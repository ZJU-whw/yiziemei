package com.tl.web.bjts.shzs.utils;

import java.io.IOException;
import java.util.Properties;

public class VersionUtil {
    private static String version;
    /**
     * 获取版本信息
     * @return
     */
    public static String getHSCVersion() {
        if (null == version) {
            Properties properties = new Properties();
            try {
                properties.load(VersionUtil.class.getClassLoader().getResourceAsStream("application.properties"));
                if (!properties.isEmpty()) {
                    version = properties.getProperty("shzs.version");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return version;
    }
}
