package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.NotNull;

import java.util.Date;
import java.util.List;

/**
 * @描述: 获取单证核查类型树
 * @作者: likun
 * @时间: 2021/10/18 9:35
 */
public class InspectTreeDTO {
    @NotEmpty(msg="纳税人识别号不能为空")
    private String nsrsbh;
    @NotEmpty(msg="报关单信息的出口业务类型不能为空")
    private List<InspectTreeEntryDTO> entryIds;
    // 类型 老板的可不用传值，日常审单核查传值 daily，年度单证核查传值year
    private String type;

    public class InspectTreeEntryDTO{
        private String ywlxCode; // 业务类型代码
        private String entryId; // 报关单号
        private Date sbrq; // 申报日期
        private String sbywzl;
        private String sbnypc;

        public String getYwlxCode() {
            return ywlxCode;
        }

        public void setYwlxCode(String ywlxCode) {
            this.ywlxCode = ywlxCode;
        }

        public String getEntryId() {
            return entryId;
        }

        public void setEntryId(String entryId) {
            this.entryId = entryId;
        }

        public Date getSbrq() {
            return sbrq;
        }

        public void setSbrq(Date sbrq) {
            this.sbrq = sbrq;
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
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public List<InspectTreeEntryDTO> getEntryIds() {
        return entryIds;
    }

    public void setEntryIds(List<InspectTreeEntryDTO> entryIds) {
        this.entryIds = entryIds;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }


}
