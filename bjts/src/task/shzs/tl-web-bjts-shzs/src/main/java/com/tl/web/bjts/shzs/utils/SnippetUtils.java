package com.tl.web.bjts.shzs.utils;

import com.tl.web.bjts.shzs.exception.BusinessException;
import javautil.NumberUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * map中key大写转小写
 */
public class SnippetUtils {
	/**
	 * Map中key值大写转小写
	 * @param orgMap
	 * @return
	 */
    public static Map<String, Object> transformUpperCase(Map<String, Object> orgMap) {
		Map<String, Object> resultMap = new HashMap<>();
		if (orgMap == null || orgMap.isEmpty()) {
			return null;
		}
		Set<String> keySet = orgMap.keySet();
		for (String key : keySet) {
			String newKey = key.toLowerCase();
			resultMap.put(newKey, orgMap.get(key));
		}

		return resultMap;
	}

	/**
	 * List<Map> 元素map中key值大写转小写
	 * @param list
	 * @return
	 */
	public static  List<Map<String, Object>>  transformUpperCase4List(List<Map<String, Object>> list) {
		List<Map<String, Object>> resultList = new ArrayList<>();
		if (CollectionUtils.isEmpty(list)) {
			return null;
		}
		for(Map map : list){
			resultList.add(transformUpperCase(map));
		}

		return  resultList;
	}

	/**
	 * 转换中文状态下的标点字符到英文状态
	 * @param reqStr
	 * @return
	 */
	public static String transferChinese2English(String reqStr){
		String[] regs = { "！", "，", "。", "；", "!", ",", ".", ";" };
		for ( int i = 0; i < regs.length / 2; i++ )
		{
			reqStr = reqStr.replaceAll (regs[i], regs[i + regs.length / 2]);
		}
		return reqStr;
	}

	/**
	 * 获取中文或英文字节长度
	 * @param text
	 * @return
	 */
	public static int getLength(String text)  {
		if (StringUtils.isBlank(text)) {
			return 0;
		}
		try {
			text = new String(text.getBytes(), "GBK");
		} catch (UnsupportedEncodingException e) {
			throw new BusinessException("获取长度出错");
		}
		int currentLength = 0;
		for (char c : text.toCharArray()) {
			currentLength += String.valueOf(c).getBytes().length;
		}
		return currentLength;
	}


	/**
	 * 判断数组中是包含某个元素
	 * @param arr 数组
	 * @param targetValue  元素
	 * @return
	 */
	public static boolean judgeArrContainElement(String[] arr,String targetValue){
		for(String s:arr){
			if(s.equalsIgnoreCase(targetValue))
				return true;
		}
		return false;
	}

	/**
	 * 将毫秒转为分和秒
	 * @param time
	 * @return
	 */
	public static String formattime(long time){
		String min= (time/(1000*60))+"";
		String second= (time%(1000*60)/1000)+"";
		if(min.length()<2){
			min=0+min;
		}
		if(second.length()<2){
			second=0+second;
		}
		return min+"分"+second + "秒";
	}

	/**
	 * 提取中文
	 * @param str 要处理的带中文的字符串
	 * @return 中文
	 */
	public static String pickupChineseChar(String str){
		if(StringUtils.isBlank(str)){
			return "";
		}
		String regex = "[^\u4e00-\u9fa5]";
		return str.replaceAll(regex, "");
	}

	/**
	 * 使用正则表达式提取中括号中的内容
	 * @param msg
	 * @return
	 */
	public static String extractMessageByRegular(String msg){
		if(StringUtils.isBlank(msg)){
			return "";
		}

		List<String> list=new ArrayList<String>();
		Pattern p = Pattern.compile("(\\[[^\\]]*\\])");
		Matcher m = p.matcher(msg);
		while(m.find()){
			list.add(m.group().substring(1, m.group().length()-1));
		}
		if(CollectionUtils.isEmpty(list)){
			return "";
		}
		return list.get(0);
	}

	/**元转万元且四舍五入取整*/
	public static String getNumberWan(BigDecimal value) {
		// 转换为万元（除以10000）
		BigDecimal decimal = value.divide(new BigDecimal("10000"));
		// 保留两位小数
		DecimalFormat formater = new DecimalFormat("0");
		// 四舍五入
		formater.setRoundingMode(RoundingMode.HALF_UP);

		// 格式化完成之后得出结果
		String rs = formater.format(decimal);
		return rs;
	}

	/**
	 * 使用UTF-8编码表进行截取字符串，一个汉字对应三个负数，一个英文字符对应一个正数
	 * 截取字符串长度
	 * @param str
	 * @param subLen
	 * @return
	 */
	public static String cutStringByU8(String str, int subLen) {
		if(StringUtils.isBlank(str)){
			return null;
		}
		String subStr = "";
		try {
			int byteEndIndex = Math.min(str.length(), subLen);
			int byteLen = 0;
			do {
				// 将要截取的子串长度减1，此处切记用 byteEndIndex--，而不是 --byteEndIndex
				subStr = str.substring(0, byteEndIndex--);
				// 更新subStr转为UTF-8的byte[]的长度
				byteLen = subStr.getBytes("UTF-8").length;
				// 只要byteLen大于最初想要截取的子串的值，则继续循环
			} while (byteLen > subLen);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return subStr;
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
	 * 如果参数为null，返回0。否则返回Integer值。
	 * @param n 必须是Number值
	 * @return 转换后的数值
	 */
	public static Integer nullToZero4Integer(Object n) {
		if(n == null) {
			return new Integer(0);
		}
		return new Integer(((Number)n).intValue());
	}

	/**
	 * 元转换为万元
	 * @param yuan
	 * @return
	 */
	public static BigDecimal transfer2WanYuan(BigDecimal yuan){
		if(yuan == null){
			return BigDecimal.ZERO;
		}

		BigDecimal decimal = yuan.divide(new BigDecimal("10000")).setScale(2, RoundingMode.HALF_UP);

		return decimal;
	}

	/**
	 *  对字节流进行base64编码
	 * @param data 待base64编码的字节流
	 * @return 已经进行base64编码的字节流
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

	/**
	 *  整型除以bigdecimal
	 * @param itemQuantity 整数
	 * @param itemPrice
	 * @return 整型
	 */
	public static int calculateCost(int itemQuantity, BigDecimal itemPrice) {
		BigDecimal totalCost = BigDecimal.ZERO;
		BigDecimal itemCost = itemPrice.multiply(new BigDecimal(itemQuantity)).divide(new BigDecimal(100));
		totalCost = totalCost.add(itemCost);
		if (totalCost.compareTo(BigDecimal.ONE) < 0) {
			return 1;
		}
		return totalCost.intValue();
	}

	public static List createRandomList(List list, int n)
	{
		if (CollectionUtils.isEmpty(list)){
			return null;
		}
		Map map = new HashMap();
		List listNew = new ArrayList();
		if (list.size() <= n)
		{
			return list;
		}
		else
		{
			while (map.size() < n)
			{
				int random = (int) (Math.random() * list.size());
				if (!map.containsKey(random))
				{
					map.put(random, "");
					listNew.add(list.get(random));
				}
			}
			return listNew;
		}
	}

	/**
	 * 全角转半角，去掉空白字符
	 * @param input String.
	 * @return 半角字符串
	 */
	public static String transferFullPart(String input) {
		if(StringUtils.isBlank(input)){
			return null;
		}
		char c[] = input.toCharArray();
		for (int i = 0; i < c.length; i++) {
			if (c[i] == '\u3000') {
				c[i] = ' ';
			} else if (c[i] > '\uFF00' && c[i] < '\uFF5F') {
				c[i] = (char) (c[i] - 65248);
			}
		}
		String returnString = new String(c).replaceAll("\\s*", "");
		return returnString;
	}

	/**
	 *  判断List中是否存在某个元素
	 * @param targetItem 目标元素
	 * @param list 集合
	 * @return 返回-1 表示不存在，否则存在
	 */
	public static int listContains(String targetItem, List<String> list ) {
		int res = -1;
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).equals(targetItem) ) {
				res = i;
				break;
			}
		}
		return res;
	}

}