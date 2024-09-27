<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param value="title" name="demoTest"/>
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>memberRegister.jsp</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <%-- 다음 주소 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


    <script>
        <%-- 다음 주소 API --%>
        function daumPost() {
            new daum.Postcode({
                oncomplete: function (data) {
                    var addr = '';
                    var extraAddr = ''; // 참고주소변수

                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }

                    // 참고주소
                    if (data.userSelectedType === 'R') {
                        if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                            extraAddr += data.bname;
                        }
                        if (data.buildingName !== '' && data.apartment === 'Y') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if (extraAddr !== '') {
                            extraAddr = ' (' + extraAddr + ')';
                        }
                    }

                    // 값 설정
                    document.getElementById('memPostCode').value = data.zonecode;
                    document.getElementById('memAddr').value = addr;
                    document.getElementById('memDetailAddr').focus();
                    document.getElementById('memExtraAddr').value = extraAddr; // 참고주소
                }
            }).open();
        }



        /* 아이디 중복체크 */
        function memberIdCheck() {

            var memId = $('#memId').val();  // 아이디 입력값

            // 유효성 검사 통과 못해서 아이디 사용 가능하다고 떠서 이부분 추가

            var pattern = /^[a-z0-9]{7,16}$/; // 소문자+숫자 7-16자 유효성 검사 패턴

            // 공백 체크
            if (!memId.trim()) {
                alert("아이디를 입력하세요.");
                return;  // 공백일 경우 Ajax 요청을 보내지 않음
            }

            // 유효성 검사
            if (!memId.match(pattern)) {
                alert("사용 불가한 아이디입니다. 7-16자의 소문자와 숫자로 입력해주세요.");
                return;  // 유효성 검사를 통과하지 못하면 Ajax 요청을 보내지 않음
            }

            console.log("보낼 memId 값: " + memId);  // 값이 제대로 들어오는지 확인


            $.ajax({
                url: "/member/memberIdCheck",  // 정확한 컨트롤러 경로 확인 (앞에 / 추가)
                type: "post",    // POST 방식으로 전달
                data: JSON.stringify({ memId: memId }), // JSON 데이터로 전달
                contentType: "application/json; charset=utf-8",
                dataType: "json", // 서버에서 받을 데이터 타입

                success: function (data) {

                    console.log("서버 응답 데이터: ", data); // 서버에서 오는 응답 확인

                    if (data.idCount > 0) {

                        alert("아이디가 이미 존재합니다. 다른 아이디를 입력해 주세요.");
                        $('#memId').val('');  // 오류 시 입력칸 초기화

                    } else {
                        alert("사용 가능한 아이디입니다.");
                    }
                },
                error: function (xhr, status, error) {

                    console.error("AJAX 요청 실패: ", error); // 오류 로그 확인
                    $('#memId').val('');  // 오류 시 입력칸 초기화
                }
            });
        }

    </script>


    <style>
        input::placeholder {
            font-size: 10px;
        }

        .redStar {
            color: red;
        }
    </style>



</head>
<body>


<form action="${ctx}/member/memberInsert" method="post">

    <table class="table table-bordered" style="width: 700px; margin-left: 400px">


        <%--사원번호 생략--%>

        <%--<tr>
           <td>사진나중에</td>
            <td> <input type="text" name="memImg" value="${member.memImg}"/>
            <input type="submit" value="첨부" class="btn btn-primary"/>
             </td>
        </tr>--%>

        <tr>
            <td style="width: 150px"><span class="redStar">*</span>아이디</td>

            <td style="display: flex; align-items: center;">
                <input type="text" id="memId" name="memId" placeholder="7-16자 소문자+숫자" required/>

                <button type="button" class="chk-btn" onclick="memberIdCheck()" style="margin-left: 5px;">중복확인</button>

                <span id="idError" style="color: red; font-size: 10px; display: none; margin-left: 10px;">7-16자 소문자+숫자로 입력하세요</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>비밀번호</td>
            <td style="display: flex; align-items: center;">
                <input type="password" id="memPw" name="memPw" placeholder="7-16자 소문자+특수+숫자" required/>
                <span id="pwError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">7-16자 소문자+특수+숫자로 입력하세요.</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>비밀번호 확인</td>
            <td style="display: flex; align-items: center;">
                <input type="password" id="memPwConfirm" name="memPwConfirm" placeholder="7-16자 소문자+특수+숫자" required/>
                <span id="pwConfirmError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">비밀번호가 일치하지 않습니다.</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>사원명</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="memNm" name="memNm" placeholder="한글 2~10자" required/>
                <span id="nameError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">한글 2~10자로 입력하세요.</span>
            </td>
        </tr>


        <tr>
            <td>생년월일</td>
            <td><input type="date" id="memBirth" name="memBirth" /></td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>입사일</td>
            <td style="display: flex; align-items: center;">
                <input type="date" id="memHireDate" name="memHireDate" required/>
            </td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>직급</td>
            <td>
                <select name="memRaCd" required>
                    <option value="">선택</option>
                    <c:forEach var="rank" items="${ranks}">
                        <option value="${rank.dtlCd}">${rank.dtlCdNm}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>부서</td>
            <td>
                <select name="memDpCd" required >
                    <option value="">선택</option>
                    <c:forEach var="department" items="${departments}">
                        <option value="${department.dtlCd}">${department.dtlCdNm}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <tr>
            <td>개발분야</td>
            <td>
                <select name="memDvCd" >
                    <option value="">선택</option>
                    <c:forEach var="devField" items="${devFields}">
                        <option value="${devField.dtlCd}">${devField.dtlCdNm}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <tr>
            <td>보유기술</td>
            <td>
                <c:forEach var="skill" items="${skills}">
                    <input type="checkbox" name="memSkills" value="${skill.dtlCd}"/> ${skill.dtlCdNm} <br/>
                </c:forEach>
            </td>
        </tr>


        <tr>
            <td>주소</td>
            <td>
                <input type="text" id="memPostCode" name="memPostCode" placeholder="우편번호" readonly >
                <input type="button" onclick="daumPost()" value="우편번호 찾기"><br>
                <input type="text" id="memAddr" name="memAddr" placeholder="주소" readonly ><br>
                <input type="text" id="memDetailAddr" name="memDetailAddr" placeholder="상세주소" ><br>
                <input type="text" id="memExtraAddr" name="memExtraAddr" placeholder="참고항목">
            </td>
        </tr>

        <tr>
            <td>이메일</td>
            <td>
                <input type="email" id="memEmail" name="memEmail" />
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>전화번호</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="memPhone" name="memPhone" placeholder="' - ' 빼고 입력하세요" required maxlength="20"/>
                <span id="phoneError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">숫자 10~12자리로 입력하세요.</span>
            </td>
        </tr>


        <%--저장 버튼--%>
        <tr>
            <td colspan="2" align="right">
                <p style="color: red">*는 필수 입력 항목</p>
                <input type="submit" value="저장" class="btn btn-success" onclick="validate(this.form);"/>
            </td>
        </tr>

    </table>
</form>


<!-- 유효성 검사 -->
<script>

    // 아이디
    document.getElementById('memId').addEventListener('input', function () {

        var memId = this.value;
        var pattern = /^[a-z0-9]{7,16}$/; // 소문자+숫자 7-16자
        if (memId.match(pattern)) {
            document.getElementById('idError').style.display = 'none';
        } else {
            document.getElementById('idError').style.display = 'block';
        }
    });

    // 비밀번호
    document.getElementById('memPw').addEventListener('input', function () {

        var memPw = this.value;
        var pattern = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[a-z\d!@#$%^&*]{7,16}$/; // 소문자, 숫자, 특수문자 포함 8-16자
        if (memPw.match(pattern)) {
            document.getElementById('pwError').style.display = 'none';
        } else {
            document.getElementById('pwError').style.display = 'block';
        }
    });

    // 비밀번호 확인
    document.getElementById('memPwConfirm').addEventListener('input', function () {

        var memPw = document.getElementById('memPw').value;
        var memPwConfirm = this.value;
        if (memPw === memPwConfirm) {
            document.getElementById('pwConfirmError').style.display = 'none';
        } else {
            document.getElementById('pwConfirmError').style.display = 'block';
        }
    });

    // 이름
    document.getElementById('memNm').addEventListener('input', function () {
        var memNm = this.value;
        var pattern = /^[가-힣]{2,10}$/; // 한글 2-10자
        if (memNm.match(pattern)) {
            document.getElementById('nameError').style.display = 'none';
        } else {
            document.getElementById('nameError').style.display = 'block';
        }
    });

    // 전화번호
    document.getElementById('memPhone').addEventListener('input', function () {
        var memPhone = this.value;
        var pattern = /^\d{10,12}$/; // 숫자 10~12자리
        if (memPhone.match(pattern)) {
            document.getElementById('phoneError').style.display = 'none';
        } else {
            document.getElementById('phoneError').style.display = 'block';
        }
    });

    /*function validate() {
        alert("가입이 완료되었습니다.");  // 간단한 alert 메시지
        return true;  // 유효성 조건을 다 만족했을때 폼을 정상적으로 제출
    }*/

    // 폼 제출 시 유효성 검사
    document.querySelector('form').addEventListener('submit', function (e) {

        var isValid = true; // 폼 유효성 상태 플래그

        // 아이디 유효성 검사
        var memId = document.getElementById('memId').value;
        var idPattern = /^[a-z0-9]{7,16}$/; // 소문자+숫자 7-16자
        if (!memId.match(idPattern)) {
            document.getElementById('idError').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('idError').style.display = 'none';
        }

        // 비밀번호 유효성 검사
        var memPw = document.getElementById('memPw').value;
        var pwPattern = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[a-z\d!@#$%^&*]{7,16}$/; // 소문자, 숫자, 특수문자 포함 7-16자
        if (!memPw.match(pwPattern)) {
            document.getElementById('pwError').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('pwError').style.display = 'none';
        }

        // 비밀번호 확인
        var memPwConfirm = document.getElementById('memPwConfirm').value;
        if (memPw !== memPwConfirm) {
            document.getElementById('pwConfirmError').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('pwConfirmError').style.display = 'none';
        }

        // 이름 유효성 검사
        var memNm = document.getElementById('memNm').value;
        var namePattern = /^[가-힣]{2,10}$/; // 한글 2-10자
        if (!memNm.match(namePattern)) {
            document.getElementById('nameError').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('nameError').style.display = 'none';
        }

        // 전화번호 유효성 검사
        var memPhone = document.getElementById('memPhone').value;
        var phonePattern = /^\d{10,12}$/; // 숫자 10~12자리
        if (!memPhone.match(phonePattern)) {
            document.getElementById('phoneError').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('phoneError').style.display = 'none';
        }

        // 유효성 검사가 실패하면 제출을 중단
        if (!isValid) {
            e.preventDefault();
        } else {
            alert("가입이 완료되었습니다."); // 모든 유효성 검사를 통과하면 alert
        }
    });

</script>


</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>
