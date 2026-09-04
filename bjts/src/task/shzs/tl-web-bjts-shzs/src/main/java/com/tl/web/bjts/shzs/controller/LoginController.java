package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.redis.shiro.PasswordManger;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.LoginDTO;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.UserService;
import com.tl.web.bjts.shzs.utils.CompareVersion;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
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
    AppProperties appProperties;
    @Autowired
    private CommonServiceImpl commonService;

    /**
     * 初始化登录
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/login")
    public SimpleResult login(HttpServletRequest request) throws Exception{
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/login】 params：" + reqStr);
        LoginDTO user=new Gson().fromJson(reqStr,LoginDTO.class);

        if(user==null||user.getCzryDm()==null||user.getPassword()==null){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        /**
         * 比较审核助手版本，如果小于基准版本则需要升级
         */
        if(CompareVersion.compare(appProperties.getBenchmarkVer(),user.getShzsVersion()) > 0){
            throw new BusinessException(ResultCode.SHZS_VERSION_LOW);
        }

        try{
            TlUserProfile dbUser = userService.findByUsername(user.getCzryDm());
            String salt = "tl-soft";
            String newPwd=PasswordManger.instance().encryptPassword(user.getPassword(),salt);
            if(dbUser!=null){
                //测试环境下，跳过金三系统的检测，公司测试环境无法提供金三的环境
                if(!appProperties.isTest()){
                    userService.getUserInfoFromJsxt(dbUser);
                    userService.changePassword(dbUser,newPwd);
                }
            }else{ //如果不存在用户，则新增用户到tl_bjts.dm_czry中
                dbUser = new TlUserProfile();
                dbUser.setCzryDm(user.getCzryDm());
                dbUser.setPassword(newPwd);
                dbUser.setYhlx(ConstUtil.DMCZRY_YHLX_PTCZY);
                dbUser.setUsrstate(ConstUtil.DMCZRY_USRSTATE);
                dbUser.setCrtime(new Date());
                dbUser.setQybz(ConstUtil.WHETHER_YES);
                //从金三中获取操作人员信息,用于填充操作人员名称和税务机关代码
                userService.getUserInfoFromJsxt(dbUser);
                userService.createUser(dbUser);
            }

            UsernamePasswordToken token = new UsernamePasswordToken(user.getCzryDm(),user.getPassword());
            Subject currentUser = SecurityUtils.getSubject();
            try {

                //if (!currentUser.isAuthenticated()){
                //    token.setRememberMe(false);
                currentUser.login(token);
                //}
            } catch (AuthenticationException e) {
                LOGGER.error("【login】：输入账号:"+user.getCzryDm());
                throw new BusinessException(ResultCode.LOGIN_ERROR);
            }

            Session  session = currentUser.getSession();
            session.setAttribute("user", new Gson().toJson(dbUser));
            SimpleResult rtn = loadData(request);
            return rtn;
        }catch (BusinessException e){
            LOGGER.error("【login】：登录失败:{}"+user.getCzryDm(),e.getMsg());
            SimpleResult rtn = new SimpleResult();
            rtn.setCode(e.getCode());
            rtn.setMsg(e.getMsg());
            return rtn;
        }catch (Exception e){
            LOGGER.error("【login】：登录失败:{}"+user.getCzryDm(),e);
        }
           return null;
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
    @RequestMapping("/user/info")
    public SimpleResult loadData(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();

        TlUserProfile user = commonService.getCurrentUser();

        String swjgMc=userService.getSwjgmc(user.getSwjgDm());
        List<Map<String,String>> list=userService.getFpglxx(user.getCzryDm());

        Map<String,Object> map=new HashMap<>();
        map.put("czryDm",user.getCzryDm());
        map.put("czrymc",user.getCzryMc());
        map.put("description",user.getDescription());
        map.put("swjgMc",swjgMc);
        map.put("swjgDm",user.getSwjgDm());
        map.put("lxdh",user.getLxdh());
        //map.put("fpglxxs",new Gson().toJson(list));
        map.put("fpglxxs",list);

        //String jsonData=new Gson().toJson(map);
        rtn.setMsg("OK");
        rtn.setData(map);

        return rtn;

    }
}
