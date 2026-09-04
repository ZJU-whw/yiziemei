package com.tl.web.bjts.shzs.controller;

import com.github.pagehelper.PageHelper;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.dto.BaseIdDTO;
import com.tl.web.bjts.shzs.model.dto.dzhc.*;
import com.tl.web.bjts.shzs.model.vo.dzhc.InspectBusinessAvailableVO;
import com.tl.web.bjts.shzs.model.vo.dzhc.InspectQueryVO;
import com.tl.web.bjts.shzs.model.vo.dzhc.InspectTaskOpenVO;
import com.tl.web.bjts.shzs.model.vo.dzhc.ShzsInspectStateCheckVO;
import com.tl.web.bjts.shzs.service.IInspectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @描述: 日常审单核查控制器
 * @作者: likun
 * @时间: 2022/4/22 16:33
 */
@RestController
@RequestMapping("inspect")
public class InspectController extends TLBaseController{
    @Autowired
    IInspectService inspectService;

    /**
     * 校验出口业务审单核查状态
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("business/check")
    public SimpleResult inspectStateCheck(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        ShzsInspectStateCheckDTO dto = getAndCheckParam(request.getInputStream(), ShzsInspectStateCheckDTO.class);
        //获取列表数据
        List<ShzsInspectStateCheckVO> retList = inspectService.inspectStateCheck(dto);
        rtn.setData(retList);
        return rtn;
    }

    /**
     * 查看日常审单核查业务
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("business/view")
    public SimpleResult inspectBusinessView(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        BaseIdDTO dto = getAndCheckParam(request.getInputStream(), BaseIdDTO.class);
        //获取列表数据
        InspectTaskOpenVO ret = inspectService.inspectBusinessView(dto);
        rtn.setData(ret);
        return rtn;
    }

    /**
     * 获取出口业务数据
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("business/avaiable/list")
    public SimpleResult listInspectBusinessAvailable(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        InspectBusinessAvailableDTO dto = getAndCheckParam(request.getInputStream(), InspectBusinessAvailableDTO.class);
        //获取列表数据
        List<InspectBusinessAvailableVO> retList = inspectService.listInspectBusinessAvailable(dto);
        rtn.setData(retList);
        return rtn;
    }

    /**
     * 获取单证核查类型树
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("tree")
    public SimpleResult inspectTree(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        InspectTreeDTO dto = getAndCheckParam(request.getInputStream(), InspectTreeDTO.class);
        rtn.setData(inspectService.inspectTree(dto));
        return rtn;
    }

    /**
     * 生成日常审单核查任务
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("business/add")
    public SimpleResult inspectBusinessAdd(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        InspectTaskAddDTO dto = getAndCheckParam(request.getInputStream(), InspectTaskAddDTO.class);
        rtn.setData(inspectService.inspectBusinessAdd(dto));
        return rtn;
    }

    /**
     *  日常审单核查批量下达
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("business/release/batch")
    public SimpleResult releaseBatchDailyBusiness(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        DailyReleaseBatchDTO dto = getAndCheckParam(request.getInputStream(), DailyReleaseBatchDTO.class);
        inspectService.releaseBatchDailyBusiness(dto);
        return rtn;
    }

    /**
     *  获取管理系统url
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("glxt/url")
    public SimpleResult getGlxtUrl(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        String ret = inspectService.getGlxtUrl();
        rtn.setData(ret);
        return rtn;
    }

    /**
     *  校验管理系统登录状态
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("glxt/login/check")
    public SimpleResult checkGlxtLoginState(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        String ret = inspectService.checkGlxtLoginState();
        rtn.setData(ret);
        return rtn;
    }

    /**
     * 登录管理系统
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("glxt/login")
    public SimpleResult loginGlxt(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        //获取列表数据
        inspectService.loginGlxt(null);
        return rtn;
    }

    /**
     * 获取操作人员信息
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("czry/info")
    public SimpleResult getCzryInfo(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        //获取列表数据
        rtn.setData(inspectService.getCzryInfo());
        return rtn;
    }

    /**
     * 查询日常审单核查列表
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("query/list")
    public SimpleResult listInspectDaily(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        InspectQueryDTO dto = getAndCheckParam(request.getInputStream(), InspectQueryDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        //获取列表数据
        List<InspectQueryVO> retList = inspectService.listInspectDaily(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 校验操作员是否有日常审单核查权限
     *  @param request
     *  @return
     *  @throws Exception
     */
    @PostMapping("auth")
    public SimpleResult inspectAuth(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        String ret = inspectService.inspectAuth();
        rtn.setData(ret);
        return rtn;
    }

}
