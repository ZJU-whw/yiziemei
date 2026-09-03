package com.tl.bjts.sw.utils;

import com.tl.common.utils.CryptManager;
import javautil.NumberUtil;
import org.apache.commons.jexl2.Expression;
import org.apache.commons.jexl2.JexlContext;
import org.apache.commons.jexl2.JexlEngine;
import org.apache.commons.jexl2.MapContext;
import org.apache.commons.lang3.StringUtils;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/*
 * @Description: 计算工具
 * @Author Neo Lin
 * @Date  2018/4/19 21:29
 */
public class TlCalculateUtils {

    private TlCalculateUtils(){}

    /*
     * @Description: 误差范围校验
     * @Author Neo Lin
     * @param  [currentValue , value, range 误差范围百分比]
     * @return  boolean
     * @Date  2018/4/19
     */
    public static boolean compareWithRange(BigDecimal currentValue,BigDecimal value,BigDecimal range){
        BigDecimal abs = currentValue.subtract(value).abs();
        BigDecimal realRange = abs.divide(currentValue,6, RoundingMode.HALF_UP);
        //realRange<range
        return realRange.compareTo(range) == -1;
    }

    public static boolean compareWithRangeByNumber(BigDecimal currentValue,BigDecimal value,BigDecimal range){
        BigDecimal abs = currentValue.subtract(value).abs();
        return abs.compareTo(range) == -1;
    }

    //生成随机密码
    public static String makeRandomPassword(int len){
        char charr[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890~!@#$%^&*.?".toCharArray();
        StringBuilder sb = new StringBuilder();
        Random r = new Random();
        for (int x = 0; x < len; ++x) {
            sb.append(charr[r.nextInt(charr.length)]);
        }
        return sb.toString();
    }

    public static String aesEncrypt(String src){
        if(src == null || "".equals(src)){
            return "";
        }
        byte[] b = "".getBytes();
        try {
            b = CryptManager.getIns().aesEncrypt(src.getBytes("UTF-8"), TlConst.TL_KEY.getBytes("UTF-8"));

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return CryptManager.byteToHex(b);
    }

    /*
     * @Description: base64编码
     * @param  [data]
     * @return  java.lang.String
     */
    public static String base64Encode(byte[] data){
        Base64.Encoder encoder = Base64.getEncoder();
        //编码
        return encoder.encodeToString(data);

    }

    /*
     * @Description: base64解码
     * @param  [content]
     * @return  byte[]
     */
    public static byte[] base64Decode(String content){
        Base64.Decoder decoder = Base64.getDecoder();
        //解码
        return decoder.decode(content);
    }

    /*
     * @Description: 获取Cdata中的内容
     * @param  [content]
     * @return  java.lang.String
     */
    public static String getCDATAContent(String content){
        if(content == null || "".equals(content)) return "";
        Pattern p = Pattern.compile(".*<!\\[CDATA\\[(.*)\\]\\]>.*");
        Matcher m = p.matcher(content);
        if(m.matches()) {
            return m.group(1);
        }
        return content;
    }

    public static String dealPercent(BigDecimal value){
        if(value == null){
            return "";
        }
        return value.multiply(BigDecimal.valueOf(100L)).setScale(2, RoundingMode.HALF_UP).toString();
    }


    /**
     * 获得指定日期的前一天
     * @param specifiedDay
     * @return
     * @throws Exception
     */
    public static Date getSpecifiedDayBefore(String specifiedDay){
        Calendar c = Calendar.getInstance();
        Date date=null;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        c.setTime(date);
        int day=c.get(Calendar.DATE);
        c.set(Calendar.DATE,day-1);

        return c.getTime();

        //String dayBefore=new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
        //return dayBefore;
    }


    /**
     * 获取上个月的今天的日期
     * @param pattam
     * @return
     */
    public static String  getLastMonthToday(String pattam){
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.MONTH, -1);
        Date date3 = cal.getTime();
        SimpleDateFormat format3= new SimpleDateFormat(pattam);
        return format3.format(date3);
    }
    /**
     * 获得指定日期的后一天
     * @param specifiedDay
     * @return
     */
    public static Date getSpecifiedDayAfter(String specifiedDay){

        if(StringUtils.isBlank(specifiedDay)){
            return null;
        }

        Calendar c = Calendar.getInstance();
        Date date=null;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        c.setTime(date);
        int day=c.get(Calendar.DATE);
        c.set(Calendar.DATE,day+1);

        return c.getTime();

        //String dayAfter=new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
        //return dayAfter;
    }


    public static boolean isNumeric(String str) {
        // 该正则表达式可以匹配所有的数字 包括负数
        Pattern pattern = Pattern.compile("-?[0-9]+\\.?[0-9]*");
        String bigStr;
        try {
            bigStr = new BigDecimal(str).toString();
        } catch (Exception e) {
            return false;//异常 说明包含非数字。
        }
        Matcher isNum = pattern.matcher(bigStr); // matcher是全匹配
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }


    static boolean isNumber(String str) {//判断表达式是不是只有一个数字
        for(int i=0;i<str.length();i++) {

            if(!Character.isDigit(str.charAt(i)) && str.charAt(i)!='.') return false;
        }
        return
                true;
    }

    public static BigDecimal getResult(String jexlExp, Map<String,Object> map,int scale) {
        JexlEngine jexl = new JexlEngine();
        Expression expression = jexl.createExpression(jexlExp);
        JexlContext jc = new MapContext(map);
        if (null == expression.evaluate(jc)) {
            return null;
        }
        Object obj = expression.evaluate(jc);
        BigDecimal result = new BigDecimal ( null == obj ? "0" : obj.toString () );
        return result.setScale (scale, BigDecimal.ROUND_HALF_UP );
    }


    /**
     * 将一个int数字转换为二进制的字符串形式。
     * @param num 需要转换的int类型数据
     * @param digits 要转换的二进制位数，位数不足则在前面补0
     * @return 二进制的字符串形式
     */
    public static String toBinary(int num, int digits) {
        int value = 1 << digits | num;
        String bs = Integer.toBinaryString(value); //0x20 | 这个是为了保证这个string长度是6位数
        return  bs.substring(1);
    }

    /**
     * 如果参数为null，返回0。否则返回BigDecimal值。
     * @param n 必须是Number值
     * @return 转换后的数值
     */
    public static BigDecimal nullToZero(Object n) {
        if(n == null) {
            return BigDecimal.ZERO;
        }
        return NumberUtil.toBigDecimal((Number)n);
    }


    /**
     * 千分位方法
     * @param text
     * @return
     */
    public static String fmtMicrometer(String text)
    {
        DecimalFormat df = null;
        if(text.indexOf(".") > 0)
        {
            if(text.length() - text.indexOf(".")-1 == 0)
            {
                df = new DecimalFormat("###,##0.");
            }else if(text.length() - text.indexOf(".")-1 == 1)
            {
                df = new DecimalFormat("###,##0.0");
            }else
            {
                df = new DecimalFormat("###,##0.00");
            }
        }else
        {
            df = new DecimalFormat("###,##0");
        }
        double number = 0.0;
        try {
            number = Double.parseDouble(text);
        } catch (Exception e) {
            number = 0.0;
        }
        return df.format(number);
    }



}
