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
        // 이름
        function validateForm() {

            var memNm = document.querySelector('input[name="memNm"]').value;
            if (!memNm.trim()) {
                alert("사원명을 입력해주세요.");
                return false; // 폼 제출 중지
            }
            return true; // 폼 제출
        }

        // 입사일
        function validateDates() {

            // 요소 가져옴
            const startHireDate = document.getElementById('startHireDate').value;
            const endHireDate = document.getElementById('endHireDate').value;

            // 둘다 입력 됬는지 날짜 유효 검사
            if(startHireDate && endHireDate){

                // end가 start보다 빠르거나 같지 않으면..
                if(new Date(endHireDate) < new Date(startHireDate)){

                    alert('종료일은 시작일보다 빠를 수 없습니다.');
                    // 유효값 입력 시 endHireDate 비움
                    document.getElementById('endHireDate').value = '';
                }
            }

        }



    </script>


</head>
<body>


<%--검색창--%>
<form action="${ctx}/member/memberList" method="get" onsubmit="return validateForm()">
    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div class="d-flex justify-content-between align-items-center">



                    <span>사원명
                        <input type="text" name="memNm" value="${param.memNm}" placeholder="필수입력 항목입니다."/>
                    </span>
                        <!-- 필수 입력 필드 -->


                    <span>입사일
                        <input type="date" id="startHireDate" name="startHireDate" value="${param.startHireDate}"
                               onchange="validateDates()"/>
                        ~
                        <input type="date" id="endHireDate" name="endHireDate" value="${param.endHireDate}"
                               onchange="validateDates()"/>
                    </span>


                    <span>직급
                        <select name="memRaCd">
                            <option value="">선택</option>
                           <c:forEach var="rank" items="${ranks}">
                                <option value="${rank.dtlCd}"
                                        <c:if test="${rank.dtlCd == param.memRaCd}">selected</c:if>>
                                        ${rank.dtlCdNm}
                                </option>
                           </c:forEach>
                        </select>
                    </span>

                    <span>부서
                        <select name="memDpCd">
                            <option value="">선택</option>
                            <c:forEach var="department" items="${departments}">
                                <option value="${department.dtlCd}"
                                        <c:if test="${department.dtlCd == param.memDpCd}">selected</c:if>>
                                        ${department.dtlCdNm}
                                </option>
                            </c:forEach>
                        </select>
                    </span>

                    <input type="reset" value="초기화" class="btn-danger" onclick="resetForm()">
                    <input type="submit" value="조회" class='btn btn-success'/>
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
                           href="?page=1&size=5&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">5줄</a>
                    </li>
                    <li><a class="dropdown-item"
                           href="?page=1&size=10&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">10줄</a>
                    </li>
                    <li><a class="dropdown-item"
                           href="?page=1&size=15&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">15줄</a>
                    </li>
                </ul>
            </div>

            <%--신규 등록 이동--%>
            <input type="button" value="신규등록" class="btn btn-primary"
                   onclick="location.href='${ctx}/member/memberRegister'"/>
        </div>
    </td>


    <%--리스트 목록--%>
    <tr style="text-align: center">
        <td style="width: 100px;">사원번호</td>
        <td style="width: 100px;">아이디</td>
        <td style="width: 100px;">사원명</td>
        <td style="width: 100px;">입사일</td>
        <td style="width: 100px;">직급</td>
        <td style="width: 100px;">부서</td>
        <td style="width: 100px;">프로젝트</td>
    </tr>


    <c:choose>

        <%-- 검색을 하지 않았거나 검색 결과가 없는 경우 --%>
        <c:when test="${!beforeSearched || empty lists}">
            <tr>
                <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                    조회된 사원이 없습니다
                </td>
            </tr>
        </c:when>


        <c:otherwise>
            <c:forEach var="list" items="${lists}">
                <tr style="text-align: center">
                    <td>${list.memSeq}</td>
                    <td>${list.memId}</td>
                    <td><a href="${ctx}/member/memberContent?memSeq=${list.memSeq}">${list.memNm}</a></td>
                    <td><fmt:formatDate value="${list.memHireDate}" pattern="yyyy-MM-dd"/></td>
                    <td>${list.raCdNm}</td> <!-- 직급 코드명 -->
                    <td>${list.dpCdNm}</td> <!-- 부서 코드명 -->
                    <td><input type="button" value="관리" class="btn btn-warning"
                               style="width: 50px; height: 20px; font-size: 9px; font-weight: bolder; padding: 2px 5px;"
                               onclick="location.href='${ctx}/member/memberProject?memSeq=${list.memSeq}'">
                    </td>
                </tr>
            </c:forEach>



    <%--if문 버전--%>
    <%--<c:if test="${!isSearched || empty lists}">
        <tr>
            <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                조회된 사원이 없습니다
            </td>
        </tr>
    </c:if>
    <c:if test="${isSearched && !empty lists}">
        <c:forEach var="list" items="${lists}">
            <tr style="text-align: center">
                <td>${list.memSeq}</td>
                <td>${list.memId}</td>
                <td><a href="${ctx}/member/memberContent?memSeq=${list.memSeq}">${list.memNm}</a></td>
                <td><fmt:formatDate value="${list.memHireDate}" pattern="yyyy-MM-dd"/></td>
                <td>${list.raCdNm}</td> <!-- 직급 코드명 -->
                <td>${list.dpCdNm}</td> <!-- 부서 코드명 -->
                <td><input type="button" value="관리" class="btn btn-warning"
                           style="width: 50px; height: 20px; font-size: 9px; font-weight: bolder; padding: 2px 5px;"
                           onclick="location.href='${ctx}/member/memberProject?memSeq=${list.memSeq}'">
                </td>
            </tr>
        </c:forEach>
    </c:if>--%>



    <%--페이징--%>
    <td colspan="7" align="center">
        <nav aria-label="Page navigation">
            <ul class="pagination">


                <!-- Previous -->
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${currentPage - 1}&size=${pageSize}&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">Previous</a>
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
                           href="?page=${i}&size=${pageSize}&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">
                                ${i}
                        </a>
                    </li>
                </c:forEach>


                <!-- Next  -->
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${currentPage + 1}&size=${pageSize}&memNm=${memNm}&memRaCd=${memRaCd}&memDpCd=${memDpCd}&startHireDate=${startHireDate}&endHireDate=${endHireDate}">Next</a>
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



