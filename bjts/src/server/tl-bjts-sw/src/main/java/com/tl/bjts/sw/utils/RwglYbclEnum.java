package com.tl.bjts.sw.utils;

/**
 * 描述:任务管理异步处理枚举类
 * 作者 likun
 * 时间 2020-05-10 19:04
 */
public enum RwglYbclEnum {

    E01001("E01001","01","出口退税和外贸出口情况"),
    D01002("D01002","01","地区出口退税基本情况"),
    D01003("D01003","01","分大类商品出口数据统计"),
    D01004("D01004","01","出口贸易国家分布查询统计"),
    D01005("D01005","01","出口企业排名情况统计"),
    D01006("D01006","01","出口商品退税率分布情况统计"),
    D01007("D01007","01","出口企业行业分布情况统计"),
    D01008("D01008","01","出口海关分布情况统计"),
    D01009("D01009","01","出口监管方式情况统计"),
    D01010("D01010","01","外贸供货企业分析"),
    CX10001("CX10001","01","出口退税审核审批表查询");

    private String code; //代码
    private String rwlx; //任务类型
    private String rwms; //任务描述

    RwglYbclEnum(String code, String rwlx,String rwms) {
        this.code = code;
        this.rwlx = rwlx;
        this.rwms = rwms;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getRwlx() {
        return rwlx;
    }

    public void setRwlx(String rwlx) {
        this.rwlx = rwlx;
    }


    public String getRwms() {
        return rwms;
    }

    public void setRwms(String rwms) {
        this.rwms = rwms;
    }
}
