package com.example.jiwontest.dto;


import lombok.*;

// 사원_보유기술
@NoArgsConstructor
@Setter
@Getter
@ToString
@Data
public class MemberSkillDto {

    private int memSeq; // 사원번호
    private String skCd; // 기술코드

    // private String skCdNm;
}
