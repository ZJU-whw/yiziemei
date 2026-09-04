package com.tl.web.bjts.yj.service;


import com.tl.web.bjts.yj.exception.BusinessException;
import com.tl.web.bjts.yj.utils.ConstUtil;

import java.util.HashMap;
import java.util.Map;

public class YjServiceFactory {

    public static final Map<String,String> yjTypeMap = new HashMap<>();

    static{
        yjTypeMap.put(ConstUtil.SC_SBYW,"yj4ScService");//生产
        yjTypeMap.put(ConstUtil.WM_SBYW,"yj4WmService");//外贸
        //ysTypeMap.put("A0310001","");//外综服
        yjTypeMap.put(ConstUtil.WZF_SBYW,"yj4WzfService");//外综服
        yjTypeMap.put(ConstUtil.YGSB_SBYW,"yj4TyzYgsbService");//特殊业务政策 A0303001 出口已使用过的设备
        yjTypeMap.put(ConstUtil.TXFS_SBYW,"yj4TyzTxfsService");//特殊业务政策 A0302001 出口非自产货物消费税
    }

    public static IYjService getService(String sbywbDm){
        String serviceName = yjTypeMap.get(sbywbDm);
        if (serviceName == null) {
            throw new BusinessException("暂不支持的预警服务");
        }
        return (IYjService) BeanFactory.getApplicationContext().getBean(serviceName);


    }

}
