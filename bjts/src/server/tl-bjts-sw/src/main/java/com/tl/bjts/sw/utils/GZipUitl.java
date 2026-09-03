package com.tl.bjts.sw.utils;

import org.apache.commons.codec.binary.Base64InputStream;
import org.apache.commons.codec.binary.Base64OutputStream;
import org.apache.commons.io.IOUtils;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

/**
 * @Author：Mamf
 * @Date: 2018/7/5.
 * @Description:
 */
public class GZipUitl {

    public static byte[] genZip(String content) throws Exception{

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        Base64OutputStream b64os = new Base64OutputStream(bos);
        GZIPOutputStream gout = new GZIPOutputStream(b64os);
        gout.write(content.getBytes("UTF-8"));
        gout.close();
        b64os.close();

        byte ret[] = bos.toByteArray();

        return ret;
    }

    public static String genUnzip(byte[] conteng) throws  Exception{

        InputStream bais = new ByteArrayInputStream(conteng);
        Base64InputStream b64io = new Base64InputStream(bais);
        GZIPInputStream gin = new GZIPInputStream(b64io);

        String ret = IOUtils.toString(gin, "UTF-8");

        return ret;
    }

}
