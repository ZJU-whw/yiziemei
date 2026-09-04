package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

/**
 * @描述: 查询日常审单核查列表
 * @作者: likun
 * @时间: 2022/4/24 17:02
 */
public class InspectQueryDTO extends BaseListDTO {
    private String swjgdm;
    // 税号
    @NotEmpty(msg = "纳税人识别号不能为空")
    private String nsrsbh;
    // 申报年月批次
    @NotEmpty(msg = "申报年月批次不能为空")
    private String sbnypc;

    private String releaser; // 下达人

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

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getReleaser() {
        return releaser;
    }

    public void setReleaser(String releaser) {
        this.releaser = releaser;
    }
}
