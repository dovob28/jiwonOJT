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


       <script type="text/javascript">

        /*초기화 버튼*/
        function resetForm() {

            var form = document.querySelector('form');
            var prjSeqInput = document.querySelector('input[name="prjSeq"]');
            var prjSeq = prjSeqInput.value;

            if (!prjSeq || prjSeq.trim() === "") {
                console.error("Invalid prjSeq value:", prjSeq);
                alert("유효하지 않은 프로젝트 번호입니다. 페이지를 새로고침해 주세요.");
                return;
            }

            // 폼 리셋 (검색 조건 초기화)
            form.reset();

            // prjSeq 값 유지
            prjSeqInput.value = prjSeq;

            // AJAX를 사용하여 서버에 초기화 요청
            fetch(`${form.action}?prjSeq=${prjSeq}`, {
                method: 'GET',
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.text();
                })
                .then(html => {
                    // 전체 페이지 내용 업데이트
                    document.body.innerHTML = html;
                    // 체크박스 이벤트 리스너 재설정
                    setupCheckboxListeners();
                    // prjSeq 값 다시 설정 (페이지 갱신 후)
                    document.querySelector('input[name="prjSeq"]').value = prjSeq;
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('초기화 중 오류가 발생했습니다. 페이지를 새로고침합니다.');
                    window.location.reload();
                });
        }


        /*검색 유효성*/
        function validateForm() {

            var memNm = document.querySelector('input[name="memNm"]').value;
            if (!memNm.trim()) {
                alert("사원명을 입력해주세요.");
                return false; // 폼 제출 중지
            }
            return true; // 폼 제출
        }


        // 체크박스 선택 (컬러)
        function setupCheckboxListeners() {
            var chkObj = document.getElementsByName("RowCheck");
            var rowCnt = chkObj.length;

            // 전체
            $("input[name='allCheck']").click(function () {

                var isChecked = $(this).prop("checked");  // 전체 체크박스의 상태


                // 모든 개별 체크박스의 상태를 변경하고 각 행의 배경 색상 변경
                var chk_listArr = $("input[name='RowCheck']");

                for (var i = 0; i < chk_listArr.length; i++) {
                    chk_listArr[i].checked = isChecked; // 개별 체크박스 상태 동기화

                    var row = $(chk_listArr[i]).closest('tr'); // 개별 체크박스가 속한 행(tr)을 찾음
                    if (isChecked) {
                        row.css("background-color", "#f0f8ff"); // 체크된 경우 배경 색상 변경
                    } else {
                        row.css("background-color", ""); // 체크 해제 시 배경 색상 초기화
                    }
                }
            });

            // 개별
            $("input[name='RowCheck']").click(function () {


                var row = $(this).closest('tr'); // 현재 체크박스가 속한 행을 가져옴

                if ($(this).is(":checked")) {
                    row.css("background-color", "#f0f8ff"); // 체크된 경우 배경 색상 변경 (예: 연한 파란색)
                } else {
                    row.css("background-color", ""); // 체크 해제 시 배경 색상 초기화
                }


                if ($("input[name='RowCheck']:checked").length == rowCnt) {

                    $("input[name='allCheck']")[0].checked = true;
                } else {
                    $("input[name='allCheck']")[0].checked = false;
                }
            });
        }

        // 페이지 로드 시 체크박스 이벤트 리스너 설정
        $(document).ready(function () {
            setupCheckboxListeners();
        });

    </script>

</head>
<body>

<input type="hidden" name="prjSeq" value="${prjSeq}"><%--이게 있어야지 프로젝트 번호 불러옴--%>



<%--검색창--%>
<form action="${ctx}/project/projectPopup" method="get" onsubmit="return validateForm()">

    <input type="hidden" name="prjSeq" value="${prjSeq}"><%--이게 있어야지 사원번호 불러옴--%>

    <table class="table table-bordered" style="width: 900px; margin-left: 20px; margin-top: 20px">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div class="d-flex justify-content-between align-items-center">

                    <span style="margin-right: 10px;">사원명
                        <input type="text" name="memNm" value="${param.memNm}" placeholder="필수입력 항목입니다." />
                    </span>

                    <span>개발분야
                        <select name="memDvCd">
                            <option value="">선택</option>
                            <c:forEach var="devField" items="${devFields}">
                                <option value="${devField.dtlCd}"
                                        <c:if test="${devField.dtlCd == param.memDvCd}">selected</c:if>>
                                        ${devField.dtlCdNm}
                                </option>
                            </c:forEach>
                        </select>
                    </span>


                    <input type="reset" value="초기화" class="btn-danger" onclick="resetForm()" style="margin-left: 315px;">
                    <input type="submit" value="조회" class='btn btn-success'style="margin-left: 10px;"/>

                </div>
            </td>
        </tr>
    </table>
</form>





<%--사원 목록--%>
<form id="projectForm" action="${ctx}/project/projectMemberAdd" method="post">

<input type="hidden" name="prjSeq" value="${prjSeq}"><%--이게 있어야지 프로젝트 번호 불러옴--%>

<table class="table table-bordered" style="width: 900px; margin-left: 20px;">

    <%--리스트--%>
    <tr style="text-align: center">
        <td style="width: 10px;"><input id="allCheck" type="checkbox" name="allCheck"/></td>
        <td style="width: 70px;">사원번호</td>
        <td style="width: 100px;">사원명</td>
        <td style="width: 100px;">개발분야</td>
        <td style="width: 200px;">보유기술</td>
    </tr>


    <c:choose>

        <c:when test="${!beforeSearchedPop || empty members}">
            <tr>
                <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                    조회된 사원이 없습니다
                </td>
            </tr>
        </c:when>


    <c:otherwise>
    <c:forEach var="member" items="${members}">
        <tr style="text-align: center">
            <td><input name="RowCheck" type="checkbox" value="${member.memSeq}"/></td>
            <td>${member.memSeq}</td>
            <td>${member.memNm}</td>
            <td>${member.dvCdNm}</td>

            <td>${member.dtlCdNm}</td> <%--원래 없어서 MemberInfo Dto에 추가--%>
        </tr>
    </c:forEach>
   </c:otherwise>

  </c:choose>


    <%--추가 버튼--%>
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
        var form = document.getElementById('projectForm'); // input의 첫번째 form(prjseq)를 선택
        var formData = new FormData(form);

        fetch(form.action, {
            method: form.method,
            body: formData

        }).then(() => {
            // 부모 창에서 리다이렉트 실행
            window.opener.location.href = "/project/projectMember?prjSeq=" + form.prjSeq.value;
            alert("사원이 추가 되었습니다");
            window.close(); // 팝업 창 닫기
        });
    }
</script>


</body>
</html>

