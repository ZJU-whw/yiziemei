package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.utils.BeanFactory;

import java.util.HashMap;
import java.util.Map;

public class LdlpServiceFactory {

    private static Map<String, String> ywlxMap;

    static {
        ywlxMap = new HashMap<>();
        ywlxMap.put("A0301001", "wmLdlpService");    //外贸
        ywlxMap.put("A0305001", "scLdlpService");   //生产
        ywlxMap.put("A0304001", "zyhwLdlpService");   //购进自用货物
        ywlxMap.put("A0310001", "wzfLdlpService");      //委托代办申报
    }

    public static LdlpService getLcslService(String sbywlx) {

        String serviceName = ywlxMap.get(sbywlx);
        if (serviceName == null) {
//            return null;
//            return (LdlpService) BeanFactory.getApplicationContext().getBean("lcslMdtssbService");
            throw new BusinessException(ResultCode.UNSUPPORT_LDLP_SERVICE);
        }
        return (LdlpService) BeanFactory.getApplicationContext().getBean(serviceName);

    }
}
