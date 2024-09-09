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



    private String custCdNm; // 고객사명

    private List<Integer> prjSeqList; // 체크박스 위해
    private List<Integer> seqList; // 체크박스 값


    // 셀렉트용
    /*public String getCustCdNm() {
        return getCustCdNm;
    }*/


}


