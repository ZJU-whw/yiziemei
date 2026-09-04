package com.tl.web.bjts.shzs.service;



import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import java.util.*;

/**
 * Created by Mamf on 2017/6/14.
 */
public interface UserService {

     void createUser(TlUserProfile user); //创建账户
     void changePassword(TlUserProfile dbUser, String newPassword);//修改密码
     void correlationRoles(Long userId, Long... roleIds); //添加用户-角色关系
     void uncorrelationRoles(Long userId, Long... roleIds);// 移除用户-角色关系
     TlUserProfile findByUsername(String username);// 根据用户名查找用户
     Set<String> findRoles(String username);// 根据用户名查找其角色
     Set<String> findPermissions(String username); //根据用户名查找其权限
     void getUserInfoFromJsxt( TlUserProfile addUser); //从金三数据库中获取用户信息

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
