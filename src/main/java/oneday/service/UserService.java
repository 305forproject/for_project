package oneday.service;

import oneday.dao.UserDAO;
import oneday.model.User;
import oneday.model.Role;
import java.sql.SQLException;

/**
 * 사용자 관련 비즈니스 로직을 처리하는 서비스 클래스
 *
 * <p>Spring 전환 시 @Service 어노테이션을 추가하여 서비스 빈으로 등록됩니다.
 * 현재는 싱글톤 패턴으로 구현되어 있습니다.</p>
 *
 * <p>책임:</p>
 * <ul>
 *   <li>회원가입 비즈니스 로직 처리</li>
 *   <li>아이디 중복 검사</li>
 *   <li>트랜잭션 관리 (Spring 전환 시 @Transactional)</li>
 * </ul>
 *
 * @author Oneday Team
 * @version 1.0
 * @since 2024
 */
public class UserService {

    private static UserService instance;
    private final UserDAO userDAO;

    /**
     * private 생성자 - 싱글톤 패턴
     */
    private UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * 싱글톤 인스턴스 반환
     *
     * <p>Spring 전환 시 이 메서드는 제거되고
     * DI(Dependency Injection)로 대체됩니다.</p>
     *
     * @return UserService 싱글톤 인스턴스
     */
    public static synchronized UserService getInstance() {
        if (instance == null) {
            instance = new UserService();
        }
        return instance;
    }

    /**
     * 회원가입 처리
     *
     * <p>Spring 전환 시 @Transactional 어노테이션이 추가됩니다.</p>
     *
     * @param loginId 로그인 아이디
     * @param password 비밀번호
     * @param name 사용자 이름
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException DB 오류 발생 시
     * @throws IllegalArgumentException 아이디가 이미 존재하는 경우
     */
    public boolean signup(String loginId, String password, String name) throws SQLException {
        // 아이디 중복 검사
        if (userDAO.isLoginIdExists(loginId)) {
            throw new IllegalArgumentException("이미 사용중인 아이디입니다.");
        }

        // User 객체 생성 및 회원가입 처리
        User user = new User(loginId, password, name);
        return userDAO.signup(user);
    }

    /**
     * 특정 역할로 회원가입 처리
     *
     * @param loginId 로그인 아이디
     * @param password 비밀번호
     * @param name 사용자 이름
     * @param role 사용자 역할
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException DB 오류 발생 시
     * @throws IllegalArgumentException 아이디가 이미 존재하는 경우
     */
    public boolean signupWithRole(String loginId, String password, String name, Role role) throws SQLException {
        // 아이디 중복 검사
        if (userDAO.isLoginIdExists(loginId)) {
            throw new IllegalArgumentException("이미 사용중인 아이디입니다.");
        }

        // User 객체 생성 및 회원가입 처리
        User user = new User(loginId, password, name);
        return userDAO.signupWithRole(user, role);
    }

    /**
     * 아이디 중복 확인
     *
     * @param loginId 확인할 아이디
     * @return 중복이면 true, 아니면 false
     * @throws SQLException DB 오류 발생 시
     */
    public boolean isLoginIdExists(String loginId) throws SQLException {
        return userDAO.isLoginIdExists(loginId);
    }
}
