package com.tl.bjts.sw.utils;
import javautil.Pair;
import javautil.ResultException;
import org.apache.commons.lang3.StringUtils;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 说明：自定义时间共有类
 * 作者：李坤
 * 时间：3/5/20
 */
public class DateUtilSelf {
    public static  String monthFormat = "%02d"; //月份显示格式 如果月份为1，则展示为01
    public  static List<String>  pattens = new ArrayList<>();


    public static Date strToDate(String date, String pattern){
        try {
            return new Date(strToDateTime(date, pattern).getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static java.util.Date strToDateTime(String date, String pattern)
    {
        try {
            if (date == null) {
                return null;
            } else {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                return sdf.parse(date);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据传递的年月下一个月所在的年月
     * @param year  年
     * @param month  月
     * @return  下一个月所在的年月
     */
    public static String getNextYm(String year, String month){
        if(StringUtils.isBlank(year) || StringUtils.isBlank(month)){
            return null;
        }

        String nextYear = year;
        String nextMonth =  String.format(monthFormat, Integer.parseInt(month) + 1);
        if(Integer.parseInt(month) == 12){
            nextYear = String.valueOf(Integer.parseInt(year) + 1);
            nextMonth = "01";
        }
        return nextYear.concat(nextMonth);
    }

    /**
     * 根据传递的年月获取上一个月所在的年月
     * @param year  年
     * @param month  月
     * @return  上一个月所在的年月
     */
    public static Pair getLastYm(String year, String month){
        if(StringUtils.isBlank(year) || StringUtils.isBlank(month)){
            return null;
        }

        String LastYear = year;
        String LastMonth =  String.format(monthFormat, Integer.parseInt(month) - 1);
        if(Integer.parseInt(month) == 1){
            LastYear = String.valueOf(Integer.parseInt(year) - 1);
            LastMonth = "12";
        }
        return new Pair(LastYear,LastMonth);
    }
}
