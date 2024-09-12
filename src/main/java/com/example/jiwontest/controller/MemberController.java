package com.example.jiwontest.controller;


import com.example.jiwontest.dto.CodeDetail;
import com.example.jiwontest.dto.MemberInfoDto;
import com.example.jiwontest.dto.MemberProjectDto;
import com.example.jiwontest.dto.ProjectInfoDto;
import com.example.jiwontest.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;


@Controller
public class MemberController {

    @Autowired
    private MemberService memberService;


    // 단순이동
    @GetMapping("/")
    public String test() {

        return "test";
    }


    // 전체조회/ 검색/ 페이징
    @GetMapping("/member/memberList")
    public String memberList(
            @RequestParam(defaultValue = "") String memNm, // 검색용들
            @RequestParam(required = false) String memRaCd,
            @RequestParam(required = false) String memDpCd,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startHireDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endHireDate,

            @RequestParam(defaultValue = "1") int page,  // 페이지 번호
            @RequestParam(defaultValue = "10") int size, // 한 페이지에 보여줄 데이터 수

            Model model) {




        // 서비스 호출하여 검색 결과를 가져옴
        List<MemberInfoDto> members = memberService.searchMembers(memNm, memRaCd, memDpCd, startHireDate, endHireDate);

        // 검색 조건도 모델에 추가
        model.addAttribute("memNm", memNm);
        model.addAttribute("memRaCd", memRaCd);
        model.addAttribute("memDpCd", memDpCd);
        model.addAttribute("startHireDate", startHireDate);
        model.addAttribute("endHireDate", endHireDate);



        // 페이징 처리
        List<MemberInfoDto> memberList = memberService.paginate(members, page, size);

        // 총 페이지 수 계산
        int totalItems = members.size();
        int totalPages = (int) Math.ceil((double) totalItems / size);
        // Math.ceil(): 소수점을 올림 처리
        // (double)은 형 변환
        // => 남은값 반올림해서 페이지수 추가할려고 사용

        // 모델에 필요한 정보 추가
        model.addAttribute("lists", memberList);  // 페이징 처리된 데이터
        model.addAttribute("currentPage", page);    // 현재 페이지 번호
        model.addAttribute("pageSize", size);       // 한 페이지에 보여줄 데이터 수
        model.addAttribute("totalItems", totalItems); // 전체 데이터 수
        model.addAttribute("totalPages", totalPages); // 총 페이지 수




        // 코드 마스터 데이터를 조회하여 모델에 추가
        List<CodeDetail> ranks = memberService.getCodeDetailsByMstCd("RA01");
        List<CodeDetail> departments = memberService.getCodeDetailsByMstCd("DP01");

        model.addAttribute("ranks", ranks);
        model.addAttribute("departments", departments);

        return "/member/memberList";
    }





    // 사원등록 페이지 이동
    @GetMapping("/member/memberRegister")
    public String memberRegister(Model model) {

        // 부서, 직급, 개발 분야, 보유 기술 코드 리스트를 가져와서 모델에 추가
        List<CodeDetail> ranks = memberService.getCodeDetailsByMstCd("RA01");    // 직급 코드
        List<CodeDetail> departments = memberService.getCodeDetailsByMstCd("DP01");  // 부서 코드
        List<CodeDetail> devFields = memberService.getCodeDetailsByMstCd("DV01");    // 개발 분야 코드
        List<CodeDetail> skills = memberService.getCodeDetailsByMstCd("SK01");       // 보유 기술 코드

        model.addAttribute("ranks", ranks);
        model.addAttribute("departments", departments);
        model.addAttribute("devFields", devFields);
        model.addAttribute("skills", skills);

        return "/member/memberRegister";
    }


    // 사원등록
    @PostMapping("/member/memberInsert")
    public String memberInsert(@ModelAttribute MemberInfoDto memberInfo) {

        memberService.insertMember(memberInfo);

        return "redirect:/member/memberList";
    }


    // 상세조회
    @GetMapping("/member/memberContent")
    public String memberContent(@RequestParam("memSeq") int memSeq,
                                Model model) {

        // 데이터베이스에서 회원 정보를 가져옴
        MemberInfoDto member = memberService.getMemberById(memSeq);

        // 디테일코드
        List<CodeDetail> ranks = memberService.getCodeDetailsByMstCd("RA01"); // 직급
        List<CodeDetail> departments = memberService.getCodeDetailsByMstCd("DP01");  // 부서
        List<CodeDetail> devFields = memberService.getCodeDetailsByMstCd("DV01");    // 개발분야
        List<CodeDetail> skillList = memberService.getCodeDetailsByMstCd("SK01"); //보유기술

        System.out.println("직급 코드 (memRaCd): " + member.getMemRaCd());
        System.out.println("부서 코드 (memDpCd): " + member.getMemDpCd());
        System.out.println("개발분야 코드 (memDvCd): " + member.getMemDvCd());
        System.out.println("보유기술 코드 (MemSkills): " + member.getMemSkills());

        // 보유기술 선택을 위한 추가
        member.setSkillDetails(memberService.getCodeDetail("SK01", member));

        model.addAttribute("member", member); // 회원정보

        model.addAttribute("ranks", ranks);  // 직급
        model.addAttribute("departments", departments); // 부서
        model.addAttribute("devFields", devFields);   // 개발분야
        model.addAttribute("skillList", skillList);  //보유기술

        return "/member/memberContent"; // JSP 파일 이름
    }


    // 사원수정
    @PostMapping("/member/memberUpdate")
    public String memberUpdate(@ModelAttribute MemberInfoDto memberInfo) {

        memberService.updateMember(memberInfo);

        memberService.deleteMemberSkill(memberInfo);
        memberService.updateMemberSkill(memberInfo);

        System.out.println("getMemRaCd() : " + memberInfo.getMemRaCd()); // 123
        System.out.println("getMemDpCd() : " + memberInfo.getMemDpCd());
        System.out.println("getMemDvCd() : " + memberInfo.getMemDvCd());
        System.out.println("사원정보 => " + memberInfo);

        System.out.println("보유기술 =>" + memberInfo.getMemSkills());


        return "redirect:/member/memberList";
    }


    // 사원삭제
    @PostMapping("/member/memberDelete")
    public String memberDelete(@RequestParam("memSeq") int memSeq) {

        System.out.println("삭제번호: " + memSeq);

        memberService.deleteMember(memSeq);

        return "redirect:/member/memberList";
    }


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // 팝업창 조회 & 검색 => 검색할때도 memSeq값이 필요하다!!!!!!!
    @GetMapping("/member/memberPopup")
    public String memberPopup(Model model,
                              @RequestParam int memSeq, // 팝업 인지용

                              @RequestParam(defaultValue = "") String prjNm, //검색용
                              @RequestParam(required = false) String custCd
                              ) {

        // 팝업 프로젝트 불러오기
        List<ProjectInfoDto> projects = memberService.selectAllProjects();

        model.addAttribute("member", memSeq);
        model.addAttribute("projects", projects);

        System.out.println("팝업창 memSeq => " + memSeq);
        System.out.println("팝업창 projects => " + projects);


        // 팝업 검색용
        List<ProjectInfoDto> popProjects = memberService.searchPopupPrjs(prjNm, custCd, memSeq);
        model.addAttribute("projects", popProjects);
        model.addAttribute("member", memSeq);

        System.out.println("팝업창검색!!! popProjects => " + popProjects);
        System.out.println("검색 memSeq => " + memSeq);


        // 디테일 코드
        List<CodeDetail> customers = memberService.getCodeDetailsByMstCd("CU01");
        model.addAttribute("customers", customers);


        return "/member/memberPopup";
    }




    //  체크박스 값 저장
    @PostMapping("/member/memberProjectAdd")
    public String memberProjectAdd(@RequestParam("RowCheck") List<Integer> prjSeqList,
                                   @RequestParam int memSeq,
                                   Model model) {

        System.out.println("추가할 사원번호값 memSeq => " + memSeq);
        System.out.println("선택한 체크박스값 prjSeqList11 => " + prjSeqList);

        // 사원 정보를 가져옴
        MemberInfoDto member = memberService.getMemberById(memSeq);

        // 선택된 프로젝트들을 조회
        // 프로젝트 ID로 체크된 프로젝트 정보들을 가져옴
        List<ProjectInfoDto> checkedProjects = memberService.getProjectsByIds(prjSeqList);

        // 조회된 프로젝트 정보를 member_project 테이블에 저장 insert memberProjectAdd(projects, memSeq)-----
        memberService.memberProjectAdd(checkedProjects, memSeq);


        // 사원 정보와 프로젝트 목록을 모델에 추가
        model.addAttribute("member", member); // 사원 정보
        model.addAttribute("checkedProjects", checkedProjects);

        return "redirect:/member/memberProject?memSeq=" + memSeq;
    }



    // 사원 프로젝트창 조회
    // memberProject에 체크박스 저장값 조회
    @GetMapping("/member/memberProject")
    public String memberProject(@RequestParam("memSeq") int memSeq,
                                Model model) {

        System.out.println("팝업에서 돌아온 memSeq => " + memSeq);

        // 사원 정보를 가져옴
        MemberInfoDto member = memberService.getMemberById(memSeq);

        // member_project 테이블에서 memSeq(135)로 prjSeqList 가져오기-------------------------------
        // 하나 이상이면 값 못가져오니까 List<>로 가져와야함
        List<MemberProjectDto> memberProjectList = memberService.getProjectList(memSeq);
        System.out.println("memberProject : " + memberProjectList);


        int seq = 0;
        List<Integer> seqList = new ArrayList<>();

        for (MemberProjectDto memberProject : memberProjectList) {

            seq = memberProject.getPrjSeq();
            //System.out.println("seq : " + seq);

            seqList.add(seq);
            //System.out.println("seqList : " + seqList);
        }


        // 위에서 가져온 prjSeqList 로 project 정보 조회----------------------------------
        List<ProjectInfoDto> projectRegister = memberService.getProjectRegister(seqList);

        model.addAttribute("checkedProjects", projectRegister);


        // 프로젝트 리스트가 null이 아닌 경우에만 처리
        /*if (seqList != null && !seqList.isEmpty()) {*/

        // 선택한 프로젝트들을 조회하여 가져옴
        List<MemberProjectDto> checkedProjects = memberService.memberProjectSelect(seqList, memSeq);

        model.addAttribute("checkedProjects", checkedProjects); // 선택된 프로젝트들
        System.out.println("어디간거니 Checked Projects =>  " + checkedProjects);

        /*} else {
            model.addAttribute("checkedProjects", new ArrayList<>()); // 빈 리스트 전달
        }*/

        model.addAttribute("member", member); // 사원 정보



        // 역할 코드 추가
        List<CodeDetail> roles = memberService.getCodeDetailsByMstCd("RO01");
        model.addAttribute("roles", roles);

        return "/member/memberProject";
    }



    // 사원 프로젝트 리스트 삭제
    @PostMapping("/member/memberProjectDelete")
    public String memberProjectDelete(@RequestParam("chkList") String chkList,
                                      @RequestParam("memSeq") int memSeq) {

        System.out.println("삭제하고 싶은 chkList => " + chkList);

        // 쉼표로 구분된 chkList 문자열을 배열로 변환
        String[] grpCode = chkList.split(",");  // 예: "1,2,3" -> ["1", "2", "3"]

        // 정수형 리스트를 선언하여 변환된 값을 저장할 준비를 함
        List<Integer> prjSeqList = new ArrayList<>();  // 빈 List<Integer> 선언

        // grpCode 배열의 각 요소를 순회하면서 문자열을 정수로 변환 후 리스트에 추가
        for (int i = 0; i < grpCode.length; i++) {

            // 현재 인덱스의 값을 가져옴 (예: "1", "2", "3" 중 하나)
            String code = grpCode[i];

            // 문자열 값을 Integer로 변환하고 리스트에 추가
            prjSeqList.add(Integer.parseInt(code));  // "1" -> 1, "2" -> 2 등으로 변환 후 리스트에 추가
        }

        /* 버전2
          for (String code : grpCode) {
            prjSeqList.add(Integer.parseInt(code));
        }*/

        // 삭제 로직 실행
        memberService.memberProjectDelete(prjSeqList, memSeq);

        System.out.println("삭제된 prjSeqList!!!!!!! => " + prjSeqList);



        return "redirect:/member/memberProject?memSeq=" + memSeq;
    }







    // 사원 프로젝트 리스트 체크 수정
    // 배열로 가져와서 각각 넣어줘야 되는거 같은데 1도 안된다 나중에 다시.........
    @PostMapping("/member/memberProjectUpdate")
    public String memberProjectUpdate(@ModelAttribute MemberProjectDto memberProject,
                                      @RequestParam("prjInDtList") List<String> prjInDtList,
                                      @RequestParam("prjOutDtList") List<String> prjOutDtList,
                                      @RequestParam("prjRoCdList") List<String> prjRoCdList,
                                      @RequestParam("memSeq") int memSeq,
                                      @RequestParam("chkList") List<String> chkList) {

        // 디버깅용 로그
        System.out.println("prjInDtList: " + prjInDtList);
        System.out.println("prjOutDtList: " + prjOutDtList);
        System.out.println("prjRoCdList: " + prjRoCdList);
        System.out.println("chkList: " + chkList);

        List<Integer> prjSeqList = chkList.stream()
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        // 수정 로직 실행
        memberService.memberProjectUpdate(prjSeqList, memSeq, memberProject, prjInDtList, prjOutDtList, prjRoCdList);

        return "redirect:/member/memberProject?memSeq=" + memSeq;
    }

    /*
    * @RequestParam("prjInDtList"), @RequestParam("prjOutDtList"), @RequestParam("prjRoCdList")
       파라미터를 추가하여 각 프로젝트의 투입일, 철수일, 역할코드를 배열로 받아옴.
       각 prjSeqList 항목에 대해 각각의 투입일, 철수일, 역할코드를 적용할 수 있도록
       반복문을 사용하여 개별적으로 업데이트 실행.
    * */








}





