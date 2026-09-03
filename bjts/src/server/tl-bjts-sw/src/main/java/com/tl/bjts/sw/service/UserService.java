package com.tl.bjts.sw.service;



import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.model.domain.TlUserRoleProfile;
import com.tl.bjts.sw.model.vo.UserInfoVo;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by Mamf on 2017/6/14.
 */
public interface UserService {

     void createUser(TlUserProfile user); //创建账户
     void changePassword(String name, String newPassword);//修改密码
     int updateRole(String czryDm, String roleDm, String crName);

     int addRole(TlUserRoleProfile obj);

     TlUserProfile findByUsername(String username);// 根据用户名查找用户
     Set<String> findRoles(String username);// 根据用户名查找其角色
     Set<String> findPermissions(String username); //根据用户名查找其权限


     List<UserInfoVo> queryUsersByRole(Map<String, String> parmMap);//授权管理获取用户
     int queryUsersByRoleCount(Map parmMap);//授权管理获取用户总数

     List<UserInfoVo> queryUsersByFpgl(Map<String, String> parmMap);//分片管理获取用户

     int queryUsersByFpglCount(Map parmMap);//分片管理获取用户总数

     List<Map<String,String>> querySwjgxx(String czryDm); //根据操作人员代码查询所属税务机关信息



     void updateUser(TlUserProfile user);

     /**
      *
      * @param czryDm 操作人员代码
      * @return 分片管理信息列表
      */
     List<Map<String,String>> getFpglxx(String czryDm);

     /**
      *
      * @param swjgDm 操作人员代码
      * @return
      */
     String getSwjgmc(String swjgDm);

}
