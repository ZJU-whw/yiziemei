package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.dto.sbxx.DocQueryDTO;
import com.tl.bjts.sw.model.dto.sbxx.DocViewDTO;
import com.tl.bjts.sw.model.dto.sbxx.SbxxQueryDTO;
import com.tl.bjts.sw.model.vo.sbxx.*;
import com.tl.bjts.sw.service.ISbxxService;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.StringUtils;
import com.tl.common.utils.CommonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 *  申报信息控制器
 */
@RestController
@RequestMapping("sbxx")
public class SbxxController extends TLBaseController{
    private static  final Logger LOGGER = LoggerFactory.getLogger(SbxxController.class);

    @Autowired
    private ISbxxService sbxxService;

    /**
     *  查询申报信息列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("list")
    public SimpleResult listSbxx(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        BaseController proxy=(BaseController) AopContext.currentProxy();
        SbxxQueryDTO dto = getAndCheckParam(request.getInputStream(), SbxxQueryDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        //获取列表数据
        List<SbxxQueryVO> retList = proxy.transferDictCode2Name(sbxxService.listSbxx(dto));
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     *  查询附件列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("doc/list")
    public SimpleResult listSbxxDoc(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        DocQueryDTO dto = getAndCheckParam(request.getInputStream(), DocQueryDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());

        if(StringUtils.isEmpty(dto.getNsrsbh()) && dto.getNsrdzdah()==null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        //获取列表数据
        List<DocQueryVO> retList = sbxxService.listSbxxDoc(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     *  查看附件
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("doc/view")
    public SimpleResult viewSbxxDoc(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();
        DocViewDTO dto = getAndCheckParam(request.getInputStream(), DocViewDTO.class);
        if(StringUtils.isEmpty(dto.getNsrsbh()) && dto.getNsrdzdah()==null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        rtn.setData(sbxxService.viewSbxxDoc(dto));
        return rtn;
    }

    @PostMapping("fpxx/view")
    public SimpleResult<FpxxVo> getFpxxInfo(HttpServletRequest request) throws Exception {
        SimpleResult<FpxxVo> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sbxx/fpxx/view】 params：" + reqStr);
        Map map = new Gson().fromJson(reqStr, Map.class);
        if(map ==null || StringUtils.isEmpty(map.get("zyfpNo"))){
            rtn.setResultCode(ResultCode.REQ_FORMAT_ERROR);
            return rtn;
        }
        FpxxVo fpxxVo = sbxxService.getSzdp((String)map.get("zyfpNo"));
        if(fpxxVo == null){
            throw new BusinessException("不存在的发票信息");
        }
        rtn.setData(fpxxVo);
        return rtn;
    }

    @PostMapping("bgd/view")
    public SimpleResult<BgdMainVO> getBgdInfoV2(HttpServletRequest request) throws Exception {
        SimpleResult<BgdMainVO> rtn = new SimpleResult<>();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/bgd/view/】 params：" + reqStr);

        Map map = new Gson().fromJson(reqStr, Map.class);
        String djxh = (String)map.get("djxh");
        String ckbgdh = (String)map.get("ckbgdh");
        if(StringUtils.isEmpty(djxh) || StringUtils.isEmpty(ckbgdh)){
            rtn.setResultCode(ResultCode.REQ_FORMAT_ERROR);
            return rtn;
        }
        rtn.setData(sbxxService.getBgdInfo(ckbgdh, djxh));
        return rtn;
    }

}
