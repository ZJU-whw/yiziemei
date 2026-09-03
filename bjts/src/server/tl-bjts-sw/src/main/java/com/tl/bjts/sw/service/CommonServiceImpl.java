package com.tl.bjts.sw.service;

import com.google.gson.Gson;
import com.tl.bjts.sw.annotation.ConvertCode;
import com.tl.bjts.sw.biz.DictCache;
import com.tl.bjts.sw.conf.MyAppConfig;
import com.tl.bjts.sw.dao.TlLinkedMapper;
import com.tl.bjts.sw.dao.TlSWJGProfileMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.Dict;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SwjgModel;
import com.tl.bjts.sw.model.TreeNode;
import com.tl.bjts.sw.model.domain.SysUser;
import com.tl.bjts.sw.model.domain.TlSWJGProfile;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @Author：Mamf
 * @Date: 2017/9/22.
 * @Description:
 */
@Service
public class CommonServiceImpl {

    @Autowired
    private TlLinkedMapper linkedMapperMapper;

    @Autowired
    private DictCache dictCache;

    @Autowired
    private TlSWJGProfileMapper swjgProfileMapper;

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    Environment evn;

    public Long getDBPk(String tbName) {
        Long ret = null;
        try {
            synchronized (this) {
                ret = linkedMapperMapper.selectCurvalue(tbName);

                if(ret == null){
                    linkedMapperMapper.insertSequence(tbName);
                    ret = linkedMapperMapper.selectCurvalue(tbName);
                }

                int rows = linkedMapperMapper.updateToNextVal(tbName);
                if (rows == 1) {
                    ret++;
                }
            }
        } catch (Exception e) {
            LOGGER.error("主键获取失败", e);
            throw new BusinessException(BusinessMsgCons.SERVICE_PK_EXIST);
        }

        return ret;
    }

    public TlUserProfile getCurrentUser(){
        Subject subject = SecurityUtils.getSubject();
        String userStr = (String) subject.getSession().getAttribute("u");
        if(StringUtils.isBlank(userStr)){
            //logger.error("获取不到缓存中的用户信息");
            throw new BusinessException(ResultCode.AUTHEN_ERROR);
        }
        SysUser sysUser = new Gson().fromJson(userStr, SysUser.class);
        TlUserProfile userProfile=new TlUserProfile();
        BeanUtils.copyProperties(sysUser,userProfile);
        return userProfile;

    }

    public static void setSession(String attr,String value){
        Subject subject = SecurityUtils.getSubject();
        subject.getSession().setAttribute(attr,value);
    }

    public static Object getSession(String attr){
        Subject subject = SecurityUtils.getSubject();
        return subject.getSession().getAttribute(attr);
    }

    protected void changeDataSource(String targe){
        MultipleDataSourceHolder.clearDBType();
        MultipleDataSourceHolder.setDBType(targe);
    }

    protected void clearDBType(){
        MultipleDataSourceHolder.clearDBType();
    }


    public String getQxdm( ){
        String swjgDm = getCurrentUser().getSwjgDm();
        return TlUtils.getPreSwjgdm(swjgDm);
        //return "133";
    }

    public String getUUId(){
       return UUID.randomUUID().toString().replaceAll("-","");
    }

    //比较传入的税务机关代码，获取正确的权限代码
    public String getQxdm(String swjgdm){
        String curSwjgDm = getCurrentUser().getSwjgDm();
        String curDm = TlUtils.getPreSwjgdm(curSwjgDm);
        if(StringUtils.isBlank(swjgdm)){
            return curDm;
        }
        String dm = TlUtils.getPreSwjgdm(swjgdm);
        if(dm.length() >= curDm.length()){
            return dm;
        }else{
            return curDm;
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public SwjgModel getSwjgMc(String swjgdm){
        return linkedMapperMapper.getSwjgmcByCode(swjgdm);
    }

    /**
     * 当前环境是否支持数据库
     *  生产环境 全部返回true
     * @return
     *
     */
    public boolean supportDb(){
        String profiles = evn.getProperty("spring.profiles.active");
        return profiles.equals("pro");
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
            if(org.springframework.util.StringUtils.isEmpty(dtype)){
                continue;
            }
            code = (String) getter(obj,fieldName);
            codeName = getNameByCode(code,dtype);
            setter(obj,fieldName,codeName,String.class);
        }
    }

    public String getNameByCode(String code, String key){
        if(org.springframework.util.StringUtils.isEmpty(code) || org.springframework.util.StringUtils.isEmpty(key)) {
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


}
