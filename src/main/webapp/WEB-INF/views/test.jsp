
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>memberList.jsp</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css'>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js'></script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>


</head>
<body>



<!--Login form starts-->
<section class="container-fluid" style="margin-top: 100px; margin-bottom: 100px;">
    <!--row justify-content-center is used for centering the login form-->
    <section class="row justify-content-center">
        <!--Making the form responsive-->
        <section class="col-12 col-sm-6 col-md-4">

            <form class="form-container">

                <!--Binding the label and input together-->
                <div class="form-group">
                    <h4 class="text-center font-weight-bold" style="margin-bottom: 30px;"> 로그인</h4>
                    <label for="Inputuser1">아이디</label>
                    <input type="email" class="form-control" id="Inputuser1" aria-describeby="usernameHelp" placeholder="아이디">
                </div>

                <!--Binding the label and input together-->
                <div class="form-group">
                    <label for="InputPassword1">비밀번호</label>
                    <input type="password" class="form-control" id="InputPassword1" placeholder="비밀번호">
                </div>

                <button type="Sign in" class="btn btn-primary btn-block">로그인</button>

                <div class="form-footer">
                    <p style="font-size: 11px; margin-top: 5px;"> 아이디가 없다면?
                        <a href="#" >회원가입</a>
                    </p>
                </div>
            </form>
        </section>
    </section>
</section>



</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</html>