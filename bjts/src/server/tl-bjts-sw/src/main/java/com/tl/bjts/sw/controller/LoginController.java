package com.tl.bjts.sw.controller;


import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.service.*;
import com.tl.bjts.sw.utils.TlConst;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.utils.CommonUtils;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Mamf on 2017/6/13.
 */

@RestController
public class LoginController {

    private org.slf4j.Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;

    @Autowired
    CommonServiceImpl commonService;

    /**
     * 初始化登录
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/login")
    public SimpleResult login(HttpServletRequest request) throws Exception{

        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        TlUserProfile user=new Gson().fromJson(reqStr,TlUserProfile.class);
        if(user==null||user.getCzryDm()==null||user.getPassword()==null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        TlUserProfile dbUser = userService.findByUsername(user.getCzryDm().toUpperCase());
        if(dbUser==null){
              throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_EMPTYUSER);
        }
      //String salt = "tl-soft";
      //String newPwd=PasswordManger.instance().encryptPassword(user.getPassword(),salt);
      //userService.changePassword(dbUser.getCzryDm(),newPwd);

        UsernamePasswordToken token = new UsernamePasswordToken(user.getCzryDm().toUpperCase(),user.getPassword());
        Subject currentUser = SecurityUtils.getSubject();


        try {
            currentUser.login(token);

        }catch (ExcessiveAttemptsException e){
            throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_TRYMUCH);
        }catch (UnknownAccountException e){
            throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_NO);
        }catch (IncorrectCredentialsException e){
            throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_NO);
        }catch (ExpiredCredentialsException e){
            throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_OVERDUE);
        }catch (AuthenticationException e) {
            throw new BusinessException(BusinessMsgCons.CONTROLLER_LOGIN_FAILED);
        }

        Session  session = currentUser.getSession();
        session.setAttribute("user", new Gson().toJson(dbUser));
        SimpleResult rtn = loadData(request);
        return rtn;

    }

    @RequestMapping("/logout")
    public SimpleResult logout(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        session.stop();
        currentUser.logout();
        return rtn;

    }

    /**
     * 加载初始化基础信息
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/preLogin")
    public SimpleResult loadData(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();

        TlUserProfile user = commonService.getCurrentUser();

        String swjgMc=userService.getSwjgmc(user.getSwjgDm());

      //  List<Map<String,String>> list=userService.getFpglxx(user.getCzryDm());

        List<Map<String, String>> mapList = roleService.queryRoleInfo(user.getCzryDm());
        Map<String, String> tempMap=new HashMap<>();

        Map<String,Object> map=new HashMap<>();
        if(mapList.size()>0){
            tempMap = mapList.get(0);
            map.put("roleDm",tempMap.get("ROLE_DM"));
            map.put("roleMc",tempMap.get("ROLE_MC"));
            //session.setAttribute("roleDm",tempMap.get("ROLE_DM"));

        }else{
            map.put("roleDm","czy");
            map.put("roleMc","普通用户");
            //session.setAttribute("roleDm","czy");
        }


        map.put("czryDm",user.getCzryDm());
        map.put("czrymc",user.getCzryMc());
        map.put("description",user.getDescription());
        map.put("swjgMc",swjgMc);
        map.put("swjgDm",user.getSwjgDm());
        map.put("yhlx",user.getYhlx());
//        map.put("fpglxxs",list);


        rtn.setMsg("OK");
        rtn.setData(map);

        return rtn;

    }
}
