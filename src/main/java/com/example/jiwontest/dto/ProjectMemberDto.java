package com.example.jiwontest.dto;


import lombok.*;

import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class ProjectMemberDto {

    private int prjSeq;
    private int memSeq;
    private Date prjInDt;
    private Date prjOutDt;
    private String prjRoCd;



    private String prjRoCdName;
}
