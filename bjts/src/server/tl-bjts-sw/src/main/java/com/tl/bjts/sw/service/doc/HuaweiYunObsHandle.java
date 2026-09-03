package com.tl.bjts.sw.service.doc;

import com.obs.services.ObsClient;
import com.obs.services.ObsConfiguration;
import com.obs.services.exception.ObsException;
import com.obs.services.model.ObsObject;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.service.SpringContextHolder;
import com.tl.bjts.sw.service.doc.strategy.IStoreStrategy;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.utils.SpringContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * 华为obs处理器
 */
public class HuaweiYunObsHandle implements IStoreStrategy {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private static HuaweiYunObsHandle huaweiYunObsHandle;

    private AppProperties appProperties;

    // 访问obs路径
    private  String endpoint = null;
    // 华为云obs访问密钥ID
    private  String accessKey = null;
    // 华为云obs私有访问密钥
    private  String secretKey = null;
    // 桶
    private  String bucketName = null;

    public static synchronized HuaweiYunObsHandle instance() {
        if (huaweiYunObsHandle == null) {
            huaweiYunObsHandle = new HuaweiYunObsHandle();
        }
        return huaweiYunObsHandle;
    }


    /**
     * 初始化华为云参数。
     * 相关参数存储在系统参数表中。
     */
    @Override
    public  void init() {
        try {
            if (appProperties == null){
                appProperties = SpringContextUtil.getBean(AppProperties.class);
            }
        }catch (Throwable t){
            LOGGER.error("HuaweiYunObsHandle:spring-context is null ,use SpringContextHolder try again!");
            if (appProperties == null){
                appProperties = SpringContextHolder.getBean(AppProperties.class);
            }
        }
        if (appProperties != null){
            LOGGER.info("HuaweiYunObsHandle:apProperties create success");
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
     * 上传文件流到华为云obs
     * @param key 文件Key
     * @param data 需上传的数据
     * @return 当前使用的bucketName
     */
    @Override
    public  String putObject(String key, byte[] data, int offset, int len) {
        ObsClient client = null;
        String rtn = null;
        try {
            ObsConfiguration config = new ObsConfiguration();
            config.setSocketTimeout(90000);
            config.setConnectionTimeout(90000);
            config.setEndPoint(endpoint);

            client = new ObsClient(accessKey, secretKey, config);
            client.putObject(bucketName, key, new ByteArrayInputStream(data, offset, len));
            rtn = bucketName;
        } catch (ObsException oe) {
            LOGGER.error("ObsClient PutObject Response Code:{} " + oe.getResponseCode());
            LOGGER.error("ObsClient PutObject Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("ObsClient PutObject Error Code:{} " + oe.getErrorCode());
            LOGGER.error("ObsClient PutObject Request ID:{} " + oe.getErrorRequestId());
            LOGGER.error("ObsClient PutObject Host ID:{} " + oe.getErrorHostId());
            LOGGER.error("ObsClient PutObject ObsException:{}",oe);
        } catch (Exception e){
            LOGGER.error("ObsClient Put Error:{}",e);
        }finally {
            if(client != null){
                try {
                    client.close();
                } catch (IOException e) {
                    LOGGER.error("ObsClient close Error:{}",e.toString());
                }
            }
        }
        return rtn;
    }
    @Override
    public  void putObject(String key, byte[] data) {
        putObject(key, data, 0, data.length);
    }

    /**
     * 删除文件华为云obs
     * @param bucketName 阿里云的bucketName
     * @param key 文件Key
     */
    @Override
    public  void deleteObject(String bucketName, String key) {
        ObsClient client = null;
        try {
            ObsConfiguration config = new ObsConfiguration();
            config.setSocketTimeout(90000);
            config.setConnectionTimeout(90000);
            config.setEndPoint(endpoint);

            client = new ObsClient(accessKey, secretKey, config);
            client.deleteObject(bucketName, key);
        } catch (ObsException oe) {
            LOGGER.error("ObsClient DeleteObject Response Code:{} " + oe.getResponseCode());
            LOGGER.error("ObsClient DeleteObject Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("ObsClient DeleteObject Error Code:{} " + oe.getErrorCode());
            LOGGER.error("ObsClient DeleteObject Request ID:{} " + oe.getErrorRequestId());
            LOGGER.error("ObsClient DeleteObject Host ID:{} " + oe.getErrorHostId());
            LOGGER.error("ObsClient DeleteObject ObsException:{}",oe.getMessage());
        } catch (Exception e){
            LOGGER.error("ObsClient Delete Error:{}",e.toString());
        }finally {
            if(client != null){
                try {
                    client.close();
                } catch (IOException e) {
                    LOGGER.error("ObsClient close Error:{}",e.toString());
                }
            }
        }
    }


    /**
     * 从华为云oss获取文件字节流
     * @param bucketName  阿里云的bucketName
     * @param key  文件Key
     * @return
     */
    @Override
    public  byte[] getYunData(String bucketName, String key){

        byte[] data = null;
        ObsClient client = null;
        try {
            ObsConfiguration config = new ObsConfiguration();
            config.setSocketTimeout(90000);
            config.setConnectionTimeout(90000);
            config.setEndPoint(endpoint);

            client = new ObsClient(accessKey, secretKey, config);
            boolean found = client.doesObjectExist(bucketName, key);
            if(found){
                ObsObject obsObject = client.getObject(bucketName, key);
                InputStream content = obsObject.getObjectContent();
                data = TlUtils.toByteArray(content);
            }else{
                LOGGER.error("ObsClient Getdata file no exists in obs:{}-{}",bucketName, key);
            }
        }catch (ObsException oe) {
            LOGGER.error("ObsClient Getdata Response Code:{} " + oe.getResponseCode());
            LOGGER.error("ObsClient Getdata Error Message:{} " + oe.getErrorMessage());
            LOGGER.error("ObsClient Getdata Error Code:{} " + oe.getErrorCode());
            LOGGER.error("ObsClient Getdata Request ID:{} " + oe.getErrorRequestId());
            LOGGER.error("ObsClient Getdata Host ID:{} " + oe.getErrorHostId());
            LOGGER.error("ObsClient Getdata ObsException:{}",oe.getMessage());
        }catch (Exception e){
            data = null;
            LOGGER.error("ObsClient Getdata Error:",e);
        }finally {
            if(client != null){
                try {
                    client.close();
                } catch (IOException e) {
                    LOGGER.error("ObsClient close Error:{}",e.toString());
                }
            }
        }
        return data;
    }
}
