<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>


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
            form[0].reset(); // 모든 입력 필드를 초기화
            window.location.href = form.action; // 기본 URL로 리다이렉트
        }

        /*검색 유효성*/
        function validateForm() {

            var prjNm = document.querySelector('input[name="prjNm"]').value;
            if (!prjNm.trim()) {
                alert("프로젝트명을 입력해주세요.");
                return false; // 폼 제출 중지
            }
            return true; // 폼 제출
        }


        // 체크박스
        $(function(){
            var chkObj = document.getElementsByName("RowCheck");
            var rowCnt = chkObj.length;

            $("input[name='allCheck']").click(function(){
                var chk_listArr = $("input[name='RowCheck']");
                for (var i=0; i<chk_listArr.length; i++){
                    chk_listArr[i].checked = this.checked;
                }
            });
            $("input[name='RowCheck']").click(function(){
                if($("input[name='RowCheck']:checked").length == rowCnt){
                    $("input[name='allCheck']")[0].checked = true;
                }
                else{
                    $("input[name='allCheck']")[0].checked = false;
                }
            });
        });
    </script>

</head>
<body>




<%--검색창--%>
<form action="${ctx}/member/memberPopup" method="get" onsubmit="return validateForm()">

    <input type="hidden" name="memSeq" value="${member}"><%--이게 있어야지 사원번호 불러옴--%>

    <table class="table table-bordered" style="width: 900px; margin-left: 20px; margin-top: 20px">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div class="d-flex justify-content-between align-items-center">

                    <span style="margin-right: 10px;">*프로젝트명
                        <input type="text" name="prjNm" value="${param.prjNm}"/>
                    </span>

                    <span>고객사명
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


                    <input type="reset" value="초기화" class="btn-danger" onclick="resetForm()">
                    <input type="submit" value="조회" class='btn btn-success'/>

                </div>
            </td>
        </tr>
    </table>
</form>





<%--프로젝트 목록--%>
<form id="projectForm" action="${ctx}/member/memberProjectAdd" method="post">

<input type="hidden" name="memSeq" value="${member}"><%--이게 있어야지 사원번호 불러옴--%>

<table class="table table-bordered" style="width: 900px; margin-left: 20px;">

    <%--리스트--%>
    <tr style="text-align: center">
        <td style="width: 10px;"><input id="allCheck" type="checkbox" name="allCheck"/></td>
        <td style="width: 70px;">프로젝트번호</td>
        <td style="width: 100px;">프로젝트명</td>
        <td style="width: 100px;">고객사명</td>
        <td style="width: 70px;">시작일</td>
        <td style="width: 70px;">종료일</td>
        <td style="width: 100px;">특이사항</td>
    </tr>


    <c:choose>

        <c:when test="${empty projects}">
            <tr >
                <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                    조회된 프로젝트가 없습니다</td>
            </tr>
        </c:when>

        <c:otherwise>


    <c:forEach var="project" items="${projects}">
        <tr style="text-align: center">
            <td><input name="RowCheck" type="checkbox" value="${project.prjSeq}"/></td>
            <td>${project.prjSeq}</td>
            <td>${project.prjNm}</td>
            <td>${project.custCdNm}</td>
            <td><fmt:formatDate value="${project.prjStDt}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${project.prjEdDt}" pattern="yyyy-MM-dd"/></td>
            <td>${project.prjDtl}</td>
        </tr>
    </c:forEach>




      </c:otherwise>

  </c:choose>


    <%--저장 삭제 버튼--%>

    <td colspan="7" align="right">
        <input type="button" value="추가" class='btn btn-success' onclick="submitAndClose()"/>
    </td>


</table>
</form>

<script type="text/javascript">

    function submitAndClose() {

        // 폼을 비동기로 제출
        // 폼 [0] => [1] !!! 폼 순서!!!! (gpt가 선호)
        // 보통은 form id="projectForm" 로 id 지정하고 getElementById 로 걸어버림 (지금 한 버전)
        var form = document.getElementById('projectForm'); // input의 첫번째 form(memseq)를 선택
        var formData = new FormData(form);

        fetch(form.action, {
            method: form.method,
            body: formData

        }).then(() => {
            // 부모 창에서 리다이렉트 실행
            window.opener.location.href = "/member/memberProject?memSeq=" + form.memSeq.value;
            window.close(); // 팝업 창 닫기
        });
    }
</script>



</body>
</html>



