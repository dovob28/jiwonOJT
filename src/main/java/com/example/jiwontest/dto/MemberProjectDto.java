package com.example.jiwontest.dto;


import lombok.*;

import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class MemberProjectDto {

    private int memSeq;
    private int prjSeq;
    private String prjNm;
    private String custNm;
    private Date prjInDt;
    private Date prjOutDt;
    private String prjRoCd;


    private String prjRoCdName;
}
