package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.model.domain.TjbbTbxx;

/**
 * @Author：Mamf
 * @Date: 2020/3/10.
 * @Description:
 */
public class TbxxExtDTO extends TjbbTbxx{

    private String qylx;

    private String myg;

    private String xdtj;

    private String pmtj;

    public String getPmtj() {
        return pmtj;
    }

    public void setPmtj(String pmtj) {
        this.pmtj = pmtj;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public String getMyg() {
        return myg;
    }

    public void setMyg(String myg) {
        this.myg = myg;
    }

    public String getXdtj() {
        return xdtj;
    }

    public void setXdtj(String xdtj) {
        this.xdtj = xdtj;
    }
}
