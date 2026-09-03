package com.tl.bjts.sw.service;




import com.tl.bjts.sw.model.domain.TlRoleProfile;
import com.tl.bjts.sw.model.domain.TlServiceProfile;
import com.tl.bjts.sw.model.domain.TlUserRoleProfile;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by Mamf on 2017/6/14.
 */

public interface RoleService {

     TlRoleProfile createRole(TlRoleProfile role);
     void deleteRole(Long roleId);
     List<TlUserRoleProfile> queryRoles(String username);
     List<TlServiceProfile> queryPermissionsByRoles(List<TlRoleProfile> list);

     Set<String>  getRolesSet(List<TlUserRoleProfile> list);
     Set<String>  getPermsSet(List<TlUserRoleProfile> list);

     List<Map<String,String>> queryRoleInfo(String czryDm);

    //添加角色-权限之间关系
     void correlationPermissions(Long roleId, Long... permissionIds);
    //移除角色-权限之间关系
     void uncorrelationPermissions(Long roleId, Long... permissionIds);//
}
