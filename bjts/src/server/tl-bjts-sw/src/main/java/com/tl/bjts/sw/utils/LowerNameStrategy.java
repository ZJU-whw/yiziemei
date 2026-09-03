package com.tl.bjts.sw.utils;

import com.google.gson.FieldNamingStrategy;

import java.lang.reflect.Field;

/**
 * @Author：Mamf
 * @Date: 2018/7/10.
 * @Description:
 */
public class LowerNameStrategy implements FieldNamingStrategy {

    @Override
    public String translateName(Field field) {
        return field.getName().toLowerCase();
    }
}
