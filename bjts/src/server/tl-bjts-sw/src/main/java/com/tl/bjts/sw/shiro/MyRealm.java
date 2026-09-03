package com.tl.bjts.sw.shiro;


import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.model.domain.TlUserRoleProfile;
import com.tl.bjts.sw.service.AuthService;
import com.tl.bjts.sw.service.RoleService;
import com.tl.bjts.sw.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Set;


/**
 * Created by wzy on 2016-05-20.
 */
public class MyRealm extends AuthorizingRealm {


    @Autowired
    private AuthService authService;

    @Autowired
    private RoleService roleService;

    // 获取授权信息
    protected AuthorizationInfo doGetAuthorizationInfo( PrincipalCollection principals) {
//        String username = (String)getAvailablePrincipal(principals);

//        if( username != null ){
//
//            List<TlUserRoleProfile> listRoles = roleService.queryRoles(username);
//
//            if (listRoles!=null){
//                Set<String> roles = roleService.getRolesSet(listRoles);
//                if (!roles.contains("czy")){
//                    roles.add("czy");
//                }
//                Set<String> perms = roleService.getPermsSet(listRoles);
//                SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
//                info.setRoles(roles);
//                info.setStringPermissions(perms);
//
//                return info;
//            }
//        }
//        return null;

        String username = (String)getAvailablePrincipal(principals);

        if( username != null ){
            //查询用户授权信息
            return authService.getAuthInfo(username);
        }
        return null;
    }


    // 获取认证信息
    protected AuthenticationInfo doGetAuthenticationInfo(
            AuthenticationToken authcToken) throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
        // 通过表单接收的用户名
        String username = token.getUsername();

        return null;
    }

    @Override
    public void clearCachedAuthorizationInfo(PrincipalCollection principals) {
        super.clearCachedAuthorizationInfo(principals);
    }


    @Override
    public void clearCache(PrincipalCollection principals) {
        super.clearCache(principals);
    }
}
