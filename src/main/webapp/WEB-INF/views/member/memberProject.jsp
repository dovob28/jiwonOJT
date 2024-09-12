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


    <script type="text/javascript">

        <%--팝업창--%>
        /*function popUp(){
            // open("경로", "이름", "옵션")
            window.open("/member/memberPopup", "memberPopup", "width=900px, height=600, left=400, top=100" );
        }*/
        function popUp() {
            var width = 950;
            var height = 600;
            var left = (window.screen.width / 2) - (width / 2);
            var top = (window.screen.height / 2) - (height / 2);

            window.open("/member/memberPopup?memSeq=${member.memSeq}", "memberPopup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
        }



        // 체크박스
        $(function () {
            var chkObj = document.getElementsByName("RowCheck");
            var rowCnt = chkObj.length;

            $("input[name='allCheck']").click(function () {
                var chk_listArr = $("input[name='RowCheck']");
                for (var i = 0; i < chk_listArr.length; i++) {
                    chk_listArr[i].checked = this.checked;
                }
            });

            $("input[name='RowCheck']").click(function () {
                if ($("input[name='RowCheck']:checked").length == rowCnt) {
                    $("input[name='allCheck']")[0].checked = true;
                } else {
                    $("input[name='allCheck']")[0].checked = false;
                }
            });
        });



        // 체크 삭제
        function deleteValue() {
            let groupList = [];

            // 체크된 항목들의 값을 배열로 모읍니다.
            $(".chkGrp:checked").each(function (idx, item) {
                groupList.push(item.value);
            });

            // 삭제할 항목이 없다면 경고
            if (groupList.length === 0) {
                alert("삭제할 항목을 선택하세요.");
                return;
            }

            // Ajax로 삭제 요청을 보냄
            $.ajax({
                url: '/member/memberProjectDelete',
                method: 'POST',
                data: {chkList: groupList, memSeq: $("input[name='memSeq']").val()},  // 배열과 memSeq를 함께 전송
                traditional: true,  // 배열을 쿼리 스트링으로 전송
                success: function (response) {
                    alert("삭제가 완료되었습니다.");
                    window.location.reload();  // 페이지 새로고침
                },
                error: function () {
                    alert("삭제 중 오류가 발생했습니다.");
                }
            });
        }




        // 사원 프로젝트 리스트 체크 수정
        function updateValue() {
            let groupList = [];  // 선택된 체크박스의 project ID 값 배열
            let prjInDtList = [];  // 프로젝트 시작일 배열
            let prjOutDtList = [];  // 프로젝트 종료일 배열
            let prjRoCdList = [];  // 역할 코드 배열

            // 체크된 항목들의 값을 배열로 모음
            $(".chkGrp:checked").each(function (idx, item) {
                groupList.push(item.value);  // 체크박스의 value (project ID) 추가

                // 각 체크된 항목에 대응하는 prjInDt, prjOutDt, prjRoCd 값을 배열에 추가
                let prjInDt = $(item).closest('tr').find("input[name='prjInDt']").val();
                let prjOutDt = $(item).closest('tr').find("input[name='prjOutDt']").val();
                let prjRoCd = $(item).closest('tr').find("select[name='prjRoCd']").val();

                // 디버깅용 로그
                console.log(`prjInDt: ${prjInDt}, prjOutDt: ${prjOutDt}, prjRoCd: ${prjRoCd}`);

                prjInDtList.push(prjInDt);  // 각각의 값을 배열에 추가
                prjOutDtList.push(prjOutDt);
                prjRoCdList.push(prjRoCd);
            });

            // 체크된 항목이 없으면 경고
            if (groupList.length === 0) {
                alert("수정할 항목을 선택하세요.");
                return;
            }

            // Ajax 요청을 통해 서버로 수정 데이터를 전송
            $.ajax({
                url: '/member/memberProjectUpdate',  // 데이터 전송할 URL
                method: 'POST',  // POST 방식으로 전송
                data: {
                    chkList: groupList,  // 선택된 항목 리스트 (project ID 리스트)
                    memSeq: $("input[name='memSeq']").val(),  // 멤버 시퀀스 (hidden input에서 가져옴)

                    prjInDtList: prjInDtList,  // 프로젝트 시작일 리스트
                    prjOutDtList: prjOutDtList,  // 프로젝트 종료일 리스트
                    prjRoCdList: prjRoCdList  // 역할 코드 리스트
                },
                traditional: false,  // 배열을 개별 쿼리스트링으로 전송

                success: function (response) {
                    alert("수정 완료되었습니다.");
                    window.location.reload();  // 성공 시 페이지 새로고침
                },
                error: function (xhr, status, error) {
                    console.error("Error during update:", status, error);  // 오류 로그 출력
                    alert("수정 중 오류가 발생했습니다.");
                }

            });console.log('prjInDtList: ',prjInDtList, 'prjOutDtList: ', prjOutDtList, 'prjRoCdList: ', prjRoCdList);
        }


    </script>

</head>


<%--<form action="${ctx}/member/memberProjectUpdate" method="post">--%>


    <%--리드온니--%>
    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div class="d-flex justify-content-left align-items-center">
                    <span style="margin-right: 10px;">사원번호 <input type="text" name="memSeq" value="${member.memSeq}"
                                                                  readonly></span>
                    <span>사원명 <input type="text" name="memNm" value="${member.memNm}" readonly/></span>
                </div>
            </td>
        </tr>
    </table>


    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">


        <td colspan="7" align="right">
            <div class="d-flex justify-content-end align-items-center">

                <%--프로젝트 추가 팝업버튼--%>
                <input type="button" value="프로젝트 추가" class="btn btn-primary"
                       onclick="popUp()"/>

            </div>
        </td>


        <%--리스트--%>
        <tr style="text-align: center">
            <td style="width: 10px;"><input id="allCheck" type="checkbox" name="allCheck"/></td>
            <td style="width: 100px;">프로젝트번호</td>
            <td style="width: 100px;">프로젝트명</td>
            <td style="width: 100px;">고객사명</td>
            <td style="width: 100px;">투입일</td>
            <td style="width: 100px;">철수일</td>
            <td style="width: 100px;">역할</td>
        </tr>


        <c:choose>

            <c:when test="${empty checkedProjects}">
                <tr>
                    <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                        등록된 프로젝트가 없습니다
                    </td>
                </tr>
            </c:when>

            <c:otherwise>

                <c:forEach var="checkedProject" items="${checkedProjects}">
                    <tr style="text-align: center">

                            <%-- <input type="hidden" name="memSeq" value="${checkedProject.memSeq}">--%>


                        <td><input name="RowCheck" type="checkbox" id="chk" class="chkGrp"
                                   value="${checkedProject.prjSeq}"/></td>

                        <td>${checkedProject.prjSeq}</td>
                        <td>${checkedProject.prjNm}</td>
                        <td>${checkedProject.custCdNm}</td>

                        <td><input type="date" name="prjInDt"
                                   value="<fmt:formatDate value='${checkedProject.prjInDt}' pattern='yyyy-MM-dd'/>"
                                   required/></td>

                        <td><input type="date" name="prjOutDt"
                                   value="<fmt:formatDate value='${checkedProject.prjOutDt}' pattern='yyyy-MM-dd'/>"
                                   required/></td>

                        <td>
                            <select name="prjRoCd" required>
                                <option value="">선택</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.dtlCd}"
                                        ${checkedProject.prjRoCd == role.dtlCd ? 'selected="selected"' : ''}>
                                            ${role.dtlCdNm}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>


                    </tr>
                </c:forEach>

            </c:otherwise>

        </c:choose>

        <%--저장 삭제 버튼--%>

        <td colspan="7" align="right">
            <input type="button" value="선택저장" class='btn btn-success' onclick="updateValue();"/>
            <input type="button" value="선택삭제" class="btn btn-warning" onclick="deleteValue();">
        </td>


    </table>




</body>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</html>



