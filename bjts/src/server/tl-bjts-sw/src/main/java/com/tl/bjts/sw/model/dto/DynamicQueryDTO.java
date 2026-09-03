package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/11/1
 * @description 动态多指标查询传输对象
 */
public class DynamicQueryDTO extends BaseListDTO {


    private String exportFlag;

    private String flushFlag;

    private String isHaveTb;

    private String logonSwjgDm;

    private String swjgDm;

    private String ssnyStart;

    private String ssnyEnd;

    private String title;

    private String pid; //第一页的父亲UUID，用于生成翻页子记录时天聪

    private String hztype; //前端标识汇总类型，用于复现查询历史数据时还原条件

    private Long zid; //样本组ID

    private List<String> hzItems;

    private List<FzItem> fzItems;

    private String tjbbType; //统计报表类型，用于特殊报表类型区分标记  1-免退税情况统计表  2-特殊业务情况表

    public String getExportFlag() {
        return this.exportFlag;

    }

    public void setExportFlag(String exportFlag) {
        this.exportFlag = exportFlag;
    }

    public String getPid() {
        return this.pid;

    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getHztype() {
        return this.hztype;

    }

    public void setHztype(String hztype) {
        this.hztype = hztype;
    }

    public String getTitle() {
        return this.title;

    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTjbbType() {
        return this.tjbbType;

    }

    public void setTjbbType(String tjbbType) {
        this.tjbbType = tjbbType;
    }

    public Long getZid() {
        return this.zid;

    }

    public void setZid(Long zid) {
        this.zid = zid;
    }

    public String getIsHaveTb() {
        return this.isHaveTb;

    }

    public void setIsHaveTb(String isHaveTb) {
        this.isHaveTb = isHaveTb;
    }

    public String getFlushFlag() {
        return this.flushFlag;

    }

    public void setFlushFlag(String flushFlag) {
        this.flushFlag = flushFlag;
    }

    public String getLogonSwjgDm() {
        return this.logonSwjgDm;

    }

    public void setLogonSwjgDm(String logonSwjgDm) {
        this.logonSwjgDm = logonSwjgDm;
    }

    public String getSwjgDm() {
        return this.swjgDm;

    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getSsnyStart() {
        return this.ssnyStart;

    }

    public void setSsnyStart(String ssnyStart) {
        this.ssnyStart = ssnyStart;
    }

    public String getSsnyEnd() {
        return this.ssnyEnd;

    }

    public void setSsnyEnd(String ssnyEnd) {
        this.ssnyEnd = ssnyEnd;
    }

    public List<String> getHzItems() {
        return this.hzItems;

    }

    public void setHzItems(List<String> hzItems) {
        this.hzItems = hzItems;
    }

    public List<FzItem> getFzItems() {
        return this.fzItems;

    }

    public void setFzItems(List<FzItem> fzItems) {
        this.fzItems = fzItems;
    }


    public static class FzItem{

        private String zbxmbm;

        private String name;

        private String range;

        private List<String> values;

        public String getRange() {
            return this.range;

        }

        public void setRange(String range) {
            this.range = range;
        }

        public String getZbxmbm() {
            return this.zbxmbm;

        }

        public void setZbxmbm(String zbxmbm) {
            this.zbxmbm = zbxmbm;
        }

        public List<String> getValues() {
            return this.values;

        }

        public void setValues(List<String> values) {
            this.values = values;
        }

        public String getName() {
            return this.name;

        }

        public void setName(String name) {
            this.name = name;
        }
    }
}


