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


<form action="${ctx}/project/projectInsert" method="post">

    <table class="table table-bordered" style="width: 700px; margin-left: 400px">


        <%--프로젝트 번호 생략--%>


        <tr>
            <td style="width: 150px"><span class="redStar">*</span>프로젝트명</td>
            <td style="display: flex; align-items: center;">
                <input type="text" id="prjNm" name="prjNm" placeholder="모든 문자 포함 30자" required/>
                <span id="nameError" class="error-message"
                      style="color: red; font-size: 10px; display: none; margin-left: 10px;">30자 안으로 입력하세요.</span>
            </td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>고객사명</td>
            <td>
                <select name="custCd" required>
                    <option value="">선택</option>
                    <c:forEach var="customer" items="${customers}">
                        <option value="${customer.dtlCd}">${customer.dtlCdNm}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>


        <tr>
            <td><span class="redStar">*</span>시작일</td>
            <td style="display: flex; align-items: center;">
                <input type="date" id="prjStDt" name="prjStDt" required/>
            </td>
        </tr>

        <tr>
            <td><span class="redStar">*</span>종료일</td>
            <td style="display: flex; align-items: center;">
                <input type="date" id="prjEdDt" name="prjEdDt" required/>
            </td>
        </tr>


        <tr>
            <td>필요기술</td>
            <td>
                <c:forEach var="skill" items="${skills}">
                    <input type="checkbox" name="prjSkills" value="${skill.dtlCd}"/> ${skill.dtlCdNm} <br/>
                </c:forEach>
            </td>
        </tr>

        <tr>
            <td>특이사항</td>
            <td style="display: flex; align-items: center; ">
                <input type="text" id="prjDtl" name="prjDtl" placeholder="" style="width: 530px"/>
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


    // 프로젝트 명
    document.getElementById('prjNm').addEventListener('input', function () {
        var prjNm = this.value;
        var pattern = /^.{1,30}$/; // 모든 문자 포함 30
        if (prjNm.match(pattern)) {
            document.getElementById('nameError').style.display = 'none';
        } else {
            document.getElementById('nameError').style.display = 'block';
        }
    });


   /* function validate() {
        alert("등록이 완료되었습니다.");  // 간단한 alert 메시지
        return true;  // 폼을 정상적으로 제출
    }*/

    // 폼 제출 시 유효성 검사
    document.querySelector('form').addEventListener('submit', function (e) {
        var prjNm = document.getElementById('prjNm').value;
        var pattern = /^.{1,30}$/; // 모든 문자 포함 30

        // 프로젝트 명이 유효하지 않으면 제출 중지
        if (!prjNm.match(pattern)) {
            e.preventDefault();  // 제출 중단
            document.getElementById('nameError').style.display = 'block';  // 에러 메시지 표시
        } else {
            alert("등록이 완료되었습니다.");  // 유효하면 alert 표시
        }
    });

</script>

</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>
