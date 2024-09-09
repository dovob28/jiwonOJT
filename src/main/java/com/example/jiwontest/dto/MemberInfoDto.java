package com.example.jiwontest.dto;

import com.oracle.wls.shaded.org.apache.bcel.classfile.Code;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

// 사원_정보
@NoArgsConstructor
@Getter
@Setter
@ToString
@Data
public class MemberInfoDto {

    private int memSeq;   // 사원번호
    private String memImg; // 사원사진

    private String memId; // 아이디
    private String memPw; // 비밀번호
    private String memNm; // 사원명

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date memBirth; // 생년월일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date memHireDate; // 입사입

    private String memRaCd; // 직급코드

    private String memDpCd; // 부서코드
    private String memDvCd; // 개발분야코드

    private String memPostCode; // 우편번호
    private String memAddr; // 주소
    private String memDetailAddr; // 상세주소
    private String memExtraAddr; // 참고주소

    private String memEmail; // 이메일
    private String memPhone; // 전화번호


    // mysql table x
    private String raCdNm; // 직급코드명
    private String dpCdNm; // 부서코드명
    private String dvCdNm; // 개발분야명

    // mysql table x, resister폼에 있음
    private List<String> memSkills; // 보유기술 => [1, 2, 7, 8]
    private List<CodeDetail> skillDetails; // 보유기술 CodeDetail
                                           // => [CodeDetail(mstCd=SK01, dtlCd=1, mstCdNm=null, dtlCdNm=Java),

    // 보유기술 선택을 위한 추가
    public void setSkillDetails(List<CodeDetail> skillDetails) {
        this.skillDetails = skillDetails;
        this.memSkills = skillDetails.stream().map(CodeDetail::getDtlCd).toList();
    }

    public String getRaCdNm() {
        return raCdNm;
    }

    /*public void setRaCdNm(String raCdNm) {
        this.raCdNm = raCdNm;
    }*/

    public String getDpCdNm() {
        return dpCdNm;
    }

    /*public void setDpCdNm(String dpCdNm) {
        this.dpCdNm = dpCdNm;
    }*/

    public String getDvCdNm() {
        return dvCdNm;
    }

    /*public void setDvCdNm(String dvCdNm) {
        this.dvCdNm = dvCdNm;
    }*/

    }



