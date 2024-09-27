package com.example.jiwontest.dto;


import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;


// 프로젝트_정보
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class ProjectInfoDto {

    private int prjSeq; // 프로젝트번호
    private String prjNm; // 프로젝트명
    private String custCd; // 고객사코드

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjStDt; // 프로젝트시작일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjEdDt; // 프로젝트종료일

    private String prjDtl; // 특이사항


    // mysql table x
    private String custCdNm; // 고객사명

    // 체크 박스 용
    private List<Integer> prjSeqList; // 체크박스 위해
    private List<Integer> seqList; // 체크박스 값


    // mysql table x, resister폼에 있음
    private List<String> prjSkills; // 보유기술 => [1, 2, 7, 8]
    private List<CodeDetail> skillDetails; // 보유기술 CodeDetail


    // 보유기술 선택을 위한 추가
    public void setSkillDetails(List<CodeDetail> skillDetails) {
        this.skillDetails = skillDetails;
        this.prjSkills = skillDetails.stream().map(CodeDetail::getDtlCd).toList();
    }

    public String getcustCdNm() {

        return custCdNm;
    }





}


