package com.tl.bjts.sw.service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tl.common.rpc.RpcAuthHelper;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class AuthService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    private RestTemplate restTemplate;



    public BaseVO getPermList(String username) {
        Map<String,String> map = new HashMap();
        map.put("username",username);
        String url = "http://bjts.swgl.user/auth/rpc/user/rolePerm";
        url = RpcAuthHelper.attachUrl(url);
        String permListStr = restTemplate.postForEntity(url,new Gson().toJson(map),String.class).getBody();
        Gson gson = new Gson();
        SimpleResult<BaseVO> rtn = gson.fromJson(permListStr,new TypeToken<SimpleResult<BaseVO>>(){}.getType());
        if(rtn != null && rtn.getCode() == 0){
            return rtn.getData();
        }else{
            return new BaseVO();
        }
    }


    public SimpleAuthorizationInfo getAuthInfo(String username){
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        BaseVO vo = getPermList(username);
        Set<String> roleSet = list2Set(vo.getRoles());
        if (!roleSet.contains("czy")){
            roleSet.add("czy");
        }
        info.setRoles(roleSet);
        info.setStringPermissions(list2Set(vo.getPerms()));
        return info;
    }

    private Set<String> list2Set(List<String> list) {
        Set<String> set = new HashSet<>();
        if(CollectionUtils.isEmpty(list)){
            return set;
        }
        set.addAll(list);
        return set;
    }

    public class BaseVO{
        private List<String> roles;

        private List<String> perms;

        public List<String> getRoles() {
            return roles;
        }

        public void setRoles(List<String> roles) {
            this.roles = roles;
        }

        public List<String> getPerms() {
            return perms;
        }

        public void setPerms(List<String> perms) {
            this.perms = perms;
        }
    }


    public class SimpleResult<T> {

        private int code;

        private String msg;

        private T data;

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
        }

        public String getMsg() {
            return msg;
        }

        public void setMsg(String msg) {
            this.msg = msg;
        }

        public T getData() {
            return data;
        }

        public void setData(T data) {
            this.data = data;
        }
    }






}
