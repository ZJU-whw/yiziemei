package com.tl.web.bjts.shzs.conf;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * 说明：nacos配置中心获取参数
 * 如果nacos的配置中有下述参数，以nacos为准，否则使用下述参数值
 * 作者：王兆阳
 * 日期：2019-05-22
 **/
@Component
@ConfigurationProperties(
        prefix = "app"
)
@RefreshScope
public class AppProperties {

    /**
     * 是否测试环境
     */
    private boolean test = false;

    /**
     * 以下为文件相关的配置
     */
    private String dir = "D:/static/";
    private String urlBase = "/shzs/static/";

    /**
     * 服务器地址
     */
    private  String serverHost = "http://80.64.64.9:8081";//服务器相对路径
    private  long mybatisCacheTimeout = 5;   //mybatis二级缓存过期时间 分钟

    /**
     * 以下是附件配置
     */
    private  String rootName = "root1";//附件逻辑根目录
    private  String rootPath = "fjfile";//rootName 对应的根路径

    /**
     * 以下为申报文件配置
     */
    private  String sbServiceUrl ="http://80.12.137.23:9800/sb_service/"; //申报服务的路径信息
    private  String xmlPath = "sbfile/xml";//申报文件生成目录

    /**
     * 以下是升级相关的配置
     */
    public static String updatepath ="update";
    public static String updatefile = "update.json";

    /**
     * 以下是oss配置
     */
    private  String endpoint = "http://aaa.com";
    private  String accessKeyId = "1111111111";
    private  String accessKeySecret = "22222222222222";
    private  String bucketName = "zjsw-bjts";

    /**
     * 审核助手基准版本
     */
    private String benchmarkVer = "1.0.0";

    /**
     * 管理系统单证备案服务路径
     */
    private String glxtDzbaUrl = "http://80.64.64.9/dzba";

    /**
     * 管理系统用户服务路径
     */
    private String glxtAuthUrl =  "http://80.64.64.9/auth";

    /**
     * 误差额上限
     */
    private BigDecimal wceUp = new BigDecimal("1000000");

    /**
     * 误差额下限
     */
    private BigDecimal wceDown = new BigDecimal("-1000000");

    private String lcswsxParam = "lcswsxDm";  //税务事项代码参数名

    private String lcslidParam = "lcslid";    //流程实例ID参数名

    private String zjgwdm="000000020941"; //岗位代码是全省统一  000000020941	出口退税_申报受理岗

    public String getZjgwdm() {
        return this.zjgwdm;

    }

    public void setZjgwdm(String zjgwdm) {
        this.zjgwdm = zjgwdm;
    }

    public String getLcswsxParam() {
        return this.lcswsxParam;

    }

    public void setLcswsxParam(String lcswsxParam) {
        this.lcswsxParam = lcswsxParam;
    }

    public String getLcslidParam() {
        return this.lcslidParam;

    }

    public void setLcslidParam(String lcslidParam) {
        this.lcslidParam = lcslidParam;
    }

    public String getServerHost() {
        return serverHost;
    }

    public void setServerHost(String serverHost) {
        this.serverHost = serverHost;
    }

    public String getRootName() {
        return rootName;
    }

    public void setRootName(String rootName) {
        this.rootName = rootName;
    }

    public String getSbServiceUrl() {
        return sbServiceUrl;
    }

    public void setSbServiceUrl(String sbServiceUrl) {
        this.sbServiceUrl = sbServiceUrl;
    }

    public String getXmlPath() {
        return xmlPath;
    }

    public void setXmlPath(String xmlPath) {
        this.xmlPath = xmlPath;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getAccessKeyId() {
        return accessKeyId;
    }

    public void setAccessKeyId(String accessKeyId) {
        this.accessKeyId = accessKeyId;
    }

    public String getAccessKeySecret() {
        return accessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret) {
        this.accessKeySecret = accessKeySecret;
    }

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }


    public String getDir() {
        if(!StringUtils.endsWith(dir,"/")){
            return dir+"/";
        }
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public String getUrlBase() {
        return urlBase;
    }

    public void setUrlBase(String urlBase) {
        this.urlBase = urlBase;
    }

    public  String getRootPathDir(){
        if(!StringUtils.endsWith(rootPath,"/")){
            return getDir()+rootPath+"/";
        }
        return getDir()+rootPath;
    }

    public  String getRootUrlPath(){
        if(!StringUtils.endsWith(rootPath,"/")){
            return getServerHost() + getUrlBase() + rootPath+"/";
        }
        return getServerHost() + getUrlBase() + rootPath;
    }

    public  String getXmlPathDir(){
        if(!StringUtils.endsWith(xmlPath,"/")){
            return getDir()+xmlPath+"/";
        }
        return getDir()+xmlPath;
    }

    public  String getXmlUrlPath(){
        if(!StringUtils.endsWith(xmlPath,"/")){
            return getServerHost() + getUrlBase() + xmlPath+"/";
        }
        return getServerHost() + getUrlBase() + xmlPath;
    }

    public  String getUpdatefilePath(){
        String dir = getDir() + updatepath;
        if(!StringUtils.endsWith(updatepath,"/")){
            dir = dir +"/";
        }
        return dir+updatefile;
    }

    public  String readUpdateIni() throws IOException {
        return FileUtils.readFileToString(new File(getUpdatefilePath()));
    }

    public String getBenchmarkVer() {
        return benchmarkVer;
    }

    public void setBenchmarkVer(String benchmarkVer) {
        this.benchmarkVer = benchmarkVer;
    }

    public boolean isTest() {
        return test;
    }

    public void setTest(boolean test) {
        this.test = test;
    }

    public long getMybatisCacheTimeout() {
        return mybatisCacheTimeout;
    }

    public void setMybatisCacheTimeout(long mybatisCacheTimeout) {
        this.mybatisCacheTimeout = mybatisCacheTimeout;
    }

    public String getGlxtDzbaUrl() {
        return glxtDzbaUrl;
    }

    public void setGlxtDzbaUrl(String glxtDzbaUrl) {
        this.glxtDzbaUrl = glxtDzbaUrl;
    }

    public String getGlxtAuthUrl() {
        return glxtAuthUrl;
    }

    public void setGlxtAuthUrl(String glxtAuthUrl) {
        this.glxtAuthUrl = glxtAuthUrl;
    }

    public BigDecimal getWceUp() {
        return wceUp;
    }

    public void setWceUp(BigDecimal wceUp) {
        this.wceUp = wceUp;
    }

    public BigDecimal getWceDown() {
        return wceDown;
    }

    public void setWceDown(BigDecimal wceDown) {
        this.wceDown = wceDown;
    }
}
