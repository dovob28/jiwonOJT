package com.example.jiwontest.dto;


import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


// 프로젝트_참여 인원 관리
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class ProjectMemberDto {

    private int prjSeq; // 프로젝트번호

    private int memSeq; // 사원번호
    private String memNm; // 사원명
    private String memDvCd; // 개발분야코드

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjInDt; // 투입일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date prjOutDt; // 철수일

    private String prjRoCd; // 역할코드


    private String dvCdNm; // 개발분야명
    private String prjRoCdNM; //역할명
}
