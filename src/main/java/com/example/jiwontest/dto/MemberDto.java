package com.example.jiwontest.dto;

import lombok.*;

import java.util.Date;


@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class MemberDto {

    private int memberSeq;
    private String memId;
    private String memPw;
    private String memNm;
    private String image;
    private String dpCd;
    private String raCd;
    private Date hireDate;
    private String dvCd;
    private Date bdt;
    private String email;
    private String postCode;
    private String memAddr;
    private String memDetailAddr;
    private String phone;



    private String dpCdName;
    private String raCdName;
    private String dvCdName;



}
