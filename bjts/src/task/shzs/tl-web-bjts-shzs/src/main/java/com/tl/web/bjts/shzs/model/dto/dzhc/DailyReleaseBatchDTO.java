package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;

import java.util.Date;

/**
 * @描述: 日常审单核查-批量下达dto
 * @作者: likun
 * @时间: 2022/2/11 16:07
 */
public class DailyReleaseBatchDTO {
    @NotEmpty(msg="日常审单核查业务序号不能为空")
    private String ids;
    @NotEmpty(msg="资料报送期限不能为空")
    private Date overdule; // 	资料报送期限
    @MaxLength(length = 30,msg = "【联系电话】最大长度不能超过30位")
    private String lxdh; // 联系电话

    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public Date getOverdule() {
        return overdule;
    }

    public void setOverdule(Date overdule) {
        this.overdule = overdule;
    }

    public String getLxdh() {
        return lxdh;
    }

    public void setLxdh(String lxdh) {
        this.lxdh = lxdh;
    }

    @Override
    public String toString() {
        return "DailyReleaseBatchDTO{" +
                "ids='" + ids + '\'' +
                ", overdule=" + overdule +
                ", lxdh='" + lxdh + '\'' +
                '}';
    }
}
