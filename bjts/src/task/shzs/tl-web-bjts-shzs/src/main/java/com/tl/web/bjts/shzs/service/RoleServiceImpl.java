package com.tl.web.bjts.shzs.service;


import com.tl.web.bjts.shzs.dao.TlRoleServiceProfileMapper;
import com.tl.web.bjts.shzs.dao.TlUserRoleProfileMapper;
import com.tl.web.bjts.shzs.model.domain.*;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by Mamf on 2017/6/14.
 */

@Service
public class RoleServiceImpl implements RoleService{

    private org.slf4j.Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TlUserRoleProfileMapper userRoleProfileMappermapper;

    @Autowired
    TlRoleServiceProfileMapper roleServiceProfileMapper;

    @Override
    public Set<String> getRolesSet(List<TlUserRoleProfile> list) {
        Set<String> hst=new HashSet<>();
        for(TlUserRoleProfile obj:list){
            hst.add(obj.getRoleDm());
        }
        return hst;
    }

    @Override
    public Set<String> getPermsSet(List<TlUserRoleProfile> list) {
        Set<String> hst=new HashSet<>();

        for(TlUserRoleProfile obj:list){
            String rolsDm=obj.getRoleDm();

            TlRoleServiceProfileExample example=new TlRoleServiceProfileExample();
            example.createCriteria().andRoleDmEqualTo(rolsDm);
            List<TlRoleServiceProfile> roleSerList = roleServiceProfileMapper.selectByExample(example);

            for(TlRoleServiceProfile roleSer:roleSerList){
                hst.add(roleSer.getRoleDm());
            }

        }

        return hst;
    }

    @Override
    public List<TlUserRoleProfile> queryRoles(String username) {
        TlUserRoleProfileExample example=new TlUserRoleProfileExample();
        TlUserRoleProfileExample.Criteria criteria = example.createCriteria();
        criteria.andCzryDmEqualTo(username);
        return userRoleProfileMappermapper.selectByExample(example);
    }

    @Override
    public List<TlServiceProfile> queryPermissionsByRoles(List<TlRoleProfile> list) {
        return null;
    }

    @Override
    public TlRoleProfile createRole(TlRoleProfile role) {
        return null;
    }

    @Override
    public void deleteRole(Long roleId) {

    }

    @Override
    public void correlationPermissions(Long roleId, Long... permissionIds) {

    }

    @Override
    public void uncorrelationPermissions(Long roleId, Long... permissionIds) {

    }
}
