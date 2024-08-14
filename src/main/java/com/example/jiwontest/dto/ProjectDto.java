package com.example.jiwontest.dto;


import lombok.*;

@NoArgsConstructor
@Getter
@Setter
@Data
@ToString
public class ProjectDto {

    private int prjSeq;
    private String prjNm;
    private String custCd;
    private String prjStDt;
    private String prjEdDt;
    private String prjDtl;

    private String custCdName;
}
