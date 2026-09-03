package com.tl.bjts.sw.service;


import com.tl.bjts.sw.dao.TlLinkedMapper;
import com.tl.bjts.sw.dao.TlSWJGProfileMapper;
import com.tl.bjts.sw.dao.TlUserProfileMapper;
import com.tl.bjts.sw.dao.TlUserRoleProfileMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.model.domain.TlSWJGProfile;
import com.tl.bjts.sw.model.domain.TlUserProfile;

import com.tl.bjts.sw.model.domain.TlUserRoleProfile;
import com.tl.bjts.sw.model.vo.UserInfoVo;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.*;

/**
 * Created by Mamf on 2017/6/14.
 */
@Service
public class UserServiceImpl implements UserService{

    private org.slf4j.Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TlUserProfileMapper userMapper;

    @Autowired
    TlLinkedMapper linkedMapper;

    @Autowired
    TlSWJGProfileMapper swjgMapper;

    @Autowired
    TlUserRoleProfileMapper userRoleProfileMapper;

    @Autowired
    CommonServiceImpl commonService;


    @Override
    public void createUser(TlUserProfile user) {
    }

    @Override
    public void changePassword(String username, String newPassword) {
        TlUserProfile user=new TlUserProfile();
        user.setCzryDm(username);
        user.setPassword(newPassword);

        userMapper.updateByPrimaryKeySelective(user);
    }

    @Override
    public int updateRole(String czryDm, String roleDm,String crName) {
        int ret;
        TlUserRoleProfile profile=new TlUserRoleProfile();
        profile.setRoleDm(roleDm);
        profile.setUptime(new Date());
        profile.setUpname(crName);
        Example exp=new Example(TlUserRoleProfile.class);
        exp.createCriteria().andEqualTo("czryDm",czryDm);
        ret=userRoleProfileMapper.updateByExampleSelective(profile,exp);
        return ret;


    }

    @Override
    public int addRole(TlUserRoleProfile obj) {
        obj.setId(commonService.getDBPk("SYS_CFG_CZRY_ROLE"));
        return userRoleProfileMapper.insertSelective(obj);

    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public TlUserProfile findByUsername(String username) {

        TlUserProfile userProfile =linkedMapper.findByUsername(username);
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
        userMapper.updateByPrimaryKey(user);
    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public List<Map<String, String>> getFpglxx(String czryDm) {
        return linkedMapper.getFpglXx(czryDm);
    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public String getSwjgmc(String swjgDm) {
        TlSWJGProfile tlSWJGProfile = swjgMapper.selectByPrimaryKey(swjgDm);
        return tlSWJGProfile.getSwjgMc();

    }

    @Override
    public List<UserInfoVo> queryUsersByRole(Map<String,String> parmMap) {
        List<UserInfoVo> retList;

        String offset=parmMap.get("offset");
        String size=parmMap.get("size");
        if(StringUtils.isNotBlank(offset)&&StringUtils.isNotBlank(size)) {
            String start = offset;
            int temp = Integer.parseInt(offset) + Integer.parseInt(size) - 1;
            String end = Integer.valueOf(temp) + "";
            parmMap.put("start", start);
            parmMap.put("end", end);
        }
        LOGGER.info("【queryUsersByRole】："+parmMap);
        retList=linkedMapper.queryUsersWithRole(parmMap);
        return retList;
    }

    @Override
    public int queryUsersByRoleCount(Map parmMap) {
        List<UserInfoVo> retList;
        retList=linkedMapper.queryUsersWithRole(parmMap);
        return retList.size();
    }

    @Override
    public int queryUsersByFpglCount(Map parmMap) {
        List<UserInfoVo> retList;
        retList=linkedMapper.queryUsersWithFpgl(parmMap);
        return retList.size();
    }

    @Override
    public List<UserInfoVo> queryUsersByFpgl(Map<String,String> parmMap) {
        List<UserInfoVo> retList;

        String offset=parmMap.get("offset");
        String size=parmMap.get("size");
        if(StringUtils.isNotBlank(offset)&&StringUtils.isNotBlank(size)) {
            String start = offset;
            int temp = Integer.parseInt(offset) + Integer.parseInt(size) - 1;
            String end = Integer.valueOf(temp) + "";
            parmMap.put("start", start);
            parmMap.put("end", end);
        }
        LOGGER.info("【queryUsersByFpgl】："+parmMap);
        retList=linkedMapper.queryUsersWithFpgl(parmMap);
        return retList;
    }

    @Override
    public List<Map<String, String>> querySwjgxx(String czryDm) {
        List<Map<String, String>> mapList = linkedMapper.querySwjgxx(czryDm);
        return mapList;
    }
}
