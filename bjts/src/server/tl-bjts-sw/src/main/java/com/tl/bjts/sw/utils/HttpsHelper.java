package com.tl.bjts.sw.utils;



import com.tl.common.http.HttpsUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.Header;

import java.util.Base64;
import java.util.List;

/*
* 用于对接百旺金赋云票平台API
* */
public class HttpsHelper {
    public static String post(String url,String content) throws Exception{
        return post(url,content,null);
    }

    public static String post(String url, String content, List<Header> headers) throws Exception{
        String msg = Base64.getEncoder().encodeToString(content.getBytes("UTF-8"));
        String ret = HttpsUtils.post(url,msg,headers);
        if(StringUtils.isBlank(ret)){
            return null;
        }
        return new String( Base64.getDecoder().decode(ret.getBytes()),"UTF-8");
    }


    public static String postXml(String url, String content, List<Header> headers) throws Exception{
        String ret = HttpsUtils.post(url,content,headers);
        return ret;
    }
}