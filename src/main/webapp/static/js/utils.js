/**
 * 공통 유틸리티 함수들
 */

/**
 * 쿠키 값 가져오기 함수
 * @param {string} name - 쿠키 이름
 * @returns {string|null} 쿠키 값 또는 null
 */
function getCookie(name) {
    const value = "; " + document.cookie;
    const parts = value.split("; " + name + "=");
    if (parts.length === 2) {
        const cookieValue = parts.pop().split(";").shift();
        return decodeURIComponent(cookieValue);
    }
    return null;
}

/**
 * 쿠키 설정 함수
 * @param {string} name - 쿠키 이름
 * @param {string} value - 쿠키 값
 * @param {number} days - 만료일 (일)
 */
function setCookie(name, value, days) {
    let expires = "";
    if (days) {
        const date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + encodeURIComponent(value) + expires + "; path=/";
}

/**
 * 로그인 상태 확인 함수
 * @returns {boolean} 로그인 여부
 */
function isLoggedIn() {
    const userId = getCookie('userId');
    return !!(userId &&
        userId !== 'null' &&
        userId !== '' &&
        userId !== 'undefined' &&
        userId.trim() !== '');
}

/**
 * 강사 여부 확인 함수
 * @returns {boolean} 강사 여부
 */
function isTeacher() {
    const isTeacherCookie = getCookie('isTeacher');
    return !!(isTeacherCookie &&
        isTeacherCookie !== 'false' &&
        isTeacherCookie !== 'null' &&
        isTeacherCookie !== 'undefined');
}

/**
 * 학생 여부 확인 함수
 * @returns {boolean} 학생 여부
 */
function isStudent() {
    const isStudentCookie = getCookie('isStudent');
    return !!(isStudentCookie &&
        isStudentCookie !== 'false' &&
        isStudentCookie !== 'null' &&
        isStudentCookie !== 'undefined');
}
