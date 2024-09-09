<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="path" value="${ pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>common/header.jsp</title>

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Popper JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- jquery -->
    <script src="${ path }/resources/js/jquery-3.6.0.min.js"></script>



</head>

<body>

<header>
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #74be82;">

        <h1>Basic</h1>

        <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item" style="margin-left: 500px;">
                    <a class="nav-link" href="${path}/member/memberList">사원관리</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/member/memberList.jsp">프로젝트관리</a>
                </li>
            </ul>
        </div>

    </nav>
</header>

</body>

</html>