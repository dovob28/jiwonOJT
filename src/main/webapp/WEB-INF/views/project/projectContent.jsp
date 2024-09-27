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


    <script>

        <%-- 삭제 버튼--%>

        function deleteFn(prjSeq) {

            if (confirm("정말 삭제하시겠습니까?")) {

                var form = document.createElement("form");
                form.setAttribute("method", "post");
                form.setAttribute("action", "${ctx}/project/projectDelete");

                var hiddenField = document.createElement("input");
                hiddenField.setAttribute("type", "hidden");
                hiddenField.setAttribute("name", "prjSeq");
                hiddenField.setAttribute("value", prjSeq);

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


<form action="${ctx}/project/projectUpdate" method="post">

    <table class='table table-bordered' style="width: 700px; margin-left: 400px">

        <%--프로젝트번호 --%>
        <tr>
            <td>프로젝트번호</td>
            <td>
                <input type="text" name="prjSeq" value="${project.prjSeq}" readonly
                       style="background-color: lightgray; border-color: lightgray">
            </td>
        </tr>


        <tr>
            <td style="width: 150px"><span class="redStar">*</span>프로젝트명</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="prjNm" name="prjNm" value="${project.prjNm}" placeholder="한글 4~15자" required/>
                <span id="nameError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">한글 4~15자로 입력하세요.</span>
            </td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>고객사명</td>
            <td>
                <select name="custCd" required>
                    <option value="">선택</option>
                    <c:forEach var="customer" items="${customers}">
                        <option value="${customer.dtlCd}" ${project.custCdNm == customer.dtlCdNm ? 'selected="selected"' : ''}>
                                ${customer.dtlCdNm} <%--실제로 값 보여주는 코드--%>
                        </option>
                    </c:forEach>
                </select>
            </td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>시작일</td>
            <td><input type="date" name="prjStDt" required
                       value="<fmt:formatDate value='${project.prjStDt}' pattern='yyyy-MM-dd'/>" /></td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>종료일</td>
            <td><input type="date" name="prjEdDt" required
                       value="<fmt:formatDate value='${project.prjEdDt}' pattern='yyyy-MM-dd'/>" /></td>
        </tr>


        <tr>
            <td>필요기술</td>
            <td>
                <c:forEach var="skill" items="${skillList}">
                    <input type="checkbox" name="prjSkills" value="${skill.dtlCd}"
                        ${fn:contains(project.prjSkills, skill.dtlCd) ? 'checked="checked"' : ''}/>
                    ${skill.dtlCdNm} <br/>
                </c:forEach>
            </td>
        </tr>

            <tr>
                <td>특이사항</td>
                <td style="display: flex; align-items: center; ">
                    <input type="text" id="prjDtl" name="prjDtl" value="${project.prjDtl}" placeholder="" style="width: 530px"/>
                </td>
            </tr>


        <%--저장 삭제 버튼--%>
        <tr>
            <td colspan="2" align="right">
                <p style="color: red">*는 필수 입력 항목</p>
                <input type="submit" value="저장" class='btn btn-success' onclick="validate()"/>
                <input type="button" value="삭제" class="btn btn-warning" onclick="deleteFn(${project.prjSeq})"/>
            </td>
        </tr>

    </table>
</form>


<!-- 유효성 검사 -->
<script>

    // 프로젝트 명
    document.getElementById('prjNm').addEventListener('input', function () {
        var prjNm = this.value;
        var pattern = /^[가-힣]{4,15}$/; // 한글 4-15자
        if (prjNm.match(pattern)) {
            document.getElementById('nameError').style.display = 'none';
        } else {
            document.getElementById('nameError').style.display = 'block';
        }
    });

    function validate() {
        alert("수정이 완료되었습니다.");
        return true;  // 폼을 정상적으로 제출
    }

</script>


</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>
