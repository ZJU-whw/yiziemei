package com.tl.web.bjts.shzs.utils;

import com.tl.web.bjts.shzs.exception.BusinessException;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * @Author：Mamf
 * @Date: 2017/7/18.
 * @Description:
 */
public class TlUtils {
    /*
  批次格式：xx
   */
    public static String dealSbpc(String sbpc) {
        //sbpc = getSbpc(Integer.parseInt(sbpc));
        return sbpc;
    }

    /** 生成2位sbpc
     * 1.序号小于100，转换为"01"、"02"之类的格式
     * 2.超过100时，转换为"A1"，"A2"之类的格式。数据的前两位从10到35分别转换为A到Z。
     * @param xh 序号
     * @return  2位sbpc
     */
    public static String getSbpc(int xh) {
        DecimalFormat sbpcDecimalFormat = new DecimalFormat("00"); // 申报表序号数值格式化。
        String sbpc;
        if (xh < 100) { // 小于100时，转换为"01"、"02"之类的格式
            sbpc = sbpcDecimalFormat.format(xh);
        } else { // 超过100时，转换为"A1"，"A2"之类的格式。数据的前两位从10到35分别转换为A到Z。
            int pre2 = xh / 10 - 10;
            char c = (char) ('A' + pre2);
            DecimalFormat df = new DecimalFormat("0");
            sbpc = c + df.format(xh % 10);
        }
        return sbpc;
    }

    /**
     * 获取权限税务机关代码
     * @param swjgDm 税务机关代码
     * @return
     */
    public static String getPreSwjgdm(String swjgDm){
        if (swjgDm==null||swjgDm.equals("")){
            return "";
        }
        while("00".equals(swjgDm.substring(swjgDm.length()-2,swjgDm.length()))){
            swjgDm=swjgDm.substring(0,swjgDm.length()-2);
        }
        return swjgDm;
    }

    /**
     * 判断字符串是否都是数字
     * @param str 待判断的字符串
     * @return  true：是  false:否
     */
    public static boolean isNumeric(String str){
        for (int i = str.length();--i>=0;){
            if (!Character.isDigit(str.charAt(i))){
                return false;
            }
        }
        return true;
    }

    /**
     * 获取异常或业务异常的错误信息
     * @param e
     * @return
     */
    public static String getErrorMsg(Exception e){
        String msg = "";
        if(e instanceof BusinessException){
            BusinessException businessException = (BusinessException) e;
            msg = businessException.getMsg();
        }else {
            msg = e.getMessage();
        }
        return msg;
    }

    public static Date parseString2Date(String dateStr, String pattern) {
        if (dateStr == null || "".equals(dateStr) || pattern == null || "".equals(pattern)) {
            return null;
        }
        Date date = null;
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        try {
            date = format.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }
}
