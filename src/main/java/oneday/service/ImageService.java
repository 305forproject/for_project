package oneday.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.Part;

import oneday.model.Image;
import oneday.repository.ImageDAO;
import oneday.util.LoggerUtil;

/**
 * 이미지 파일 처리를 담당하는 서비스 클래스
 * 파일 업로드, 저장, 검증 등의 기능을 제공
 */
public class ImageService {
	private static ImageService instance;
	private final ImageDAO imageDAO;
	private static final String UPLOAD_BASE_DIR = "uploads/images/";
	private static final String[] ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "gif"};
	private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
	private static final Logger logger = LoggerUtil.getLogger(String.valueOf(ReservationService.class));

	private ImageService() {
		this.imageDAO = new ImageDAO();
	}

	/**
	 * ImageService 싱글톤 인스턴스를 반환
	 *
	 * @return ImageService 인스턴스
	 */
	public static synchronized ImageService getInstance() {
		if (instance == null) {
			instance = new ImageService();
		}
		return instance;
	}

	//메인 화면 슬라이드 이미지
	public List<Image> getMainSlideImages() {
		try {
			return imageDAO.findMainSlideImages();
		} catch (SQLException e) {
			logger.log(Level.SEVERE, "메인 슬라이드 이미지 조회 중 DB 오류 발생", e);
			return new ArrayList<>();
		}
	}

	/**
	 * 업로드된 파일들을 검증하고 카테고리별로 저장
	 *
	 * @param parts 업로드된 파일 Part 목록
	 * @param representativeIndex 대표 이미지 인덱스 (0부터 시작)
	 * @param categoryId 카테고리 ID
	 * @param servletContext 서블릿 컨텍스트 (실제 경로 확인용)
	 * @return 저장된 이미지 정보 목록
	 * @throws IOException 파일 처리 중 오류 발생 시
	 * @throws IllegalArgumentException 검증 실패 시
	 */
	public List<Image> processUploadedImages(List<Part> parts, int representativeIndex,
		int categoryId, javax.servlet.ServletContext servletContext) throws IOException {
		// 이미지 개수 검증
		if (parts.size() < 1 || parts.size() > 8) {
			throw new IllegalArgumentException("이미지는 최소 1개, 최대 8개까지 업로드 가능합니다.");
		}

		// 카테고리별 업로드 디렉토리 생성
		String realPath = servletContext.getRealPath("/");
		String categoryPath = String.valueOf(categoryId);
		Path categoryUploadPath = Paths.get(realPath, UPLOAD_BASE_DIR, categoryPath);
		createDirectoryIfNotExists(categoryUploadPath);

		List<Image> images = new ArrayList<>();

		for (int i = 0; i < parts.size(); i++) {
			Part part = parts.get(i);

			// 파일 검증
			validateImageFile(part);

			// 고유 파일명 생성 (원본파일명-UUID-datetime 형태)
			String originalFileName = getFileName(part);
			String uniqueFileName = generateCategoryBasedFileName(originalFileName);

			// 파일 저장
			Path filePath = categoryUploadPath.resolve(uniqueFileName);
			try {
				Files.copy(part.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
			} catch (IOException e) {
				// 이전에 저장된 파일들 삭제
				cleanupFiles(images, categoryUploadPath);
				throw new IOException("파일 저장 중 오류가 발생했습니다: " + originalFileName, e);
			}

			// Image 객체 생성 (카테고리 경로 포함)
			Image image = new Image();
			image.setImageUrl("/" + UPLOAD_BASE_DIR + categoryId + "/" + uniqueFileName);
			image.setRepresentative(i == representativeIndex);
			images.add(image);
		}

		return images;
	}

	/**
	 * 업로드된 이미지 파일을 검증
	 *
	 * @param part 업로드된 파일 Part
	 * @throws IllegalArgumentException 검증 실패 시
	 */
	private void validateImageFile(Part part) {
		// 파일 크기 검증
		if (part.getSize() > MAX_FILE_SIZE) {
			throw new IllegalArgumentException("파일 크기는 5MB를 초과할 수 없습니다.");
		}

		// 파일 확장자 검증
		String fileName = getFileName(part);
		String extension = getFileExtension(fileName);

		boolean isValidExtension = false;
		for (String allowedExt : ALLOWED_EXTENSIONS) {
			if (allowedExt.equalsIgnoreCase(extension)) {
				isValidExtension = true;
				break;
			}
		}

		if (!isValidExtension) {
			throw new IllegalArgumentException("지원하지 않는 파일 형식입니다. (jpg, jpeg, png, gif만 허용)");
		}
	}

	/**
	 * Part에서 파일명을 추출
	 *
	 * @param part 업로드된 파일 Part
	 * @return 파일명
	 */
	private String getFileName(Part part) {
		String contentDisposition = part.getHeader("content-disposition");
		String[] tokens = contentDisposition.split(";");

		for (String token : tokens) {
			if (token.trim().startsWith("filename")) {
				return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
			}
		}
		return "";
	}

	/**
	 * 파일 확장자를 추출
	 *
	 * @param fileName 파일명
	 * @return 확장자 (소문자)
	 */
	private String getFileExtension(String fileName) {
		int lastDotIndex = fileName.lastIndexOf('.');
		if (lastDotIndex == -1) {
			return "";
		}
		return fileName.substring(lastDotIndex + 1).toLowerCase();
	}

	/**
	 * 카테고리 기반 고유한 파일명을 생성
	 * 형태: 원본파일명-UUID-datetime.확장자
	 *
	 * @param originalFileName 원본 파일명
	 * @return 고유한 파일명
	 */
	private String generateCategoryBasedFileName(String originalFileName) {
		String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
		String uuid = UUID.randomUUID().toString().substring(0, 8);
		String extension = getFileExtension(originalFileName);

		// 확장자를 제거한 원본 파일명
		String nameWithoutExtension = originalFileName;
		int lastDotIndex = originalFileName.lastIndexOf('.');
		if (lastDotIndex != -1) {
			nameWithoutExtension = originalFileName.substring(0, lastDotIndex);
		}

		return nameWithoutExtension + "-" + uuid + "-" + timestamp + "." + extension;
	}

	/**
	 * 디렉토리가 존재하지 않으면 생성
	 *
	 * @param path 생성할 디렉토리 경로
	 * @throws IOException 디렉토리 생성 실패 시
	 */
	private void createDirectoryIfNotExists(Path path) throws IOException {
		if (!Files.exists(path)) {
			Files.createDirectories(path);
		}
	}

	/**
	 * 오류 발생 시 이미 저장된 파일들을 정리
	 *
	 * @param images 저장된 이미지 목록
	 * @param uploadPath 업로드 디렉토리 경로
	 */
	private void cleanupFiles(List<Image> images, Path uploadPath) {
		for (Image image : images) {
			try {
				String fileName = image.getImageUrl().substring(image.getImageUrl().lastIndexOf('/') + 1);
				Path filePath = uploadPath.resolve(fileName);
				Files.deleteIfExists(filePath);
			} catch (IOException e) {
				// 정리 중 오류는 로그만 남기고 계속 진행
				e.printStackTrace();
			}
		}
	}

	/**
	 * 트랜잭션 롤백 시 업로드된 파일들을 삭제
	 *
	 * @param images 삭제할 이미지 목록
	 * @param categoryId 카테고리 이름
	 * @param servletContext 서블릿 컨텍스트
	 */
	public void rollbackUploadedFiles(List<Image> images, int categoryId,
		javax.servlet.ServletContext servletContext) {
		String realPath = servletContext.getRealPath("/");
		Path categoryUploadPath = Paths.get(realPath, UPLOAD_BASE_DIR, String.valueOf(categoryId));
		cleanupFiles(images, categoryUploadPath);
	}
}
