package com.tl.bjts.sw.annotation;

import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.utils.TlBeanUtils;
import org.apache.shiro.util.CollectionUtils;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Author：Mamf
 * @Date: 2018/6/27.
 * @Description:
 */
public class AnnoUtil {

    /*
 * @Description: 校验参数（简易版）
 * @Author Neo Lin
 * @param  [t]
 * @return  void
 * @Date  2018/4/11
 */
    public static  <T> void checkParam(T t) {
        if (t == null) {
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        //反射获取所有字段
        Field[] fields = TlBeanUtils.getAllFields(t);

        for (Field field : fields) {
            checkNotNull(field,t);  //检查对象非空
            checkNotEmpty(field,t); //检查字符串或者集合是否非空
            checkIsNumber(field,t); //检查是否为数字类型
            checkMaxLength(field,t); //检查字符串最大长度
            checkInjection(field,t); //检查sql注入
            checkNeedCheck(field,t); //检查对象的属性
        }

    }


    /*
     * @Description: 检查对象是否为空
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkNotNull(Field field, T t){
        String errorMsg;
        Object obj;
        NotNull notNull = field.getAnnotation(NotNull.class);
        if (notNull != null) {
            //校验是否为空
            errorMsg = notNull.msg();
            obj = TlBeanUtils.getter(t, field.getName());
            if (obj == null) {
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR, errorMsg);
            }
        }
    }

    /*
     * @Description: 检查字符串类型或者集合类型是否为空
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkNotEmpty(Field field, T t){
        String errorMsg;
        Object obj;
        NotEmpty notEmpty = field.getAnnotation(NotEmpty.class);
        if (notEmpty != null) {
            errorMsg = notEmpty.msg();
            obj = TlBeanUtils.getter(t, field.getName());
            if (obj == null || (obj instanceof String && "".equals(obj))) {
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR,errorMsg);
            }
            if (obj instanceof Collection && CollectionUtils.isEmpty((Collection) obj)) {
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR,errorMsg);
            }
        }

    }

    /*
     * @Description: 检查是否是数字类型，但是好像没啥卵用
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkIsNumber(Field field,T t){
        String errorMsg;
        Object obj;
        IsNumber isNumber = field.getAnnotation(IsNumber.class);
        if (isNumber != null) {
            errorMsg = isNumber.msg();
            obj = TlBeanUtils.getter(t, field.getName());
            if(obj!=null){
                try {
                    new BigDecimal(obj.toString());
                } catch (Exception e) {
                    throw new BusinessException(ResultCode.REQ_FORMAT_ERROR,errorMsg);
                }
            }
        }
    }

    /*
     * @Description: 检查字段的最大长度
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkMaxLength(Field field,T t){
        String errorMsg;
        Object obj;
        int length;
        MaxLength maxLength = field.getAnnotation(MaxLength.class);
        if (maxLength != null) {
            errorMsg = maxLength.msg();
            length = maxLength.length();
            obj = TlBeanUtils.getter(t, field.getName());
            if (obj instanceof String) {
                if(((String) obj).length() > length){
                    throw new BusinessException(ResultCode.REQ_FORMAT_ERROR,String.format(errorMsg,length));
                }
            }
        }

    }


    /*
     * @Description: 检查字段是否有sql注入的隐患
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkInjection(Field field,T t){
        String errorMsg;
        Object obj;
        AntiSqlInjection antiSqlInjection = field.getAnnotation(AntiSqlInjection.class);
        if (antiSqlInjection != null) {  //防止sql注入
            obj = TlBeanUtils.getter(t, field.getName());
            errorMsg = antiSqlInjection.msg();
            if (obj == null || "".equals(obj)) {
                return;
            }
            String str = obj.toString();
            if (str.length() > 15) {
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR, errorMsg);
            }
            if (!checkSqlInjection(str)) {
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR, errorMsg);
            }
        }
    }

    /*
     * @Description: 检查该对象的属性
     * @Author Neo Lin
     * @param  [field, t]
     * @return  void
     */
    private static <T> void checkNeedCheck(Field field,T t){
        String errorMsg;
        Object obj;
        NeedCheck needCheck = field.getAnnotation(NeedCheck.class);
        if (needCheck != null) {
            errorMsg = needCheck.msg();
            obj = TlBeanUtils.getter(t, field.getName());
            if(null == obj){
                throw new BusinessException(ResultCode.REQ_FORMAT_ERROR,errorMsg);
            }
            if(obj instanceof Collection && !CollectionUtils.isEmpty((Collection) obj)){//如果是集合类型，遍历集合递归
                for (Object obj2 : (Collection) obj){
                    checkParam(obj2);
                }
            }else{
                checkParam(obj);   //递归调用
            }

        }
    }

    private  static boolean checkSqlInjection(String str) {
        Pattern p = Pattern.compile("^[A-Za-z]*_*[A-Za-z]*\\.*[A-Za-z]*_*[A-Za-z]*+\\s*[A-Za-z]*$");
        Matcher m = p.matcher(str);
        return m.matches();
    }

}
