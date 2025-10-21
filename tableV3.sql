SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER_SET_CLIENT = utf8mb4;
SET CHARACTER_SET_CONNECTION = utf8mb4;
SET CHARACTER_SET_RESULTS = utf8mb4;

USE oneday_db;

-- =================================================================
-- 기존 테이블 삭제 (초기화)
-- =================================================================
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
-- 테이블 생성 (tableV2.sql 기반 - 변경 없음)
-- =================================================================

CREATE TABLE `ROLES` (
                         `ROLE_ID` INT NOT NULL AUTO_INCREMENT,
                         `ROLE_NAME` VARCHAR(20) NOT NULL,
                         PRIMARY KEY (`ROLE_ID`),
                         UNIQUE KEY `UK_ROLE_NAME` (`ROLE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `USERS` (
                         `USER_ID` INT NOT NULL AUTO_INCREMENT,
                         `LOGIN_ID` VARCHAR(20) NOT NULL,
                         `PASSWORD` VARCHAR(255) NOT NULL,
                         `NAME` VARCHAR(20) NOT NULL,
                         `ACCOUNT` VARCHAR(20) NULL,
                         PRIMARY KEY (`USER_ID`),
                         UNIQUE KEY `UK_LOGIN_ID` (`LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `USER_ROLE` (
                             `USER_ID` INT NOT NULL,
                             `ROLE_ID` INT NOT NULL,
                             PRIMARY KEY (`USER_ID`, `ROLE_ID`),
                             CONSTRAINT `FK_USER_ROLE_TO_USERS` FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                             CONSTRAINT `FK_USER_ROLE_TO_ROLES` FOREIGN KEY (`ROLE_ID`) REFERENCES `ROLES` (`ROLE_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX `IDX_USER_ROLE_ROLE_ID` ON `USER_ROLE` (`ROLE_ID`);

CREATE TABLE `CATEGORIES` (
                              `CATEGORY_ID` INT NOT NULL AUTO_INCREMENT,
                              `CATEGORY` VARCHAR(100) NOT NULL,
                              PRIMARY KEY (`CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `CLASSES` (
                           `CLASS_ID` INT NOT NULL AUTO_INCREMENT,
                           `TEACHER_ID` INT NOT NULL,
                           `CATEGORY_ID` INT NOT NULL,
                           `CLASS_NAME` VARCHAR(50) NOT NULL,
                           `CLASS_DETAIL` TEXT NULL,
                           `START_AT` DATETIME NOT NULL,
                           `END_AT` DATETIME NOT NULL,
                           `LONGITUDE` VARCHAR(20) NULL,
                           `LATITUDE` VARCHAR(20) NULL,
                           `LOCATION` VARCHAR(255) NULL,
                           `ZIPCODE` VARCHAR(10) NULL,
                           `MAX_CAPACITY` INT UNSIGNED NULL,
                           `PRICE` INT UNSIGNED NOT NULL DEFAULT 0,
                           PRIMARY KEY (`CLASS_ID`),
                           CONSTRAINT `FK_CLASSES_TO_USERS` FOREIGN KEY (`TEACHER_ID`) REFERENCES `USERS` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
                           CONSTRAINT `FK_CLASSES_TO_CATEGORIES` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `CATEGORIES` (`CATEGORY_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `IMAGES` (
                          `IMAGE_ID` INT NOT NULL AUTO_INCREMENT,
                          `CLASS_ID` INT NOT NULL,
                          `IMAGE_URL` VARCHAR(255) NOT NULL,
                          `IS_REPRESENTATIVE` TINYINT(1) NOT NULL DEFAULT 0,
                          `IS_MAIN_SLIDE` TINYINT(1) NOT NULL DEFAULT 0,
                          PRIMARY KEY (`IMAGE_ID`),
                          CONSTRAINT `FK_IMAGES_TO_CLASSES` FOREIGN KEY (`CLASS_ID`) REFERENCES `CLASSES` (`CLASS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `RESERVE_STATUSES` (
                                    `STATUS_CODE` INT NOT NULL,
                                    `STATUS_NAME` VARCHAR(40) NOT NULL,
                                    PRIMARY KEY (`STATUS_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE `PAYMENTS` (
                            `PAYMENT_ID` INT NOT NULL AUTO_INCREMENT,
                            `RESERVATION_ID` INT NOT NULL,
                            `TOSS_ORDER_ID` VARCHAR(255) NULL,
                            `TOSS_PAYMENT_KEY` VARCHAR(255) NULL,
                            `TOSS_PAYMENT_METHOD` VARCHAR(50) NULL,
                            `TOSS_PAYMENT_STATUS` VARCHAR(50) NULL,
                            `REQUESTED_AT` DATETIME NULL,
                            `APPROVED_AT` DATETIME NULL,
                            `TOTAL_AMOUNT` INT UNSIGNED NULL,
                            PRIMARY KEY (`PAYMENT_ID`),
                            UNIQUE KEY `UK_RESERVATION_ID` (`RESERVATION_ID`),
                            UNIQUE KEY `UK_TOSS_ORDER_ID` (`TOSS_ORDER_ID`),
                            CONSTRAINT `FK_PAYMENTS_TO_RESERVATIONS` FOREIGN KEY (`RESERVATION_ID`) REFERENCES `RESERVATIONS` (`RESERVATION_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =================================================================
-- 기본 데이터 삽입
-- =================================================================

INSERT INTO `ROLES` (`ROLE_ID`, `ROLE_NAME`) VALUES (1, 'TEACHER'), (2, 'STUDENT');

INSERT INTO `RESERVE_STATUSES` (`STATUS_CODE`, `STATUS_NAME`) VALUES
                                                                  (1, '예약 완료'),
                                                                  (2, '결제 대기'),
                                                                  (3, '예약 취소'),
                                                                  (4, '수업 완료');

-- =================================================================
-- 테스트 데이터 삽입
-- =================================================================

-- 1. 카테고리 데이터 (7개) - CATEGORY_ID는 AUTO_INCREMENT로 1~7 자동 생성
INSERT INTO `CATEGORIES` (`CATEGORY`) VALUES
                                          ('baking'),      -- CATEGORY_ID: 1
                                          ('bookmaking'),  -- CATEGORY_ID: 2
                                          ('cooking'),     -- CATEGORY_ID: 3
                                          ('flower'),      -- CATEGORY_ID: 4
                                          ('metalworking'),-- CATEGORY_ID: 5
                                          ('painting'),    -- CATEGORY_ID: 6
                                          ('pottery');     -- CATEGORY_ID: 7

-- 2. 사용자 데이터: 강사 7명 + 학생 20명
INSERT INTO `USERS` (`LOGIN_ID`, `PASSWORD`, `NAME`, `ACCOUNT`) VALUES
-- 강사 7명 (카테고리별 1명)
('teacher_baking', 'password123', '김베이킹', '111-111-111111'),
('teacher_bookmaking', 'password123', '박제책', '222-222-222222'),
('teacher_cooking', 'password123', '이쿠킹', '333-333-333333'),
('teacher_flower', 'password123', '최플라워', '444-444-444444'),
('teacher_metalworking', 'password123', '정금속', '555-555-555555'),
('teacher_painting', 'password123', '강페인팅', '666-666-666666'),
('teacher_pottery', 'password123', '윤도자기', '777-777-777777'),
-- 학생 20명
('student01', 'password123', '학생01', '800-000-000001'),
('student02', 'password123', '학생02', '800-000-000002'),
('student03', 'password123', '학생03', '800-000-000003'),
('student04', 'password123', '학생04', '800-000-000004'),
('student05', 'password123', '학생05', '800-000-000005'),
('student06', 'password123', '학생06', '800-000-000006'),
('student07', 'password123', '학생07', '800-000-000007'),
('student08', 'password123', '학생08', '800-000-000008'),
('student09', 'password123', '학생09', '800-000-000009'),
('student10', 'password123', '학생10', '800-000-000010'),
('student11', 'password123', '학생11', '800-000-000011'),
('student12', 'password123', '학생12', '800-000-000012'),
('student13', 'password123', '학생13', '800-000-000013'),
('student14', 'password123', '학생14', '800-000-000014'),
('student15', 'password123', '학생15', '800-000-000015'),
('student16', 'password123', '학생16', '800-000-000016'),
('student17', 'password123', '학생17', '800-000-000017'),
('student18', 'password123', '학생18', '800-000-000018'),
('student19', 'password123', '학생19', '800-000-000019'),
('student20', 'password123', '학생20', '800-000-000020');

-- 3. 역할 부여
-- 강사 역할 (USER_ID 1~7)
INSERT INTO `USER_ROLE` (`USER_ID`, `ROLE_ID`) VALUES
                                                   (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1);

-- 학생 역할 (USER_ID 8~27)
INSERT INTO `USER_ROLE` (`USER_ID`, `ROLE_ID`) VALUES
                                                   (8, 2), (9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 2),
                                                   (15, 2), (16, 2), (17, 2), (18, 2), (19, 2), (20, 2), (21, 2),
                                                   (22, 2), (23, 2), (24, 2), (25, 2), (26, 2), (27, 2);

-- 4. 강의 데이터 (카테고리별 3개씩, 총 21개)
-- 날짜 분산: 과거 10% (2건), 현재 10% (2건), 미래 80% (17건)
INSERT INTO `CLASSES` (`TEACHER_ID`, `CATEGORY_ID`, `CLASS_NAME`, `CLASS_DETAIL`, `START_AT`, `END_AT`, `LONGITUDE`, `LATITUDE`, `LOCATION`, `ZIPCODE`, `MAX_CAPACITY`, `PRICE`) VALUES
-- CATEGORY 1: baking (과거 1개, 미래 2개)
(1, 1, '쿠키 만들기 입문', '초보자를 위한 기본 쿠키 만들기 클래스입니다.', '2025-10-15 14:00:00', '2025-10-15 17:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 베이킹 스튜디오', '06234', 12, 45000),
(1, 1, '프랑스식 크루아상', '버터가 풍부한 크루아상을 만들어봅니다.', '2025-12-05 10:00:00', '2025-12-05 14:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 베이킹 스튜디오', '06234', 8, 85000),
(1, 1, '케이크 데코레이션', '생크림 케이크 만들기와 데코레이션 기법', '2025-12-20 13:00:00', '2025-12-20 16:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 베이킹 스튜디오', '06234', 10, 65000),

-- CATEGORY 2: bookmaking (미래 3개)
(2, 2, '수제 노트 만들기', '나만의 핸드메이드 노트를 제작합니다.', '2025-12-08 14:00:00', '2025-12-08 17:00:00', '126.9784', '37.5665', '서울시 종로구 인사동 공방', '03141', 6, 55000),
(2, 2, '전통 제책 기법', '한국 전통 제책 방식을 배워봅니다.', '2025-12-15 10:00:00', '2025-12-15 13:00:00', '126.9784', '37.5665', '서울시 종로구 인사동 공방', '03141', 8, 70000),
(2, 2, '가죽 다이어리 제작', '천연 가죽으로 만드는 고급 다이어리', '2025-12-28 14:00:00', '2025-12-28 18:00:00', '126.9784', '37.5665', '서울시 종로구 인사동 공방', '03141', 5, 95000),

-- CATEGORY 3: cooking (현재 1개, 미래 2개)
(3, 3, '이탈리아 파스타 마스터', '정통 파스타 만들기 클래스', '2025-11-25 18:00:00', '2025-11-25 21:00:00', '126.9270', '37.5563', '서울시 마포구 홍대 쿠킹 스튜디오', '04042', 15, 75000),
(3, 3, '일본 가정식 요리', '간단하고 맛있는 일본 가정식', '2025-12-10 14:00:00', '2025-12-10 17:00:00', '126.9270', '37.5563', '서울시 마포구 홍대 쿠킹 스튜디오', '04042', 12, 60000),
(3, 3, '건강 샐러드 & 드레싱', '영양 만점 샐러드와 수제 드레싱', '2025-12-22 11:00:00', '2025-12-22 13:00:00', '126.9270', '37.5563', '서울시 마포구 홍대 쿠킹 스튜디오', '04042', 20, 50000),

-- CATEGORY 4: flower (과거 1개, 미래 2개)
(4, 4, '계절 꽃다발 만들기', '제철 꽃으로 만드는 아름다운 꽃다발', '2025-10-20 14:00:00', '2025-10-20 16:00:00', '127.0472', '37.5172', '서울시 강남구 압구정동 플라워샵', '06011', 10, 80000),
(4, 4, '웨딩 부케 디자인', '신부를 위한 특별한 웨딩 부케', '2025-12-07 10:00:00', '2025-12-07 13:00:00', '127.0472', '37.5172', '서울시 강남구 압구정동 플라워샵', '06011', 8, 120000),
(4, 4, '프리저브드 플라워', '오래 보관할 수 있는 프리저브드 플라워 제작', '2025-12-18 14:00:00', '2025-12-18 17:00:00', '127.0472', '37.5172', '서울시 강남구 압구정동 플라워샵', '06011', 12, 90000),

-- CATEGORY 5: metalworking (미래 3개)
(5, 5, '실버 반지 만들기', '순은으로 나만의 반지 제작', '2025-12-12 14:00:00', '2025-12-12 17:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 금속공방', '06234', 6, 110000),
(5, 5, '커플 팔찌 제작', '연인을 위한 특별한 커플 팔찌', '2025-12-19 13:00:00', '2025-12-19 16:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 금속공방', '06234', 8, 150000),
(5, 5, '금속 공예 입문', '금속 세공의 기초를 배웁니다', '2025-12-26 10:00:00', '2025-12-26 14:00:00', '127.0276', '37.4979', '서울시 강남구 역삼동 금속공방', '06234', 10, 95000),

-- CATEGORY 6: painting (현재 1개, 미래 2개)
(6, 6, '수채화 풍경화', '아름다운 풍경을 수채화로 표현하기', '2025-11-28 10:00:00', '2025-11-28 13:00:00', '126.9784', '37.5665', '서울시 종로구 삼청동 화실', '03062', 12, 55000),
(6, 6, '인물 드로잉 기초', '사람을 그리는 기본 기법', '2025-12-14 14:00:00', '2025-12-14 17:00:00', '126.9784', '37.5665', '서울시 종로구 삼청동 화실', '03062', 10, 70000),
(6, 6, '아크릴화 추상화', '자유로운 추상 표현 기법', '2025-12-21 13:00:00', '2025-12-21 16:00:00', '126.9784', '37.5665', '서울시 종로구 삼청동 화실', '03062', 15, 60000),

-- CATEGORY 7: pottery (과거 1개, 현재 1개, 미래 1개)
(7, 7, '손으로 빚는 도자기', '물레 없이 손으로 그릇 만들기', '2025-10-25 14:00:00', '2025-10-25 17:00:00', '127.0472', '37.5172', '서울시 강남구 청담동 도예공방', '06015', 8, 65000),
(7, 7, '물레 체험 클래스', '전통 물레로 도자기 만들기', '2025-11-30 10:00:00', '2025-11-30 13:00:00', '127.0472', '37.5172', '서울시 강남구 청담동 도예공방', '06015', 10, 85000),
(7, 7, '도자기 페인팅', '완성된 도자기에 그림 그리기', '2025-12-25 14:00:00', '2025-12-25 17:00:00', '127.0472', '37.5172', '서울시 강남구 청담동 도예공방', '06015', 12, 70000);

-- 5. 이미지 데이터 (카테고리 ID 기반 경로, 강의당 1~5개 랜덤)
INSERT INTO `IMAGES` (`CLASS_ID`, `IMAGE_URL`, `IS_REPRESENTATIVE`, `IS_MAIN_SLIDE`) VALUES
-- CLASS_ID 1: baking 쿠키 (4개, 메인슬라이드 1개)
(1, '/uploads/images/1/cookie1.png', 1, 1),
(1, '/uploads/images/1/cookie2.png', 0, 0),
(1, '/uploads/images/1/cookie3.png', 0, 0),
(1, '/uploads/images/1/cookie4.png', 0, 0),

-- CLASS_ID 2: baking 크루아상 (5개)
(2, '/uploads/images/1/croissant1.png', 1, 0),
(2, '/uploads/images/1/croissant2.png', 0, 0),
(2, '/uploads/images/1/croissant3.png', 0, 0),
(2, '/uploads/images/1/croissant4.png', 0, 0),
(2, '/uploads/images/1/croissant5.png', 0, 0),

-- CLASS_ID 3: baking 케이크 (2개)
(3, '/uploads/images/1/cake1.png', 1, 0),
(3, '/uploads/images/1/cake2.png', 0, 0),

-- CLASS_ID 4: bookmaking 수제노트 (3개)
(4, '/uploads/images/2/264cfebb-3b2f-4e57-ab97-90a64af11508.png', 1, 0),
(4, '/uploads/images/2/a9c3a9dd-2bcb-430e-bbda-10f29742ab31.png', 0, 0),
(4, '/uploads/images/2/b6780654-5407-4fc7-a261-73adc8fd8668.png', 0, 0),

-- CLASS_ID 5: bookmaking 전통제책 (4개, 메인슬라이드 1개)
(5, '/uploads/images/2/b7b118df-3af9-482c-b365-8b1f22becf89.png', 1, 1),
(5, '/uploads/images/2/c5414b2c-ec3e-41c5-92e7-c8fa7a1bc051.png', 0, 0),
(5, '/uploads/images/2/c6566ca2-1163-4b56-aa4e-6068deaf0a96.png', 0, 0),
(5, '/uploads/images/2/ccbbf523-4647-429d-999b-2cf93a7a0b39.png', 0, 0),

-- CLASS_ID 6: bookmaking 가죽다이어리 (2개)
(6, '/uploads/images/2/264cfebb-3b2f-4e57-ab97-90a64af11508.png', 1, 0),
(6, '/uploads/images/2/a9c3a9dd-2bcb-430e-bbda-10f29742ab31.png', 0, 0),

-- CLASS_ID 7: cooking 파스타 (5개)
(7, '/uploads/images/3/martcha.png', 1, 0),
(7, '/uploads/images/3/0482535a-f695-4a9b-883b-57bc855640b7.png', 0, 0),
(7, '/uploads/images/3/11a25dc8-5ac5-4ea0-bc74-95f4c184ef10.png', 0, 0),
(7, '/uploads/images/3/29b30146-ed53-4ece-b73b-c243815df324.png', 0, 0),
(7, '/uploads/images/3/4a6b8c61-c3c1-46c4-8349-876cd3a58b16.png', 0, 0),

-- CLASS_ID 8: cooking 일본가정식 (3개)
(8, '/uploads/images/3/570afa73-a093-4f65-bb8f-ae80ae9ce7ce.png', 1, 0),
(8, '/uploads/images/3/588058fb-c9fc-4b54-b0d7-74c777c16b4d.png', 0, 0),
(8, '/uploads/images/3/72a6e00d-b1e0-465d-8d0a-e6e8d5cc62d2.png', 0, 0),

-- CLASS_ID 9: cooking 샐러드 (4개, 메인슬라이드 1개)
(9, '/uploads/images/3/7716f4b2-2e19-48cb-a1cd-2ecc1dea5166.png', 1, 1),
(9, '/uploads/images/3/7cf8cc24-964f-4aab-98dd-5492f9f16758.png', 0, 0),
(9, '/uploads/images/3/869a51f6-2ac1-4c82-a86d-13af0ce6626d.png', 0, 0),
(9, '/uploads/images/3/8eee9888-3962-44cd-84bf-304d519de33f.png', 0, 0),

-- CLASS_ID 10: flower 계절꽃다발 (5개)
(10, '/uploads/images/4/bouquet1.png', 1, 0),
(10, '/uploads/images/4/bouquet2.png', 0, 0),
(10, '/uploads/images/4/bouquet3.png', 0, 0),
(10, '/uploads/images/4/bouquet4.png', 0, 0),
(10, '/uploads/images/4/bouquet5.png', 0, 0),

-- CLASS_ID 11: flower 웨딩부케 (3개, 메인슬라이드 1개)
(11, '/uploads/images/4/bouquet6.png', 1, 1),
(11, '/uploads/images/4/bouquet7.png', 0, 0),
(11, '/uploads/images/4/bouquet8.png', 0, 0),

-- CLASS_ID 12: flower 프리저브드 (3개)
(12, '/uploads/images/4/flower1.png', 1, 0),
(12, '/uploads/images/4/flower2.png', 0, 0),
(12, '/uploads/images/4/flower3.png', 0, 0),

-- CLASS_ID 13: metalworking 반지 (2개)
(13, '/uploads/images/5/ring 1.png', 1, 0),
(13, '/uploads/images/5/ring 2.png', 0, 0),

-- CLASS_ID 14: metalworking 팔찌 (4개)
(14, '/uploads/images/5/54e16625-2834-457c-bb31-510e0933d7a7.png', 1, 0),
(14, '/uploads/images/5/b64980b0-fbe6-4c43-b4e3-1cf748804d4f.png', 0, 0),
(14, '/uploads/images/5/ecdb3ae2-7251-428e-a84c-b30804c3ccb2.png', 0, 0),
(14, '/uploads/images/5/0af2ee27-ea1b-4086-8bbc-8ffa0922b840.jpg', 0, 0),

-- CLASS_ID 15: metalworking 금속공예 (3개, 메인슬라이드 1개)
(15, '/uploads/images/5/54e16625-2834-457c-bb31-510e0933d7a7.png', 1, 1),
(15, '/uploads/images/5/b64980b0-fbe6-4c43-b4e3-1cf748804d4f.png', 0, 0),
(15, '/uploads/images/5/ecdb3ae2-7251-428e-a84c-b30804c3ccb2.png', 0, 0),

-- CLASS_ID 16: painting 수채화 (5개)
(16, '/uploads/images/6/watercolor1.jpg', 1, 0),
(16, '/uploads/images/6/watercolor2.jpg', 0, 0),
(16, '/uploads/images/6/watercolor3.png', 0, 0),
(16, '/uploads/images/6/watercolor4.png', 0, 0),
(16, '/uploads/images/6/watercolor5.png', 0, 0),

-- CLASS_ID 17: painting 인물드로잉 (3개)
(17, '/uploads/images/6/pastel1.png', 1, 0),
(17, '/uploads/images/6/pastel2.png', 0, 0),
(17, '/uploads/images/6/pastel3.png', 0, 0),

-- CLASS_ID 18: painting 아크릴화 (5개, 메인슬라이드 1개)
(18, '/uploads/images/6/acryliccolor5.png', 1, 1),
(18, '/uploads/images/6/oilcolor1.png', 0, 0),
(18, '/uploads/images/6/oilcolor2.png', 0, 0),
(18, '/uploads/images/6/pastel4.png', 0, 0),
(18, '/uploads/images/6/pastel5.png', 0, 0),

-- CLASS_ID 19: pottery 손빚기 (3개)
(19, '/uploads/images/7/cup1.png', 1, 0),
(19, '/uploads/images/7/cup2.png', 0, 0),
(19, '/uploads/images/7/cup.png', 0, 0),

-- CLASS_ID 20: pottery 물레체험 (5개, 메인슬라이드 1개)
(20, '/uploads/images/7/jiggering1.png', 1, 1),
(20, '/uploads/images/7/jiggering2.png', 0, 0),
(20, '/uploads/images/7/jiggering3.png', 0, 0),
(20, '/uploads/images/7/colormarble1.png', 0, 0),
(20, '/uploads/images/7/colormarble2.png', 0, 0),

-- CLASS_ID 21: pottery 페인팅 (4개)
(21, '/uploads/images/7/colormarble3.png', 1, 0),
(21, '/uploads/images/7/colormarble4.png', 0, 0),
(21, '/uploads/images/7/colormarble5.png', 0, 0),
(21, '/uploads/images/7/colormarble6.png', 0, 0);

-- 6. 예약 데이터 (정원 대비 0~70% 랜덤, 완료 70%, 대기 20%, 취소 10%)
INSERT INTO `RESERVATIONS` (`CLASS_ID`, `STUDENT_ID`, `STATUS_CODE`) VALUES
-- CLASS 1 (정원 12, 예약 8명 - 67%)
(1, 8, 1), (1, 9, 1), (1, 10, 1), (1, 11, 1), (1, 12, 1), (1, 13, 2), (1, 14, 2), (1, 15, 3),
-- CLASS 2 (정원 8, 예약 5명 - 63%)
(2, 16, 1), (2, 17, 1), (2, 18, 1), (2, 19, 2), (2, 20, 3),
-- CLASS 3 (정원 10, 예약 6명 - 60%)
(3, 21, 1), (3, 22, 1), (3, 23, 1), (3, 24, 1), (3, 25, 2), (3, 26, 3),
-- CLASS 4 (정원 6, 예약 4명 - 67%)
(4, 27, 1), (4, 8, 1), (4, 9, 2), (4, 10, 3),
-- CLASS 5 (정원 8, 예약 5명 - 63%)
(5, 11, 1), (5, 12, 1), (5, 13, 1), (5, 14, 2), (5, 15, 3),
-- CLASS 6 (정원 5, 예약 3명 - 60%)
(6, 16, 1), (6, 17, 1), (6, 18, 2),
-- CLASS 7 (정원 15, 예약 10명 - 67%) - 인기강좌
(7, 19, 1), (7, 20, 1), (7, 21, 1), (7, 22, 1), (7, 23, 1), (7, 24, 1), (7, 25, 1), (7, 26, 2), (7, 27, 2), (7, 8, 3),
-- CLASS 8 (정원 12, 예약 7명 - 58%)
(8, 9, 1), (8, 10, 1), (8, 11, 1), (8, 12, 1), (8, 13, 1), (8, 14, 2), (8, 15, 3),
-- CLASS 9 (정원 20, 예약 0명) - 예약 없음
-- CLASS 10 (정원 10, 예약 6명 - 60%)
(10, 16, 1), (10, 17, 1), (10, 18, 1), (10, 19, 1), (10, 20, 2), (10, 21, 3),
-- CLASS 11 (정원 8, 예약 5명 - 63%)
(11, 22, 1), (11, 23, 1), (11, 24, 1), (11, 25, 2), (11, 26, 3),
-- CLASS 12 (정원 12, 예약 4명 - 33%)
(12, 27, 1), (12, 8, 1), (12, 9, 2), (12, 10, 3),
-- CLASS 13 (정원 6, 예약 4명 - 67%)
(13, 11, 1), (13, 12, 1), (13, 13, 2), (13, 14, 3),
-- CLASS 14 (정원 8, 예약 5명 - 63%)
(14, 15, 1), (14, 16, 1), (14, 17, 1), (14, 18, 2), (14, 19, 3),
-- CLASS 15 (정원 10, 예약 7명 - 70%)
(15, 20, 1), (15, 21, 1), (15, 22, 1), (15, 23, 1), (15, 24, 1), (15, 25, 2), (15, 26, 3),
-- CLASS 16 (정원 12, 예약 8명 - 67%)
(16, 27, 1), (16, 8, 1), (16, 9, 1), (16, 10, 1), (16, 11, 1), (16, 12, 2), (16, 13, 2), (16, 14, 3),
-- CLASS 17 (정원 10, 예약 5명 - 50%)
(17, 15, 1), (17, 16, 1), (17, 17, 1), (17, 18, 2), (17, 19, 3),
-- CLASS 18 (정원 15, 예약 3명 - 20%)
(18, 20, 1), (18, 21, 1), (18, 22, 2),
-- CLASS 19 (정원 8, 예약 5명 - 63%) - 과거강의
(19, 23, 1), (19, 24, 1), (19, 25, 1), (19, 26, 1), (19, 27, 3),
-- CLASS 20 (정원 10, 예약 7명 - 70%)
(20, 8, 1), (20, 9, 1), (20, 10, 1), (20, 11, 1), (20, 12, 1), (20, 13, 2), (20, 14, 3),
-- CLASS 21 (정원 12, 예약 4명 - 33%)
(21, 15, 1), (21, 16, 1), (21, 17, 2), (21, 18, 3);

-- 7. 결제 데이터 (예약 완료 상태만)
INSERT INTO `PAYMENTS` (`RESERVATION_ID`, `TOSS_ORDER_ID`, `TOSS_PAYMENT_KEY`, `TOSS_PAYMENT_METHOD`, `TOSS_PAYMENT_STATUS`, `REQUESTED_AT`, `APPROVED_AT`, `TOTAL_AMOUNT`) VALUES
-- CLASS 1 결제 (5건)
(1, 'toss_order_1', 'toss_key_1', '카드', 'DONE', '2025-10-10 10:00:00', '2025-10-10 10:00:15', 45000),
(2, 'toss_order_2', 'toss_key_2', '토스페이', 'DONE', '2025-10-10 11:00:00', '2025-10-10 11:00:10', 45000),
(3, 'toss_order_3', 'toss_key_3', '카드', 'DONE', '2025-10-11 10:00:00', '2025-10-11 10:00:20', 45000),
(4, 'toss_order_4', 'toss_key_4', '가상계좌', 'DONE', '2025-10-11 14:00:00', '2025-10-12 09:00:00', 45000),
(5, 'toss_order_5', 'toss_key_5', '카드', 'DONE', '2025-10-12 10:00:00', '2025-10-12 10:00:15', 45000),

-- CLASS 2 결제 (3건)
(9, 'toss_order_9', 'toss_key_9', '카드', 'DONE', '2025-11-20 10:00:00', '2025-11-20 10:00:15', 85000),
(10, 'toss_order_10', 'toss_key_10', '토스페이', 'DONE', '2025-11-21 10:00:00', '2025-11-21 10:00:10', 85000),
(11, 'toss_order_11', 'toss_key_11', '카드', 'DONE', '2025-11-22 10:00:00', '2025-11-22 10:00:20', 85000),

-- CLASS 3 결제 (4건)
(14, 'toss_order_14', 'toss_key_14', '카드', 'DONE', '2025-11-25 10:00:00', '2025-11-25 10:00:15', 65000),
(15, 'toss_order_15', 'toss_key_15', '토스페이', 'DONE', '2025-11-26 10:00:00', '2025-11-26 10:00:10', 65000),
(16, 'toss_order_16', 'toss_key_16', '카드', 'DONE', '2025-11-27 10:00:00', '2025-11-27 10:00:20', 65000),
(17, 'toss_order_17', 'toss_key_17', '가상계좌', 'DONE', '2025-11-28 14:00:00', '2025-11-29 09:00:00', 65000),

-- CLASS 4 결제 (2건)
(20, 'toss_order_20', 'toss_key_20', '카드', 'DONE', '2025-11-30 10:00:00', '2025-11-30 10:00:15', 55000),
(21, 'toss_order_21', 'toss_key_21', '토스페이', 'DONE', '2025-12-01 10:00:00', '2025-12-01 10:00:10', 55000),

-- CLASS 5 결제 (3건)
(24, 'toss_order_24', 'toss_key_24', '카드', 'DONE', '2025-12-02 10:00:00', '2025-12-02 10:00:15', 70000),
(25, 'toss_order_25', 'toss_key_25', '토스페이', 'DONE', '2025-12-03 10:00:00', '2025-12-03 10:00:10', 70000),
(26, 'toss_order_26', 'toss_key_26', '카드', 'DONE', '2025-12-04 10:00:00', '2025-12-04 10:00:20', 70000),

-- CLASS 6 결제 (2건)
(28, 'toss_order_28', 'toss_key_28', '카드', 'DONE', '2025-12-05 10:00:00', '2025-12-05 10:00:15', 95000),
(29, 'toss_order_29', 'toss_key_29', '토스페이', 'DONE', '2025-12-06 10:00:00', '2025-12-06 10:00:10', 95000),

-- CLASS 7 결제 (7건)
(31, 'toss_order_31', 'toss_key_31', '카드', 'DONE', '2025-11-01 10:00:00', '2025-11-01 10:00:15', 75000),
(32, 'toss_order_32', 'toss_key_32', '토스페이', 'DONE', '2025-11-02 10:00:00', '2025-11-02 10:00:10', 75000),
(33, 'toss_order_33', 'toss_key_33', '카드', 'DONE', '2025-11-03 10:00:00', '2025-11-03 10:00:20', 75000),
(34, 'toss_order_34', 'toss_key_34', '가상계좌', 'DONE', '2025-11-04 14:00:00', '2025-11-05 09:00:00', 75000),
(35, 'toss_order_35', 'toss_key_35', '카드', 'DONE', '2025-11-05 10:00:00', '2025-11-05 10:00:15', 75000),
(36, 'toss_order_36', 'toss_key_36', '토스페이', 'DONE', '2025-11-06 10:00:00', '2025-11-06 10:00:10', 75000),
(37, 'toss_order_37', 'toss_key_37', '카드', 'DONE', '2025-11-07 10:00:00', '2025-11-07 10:00:20', 75000),

-- CLASS 8 결제 (5건)
(41, 'toss_order_41', 'toss_key_41', '카드', 'DONE', '2025-11-10 10:00:00', '2025-11-10 10:00:15', 60000),
(42, 'toss_order_42', 'toss_key_42', '토스페이', 'DONE', '2025-11-11 10:00:00', '2025-11-11 10:00:10', 60000),
(43, 'toss_order_43', 'toss_key_43', '카드', 'DONE', '2025-11-12 10:00:00', '2025-11-12 10:00:20', 60000),
(44, 'toss_order_44', 'toss_key_44', '가상계좌', 'DONE', '2025-11-13 14:00:00', '2025-11-14 09:00:00', 60000),
(45, 'toss_order_45', 'toss_key_45', '카드', 'DONE', '2025-11-14 10:00:00', '2025-11-14 10:00:15', 60000),

-- CLASS 10 결제 (4건)
(49, 'toss_order_49', 'toss_key_49', '카드', 'DONE', '2025-10-15 10:00:00', '2025-10-15 10:00:15', 80000),
(50, 'toss_order_50', 'toss_key_50', '토스페이', 'DONE', '2025-10-16 10:00:00', '2025-10-16 10:00:10', 80000),
(51, 'toss_order_51', 'toss_key_51', '카드', 'DONE', '2025-10-17 10:00:00', '2025-10-17 10:00:20', 80000),
(52, 'toss_order_52', 'toss_key_52', '가상계좌', 'DONE', '2025-10-18 14:00:00', '2025-10-19 09:00:00', 80000),

-- CLASS 11 결제 (3건)
(55, 'toss_order_55', 'toss_key_55', '카드', 'DONE', '2025-11-20 10:00:00', '2025-11-20 10:00:15', 120000),
(56, 'toss_order_56', 'toss_key_56', '토스페이', 'DONE', '2025-11-21 10:00:00', '2025-11-21 10:00:10', 120000),
(57, 'toss_order_57', 'toss_key_57', '카드', 'DONE', '2025-11-22 10:00:00', '2025-11-22 10:00:20', 120000),

-- CLASS 12 결제 (2건)
(59, 'toss_order_59', 'toss_key_59', '카드', 'DONE', '2025-11-25 10:00:00', '2025-11-25 10:00:15', 90000),
(60, 'toss_order_60', 'toss_key_60', '토스페이', 'DONE', '2025-11-26 10:00:00', '2025-11-26 10:00:10', 90000),

-- CLASS 13 결제 (2건)
(63, 'toss_order_63', 'toss_key_63', '카드', 'DONE', '2025-11-28 10:00:00', '2025-11-28 10:00:15', 110000),
(64, 'toss_order_64', 'toss_key_64', '토스페이', 'DONE', '2025-11-29 10:00:00', '2025-11-29 10:00:10', 110000),

-- CLASS 14 결제 (3건)
(67, 'toss_order_67', 'toss_key_67', '카드', 'DONE', '2025-11-30 10:00:00', '2025-11-30 10:00:15', 150000),
(68, 'toss_order_68', 'toss_key_68', '토스페이', 'DONE', '2025-12-01 10:00:00', '2025-12-01 10:00:10', 150000),
(69, 'toss_order_69', 'toss_key_69', '카드', 'DONE', '2025-12-02 10:00:00', '2025-12-02 10:00:20', 150000),

-- CLASS 15 결제 (5건)
(72, 'toss_order_72', 'toss_key_72', '카드', 'DONE', '2025-12-04 10:00:00', '2025-12-04 10:00:15', 95000),
(73, 'toss_order_73', 'toss_key_73', '토스페이', 'DONE', '2025-12-05 10:00:00', '2025-12-05 10:00:10', 95000),
(74, 'toss_order_74', 'toss_key_74', '카드', 'DONE', '2025-12-06 10:00:00', '2025-12-06 10:00:20', 95000),
(75, 'toss_order_75', 'toss_key_75', '가상계좌', 'DONE', '2025-12-07 14:00:00', '2025-12-08 09:00:00', 95000),
(76, 'toss_order_76', 'toss_key_76', '카드', 'DONE', '2025-12-08 10:00:00', '2025-12-08 10:00:15', 95000),

-- CLASS 16 결제 (5건)
(79, 'toss_order_79', 'toss_key_79', '카드', 'DONE', '2025-11-15 10:00:00', '2025-11-15 10:00:15', 55000),
(80, 'toss_order_80', 'toss_key_80', '토스페이', 'DONE', '2025-11-16 10:00:00', '2025-11-16 10:00:10', 55000),
(81, 'toss_order_81', 'toss_key_81', '카드', 'DONE', '2025-11-17 10:00:00', '2025-11-17 10:00:20', 55000),
(82, 'toss_order_82', 'toss_key_82', '가상계좌', 'DONE', '2025-11-18 14:00:00', '2025-11-19 09:00:00', 55000),
(83, 'toss_order_83', 'toss_key_83', '카드', 'DONE', '2025-11-19 10:00:00', '2025-11-19 10:00:15', 55000),

-- CLASS 17 결제 (3건)
(87, 'toss_order_87', 'toss_key_87', '카드', 'DONE', '2025-11-22 10:00:00', '2025-11-22 10:00:15', 70000),
(88, 'toss_order_88', 'toss_key_88', '토스페이', 'DONE', '2025-11-23 10:00:00', '2025-11-23 10:00:10', 70000),
(89, 'toss_order_89', 'toss_key_89', '카드', 'DONE', '2025-11-24 10:00:00', '2025-11-24 10:00:20', 70000),

-- CLASS 18 결제 (2건)
(91, 'toss_order_91', 'toss_key_91', '카드', 'DONE', '2025-12-10 10:00:00', '2025-12-10 10:00:15', 60000),
(92, 'toss_order_92', 'toss_key_92', '토스페이', 'DONE', '2025-12-11 10:00:00', '2025-12-11 10:00:10', 60000),

-- CLASS 19 결제 (4건) - 과거강의
(94, 'toss_order_94', 'toss_key_94', '카드', 'DONE', '2025-10-05 10:00:00', '2025-10-05 10:00:15', 65000),
(95, 'toss_order_95', 'toss_key_95', '토스페이', 'DONE', '2025-10-06 10:00:00', '2025-10-06 10:00:10', 65000),
(96, 'toss_order_96', 'toss_key_96', '카드', 'DONE', '2025-10-07 10:00:00', '2025-10-07 10:00:20', 65000),
(97, 'toss_order_97', 'toss_key_97', '가상계좌', 'DONE', '2025-10-08 14:00:00', '2025-10-09 09:00:00', 65000),

-- CLASS 20 결제 (5건)
(99, 'toss_order_99', 'toss_key_99', '카드', 'DONE', '2025-11-10 10:00:00', '2025-11-10 10:00:15', 85000),
(100, 'toss_order_100', 'toss_key_100', '토스페이', 'DONE', '2025-11-11 10:00:00', '2025-11-11 10:00:10', 85000),
(101, 'toss_order_101', 'toss_key_101', '카드', 'DONE', '2025-11-12 10:00:00', '2025-11-12 10:00:20', 85000),
(102, 'toss_order_102', 'toss_key_102', '가상계좌', 'DONE', '2025-11-13 14:00:00', '2025-11-14 09:00:00', 85000),
(103, 'toss_order_103', 'toss_key_103', '카드', 'DONE', '2025-11-14 10:00:00', '2025-11-14 10:00:15', 85000),

-- CLASS 21 결제 (2건)
(105, 'toss_order_105', 'toss_key_105', '카드', 'DONE', '2025-12-01 10:00:00', '2025-12-01 10:00:15', 70000),
(106, 'toss_order_106', 'toss_key_106', '토스페이', 'DONE', '2025-12-02 10:00:00', '2025-12-02 10:00:10', 70000);

-- =================================================================
-- 데이터 삽입 완료
-- =================================================================
