<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/studentMypage.css">
    <script src="${pageContext.request.contextPath}/static/js/script-studentMypage.js"></script>
    <title>Student Mypage</title>
</head>
<body>
<!-- Header 영역 -->
    <header class="header">
        <div class="header-container">
            <!-- 로고 영역 -->
            <div class="logo">
                <div class="logo-img">
                    <img src="${pageContext.request.contextPath}/static/img/mainlogo.png" alt="logoimg">
                </div>
                <div class="logo-text">로고</div>
            </div>

            <!-- 모바일 메뉴 -->
            <button class="mobile-menu-toggle" aria-label="메뉴 열기" type="button">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </header>

    <!-- 메인 컨텐츠 -->
    <main class="main-content">
        <!-- 사용자 정보 표시 -->
        <% if (session.getAttribute("user") != null) { %>
        <div class="user-info">
            <h2>환영합니다, ${sessionScope.user.name} 님!</h2>
            <p>로그인 ID: ${sessionScope.user.loginId}</p>
        </div>
        <% } else { %>
        <div class="user-info">
            <h2>로그인이 필요합니다.</h2>
            <a href="${pageContext.request.contextPath}/login" class="login-link">로그인하기</a>
        </div>
        <% } %>

        <!-- 예약 현황 섹션 -->
        <section class="reservation-status">
            <h3>내 예약 현황</h3>
            <div class="reservation-tabs">
                <button class="tab-btn active" data-tab="upcoming">예정된 수업</button>
                <button class="tab-btn" data-tab="completed">완료된 수업</button>
                <button class="tab-btn" data-tab="canceled">취소된 수업</button>
            </div>
            
            <div class="reservation-list">
                <!-- 예정된 수업 -->
                <div class="tab-content active" id="upcoming">
                    <% if (request.getAttribute("upcomingReservations") != null) { %>
                        <div class="reservations-grid">
                            <!-- JavaScript로 동적 생성 또는 JSTL로 반복 처리 -->
                        </div>
                    <% } else { %>
                        <div class="no-reservations">
                            <p>예정된 수업이 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/main" class="browse-classes-btn">수업 둘러보기</a>
                        </div>
                    <% } %>
                </div>
                
                <!-- 완료된 수업 -->
                <div class="tab-content" id="completed">
                    <% if (request.getAttribute("completedReservations") != null) { %>
                        <div class="reservations-grid">
                            <!-- JavaScript로 동적 생성 또는 JSTL로 반복 처리 -->
                        </div>
                    <% } else { %>
                        <div class="no-reservations">
                            <p>완료된 수업이 없습니다.</p>
                        </div>
                    <% } %>
                </div>
                
                <!-- 취소된 수업 -->
                <div class="tab-content" id="canceled">
                    <% if (request.getAttribute("canceledReservations") != null) { %>
                        <div class="reservations-grid">
                            <!-- JavaScript로 동적 생성 또는 JSTL로 반복 처리 -->
                        </div>
                    <% } else { %>
                        <div class="no-reservations">
                            <p>취소된 수업이 없습니다.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </section>

        <!-- 통계 정보 섹션 -->
        <section class="stats-section">
            <h3>나의 수강 통계</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <h4>총 수강 횟수</h4>
                    <span class="stat-number">${totalClasses != null ? totalClasses : 0}</span>
                </div>
                <div class="stat-card">
                    <h4>이번 달 수강</h4>
                    <span class="stat-number">${monthlyClasses != null ? monthlyClasses : 0}</span>
                </div>
                <div class="stat-card">
                    <h4>좋아하는 카테고리</h4>
                    <span class="stat-text">${favoriteCategory != null ? favoriteCategory : '없음'}</span>
                </div>
            </div>
        </section>
    </main>

    <div class="reservation-calendar">
        달력
    </div>

    
    <!-- Footer 영역 -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-top">
                <!-- 로고 프레임 -->
                <div class="footer-logo-frame">
                    <div class="footer-logo">로고</div>
                    <div class="footer-info">웹사이트 정보</div>
                </div>

                <!-- 고객센터, 운영시간, 연락처 -->
                <div class="footer-contents">
                    <p>고객센터</p>
                </div>
                <div class="footer-contents">
                    <p>운영시간</p>
                    평일/주말 <br>
                    10:00 - 17:00<br>
                    (점심 : 12:00 - 13:00)
                </div>
                <div class="footer-contents">
                    <p>연락처</p>
                    010-1234-5678<br>
                    oneday@class.com
                </div>
            </div>

            <hr>

            <div class="footer-down">
                <!-- 이용약관, 사업자 정보 -->
                <div class="footer-contents">
                    <P>사업자 정보</P>
                    사업자 등록번호: 123-45-67890<br>
                    대표자: 홍길동<br>
                    주소: 서울특별시 강남구 테헤란로 123, 45
                </div>

                <div class="footer-contents">
                    <P>이용약관</P>
                    개인정보처리방침
                </div>
            </div>
        </div>
    </footer>

    <!-- 모바일 메뉴 모달 -->
    <div id="mobileMenuModal" class="mobile-menu-modal">
        <div class="mobile-menu-modal-content">
            <div class="mobile-menu-header">
                <h2>원데이클래스</h2>
                <button id="closeMobileMenu" class="close">></button>
            </div>
            
            <!-- 모바일 메뉴 버튼들 -->
            <div class="mobile-menu-buttons">
                <a href="${pageContext.request.contextPath}/main" class="mobile-menu-btn">홈으로</a>
                <% if (session.getAttribute("user") != null) { %>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-menu-btn">로그아웃</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="mobile-menu-btn">로그인</a>
                <% } %>
            </div>
            
            <!-- 빈 컨텐츠 영역 -->
            <div class="mobile-menu-empty">
                <p>더 많은 메뉴가 곧 추가될 예정입니다.</p>
            </div>
        </div>
    </div>
</body>
</html>