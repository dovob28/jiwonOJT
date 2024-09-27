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
    <title>Member List</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css'>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js'></script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"
            integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"
            integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"
            crossorigin="anonymous"></script>


    <script>
        /*초기화 버튼*/
        function resetForm() {

            // 폼의 모든 필드를 비우고 기본 URL로 리다이렉트
            var form = document.querySelector('form');
            form.reset(); // 모든 입력 필드를 초기화
            window.location.href = form.action; // 기본 URL로 리다이렉트
        }

        /*검색 유효성*/
        // 프로제트
        function validateForm() {

            var prjNm = document.querySelector('input[name="prjNm"]').value;
            if (!prjNm.trim()) {
                alert("프로젝트명을 입력해주세요.");
                return false; // 폼 제출 중지
            }
            return true; // 폼 제출
        }

        // 날짜
        function validateDates() {
            var startPrjStDt = new Date(document.getElementById("startPrjStDt").value);
            var endPrjStDt = new Date(document.getElementById("endPrjStDt").value);
            var startPrjEdDt = new Date(document.getElementById("startPrjEdDt").value);
            var endPrjEdDt = new Date(document.getElementById("endPrjEdDt").value);

            // 조건 1: endPrjEdDt는 startPrjEdDt, endPrjStDt, startPrjStDt를 넘을 수 없다.
            if (endPrjEdDt < startPrjEdDt || endPrjEdDt < endPrjStDt || endPrjEdDt < startPrjStDt) {
                alert("종료일의 종료일은 시작일의 종료일 또는 그 이전 날짜들을 넘을 수 없습니다.");
                document.getElementById('endPrjEdDt').value = '';
            }

            // 조건 2: startPrjEdDt는 endPrjStDt, startPrjStDt를 넘을 수 없다.
            if (startPrjEdDt < endPrjStDt || startPrjEdDt < startPrjStDt) {
                alert("종료일의 시작일은 시작일의 종료일 또는 시작일을 넘을 수 없습니다.");
                document.getElementById('startPrjEdDt').value = '';
            }

            // 조건 3: endPrjStDt는 startPrjStDt를 넘을 수 없다.
            if (endPrjStDt < startPrjStDt) {
                alert("시작일의 종료일은 시작일을 넘을 수 없습니다.");
                document.getElementById('endPrjStDt').value = '';
            }
        }

    </script>


</head>
<body>



<%--검색창--%>
<form action="${ctx}/project/projectList" method="get" onsubmit="return validateForm()">
    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div>

                    <span>프로젝트명
                        <input type="text" name="prjNm" value="${param.prjNm}" placeholder="필수입력 항목입니다."/>
                    </span>


                    <span style="margin-left: 10px;">고객사명
                        <select name="custCd">
                            <option value="">선택</option>
                           <c:forEach var="customer" items="${customers}">
                                <option value="${customer.dtlCd}"
                                        <c:if test="${customer.dtlCd == param.custCd}">selected</c:if>>
                                        ${customer.dtlCdNm}
                                </option>
                           </c:forEach>
                        </select>
                    </span>

                    <br><br>

                    <span>시작일
                        <input type="date" id="startPrjStDt" name="startPrjStDt" value="${param.startPrjStDt}"
                               onchange="validateDates()"/>
                        ~
                        <input type="date" id="endPrjStDt" name="endPrjStDt" value="${param.endPrjStDt}"
                               onchange="validateDates()"/>
                    </span>

                    <span style="margin-left: 10px;">종료일
                        <input type="date" id="startPrjEdDt" name="startPrjEdDt" value="${param.startPrjEdDt}"
                               onchange="validateDates()"/>
                        ~
                        <input type="date" id="endPrjEdDt" name="endPrjEdDt" value="${param.endPrjEdDt}"
                               onchange="validateDates()"/>
                    </span>


                    <input type="reset" value="초기화" class="btn-danger" onclick="resetForm()" style="margin-left: 160px;">
                    <input type="submit" value="조회" class='btn btn-success' style="margin-left: 5px;"/>
                </div>
            </td>
        </tr>
    </table>
</form>



<table class="table table-bordered" style="width: 900px; margin-left: 300px;">


    <td colspan="7" align="right">
        <div class="d-flex justify-content-end align-items-center">

            <%--줄선택--%>
            <div class="dropdown me-2" style="margin-right: 5px">
                <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown"
                        aria-expanded="false">
                    ${pageSize}줄 <%--modelAttribute에서 가져옴--%>
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item"
                           href="?page=1&size=5&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">5줄</a>
                    </li>
                    <li><a class="dropdown-item"
                           href="?page=1&size=10&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">10줄</a>
                    </li>
                    <li><a class="dropdown-item"
                           href="?page=1&size=15&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">15줄</a>
                    </li>
                </ul>
            </div>

            <%--신규 등록 이동--%>
            <input type="button" value="신규등록" class="btn btn-primary"
                   onclick="location.href='${ctx}/project/projectRegister'"/>
        </div>
    </td>


    <%--리스트--%>
    <tr style="text-align: center">
        <td style="width: 100px;">프로젝트번호</td>
        <td style="width: 100px;">프로젝트명</td>
        <td style="width: 100px;">고객사명</td>
        <td style="width: 100px;">시작일</td>
        <td style="width: 100px;">종료일</td>
        <td style="width: 100px;">인원</td>
    </tr>


    <c:choose>

        <%-- 검색을 하지 않았거나 검색 결과가 없는 경우 --%>
        <c:when test="${!beforeSearched || empty projects}">
            <tr>
                <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                    조회된 프로젝트가 없습니다.
                </td>
            </tr>
        </c:when>


        <c:otherwise>

            <c:forEach var="project" items="${projects}">
                <tr style="text-align: center">
                    <td>${project.prjSeq}</td><%--프로젝트 번호--%>
                    <td><a href="${ctx}/project/projectContent?prjSeq=${project.prjSeq}">${project.prjNm}</a></td><%--프로젝트명--%>
                    <td>${project.custCdNm}</td><%--고객사명--%>
                    <td><fmt:formatDate value="${project.prjStDt}" pattern="yyyy-MM-dd"/></td> <%--시작일--%>
                    <td><fmt:formatDate value="${project.prjEdDt}" pattern="yyyy-MM-dd"/></td> <%--종료일--%>
                     <%--인원 관리 버튼--%>
                    <td><input type="button" value="관리" class="btn btn-warning"
                               style="width: 50px; height: 20px; font-size: 9px; font-weight: bolder; padding: 2px 5px;"
                               onclick="location.href='${ctx}/project/projectMember?prjSeq=${project.prjSeq}'">
                    </td>
                </tr>
            </c:forEach>






    <!-- 페이징 버튼 -->
    <td colspan="7" align="center">
        <nav aria-label="Page navigation">
            <ul class="pagination">


                <!-- Previous -->
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link"
                            href="?page=${currentPage - 1}&size=${pageSize}&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">Previous</a>
                    </li>
                </c:if>
                <c:if test="${currentPage == 1}">
                    <li class="page-item disabled">
                        <a class="page-link">Previous</a>
                    </li>
                </c:if>


                <!-- Page numbers -->
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item <c:if test='${currentPage == i}'>active</c:if>">
                        <a class="page-link"
                           href="?page=${i}&size=${pageSize}&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">
                                ${i}
                        </a>
                    </li>
                </c:forEach>


                <!-- Next -->
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${currentPage + 1}&size=${pageSize}&prjNm=${prjNm}&custCd=${custCd}&startPrjStDt=${startPrjStDt}&endPrjStDt=${endPrjStDt}&startPrjEdDt=${startPrjEdDt}&endPrjEdDt=${endPrjEdDt}">Next</a>
                    </li>
                </c:if>
                <c:if test="${currentPage == totalPages}">
                    <li class="page-item disabled">
                        <a class="page-link">Next</a>
                    </li>
                </c:if>

            </ul>
        </nav>
    </td>


        </c:otherwise>

    </c:choose>


</table>


</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>



