package com.tl.web.bjts.shzs.model.dto.dbwp;


import com.tl.common.ext.model.BaseListDTO;
import com.tl.web.bjts.shzs.model.domain.ShzsWpTaskProfile;

import java.util.Date;
import java.util.List;

/**
 * @description 待办任务委派参数对象
 * @author: Mamf
 * @date: 2024/9/18 13:39
 */
public class DbwpDTO extends BaseListDTO{

    private String sfdm;

    private String qybs;

    private String lcswsxdm;

    private Date sbrqQ;

    private Date sbrqZ;

    private String type; //0：岗位待办 1、待办任务 2、在办任务明细

    private String status; //0：离线 1：上线

    private List<DbrwmxVo>  wpMxs;  //提交预分配任务列表

    private List<ShzsWpTaskProfile> mxs;

    public Date getSbrqQ() {
        return this.sbrqQ;

    }

    public void setSbrqQ(Date sbrqQ) {
        this.sbrqQ = sbrqQ;
    }

    public Date getSbrqZ() {
        return this.sbrqZ;

    }

    public void setSbrqZ(Date sbrqZ) {
        this.sbrqZ = sbrqZ;
    }

    public String getQybs() {
        return this.qybs;

    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getLcswsxdm() {
        return this.lcswsxdm;

    }

    public void setLcswsxdm(String lcswsxdm) {
        this.lcswsxdm = lcswsxdm;
    }

    public List<ShzsWpTaskProfile> getMxs() {
        return this.mxs;

    }

    public void setMxs(List<ShzsWpTaskProfile> mxs) {
        this.mxs = mxs;
    }

    public List<DbrwmxVo> getWpMxs() {
        return this.wpMxs;

    }

    public void setWpMxs(List<DbrwmxVo> wpMxs) {
        this.wpMxs = wpMxs;
    }

    public String getStatus() {
        return this.status;

    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return this.type;

    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSfdm() {
        return this.sfdm;

    }

    public void setSfdm(String sfdm) {
        this.sfdm = sfdm;
    }
}
