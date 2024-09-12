package com.example.jiwontest.dto;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;


// 사원_참여 프로젝트 관리
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class MemberProjectDto {

    private int memSeq; // 사원번호
    private int prjSeq; // 프로젝트번호
    private String prjNm; // 프로젝트명
    private String custCd; // 고객사 코드

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjInDt; // 투입일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjOutDt; // 철수일

    private String prjRoCd; // 역할코드


    private String custCdNm; // 고객사명
    private String prjRoCdNM; // 역할명

    private List<Integer> prjSeqList;
    private List<String> chkList;
    private List<String> prjInDtList;
    private List<String> prjOutDtList;
    private List<String> prjRoCdList;

}
