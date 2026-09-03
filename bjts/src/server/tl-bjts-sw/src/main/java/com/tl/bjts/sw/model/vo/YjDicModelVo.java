package com.tl.bjts.sw.model.vo;

import com.tl.bjts.sw.model.domain.YjDicModel;
import com.tl.bjts.sw.utils.TlCalculateUtils;

import java.math.BigDecimal;

/**
 * @Author：Mamf
 * @Date: 2019/9/2.
 * @Description:
 */
public class YjDicModelVo extends YjDicModel {

    private String zxflagZh;

    private String yjlxZh;

    private String tsywlxZh;

    private String syqyZh;

    private String yxbzZh;

    public String getZxflagZh() {
        if("1".equals(super.getZxflag())){
            return "是";
        }else if("0".equals(super.getZxflag())){
            return "否";
        }
        return "";
    }


    public String getYjlxZh() {
        if("1".equals(super.getYjlx())){
            return "综合预警";
        }else if("2".equals(super.getYjlx())){
            return "按单预警";
        }else if("3".equals(super.getYjlx())){
            return "汇总预警";
        }

        return "";
    }

    public String getTsywlxZh() {

        StringBuffer sb=new StringBuffer();

        if(super.getTsywlx()!=null) {


            String s = TlCalculateUtils.toBinary(super.getTsywlx().intValue(), 4);
            String[] split = s.split("");

            if ("1".equals(split[3])) {
                sb.append(",生产");
            }
            if ("1".equals(split[2])) {
                sb.append(",外贸");
            }
            if ("1".equals(split[1])) {
                sb.append(",外综服");
            }
            if ("1".equals(split[0])) {
                sb.append(",周边业务");
            }

        }

        if(sb.toString().length()>0){
            return sb.toString().substring(1);
        }else {
            return sb.toString();
        }
    }


    public String getYxbzZh() {

        if("1".equals(super.getYxbz())){
            return "启用";
        }else if("0".equals(super.getYxbz())){
            return "关闭";
        }

        return "";
    }
}
