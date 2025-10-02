<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <link rel="icon" href="https://static.toss.im/icons/png/4x/icon-toss-logo.png" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/style.css" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>토스페이먼츠 샘플 프로젝트</title>
    <script src="https://js.tosspayments.com/v2/standard"></script>
</head>

<body>
<div class="wrapper">
    <div class="box_section" style="padding: 40px 30px 50px 30px; margin-top: 30px; margin-bottom: 50px">
        <div id="payment-method"></div>
        <div id="agreement"></div>
        <div style="padding-left: 30px">
            <div class="checkable typography--p">
                <label for="coupon-box" class="checkable__label typography--regular">
                    <input id="coupon-box" class="checkable__input" type="checkbox" aria-checked="true" /><span class="checkable__label-text">5,000원 쿠폰 적용</span>
                </label>
            </div>
        </div>
        <button class="button" id="payment-button" style="margin-top: 30px">결제하기</button>
    </div>
    <div class="box_section" style="padding: 40px 30px 50px 30px; margin-top: 30px; margin-bottom: 50px">
        <button class="button" id="brandpay-button" style="margin-top: 30px">위젯 없이 브랜드페이만 연동하기</button>
        <button class="button" id="payment-window-button" style="margin-top: 30px">위젯 없이 결제창만 연동하기</button>
    </div>
</div>
<script>
    let currentURL = window.location.href.replace(/[^/]*$/, '');
    main();

    async function main() {
        const paymentButton = document.getElementById("payment-button");
        const coupon = document.getElementById("coupon-box");
        const initialAmount = {
            currency: "KRW",
            value: 50000,
        };

        // ------  결제위젯 초기화 ------
        const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm"; // 위젯 사용을 위한 클라이언트 키
        const customerKey = generateRandomString(); // 구매자의 고유 아이디

        const tossPayments = TossPayments(clientKey);
        const widgets = tossPayments.widgets({
            customerKey,
        });

        // ------  주문서의 결제 금액 설정 (최초 렌더링 전) ------
        await widgets.setAmount(initialAmount);

        await Promise.all([
            // ------  결제 UI 렌더링 (이미지와 동일한 위젯 렌더링) ------
            widgets.renderPaymentMethods({
                selector: "#payment-method",
                variantKey: "DEFAULT", // 기본 결제 UI
            }),
            // ------  이용약관 UI 렌더링 (이미지에 포함된 필수 동의) ------
            widgets.renderAgreement({
                selector: "#agreement",
                variantKey: "AGREEMENT",
            }),
        ]);

        // ------  주문서의 결제 금액이 변경되었을 경우 결제 금액 업데이트 ------
        coupon.addEventListener("change", async function () {
            let newAmount = initialAmount.value;
            if (coupon.checked) {
                newAmount -= 5000; // 쿠폰 적용
            }
            await widgets.setAmount({
                currency: "KRW",
                value: newAmount,
            });
        });

        // ------ '결제하기' 버튼 누르면 결제창 띄우기 (위젯의 requestPayment 사용) ------
        paymentButton.addEventListener("click", async function () {
            const domain = window.location.origin;
            const contextPath = "${pageContext.request.contextPath}"; // JSP context path 사용

            const success_Url = domain + contextPath + "/api/payment/success"; // 첫 번째 코드의 성공 URL
            const fail_Url = domain + contextPath + "/api/payment/fail";     // 첫 번째 코드의 실패 URL

            await widgets.requestPayment({
                orderId: 'oneday-3-' + Date.now(), // 첫 번째 코드의 주문 ID 생성 방식
                orderName: "토스 티셔츠 외 2건",
                successUrl: success_Url,
                failUrl: fail_Url,
                customerEmail: "customer123@gmail.com", // 첫 번째 코드의 이메일
                customerName: "김토스",               // 첫 번째 코드의 이름
            });
        });
    }

    document.getElementById("payment-window-button").addEventListener("click", () => {
        location.href = "/public/payment/checkout.html";
    });

    document.getElementById("brandpay-button").addEventListener("click", () => {
        location.href = "/public/brandpay/checkout.html";
    });

    function generateRandomString() {
        return window.btoa(Math.random()).slice(0, 20);
    }
</script>
</body>
</html>