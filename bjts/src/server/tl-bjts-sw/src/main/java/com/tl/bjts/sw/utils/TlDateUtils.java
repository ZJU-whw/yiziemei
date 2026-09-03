package com.tl.bjts.sw.utils;



import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/*
 * @Description: 时间处理工具类
 * @Author Neo Lin
 * @Date  2018/4/14 14:40
 */
public class TlDateUtils {

    private TlDateUtils() {
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

    public static String format(Date date, String pattern) {
        if (date == null || pattern == null || "".equals(pattern)) {
            return null;
        }
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.format(date);
    }

    public static Date getFirstDayOfMonth() {
        Calendar c = Calendar.getInstance();
        c.set(c.get(Calendar.YEAR), c.get(Calendar.MONTH), 1, 0, 0, 0);
        return c.getTime();
    }

    public static Date getFirstDayOfMonth(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.set(c.get(Calendar.YEAR), c.get(Calendar.MONTH), 1, 0, 0, 0);
        return c.getTime();
    }

    public static Date getFirstDayOfNextMonth() {
        Calendar c = Calendar.getInstance();
        c.set(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1, 1, 0, 0, 0);
        return c.getTime();
    }

    public static Date getFirstDayOfNextMonth(Date date) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.set(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1, 1, 0, 0, 0);
        return c.getTime();
    }

    public static Date addDay(Date date, Integer add){
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.set(c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DATE) + add, 0, 0, 0);
        return c.getTime();
    }

    /*
     * @Description: 如果是2019-01-01之前 返回2019-01-01 否则返回传入日期
     * @param  []
     * @return  java.util.Date
     */
    public static Date getShitDate(Date date){
        Calendar c = Calendar.getInstance();
        c.set(2019,0,1);
        if(date.getTime() < c.getTime().getTime()){
            return c.getTime();
        }else{
            return date;
        }
    }


    /*
     * @Description:  获取当月首个工作日
     * @param  [date]
     * @return  java.util.Date
     */
    public static Date getFirstWorkingDayOfMonth(Date date) {
        Date firstDate = getFirstDayOfMonth(date);
        Calendar c = Calendar.getInstance();
        c.setTime(firstDate);
        int week = c.get(Calendar.DAY_OF_WEEK);
        if (week == 1) { //周日
            c.add(Calendar.DAY_OF_MONTH,1);
            return c.getTime();
        }if (week == 7) { //周六
            c.add(Calendar.DAY_OF_MONTH,2);
            return c.getTime();
        }else {
            return c.getTime();
        }
    }

    /*
     * @Description: -1 less than  0 equal 1 greatter than
     * @param  [date]
     * @return  int
     */
    public static int compareWithNow(Date date) {
        Date now = new Date();
        long nowTime = now.getTime();
        long dateTime = date.getTime();
        return Long.compare(dateTime, nowTime);
    }
    /*
     * @Description: -1 less than  0 equal 1 greatter than
     * @param  [date]
     * @return  int
     */
    public static int compareDate(Date date, Date date2) {
        long date2Time = date2.getTime();
        long dateTime = date.getTime();
        return Long.compare(dateTime, date2Time);
    }


    /**
     * 计算两个日期之间相差的天数
     * @param smdate 较小的时间
     * @param bdate  较大的时间
     * @return 相差天数
     * @throws ParseException
     */
    public static int daysBetween(Date smdate,Date bdate){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");

        try{
            smdate=sdf.parse(sdf.format(smdate));
            bdate=sdf.parse(sdf.format(bdate));
        }catch (ParseException e) {
            e.printStackTrace();
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(smdate);
        long time1 = cal.getTimeInMillis();
        cal.setTime(bdate);
        long time2 = cal.getTimeInMillis();
        long between_days=(time2-time1)/(1000*3600*24);

        return Integer.parseInt(String.valueOf(between_days));
    }


    /**
     * 获得指定日期的后一天
     * @param specifiedDay
     * @return
     */
    public static Date getSpecifiedDayAfter(String specifiedDay){
        Calendar c = Calendar.getInstance();
        Date date=null;
        try {
            date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        c.setTime(date);
        int day=c.get(Calendar.DATE);
        c.set(Calendar.DATE,day+1);

        return c.getTime();
    }

    public static String getLastYearSsny(String ssny){
        if(ssny.length()!=6){
            return null;
        }

        String substring1 = ssny.substring(0, 4);
        String substring2 = ssny.substring(4, 6);

        return Integer.parseInt(substring1)-1+substring2;

    }

}
