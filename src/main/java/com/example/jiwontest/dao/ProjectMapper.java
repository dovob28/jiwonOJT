package com.example.jiwontest.dao;


import com.example.jiwontest.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;


@Mapper
public interface ProjectMapper {

    // 프로젝트 전체 조회
    List<ProjectInfoDto> selectAllProjects();



    // 특정 마스터 코드에 해당하는 상세 코드 리스트 조회
    List<CodeDetail> getCodeDetailsByMstCd(String mstCd);

    // 마스터 코드와 프로젝트를 이용하여 스킬 목록 조회 (이걸해야 선택목록 뜸)
    List<CodeDetail> getCodeDetail(@Param("mstCode") String mstCode,
                                   @Param("project") ProjectInfoDto projectInfo);

    // 보유기술등록 (신규등록용)
    void insertProjectSkill(@Param("prjSeq") int prjSeq,
                            @Param("skCd") String skCd);


    // 프로젝트 검색 리스트
    List<ProjectInfoDto> searchProjects(@Param("prjNm") String prjNm,
                                        @Param("custCd") String custCd,
                                        @Param("startPrjStDt") LocalDate startPrjStDt,
                                        @Param("endPrjStDt") LocalDate endPrjStDt,
                                        @Param("startPrjEdDt") LocalDate startPrjEdDt,
                                        @Param("endPrjEdDt") LocalDate endPrjEdDt);



    // 신규 프로젝트 등록
    void insertProject(ProjectInfoDto projectInfo);

    // 프로젝트 상세조회
    ProjectInfoDto getProjectById(int prjSeq);


    // 프로젝트 수정
    void updateProject(ProjectInfoDto projectInfo);
    // -프로젝트 필요기술 삭제
    void deleteProjectSkill(ProjectInfoDto projectInfo);
    // -프로젝트 필요기술 수정
    //  위 필요기술등록 (신규등록용) 다시 넣어줌


    // 프로젝트 삭제
    void deleteProject(int prjSeq);


    ///////////////////////////////////////////////////////////////////////




    // 팝업창 //검색 조건이 없는 경우 (초기화 포함)
    List<MemberInfoDto> selectAvailableMembers(@Param("projectMemberIds")List<Integer> projectMemberIds);

    // 팝업창  //검색 조건이 있는 경우
    List<MemberInfoDto> searchPopupMems(@Param("memNm") String memNm,
                                        @Param("memDvCd")String memDvCd,
                                        @Param("prjSeq")int prjSeq,
                                        @Param("projectMemberIds")List<Integer> projectMemberIds);



    // 체크박스 값 저장
    void projectMemberAdd(List<ProjectMemberDto> projectMembers);


    // 사원 ID로 체크된 프로젝트 정보들을 가져옴
    List<MemberInfoDto> getMembersByIds(@Param("memSeqList") List<Integer> memSeqList);



    // 프로젝트사원창 조회
    List<ProjectMemberDto> projectMemberSelect(@Param("memSeqList") List<Integer> memSeqList,
                                               @Param("prjSeq") int prjSeq);

    // project_member 테이블에서 prjSeq(135)로 memSeqList 가져오기
    List<ProjectMemberDto> getMemberList(int prjSeq);

    // 위에서 가져온 memSeqList로 member 정보 조회
    List<MemberInfoDto> getMemberRegister(List<Integer> seqList);

    // 프로젝트사원 리스트 삭제
    void projectMemberDelete(@Param("chkList") List<Integer> chkList,
                             @Param("prjSeq") int prjSeq);


    // 프로젝트사원 체크 수정
    void updateProjectMember(ProjectMemberDto member);

}//
