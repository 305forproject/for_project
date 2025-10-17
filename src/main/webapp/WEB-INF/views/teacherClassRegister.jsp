<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>클래스 등록 - 원데이 클래스</title>
    
    <!-- 카카오 우편번호 서비스 -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        .register-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .register-card {
            background: var(--bg-white);
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--shadow-md);
        }
        
        .register-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 32px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 24px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 15px;
        }
        
        .form-group label span {
            color: var(--primary-color);
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
            font-family: inherit;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--primary-light);
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-group input[type="number"],
        .form-group input[type="time"],
        .form-group input[type="date"] {
            width: auto;
            min-width: 200px;
        }
        
        .form-group small {
            display: block;
            margin-top: 6px;
            font-size: 13px;
            color: var(--text-muted);
        }
        
        .error {
            color: #dc3545;
            font-size: 13px;
            margin-top: 6px;
        }
        
        .address-group {
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        
        .address-group input {
            flex: 1;
        }
        
        .address-group .btn {
            flex-shrink: 0;
            margin-top: 0;
        }
        
        .image-preview {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }
        
        .image-item {
            position: relative;
            width: 100%;
            padding-top: 100%;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .image-item:hover {
            transform: scale(1.02);
        }
        
        .image-item.representative {
            border-color: var(--primary-color);
            border-width: 3px;
        }
        
        .image-item img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .representative-label {
            position: absolute;
            top: 8px;
            left: 8px;
            background: var(--primary-color);
            color: var(--text-white);
            padding: 4px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 4px;
            z-index: 1;
        }
        
        .remove-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            background: #dc3545;
            color: var(--text-white);
            border: none;
            border-radius: 50%;
            width: 28px;
            height: 28px;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1;
            transition: var(--transition);
        }
        
        .remove-btn:hover {
            background: #c82333;
        }
        
        .button-group {
            display: flex;
            gap: 16px;
            margin-top: 40px;
            justify-content: center;
        }
        
        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: var(--primary-color);
            color: var(--text-white);
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        
        .btn-secondary {
            background: var(--bg-gray);
            color: var(--text-primary);
        }
        
        .btn-secondary:hover {
            background: var(--primary-light);
        }
        
        /* 반응형 */
        @media screen and (max-width: 768px) {
            .register-container {
                margin: 40px auto;
            }
            
            .register-card {
                padding: 24px;
            }
            
            .register-title {
                font-size: 24px;
            }
            
            .address-group {
                flex-direction: column;
            }
            
            .address-group input,
            .form-group input[type="number"],
            .form-group input[type="time"],
            .form-group input[type="date"] {
                width: 100%;
            }
            
            .image-preview {
                grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
                gap: 12px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- 공통 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/includes/header.jsp" />

    <div class="register-container">
        <div class="register-card">
            <h1 class="register-title">✨ 클래스 등록</h1>

            <form method="post" 
                  action="${pageContext.request.contextPath}/teachers/classes/register"
                  id="registerForm" 
                  enctype="multipart/form-data">
                  
                <div class="form-group">
                    <label for="className">
                        클래스명 <span>*</span>
                    </label>
                    <input type="text" id="className" name="className" required 
                           placeholder="예: 처음 배우는 홈베이킹">
                </div>

                <div class="form-group">
                    <label for="description">
                        클래스 설명 <span>*</span>
                    </label>
                    <textarea id="description" name="description" required 
                              placeholder="클래스에 대한 상세한 설명을 입력해주세요"></textarea>
                </div>

                <div class="form-group">
                    <label for="categoryId">
                        카테고리 <span>*</span>
                    </label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">카테고리를 선택하세요</option>
                        <option value="1">🍳 요리</option>
                        <option value="2">🎨 미술</option>
                        <option value="3">🏃 운동</option>
                        <option value="4">🧘 요가</option>
                        <option value="5">🎭 공예</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="classDate">
                        수업 날짜 <span>*</span>
                    </label>
                    <input type="date" id="classDate" name="classDate" required>
                    <div id="dateError" class="error"></div>
                </div>

                <div class="form-group">
                    <label for="startTime">
                        시작 시간 <span>*</span>
                    </label>
                    <input type="time" id="startTime" name="startTime" required step="300">
                    <div id="timeError" class="error"></div>
                </div>

                <div class="form-group">
                    <label for="endTime">
                        종료 시간 <span>*</span>
                    </label>
                    <input type="time" id="endTime" name="endTime" required step="300">
                </div>

                <div class="form-group">
                    <label for="maxStudents">
                        최대 학생 수 <span>*</span>
                    </label>
                    <input type="number" id="maxStudents" name="maxStudents" 
                           min="1" max="50" required placeholder="1">
                    <small>최소 1명, 최대 50명까지 설정 가능합니다</small>
                </div>

                <div class="form-group">
                    <label for="price">
                        수업료 <span>*</span>
                    </label>
                    <input type="number" id="price" name="price" 
                           min="0" required placeholder="50000">
                    <small>원 단위로 입력해주세요 (예: 50000)</small>
                </div>

                <div class="form-group">
                    <label for="zipcode">
                        우편번호 <span>*</span>
                    </label>
                    <div class="address-group">
                        <input type="text" id="zipcode" name="zipcode" readonly 
                               placeholder="주소 검색 버튼을 클릭하세요">
                        <button type="button" class="btn btn-primary" onclick="searchAddress()">
                            📍 주소 검색
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="location">
                        수업 장소 <span>*</span>
                    </label>
                    <input type="text" id="location" name="location" required 
                           placeholder="주소 검색 후 자동 입력됩니다">
                </div>

                <input type="hidden" id="latitude" name="latitude">
                <input type="hidden" id="longitude" name="longitude">

                <div class="form-group">
                    <label for="images">
                        클래스 이미지 <span>*</span>
                    </label>
                    <input type="file" id="images" name="images" 
                           multiple accept="image/*" required>
                    <small>최소 1개, 최대 8개까지 업로드 가능 (JPG, PNG, GIF / 최대 5MB)</small>
                    <div id="imageError" class="error"></div>
                    <div id="imagePreview" class="image-preview"></div>
                </div>

                <input type="hidden" id="representativeIndex" name="representativeIndex" value="0">

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        ✅ 등록하기
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">
                        ← 취소
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 공통 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/includes/footer.jsp" />

    <script>
        let selectedFiles = [];
        let representativeIndex = 0;

        // 이미지 파일 선택 처리
        document.getElementById('images').addEventListener('change', function (e) {
            const files = Array.from(e.target.files);
            const imageError = document.getElementById('imageError');

            if (files.length < 1) {
                imageError.textContent = '최소 1개의 이미지는 필수입니다.';
                return;
            }
            if (files.length > 8) {
                imageError.textContent = '최대 8개까지만 업로드 가능합니다.';
                return;
            }

            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
            for (let file of files) {
                if (!allowedTypes.includes(file.type)) {
                    imageError.textContent = '지원하지 않는 파일 형식입니다. (jpg, jpeg, png, gif만 허용)';
                    return;
                }
                if (file.size > 5 * 1024 * 1024) {
                    imageError.textContent = '파일 크기는 5MB를 초과할 수 없습니다.';
                    return;
                }
            }

            imageError.textContent = '';
            selectedFiles = files;
            representativeIndex = 0;
            displayImagePreviews();
        });

        // 이미지 미리보기 표시
        function displayImagePreviews() {
            const preview = document.getElementById('imagePreview');
            preview.innerHTML = '';

            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const imageItem = document.createElement('div');
                    imageItem.className = 'image-item' + (index === representativeIndex ? ' representative' : '');
                    imageItem.onclick = () => setRepresentativeImage(index);

                    const representativeLabel = (index === representativeIndex)
                        ? '<div class="representative-label">대표</div>'
                        : '';

                    imageItem.innerHTML =
                        '<img src="' + e.target.result + '" alt="Preview ' + (index + 1) + '">' +
                        representativeLabel +
                        '<button type="button" class="remove-btn" onclick="removeImage(' + index + ')">&times;</button>';

                    preview.appendChild(imageItem);
                };
                reader.readAsDataURL(file);
            });

            updateRepresentativeIndexInput();
        }

        // 대표 이미지 설정
        function setRepresentativeImage(index) {
            representativeIndex = index;
            displayImagePreviews();
        }

        // 이미지 제거
        function removeImage(index) {
            selectedFiles.splice(index, 1);

            if (representativeIndex >= selectedFiles.length) {
                representativeIndex = Math.max(0, selectedFiles.length - 1);
            }

            const dt = new DataTransfer();
            selectedFiles.forEach(file => dt.items.add(file));
            document.getElementById('images').files = dt.files;

            displayImagePreviews();
        }

        // 대표 이미지 인덱스 업데이트
        function updateRepresentativeIndexInput() {
            document.getElementById('representativeIndex').value = representativeIndex;
        }

        // 시간 검증
        function validateTime() {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const timeError = document.getElementById('timeError');

            if (startTime && endTime) {
                if (startTime >= endTime) {
                    timeError.textContent = '종료 시간은 시작 시간보다 늦어야 합니다.';
                    return false;
                } else {
                    timeError.textContent = '';
                    return true;
                }
            }
            return true;
        }

        // 날짜 검증
        function validateDate() {
            const classDate = document.getElementById('classDate').value;
            const dateError = document.getElementById('dateError');

            if (classDate) {
                const selectedDate = new Date(classDate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (selectedDate < today) {
                    dateError.textContent = '수업 날짜는 오늘 이후여야 합니다.';
                    return false;
                } else {
                    dateError.textContent = '';
                    return true;
                }
            }
            return true;
        }

        document.getElementById('startTime').addEventListener('change', validateTime);
        document.getElementById('endTime').addEventListener('change', validateTime);
        document.getElementById('classDate').addEventListener('change', validateDate);

        // 폼 제출 검증
        document.getElementById('registerForm').addEventListener('submit', function (e) {
            const isTimeValid = validateTime();
            const isDateValid = validateDate();

            if (selectedFiles.length < 1) {
                alert('최소 1개의 이미지는 필수입니다.');
                e.preventDefault();
                return false;
            }

            if (!document.getElementById('zipcode').value) {
                alert('주소 검색을 통해 우편번호를 입력해주세요.');
                e.preventDefault();
                return false;
            }

            if (!isTimeValid || !isDateValid) {
                e.preventDefault();
                alert('입력한 정보를 다시 확인해주세요.');
                return false;
            }
        });

        // 주소 검색
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function (data) {
                    document.getElementById('zipcode').value = data.zonecode;
                    let fullAddress = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                    document.getElementById('location').value = fullAddress;

                    document.getElementById('latitude').value = '';
                    document.getElementById('longitude').value = '';
                }
            }).open();
        }
    </script>
</body>
</html>
