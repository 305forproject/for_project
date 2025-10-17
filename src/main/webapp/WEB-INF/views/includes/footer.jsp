<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 
    공통 푸터 파일
    모든 페이지에서 include하여 사용
-->

<!-- Footer 영역 -->
<footer class="footer">
    <div class="footer-container">
        <!-- 상단 영역 -->
        <div class="footer-top">
            <!-- 로고 및 소개 -->
            <div class="footer-logo-frame">
                <div class="footer-logo">원데이클래스</div>
                <div class="footer-info">
                    나만의 특별한 원데이 클래스를 찾아보세요.<br>
                    다양한 강의와 전문 강사들이 여러분을 기다립니다.
                </div>
            </div>

            <!-- 고객센터 -->
            <div class="footer-contents">
                <p>고객센터</p>
                <div>
                    평일/주말<br>
                    10:00 - 17:00<br>
                    (점심시간: 12:00 - 13:00)
                </div>
            </div>

            <!-- 연락처 -->
            <div class="footer-contents">
                <p>연락처</p>
                <div>
                    Tel: 010-1234-5678<br>
                    Email: oneday@class.com
                </div>
            </div>
        </div>

        <hr>

        <!-- 하단 영역 -->
        <div class="footer-down">
            <!-- 사업자 정보 -->
            <div class="footer-contents">
                <p>사업자 정보</p>
                <div>
                    사업자 등록번호: 123-45-67890<br>
                    대표자: 홍길동<br>
                    주소: 서울특별시 강남구 테헤란로 123, 4층
                </div>
            </div>

            <!-- 이용약관 -->
            <div class="footer-contents">
                <p>이용약관</p>
                <div>
                    <a href="#" style="text-decoration: underline;">개인정보처리방침</a><br>
                    <a href="#" style="text-decoration: underline;">이용약관</a>
                </div>
            </div>
        </div>

        <!-- 저작권 -->
        <div style="text-align: center; margin-top: 32px; padding-top: 24px; border-top: 1px solid var(--border-color); color: var(--text-muted); font-size: 14px;">
            © 2024 원데이클래스. All rights reserved.
        </div>
    </div>
</footer>

<!-- 공통 JavaScript (필요한 경우) -->
<script src="${pageContext.request.contextPath}/static/js/auth.js"></script>
<script src="${pageContext.request.contextPath}/static/js/utils.js"></script>
