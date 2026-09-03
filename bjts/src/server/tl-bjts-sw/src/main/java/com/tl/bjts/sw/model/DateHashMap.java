package com.tl.bjts.sw.model;

import com.tl.bjts.sw.utils.DateUtils;

import java.util.Date;
import java.util.HashMap;

/**
 * @Author：Mamf
 * @Date: 2019/12/9.
 * @Description:
 */
public class DateHashMap extends HashMap{

    @Override
    public Object put(Object key, Object value) {
        if(value instanceof java.util.Date){
            Date dObjt=(Date)value;
            value=DateUtils.format(dObjt,"yyyy-MM-dd");
        }
        return super.put(key, value);
    }
}
