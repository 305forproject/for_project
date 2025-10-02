<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>클래스 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input, textarea, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        textarea {
            height: 80px;
            resize: vertical;
        }

        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .btn-cancel {
            background-color: #6c757d;
            margin-left: 10px;
        }

        .btn-cancel:hover {
            background-color: #545b62;
        }

        .error {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }

        .image-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }

        .image-item {
            position: relative;
            width: 100px;
            height: 100px;
            border: 2px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }

        .image-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-item.representative {
            border-color: #007bff;
            border-width: 3px;
        }

        .representative-label {
            position: absolute;
            top: 0;
            left: 0;
            background: #007bff;
            color: white;
            padding: 2px 6px;
            font-size: 10px;
        }

        .remove-btn {
            position: absolute;
            top: -5px;
            right: -5px;
            background: red;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            cursor: pointer;
            font-size: 12px;
        }
    </style>
</head>
<body>
<h1>클래스 등록</h1>
<p>Context Path: ${pageContext.request.contextPath}</p>

<form method="post" action="${pageContext.request.contextPath}/teachers/classes/register"
      id="registerForm" enctype="multipart/form-data">
    <div class="form-group">
        <label for="className">클래스명:</label>
        <input type="text" id="className" name="className" required>
    </div>

    <div class="form-group">
        <label for="description">설명:</label>
        <textarea id="description" name="description" required></textarea>
    </div>

    <div class="form-group">
        <label for="categoryId">카테고리:</label>
        <select id="categoryId" name="categoryId" required>
            <option value="">카테고리 선택</option>
            <option value="1">요리</option>
            <option value="2">미술</option>
            <option value="3">운동</option>
        </select>
    </div>

    <div class="form-group">
        <label for="classDate">수업 날짜:</label>
        <input type="date" id="classDate" name="classDate" required>
        <div id="dateError" class="error"></div>
    </div>

    <div class="form-group">
        <label for="startTime">시작 시간:</label>
        <input type="time" id="startTime" name="startTime" required>
        <div id="timeError" class="error"></div>
    </div>

    <div class="form-group">
        <label for="endTime">종료 시간:</label>
        <input type="time" id="endTime" name="endTime" required>
    </div>

    <div class="form-group">
        <label for="maxStudents">최대 학생 수:</label>
        <input type="number" id="maxStudents" name="maxStudents" min="1" max="50" required>
    </div>

    <div class="form-group">
        <label for="price">수업료 (원):</label>
        <input type="number" id="price" name="price" min="0" required>
    </div>

    <div class="form-group">
        <label for="location">수업 장소:</label>
        <input type="text" id="location" name="location" required>
    </div>

    <div class="form-group">
        <label for="images">이미지 업로드 (최소 1개, 최대 8개):</label>
        <input type="file" id="images" name="images" multiple accept="image/*" required>
        <div id="imageError" class="error"></div>
        <div id="imagePreview" class="image-preview"></div>
    </div>

    <input type="hidden" id="representativeIndex" name="representativeIndex" value="0">

    <div style="margin-top: 30px;">
        <button type="submit" class="btn">등록하기</button>
        <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
    </div>
</form>

<script>
    let selectedFiles = [];
    let representativeIndex = 0;

    // 이미지 파일 선택 시 처리
    document.getElementById('images').addEventListener('change', function (e) {
        const files = Array.from(e.target.files);
        const imageError = document.getElementById('imageError');

        // 파일 개수 검증
        if (files.length < 1) {
            imageError.textContent = '최소 1개의 이미지는 필수입니다.';
            return;
        }
        if (files.length > 8) {
            imageError.textContent = '최대 8개까지만 업로드 가능합니다.';
            return;
        }

        // 파일 형식 검증
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
        representativeIndex = 0; // 첫 번째 이미지를 기본 대표 이미지로 설정
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

                imageItem.innerHTML = `
                        <img src="${e.target.result}" alt="Preview ${index + 1}">
                        ${index === representativeIndex ? '<div class="representative-label">대표</div>' : ''}
                        <button type="button" class="remove-btn" onclick="removeImage(${index})">&times;</button>
                    `;

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

        // 대표 이미지 인덱스 조정
        if (representativeIndex >= selectedFiles.length) {
            representativeIndex = Math.max(0, selectedFiles.length - 1);
        }

        // 파일 입력 업데이트
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        document.getElementById('images').files = dt.files;

        displayImagePreviews();
    }

    // 대표 이미지 인덱스 히든 필드 업데이트
    function updateRepresentativeIndexInput() {
        document.getElementById('representativeIndex').value = representativeIndex;
    }

    // 실시간 시간 검증
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

    // 실시간 날짜 검증
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

    // 이벤트 리스너 등록
    document.getElementById('startTime').addEventListener('change', validateTime);
    document.getElementById('endTime').addEventListener('change', validateTime);
    document.getElementById('classDate').addEventListener('change', validateDate);

    // 폼 제출 시 최종 검증
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        const isTimeValid = validateTime();
        const isDateValid = validateDate();

        if (selectedFiles.length < 1) {
            alert('최소 1개의 이미지는 필수입니다.');
            e.preventDefault();
            return false;
        }

        if (!isTimeValid || !isDateValid) {
            e.preventDefault();
            alert('입력한 정보를 다시 확인해주세요.');
            return false;
        }
    });
</script>
</body>
</html>
