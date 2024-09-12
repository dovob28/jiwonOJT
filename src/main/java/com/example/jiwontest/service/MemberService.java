package com.example.jiwontest.service;

import com.example.jiwontest.dao.MemberMapper;
import com.example.jiwontest.dto.CodeDetail;
import com.example.jiwontest.dto.MemberInfoDto;
import com.example.jiwontest.dto.MemberProjectDto;
import com.example.jiwontest.dto.ProjectInfoDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;



@Transactional
@Service
public class MemberService {

    @Autowired
    private MemberMapper memberMapper;


    // 전체리스트 조회
    /*public List<MemberInfoDto> selectAllMembers(String raCdNm,String dpCdNm, MemberInfoDto member) {
        return memberMapper.selectAllMembers(raCdNm,dpCdNm,member);
    }*/


    // 사원검색
    public List<MemberInfoDto> searchMembers(String memNm, String memRaCd, String memDpCd, LocalDate startHireDate, LocalDate endHireDate) {
        return memberMapper.searchMembers(memNm, memRaCd, memDpCd, startHireDate, endHireDate);
    }

    // 페이징 처리 로직
    public List<MemberInfoDto> paginate(List<MemberInfoDto> allMembers, int page, int size) {
        int start = (page - 1) * size;
        int end = Math.min(start + size, allMembers.size());

        // 페이징된 결과를 반환
        return allMembers.subList(start, end);
    }


    // 특정 마스터 코드에 해당하는 상세 코드 리스트 조회
    public List<CodeDetail> getCodeDetailsByMstCd(String mstCd) {

        return memberMapper.getCodeDetailsByMstCd(mstCd);
    }


    // 마스터 코드와 멤버의 아이디를 이용하여 스킬 목록 조회
    public List<CodeDetail> getCodeDetail(String mstCode, MemberInfoDto member) {

        return memberMapper.getCodeDetail(mstCode, member);
    }


    // 신규등록
    public void insertMember(MemberInfoDto memberInfo) {

        memberMapper.insertMember(memberInfo);

        // 사원 번호 가져오기
        int memSeq = memberInfo.getMemSeq();

        // 보유 기술 저장
        if (memberInfo.getMemSkills() != null) {
            for (String skCd : memberInfo.getMemSkills()) {
                memberMapper.insertMemberSkill(memSeq, skCd);
            }
        }
    }


    // 상세조회
    public MemberInfoDto getMemberById(int memSeq) {

        MemberInfoDto member = memberMapper.getMemberById(memSeq);


        if (member != null) {
            // 선택된 값과 코드명 등이 제대로 세팅되었는지 점검
            List<CodeDetail> skillDetails = memberMapper.getCodeDetail("SK01", member);
            member.setSkillDetails(skillDetails);

            List<CodeDetail> memRaCd = memberMapper.getCodeDetail("RA01", member);
            member.setMemRaCd(member.getMemRaCd());
        }
        return member;
    }


    // 사원수정
    public void updateMember(MemberInfoDto memberInfo) {

        memberMapper.updateMember(memberInfo);
    }


    // 보유기술 수정용!!!! (삭제 + 수정)
    //  사원보유기술 삭제
    public void deleteMemberSkill(MemberInfoDto memberInfo) {

        memberMapper.deleteMemberSkill(memberInfo);
    }

    // 사원보유기술 수정
    public void updateMemberSkill(MemberInfoDto memberInfo) {

        // 사원 번호 가져오기
        int memSeq = memberInfo.getMemSeq();

        // 보유 기술 저장 => 반복해서 4번이면 4번 업데이트
        if (memberInfo.getMemSkills() != null) {

            for (String skCd : memberInfo.getMemSkills()) {
                memberMapper.insertMemberSkill(memSeq, skCd);
            }
        }

        /* for each문 버전

            if (memberInfo.getMemSkills() != null) {
            List<String> skills = memberInfo.getMemSkills(); // 리스트를 변수에 할당
            for (int i = 0; i < skills.size(); i++) {
                String skCd = skills.get(i); // 리스트의 각 요소를 순차적으로 가져오기
                memberMapper.updateMemberSkill(memSeq, skCd);
            }
        }*/

    }


    // 사원삭제
    public void deleteMember(int memSeq) {

        memberMapper.deleteMember(memSeq);
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // 팝업창 조회
    public List<ProjectInfoDto> selectAllProjects() {

        List<ProjectInfoDto> projects = memberMapper.selectAllProjects();

        return projects;
    }


    // 팝업 검색용
    public List<ProjectInfoDto> searchPopupPrjs(String prjNm, String custCd, int memSeq) {
        return memberMapper.searchPopupPrjs(prjNm, custCd, memSeq);
    }


    // 체크박스 값 저장
    public void memberProjectAdd(List<ProjectInfoDto> projects, int memSeq) {

        List<MemberProjectDto> memberProjects = new ArrayList<>();

        for (ProjectInfoDto project : projects) {

            MemberProjectDto memberProject = new MemberProjectDto();

            memberProject.setMemSeq(memSeq);
            memberProject.setPrjSeq(project.getPrjSeq());
            memberProject.setPrjNm(project.getPrjNm());
            memberProject.setCustCd(project.getCustCd());
            memberProject.setPrjInDt(project.getPrjStDt());  // 프로젝트 시작일을 투입일로 설정
            memberProject.setPrjOutDt(project.getPrjEdDt()); // 프로젝트 종료일을 철수일로 설정

            memberProjects.add(memberProject);
        }

        // MyBatis Mapper를 통해 DB에 insert
        memberMapper.memberProjectAdd(memberProjects);
    }


    // 프로젝트 ID로 체크된 프로젝트 정보들을 가져옴
    public List<ProjectInfoDto> getProjectsByIds(List<Integer> prjSeqList) {
        return memberMapper.getProjectsByIds(prjSeqList);
    }


    // 사원 프로젝트창 조회
    public List<MemberProjectDto> memberProjectSelect(List<Integer> prjSeqList, int memSeq) {

        if (prjSeqList == null || prjSeqList.isEmpty()) {
            return new ArrayList<>();
        }
        return memberMapper.memberProjectSelect(prjSeqList, memSeq);
    }


    // member_project 테이블에서 memSeq(135)로 prjSeqList 가져오기
    public List<MemberProjectDto> getProjectList(int memSeq) {

        return memberMapper.getProjectList(memSeq);
    }

    // 위에서 가져온 prjSeqList 로 project 정보 조회
    public List<ProjectInfoDto> getProjectRegister(List<Integer> seqList) {

        return memberMapper.getProjectRegister(seqList);
    }


    // 사원 프로젝트 리스트 삭제
    public void memberProjectDelete(List<Integer> chkList,
                                    int memSeq) {

        memberMapper.memberProjectDelete(chkList, memSeq);
    }




    // 사원 프로젝트 리스트 수정
//    public void memberProjectUpdate(List<Integer> prjSeqList,
//                                    int memSeq,
//                                    MemberProjectDto memberProject,
//                                    List<String> prjInDtList,
//                                    List<String> prjOutDtList,
//                                    List<String> prjRoCdList) {
//
//        memberMapper.memberProjectUpdate(prjSeqList, memSeq, memberProject, prjInDtList, prjOutDtList, prjRoCdList);
//    }

    public void memberProjectUpdate(List<Integer> prjSeqList,
                                    int memSeq,
                                    MemberProjectDto memberProject,
                                    List<String> prjInDtList,
                                    List<String> prjOutDtList,
                                    List<String> prjRoCdList) {

        // 각 리스트의 크기가 일치하는지 확인
        if (prjSeqList.size() == prjInDtList.size() &&
                prjSeqList.size() == prjOutDtList.size() &&
                prjSeqList.size() == prjRoCdList.size()) {
            memberMapper.memberProjectUpdate(prjSeqList, memSeq, memberProject, prjInDtList, prjOutDtList, prjRoCdList);
        } else {
            throw new IllegalArgumentException("리스트의 크기가 일치하지 않습니다.");
        }
    }



}