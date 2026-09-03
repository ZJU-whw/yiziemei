package com.tl.bjts.sw.controller;

import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.TreeNode;
import com.tl.bjts.sw.model.domain.SysCfgTableColumn;
import com.tl.bjts.sw.service.BasisService;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.ext.utils.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2019/7/31.
 * @Description:
 */
@RequestMapping("basis")
@RestController
public class AppBaseController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    BasisService basisService;

    @PostMapping("columprofile")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult  viewColumprofile(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String tcode = param.get("tcode");
        if(StringUtils.isBlank(tcode)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        String czryDm = commonService.getCurrentUser().getCzryDm();

        String select = basisService.getUserTableSelect(czryDm,tcode);
        if(select==null){
            select="";
        }
        List<SysCfgTableColumn> profiles= basisService.getUserTableColumn(tcode);

        Map retMap=new HashMap();
        retMap.put("select",select);
        retMap.put("profiles",profiles);

        rtn.setData(retMap);
        return rtn;
    }

    @PostMapping("columprofile/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult  updateColumprofile(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String tcode = param.get("tcode");
        String cs = param.get("cs");
/*        if(StringUtils.isBlank(tcode)||StringUtils.isBlank(cs)||"".equals(cs)||"".equals(tcode)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }*/

        String czryDm = commonService.getCurrentUser().getCzryDm();

        basisService.saveTableUserCs(czryDm,tcode,cs);

        return rtn;
    }


    @PostMapping("readtree")
    public SimpleResult readjson(HttpServletRequest request) throws Exception {
        SimpleResult result=new SimpleResult();

        List<TreeNode> retList = basisService.getSelectTree(commonService.getCurrentUser().getSwjgDm());

        for (TreeNode treeNode : retList) {
            treeNode.setItem(null);
        }

        result.setData(retList);
        return result;
    }


}
