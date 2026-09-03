package com.tl.bjts.sw.utils;

import org.apache.commons.lang3.StringUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/* *
 *类名：UtilDate
 *功能：自定义日期
 *详细：工具类，可以用作获取系统日期
 *版本：3.3
 *日期：2012-08-17

 */
public class DateUtils {

    /** 完整时间 yyyy-MM-dd HH:mm:ss */
    public static final String SIMPLE    = "yyyy-MM-dd HH:mm:ss";

    /** 完整时间 yyyy-MM-dd */
    public static final String YMD   = "yyyy-MM-dd";

    public static String getDateStr(String format){
        if(StringUtils.isEmpty(format))
            format = SIMPLE;
        return new SimpleDateFormat(format).format(new Date());
    }


    public static Date strToDate(String strDate) {
        SimpleDateFormat formatter = new SimpleDateFormat(YMD);
        if(null == strDate || "".equals(strDate)){
            return null;
        }
        Date strtodate = null;
        try {
            formatter.setLenient(false);
            strtodate = formatter.parse(strDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return strtodate;
    }

    private static void setMinTime(Calendar calendar){
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
    }

    private static void setMaxTime(Calendar calendar){
        calendar.set(Calendar.HOUR_OF_DAY, calendar.getActualMaximum(Calendar.HOUR_OF_DAY));
        calendar.set(Calendar.MINUTE, calendar.getActualMaximum(Calendar.MINUTE));
        calendar.set(Calendar.SECOND, calendar.getActualMaximum(Calendar.SECOND));
        calendar.set(Calendar.MILLISECOND, calendar.getActualMaximum(Calendar.MILLISECOND));
    }

    /**
     * 获取指定月的前一月（年）或后一月（年）
     * @param addYear
     * @param addMonth
     * @param addDate
     * @return 输入的时期格式为yyyy-MM-dd，输出的日期格式为yyyy-MM-dd
     * @throws Exception
     */
    public static Date getTime(Date sourceDate, int addYear, int addMonth,
                                  int addDate,String format) throws Exception {
        try {
            Calendar cal = Calendar.getInstance();
            cal.setTime(sourceDate);
            cal.add(Calendar.YEAR, addYear);
            cal.add(Calendar.MONTH, addMonth);
            cal.add(Calendar.DATE, addDate);

            SimpleDateFormat returnSdf = new SimpleDateFormat(
                    format);
            String dateTmp = returnSdf.format(cal.getTime());
            Date returnDate = returnSdf.parse(dateTmp);
            return returnDate;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }


    public final static String DEFAULT_PATTERN = "MM/dd/yyyy HH:mm:ss";
    public static String format(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat(DEFAULT_PATTERN);
        return sdf.format(date);
    }

    public static String format(Date date,String patt){
        SimpleDateFormat sdf = new SimpleDateFormat(patt);
        return sdf.format(date);
    }

    public static String getSimpleFormat(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat(SIMPLE);
        return sdf.format(date);
    }

    /**
     * 获取系统时间所在的所属时期
     * @param date
     * @return
     */
    public static String getCurrSssq(Date date){
        String SIMPLE    = "yyyyMM";
        SimpleDateFormat sdf = new SimpleDateFormat(SIMPLE);
        return sdf.format(date);
    }

    public static java.sql.Date getSqlDate(String dataStr){
        return java.sql.Date.valueOf(dataStr);
    }

}
