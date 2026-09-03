package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.annotation.NotEmpty;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2019/10/9.
 * @Description:
 */
public class SavaDataDTO {

    @NotEmpty
    private String bbid;

    @NotEmpty
    private String bbdm;

    @NotEmpty
    private List<Map<String, String>> data;

    private String ssny;

    private List<String> delBblcs;

    public String getSsny() {
        return ssny;
    }

    public void setSsny(String ssny) {
        this.ssny = ssny;
    }

    public List<String> getDelBblcs() {
        return delBblcs;
    }

    public void setDelBblcs(List<String> delBblcs) {
        this.delBblcs = delBblcs;
    }

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public List<Map<String, String>> getData() {
        return data;
    }

    public void setData(List<Map<String, String>> data) {
        this.data = data;
    }

    public String getBbid() {
        return bbid;
    }

    public void setBbid(String bbid) {
        this.bbid = bbid;
    }
}
