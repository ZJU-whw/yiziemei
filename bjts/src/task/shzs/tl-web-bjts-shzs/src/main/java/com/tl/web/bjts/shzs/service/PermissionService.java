package com.tl.web.bjts.shzs.service;


import com.tl.web.bjts.shzs.model.domain.TlServiceProfile;

/**
 * Created by Mamf on 2017/6/14.
 */
public interface PermissionService {

    public TlServiceProfile createPermission(TlServiceProfile permission);
    public void deletePermission(Long permissionId);

}
