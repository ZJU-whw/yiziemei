package com.tl.bjts.sw.model.vo;

import com.tl.bjts.sw.model.domain.YjDicYjzbModel;

import java.math.BigDecimal;

/**
 * @Author：Mamf
 * @Date: 2019/9/3.
 * @Description:
 */
public class YjDicYjzbModelVo  extends YjDicYjzbModel{

    private String yxbz;

    private String p2valchange;

    private String p1valchange;

    private String p3valchange;

    private String p4valchange;

    private String swjgdm;

    private String swjgmc;

    public void setP3valchange(String p3valchange) {
        this.p3valchange = p3valchange;
    }

    public void setP4valchange(String p4valchange) {
        this.p4valchange = p4valchange;
    }

    public String getP2valchange() {

        if(p2valchange!=null && p2valchange.startsWith(".")){
            return "0"+p2valchange;
        }else if(p2valchange!=null && p2valchange.startsWith("-.")){
            p2valchange=p2valchange.replace("-.","-0.");
        }

        return p2valchange;
    }

    public String getP3valchange() {

        if(p3valchange!=null && p3valchange.startsWith(".")){
            return "0"+p3valchange;
        }else if(p3valchange!=null && p3valchange.startsWith("-.")){
            p3valchange=p3valchange.replace("-.","-0.");
        }

        return p3valchange;
    }

    public String getP4valchange() {

        if(p4valchange!=null && p4valchange.startsWith(".")){
            return "0"+p4valchange;
        }else if(p4valchange!=null && p4valchange.startsWith("-.")){
            p4valchange=p4valchange.replace("-.","-0.");
        }

        return p4valchange;
    }

    public void setP2valchange(String p2valchange) {
        this.p2valchange = p2valchange;
    }

    public void setP1valchange(String p1valchange) {
        this.p1valchange = p1valchange;
    }

    public String getP1valchange() {

        if(p1valchange!=null && p1valchange.startsWith(".")){
            return "0"+p1valchange;
        }else if(p1valchange!=null && p1valchange.startsWith("-.")){
            p1valchange=p1valchange.replace("-.","-0.");
        }

        return p1valchange;
    }


    public String getYxbz() {

        if("Y".equals(yxbz)){
            return "启用";
        }else if("N".equals(yxbz)){
            return "关闭";
        }

        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }

    public String getSyqyZh() {
        if("1".equals(super.getSyqy())){
            return "是";
        }else if("0".equals(super.getSyqy())){
            return "否";
        }

        return "";
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getSwjgmc() {
        return swjgmc;
    }

    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc;
    }
}
