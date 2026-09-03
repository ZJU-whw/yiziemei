package com.tl.bjts.sw.service.doc;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.OSSException;
import com.aliyun.oss.model.OSSObject;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.service.SpringContextHolder;
import com.tl.bjts.sw.service.doc.strategy.IStoreStrategy;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.utils.SpringContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

/**
 * 阿里云处理器
 */
public class ALYunOssHandle implements IStoreStrategy {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private static ALYunOssHandle alYunOssHandle;

    private AppProperties appProperties;

    // 访问oss路径
    private  String endpoint = null;
    // 阿里云云oss访问密钥ID
    private  String accessKey = null;
    // 阿里云云oss私有访问密钥
    private  String secretKey = null;
    // 桶
    private  String bucketName = null;

    public static synchronized ALYunOssHandle instance() {
        if (alYunOssHandle == null) {
            alYunOssHandle = new ALYunOssHandle();
        }
        return alYunOssHandle;
    }

    /**
     * 初始化阿里云参数。
     * 相关参数存储在系统参数表中。
     */
    @Override
    public  void init() {
        try {
            if (appProperties == null){
                appProperties = SpringContextUtil.getBean(AppProperties.class);
            }
        }catch (Throwable t){
            LOGGER.error("ALYunOssHandle:spring-context is null ,use SpringContextHolder try again!");
            if (appProperties == null){
                appProperties = SpringContextHolder.getBean(AppProperties.class);
            }
        }
        if (appProperties != null){
            LOGGER.info("ALYunOssHandle:apProperties create success");
        }
        endpoint = appProperties.getEndpoint();
        accessKey = appProperties.getAccessKey();
        secretKey = appProperties.getSecretKey();
        bucketName = appProperties.getBucketName();
//        LOGGER.info("endpoint：{}", endpoint);
//        LOGGER.info("accessKey：{}", accessKey);
//        LOGGER.info("secretKey：{}", secretKey);
//        LOGGER.info("bucketName：{}", bucketName);
    }

    /**
     * 上传文件流到阿里云
     * @param key 文件Key
     * @param data 需上传的数据
     * @return 当前使用的bucketName
     */
    @Override
    public  String putObject(String key, byte[] data, int offset, int len) {
        OSSClient client = null;
        String rtn = null;
        try {
            client = new OSSClient(endpoint, accessKey, secretKey);
            client.putObject(bucketName, key, new ByteArrayInputStream(data, offset, len));
            rtn = bucketName;
        } catch (OSSException oe) {
            LOGGER.error("OssClient PutObject ResponseError:{} " + oe.getRawResponseError());
            LOGGER.error("OssClient PutObject Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("OssClient PutObject Error Code:{} " + oe.getErrorCode());
            LOGGER.error("OssClient PutObject Request ID:{} " + oe.getRequestId());
            LOGGER.error("OssClient PutObject Host ID:{} " + oe.getHostId());
            LOGGER.error("OssClient PutObject OSSException:{}",oe);
        } catch (Exception e){
            LOGGER.error("OssClient Put Error:{}",e);
        }finally {
            if(client != null){
                client.shutdown();
            }
        }

        return rtn;
    }
    @Override
    public  void putObject(String key, byte[] data) {
        putObject(key, data, 0, data.length);
    }

    /**
     * 删除文件
     * @param bucketName 阿里云的bucketName
     * @param key 文件Key
     */
    @Override
    public  void deleteObject(String bucketName, String key) {
        OSSClient client = null;
        try {
            client = new OSSClient(endpoint, accessKey, secretKey);
            client.deleteObject(bucketName, key);
        } catch (OSSException oe) {
            LOGGER.error("OssClient DeleteObject ResponseError:{} " + oe.getRawResponseError());
            LOGGER.error("OssClient DeleteObject Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("OssClient DeleteObject Error Code:{} " + oe.getErrorCode());
            LOGGER.error("OssClient DeleteObject Request ID:{} " + oe.getRequestId());
            LOGGER.error("OssClient DeleteObject Host ID:{} " + oe.getHostId());
            LOGGER.error("OssClient DeleteObject OSSException:{}",oe.getMessage());
        } catch (Exception e){
            LOGGER.error("OssClient Delete Error:{}",e.toString());
        }finally {
            if(client != null){
                client.shutdown();
            }
        }
    }


    /**
     * 从阿里云oss获取文件字节流
     * @param bucketName  阿里云的bucketName
     * @param key  文件Key
     * @return
     */
    @Override
    public  byte[] getYunData(String bucketName, String key){

        byte[] data = null;
        OSSClient client = null;
        OSSObject ossObject =null;
        try {
            client = new OSSClient(endpoint, accessKey, secretKey);
            boolean found = client.doesObjectExist(bucketName, key);
            if(found){
                ossObject = client.getObject(bucketName, key);
                InputStream content = ossObject.getObjectContent();
                data = TlUtils.toByteArray(content);
                ossObject.close();
            }else{
                LOGGER.error("OssClient Getdata file no exists in oss:{}-{}",bucketName, key);
            }
        }catch (OSSException oe) {
            LOGGER.error("OssClient Getdata ResponseError:{} " + oe.getRawResponseError());
            LOGGER.error("OssClient Getdata Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("OssClient Getdata Error Code:{} " + oe.getErrorCode());
            LOGGER.error("OssClient Getdata Request ID:{} " + oe.getRequestId());
            LOGGER.error("OssClient Getdata Host ID:{} " + oe.getHostId());
            LOGGER.error("OssClient Getdata OSSException:{}",oe.getMessage());
        }catch (Exception e){
            data = null;
            LOGGER.error("OssClient Getdata Error:",e);
        }finally {
            if(client != null){
                client.shutdown();
            }
        }
        return data;
    }

}
