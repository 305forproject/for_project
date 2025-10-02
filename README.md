# for_project

경휘, 진주, 성 프로젝트

# PR test

src/
└── main/
├── java/
│ └── /yourproject/
│ ├── config/ // 설정 클래스 (SpringConfig 등)
│ ├── controller/ // 웹/REST 컨트롤러 (Servlet, 이후 @Controller)
│ ├── service/ // 비즈니스 로직 (Service 계층)
│ ├── domain/ // 엔티티, VO 등 도메인 객체
│ ├── dto/ // 데이터 전송 객체 (DTO)
│ ├── repository/ // DB 접근 (DAO, 이후 JpaRepository 등)
│ ├── exception/ // 예외 계층
│ └── util/ // 공통 유틸리티
├── resources/
│ ├── application.properties // Spring 설정 파일(도입 시)
│ ├── messages.properties // 메시지 리소스
│ └── ... // 기타 설정, SQL 등
└── webapp/
├── WEB-INF/
│ ├── web.xml // 서블릿 설정
│ └── jsp/ // JSP 뷰 파일
└── static/ // 정적 리소스(css, js, img 등)
test/
└── java/
└── com/yourcompany/yourproject/
├── controller/
├── service/
├── repository/
└── ...
