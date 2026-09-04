package com.tl.web.bjts.shzs.service;


import com.tl.web.bjts.shzs.dao.*;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.domain.TlSWJGProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.vo.JxUserVO;
import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by Mamf on 2017/6/14.
 */
@Service
public class UserServiceImpl implements UserService{

    private org.slf4j.Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TlUserProfileMapper mapper;

    @Autowired
    TlLinkedMapper linkedMapperMapper;

    @Autowired
    TlSWJGProfileMapper swjgMapper;

    @Autowired
    TlJsxtMapper jsxtMapper;


    @Override
    public void createUser(TlUserProfile user) {
        mapper.insertSelective(user);
    }

    @Override
    public void changePassword(TlUserProfile dbUser, String newPassword) {
        TlUserProfile user=new TlUserProfile();
        user.setCzryDm(dbUser.getCzryDm());
        user.setPassword(newPassword);
        user.setSwjgDm(dbUser.getSwjgDm());
        user.setCzryMc(dbUser.getCzryMc());
        mapper.updateByPrimaryKeySelective(user);
    }

    @Override
    public void correlationRoles(Long userId, Long... roleIds) {

    }

    @Override
    public void uncorrelationRoles(Long userId, Long... roleIds) {

    }

    @Override
    public TlUserProfile findByUsername(String username) {

        TlUserProfile userProfile = mapper.selectByPrimaryKey(username);
        return userProfile;
    }

    @Override
    public Set<String> findRoles(String username) {
        Set<String> hst=new HashSet<>();
        hst.add("admin");
        hst.add("authc");
        hst.add("user");
        return hst;
    }


    /**
     * 从金三数据库中获取用户信息
     * @param user  便捷退税系统中的用户
     * @return
     */
    public void getUserInfoFromJsxt(TlUserProfile user){
        try {
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            JxUserVO jsUserVO = jsxtMapper.getUserInfoFromJsxt(user.getCzryDm());
            if(jsUserVO == null){
                throw new BusinessException(ResultCode.USER_NOT_EXIST_JS);
            }
            String czryMc = jsUserVO.getSwryMc();
            //身份税务机关代码
            /**
             * sfswjg_dm是操作员的金三岗位身份代码，需提升一级作为dm_czry表的swjg_dm税务机关代码
             */
            String sfswjgDm = jsUserVO.getSfswjgDm();
            //税务机关代码
            String swjgDm = transferSfswjgDm2SwjgDm(sfswjgDm);
            user.setCzryMc(czryMc);
            user.setSwjgDm(swjgDm);
            LOGGER.info("从金三数据库中获取用户信 查询结果re-{}", ToStringBuilder.reflectionToString(jsUserVO));
        }catch (BusinessException e){
            LOGGER.error("从金三数据库中获取用户信息出错-账号:{} errMSg:{}", user.getCzryDm(),e.getMsg());
            throw  e;
        }catch (Exception e){
            LOGGER.error("从金三数据库中获取用户信息出错-账号:{} errMSg:{}", user.getCzryDm(),e);
        }
        finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     * 金三岗位身份代码转换为税务机关代码
     * 转换规则：
     *   末尾两个0或者末尾没有0的的提升为末尾4个0（13301051000 -> 13301050000拱墅区某科所机关提升为拱墅区代码）；
         末尾4个0的提升为末尾6个0（13301050000 ->13301000000拱墅区代码提升为杭州市局代码）；
         末尾6个0的提升为末尾8个0（13301000000 ->13300000000杭州市局代码提升为浙江省局）
     * @param sfswjgDm 金三岗位身份代码
     * @return 税务机关代码
     */
    public static String transferSfswjgDm2SwjgDm(String sfswjgDm){
        if(StringUtils.isBlank(sfswjgDm)){
            return null;
        }
        String preSwjgDm = TlUtils.getPreSwjgdm(sfswjgDm);
        if(StringUtils.isBlank(preSwjgDm)){
            return null;
        }
        if(preSwjgDm.length() == 11 ||preSwjgDm.length() == 9){
            return preSwjgDm.substring(0,7).concat("0000");
        }else if(preSwjgDm.length() == 7){
            return preSwjgDm.substring(0,5).concat("000000");
        }else if(preSwjgDm.length() == 5){
            return preSwjgDm.substring(0,3).concat("00000000");
        }
        return sfswjgDm;
    }

    @Override
    public Set<String> findPermissions(String username) {
        Set<String> hst=new HashSet<>();
        hst.add("service:add,update");
        hst.add("service2:query,update");
        hst.add("service3:login");

        LOGGER.info("-------findPermissions-------");

        return hst;
    }

    @Override
    public void updateUser(TlUserProfile user) {
        mapper.updateByPrimaryKey(user);
    }

    @Override
    public List<Map<String, String>> getFpglxx(String czryDm) {
        return linkedMapperMapper.getFpglXx(czryDm);
    }

    @Override
    public String getSwjgmc(String swjgDm) {
        TlSWJGProfile tlSWJGProfile = swjgMapper.selectByPrimaryKey(swjgDm);
        return tlSWJGProfile.getSwjgMc();

    }
}
