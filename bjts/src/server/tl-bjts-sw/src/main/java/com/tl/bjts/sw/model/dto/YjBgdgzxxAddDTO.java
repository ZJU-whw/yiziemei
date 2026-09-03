package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;


/**
 * 报关单关注信息新增/编辑DTO
 */
public class YjBgdgzxxAddDTO {

    /** 金三企业登记序号 */
    @NotEmpty(msg = "金三企业登记序号不能为空")
    private String djxh;

    /** 出口报关单号 */
    @NotEmpty(msg = "出口报关单号不能为空")
    @MaxLength(length = 21, msg = "出口报关单号长度不能超过21位")
    private String ckbgdh;

    /** 关注信息 */
    @MaxLength(length = 1000, msg = "关注信息长度不能超过1000位")
    @NotEmpty(msg = "关注信息不能为空")
    private String gzxx;

    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getCkbgdh() {
        return ckbgdh;
    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
    }

    public String getGzxx() {
        return gzxx;
    }

    public void setGzxx(String gzxx) {
        this.gzxx = gzxx;
    }
}
