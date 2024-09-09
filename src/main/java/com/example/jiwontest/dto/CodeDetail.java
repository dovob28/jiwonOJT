package com.example.jiwontest.dto;

import lombok.*;


// 디테일_코드
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class CodeDetail {

    private String mstCd; // 마스터코드
    private String dtlCd; // 디테일코드

    private String mstCdNm; // 마스터코드명 > 보여주는 뷰 화면에 쓸때 사용
    private String dtlCdNm; // 디테일코드명
}
