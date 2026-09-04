package com.tl.web.bjts.shzs.model.vo;

/**
 * @描述: 重要事项提醒返回vo
 * @作者: likun
 * @时间: 2022/4/25 10:05
 */
public class ItemNoticeVO {
    // 审单核查在办任务笔数
    private Integer dzhxZbbs;
    // 出口退税岗位在办-为金三中涉及出口退税的流程笔数
    private Integer gwzbLcbs;
    // 出口退税岗位在办-为其中即将超期的业务笔数
    private Integer gwzbJjcq;

    public Integer getDzhxZbbs() {
        return dzhxZbbs;
    }

    public void setDzhxZbbs(Integer dzhxZbbs) {
        this.dzhxZbbs = dzhxZbbs;
    }

    public Integer getGwzbLcbs() {
        return gwzbLcbs;
    }

    public void setGwzbLcbs(Integer gwzbLcbs) {
        this.gwzbLcbs = gwzbLcbs;
    }

    public Integer getGwzbJjcq() {
        return gwzbJjcq;
    }

    public void setGwzbJjcq(Integer gwzbJjcq) {
        this.gwzbJjcq = gwzbJjcq;
    }
}
