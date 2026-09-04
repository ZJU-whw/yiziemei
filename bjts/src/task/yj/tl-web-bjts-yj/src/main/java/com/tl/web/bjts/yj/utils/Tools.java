package com.tl.web.bjts.yj.utils;

import org.apache.commons.lang3.StringUtils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Tools {

	public static String substringByte(String text, int length)  {
		if (text == null) {
			return null;
		}
		try {
			text = new String(text.getBytes(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		StringBuilder sb = new StringBuilder();
		int currentLength = 0;
		for (char c : text.toCharArray()) {
			currentLength += String.valueOf(c).getBytes().length;
			if (currentLength <= length) {
				sb.append(c);
			} else {
				break;
			}
		}
		return sb.toString();
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


	public static Long parseLong(String v, Long defaultValue){
		if (StringUtils.isNotBlank(v))
			return new Long(v);
		else
			return defaultValue;
	}


	public static Integer parseInt(String v, Integer defaultValue)
	{
		if (StringUtils.isNotBlank(v))
			return new Integer(v);
		else
			return defaultValue;
	}

	public static Integer parseInt(String v)
	{
		return parseInt(v, null);
	}

	public static BigDecimal parseBigDecimal(String v, BigDecimal defaultValue)
	{
		if (StringUtils.isNotBlank(v))
			return new BigDecimal(v);
		else
			return defaultValue;
	}

	public static Short parseShort(String v, Short defaultValue)
	{
		if (StringUtils.isNotBlank(v))
			return new Short(v);
		else
			return defaultValue;
	}

	public static String getZeroString(int length){
		if(length<=0){
			return "";
		}
		StringBuffer sb = new StringBuffer();
		for(int i=0;i<length;i++){
			sb.append(0);
		}
		return sb.toString();

	}

	public static String getPreSwjgdm(String swjgDm){
		while("00".equals(swjgDm.substring(swjgDm.length()-2,swjgDm.length()))){
			swjgDm=swjgDm.substring(0,swjgDm.length()-2);
		}
		return swjgDm;
	}

	/**
	 * 获取错误的堆栈信息
	 * @param throwable
	 * @return
	 */
	public static String getStackTrace(Throwable throwable){
		StringWriter stringWriter=new StringWriter();
		PrintWriter printWriter=new PrintWriter(stringWriter);

		try {
			throwable.printStackTrace(printWriter);
			return stringWriter.toString();
		}finally {
			printWriter.close();
		}

	}

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


}
