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
    <title>memberContent.jsp</title>
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



        <%-- 삭제 버튼--%>
        function deleteFn(memSeq) {

            if (confirm("정말 삭제하시겠습니까?")) {

                var form = document.createElement("form");
                form.setAttribute("method", "post");
                form.setAttribute("action", "${ctx}/member/memberDelete");

                var hiddenField = document.createElement("input");
                hiddenField.setAttribute("type", "hidden");
                hiddenField.setAttribute("name", "memSeq");
                hiddenField.setAttribute("value", memSeq);

                form.appendChild(hiddenField);
                document.body.appendChild(form);
                form.submit();
            }
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


<form action="${ctx}/member/memberUpdate" method="post">

    <table class='table table-bordered' style="width: 700px; margin-left: 400px">

        <%--사원번호 --%>
        <tr>
            <td>사원번호</td>
            <td>
                <input type="text" name="memSeq" value="${member.memSeq}" readonly style="background-color: lightgray; border-color: lightgray">
            </td>
        </tr>

        <%--<tr>
           <td>사진나중에</td>
            <td> <input type="text" name="memImg" value="${member.memImg}"/>
            <input type="submit" value="첨부" class="btn btn-primary"/>
             </td>
        </tr>--%>

        <tr>
            <td style="width: 150px"><span class="redStar">*</span>아이디</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="memId" name="memId" value="${member.memId}" placeholder="7-16자 소문자+숫자" required/>
                <span id="idError" style="color: red; font-size: 10px; display: none; margin-left: 10px;">7-16자 소문자+숫자로 입력하세요.</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>비밀번호</td>
            <td style="display: flex; align-items: center;">
                <input type="password" id="memPw" name="memPw" value="${member.memPw}" placeholder=" 7-16자 소문자+특수+숫자"
                required/>
                <span id="pwError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">7-16자 소문자+특수+숫자로 입력하세요.</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>비밀번호확인</td>
            <td style="display: flex; align-items: center;">
                <input type="password" id="memPwConfirm" name="memPwConfirm" value="${member.memPw}" placeholder="7-16자
                       소문자+특수+숫자" required/>
                <span id="pwConfirmError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">비밀번호가 일치하지 않습니다.</span>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>사원명</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="memNm" name="memNm" value="${member.memNm}" placeholder="한글 2~10자" required/>
                <span id="nameError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">한글 2~10자로 입력하세요.</span>
            </td>
        </tr>

        <tr>
            <td>생년월일</td>
            <td><input type="date" name="memBirth"
                       value="<fmt:formatDate value='${member.memBirth}' pattern='yyyy-MM-dd'/>" /></td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>입사일</td>
            <td><input type="date" name="memHireDate"
                       value="<fmt:formatDate value='${member.memHireDate}' pattern='yyyy-MM-dd'/>" required/></td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>직급</td>
            <td>
                <select name="memRaCd" required>
                    <option value="">선택</option>
                    <c:forEach var="rank" items="${ranks}">
                        <option value="${rank.dtlCd}" ${member.raCdNm == rank.dtlCdNm ? 'selected="selected"' : ''}>
                                ${rank.dtlCdNm} <%--실제로 값 보여주는 코드--%>
                                <%-- 1 or name=사장--%>
                                <%--저장된 값을 가져와야해. a--%>
                        </option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>부서</td>
            <td>
                <select name="memDpCd" required>
                    <option value="">선택</option>
                    <c:forEach var="department" items="${departments}">
                        <option value="${department.dtlCd}"
                            ${member.dpCdNm == department.dtlCdNm ? 'selected="selected"' : ''}>
                                ${department.dtlCdNm} <%--실제로 값 보여주는 코드--%>
                        </option>
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
                        <option value="${devField.dtlCd}"
                            ${member.dvCdNm == devField.dtlCdNm ? 'selected="selected"' : ''}>
                                ${devField.dtlCdNm}
                        </option>
                    </c:forEach>
                </select>
            </td>
        </tr>


        <tr>
            <td>보유기술</td>
            <td>
                <c:forEach var="skill" items="${skillList}">
                    <input type="checkbox" name="memSkills" value="${skill.dtlCd}"
                        ${fn:contains(member.memSkills, skill.dtlCd) ? 'checked="checked"' : ''}/>
                    ${skill.dtlCdNm} <br/>
                </c:forEach>
            </td>
        </tr>


        <tr>
            <td>주소</td>
            <td>
                <input type="text" id="memPostCode" name="memPostCode" placeholder="우편번호" readonly="readonly"
                       value="${member.memPostCode}">
                <input type="button" onclick="daumPost()" value="우편번호 찾기"><br>
                <input type="text" id="memAddr" name="memAddr" placeholder="주소" value="${member.memAddr}"><br>
                <input type="text" id="memDetailAddr" name="memDetailAddr" placeholder="상세주소"
                       value="${member.memDetailAddr}"><br>
                <input type="text" id="memExtraAddr" name="memExtraAddr" placeholder="참고항목"
                       value="${member.memExtraAddr}">
            </td>
        </tr>


        <tr>
            <td>이메일</td>
            <td><input type="text" name="memEmail" value="${member.memEmail}"/></td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>전화번호</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="memPhone" name="memPhone" value="${member.memPhone}" placeholder="0100000000"
                required maxlength="20"/>
                <span id="phoneError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">숫자 10~12자리로 입력하세요.</span>
            </td>
        </tr>


        <%--저장 삭제 버튼--%>
        <tr>
            <td colspan="2" align="right">
                <p style="color: red">*는 필수 입력 항목</p>
                <input type="submit" value="저장" class='btn btn-success' onclick="validate()"/>
                <input type="button" value="삭제" class="btn btn-warning" onclick="deleteFn(${member.memSeq})"/>
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

    function validate() {
        alert("수정이 완료되었습니다.");
        return true;  // 유효성 조건을 다 만족했을때 폼을 정상적으로 제출
    }

</script>


</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>