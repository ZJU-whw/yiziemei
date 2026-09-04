package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.NotEmpty;

import java.util.List;

/**
 * @描述: 校验日常审单核查状态dto
 * @作者: likun
 * @时间: 2022/4/22 15:56
 */
public class ShzsInspectStateCheckDTO {
    // 纳税人识别号
    @NotEmpty(msg="【纳税人识别号】不能为空")
    private String nsrsbh;
    // 申报业务种类
    private String sbywzl;
    // 申报年月批次
    @NotEmpty(msg="【申报年月批次】不能为空")
    private String sbnypc;
    // 18位报关单号
    @NotEmpty(msg="【报关单数据】不能为空")
    private List<String> entryIds;

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getSbywzl() {
        return sbywzl;
    }

    public void setSbywzl(String sbywzl) {
        this.sbywzl = sbywzl;
    }

    public String getSbnypc() {
        return sbnypc;
    }

    public void setSbnypc(String sbnypc) {
        this.sbnypc = sbnypc;
    }

    public List<String> getEntryIds() {
        return entryIds;
    }

    public void setEntryIds(List<String> entryIds) {
        this.entryIds = entryIds;
    }
}
