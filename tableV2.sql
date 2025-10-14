SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER_SET_CLIENT = utf8mb4;
SET CHARACTER_SET_CONNECTION = utf8mb4;
SET CHARACTER_SET_RESULTS = utf8mb4;

-- =================================================================
-- 기존 테이블 삭제 (초기화)
-- =================================================================
-- 외래 키 제약 조건 때문에 참조하는 테이블부터 역순으로 삭제해야 합니다.
DROP TABLE IF EXISTS `PAYMENTS`;
DROP TABLE IF EXISTS `IMAGES`;
DROP TABLE IF EXISTS `RESERVATIONS`;
DROP TABLE IF EXISTS `RESERVE_STATUSES`;
DROP TABLE IF EXISTS `USER_ROLE`;
DROP TABLE IF EXISTS `CLASSES`;
DROP TABLE IF EXISTS `CATEGORIES`;
DROP TABLE IF EXISTS `USERS`;
DROP TABLE IF EXISTS `ROLES`;

-- =================================================================
-- ROLES, USERS, USER_ROLE 테이블 (제공된 코드 기반)
-- =================================================================

-- ROLES 테이블 생성
CREATE TABLE `ROLES` (
                         `ROLE_ID` INT NOT NULL AUTO_INCREMENT,
                         `ROLE_NAME` VARCHAR(20) NOT NULL,
                         PRIMARY KEY (`ROLE_ID`),
                         UNIQUE KEY `UK_ROLE_NAME` (`ROLE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- USERS 테이블 생성
CREATE TABLE `USERS` (
                         `USER_ID` INT NOT NULL AUTO_INCREMENT,
                         `LOGIN_ID` VARCHAR(20) NOT NULL,
                         `PASSWORD` VARCHAR(255) NOT NULL, -- 비밀번호는 암호화(해싱) 저장을 위해 길이를 넉넉하게 설정하는 것을 권장합니다.
                         `NAME` VARCHAR(20) NOT NULL,
                         `ACCOUNT` VARCHAR(20) NULL,
                         PRIMARY KEY (`USER_ID`),
                         UNIQUE KEY `UK_LOGIN_ID` (`LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- USER_ROLE 테이블 생성 (다대다 관계 매핑)
CREATE TABLE `USER_ROLE` (
                             `USER_ID` INT NOT NULL,
                             `ROLE_ID` INT NOT NULL,
                             PRIMARY KEY (`USER_ID`, `ROLE_ID`),
                             CONSTRAINT `FK_USER_ROLE_TO_USERS` FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                             CONSTRAINT `FK_USER_ROLE_TO_ROLES` FOREIGN KEY (`ROLE_ID`) REFERENCES `ROLES` (`ROLE_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 인덱스 추가 (성능 최적화)
CREATE INDEX `IDX_USER_ROLE_ROLE_ID` ON `USER_ROLE` (`ROLE_ID`);

-- =================================================================
-- 나머지 테이블 생성
-- =================================================================

-- CATEGORIES 테이블 생성
CREATE TABLE `CATEGORIES` (
                              `CATEGORY_ID` INT NOT NULL AUTO_INCREMENT,
                              `CATEGORY` VARCHAR(100) NOT NULL,
                              PRIMARY KEY (`CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CLASSES 테이블 생성 (우편번호 컬럼 추가)
CREATE TABLE `CLASSES` (
                           `CLASS_ID` INT NOT NULL AUTO_INCREMENT,
                           `TEACHER_ID` INT NOT NULL,
                           `CATEGORY_ID` INT NOT NULL,
                           `CLASS_NAME` VARCHAR(50) NOT NULL,
                           `CLASS_DETAIL` TEXT NULL, -- 긴 설명이 들어갈 수 있으므로 VARCHAR(255) 대신 TEXT 타입을 고려
                           `START_AT` DATETIME NOT NULL,
                           `END_AT` DATETIME NOT NULL,
                           `LONGITUDE` VARCHAR(20) NULL,
                           `LATITUDE` VARCHAR(20) NULL,
                           `LOCATION` VARCHAR(255) NULL,
                           `ZIPCODE` VARCHAR(10) NULL,
                           `MAX_CAPACITY` INT UNSIGNED NULL, -- 정원 수는 음수가 될 수 없으므로 UNSIGNED 옵션 추가
                           `PRICE` INT UNSIGNED NOT NULL DEFAULT 0, -- 가격은 음수가 될 수 없으므로 UNSIGNED 옵션 추가
                           PRIMARY KEY (`CLASS_ID`),
                           CONSTRAINT `FK_CLASSES_TO_USERS` FOREIGN KEY (`TEACHER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                           CONSTRAINT `FK_CLASSES_TO_CATEGORIES` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `CATEGORIES` (`CATEGORY_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- IMAGES 테이블 생성
CREATE TABLE `IMAGES` (
                          `IMAGE_ID` INT NOT NULL AUTO_INCREMENT,
                          `CLASS_ID` INT NOT NULL,
                          `IMAGE_URL` VARCHAR(255) NOT NULL,
                          `IS_REPRESENTATIVE` TINYINT(1) NOT NULL DEFAULT 0,
                          `IS_MAIN_SLIDE` TINYINT(1) NOT NULL DEFAULT 0,
                          PRIMARY KEY (`IMAGE_ID`),
                          CONSTRAINT `FK_IMAGES_TO_CLASSES` FOREIGN KEY (`CLASS_ID`) REFERENCES `CLASSES` (`CLASS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RESERVE_STATUSES 테이블 생성
CREATE TABLE `RESERVE_STATUSES` (
                                    `STATUS_CODE` INT NOT NULL,
                                    `STATUS_NAME` VARCHAR(40) NOT NULL,
                                    PRIMARY KEY (`STATUS_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RESERVATIONS 테이블 생성
CREATE TABLE `RESERVATIONS` (
                                `RESERVATION_ID` INT NOT NULL AUTO_INCREMENT,
                                `CLASS_ID` INT NOT NULL,
                                `STUDENT_ID` INT NOT NULL,
                                `STATUS_CODE` INT NOT NULL,
                                PRIMARY KEY (`RESERVATION_ID`),
                                CONSTRAINT `FK_RESERVATIONS_TO_CLASSES` FOREIGN KEY (`CLASS_ID`) REFERENCES `CLASSES` (`CLASS_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                                CONSTRAINT `FK_RESERVATIONS_TO_USERS` FOREIGN KEY (`STUDENT_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                                CONSTRAINT `FK_RESERVATIONS_TO_STATUSES` FOREIGN KEY (`STATUS_CODE`) REFERENCES `RESERVE_STATUSES` (`STATUS_CODE`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PAYMENTS 테이블 생성
CREATE TABLE `PAYMENTS` (
                            `PAYMENT_ID` INT NOT NULL AUTO_INCREMENT,
                            `RESERVATION_ID` INT NOT NULL,
                            `TOSS_ORDER_ID` VARCHAR(255) NULL,
                            `TOSS_PAYMENT_KEY` VARCHAR(255) NULL,
                            `TOSS_PAYMENT_METHOD` VARCHAR(50) NULL,
                            `TOSS_PAYMENT_STATUS` VARCHAR(50) NULL,
                            `REQUESTED_AT` DATETIME NULL,
                            `APPROVED_AT` DATETIME NULL,
                            `TOTAL_AMOUNT` INT UNSIGNED NULL, -- 결제 금액은 음수가 될 수 없으므로 UNSIGNED 옵션 추가
                            PRIMARY KEY (`PAYMENT_ID`),
                            UNIQUE KEY `UK_RESERVATION_ID` (`RESERVATION_ID`), -- 하나의 예약에는 하나의 결제만 존재
                            UNIQUE KEY `UK_TOSS_ORDER_ID` (`TOSS_ORDER_ID`),
                            CONSTRAINT `FK_PAYMENTS_TO_RESERVATIONS` FOREIGN KEY (`RESERVATION_ID`) REFERENCES `RESERVATIONS` (`RESERVATION_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =================================================================
-- 기본 데이터 삽입
-- =================================================================

-- 기본 역할 데이터 삽입
INSERT INTO `ROLES` (`ROLE_ID`, `ROLE_NAME`) VALUES (1, 'TEACHER'), (2, 'STUDENT');

-- 기본 예약 상태 데이터 삽입
INSERT INTO `RESERVE_STATUSES` (`STATUS_CODE`, `STATUS_NAME`) VALUES
                                                                  (1, '예약 완료'),
                                                                  (2, '결제 대기'),
                                                                  (3, '예약 취소'),
                                                                  (4, '수업 완료');


-- =================================================================
-- 테스트 데이터 삽입
-- 외래 키 제약 조건에 따라 순서대로 삽입해야 합니다.
-- =================================================================

-- 1. USERS: 선생님 2명, 학생 3명 생성
-- 비밀번호는 실제 환경에서는 반드시 해싱하여 저장해야 합니다. (예: 'password123' -> '$2a$10$...')
INSERT INTO `USERS` (`LOGIN_ID`, `PASSWORD`, `NAME`, `ACCOUNT`) VALUES
                                                                    ('teacher1', 'pass123', '김선생', '111-111-111111'),
                                                                    ('teacher2', 'pass123', '박교사', '222-222-222222'),
                                                                    ('student1', 'pass123', '이학생', '333-333-333333'),
                                                                    ('student2', 'pass123', '최수강', '444-444-444444'),
                                                                    ('student3', 'pass123', '정배움', NULL);

-- 2. USER_ROLE: 생성된 사용자들에게 역할 부여
-- 김선생(ID:1)과 박교사(ID:2)에게 TEACHER(ID:1) 역할 부여
INSERT INTO `USER_ROLE` (`USER_ID`, `ROLE_ID`) VALUES
                                                   (1, 1),
                                                   (2, 1),
-- 이학생(ID:3), 최수강(ID:4), 정배움(ID:5)에게 STUDENT(ID:2) 역할 부여
                                                   (3, 2),
                                                   (4, 2),
                                                   (5, 2);

-- 3. CATEGORIES: 강의 카테고리 생성
INSERT INTO `CATEGORIES` (`CATEGORY`) VALUES
                                          ('요리'),
                                          ('미술'),
                                          ('운동');

-- 4. CLASSES: 3개의 클래스 개설
-- 김선생(ID:1)이 '요리'와 '미술' 클래스 개설
INSERT INTO `CLASSES` (`TEACHER_ID`, `CATEGORY_ID`, `CLASS_NAME`, `CLASS_DETAIL`, `START_AT`, `END_AT`, `LOCATION`, `ZIPCODE`, `MAX_CAPACITY`, `PRICE`) VALUES
                                                                                                                                                           (1, 1, '왕초보 파스타 만들기', '토마토 소스 파스타의 모든 것을 알려드립니다.', '2025-11-15 14:00:00', '2025-11-15 16:00:00', '서울시 강남구 요리학원', '06292', 10, 50000),
                                                                                                                                                           (1, 2, '연필 소묘 기초', '인물화 그리기를 위한 기본기 다지기', '2025-11-22 10:00:00', '2025-11-22 13:00:00', '서울시 홍대입구 화실', '04054', 8, 75000),
-- 박교사(ID:2)가 '운동' 클래스 개설
                                                                                                                                                           (2, 3, '주말 아침 요가', '몸과 마음을 깨우는 힐링 요가 클래스입니다.', '2025-11-23 09:00:00', '2025-11-23 10:30:00', '서울시 마포구 요가센터', '04107', 15, 30000);

-- 5. IMAGES: 각 클래스에 이미지 추가
-- '왕초보 파스타 만들기'(ID:1) 클래스에 이미지 2개 (하나는 대표 이미지)
INSERT INTO `IMAGES` (`CLASS_ID`, `IMAGE_URL`, `IS_REPRESENTATIVE`,`IS_MAIN_SLIDE`) VALUES
                                                                        (1, '/static/img/category-painting-icon.png', 1, 0),
                                                                        (1, '/static/img/category-pottery-icon.png', 0, 0),
-- '연필 소묘 기초'(ID:2) 클래스에 대표 이미지 1개
                                                                        (2, '/static/img/category-pottery-icon.png', 1, 0),
-- '주말 아침 요가'(ID:3) 클래스에 대표 이미지 1개
                                                                        (3, 'http://example.com/images/yoga_main.jpg', 1, 0),
                                                                        (1, '/static/img/logo.png', 0, 1),
                                                                        (2, '/static/img/logo.png', 0, 1);


-- 6. RESERVATIONS: 학생들이 클래스를 예약
-- 이학생(ID:3)이 파스타(ID:1) 클래스를 '예약 완료' 상태로 예약
INSERT INTO `RESERVATIONS` (`CLASS_ID`, `STUDENT_ID`, `STATUS_CODE`) VALUES
                                                                         (1, 3, 1),
-- 최수강(ID:4)이 요가(ID:3) 클래스를 '결제 대기' 상태로 예약
                                                                         (3, 4, 2),
-- 정배움(ID:5)이 파스타(ID:1) 클래스를 '예약 완료' 상태로 예약
                                                                         (1, 5, 1),
-- 이학생(ID:3)이 연필 소묘(ID:2) 클래스를 '예약 취소' 상태로 예약했던 기록
                                                                         (2, 3, 3);

-- 7. PAYMENTS: '예약 완료'된 건에 대한 결제 정보 생성
-- 이학생(ID:3)의 파스타 클래스(예약ID:1) 결제 정보
INSERT INTO `PAYMENTS` (`RESERVATION_ID`, `TOSS_ORDER_ID`, `TOSS_PAYMENT_KEY`, `TOSS_PAYMENT_METHOD`, `TOSS_PAYMENT_STATUS`, `REQUESTED_AT`, `APPROVED_AT`, `TOTAL_AMOUNT`) VALUES
                                                                                                                                                                                (1, 'toss_order_1_stud1_class1', 'toss_payment_key_abc123', '카드', 'DONE', '2025-10-10 10:01:00', '2025-10-10 10:01:15', 50000),
-- 정배움(ID:5)의 파스타 클래스(예약ID:3) 결제 정보
                                                                                                                                                                                (3, 'toss_order_3_stud3_class1', 'toss_payment_key_def456', '가상계좌', 'DONE', '2025-10-11 15:30:00', '2025-10-12 09:00:00', 50000);