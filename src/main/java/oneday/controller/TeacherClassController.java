package oneday.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import oneday.dto.ClassRegisterDto;
import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.repository.CategoryDAO;
import oneday.service.ClassService;

/**
 * 강사의 클래스 관리를 담당하는 컨트롤러
 * 클래스 등록, 조회, 달력 보기 등의 기능을 제공
 */
@WebServlet("/teachers/classes/*")
@MultipartConfig(
	fileSizeThreshold = 1024 * 1024 * 2, // 2MB
	maxFileSize = 1024 * 1024 * 5,       // 5MB
	maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class TeacherClassController extends HttpServlet {

	private final ClassService classService = ClassService.getInstance();
	private final CategoryDAO categoryDAO = new CategoryDAO();

	/**
	 * GET 요청을 처리하는 메서드
	 * 달력 조회, 등록 폼 페이지, 클래스 상세 조회를 담당
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		String pathInfo = request.getPathInfo();

		// 권한 검증
		if (!validateTeacherPermission(request, response)) {
			return;
		}

		Integer teacherId = (Integer)request.getSession().getAttribute("userId");

		// 1. 달력 조회: /teachers/classes?year=...&month=...
		if (pathInfo == null || pathInfo.equals("/")) {
			handleCalendarView(request, response, teacherId);
		}
		// 2. 등록 폼 페이지: /teachers/classes/register
		else if (pathInfo.equals("/register")) {
			handleRegisterView(request, response);
		}
		// 3. 상세 정보 조회: /teachers/classes/{classId}
		else {
			handleDetailView(request, response, teacherId, pathInfo);
		}
	}

	/**
	 * POST 요청을 처리하는 메서드
	 * 클래스 등록 처리를 담당
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		String pathInfo = request.getPathInfo();

		// 권한 검증
		if (!validateTeacherPermission(request, response)) {
			return;
		}

		Integer teacherId = (Integer)request.getSession().getAttribute("userId");

		// 클래스 등록 처리: /teachers/classes/register
		if (pathInfo != null && pathInfo.equals("/register")) {
			handleRegisterProcess(request, response, teacherId);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "지원하지 않는 요청입니다.");
		}
	}

	/**
	 * 강사 권한을 검증하는 메서드
	 * 로그인 상태와 강사 권한을 확인
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @return 권한이 유효하면 true, 그렇지 않으면 false
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	private boolean validateTeacherPermission(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		Integer teacherId = (Integer)request.getSession().getAttribute("userId");
		Boolean isTeacher = (Boolean)request.getSession().getAttribute("isTeacher");

		if (teacherId == null) {
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
			return false;
		}

		if (!Boolean.TRUE.equals(isTeacher)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "강사 권한이 필요합니다.");
			return false;
		}

		return true;
	}

	/**
	 * 강사의 월별 클래스 달력을 조회하고 표시
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @param teacherId 강사 ID
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	private void handleCalendarView(HttpServletRequest request, HttpServletResponse response, int teacherId) throws
		ServletException,
		IOException {
		String yearParam = request.getParameter("year");
		String monthParam = request.getParameter("month");

		if (yearParam != null && monthParam != null) {
			int year = Integer.parseInt(yearParam);
			int month = Integer.parseInt(monthParam);

			List<TeacherCalendarDto> events = classService.findMyCalendarEvents(teacherId, year, month);
			request.setAttribute("calendarEvents", events);
			request.getRequestDispatcher("/WEB-INF/views/teacherCalendar.jsp").forward(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "year와 month 가 필요합니다.");
		}
	}

	/**
	 * 클래스 등록 폼 페이지를 표시
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	private void handleRegisterView(HttpServletRequest request, HttpServletResponse response) throws
		ServletException,
		IOException {
		// 등록 폼 페이지로 이동
		request.getRequestDispatcher("/WEB-INF/views/teacherClassRegister.jsp").forward(request, response);
	}

	/**
	 * 클래스 등록 요청을 처리
	 * 폼 데이터를 받아서 클래스를 등록하고 결과에 따라 응답
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @param teacherId 강사 ID
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	private void handleRegisterProcess(HttpServletRequest request, HttpServletResponse response, int teacherId) throws
		ServletException,
		IOException {
		try {
			// 폼 데이터를 DTO로 변환
			ClassRegisterDto registerDto = new ClassRegisterDto();
			registerDto.setClassName(request.getParameter("className"));
			registerDto.setDescription(request.getParameter("description"));
			registerDto.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
			registerDto.setClassDate(request.getParameter("classDate"));
			registerDto.setStartTime(request.getParameter("startTime"));
			registerDto.setEndTime(request.getParameter("endTime"));
			registerDto.setMaxStudents(Integer.parseInt(request.getParameter("maxStudents")));
			registerDto.setPrice(Integer.parseInt(request.getParameter("price")));
			registerDto.setLocation(request.getParameter("location"));
			registerDto.setZipcode(request.getParameter("zipcode"));
			registerDto.setLatitude(request.getParameter("latitude"));
			registerDto.setLongitude(request.getParameter("longitude"));

			// 대표 이미지 인덱스 가져오기
			int representativeIndex = Integer.parseInt(request.getParameter("representativeIndex"));

			// 업로드된 이미지 파일들 가져오기
			Collection<Part> parts = request.getParts();
			List<Part> imageParts = new ArrayList<>();

			for (Part part : parts) {
				if ("images".equals(part.getName()) && part.getSize() > 0) {
					imageParts.add(part);
				}
			}

			// 이미지가 없으면 에러
			if (imageParts.isEmpty()) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "최소 1개의 이미지는 필수입니다.");
				return;
			}

			// 카테고리명 가져오기
			String categoryName = getCategoryNameById(registerDto.getCategoryId());

			// 클래스 등록 처리 (이미지 포함)
			boolean success = classService.registerClassWithImages(
				registerDto, teacherId, imageParts, representativeIndex,
				categoryName, getServletContext()
			);

			if (success) {
				// 등록된 클래스의 날짜를 기준으로 년월 추출
				String classDate = request.getParameter("classDate"); // yyyy-MM-dd 형식
				String[] dateParts = classDate.split("-");
				int year = Integer.parseInt(dateParts[0]);
				int month = Integer.parseInt(dateParts[1]);

				// 등록 성공 시 해당 년월의 달력 페이지로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/teachers/classes?year=" + year + "&month=" + month);
			} else {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "클래스 등록에 실패했습니다.");
			}

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 입력 형식입니다.");
		} catch (Exception e) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "클래스 등록 중 오류가 발생했습니다.");
		}
	}

	/**
	 * 카테고리 ID로 카테고리명을 반환
	 * 데이터베이스에서 동적으로 조회하여 유연한 처리 제공
	 *
	 * @param categoryId 카테고리 ID
	 * @return 카테고리명
	 */
	private String getCategoryNameById(int categoryId) {
		return categoryDAO.findCategoryNameById(categoryId);
	}

	/**
	 * 클래스 상세 정보를 조회하고 표시
	 *
	 * @param request HTTP 요청 객체
	 * @param response HTTP 응답 객체
	 * @param teacherId 강사 ID
	 * @param pathInfo 요청 경로 정보 (클래스 ID 포함)
	 * @throws ServletException 서블릿 처리 중 오류 발생 시
	 * @throws IOException 입출력 오류 발생 시
	 */
	private void handleDetailView(HttpServletRequest request, HttpServletResponse response, int teacherId,
		String pathInfo) throws ServletException, IOException {
		try {
			int classId = Integer.parseInt(pathInfo.substring(1));

			TeacherClassDetailDto detail = classService.findMyClassDetail(classId, teacherId);
			request.setAttribute("classDetail", detail);
			request.getRequestDispatcher("/WEB-INF/views/teacherClassDetail.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 강의 ID 형식입니다.");
		}
	}
}