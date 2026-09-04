package com.tl.web.bjts.yj.biz;

import com.tl.common.conf.TLConfigManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * 说明：初始化配置,配置文件内容修改后最大10秒后更新
 * 作者：王兆阳
 * 日期：2017-05-23
 **/

@Component
public class InitApp {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    Environment evn;

    @PostConstruct
    public void init() {
        try {

            String confPath = evn.getProperty("conf.path");
            if (confPath == null || confPath.startsWith("${")){
                confPath = "/home/dev/tlweb/web_bjts.yj/etc";
            }

            TLConfigManager.initializeConfig(confPath, "com.tl.web.bjts.yj.conf");
            LOGGER.info("init conf path:{}", confPath);

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("init conf failed.", e);
        }
        try {

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.error("init service failed.", e);
        }
        LOGGER.info("init app success.");
    }


}
