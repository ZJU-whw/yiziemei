package com.tl.web.bjts.shzs.controller;

import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.CollectionUtils;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.domain.ShzsWpSwryProfile;
import com.tl.web.bjts.shzs.model.domain.ShzsWpTaskProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbrwmxVo;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbwpDTO;
import com.tl.web.bjts.shzs.model.dto.dbwp.LoggeQueryDTO;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpResultVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpSlVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.LcswsxVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.SwryVo;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.IDbwpService;
import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * 待办任务委派
 */
@RestController
@RequestMapping("dbwt")
public class DbwpController extends TLBaseController{
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private IDbwpService dbwpService;

    @Autowired
    AppProperties appProperties;

    @Autowired
    CommonServiceImpl commonService;

    @PostMapping("rwsl")
    public SimpleResult rwsl(HttpServletRequest request) throws Exception {
        SimpleResult<DbwpSlVo> rtn = new SimpleResult();

        TlUserProfile currentUser = commonService.getCurrentUser();

        ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());

        DbwpSlVo dbwpSlVo = dbwpService.getDbwpTaskNum(swryProfile);

        rtn.setData(dbwpSlVo);
        return rtn;
    }

    @PostMapping("lcswsx/list")
    public SimpleResult lcswsxList(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult<>();

        DbwpDTO dbwpDTO =getParam(request.getInputStream(), DbwpDTO.class);

        List<LcswsxVo> list;
        if("0".equals(dbwpDTO.getType())){ //数据源用tl_bjts.dm_gt3_config表
            list = dbwpService.selectAllLcswsxList();
        }else { //从在办任务取业务
            TlUserProfile currentUser = commonService.getCurrentUser();
            ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());
            list = dbwpService.selectLcswsxList(swryProfile);
        }

        rtn.setData(list);
        return rtn;
    }


    @PostMapping("dbmx")
    public SimpleResult dbmx(HttpServletRequest request) throws Exception {
        SimpleResult<PageInfo> rtn = new SimpleResult<>();

        DbwpDTO dbwpDTO =getAndCheckParam(request.getInputStream(), DbwpDTO.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());

        rtn.setData(dbwpService.getDbrwmx(dbwpDTO, swryProfile));
        return rtn;
    }


    /**
     * 自动委派查询列表导出
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("dbmx/export")
    public void ckyzshwListExport(String data, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filename = "岗位待办任务查询列表_" + new Date().getTime();
        String reqStr = data.replace("&quot;", "\"");
        DbwpDTO dbwpDTO =getAndCheckParam(reqStr, DbwpDTO.class);
        dbwpDTO.setPageSize(RowBounds.NO_ROW_LIMIT);
        try{
            TlUserProfile currentUser = commonService.getCurrentUser();
            ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());
            PageInfo<List<DbrwmxVo>> pageInfo = dbwpService.getDbrwmx(dbwpDTO, swryProfile);

            super.exportExcel(filename,response, pageInfo.getRows(), DbrwmxVo.class,null);
        }catch (Exception e){
            LOGGER.error("异常：",e);
            String msg = TlUtils.getErrorMsg(e);
            super.processErrorResponse(response,msg);
        }
    }



    /**
     * 委派人员列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("dbswry")
    public SimpleResult dbswry(HttpServletRequest request) throws Exception {
        SimpleResult<List<SwryVo>> rtn = new SimpleResult<>();

        TlUserProfile currentUser = commonService.getCurrentUser();

        ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());

        if(swryProfile==null){
            throw new BusinessException(ResultCode.NO_SHZS_SLG_PERM);
        }

        List<SwryVo> swryVos = dbwpService.getSwryBySwjg(currentUser.getSwjgDm(),swryProfile.getGwxh());

        dbwpService.fillSwryStatus(swryVos);

        rtn.setData(swryVos);
        return rtn;
    }

    /**
     * 更新委派人员状态变更
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("dbswry/update")
    public SimpleResult dbswryUpdate(HttpServletRequest request) throws Exception {
        SimpleResult<List<SwryVo>> rtn = new SimpleResult<>();

        DbwpDTO dbwpDTO =getParam(request.getInputStream(), DbwpDTO.class);
        if (StringUtils.isEmpty(dbwpDTO.getStatus())) {
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }


        TlUserProfile currentUser = commonService.getCurrentUser();
        ShzsWpSwryProfile swryProfile = dbwpService.getWpswry(appProperties.getZjgwdm(), currentUser.getCzryDm());

        dbwpService.dbswryUpdateStatus(dbwpDTO,swryProfile.getGwxh());
        return rtn;
    }

    /**
     * 提交自动委派
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("dbswry/submit")
    public SimpleResult submitDbwp(HttpServletRequest request) throws Exception {
        SimpleResult<List<DbwpResultVo>> rtn = new SimpleResult<>();

        DbwpDTO dbwpDTO =getParam(request.getInputStream(), DbwpDTO.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        if(CollectionUtils.isEmpty(dbwpDTO.getWpMxs())){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        List<DbwpResultVo> retlist = dbwpService.submitAutoDbwp(dbwpDTO.getWpMxs(), commonService.getCurrentUser().getSwjgDm(),currentUser);

        rtn.setData(retlist);

        return rtn;
    }


    @PostMapping("writeback")
    public SimpleResult writeback(HttpServletRequest request) throws Exception {
        SimpleResult<List<DbwpResultVo>> rtn = new SimpleResult<>();

        DbwpDTO dbwpDTO =getParam(request.getInputStream(), DbwpDTO.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        if(CollectionUtils.isEmpty(dbwpDTO.getMxs())){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        dbwpService.writebackWpResult(dbwpDTO.getMxs(),currentUser.getCzryMc());

        return rtn;
    }

    /**
     * 委派日志数据列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("/logger/list")
    public SimpleResult loggerList(HttpServletRequest request) throws Exception {
        SimpleResult<PageInfo> rtn = new SimpleResult<>();

        LoggeQueryDTO loggeQueryDTO =getParam(request.getInputStream(), LoggeQueryDTO.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        TLBaseController.setPageParam(loggeQueryDTO);
        rtn.setData(dealPageInfo(dbwpService.queryLoggerList(loggeQueryDTO, currentUser.getSwjgDm())));
        return rtn;
    }


    /**
     * 委派日志数据列表导出
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("/logger/list/export")
    public void loggerListExprot(String data, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filename = "委派日志数据列表_" + new Date().getTime();
        String reqStr = data.replace("&quot;", "\"");
        LoggeQueryDTO loggeQueryDTO =getAndCheckParam(reqStr, LoggeQueryDTO.class);
        try{
            TlUserProfile currentUser = commonService.getCurrentUser();
            List list = dbwpService.queryLoggerList(loggeQueryDTO, currentUser.getSwjgDm());
            super.exportExcel(filename,response, list, ShzsWpTaskProfile.class,null);
        }catch (Exception e){
            LOGGER.error("异常：",e);
            String msg = TlUtils.getErrorMsg(e);
            super.processErrorResponse(response,msg);
        }
    }


}
