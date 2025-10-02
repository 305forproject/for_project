package oneday.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import oneday.dto.ReservationCalendarDto;
import oneday.dto.ReservationDetailDto;
import oneday.dto.ReservationRequestDto;
import oneday.model.Reservation;
import oneday.repository.ReservationDAO;

public class ReservationService {
	private static ReservationService instance;
	private final ReservationDAO reservationDAO;

	public ReservationService() {
		this.reservationDAO = new ReservationDAO();
	}

	public static synchronized ReservationService getInstance() {
		if (instance == null) {
			instance = new ReservationService();
		}
		return instance;
	}

	public Reservation createReservation(ReservationRequestDto dto, int studentId) throws Exception {
		/*
		// 1. 강의 정보 조회
		Class targetClass = classDAO.findById(dto.getClassId());
		if (targetClass == null) {
			throw new Exception("존재하지 않는 강의입니다.");
		}
		*/

		// 2. 이미 예약했는지 확인
		if (reservationDAO.existsByStudentIdAndClassId(studentId, dto.getClassId())) {
			throw new Exception("이미 예약한 강의입니다.");
		}

		/*
		// 3. 정원이 다 찼는지 확인
		int currentCount = reservationDAO.countByClassId(dto.getClassId());
		if (currentCount >= targetClass.getMaxCapacity()) {
			throw new Exception("정원이 모두 마감되었습니다.");
		}
		*/

		// 4. 모든 규칙 통과 시 예약 생성
		Reservation newReservation = new Reservation();
		newReservation.setStudentId(studentId);
		newReservation.setClassId(dto.getClassId());
		newReservation.setStatusCode(1); // 1: 예약완료 상태라고 가정

		return reservationDAO.save(newReservation);
	}

	//학생 월별 예약 조회
	public List<ReservationCalendarDto> findMyReservationTimesByMonth(int studentId, int year, int month) {
		try {
			return reservationDAO.findCalendarEventsByStudentIdAndMonth(studentId, year, month);
		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>();
		}
	}

	//예약 상세정보 조회
	public ReservationDetailDto findMyReservationDetails(int reservationId, int studentId) throws SQLException {
		try {
			return reservationDAO.findReservationDetailsById(reservationId, studentId);
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
	}
}