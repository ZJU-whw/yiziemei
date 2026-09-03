package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_TASK_SUB")
public class JcfxTaskSubModel implements Serializable {
    @Id
    @Column(name = "PID")
    private String pid;

    @Id
    @Column(name = "PAGE_NO")
    private BigDecimal pageNo;

    @Column(name = "RESP_DATA")
    private byte[] respData;

    private static final long serialVersionUID = 1L;

    /**
     * @return PID
     */
    public String getPid() {
        return pid;
    }

    /**
     * @param pid
     */
    public void setPid(String pid) {
        this.pid = pid == null ? null : pid.trim();
    }

    /**
     * @return PAGE_NO
     */
    public BigDecimal getPageNo() {
        return pageNo;
    }

    /**
     * @param pageNo
     */
    public void setPageNo(BigDecimal pageNo) {
        this.pageNo = pageNo;
    }

    /**
     * @return RESP_DATA
     */
    public byte[] getRespData() {
        return respData;
    }

    /**
     * @param respData
     */
    public void setRespData(byte[] respData) {
        this.respData = respData;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", pid=").append(pid);
        sb.append(", pageNo=").append(pageNo);
        sb.append(", respData=").append(respData);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}