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
);

-- USERS 테이블 생성
CREATE TABLE `USERS` (
                         `USER_ID` INT NOT NULL AUTO_INCREMENT,
                         `LOGIN_ID` VARCHAR(20) NOT NULL,
                         `PASSWORD` VARCHAR(255) NOT NULL, -- 비밀번호는 암호화(해싱) 저장을 위해 길이를 넉넉하게 설정하는 것을 권장합니다.
                         `NAME` VARCHAR(20) NOT NULL,
                         `ACCOUNT` VARCHAR(20) NULL,
                         PRIMARY KEY (`USER_ID`),
                         UNIQUE KEY `UK_LOGIN_ID` (`LOGIN_ID`)
);

-- USER_ROLE 테이블 생성 (다대다 관계 매핑)
CREATE TABLE `USER_ROLE` (
                             `USER_ID` INT NOT NULL,
                             `ROLE_ID` INT NOT NULL,
                             PRIMARY KEY (`USER_ID`, `ROLE_ID`),
                             CONSTRAINT `FK_USER_ROLE_TO_USERS` FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                             CONSTRAINT `FK_USER_ROLE_TO_ROLES` FOREIGN KEY (`ROLE_ID`) REFERENCES `ROLES` (`ROLE_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

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
);

-- CLASSES 테이블 생성
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
                           `MAX_CAPACITY` INT UNSIGNED NULL, -- 정원 수는 음수가 될 수 없으므로 UNSIGNED 옵션 추가
                           `PRICE` INT UNSIGNED NOT NULL DEFAULT 0, -- 가격은 음수가 될 수 없으므로 UNSIGNED 옵션 추가
                           PRIMARY KEY (`CLASS_ID`),
                           CONSTRAINT `FK_CLASSES_TO_USERS` FOREIGN KEY (`TEACHER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                           CONSTRAINT `FK_CLASSES_TO_CATEGORIES` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `CATEGORIES` (`CATEGORY_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- IMAGES 테이블 생성
CREATE TABLE `IMAGES` (
                          `IMAGE_ID` INT NOT NULL AUTO_INCREMENT,
                          `CLASS_ID` INT NOT NULL,
                          `IMAGE_URL` VARCHAR(255) NOT NULL,
                          `IS_REPRESENTATIVE` TINYINT(1) NOT NULL DEFAULT 0,
                          PRIMARY KEY (`IMAGE_ID`),
                          CONSTRAINT `FK_IMAGES_TO_CLASSES` FOREIGN KEY (`CLASS_ID`) REFERENCES `CLASSES` (`CLASS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- RESERVE_STATUSES 테이블 생성
CREATE TABLE `RESERVE_STATUSES` (
                                    `STATUS_CODE` INT NOT NULL,
                                    `STATUS_NAME` VARCHAR(40) NOT NULL,
                                    PRIMARY KEY (`STATUS_CODE`)
);

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
);

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
);

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

