package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.ldlp.*;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.service.LdlpBaseService;
import com.tl.web.bjts.shzs.service.LdlpService;
import com.tl.web.bjts.shzs.service.LdlpServiceFactory;
import com.tl.web.bjts.shzs.service.SbLcslService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

/**
 * @Description: 关联明细相关接口
 * @Author Neo Lin
 * @Date  2017/12/14 15:27
 */
@RestController
@RequestMapping("sb")
public class SbLdlpController {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
    private final LdlpBaseService ldlpBaseService;

    @Autowired
    SbLcslService sbLcslService;

    @Autowired
    public SbLdlpController(LdlpBaseService ldlpBaseService) {
        this.ldlpBaseService = ldlpBaseService;
    }


    @PostMapping("/ldlp/list")
    public SimpleResult<LdlpListVo> getLdlpNos(HttpServletRequest request) throws Exception {
        SimpleResult<LdlpListVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/ldlp/list】 params：" + reqStr);
        SbidVo sbidVo = new Gson().fromJson(reqStr, SbidVo.class);
        Long sbid = sbidVo.getSbid();
        if(sbid == null){
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }
        String sbywbDm = ldlpBaseService.getSbywbDm(sbid);
        LdlpService ldlpService = (LdlpService)LdlpServiceFactory.getLcslService(sbywbDm);
        LdlpListVo ldlpListVo= ldlpService.getLdlpNos(sbid);
        rtn.setData(ldlpListVo);
        return rtn;
    }

    @PostMapping("/ldlp/view")
    public SimpleResult<LdlpInfoVo> getLdlpInfo(HttpServletRequest request) throws Exception {

        SimpleResult<LdlpInfoVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/ldlp/view】 params：" + reqStr);
        LdlpParamVo ldlpParamVo = new Gson().fromJson(reqStr, LdlpParamVo.class);
        if(ldlpParamVo == null || ldlpParamVo.getSbid() == null || StringUtils.isEmpty(ldlpParamVo.getLdlpNo())){
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }
        Long sbid = ldlpParamVo.getSbid();
        String sbywbDm = ldlpBaseService.getSbywbDm(sbid);
        LdlpService ldlpService = (LdlpService)LdlpServiceFactory.getLcslService(sbywbDm);
        rtn.setData(ldlpService.getLdlpInfo(ldlpParamVo));
        return rtn;
    }



    @PostMapping("fpxx/view")
    public SimpleResult<FpxxVo> getFpxxInfo(HttpServletRequest request) throws Exception {
        SimpleResult<FpxxVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/fpxx/view】 params：" + reqStr);
        FpxxParamVo fpxxParamVo = new Gson().fromJson(reqStr, FpxxParamVo.class);
        if(fpxxParamVo ==null || StringUtils.isEmpty(fpxxParamVo.getZyfpNo()))
        {
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }
        FpxxVo fpxxVo = ldlpBaseService.getZzsFp(fpxxParamVo.getZyfpNo());
        if(fpxxVo == null){
            rtn.setResultCode(ResultCode.DONOT_EXIST_FP_INFO);
            return rtn;
        }
        rtn.setData(fpxxVo);
        return rtn;
    }

    @PostMapping("bgd/view")
    public SimpleResult<BgdVo> getBgdInfo(HttpServletRequest request) throws Exception {
        SimpleResult<BgdVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/bgd/view】 params：" + reqStr);
        BgdParamVo bgdParamVo = new Gson().fromJson(reqStr, BgdParamVo.class);
        if(bgdParamVo ==null || StringUtils.isEmpty(bgdParamVo.getBgdNo()) || bgdParamVo.getSbid() == null)
        {
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }
        BgdVo bgdVo = ldlpBaseService.getBgdInfo(bgdParamVo.getBgdNo(),bgdParamVo.getSbid());
        if(bgdVo == null){
            rtn.setResultCode(ResultCode.DONOT_EXIST_BGD_INFO);
            return rtn;
        }
        rtn.setData(bgdVo);

        return rtn;
    }

    @PostMapping("bgd/view/v2")
    public SimpleResult<BgdMainVO> getBgdInfoV2(HttpServletRequest request) throws Exception {
        SimpleResult<BgdMainVO> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/bgd/view/v2】 params：" + reqStr);
        BgdParamVo bgdParamVo = new Gson().fromJson(reqStr, BgdParamVo.class);
        if(bgdParamVo ==null || StringUtils.isEmpty(bgdParamVo.getBgdNo()) || StringUtils.isEmpty(bgdParamVo.getLcslid())){
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }

        YwblxxVO ywblxxVo = sbLcslService.getYwblxxFormJsxt(bgdParamVo.getLcslid());

        BgdMainVO bgdVo = ldlpBaseService.getBgdInfoV2(bgdParamVo.getBgdNo(),ywblxxVo.getDjxh());
        if(bgdVo == null){
            rtn.setResultCode(ResultCode.DONOT_EXIST_BGD_INFO);
            return rtn;
        }
        rtn.setData(bgdVo);
        return rtn;
    }

}
