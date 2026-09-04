package com.tl.web.bjts.shzs.utils;

import org.apache.commons.lang3.StringUtils;

/**
 * @描述: 比较版本通用方法
 * @作者: likun
 * @时间: 2021/6/18 14:36
 */
public class CompareVersion {
    /**
     * 比较版本（版本格式为1.0.1）
     *  @param benchmarkVer  基准版本
     * @param comparedVer  待比较版本

     * @return  0:版本一致  大于0：待比较版本小于基准版本  小于0：待比较版本大于基准版本
     */
    public static int compare(String benchmarkVer, String comparedVer) {
        if(StringUtils.isBlank(comparedVer)){
            return 1;
        }
        if (benchmarkVer.equals(comparedVer)) {
            return 0;
        }
        String[] version1Array = benchmarkVer.split("\\.");
        String[] version2Array = comparedVer.split("\\.");
        int index = 0;
        //获取最小长度值
        int minLen = Math.min(version1Array.length, version2Array.length);
        int diff = 0;
        //循环判断每位的大小
        while (index < minLen && (diff = Integer.parseInt(version1Array[index]) - Integer.parseInt(version2Array[index])) == 0) {
            index++;
        }
        if (diff == 0) {
            //如果位数不一致，比较多余位数
            for (int i = index; i < version1Array.length; i++) {
                if (Integer.parseInt(version1Array[i]) > 0) {
                    return 1;
                }
            }

            for (int i = index; i < version2Array.length; i++) {
                if (Integer.parseInt(version2Array[i]) > 0) {
                    return -1;
                }
            }
            return 0;
        } else {
            return diff > 0 ? 1 : -1;
        }
    }

}
