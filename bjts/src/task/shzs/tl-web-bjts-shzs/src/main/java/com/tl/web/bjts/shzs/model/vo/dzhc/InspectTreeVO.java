package com.tl.web.bjts.shzs.model.vo.dzhc;

import java.util.List;

/**
 * @描述: 核查单证类型树
 * @作者: likun
 * @时间: 2021/5/10 14:09
 */
public class InspectTreeVO {
    private String name;
    //是否已勾选
    private Boolean checked;
    //是否不能编辑
    private Boolean chkDisabled;
    private List<InspectTreeSubVO> item;

    public class InspectTreeSubVO{
        private String name;
        private String value;
        //是否已勾选
        private Boolean checked;
        //是否不能编辑
        private Boolean chkDisabled;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public Boolean getChecked() {
            return checked;
        }

        public void setChecked(Boolean checked) {
            this.checked = checked;
        }

        public Boolean getChkDisabled() {
            return chkDisabled;
        }

        public void setChkDisabled(Boolean chkDisabled) {
            this.chkDisabled = chkDisabled;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public Boolean getChkDisabled() {
        return chkDisabled;
    }

    public void setChkDisabled(Boolean chkDisabled) {
        this.chkDisabled = chkDisabled;
    }

    public List<InspectTreeSubVO> getItem() {
        return item;
    }

    public void setItem(List<InspectTreeSubVO> item) {
        this.item = item;
    }
}
