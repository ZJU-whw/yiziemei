package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.vo.SbztVo;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.SbLcslService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Neo Lin on 2017/6/19.
 */
@RestController
@RequestMapping("sb/lcsl")
public class SbLcslController {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private SbLcslService sbLcslService;
    @Autowired
    private CommonServiceImpl commonService;

    @PostMapping("wb")
    public SimpleResult lcslWriteBack(HttpServletRequest request) throws Exception{

        TlUserProfile user = commonService.getCurrentUser();

        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/lcsl/wb】 params：" + reqStr);
        Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
        String lcslid = (String) param.get("lcslid");
        Double sbid = (Double) param.get("sbid");

        //校验sbid与企业业务是否相符
        String qyhgdm = (String) param.get("qyhgdm");
        String lcswsxdm = (String) param.get("lcswsxdm"); //流程税务事项代码
        if(StringUtils.isEmpty(qyhgdm) || StringUtils.isEmpty(lcswsxdm)) {
            throw new BusinessException(ResultCode.NOT_MATCHED_SBID);
        }else{
            if(sbLcslService.checkBindLcslidBefore(sbid.longValue(),qyhgdm,lcswsxdm) == 0){
                throw new BusinessException(ResultCode.NOT_MATCHED_SBID);
            }
        }
        if (StringUtils.isEmpty(lcslid) || sbid == null) {
            LOGGER.error("lcslWriteBack-缺少必要的参数："+reqStr);
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        sbLcslService.writeBackLcslid(sbid.longValue(), lcslid,user.getCzryDm());
        return rtn;
    }

    @Deprecated
    @PostMapping("getsbid")
    public SimpleResult<Map> lcslGetSbid(HttpServletRequest request) throws Exception{
        SimpleResult<Map> rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/lcsl/getsbid】 params：" + reqStr);
        Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
        String lcslid = (String) param.get("lcslid");
        if (StringUtils.isEmpty(lcslid) || "null".equals(lcslid)) {
            LOGGER.error("lcslGetSbid-缺少必要的参数:"+reqStr);
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        // 根据流程受理id获取申报id
        Long sbid = sbLcslService.getSbid(lcslid);
        Map<String, Long> rtnData = new HashMap<>();
        rtnData.put("sbid", sbid);
        rtn.setData(rtnData);
        return rtn;
    }

    @PostMapping("check")
    public SimpleResult<SbztVo> lcslCheck(HttpServletRequest request) throws Exception {
        SimpleResult<SbztVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/lcsl/check】 params：" + reqStr);
        Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
        String sbid = (String) param.get("sbid");
        if(StringUtils.isEmpty(sbid)){
            LOGGER.error("lcslCheck-缺少必要的参数:"+reqStr);
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        String result = sbLcslService.checkLcslid(Long.valueOf(sbid));
        if(!StringUtils.isEmpty(result)){
            rtn.setResultCode(ResultCode.APP_BIZ_LCSLID_ERROR);
            SbztVo vo = new SbztVo();
            vo.setSbzt(result);
            rtn.setData(vo);
        }
        return rtn;
    }
}
