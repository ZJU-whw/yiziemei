package com.tl.bjts.sw.utils;

import com.github.pagehelper.Page;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.utils.MD5;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author：Mamf
 * @Date: 2017/7/18.
 * @Description:
 */
public class TlUtils {

    public static final ThreadLocal<String[]> dynnamicColumn = new ThreadLocal<String[]>();

    private static final char[] HEX_DIGITS = {'0', '1', '2', '3', '4', '5',
            '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

    public static String readNullToEmpty(Object o){
        if(o==null){
            return "";
        }else{
            return (String)o;
        }
    }

    /**
     * 加密文件
     */
    public static String getMd5ByFile(File file) {
        String value = null;
        FileInputStream fin = null;
        try {
            fin = new FileInputStream(file);
            byte[] bytes = new byte[1024];
            int nums = 0;
            MessageDigest messageDigest = MessageDigest.getInstance("SHA1");

            while ((nums = fin.read(bytes)) > 0 ){
                messageDigest.update(bytes,0,nums);
            }
            value = getFormattedText(messageDigest.digest());
            value = value.toUpperCase();
            return value;
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }catch (IOException e){

        }catch (NoSuchAlgorithmException e){

        }finally {
            if (fin != null){

                try {
                    fin.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    /**
     * Takes the raw bytes from the digest and formats them correct.
     *
     * @param bytes the raw bytes from the digest.
     * @return the formatted bytes.
     */
    private static String getFormattedText(byte[] bytes) {
        int len = bytes.length;
        StringBuilder buf = new StringBuilder(len * 2);
        // 把密文转换成十六进制的字符串形式
        for (int j = 0; j < len; j++) {
            buf.append(HEX_DIGITS[(bytes[j] >> 4) & 0x0f]);
            buf.append(HEX_DIGITS[bytes[j] & 0x0f]);
        }
        return buf.toString();
    }




    // 保存文件
    public static File saveFile(String newsRootPath, String filename,

                                InputStream fis) {
         File file = null;
        try {
            File newsFileRoot  = new File(newsRootPath);
            if (!newsFileRoot.exists()) {
                newsFileRoot.mkdirs();
            }
            file = new File(newsRootPath + filename);
            FileOutputStream fos = new FileOutputStream(file);
            byte[] buf = new byte[1024];
            int len = 0;
            while ((len = fis.read(buf)) > 0) {
                fos.write(buf, 0, len);
            }
            if (fis != null)
                fis.close();
            if (fos != null)
                fos.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return file;
    }


    public static TlUserProfile parseJson2User(Object jsonUser){
        if(jsonUser==null){
            return null;
        }
        return new Gson().fromJson(String.valueOf(jsonUser),TlUserProfile.class);
    }


    public static String getPreSwjgdm(String swjgDm){
        if (swjgDm==null||swjgDm.equals("")){
            return "";
        }
        while("00".equals(swjgDm.substring(swjgDm.length()-2,swjgDm.length()))){
            swjgDm=swjgDm.substring(0,swjgDm.length()-2);
        }
        return swjgDm;
    }

    public static Date parseString2Date(String dateStr,String pattern) throws ParseException {
        if(StringUtils.isBlank(dateStr)){
            return null;
        }
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.parse(dateStr);
    }

    public static String formatDate2String(Date date, String pattern){
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        return format.format(date);
    }

    /*
  批次格式：xx
   */
    public static String dealSbpc(String sbpc) {
        sbpc = getSbpc(Integer.parseInt(sbpc));
        return sbpc;
    }

    /** 生成2位sbpc
     * 1.序号小于100，转换为"01"、"02"之类的格式
     * 2.超过100时，转换为"A1"，"A2"之类的格式。数据的前两位从10到35分别转换为A到Z。
     * @param xh 序号
     * @return  2位sbpc
     */
    public static String getSbpc(int xh) {
        DecimalFormat sbpcDecimalFormat = new DecimalFormat("00"); // 申报表序号数值格式化。
        String sbpc;
        if (xh < 100) { // 小于100时，转换为"01"、"02"之类的格式
            sbpc = sbpcDecimalFormat.format(xh);
        } else { // 超过100时，转换为"A1"，"A2"之类的格式。数据的前两位从10到35分别转换为A到Z。
            int pre2 = xh / 10 - 10;
            char c = (char) ('A' + pre2);
            DecimalFormat df = new DecimalFormat("0");
            sbpc = c + df.format(xh % 10);
        }
        return sbpc;
    }

    public static Object getter(Object obj, String att) {
        try {
            Method met = obj.getClass().getMethod("get" + initStr(att)); // 得到setter方法
            return met.invoke(obj);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void setter(Object obj, String att, Object value, Class<?> type) {
        try {
            Method met = obj.getClass().getMethod("set" + initStr(att), type);    // 得到setter方法
            met.invoke(obj, value); // 设置setter的内容
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //获取一个类及其父类的所有字段
    public static Field[] getAllFields(Object object){
        Class clazz = object.getClass();
        List<Field> fieldList = new ArrayList<>();
        while (clazz != null){
            fieldList.addAll(new ArrayList<>(Arrays.asList(clazz.getDeclaredFields())));
            clazz = clazz.getSuperclass();
        }
        Field[] fields = new Field[fieldList.size()];
        fieldList.toArray(fields);
        return fields;
    }

    public static String initStr(String attr) {
        return Character.toUpperCase(attr.charAt(0)) + attr.substring(1);
    }

    // 对指定字段的集合进行排序
    public static <T>void getSortList(List<T> list, String orderSql){
        String var1[]=orderSql.split(",");
        int order=var1[1].equals("asc")?1:-1;
        Collections.sort(list, new Comparator<T>() {
            @Override
            public int compare(T o1, T o2) {
                Object obj1;
                Object obj2;
                Field[] fields = getAllFields(o1);
                for (Field field : fields) {
                    if (field.getName().equals(var1[0])){
                        obj1=getter(o1,field.getName());
                        obj2=getter(o2,field.getName());
                        if (obj1==null&&obj2==null){
                            return 0;
                        }
                        if (obj1==null){
                            return -order;
                        }
                        if (obj2==null){
                            return order;
                        }
                        if (obj1 instanceof Long){
                            if ((long)obj1>(long)obj2){
                                return order;
                            }
                            if ((long)obj1==(long)obj2){
                                return 0;
                            }
                        }else if(obj1 instanceof  Date){
                            if (((Date) obj1).getTime()>((Date) obj2).getTime()){
                                return order;
                            }
                            if (((Date) obj1).getTime()==((Date) obj2).getTime()){
                                return 0;
                            }
                        }
                        return -order;
                    }
                }
                return -order;
            }
        });
    }


    public static String base64Encode(byte[] data){
        Base64.Encoder encoder = Base64.getEncoder();
        //编码
        return encoder.encodeToString(data);

    }

    /**
     * base64Url编码,用于请求地址参数
     * @param data
     * @return
     */
    public static String base64UrlEncode(byte[] data) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(data);
    }

    /**
     * base64Url解码
     * @param encodedData
     * @return
     */
    public static byte[] base64UrlDecode(String encodedData) {
        return Base64.getUrlDecoder().decode(encodedData);
    }

    /**
     * Base64URL解码为UTF-8字符串
     * @param encodedData Base64URL编码的字符串
     * @return 解码后的原始字符串
     */
    public static String base64UrlDecodeStr(String encodedData) {
        byte[] decodedBytes = Base64.getUrlDecoder().decode(encodedData);
        return new String(decodedBytes, StandardCharsets.UTF_8);
    }



    public static Gson getLowerNameGson(){
        return new GsonBuilder().setFieldNamingStrategy(new LowerNameStrategy()).create();
    }

    public static void sendJsonResult(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
    }

    public static boolean isValidQuerySql(String sqlScript) {
        String update= "UPDATE";
        String del="DELETE";
        String trunc = "TRUNCATE";
        String drop="DROP";

        String upperCase = sqlScript.toUpperCase();
        if(upperCase.contains(update)){
            return false;
        }else if(upperCase.contains(del)){
            return false;
        }else if(upperCase.contains(trunc)){
            return false;
        }else if(upperCase.contains(drop)){
            return false;
        }
        return true;
    }

    public static  String getHashValue4String(String bodyStr) throws UnsupportedEncodingException {
        byte[] bytes = bodyStr.getBytes("UTF-8");
        return MD5.digest(bytes);
    }


    public static PageInfo dealPageInfo(List list) {
        Page page = (Page)list;
        PageInfo<List> pageInfo = new PageInfo();
        if(list != null && !list.isEmpty()) {
            com.github.pagehelper.PageInfo pi = page.toPageInfo();
            pageInfo.setPage(Integer.valueOf(pi.getPageNum()));
            pageInfo.setRecords((int)pi.getTotal()); //前端记录总数用的是records接收，覆盖BaseController中的数据
            pageInfo.setCount(Long.valueOf(pi.getTotal()));
            pageInfo.setTotal(Integer.valueOf(pi.getPages()));
            pageInfo.setRows(pi.getList());
        } else {
            pageInfo.setPage(Integer.valueOf(1));
            pageInfo.setRecords(Integer.valueOf(0));
            pageInfo.setTotal(Integer.valueOf(0));
            pageInfo.setCount(Long.valueOf(0L));
            pageInfo.setRows(new ArrayList());
        }

        return pageInfo;
    }


    public static String getTqbz(){
        String s = String.valueOf(System.nanoTime());
        InetAddress addr = null;
        try {
            addr = InetAddress.getLocalHost();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
        String hostAddress = addr.getHostAddress();
        if(StringUtils.isNotBlank(hostAddress) && hostAddress.length()<24){
            return hostAddress+"-"+s;
        }else {
            return s;
        }
    }
    /**
     * 将流转成字节数组
     * @param input
     * @return
     */
    public static byte[] toByteArray(InputStream input) {
        byte[] bytes = null;
        ByteArrayOutputStream output = new ByteArrayOutputStream();

        try {
            byte[] buffer = new byte[4096];
            boolean var4 = false;

            int n;
            while(-1 != (n = input.read(buffer))) {
                output.write(buffer, 0, n);
            }

            bytes = output.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("将InputStream 转成字节数组失败");
        }

        return bytes;
    }




}
