package com.tl.web.bjts.shzs.shiro;

import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserRoleProfile;
import com.tl.web.bjts.shzs.service.RoleService;
import com.tl.web.bjts.shzs.service.UserService;
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
    private UserService userService;

    @Autowired
    private RoleService roleService;

    // 获取授权信息
    protected AuthorizationInfo doGetAuthorizationInfo( PrincipalCollection principals) {
        String username = (String)getAvailablePrincipal(principals);

        if( username != null ){

            List<TlUserRoleProfile> listRoles = roleService.queryRoles(username);

            if (listRoles!=null){
                Set<String> roles = roleService.getRolesSet(listRoles);
                Set<String> perms = roleService.getPermsSet(listRoles);
                SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
                info.setRoles(roles);
                info.setStringPermissions(perms);

                return info;
            }
        }
        return null;
    }

    // 获取认证信息
    protected AuthenticationInfo doGetAuthenticationInfo(
            AuthenticationToken authcToken ) throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
        // 通过表单接收的用户名
        String username = token.getUsername();

        if( username != null && !"".equals(username) ){

            TlUserProfile invoiceUser = userService.findByUsername(username);

            String salt = "tl-soft";

            //重新登陆时 清除授权缓存
            if( invoiceUser != null ){
                SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(
                        invoiceUser.getCzryDm(),
                        invoiceUser.getPassword(),
                        ByteSource.Util.bytes(salt),
                        getName());

                return info;
            }

        }

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
