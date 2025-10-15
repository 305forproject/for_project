package oneday.service;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.Part;

import oneday.dto.ClassDetailDto;
import oneday.dto.ClassListDto;
import oneday.dto.ClassRegisterDto;
import oneday.dto.CoordinateDto;
import oneday.dto.FullCalendarEventDto;
import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.model.Category;
import oneday.model.Classes;
import oneday.model.Image;
import oneday.repository.ClassDAO;
import oneday.repository.ImageDAO;
import oneday.util.LoggerUtil;

/**
 * 클래스 관련 비즈니스 로직을 처리하는 서비스 클래스
 * 싱글톤 패턴을 사용하여 인스턴스를 관리
 */
public class ClassService {
	private static ClassService instance;
	private final ClassDAO classDAO;
	private final ImageService imageService;
	private final ImageDAO imageDAO;
	private static final Logger logger = LoggerUtil.getLogger(String.valueOf(ReservationService.class));

	/**
	 * ClassService 생성자 (private)
	 * 싱글톤 패턴을 위해 외부에서 직접 생성 불가
	 */
	private ClassService() {
		this.classDAO = new ClassDAO();
		this.imageService = ImageService.getInstance();
		this.imageDAO = new ImageDAO();
	}

	/**
	 * ClassService 싱글톤 인스턴스를 반환
	 *
	 * @return ClassService 인스턴스
	 */
	public static synchronized ClassService getInstance() {
		if (instance == null) {
			instance = new ClassService();
		}
		return instance;
	}

	/**
	 * 강사의 월별 클래스 일정을 조회
	 *
	 * @param teacherId 강사 ID
	 * @param year 조회할 년도
	 * @param month 조회할 월
	 * @return 해당 년월의 클래스 일정 목록, 조회 실패 시 빈 목록
	 */
	public List<TeacherCalendarDto> findMyCalendarEvents(int teacherId, int year, int month) {
		try {
			return classDAO.findCalendarEventsByTeacherIdAndMonth(teacherId, year, month);
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	public List<FullCalendarEventDto> findMyCalendarEventsByDateRange(int teacherId, String startDate, String endDate) {
		try {
			return classDAO.findEventsForCalendarByTeacher(teacherId, startDate, endDate);
		} catch (SQLException e) {
			// Logger를 사용한 에러 처리
			// logger.log(Level.SEVERE, "강사 캘린더 이벤트 조회 중 DB 오류", e);
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	/**
	 * 강사 본인의 클래스 상세 정보를 조회
	 *
	 * @param classId 조회할 클래스 ID
	 * @return 클래스 상세 정보, 조회 실패 시 null
	 */
	public TeacherClassDetailDto findMyClassDetail(int classId) {
		try {
			return classDAO.findDetailByClassIdAndTeacherId(classId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	//클래스 상세 정보 조회
	public ClassDetailDto findClassDetail(int classId) {
		try {
			//클래스 상세 정보 조회
			ClassDetailDto detail = classDAO.findDetailById(classId);

			if (detail != null) {
				//해당 클래스 이미지 목록 조회
				List<Image> images = imageDAO.findByClassId(classId);

				//
				detail.setImages(images);
			}
			return detail;

		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 새로운 클래스를 등록
	 * ClassRegisterDto를 Classes 엔티티로 변환하여 데이터베이스에 저장
	 *
	 * @param registerDto 등록할 클래스 정보가 담긴 DTO
	 * @param teacherId 강사 ID
	 * @return 등록 성공 시 true, 실패 시 false
	 */
	public boolean registerClass(ClassRegisterDto registerDto, int teacherId) {
		try {
			// DTO를 Classes 엔티티로 변환
			Classes classes = new Classes();
			classes.setTeacherId(teacherId);
			classes.setClassName(registerDto.getClassName());
			classes.setClassDetail(registerDto.getDescription());
			classes.setCategoryId(registerDto.getCategoryId());

			// 날짜와 시간을 LocalDateTime으로 변환
			String startDateTimeStr = registerDto.getClassDate() + " " + registerDto.getStartTime();
			String endDateTimeStr = registerDto.getClassDate() + " " + registerDto.getEndTime();
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

			classes.setStartAt(LocalDateTime.parse(startDateTimeStr, formatter));
			classes.setEndAt(LocalDateTime.parse(endDateTimeStr, formatter));
			classes.setMaxCapacity(registerDto.getMaxStudents());
			classes.setPrice(registerDto.getPrice());
			classes.setLocation(registerDto.getLocation());

			return classDAO.insertClass(classes);
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 이미지를 포함하여 새로운 클래스를 등록
	 * DatabaseTransactionUtil을 사용하여 트랜잭션 처리
	 *
	 * @param registerDto 등록할 클래스 정보
	 * @param teacherId 강사 ID
	 * @param imageParts 업로드된 이미지 파일들
	 * @param representativeIndex 대표 이미지 인덱스
	 * @param categoryName 카테고리 이름 (이미지 저장 폴더명)
	 * @param servletContext 서블릿 컨텍스트
	 * @return 등록 성공 시 true, 실패 시 false
	 */
	public boolean registerClassWithImages(ClassRegisterDto registerDto, int teacherId,
		List<Part> imageParts, int representativeIndex,
		String categoryName, javax.servlet.ServletContext servletContext) {

		List<Image> uploadedImages = null;

		try {
			// 주소로부터 좌표 자동 변환
			if ((registerDto.getLatitude() == null || registerDto.getLatitude().isEmpty()) &&
				registerDto.getLocation() != null && !registerDto.getLocation().isEmpty()) {
				CoordinateDto coordinates =
					KakaoMapService.getInstance().getCoordinatesFromAddress(registerDto.getLocation());
				if (coordinates != null) {
					registerDto.setLatitude(coordinates.latitude());
					registerDto.setLongitude(coordinates.longitude());
				}
			}

			// 이미지 파일 처리 (카테고리별 폴더에 저장)
			uploadedImages = imageService.processUploadedImages(imageParts, representativeIndex,
				categoryName, servletContext);

			// 데이터베이스 트랜잭션 실행
			final List<Image> finalUploadedImages = uploadedImages;
			return oneday.util.DatabaseTransactionUtil.executeTransactionForBoolean(conn -> {
				try {
					// 클래스 등록
					Classes classes = convertDtoToEntity(registerDto, teacherId);
					int classId = classDAO.insertClassAndGetId(conn, classes);

					if (classId <= 0) {
						return false;
					}

					// 이미지 정보 저장
					for (Image image : finalUploadedImages) {
						image.setClassId(classId);
					}

					return imageDAO.insertImages(conn, classId, finalUploadedImages);

				} catch (SQLException e) {
					throw new RuntimeException("클래스 등록 중 데이터베이스 오류", e);
				}
			});

		} catch (Exception e) {
			// 트랜잭션 실패 시 업로드된 파일들 삭제
			if (uploadedImages != null) {
				imageService.rollbackUploadedFiles(uploadedImages, categoryName, servletContext);
			}
			return false;
		}
	}

	/**
	 * DTO를 Classes 엔티티로 변환
	 */
	private Classes convertDtoToEntity(ClassRegisterDto registerDto, int teacherId) {
		Classes classes = new Classes();
		classes.setTeacherId(teacherId);
		classes.setClassName(registerDto.getClassName());
		classes.setClassDetail(registerDto.getDescription());
		classes.setCategoryId(registerDto.getCategoryId());

		String startDateTimeStr = registerDto.getClassDate() + " " + registerDto.getStartTime();
		String endDateTimeStr = registerDto.getClassDate() + " " + registerDto.getEndTime();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

		classes.setStartAt(LocalDateTime.parse(startDateTimeStr, formatter));
		classes.setEndAt(LocalDateTime.parse(endDateTimeStr, formatter));
		classes.setMaxCapacity(registerDto.getMaxStudents());
		classes.setPrice(registerDto.getPrice());
		classes.setLocation(registerDto.getLocation());
		classes.setZipcode(registerDto.getZipcode());
		classes.setLatitude(registerDto.getLatitude());
		classes.setLongitude(registerDto.getLongitude());

		return classes;
	}

	/**
	 * 모든 강의 목록을 최신순으로 조회
	 *
	 * @return sort option으로 정렬된 강의 목록
	 */
	public List<ClassListDto> getClassList(String sortOption, Integer categoryId) {
		try {
			return classDAO.findAllClasses(sortOption, categoryId);
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	//모든 카테고리 조회
	public List<Category> getAllCategories() {
		try {
			return classDAO.findAllCategories();
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}
}
