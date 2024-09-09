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


</head>
<body>


<form action="${ctx}/member/memberUpdate" method="post">

    <table class='table table-bordered' style="width: 700px; margin-left: 400px">

        <%--사원번호 --%>
        <tr>
            <td>*사원번호</td>
            <td><input type="text" name="memSeq" value="${member.memSeq}" readonly></td>
        </tr>

        <%--<tr>
           <td>사진나중에</td>
            <td> <input type="text" name="memImg" value="${member.memImg}"/>
            <input type="submit" value="첨부" class="btn btn-primary"/>
             </td>
        </tr>--%>

        <tr>
            <td>*아이디</td>
            <td><input type="text" name="memId" value="${member.memId}"/></td>
        </tr>

        <tr>
            <td>*비밀번호</td>
            <td><input type="password" name="memPw" value="${member.memPw}"/></td>
        </tr>

        <tr>
            <td>*비밀번호확인</td>
            <td><input type="password" name="memPwConfirm" value="${member.memPw}"/></td>
        </tr>

        <tr>
            <td>*사원명</td>
            <td><input type="text" name="memNm" value="${member.memNm}"/></td>
        </tr>

        <tr>
            <td>생년월일</td>
            <td><input type="date" name="memBirth"
                       value="<fmt:formatDate value='${member.memBirth}' pattern='yyyy-MM-dd'/>" required/></td>
        </tr>

        <tr>
            <td>*입사일</td>
            <td><input type="date" name="memHireDate"
                       value="<fmt:formatDate value='${member.memHireDate}' pattern='yyyy-MM-dd'/>" required/></td>
        </tr>


        <tr>
            <td>직급</td>
            <td>
                <select name="memRaCd" required>
                    <option value="">선택</option>
                    <c:forEach var="rank" items="${ranks}">
                        <option value="${rank.dtlCd}"
                            ${member.raCdNm == rank.dtlCdNm ? 'selected="selected"' : ''}>
                                ${rank.dtlCdNm}
                                <%-- 1 or name=사장--%>
                                <%--저장된 값을 가져와야해. a--%>
                        </option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <tr>
            <td>부서</td>
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
                <select name="memDvCd" required>
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
            <td>*전화번호</td>
            <td><input type="text" name="memPhone" value="${member.memPhone}"/></td>
        </tr>


        <%--저장 삭제 버튼--%>
        <tr>
            <td colspan="2" align="right">
                <input type="submit" value="저장" class='btn btn-success'/>
                <input type="button" value="삭제" class="btn btn-warning" onclick="deleteFn(${member.memSeq})"/>
            </td>
        </tr>

    </table>
</form>

</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>