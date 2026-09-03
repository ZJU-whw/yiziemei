package com.tl.bjts.sw.controller;

import com.google.gson.reflect.TypeToken;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;


import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.service.QtBizService;
import com.tl.common.ext.utils.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;


@RequestMapping("search")
@RestController
public class TscxController extends BaseController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());




    @Autowired
    QtBizService qtBizService;



    @PostMapping("cktsjbqk")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult cktsjbqk(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        try {

/*            DqTsqkDTO dto =getParam(request.getInputStream(), DqTsqkDTO.class);


            rtn.setData(dealPageInfo(retList));*/
            return rtn;

        }catch (BusinessException e){
            rtn.setMsg(e.getMsg());
            rtn.setCode(e.getCode());
        }
        return rtn;
    }

    @PostMapping("tj/extra")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult extraCx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String year = param.get("year");

        if(StringUtils.isBlank(year)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<TjfxExtraCkts> retList=qtBizService.extraCx(year);

        rtn.setData(retList);
        return rtn;

    }

    @PostMapping("tj/extra/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult extraCxUpdate(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Type type = new TypeToken<List<TjfxExtraCkts>>() {
        }.getType();


        List<TjfxExtraCkts> revList = getParam(request.getInputStream(), type);


        if(!CollectionUtils.isEmpty(revList)){
            qtBizService.saveExtraCkts(revList);
        }

        return rtn;

    }

    @PostMapping("tj/hzfx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult hzcx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String year = param.get("year");

        if(StringUtils.isBlank(year)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<TjfxExtraCktsVo> retList=qtBizService.tjHzCx(year);

        rtn.setData(retList);
        return rtn;

    }

}
