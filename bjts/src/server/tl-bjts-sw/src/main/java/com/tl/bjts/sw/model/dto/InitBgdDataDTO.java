package com.tl.bjts.sw.model.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/3/5.
 * @Description:
 */
public class InitBgdDataDTO {


    private String swjgdm;

    private String qxdm;

    private String ssny;

    private String lastssny;

    private List<Month> months;

    private List<MonthCktse> monthCktses;

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getQxdm() {
        return qxdm;
    }

    public void setQxdm(String qxdm) {
        this.qxdm = qxdm;
    }

    public String getLastssny() {
        return lastssny;
    }

    public void setLastssny(String lastssny) {
        this.lastssny = lastssny;
    }

    public String getSsny() {
        return ssny;
    }

    public void setSsny(String ssny) {
        this.ssny = ssny;
    }

    public List<Month> getMonths() {
        return months;
    }

    public void setMonths(List<Month> months) {
        this.months = months;
    }

    public List<MonthCktse> getMonthCktses() {
        return monthCktses;
    }

    public void setMonthCktses(List<MonthCktse> monthCktses) {
        this.monthCktses = monthCktses;
    }

    public class Month{
        private String yue;
        private String month;

        public String getYue() {
            return yue;
        }

        public void setYue(String yue) {
            this.yue = yue;
        }

        public String getMonth() {
            return month;
        }

        public void setMonth(String month) {
            this.month = month;
        }
    }

    /**
     * 用于出口退税额的月份类
     */
    public class MonthCktse extends Month{
        private String byq; //本月起
        private String byz; //本月止

        private String sntqq; //上年同期起
        private String sntqz; //上年同期止
        private BigDecimal cktse;


        public BigDecimal getCktse() {
            return cktse;
        }

        public void setCktse(BigDecimal cktse) {
            this.cktse = cktse;
        }

        public String getByq() {
            return byq;
        }

        public void setByq(String byq) {
            this.byq = byq;
        }

        public String getByz() {
            return byz;
        }

        public void setByz(String byz) {
            this.byz = byz;
        }

        public String getSntqq() {
            return sntqq;
        }

        public void setSntqq(String sntqq) {
            this.sntqq = sntqq;
        }

        public String getSntqz() {
            return sntqz;
        }

        public void setSntqz(String sntqz) {
            this.sntqz = sntqz;
        }
    }

}
