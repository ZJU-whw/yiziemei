package com.tl.web.bjts.shzs.controller;

/**
 * Created by Neo Lin on 2017/6/19.
 */

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.vo.FkxxWbSbyyVo;
import com.tl.web.bjts.shzs.model.vo.FkxxWbVO;
import com.tl.web.bjts.shzs.service.SbWbService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("sb")
public class SbWbController {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private SbWbService sbWbService;

    @PostMapping("wb")
    public SimpleResult writeBack(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/wb】 params：" + reqStr);
        FkxxWbVO fkxxWbVO = new Gson().fromJson(reqStr, FkxxWbVO.class);
        if (fkxxWbVO.getSbid() == null) {
            LOGGER.error("writeback-缺少必要的参数："+reqStr);
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        sbWbService.writeBackFeedbackInfo(fkxxWbVO);

        return rtn;
    }


    @PostMapping("wb/sbyy")
    public SimpleResult writeBackSbyy(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/wb/sbyy】 params：" + reqStr);
        FkxxWbSbyyVo sbyyVo  = new Gson().fromJson(reqStr, FkxxWbSbyyVo.class);
        if (sbyyVo.getSbid() == null) {
            LOGGER.error("writeback-缺少必要的参数："+reqStr);
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        sbWbService.writeBackSbyyInfo(sbyyVo);

        return rtn;

    }



}
