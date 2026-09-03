package com.tl.bjts.sw.model.dto;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/6/6.
 * @Description:
 */
public class VirSwjgDTO {

    private String virSwjgdm;

    private String yxbz;

    private String virName;

    private List<SubSwjg> sublist;

    public String getVirSwjgdm() {
        return this.virSwjgdm;

    }

    public void setVirSwjgdm(String virSwjgdm) {
        this.virSwjgdm = virSwjgdm;
    }


    public String getYxbz() {
        return this.yxbz;

    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }

    public String getVirName() {
        return this.virName;

    }

    public void setVirName(String virName) {
        this.virName = virName;
    }


    public List<SubSwjg> getSublist() {
        return this.sublist;

    }

    public void setSublist(List<SubSwjg> sublist) {
        this.sublist = sublist;
    }

    public static class SubSwjg{

        private String swjgdm;
        private String swjgmc;

        public String getSwjgdm() {
            return this.swjgdm;

        }

        public void setSwjgdm(String swjgdm) {
            this.swjgdm = swjgdm;
        }

        public String getSwjgmc() {
            return this.swjgmc;

        }

        public void setSwjgmc(String swjgmc) {
            this.swjgmc = swjgmc;
        }
    }
}
