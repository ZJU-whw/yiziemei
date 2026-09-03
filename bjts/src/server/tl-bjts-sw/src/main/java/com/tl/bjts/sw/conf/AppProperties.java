package com.tl.bjts.sw.conf;

import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2019-05-22
 **/
@Component
@ConfigurationProperties(
        prefix = "app"
)
@RefreshScope
public class AppProperties {

    private Integer refreshPeriod4E01001=-7; //出口退税和外贸出口情况-异步任务存在记录时需要刷新记录的周期（如果在周期内不需要刷新）

    private Integer TjfxExceedTime = -2;//统计分析中：已经存在统计结果，超期时间  天

    private Integer TjfxCurrentTotal = 30;//统计分析中：正在处理的任务总数
    private Integer TjfxCurrentOne = 5;//统计分析中：正在处理的属于某个人的任务总数

    private String dateCrossYearFlag="0";  //1,允许跨年  0 不允许跨年

    private String dataSsnyStart="202101";

    private String dataSsnyEnd="202112";

    private Integer pageSize=6;

    private boolean isNb = false;

    public boolean test=false;

    private String dbUserBjts = "tl_bjts."; // 局端bjts用户名
    /**
     *  云存储类型 oss:阿里云存储 obs:华为云存储
     */
    private String storeType = "oss";

    /**
     *  以下是云存储参数
     */

    // 访问云存储的配置参数
    private  String endpoint = null;
    // 阿里云云oss访问密钥ID
    private  String accessKey = null;
    // 阿里云云oss私有访问密钥
    private  String secretKey = null;
    // 桶
    private  String bucketName = null;

    private  String tjbbDir = "/home/tonlan/static/tjbb/";

    private  String templateDir = "template";

    /**
     * 物流链路二维码基础URL
     */
    private String qrYsyBaseUrl = "http://app.hzztsoft.net/qrYsy/";

    /**
     * 二维码图片尺寸（像素）
     */
    private Integer qrCodeSize = 300;

    public  String getTemplateTjbbDir(){
        String dir = tjbbDir+templateDir;
        if(!StringUtils.endsWith(templateDir,"/")){
            dir = dir +"/";
        }
        return dir;
    }

    public String getTjbbDir() {
        return this.tjbbDir;

    }

    public void setTjbbDir(String tjbbDir) {
        this.tjbbDir = tjbbDir;
    }

    public String getTemplateDir() {
        return this.templateDir;

    }

    public void setTemplateDir(String templateDir) {
        this.templateDir = templateDir;
    }

    public boolean getIsNb() {
        return this.isNb;

    }

    public void setIsNb(boolean nb) {
        this.isNb = nb;
    }

    public Integer getPageSize() {
        return this.pageSize;

    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public boolean isTest() {
        return test;
    }

    public void setTest(boolean test) {
        this.test = test;
    }

    public String getDateCrossYearFlag() {
        return this.dateCrossYearFlag;

    }

    public void setDateCrossYearFlag(String dateCrossYearFlag) {
        this.dateCrossYearFlag = dateCrossYearFlag;
    }

    public String getDataSsnyStart() {
        return this.dataSsnyStart;

    }

    public void setDataSsnyStart(String dataSsnyStart) {
        this.dataSsnyStart = dataSsnyStart;
    }

    public String getDataSsnyEnd() {
        return this.dataSsnyEnd;

    }

    public void setDataSsnyEnd(String dataSsnyEnd) {
        this.dataSsnyEnd = dataSsnyEnd;
    }

    public Integer getRefreshPeriod4E01001() {
        return refreshPeriod4E01001;
    }

    public void setRefreshPeriod4E01001(Integer refreshPeriod4E01001) {
        this.refreshPeriod4E01001 = refreshPeriod4E01001;
    }

    public Integer getTjfxExceedTime() {
        return TjfxExceedTime;
    }

    public void setTjfxExceedTime(Integer tjfxExceedTime) {
        TjfxExceedTime = tjfxExceedTime;
    }

    public Integer getTjfxCurrentTotal() {
        return TjfxCurrentTotal;
    }

    public void setTjfxCurrentTotal(Integer tjfxCurrentTotal) {
        TjfxCurrentTotal = tjfxCurrentTotal;
    }

    public Integer getTjfxCurrentOne() {
        return TjfxCurrentOne;
    }

    public void setTjfxCurrentOne(Integer tjfxCurrentOne) {
        TjfxCurrentOne = tjfxCurrentOne;
    }

    public String getStoreType() {
        return storeType;
    }

    public void setStoreType(String storeType) {
        this.storeType = storeType;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getAccessKey() {
        return accessKey;
    }

    public void setAccessKey(String accessKey) {
        this.accessKey = accessKey;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public void setSecretKey(String secretKey) {
        this.secretKey = secretKey;
    }

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    public String getDbUserBjts() {
        return dbUserBjts;
    }

    public void setDbUserBjts(String dbUserBjts) {
        this.dbUserBjts = dbUserBjts;
    }

    public String getQrYsyBaseUrl() {
        return qrYsyBaseUrl;
    }

    public void setQrYsyBaseUrl(String qrYsyBaseUrl) {
        this.qrYsyBaseUrl = qrYsyBaseUrl;
    }

    public Integer getQrCodeSize() {
        return qrCodeSize;
    }

    public void setQrCodeSize(Integer qrCodeSize) {
        this.qrCodeSize = qrCodeSize;
    }

}
