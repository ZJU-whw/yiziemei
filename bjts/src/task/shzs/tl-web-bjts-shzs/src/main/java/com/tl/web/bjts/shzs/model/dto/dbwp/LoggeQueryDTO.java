package com.tl.web.bjts.shzs.model.dto.dbwp;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * @description 传参对象
 * @author: Mamf
 * @date: 2024/10/23 15:30
 */
public class LoggeQueryDTO extends BaseListDTO{

    private String qybs;

    private String swsxdm;

    private Date wpsjStart;

    private Date wpsjEnd;

    private String wpdx;

    private String status;

    public String getQybs() {
        return this.qybs;

    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getSwsxdm() {
        return this.swsxdm;

    }

    public void setSwsxdm(String swsxdm) {
        this.swsxdm = swsxdm;
    }

    public Date getWpsjStart() {
        return this.wpsjStart;

    }

    public void setWpsjStart(Date wpsjStart) {
        this.wpsjStart = wpsjStart;
    }

    public Date getWpsjEnd() {
        return this.wpsjEnd;

    }

    public void setWpsjEnd(Date wpsjEnd) {
        this.wpsjEnd = wpsjEnd;
    }

    public String getWpdx() {
        return this.wpdx;

    }

    public void setWpdx(String wpdx) {
        this.wpdx = wpdx;
    }

    public String getStatus() {
        return this.status;

    }

    public void setStatus(String status) {
        this.status = status;
    }
}
