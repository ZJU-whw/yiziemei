package com.tl.bjts.sw.model.vo;

import com.tl.bjts.sw.model.domain.VirtualSwjgModel;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/6/6.
 * @Description:
 */
public class VirSwjgVo extends VirtualSwjgModel {

    private List<SubSwjg> sublist;

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
