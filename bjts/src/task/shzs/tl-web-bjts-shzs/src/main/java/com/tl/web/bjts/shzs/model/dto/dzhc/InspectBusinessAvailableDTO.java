package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

import java.util.List;

/**
 * @描述: 获取出口业务数据dto
 * @作者: likun
 * @时间: 2022/4/24 14:58
 */
public class InspectBusinessAvailableDTO {
    // 纳税人识别号
    @NotEmpty(msg="【纳税人识别号】不能为空")
    private String nsrsbh;
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
