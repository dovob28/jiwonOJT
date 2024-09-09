package com.example.jiwontest.dto;


import lombok.*;


// 프로젝트_필요기술
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class ProjectSkillDto {

    private String prjSeq; // 프로젝트 번호
    private String skCd; // 기술코드

    private String skCdNm; //기술명
}
