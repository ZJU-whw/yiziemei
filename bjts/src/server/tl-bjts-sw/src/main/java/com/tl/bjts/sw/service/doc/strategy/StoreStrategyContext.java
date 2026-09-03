package com.tl.bjts.sw.service.doc.strategy;

import com.tl.bjts.sw.service.doc.ALYunOssHandle;
import com.tl.bjts.sw.service.doc.HuaweiYunObsHandle;
import com.tl.bjts.sw.utils.TlConst;

/**
 * @描述: 存储策略管理类
 * @作者: likun
 * @时间: 2021/11/23 13:45
 */
public class StoreStrategyContext {
    /**
     * 根据存储使用服务商类型初始化策略子类实例对象
     * @param storeType  存储使用服务商类型
     * @return 策略子类实例对象
     */
    public static IStoreStrategy getStrategy(String storeType){
        IStoreStrategy storeStrategy = null;
        // 阿里云oss
        if(TlConst.STORETYPE_ALIYUN_OSS.equals(storeType)){
            storeStrategy =  ALYunOssHandle.instance();
        }else if(TlConst.STORETYPE_HUAWEIYUN_OBS.equals(storeType)){ //华为云obs
            storeStrategy =  HuaweiYunObsHandle.instance();
        }
        storeStrategy.init();
        return storeStrategy;
    }
}
