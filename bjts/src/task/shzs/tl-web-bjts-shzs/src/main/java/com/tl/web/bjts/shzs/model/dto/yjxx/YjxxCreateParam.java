package com.tl.web.bjts.shzs.model.dto.yjxx;

import com.tl.common.ext.annotation.NotEmpty;

/**
 * @Author whg
 * @create 2024/4/8 15:27
 * @description：
 */
public class YjxxCreateParam {

    /**
     * 操作人员代码
     */
    private String swryDm;

    /**
     * 流程税务事项代码
     */
    @NotEmpty(msg = "流程税务事项代码不能为空")
    private String lcswsxDm;

    /**
     * 流程实例ID
     */
    @NotEmpty(msg = "流程实例ID不能为空")
    private String lcslid;

    /**
     * 生成事中明细数量
     */
    private int num;

    /**
     * 通用参数集，逗号分割
     * 格式：prop1:value1;prop2:value2;prop3:value3...
     */
    private String props;

    /**
     * 报文格式唯一标识
     */
    private String bizKey;

    public String getProps() {
        return this.props;

    }

    public void setProps(String props) {
        this.props = props;
    }

    public String getSwryDm() {
        return swryDm;
    }

    public void setSwryDm(String swryDm) {
        this.swryDm = swryDm;
    }

    public String getLcswsxDm() {
        return lcswsxDm;
    }

    public void setLcswsxDm(String lcswsxDm) {
        this.lcswsxDm = lcswsxDm;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String getBizKey() {
        return bizKey;
    }

    public void setBizKey(String bizKey) {
        this.bizKey = bizKey;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
