package com.tl.web.bjts.shzs.model.vo.dbwp;

/**
 * @description 税务人员信息
 * @author: Mamf
 * @date: 2024/9/19 10:00
 */
public class SwryVo {

    private String swrysfDm;

    private String rysfmc;

    private boolean isOnline;


    private String status;

    public String getStatus() {
        return this.status;

    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean getIsOnline() {
        return this.isOnline;

    }

    public void setIsOnline(boolean online) {
        this.isOnline = online;
    }

    public String getSwrysfDm() {
        return this.swrysfDm;

    }

    public void setSwrysfDm(String swrysfDm) {
        this.swrysfDm = swrysfDm;
    }

    public String getRysfmc() {
        return this.rysfmc;

    }

    public void setRysfmc(String rysfmc) {
        this.rysfmc = rysfmc;
    }
}
