package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.model.FjxxVo;
import com.tl.web.bjts.shzs.utils.DataUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.*;

/**
 * 附件文件服务类
 * Created by likun on 2017/6/21.
 */
@Service
public class FjfileService {
    @Autowired
    AppProperties appProperties;

    @Autowired
    ALYunOssHandle aLYunOssHandle;

    /**
     * 声明日志
     */
    public static final Logger logger = LoggerFactory.getLogger(FjfileService.class);

    /**
     * 从云端获取文件数据
     * @param fileJbxxMap 附件基本信息map
     * @param fileKzMap 附件扩展表map
     * @param vo 返回的vo
     * @throws java.io.IOException
     */
    public  void downloadFromYun(Map fileJbxxMap, Map fileKzMap,FjxxVo vo) throws IOException {
        //上传时间设置为当前时间
        Date uptime = new Date();
        StringBuilder key = new StringBuilder(); //key的组成方式：年月/日/uuid
        String rootPath = appProperties.getRootPathDir();

        //从oss（局端）获取文件流（2019-09-04修改）
        String bucketName = (String) fileJbxxMap.get("ROOTPATH");
        String keyMain = (String) fileJbxxMap.get("FILEPATH");
        InputStream in = null;
        File file = null;
        try {
            byte[] fileBytes = aLYunOssHandle.getYunData(bucketName,keyMain);
            in = new ByteArrayInputStream(fileBytes);
            key.append(DateFormatUtils.format(uptime, "yyyyMM/dd/"));
            file = new File(rootPath + key.toString());
            if(!file.exists()){
                file.mkdirs();
            }
            key.append(UUID.randomUUID().toString());
            file = new File(rootPath + key.toString());

            FileOutputStream fout = new FileOutputStream(file);
            int l = -1;
            byte[] data = new byte[1024];
            while ((l = in.read(data)) != -1) {
                fout.write(data, 0, l);
            }
            fout.flush();
            fout.close();
        }catch (Exception e){
            logger.error("从oss获取附件出现错误：" ,e);
        }finally {
            // 关闭低层流。
            if(in != null){
                in.close();
            }
//            httpclient.close();
        }
        //处理fileKzMap
        fileKzMap.put("rootpath", appProperties.getRootName());
        fileKzMap.put("filepath",key.toString());
        fileKzMap.put("clbz", DataUtils.FILE_CLBZ_DOWNLOAD_COMPLETE);
        fileKzMap.put("filehash", getFileMD5(file));
        fileKzMap.put("crtime",new Date());
        fileKzMap.put("uptime",new Date());
        fileKzMap.put("downloadnum",new Integer(1));//初始化下载次数为一次

        //处理vo
        vo.setClbz(DataUtils.FILE_CLBZ_DOWNLOAD_COMPLETE);
        vo.setFileUrl(appProperties.getRootUrlPath() + key.toString());

    }

    // 计算文件的 MD5 值
    public static String getFileMD5(File file) {
        if(file == null){
            return null;
        }
        if (!file.isFile()) {
            return null;
        }
        MessageDigest digest = null;
        FileInputStream in = null;
        byte buffer[] = new byte[8192];
        int len;
        try {
            digest = MessageDigest.getInstance("MD5");
            in = new FileInputStream(file);
            while ((len = in.read(buffer)) != -1) {
                digest.update(buffer, 0, len);
            }
            BigInteger bigInt = new BigInteger(1, digest.digest());
            return bigInt.toString(16);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                in.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
