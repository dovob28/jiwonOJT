package com.example.jiwontest.service;


import com.example.jiwontest.dao.MemberMapper;
import com.example.jiwontest.dao.ProjectMapper;
import com.example.jiwontest.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class ProjectService {

    @Autowired
    private ProjectMapper projectMapper;
    @Autowired
    private MemberMapper memberMapper;


    // 프로젝트 전체 조회
    /*public List<ProjectInfoDto> selectAllProjects() {

        return projectMapper.selectAllProjects();
    }*/


    // 프로젝트 검색 리스트
    public List<ProjectInfoDto> searchProjects(String prjNm, String custCd, LocalDate startPrjStDt, LocalDate endPrjStDt, LocalDate startPrjEdDt, LocalDate endPrjEdDt) {

        return projectMapper.searchProjects(prjNm,custCd,startPrjStDt,endPrjStDt,startPrjEdDt,endPrjEdDt);
    }


    // 페이징 처리
    public  List<ProjectInfoDto> paginate( List<ProjectInfoDto> allProjects, int page, int size) {
        int start = (page - 1) * size;
        int end = Math.min(start + size, allProjects.size());

        // 페이징된 결과를 반환
        return allProjects.subList(start, end);
    }




    // 특정 마스터 코드에 해당하는 상세 코드 리스트 조회
    public List<CodeDetail> getCodeDetailsByMstCd(String mstCd) {

        return projectMapper.getCodeDetailsByMstCd(mstCd);
    }

    // 마스터 코드와 멤버의 아이디를 이용하여 스킬 목록 조회
    public List<CodeDetail> getCodeDetail(String mstCode, ProjectInfoDto projectInfo) {

        return projectMapper.getCodeDetail(mstCode, projectInfo);
    }



    // 프로젝트 신규등록
    public void insertProject(ProjectInfoDto projectInfo) {

        projectMapper.insertProject(projectInfo);

        // 프로젝트 번호 가져오기
        int prjSeq = projectInfo.getPrjSeq();

        // 보유기술 등록
        if (projectInfo.getPrjSkills() != null) {
            for (String skCd : projectInfo.getPrjSkills()){
                projectMapper.insertProjectSkill(prjSeq, skCd);
            }
        }
    }

    // 상세조회
    public ProjectInfoDto getProjectById(int prjSeq) {

        ProjectInfoDto projectInfo = projectMapper.getProjectById(prjSeq);


        if (projectInfo != null) {
            // 선택된 값과 코드명 등이 제대로 세팅되었는지 점검
            List<CodeDetail> skillDetails = projectMapper.getCodeDetail("SK01", projectInfo);
            projectInfo.setSkillDetails(skillDetails);

            /*List<CodeDetail> memRaCd = memberMapper.getCodeDetail("RA01", projectInfo);
            projectInfo.setCustCd(projectInfo.getCustCd());*/
        }
        return projectInfo;
    }


    // 프로젝트 수정
    public void updateProject(ProjectInfoDto projectInfo) {

        projectMapper.updateProject(projectInfo);
    }

  // 필요기술 수정용!!!! => 삭제 하고 수정

    // - 프로젝트 필요기술 삭제
    public void deleteProjectSkill(ProjectInfoDto projectInfo) {

        projectMapper.deleteProjectSkill(projectInfo);
    }
    // - 프로젝트 필요기술 수정
    public void updateProjectSkill(ProjectInfoDto projectInfo) {

        // 사원 번호 가져오기
        int prjSeq = projectInfo.getPrjSeq();

        // 보유 기술 저장 => 반복해서 4번이면 4번 업데이트
        if (projectInfo.getPrjSkills() != null) {

            for (String skCd : projectInfo.getPrjSkills()) {
                projectMapper.insertProjectSkill(prjSeq, skCd);
            }
        }

    }



    // 프로젝트 삭제
    public void deleteProject(int prjSeq) {

        projectMapper.deleteProject(prjSeq);
    }



/////////////////////////////////////////////////////////////////////////////////////////////




    // 팝업창 //검색 조건이 없는 경우 (초기화 포함)
    public List<MemberInfoDto> selectAvailableMembers(List<Integer> projectMemberIds) {

        return projectMapper.selectAvailableMembers(projectMemberIds);
    }


    // 팝업창  //검색 조건이 있는 경우
    public List<MemberInfoDto> searchPopupMems(String memNm, String memDvCd, int prjSeq, List<Integer> projectMemberIds) {

        return projectMapper.searchPopupMems(memNm, memDvCd, prjSeq, projectMemberIds);
    }








    // 체크박스 값 저장
    public void projectMemberAdd(List<MemberInfoDto> members, int prjSeq ) {

        List<ProjectMemberDto> projectMembers = new ArrayList<>();

        for (MemberInfoDto member : members) {

            ProjectMemberDto projectMember = new ProjectMemberDto();

            projectMember.setPrjSeq(prjSeq);
            projectMember.setMemSeq(member.getMemSeq());
            projectMember.setMemNm(member.getMemNm());
            projectMember.setMemDvCd(member.getMemDvCd());

            projectMembers.add(projectMember);
        }

        // MyBatis Mapper를 통해 DB에 insert
        projectMapper.projectMemberAdd(projectMembers);
    }



    // 사원 ID로 체크된 프로젝트 정보들을 가져옴
    public List<MemberInfoDto> getMembersByIds(List<Integer> memSeqList) {
        return projectMapper.getMembersByIds(memSeqList);
    }


    // 프로젝트사원창 조회
    public List<ProjectMemberDto> projectMemberSelect(List<Integer> memSeqList, int prjSeq) {

        if (memSeqList == null || memSeqList.isEmpty()) {
            return new ArrayList<>();
        }
        return projectMapper.projectMemberSelect(memSeqList, prjSeq);
    }


    // project_member 테이블에서 memSeq(135)로 prjSeqList 가져오기
    public List<ProjectMemberDto> getMemberList(int prjSeq) {

        return projectMapper.getMemberList(prjSeq);
    }

    // 위에서 가져온 memSeqList로 member정보 조회
    public List<MemberInfoDto> getMemberRegister(List<Integer> seqList) {

        return projectMapper.getMemberRegister(seqList);
    }


    // 프로젝트사원 리스트 삭제
    public void projectMemberDelete(List<Integer> chkList,
                                    int prjSeq) {

        projectMapper.projectMemberDelete(chkList, prjSeq);
    }


    // 프로젝트사원 체크 수정
    @Transactional
    public void updateProjectMember(List<ProjectMemberDto> projectMembers) {

        for (ProjectMemberDto member : projectMembers) {
            projectMapper.updateProjectMember(member);
        }

    }



}//







