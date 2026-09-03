package com.tl.bjts.sw.service;


import com.tl.bjts.sw.dao.TlLinkedMapper;
import com.tl.bjts.sw.dao.TlRoleServiceProfileMapper;
import com.tl.bjts.sw.dao.TlUserRoleProfileMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.model.domain.TlRoleProfile;
import com.tl.bjts.sw.model.domain.TlRoleServiceProfile;
import com.tl.bjts.sw.model.domain.TlServiceProfile;
import com.tl.bjts.sw.model.domain.TlUserRoleProfile;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
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

    @Autowired
    TlLinkedMapper linkedMapper;

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public Set<String> getRolesSet(List<TlUserRoleProfile> list) {
        Set<String> hst=new HashSet<>();
        for(TlUserRoleProfile obj:list){
            hst.add(obj.getRoleDm());
        }
        return hst;
    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public Set<String> getPermsSet(List<TlUserRoleProfile> list) {
        Set<String> hst=new HashSet<>();

        for(TlUserRoleProfile obj:list){
            String rolsDm=obj.getRoleDm();

            Example example=new Example(TlUserRoleProfile.class);
            example.createCriteria().andEqualTo("roleDm",rolsDm);
            List<TlRoleServiceProfile> roleSerList = roleServiceProfileMapper.selectByExample(example);

            for(TlRoleServiceProfile roleSer:roleSerList){
                hst.add(roleSer.getServiceDm());
            }

        }

        return hst;
    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public List<TlUserRoleProfile> queryRoles(String username) {
        Example example=new Example(TlUserRoleProfile.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("czryDm",username);
        return userRoleProfileMappermapper.selectByExample(example);
    }

    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public List<Map<String, String>> queryRoleInfo(String czryDm) {
        List<Map<String, String>> mapList = linkedMapper.queryRoleInfo(czryDm);
        return mapList;
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
