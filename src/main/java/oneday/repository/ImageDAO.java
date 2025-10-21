package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import oneday.model.Image;

/**
 * 이미지 정보에 대한 데이터베이스 접근을 담당하는 DAO 클래스
 * IMAGES 테이블과의 CRUD 작업을 수행
 */
public class ImageDAO {

	/**
	 * 클래스 ID에 해당하는 모든 이미지를 저장
	 *
	 * @param conn 데이터베이스 연결 객체
	 * @param classId 클래스 ID
	 * @param images 저장할 이미지 목록
	 * @return 저장 성공 시 true, 실패 시 false
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public boolean insertImages(Connection conn, int classId, List<Image> images) throws SQLException {
		String sql = "INSERT INTO IMAGES (CLASS_ID, IMAGE_URL, IS_REPRESENTATIVE) VALUES (?, ?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			for (Image image : images) {
				pstmt.setInt(1, classId);
				pstmt.setString(2, image.getImageUrl());
				pstmt.setInt(3, image.isRepresentative() ? 1 : 0);
				pstmt.addBatch();
			}

			int[] results = pstmt.executeBatch();
			return results.length == images.size();
		}
	}

	/**
	 * 클래스 ID로 해당 클래스의 모든 이미지를 조회
	 *
	 * @param classId 클래스 ID
	 * @return 해당 클래스의 이미지 목록
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public List<Image> findByClassId(int classId) throws SQLException {
		List<Image> images = new ArrayList<>();
		String sql = "SELECT IMAGE_ID, CLASS_ID, IMAGE_URL, IS_REPRESENTATIVE, IS_MAIN_SLIDE " +
			"FROM IMAGES WHERE CLASS_ID = ? AND IS_MAIN_SLIDE = 0";


		try (Connection conn = oneday.config.DatabaseConfig.getInstance().getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					Image image = new Image();
					image.setImageId(rs.getInt("IMAGE_ID"));
					image.setClassId(rs.getInt("CLASS_ID"));
					image.setImageUrl(rs.getString("IMAGE_URL"));
					image.setRepresentative(rs.getInt("IS_REPRESENTATIVE") == 1);
					images.add(image);
				}
			}
		}
		return images;
	}

	/**
	 * 클래스 ID로 대표 이미지를 조회
	 *
	 * @param classId 클래스 ID
	 * @return 대표 이미지 URL, 없으면 null
	 * @throws SQLException 데이터베이스 오류 발생 시
	 */
	public String findRepresentativeImageByClassId(int classId) throws SQLException {
		String sql = "SELECT IMAGE_URL FROM IMAGES WHERE CLASS_ID = ? AND IS_REPRESENTATIVE = 1 LIMIT 1";

		try (Connection conn = oneday.config.DatabaseConfig.getInstance().getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, classId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getString("IMAGE_URL");
				}
			}
		}
		return null;
	}

	//메인 화면에 보여줄 is_main_slide가 1인 이미지만 조회
	public List<Image> findMainSlideImages() throws SQLException {
		List<Image> slideImages = new ArrayList<>();
		String sql = "SELECT * FROM IMAGES WHERE IS_MAIN_SLIDE = 1";

		try (Connection conn = oneday.config.DatabaseConfig.getInstance().getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				Image image = new Image();
				image.setImageId(rs.getInt("IMAGE_ID"));
				image.setClassId(rs.getInt("CLASS_ID"));
				image.setImageUrl(rs.getString("IMAGE_URL"));
				image.setRepresentative(rs.getBoolean("IS_REPRESENTATIVE"));
				image.setMainSlide(rs.getBoolean("IS_MAIN_SLIDE"));
				slideImages.add(image);
			}
		}
		return slideImages;
	}
}
