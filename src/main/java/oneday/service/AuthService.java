package oneday.service;

import java.sql.SQLException;

import oneday.model.User;
import oneday.repository.UserDAO;

/**
 * 사용자 인증 및 사용자 정보 관리 서비스 클래스
 *
 * <p>이 클래스는 로그인 인증과 사용자 정보 조회를 위한 비즈니스 로직을 제공합니다.
 * UserDAO를 통해 데이터베이스에 접근하며, 예외 처리를 담당합니다.</p>
 *
 * <p>주요 기능:</p>
 * <ul>
 *   <li>로그인 인증 처리</li>
 *   <li>사용자 ID를 통한 사용자 정보 조회</li>
 *   <li>데이터베이스 접근 예외 처리</li>
 * </ul>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class AuthService {
	/** 사용자 데이터 접근을 위한 DAO 인스턴스 */
	private UserDAO userDAO = new UserDAO();

	/**
	 * 사용자 로그인을 인증합니다.
	 *
	 * <p>주어진 로그인 ID와 비밀번호를 통해 사용자를 인증합니다.
	 * 데이터베이스 접근 중 발생하는 예외를 처리하고,
	 * 인증 실패 시 null을 반환합니다.</p>
	 *
	 * @param loginId 사용자의 로그인 ID
	 * @param password 사용자의 비밀번호
	 * @return 인증된 사용자 객체, 인증 실패 또는 오류 시 null
	 */
	public User authenticate(String loginId, String password) {
		try {
			return userDAO.findByLoginIdAndPassword(loginId, password);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 사용자 ID로 사용자 정보를 조회합니다.
	 *
	 * <p>세션에 저장된 사용자 ID를 통해 사용자의 전체 정보를 조회할 때 사용됩니다.
	 * 데이터베이스 접근 중 발생하는 예외를 처리합니다.</p>
	 *
	 * @param userId 조회할 사용자의 고유 ID
	 * @return 사용자 객체, 조회 실패 또는 오류 시 null
	 */
	public User getUserById(int userId) {
		try {
			return userDAO.findById(userId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}
}
