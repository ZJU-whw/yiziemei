package com.tl.web.bjts.shzs.service;

import com.google.gson.Gson;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.cache.DictCache;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.TlLinkedMapper;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.Dict;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2017/9/22.
 * @Description:
 */
@Service
public class CommonServiceImpl {

    @Autowired
    TlLinkedMapper linkedMapperMapper;

    @Autowired
    private DictCache dictCache;

    @Autowired
    private AppProperties appProperties;

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    public Long getDBPk(String tbName) {
        Long ret=null;
        try {
            synchronized(this) {
                int rows = linkedMapperMapper.updateToNextVal(tbName);
                if (rows == 1) {
                    ret = linkedMapperMapper.selectCurvalue(tbName);
                }
            }
        } catch (Exception e) {
            LOGGER.error("主键获取失败",e);
            throw new BusinessException(BusinessMsgCons.SERVICE_SBXXHZ_RWTXPK);
        }

        return ret;
    }

    public Long getDBPk4Admin(String tbName) {
        Long ret=null;
        try {
            synchronized(this) {
                int rows = linkedMapperMapper.updateToNextVal4Admin(tbName);
                if (rows == 1) {
                    ret = linkedMapperMapper.selectCurvalue4Admin(tbName);
                }
            }
        } catch (Exception e) {
            LOGGER.error("主键获取失败",e);
            throw new BusinessException(BusinessMsgCons.SERVICE_SBXXHZ_RWTXPK);
        }

        return ret;
    }



    public String getNameByCode(String code, String key){
        if(StringUtils.isEmpty(code) || StringUtils.isEmpty(key)) {
            return "";
        }
        List<Dict> dicts = dictCache.getCacheKeyloadingCache(key);
        for(Dict dict : dicts){
            if(code.equals(dict.getDcode())){
                return dict.getDname();
            }
        }
        return code;
    }

    public void convertCode2Name(Object obj){
        if(obj == null)
            return;
        Class clazz = obj.getClass();
        Field[] fields = clazz.getDeclaredFields();
        ConvertCode convertCode;
        String dtype;
        String code;
        String codeName;
        String fieldName;
        for (Field field : fields){
            fieldName = field.getName();
            convertCode = field.getAnnotation(ConvertCode.class);
            if(convertCode == null){
                continue;
            }
            dtype = convertCode.dtype();
            if(StringUtils.isEmpty(dtype)){
                continue;
            }
            code = (String) getter(obj,fieldName);
            codeName = getNameByCode(code,dtype);
            setter(obj,fieldName,codeName,String.class);
        }
    }

    /**
     Object obj：要操作的对象
     String att：要操作的属性
     Object value：要设置的属性内容
     Class<?> type：要设置的属性类型
     */
    private void setter(Object obj,String att,Object value,Class<?> type){
        try{
            Method met = obj.getClass().getMethod("set"+initStr(att),type) ;    // 得到setter方法
            met.invoke(obj,value) ; // 设置setter的内容
        }catch(Exception e){
            /**
             *  由于属性名定义不规范，例如gUnit，使用idea的setter和getter方法生成的文件名为setgUnit,这样就会出问题
             *  下述方式尝试再次反射，方法setter后为小写字母
             */
            try{
                Method met = obj.getClass().getMethod("set"+initStrLower(att),type) ;    // 得到setter方法
                met.invoke(obj,value) ; // 设置setter的内容
            }catch(Exception e1){
                e1.printStackTrace() ;
            }
        }
    }

    private Object getter(Object obj,String att) {
        try {
            Method met = obj.getClass().getMethod("get" + initStr(att)); // 得到getter方法
            return met.invoke(obj) ;
        } catch (Exception e) {
            try {
                Method met = obj.getClass().getMethod("get" + initStrLower(att)); // 得到getter方法
                return met.invoke(obj) ;
            } catch (Exception e1) {
                e1.printStackTrace();
                return  null;
            }
        }
    }

    /**
     *  set后第一位大写
     * @param attr
     * @return
     */
    private String initStr(String attr){
        return Character.toUpperCase(attr.charAt(0)) + attr.substring(1);
    }

    /**
     *  set后第一位小写
     * @param attr
     * @return
     */
    private String initStrLower(String attr){
        return attr.charAt(0) + attr.substring(1);
    }

    /**
     *  获取当前登录名
     * @return
     */
    public  String getCurrentLoginName(){
        TlUserProfile user = getCurrentUser();
        return user.getCzryDm();
    }

    /**
     *  获取当前登录的用户名
     * @return
     */
    public String getCurrentUserName(){
        TlUserProfile user = getCurrentUser();
        return user.getCzryMc();
    }

    /**
     *  获取当前登录用户
     * @return
     */
    public TlUserProfile getCurrentUser(){
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        TlUserProfile user = parseJson2User(session.getAttribute("user"));
        if(user==null){
            throw new BusinessException(BusinessMsgCons.CONTROLLER_SHZS_UNLOGIN);
        }
        return user;
    }

    private TlUserProfile parseJson2User(Object jsonUser){
        if(jsonUser==null){
            if(appProperties.isTest()){
                return testUser();
            }else {
                return null;
            }
        }
        return new Gson().fromJson(String.valueOf(jsonUser),TlUserProfile.class);
    }

    private TlUserProfile testUser(){
        TlUserProfile user=new TlUserProfile();
        user.setCzryDm("13301090092");
        user.setYhlx("0");
        user.setCzryMc("蔡琦");
        user.setSwjgDm("13301080000");
        return user;
    }

}
