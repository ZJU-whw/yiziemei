package com.tl.bjts.sw.utils;

import com.tl.bjts.sw.exception.BusinessException;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.UnsupportedEncodingException;
import java.util.*;

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
	 * 校验长度
	 * @param checkStr 校验的字符串
	 * @param showName 显示的提示信息
	 * @param maxLength 最大的长度
	 */
	public static void checkLength(String checkStr,String showName,int maxLength){
		if(StringUtils.isBlank(checkStr)){
			return ;
		}
		if(getLength(checkStr) > maxLength){
			throw new BusinessException( showName + "长度不能超过" + maxLength + "位。");
		}
	}

	/**
	 * 判断数组中是包含某个元素
	 * @param arr 数组
	 * @param targetValue  元素
	 * @return
	 */
	public static boolean judgeArrContainElement(String[] arr,String targetValue){
		for(String s:arr){
			if(s.equals(targetValue))
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

}