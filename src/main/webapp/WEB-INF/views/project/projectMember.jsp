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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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

            window.open("/project/projectPopup?prjSeq=${project.prjSeq}", "projectPopup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
        }



        // 날짜 유효성
        function validateDates() {

            // 요소 가져옴
            const prjInDt = document.getElementById('prjInDt').value;
            const prjOutDt = document.getElementById('prjOutDt').value;

            // 둘다 입력 됬는지 날짜 유효 검사
            if(prjInDt && prjOutDt){

                // end가 start보다 빠르거나 같지 않으면..
                if(new Date(prjOutDt) < new Date(prjInDt)){

                    alert('철수일은 투입일보다 빠를 수 없습니다.');
                    // 유효값 입력 시 endHireDate 비움
                    document.getElementById('prjOutDt').value = '';
                }
            }

        }



        // 체크박스
        $(function () {
            var chkObj = document.getElementsByName("RowCheck");
            var rowCnt = chkObj.length;

            // 전체 선택
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

            // 삭제 확인 메시지
            if (!confirm("정말 삭제하시겠습니까?")) {
                return;  // 사용자가 '취소'를 누르면 삭제 중단
            }

            // Ajax로 삭제 요청을 보냄
            $.ajax({
                url: '/project/projectMemberDelete',
                method: 'POST',
                data: {chkList: groupList, prjSeq: $("input[name='prjSeq']").val()},  // 배열과 memSeq를 함께 전송
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


        // 체크 수정
        function updateValue() {

            var selectedMembers = [];

            $('input[name="RowCheck"]:checked').each(function() {

                var row = $(this).closest('tr');

                var member = {
                    prjSeq: $('input[name="prjSeq"]').val(),
                    memSeq: $(this).val(),
                    prjInDt: row.find('input[name="prjInDt"]').val(),
                    prjOutDt: row.find('input[name="prjOutDt"]').val(),
                    prjRoCd: row.find('select[name="prjRoCd"]').val()
                };
                selectedMembers.push(member);
            });

            if (selectedMembers.length > 0) {
                $.ajax({
                    url: '/project/updateMembers',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(selectedMembers),

                    success: function(response) {
                        if (response === 'Success') {
                            alert('수정이 완료되었습니다.');
                            // 필요하다면 페이지를 리로드하거나 테이블을 새로고침
                            location.reload();
                        } else {
                            alert('업데이트 중 오류가 발생했습니다: ' + response);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('서버 오류: ' + error);
                    }
                });
            } else {
                alert('수정할 멤버를 선택해주세요.');
            }
        }

    </script>


    <%-- 수정시 컬러 변경--%>
    <script>
        function highlightRow(row) {
            // 클릭된 행에 색 적용
            row.classList.add('highlight-row');
        }
    </script>

    <style>
        .highlight-row {
            background-color: #afeaaf;
        }
    </style>

</head>




    <%--리드온니--%>
    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">
        <tr>
            <td colspan="7" style="text-align: left;">
                <div class="d-flex justify-content-left align-items-center">
                    <span style="margin-right: 10px;">프로젝트번호
                        <input type="text" name="prjSeq" value="${project.prjSeq}" readonly style="background-color: lightgray; border-color: lightgray"></span>
                    <span>프로젝트명
                        <input type="text" name="prjNm" value="${project.prjNm}" readonly style="background-color: lightgray; border-color: lightgray" /></span>
                </div>
            </td>
        </tr>
    </table>


    <table class="table table-bordered" style="width: 900px; margin-left: 300px;">


        <td colspan="7" align="right">
            <div class="d-flex justify-content-end align-items-center">

                <%--인원 추가 팝업버튼--%>
                <input type="button" value="사원 추가" class="btn btn-primary"
                       onclick="popUp()"/>

            </div>
        </td>


        <%--리스트--%>
        <tr style="text-align: center">
            <td style="width: 10px;"><input id="allCheck" type="checkbox" name="allCheck"/></td>
            <td style="width: 100px;">사원번호</td>
            <td style="width: 100px;">사원명</td>
            <td style="width: 100px;">개발분야</td>
            <td style="width: 100px;">투입일</td>
            <td style="width: 100px;">철수일</td>
            <td style="width: 100px;">역할</td>
        </tr>


        <c:choose>

            <c:when test="${empty checkedMembers}">
          <%--            <c:when test="${fn:length(checkedProjects) == 0}">--%>
                <tr>
                    <td colspan="7" style="text-align: center; vertical-align: middle; height: 100px;">
                        등록된 프로젝트가 없습니다
                    </td>
                </tr>
            </c:when>


            <c:otherwise>
                <c:forEach var="checkedMember" items="${checkedMembers}">
                    <tr style="text-align: center">


                        <td><input name="RowCheck" type="checkbox" id="chk" class="chkGrp"
                                   value="${checkedMember.memSeq}"/></td>

                        <td>${checkedMember.memSeq}</td>
                        <td>${checkedMember.memNm}</td>
                        <td>${checkedMember.dvCdNm}</td>

                        <td><input type="date" id="prjInDt" name="prjInDt" onclick="highlightRow(this)" onchange="validateDates()"
                                   value="<fmt:formatDate value='${checkedMember.prjInDt}' pattern='yyyy-MM-dd'/>"
                                   required/></td>

                        <td><input type="date" id="prjOutDt" name="prjOutDt" onclick="highlightRow(this)" onchange="validateDates()"
                                   value="<fmt:formatDate value='${checkedMember.prjOutDt}' pattern='yyyy-MM-dd'/>"
                                   required/></td>

                        <td>
                            <select name="prjRoCd" required onclick="highlightRow(this)">
                                <option value="">선택</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.dtlCd}"
                                        ${checkedMember.prjRoCd == role.dtlCd ? 'selected="selected"' : ''}>
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



