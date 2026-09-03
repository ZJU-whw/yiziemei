package com.tl.bjts.sw.service.doc.strategy;

/**
 * @描述: 存储策略接口
 * @作者: likun
 * @时间: 2021/11/23 13:44
 */
public interface IStoreStrategy {
    /**
     * 初始化相关参数
     */
    void init();

    /**
     * 上传对象
     * @param key  文件Key
     * @param data 需上传的数据
     * @param offset 偏移
     * @param len 文件长度
     * @return bucketName
     */
    String putObject(String key, byte[] data, int offset, int len);

    /**
     * 上传对象
     * @param key 文件Key
     * @param data 需上传的数据
     */
    void putObject(String key, byte[] data);

    /**
     * 删除对象
     * @param bucketName  桶
     * @param key 文件Key
     */
    void deleteObject(String bucketName, String key);

    /**
     * 下载对象
     * @param bucketName 桶
     * @param key 文件Key
     * @return 文件流
     */
    byte[] getYunData(String bucketName, String key);

}
