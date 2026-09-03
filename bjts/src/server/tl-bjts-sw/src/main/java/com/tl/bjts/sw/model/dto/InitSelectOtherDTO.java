package com.tl.bjts.sw.model.dto;

import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/12/28
 * @description
 */
public class InitSelectOtherDTO {


    private String zbdldm;

    private List<String> zbxms;

    public String getZbdldm() {
        return this.zbdldm;

    }

    public void setZbdldm(String zbdldm) {
        this.zbdldm = zbdldm;
    }

    public List<String> getZbxms() {
        return this.zbxms;

    }

    public void setZbxms(List<String> zbxms) {
        this.zbxms = zbxms;
    }
}
