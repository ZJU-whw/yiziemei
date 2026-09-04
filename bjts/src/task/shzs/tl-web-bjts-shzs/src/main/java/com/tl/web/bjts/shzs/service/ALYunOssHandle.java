package com.tl.web.bjts.shzs.service;

import com.aliyun.oss.OSSClient;
import com.aliyun.oss.OSSException;
import com.aliyun.oss.model.OSSObject;
import com.tl.web.bjts.shzs.conf.AppProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * 阿里云处理器
 */
@Service
public class ALYunOssHandle {
    public static final Logger logger = LoggerFactory.getLogger(ALYunOssHandle.class);

    private  String endpointInner = null;
    private  String accessKeyId = null;
    private  String accessKeySecret = null;
    private  String bucketName = null;
    private  long signedUrlExp = 3600000; //生成的签名URL过期时间。毫秒数

    @Autowired
    AppProperties appProperties;

    /**
     * 初始化阿里云参数。
     * 相关参数存储在系统参数表中。
     */
    @PostConstruct
    public  void init() {
        endpointInner = appProperties.getEndpoint();
        accessKeyId = appProperties.getAccessKeyId();
        accessKeySecret = appProperties.getAccessKeySecret();
        bucketName = appProperties.getBucketName();
    }

    /**
     * 从阿里云oss获取文件字节流
     * @param bucketName  阿里云的bucketName
     * @param key  文件Key
     * @return
     */
    public  byte[] getYunData(String bucketName, String key){

        byte[] data = null;
        OSSClient client = null;
        OSSObject ossObject =null;
        try {
            client = new OSSClient(endpointInner, accessKeyId, accessKeySecret);
            boolean found = client.doesObjectExist(bucketName, key);
            if(found){
                ossObject = client.getObject(bucketName, key);
                InputStream content = ossObject.getObjectContent();
                data = toByteArray(content);
                ossObject.close();
            }else{
                logger.error("OssClient Getdata file no exists in oss:{}-{}",bucketName, key);
            }
        }catch (OSSException oe) {
            logger.error("OssClient Getdata OSSException:{}",oe.getMessage());
        }catch (Exception e){
            data = null;
            logger.error("OssClient Getdata Error:{}",e.toString());
        }finally {
            if(client != null){
                client.shutdown();
            }
        }
        return data;
    }

    /**
     * InputStream 转 byte数组
     * @param input
     * @return
     * @throws IOException
     */
    public static  byte[] toByteArray(InputStream input) throws IOException {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int n = 0;
        while (-1 != (n = input.read(buffer))) {
            output.write(buffer, 0, n);
        }
        return output.toByteArray();
    }

}
