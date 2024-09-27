package com.example.jiwontest.controller;



import com.example.jiwontest.dto.*;
import com.example.jiwontest.service.MemberService;
import com.example.jiwontest.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@Controller
public class ProjectController {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private MemberService memberService;



    // 프로젝트 전체 조회 (검색 + 페이징 추가 전)
    /*@GetMapping("/project/projectList")
    public String projectList(Model model){

        List<ProjectInfoDto> projectInfo = projectService.selectAllProjects();
        model.addAttribute("projects", projectInfo);

        return "/project/projectList";
        
    }*/

    // 프로젝트 전체조회/ 검색/ 페이징
    @GetMapping("/project/projectList")
    public String projectList( @RequestParam(defaultValue = "") String prjNm, // 검색용들
                               @RequestParam(required = false) String custCd,
                               @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startPrjStDt,
                               @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endPrjStDt,
                               @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startPrjEdDt,
                               @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endPrjEdDt,

                               @RequestParam(defaultValue = "1") int page,  // 페이지 번호
                               @RequestParam(defaultValue = "10") int size, // 한 페이지에 보여줄 데이터 수

                               Model model// 전체조회용
                             ){

        // 조회 전 안보이게
        boolean beforeSearched = !(prjNm.isEmpty() && custCd == null && startPrjStDt == null && endPrjStDt == null && startPrjEdDt == null && endPrjEdDt == null);
        model.addAttribute("beforeSearched", beforeSearched);


        // 프로젝트 검색 리스트
        List<ProjectInfoDto> projectInfo = projectService.searchProjects(prjNm, custCd, startPrjStDt, endPrjStDt,startPrjEdDt,endPrjEdDt);

        // 검색 조건도 모델에 추가
        model.addAttribute("prjNm", prjNm);
        model.addAttribute("custCd", custCd);
        model.addAttribute("startPrjStDt", startPrjStDt);
        model.addAttribute("endPrjStDt", endPrjStDt);
        model.addAttribute("startPrjEdDt", startPrjEdDt);
        model.addAttribute("endPrjEdDt", endPrjEdDt);



        // 페이징 처리
        List<ProjectInfoDto> projectList = projectService.paginate(projectInfo, page, size);

        // 총 페이지 수 계산
        int totalItems = projectInfo.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        // Math.ceil(): 소수점을 올림 처리
        // (double)은 형 변환
        // => 남은값 반올림해서 페이지수 추가할려고 사용

        // 모델에 필요한 정보 추가
        model.addAttribute("projects", projectList);  // 페이징 처리된 데이터
        model.addAttribute("currentPage", page);    // 현재 페이지 번호
        model.addAttribute("pageSize", size);       // 한 페이지에 보여줄 데이터 수
        model.addAttribute("totalItems", totalItems); // 전체 데이터 수
        model.addAttribute("totalPages", totalPages); // 총 페이지 수




        // 코드 마스터 데이터를 조회하여 모델에 추가
        List<CodeDetail> customers = projectService.getCodeDetailsByMstCd("CU01");
        model.addAttribute("customers", customers);


        return "/project/projectList";

    }





    // 등록페이지 이동
    @GetMapping("/project/projectRegister")
    public String projectRegister(Model model) {

        // 스킬코드 등록
        List<CodeDetail> skills = projectService.getCodeDetailsByMstCd("SK01");
        model.addAttribute("skills", skills);

        List<CodeDetail> customers = projectService.getCodeDetailsByMstCd("CU01");
        model.addAttribute("customers", customers);

        return "/project/projectRegister";
    }


    // 프로젝트 신규 등록
    @PostMapping("/project/projectInsert")
    public String projectInsert(@ModelAttribute ProjectInfoDto projectInfo) {

        projectService.insertProject(projectInfo);

        return "redirect:/project/projectList?page=1&size=10&prjNm=&custCd=&startPrjStDt=&endPrjStDt=&startPrjEdDt=&endPrjEdDt=";
    }


    // 상세조회
    @GetMapping("/project/projectContent")
    public String projectContent(@RequestParam("prjSeq") int prjSeq,
                                 Model model) {

        // 데이터베이스에서 회원 정보를 가져옴
        ProjectInfoDto projectInfo = projectService.getProjectById(prjSeq);

        // 디테일코드
        List<CodeDetail> customers = projectService.getCodeDetailsByMstCd("CU01");
        List<CodeDetail> skillList = projectService.getCodeDetailsByMstCd("SK01"); //보유기술


        // 보유기술 선택을 위한 추가
        projectInfo.setSkillDetails(projectService.getCodeDetail("SK01", projectInfo));

        model.addAttribute("project", projectInfo); // 프로젝트 정보

        model.addAttribute("customers", customers);  // 고객사
        model.addAttribute("skillList", skillList);  // 필요기술

        return "/project/projectContent"; // JSP 파일 이름
    }



    // 프로젝트 수정
    @PostMapping("/project/projectUpdate")
    public String memberUpdate(@ModelAttribute ProjectInfoDto projectInfo) {

        // 프로젝트 정보용
        projectService.updateProject(projectInfo);

        // 필요기술 수정용 => 삭제 하고 수정
        projectService.deleteProjectSkill(projectInfo);
        projectService.updateProjectSkill(projectInfo);

        System.out.println("사원정보 => " + projectInfo);

        System.out.println("getCustCd() : " + projectInfo.getCustCd()); // 123
        System.out.println("필요기술 =>" + projectInfo.getPrjSkills());


        return "redirect:/project/projectList?page=1&size=10&prjNm=&custCd=&startPrjStDt=&endPrjStDt=&startPrjEdDt=&endPrjEdDt=";
    }




    // 프로젝트 삭제
    @PostMapping("/project/projectDelete")
    public String projectDelete(@RequestParam("prjSeq") int prjSeq) {

        System.out.println("삭제번호!!!!!!!!!!!: " + prjSeq);

        projectService.deleteProject(prjSeq);


        return "redirect:/project/projectList?page=1&size=10&prjNm=&custCd=&startPrjStDt=&endPrjStDt=&startPrjEdDt=&endPrjEdDt=";

    }






    ////////////////////////////////////////////////////////////////////////


    // 팝업창 조회 & 검색
    // 프로젝트가 선택한 사원은 뜨면 안됌
    @GetMapping("/project/projectPopup")
    public String projectPopup(Model model,
                               @RequestParam int prjSeq, // 인지용

                               @RequestParam(defaultValue = "") String memNm, // 검색용
                               @RequestParam(required = false) String memDvCd) {



        // 프로젝트의 현재 사원목록 가져오기
        List<ProjectMemberDto> projectMembers = projectService.getMemberList(prjSeq);

        List<Integer> projectMemberIds = projectMembers.stream()
                                        .map(ProjectMemberDto::getMemSeq)
                                        .collect(Collectors.toList());


        List<MemberInfoDto> members;

        if (memNm.isEmpty() && memDvCd == null) {

            // 검색 조건이 없는 경우 (초기화 포함)
            members = projectService.selectAvailableMembers(projectMemberIds);

        } else {

            // 검색 조건이 있는 경우
            members = projectService.searchPopupMems(memNm, memDvCd, prjSeq, projectMemberIds);
        }

        model.addAttribute("prjSeq", prjSeq);
        model.addAttribute("members", members);

        // 검색용 디테일 코드
        List<CodeDetail> devFields = projectService.getCodeDetailsByMstCd("DV01");
        model.addAttribute("devFields", devFields);


        // 조회 안될떄
        boolean beforeSearchedPop = !(memNm.isEmpty() && memDvCd == null);
        model.addAttribute("beforeSearchedPop", beforeSearchedPop);

        return "/project/projectPopup";
    }






    //  체크박스 값 저장
    @PostMapping("/project/projectMemberAdd")
    public String projectMemberAdd(@RequestParam("RowCheck") List<Integer> memSeqList,
                                   @RequestParam int prjSeq,
                                   Model model) {

        System.out.println("추가할 프로젝트번호값 memSeq => " + prjSeq);
        System.out.println("선택한 체크박스값 prjSeqList11 => " + memSeqList);

        // 프로젝트 정보를 가져옴
        ProjectInfoDto projectInfo = projectService.getProjectById(prjSeq);

        // 선택된 사원들을 조회
        // 사원ID로 체크된 사원정보들을 가져옴
        List<MemberInfoDto> checkedMembers = projectService.getMembersByIds(memSeqList);

        // 조회된 프로젝트 정보를 project_member 테이블에 저장 insert projectMemberAdd(members, prjSeq)-----
        projectService.projectMemberAdd(checkedMembers, prjSeq);


        // 프로젝트 정보와 사원목록을 모델에 추가
        model.addAttribute("project", projectInfo); // 프로젝트 정보
        model.addAttribute("checkedMembers", checkedMembers);

        return "redirect:/project/projectMember?prjSeq=" + prjSeq;
    }






    // 프로젝트사원창 조회
    //projectMember에 체크박스 저장값 조회
    @GetMapping("/project/projectMember")
    public String projectMember(@RequestParam("prjSeq") int prjSeq,
                                Model model) {

        System.out.println("팝업에서 돌아온 prjSeq => " + prjSeq);

        // 프로젝트 정보를 가져옴
        ProjectInfoDto projectInfo = projectService.getProjectById(prjSeq);

        // project_member 테이블에서 prjSeq(135)로 memSeqList 가져오기-------------------------------
        // 하나 이상이면 값 못가져오니까 List<>로 가져와야함
        List<ProjectMemberDto> projectMemberList = projectService.getMemberList(prjSeq);
        System.out.println("projectMember : " + projectMemberList);


        int seq = 0;
        List<Integer> seqList = new ArrayList<>();

        for (ProjectMemberDto projectMember : projectMemberList) {

            seq = projectMember.getMemSeq();
            System.out.println("seq : " + seq);

            seqList.add(seq);
            System.out.println("seqList : " + seqList);
        }


        // 위에서 가져온 memSeqList 로 member 정보 조회----------------------------------
        List<MemberInfoDto> memberRegister = projectService.getMemberRegister(seqList);

        model.addAttribute("checkedMembers", memberRegister);


        // 프로젝트 리스트가 null이 아닌 경우에만 처리
        /*if (seqList != null && !seqList.isEmpty()) {*/

        // 선택한 사원들을 조회하여 가져옴
        List<ProjectMemberDto> checkedMembers = projectService.projectMemberSelect(seqList, prjSeq);

        model.addAttribute("checkedMembers", checkedMembers); // 선택된 사원들
        System.out.println("어디간거니 checkedMembers =>  " + checkedMembers);

        /*} else {
            model.addAttribute("checkedProjects", new ArrayList<>()); // 빈 리스트 전달
        }*/

        model.addAttribute("project", projectInfo); // 프로젝트 정보

        // 역할 코드 추가
        List<CodeDetail> roles = projectService.getCodeDetailsByMstCd("RO01");
        model.addAttribute("roles", roles);

        return "/project/projectMember";
    }




    // 프로젝트 사원리스트 삭제
    @PostMapping("/project/projectMemberDelete")
    public String projectMemberDelete(@RequestParam("chkList") String chkList,
                                      @RequestParam("prjSeq") int prjSeq) {

        System.out.println("삭제하고 싶은 chkList => " + chkList);

        // 쉼표로 구분된 chkList 문자열을 배열로 변환
        String[] grpCode = chkList.split(",");  // 예: "1,2,3" -> ["1", "2", "3"]

        // 정수형 리스트를 선언하여 변환된 값을 저장할 준비를 함
        List<Integer> memSeqList = new ArrayList<>();  // 빈 List<Integer> 선언

        // grpCode 배열의 각 요소를 순회하면서 문자열을 정수로 변환 후 리스트에 추가
        for (int i = 0; i < grpCode.length; i++) {

            // 현재 인덱스의 값을 가져옴 (예: "1", "2", "3" 중 하나)
            String code = grpCode[i];

            // 문자열 값을 Integer로 변환하고 리스트에 추가
            memSeqList.add(Integer.parseInt(code));  // "1" -> 1, "2" -> 2 등으로 변환 후 리스트에 추가
        }

        /* 버전2
          for (String code : grpCode) {
            prjSeqList.add(Integer.parseInt(code));
        }*/

        // 삭제 로직 실행
        projectService.projectMemberDelete(memSeqList, prjSeq);

        System.out.println("삭제된 prjSeqList!!!!!!! => " + memSeqList);


        return "redirect:/project/projectMember?prjSeq=" + prjSeq;
    }



    // 사원 프로젝트 체크 수정
    // @RequestBody List<MemberProjectDto> memberProjects 로 전부 불러울수 있다
    // 쓸데없이 다 안쳐넣어도 됌 => 코드의 간결화, 유지보수
    @PostMapping("/project/updateMembers")
    @ResponseBody
    public ResponseEntity<String> updateMemberProject(@RequestBody List<ProjectMemberDto> projectMembers) {

        try {
            projectService.updateProjectMember(projectMembers);

            return ResponseEntity.ok("Success");

        } catch (Exception e) {

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }






}//






