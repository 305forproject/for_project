package oneday.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import oneday.config.DatabaseConfig;
import oneday.model.Category;

/**
 * 카테고리 관련 데이터베이스 접근 객체 (DAO)
 * 카테고리 정보 조회 기능을 제공
 */
public class CategoryDAO {
	private final DatabaseConfig dbConfig;

	/**
	 * CategoryDAO 생성자
	 * DatabaseConfig 싱글톤 인스턴스를 초기화
	 */
	public CategoryDAO() {
		this.dbConfig = DatabaseConfig.getInstance();
	}

	/**
	 * 모든 카테고리 목록을 조회
	 *
	 * @return 카테고리 목록
	 */
	public List<Category> findAll() {
		List<Category> categories = new ArrayList<>();
		String sql = "SELECT CATEGORY_ID, CATEGORY FROM CATEGORIES ORDER BY CATEGORY_ID";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				Category category = new Category();
				category.setCategoryId(rs.getInt("CATEGORY_ID"));
				category.setCategory(rs.getString("CATEGORY"));
				categories.add(category);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return categories;
	}

	/**
	 * 카테고리 ID로 카테고리명을 조회
	 *
	 * @param categoryId 조회할 카테고리 ID
	 * @return 카테고리명, 조회 실패 시 "기타" 반환
	 */
	public String findCategoryNameById(int categoryId) {
		String sql = "SELECT CATEGORY FROM CATEGORIES WHERE CATEGORY_ID = ?";

		try (Connection conn = dbConfig.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, categoryId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getString("CATEGORY");
				}
			}
		} catch (SQLException e) {
			// 데이터베이스 오류 발생 시 기본값 반환
			e.printStackTrace();
		}

		return "기타"; // 기본값
	}
}
