package com.tl.bjts.sw.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @Description: 二维码参数字段标记，指定拼接顺序
 * @Author: sxf
 * @Date: 2026-07-22
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface QrField {

    /** 拼接顺序，从1开始，值越小越靠前 */
    int order();
}
