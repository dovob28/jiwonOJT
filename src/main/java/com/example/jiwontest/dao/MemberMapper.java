package com.example.jiwontest.dao;

import com.example.jiwontest.dto.CodeDetail;
import com.example.jiwontest.dto.MemberInfoDto;
import com.example.jiwontest.dto.MemberProjectDto;
import com.example.jiwontest.dto.ProjectInfoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface MemberMapper {

    // 전체조회
    List<MemberInfoDto> selectAllMembers(@Param("raCdNm") String raCdNm,
                                         @Param("dpCdNm") String dpCdNm,
                                         @Param("member") MemberInfoDto member);


    // 특정 마스터 코드에 해당하는 상세 코드 리스트 조회
    List<CodeDetail> getCodeDetailsByMstCd(String mstCd);


    // 마스터 코드와 멤버의 아이디를 이용하여 보유스킬 목록 조회  (이걸해야 선택목록 뜸)
    List<CodeDetail> getCodeDetail(@Param("mstCode") String mstCode,
                                   @Param("member") MemberInfoDto member);

    // 보유기술등록 (신규등록용)
    void insertMemberSkill(@Param("memSeq") int memSeq,
                           @Param("skCd") String skCd);


    // 사원 검색 리스트
    List<MemberInfoDto> searchMembers(@Param("memNm") String memNm,
                                      @Param("memRaCd") String memRaCd,
                                      @Param("memDpCd") String memDpCd,
                                      @Param("startHireDate") LocalDate startHireDate,
                                      @Param("endHireDate") LocalDate endHireDate);


    // 신규등록
    void insertMember(MemberInfoDto memberInfo);

    // 아이디 중복 체크
    int memberIdCheck(String memId);




    // 상세조회
    MemberInfoDto getMemberById(int memSeq);


    // 사원수정
    void updateMember(MemberInfoDto memberInfo);
    // -사원 보유기술 삭제
    void deleteMemberSkill(MemberInfoDto memberInfo);
    // -사원 보유기술 수정
    //  위 보유기술등록 (신규등록용) 다시 넣어줌



    // 사원삭제
    void deleteMember(int memSeq);




/////////////////////////////////////////////////////////////////////////////////////////////


    // 팝업창 //검색 조건이 없는 경우 (초기화 포함)
    List<ProjectInfoDto> selectAvailableProjects(@Param("memberProjectIds") List<Integer> memberProjectIds);

    // 팝업창 //검색 조건이 있는 경우
    List<ProjectInfoDto> searchPopupPrjs(@Param("prjNm") String prjNm,
                                         @Param("custCd") String custCd,
                                         @Param("memSeq") int memSeq,
                                         @Param("memberProjectIds") List<Integer> memberProjectIds);


   // 체크박스 값 저장
    void memberProjectAdd(List<MemberProjectDto> memberProjects);


    // 프로젝트 ID로 체크된 프로젝트 정보들을 가져옴
    List<ProjectInfoDto> getProjectsByIds(@Param("prjSeqList") List<Integer> prjSeqList);



    // 사원 프로젝트창 조회
    List<MemberProjectDto> memberProjectSelect(@Param("prjSeqList") List<Integer> prjSeqList,
                                               @Param("memSeq") int memSeq);

    // member_project 테이블에서 memSeq(135)로 prjSeqList 가져오기
    List<MemberProjectDto> getProjectList(int memSeq);

    // 위에서 가져온 prjSeqList 로 project 정보 조회
    List<ProjectInfoDto> getProjectRegister(List<Integer> seqList);



    // 사원 프로젝트 리스트 삭제
    void memberProjectDelete(@Param("chkList") List<Integer> chkList,
                             @Param("memSeq") int memSeq);



    // 사원 프로젝트 체크 수정
    void updateMemberProject(MemberProjectDto memberProject);



}