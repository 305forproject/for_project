package oneday.service;

import oneday.dto.TeacherCalendarDto;
import oneday.dto.TeacherClassDetailDto;
import oneday.model.Classes;
import oneday.repository.ClassDAO;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClassService {
	private static ClassService instance;
	private final ClassDAO classDAO;

	private ClassService() {
		this.classDAO = new ClassDAO();
	}

	// 싱글톤 인스턴스
	public static synchronized ClassService getInstance() {
		if (instance == null) {
			instance = new ClassService();
		}
		return instance;
	}

	//아이디로 수업 조회
	public TeacherClassDetailDto findClassById(int classId) {
		try {
			return classDAO.findById(classId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}

	//월별 예약 조회
	public List<TeacherCalendarDto> findMyCalendarEvents(int teacherId, int year, int month) {
		try {
			return classDAO.findCalendarEventsByTeacherIdAndMonth(teacherId, year, month);
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	//예약 상세 조회
	public TeacherClassDetailDto findMyClassDetail(int classId, int teacherId) {
		try {
			return classDAO.findDetailByClassIdAndTeacherId(classId, teacherId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}
}