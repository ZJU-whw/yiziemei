package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.tl.bjts.sw.annotation.TLParam;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.YjCsBmdSubModel;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.dto.QspjdjDTO;
import com.tl.bjts.sw.model.dto.WmMgkaDTO;
import com.tl.bjts.sw.model.dto.YchdDTO;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.model.vo.yjzb.YjzbListVO;
import com.tl.bjts.sw.model.vo.yjzb.ZbSelectVO;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.ExportService;
import com.tl.bjts.sw.service.YjService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import com.tl.bjts.sw.model.dto.YjcodeQybzDTO;
import com.tl.bjts.sw.model.vo.YjCsBmdModelVo;
import com.tl.bjts.sw.model.vo.YjDicYjzbModelVo;
import com.tl.bjts.sw.model.vo.YjPfxxVO;
import com.tl.common.ext.model.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2019/8/30.
 * @Description:
 */
@RequestMapping("yj")
@RestController
public class YjController  extends TLBaseController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ExportService exportExcelService;

    @Autowired
    private YjService yjService;

    @Autowired
    private CommonServiceImpl commonService;

    /**
     * 外贸免退税敏感口岸信息库维护（查询）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("wmmgka")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult wmmgka(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        WmMgkaDTO dto =getParam(request.getInputStream(), WmMgkaDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<MgkaWmVo> retList=yjService.wmmgka(dto);
        rtn.setData(dealPageInfo(retList));

        return rtn;
    }
    @PostMapping("wmmgka/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult wmmmgkaup(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        MgkaWmVo dto =getAndCheckParam(request.getInputStream(), MgkaWmVo.class);
        yjService.saveMgka(dto);
        return rtn;
    }
    @PostMapping("wmmgka/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult wmmmgkadel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        IdsDTO dto =getParam(request.getInputStream(), IdsDTO.class);
        if(dto.getIds().size()==0){
            throw new BusinessException(BusinessMsgCons.NO_EMPTY);
        }
        yjService.wmmmgkadel(dto);
        return rtn;
    }
    /**
     * 敏感商品信息库维护（查询）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("mgsp")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult mgsp(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        WmMgkaDTO dto =getParam(request.getInputStream(), WmMgkaDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<MgspVo> retList=yjService.mgsp(dto);
        rtn.setData(dealPageInfo(retList));

        return rtn;
    }

    @PostMapping("mgsp/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult mgspup(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        MgspVo dto =getAndCheckParam(request.getInputStream(), MgspVo.class);
        yjService.mgspup(dto);
        return rtn;
    }
    @PostMapping("mgsp/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult mgspdel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        IdsDTO dto =getParam(request.getInputStream(), IdsDTO.class);
        if(dto.getIds().size()==0){
            throw new BusinessException(BusinessMsgCons.NO_EMPTY);
        }
        yjService.mgspdel(dto);
        return rtn;
    }

    /**
     * 异常供货企业信息库维护（查询）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("ycghqy")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ycghqy(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        WmMgkaDTO dto =getParam(request.getInputStream(), WmMgkaDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YcghVo> retList=yjService.ycghqy(dto);
        rtn.setData(dealPageInfo(retList));

        return rtn;
    }
    @PostMapping("ycghqy/update")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ycghqyup(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YcghVo dto =getAndCheckParam(request.getInputStream(), YcghVo.class);
        yjService.ycghqyup(dto);
        return rtn;
    }
    @PostMapping("ycghqy/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ycghqydel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        IdsDTO dto =getParam(request.getInputStream(), IdsDTO.class);
        if(dto.getIds().size()==0){
            throw new BusinessException(BusinessMsgCons.NO_EMPTY);
        }
        yjService.ycghqydel(dto);
        return rtn;
    }
    /**
     * 生产免抵退常见口岸库查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("scqycjka")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult scqycjka(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        WmMgkaDTO dto =getParam(request.getInputStream(), WmMgkaDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<MGkaScVo> retList=yjService.scqycjka(dto);
        rtn.setData(dealPageInfo(retList));

        return rtn;
    }

    @PostMapping("scqycjka/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult scqycjkaup(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        MGkaScVo dto =getAndCheckParam(request.getInputStream(), MGkaScVo.class);
        yjService.scqycjkaup(dto);
        return rtn;
    }
    @PostMapping("scqycjka/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult scqycjkadel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        IdsDTO dto =getParam(request.getInputStream(), IdsDTO.class);
        if(dto.getIds().size()==0){
            throw new BusinessException(BusinessMsgCons.NO_EMPTY);
        }
        yjService.scqycjkadel(dto);
        return rtn;
    }

    /**
     * 异常函调信息库查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("ychd")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ychd(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YchdDTO dto = getParam(request.getInputStream(), YchdDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YchdVo> retList = yjService.ychd(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    @PostMapping("ychd/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ychdup(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YchdVo dto =getAndCheckParam(request.getInputStream(), YchdVo.class);
        yjService.ychdup(dto);
        return rtn;
    }
    @PostMapping("ychd/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult ychddel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        IdsDTO dto =getParam(request.getInputStream(), IdsDTO.class);
        if(dto.getIds().size()==0){
            throw new BusinessException(BusinessMsgCons.NO_EMPTY);
        }
        yjService.ychddel(dto);
        return rtn;
    }


    @PostMapping("profile")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profile(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();


        TsjgDTO dto =getParam(request.getInputStream(), TsjgDTO.class);
        PageInfo pageInfo=yjService.queryYjDicList(dto);

        rtn.setData(pageInfo);
        return rtn;

    }


    @PostMapping("profile/qybz")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileQybz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjcodeQybzDTO dto =getAndCheckParam(request.getInputStream(), YjcodeQybzDTO.class);
        yjService.updateYjProfileQybz(dto);

        return rtn;

    }


    @PostMapping("profile/mx")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileMxYjzb(HttpServletRequest request) throws IOException {
        YjzbListVO vo = new YjzbListVO();
        SimpleResult rtn = new SimpleResult();

        IdDTO param = getParam(request.getInputStream(), IdDTO.class);
        String yjcode = param.getYjcode();
        if(StringUtils.isBlank(yjcode)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        PageHelper.startPage(param.getPageNo(), param.getPageSize());
        //全省默认
        List<YjDicYjzbModelVo> qsmrList=yjService.queryYjzbsQsmr(yjcode);
        vo.setQsmr(dealPageInfo(qsmrList));

        PageHelper.startPage(param.getPageNo(), param.getPageSize());
        //用户设置的
        List<YjDicYjzbModelVo> yhszList=yjService.queryYjzbs(yjcode);
        if(yhszList!=null){
            vo.setYhsz(dealPageInfo(yhszList));
        }
        rtn.setData(vo);
        return rtn;
    }

    @PostMapping("profile/mx/delete")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileMxDelete(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map paramMap  = getParam(request.getInputStream(), Map.class);
        String swjgdm = (String)paramMap.get("swjgdm");
        if(StringUtils.isBlank(swjgdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        String zbcode = (String)paramMap.get("zbcode");
        if(StringUtils.isBlank(zbcode)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        //根据税务机关代码和指标代码删除预警参数指标的相关信息
        yjService.deleteYjzbSwjg(swjgdm,zbcode);
        return rtn;
    }

    @PostMapping("profile/mx/getZbSelect")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileMxZbSelect(HttpServletRequest request) throws IOException {
        YjzbListVO vo = new YjzbListVO();
        SimpleResult rtn = new SimpleResult();

        IdDTO param = getParam(request.getInputStream(), IdDTO.class);
        String yjcode = param.getYjcode();
        if(StringUtils.isBlank(yjcode)){
            throw new BusinessException("预警代码不能为空");
        }
        List<ZbSelectVO> list=yjService.getZbSelect(yjcode);
        rtn.setData(list);
        return rtn;
    }

    @PostMapping("profile/mx/ds")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileMxYjzbDs(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        IdDTO param = getParam(request.getInputStream(), IdDTO.class);
        String yjcode = param.getYjcode();
        if(StringUtils.isBlank(yjcode)){
            throw new BusinessException("预警代码不能为空");
        }
        String zbcode = param.getZbcode();
        PageHelper.startPage(param.getPageNo(), param.getPageSize());
        List<YjDicYjzbModelVo> list=yjService.queryYjzbsDs(yjcode,zbcode);
        rtn.setData(dealPageInfo(list));
        return rtn;
    }

    @PostMapping("profile/mx/qybz")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profileMxQybz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjzbcodeQybzDTO dto =getAndCheckParam(request.getInputStream(), YjzbcodeQybzDTO.class);

        yjService.updateYjzbQybz(dto);

        return rtn;

    }

    @PostMapping("bmd")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmd(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjBmdDTO dto =getParam(request.getInputStream(), YjBmdDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjCsBmdModelVo> list =yjService.queryYjBmds(dto);

        rtn.setData(dealPageInfo(list));
        return rtn;

    }


    @PostMapping("bmd/add")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdAdd(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjCsBmdModelVo obj =getAndCheckParam(request.getInputStream(), YjCsBmdModelVo.class);

        yjService.addYjBmd(obj);

        return rtn;

    }

    @PostMapping("bmd/add/check")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdAddCheck(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjCsBmdModelVo obj =getParam(request.getInputStream(), YjCsBmdModelVo.class);

        //校验通过返回名称
        String nsrmc = yjService.addCheckYjBmd(obj);

        rtn.setData(nsrmc);

        return rtn;

    }


    @PostMapping("bmd/excel")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void exportExcel(String data, HttpServletRequest request,HttpServletResponse response) throws Exception {
        String filename="预警白名单企业";
        String reqStr = data.replace("&quot;", "\"");
        YjBmdDTO dto =getParam(reqStr, YjBmdDTO.class);
        List<YjCsBmdModelVo> retList=yjService.queryYjBmds(dto);
        try {
            exportExcelService.exportOrderExcel(filename,response, retList,YjCsBmdModelVo.class,null);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }


    @PostMapping("bmd/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdDel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String id = param.get("id");
        if(StringUtils.isBlank(id)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        yjService.delYjBmd(Long.valueOf(id));

        return rtn;

    }

    @PostMapping("bmdsub/view")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdSubView(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        IdDTO obj =getParam(request.getInputStream(), IdDTO.class);

        PageHelper.startPage(obj.getPageNo(), obj.getPageSize());
        List<YjCsBmdSubModel> subModels= yjService.viewYjBmdSub(obj.getId());

        rtn.setData(dealPageInfo(subModels));
        return rtn;

    }


    @PostMapping("bmdsub/add")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdSubAdd(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        YjCsBmdSubModel obj =getAndCheckParam(request.getInputStream(), YjCsBmdSubModel.class);

        yjService.addYjBmdSub(obj);

        return rtn;

    }


    @PostMapping("bmdsub/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult bmdSubDel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String id = param.get("bsid");
        if(StringUtils.isBlank(id)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        yjService.delYjBmdSub(Long.valueOf(id));

        return rtn;

    }


    /**
     * 全省出口商品平均单价查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("cksppjj")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult cksppjj(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        QspjdjDTO dto =getParam(request.getInputStream(), QspjdjDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<PjdjVo> retList=yjService.cksppjj(dto);
        rtn.setData(dealPageInfo(retList));

        return rtn;
    }

    /*
     * @Description: 预警综合信息查询
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("zhcx/list")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult listZhcx(HttpServletRequest request) throws IOException, ParseException {
        SimpleResult<PageInfo> rtn = new SimpleResult();
        YjZhcxListDTO dto =getAndCheckParam(request.getInputStream(), YjZhcxListDTO.class);
        //查询明细列表信息
        List<YjZhcxListVO> retList = yjService.getYjZhcxList(dto);
        //查询合计信息
        Map retSum = yjService.getYjZhcxSum(dto);

        rtn.setData(dealPageInfoIncludeSum(retList,retSum));
        return rtn;
    }

    /*
     * @Description: 导出预警综合信息查询列表
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("zhcx/export")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void zhcx(String data, HttpServletResponse response,@TLParam List<String> exual) throws Exception {
        try {
            String reqStr = data.replace("&quot;", "\"");
            YjZhcxListDTO dto = getParam(reqStr, YjZhcxListDTO.class);
            yjService.exportYjZhcxList(response, dto,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }


    /*
     * @Description:查询企业基础评分信息
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("pfxx/view")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult viewPfxx(HttpServletRequest request) throws IOException {
        SimpleResult<YjPfxxVO> rtn = new SimpleResult<>();

        NsrsbhDTO dto =getAndCheckParam(request.getInputStream(), NsrsbhDTO.class);
        rtn.setData(yjService.getYjPfxx(dto.getNsrsbh()));
        return rtn;
    }


    /*
     * @Description: 获取预警评分信息列表
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("pfxx/list")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult listPfxx(HttpServletRequest request) throws IOException {
        SimpleResult<PageInfo> rtn = new SimpleResult();

        YjPfxxListDTO dto =getAndCheckParam(request.getInputStream(), YjPfxxListDTO.class);
        rtn.setData(dealPageInfo(yjService.getYjPfxxList(dto)));
        return rtn;
    }


    @PostMapping("pfxx/reset")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult resetPfxx(HttpServletRequest request) throws IOException {
        SimpleResult<PageInfo> rtn = new SimpleResult();

        YjPfxxListDTO dto =getParam(request.getInputStream(), YjPfxxListDTO.class);

        yjService.resetPfxx(dto.getNsrsbh());

        return rtn;
    }

    /*
     * @Description: 评分信息导出
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("pfxx/export")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void pfxx(String data, HttpServletResponse response, @TLParam List<String> exual) throws Exception {
        try {
            String reqStr = data.replace("&quot;", "\"");
            YjPfxxListDTO dto = getParam(reqStr, YjPfxxListDTO.class);
            yjService.exportYjPfxxList(response, dto,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

    /*
     * @Description: 查找预警指标
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("yjzb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult yjzb(String data, HttpServletResponse response) throws Exception {

        SimpleResult<List<YjzbcxVo>> rtn = new SimpleResult();
        List<YjzbcxVo> list = yjService.findyjzb();
        rtn.setData(list);
        return rtn;
    }

    /*
     * @Description: 异常供货企业模板导入
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("ycghqy/import")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void ycghqyimport(@RequestParam("file") MultipartFile file, HttpServletResponse response) throws Exception {
        SimpleResult rtn=new SimpleResult();
        try {
            List<YcghMbVo> allData = checkAndGetExcel(file, YcghMbVo.class);
            yjService.importYcghqy(allData);
        }catch (BusinessException e){
            rtn.setMsg(e.getMsg());
            rtn.setCode(e.getCode());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(new Gson().toJson(rtn));
    }
    /*
     * @Description: 敏感商品模板导入
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("mgsp/import")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void mgspimport(@RequestParam("file") MultipartFile file, HttpServletResponse response) throws Exception {
        SimpleResult rtn=new SimpleResult();
        try {
            List<MgspMbVo> allData = checkAndGetExcel(file, MgspMbVo.class);
            yjService.importMgsp(allData);
        }catch (BusinessException e){
            rtn.setMsg(e.getMsg());
            rtn.setCode(e.getCode());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(new Gson().toJson(rtn));
    }

    /*
     * @Description: 敏感商品模板导入
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("wmmgka/import")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void wmmgkaimport(@RequestParam("file") MultipartFile file, HttpServletResponse response) throws Exception {
        SimpleResult rtn=new SimpleResult();
        try {
        List<MgkaWmMbVo> allData=checkAndGetExcel(file,MgkaWmMbVo.class);
        yjService.importWmmgka(allData);
        }catch (BusinessException e){
            rtn.setMsg(e.getMsg());
            rtn.setCode(e.getCode());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(new Gson().toJson(rtn));
    }

    /**
     * 行政区域对照表查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("xzqh")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult xzqh(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjHghydDTO dto = getParam(request.getInputStream(), YjHghydDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjHghydVO> retList = yjService.queryYjXzqhList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 行政区域字典接口（下拉用）
     * @return 区域代码和名称列表
     */
    @PostMapping("xzqh/dic")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult xzqhDic() {
        SimpleResult rtn = new SimpleResult();
        List<YjHghydVO> retList = yjService.queryYjXzqhDicList();
        rtn.setData(retList);
        return rtn;
    }



    /**
     * 海关货源地区域对照表查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("hghyd")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult hghyd(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjHghydDTO dto = getParam(request.getInputStream(), YjHghydDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjHghydVO> retList = yjService.queryYjHghydList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 海关口岸区域对照表查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("hgcode")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult hgcode(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjHgcodeDTO dto = getParam(request.getInputStream(), YjHgcodeDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjHgcodeVO> retList = yjService.queryYjHgcodeList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 风险报关行信息查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("fxbgh")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult fxbgh(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjCsFxbghDTO dto = getParam(request.getInputStream(), YjCsFxbghDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjCsFxbghVO> retList = yjService.queryYjCsFxbghList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 风险报关行信息导出
     * @param data 查询参数
     * @param response
     * @throws Exception
     */
    @PostMapping("fxbgh/export")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void fxbghExport(String data, HttpServletResponse response) throws Exception {
        String filename = "风险报关行信息";
        String reqStr = data.replace("&quot;", "\"");
        YjCsFxbghDTO dto = getParam(reqStr, YjCsFxbghDTO.class);
        try {
            List<YjCsFxbghVO> retList = yjService.queryYjCsFxbghList(dto);
            exportExcelService.exportOrderExcel(filename, response, retList, YjCsFxbghVO.class, null);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

    /**
     * 最终目的国区域对照表查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("gbcode")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult gbcode(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjGbcodeDTO dto = getParam(request.getInputStream(), YjGbcodeDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjGbcodeVO> retList = yjService.queryYjGbcodeList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 目的国区域字典接口（下拉用）
     * @return 国家区域代码和名称列表
     */
    @PostMapping("gbcode/dic")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult gbcodeDic() {
        SimpleResult rtn = new SimpleResult();
        List<YjGbcodeVO> retList = yjService.queryYjGbcodeDicList();
        rtn.setData(retList);
        return rtn;
    }

    /**
     * 出口链路风险等级参数表查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("fxdjsz")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult fxdjsz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjFxdjszDTO dto = getParam(request.getInputStream(), YjFxdjszDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjFxdjszVO> retList = yjService.queryYjFxdjszList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 出口链路异常分析模型（外贸）查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("wmll")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult wmll(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjWmllDTO dto = getParam(request.getInputStream(), YjWmllDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjWmllVO> retList = yjService.queryYjWmllList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 保存出口链路风险等级调整（外贸）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("wmll/fxdjtz")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult saveWmllFxdjtz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjWmllFxdjtzDTO dto = getAndCheckParam(request.getInputStream(), YjWmllFxdjtzDTO.class);
        yjService.saveYjWmllFxdjtz(dto);
        return rtn;
    }

    /**
     * 每美元利润率分析结果查询
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("mmyll")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult mmyll(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjMmyllDTO dto = getParam(request.getInputStream(), YjMmyllDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjMmyllVO> retList=yjService.queryYjMmyllList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    // ==================== 报关单关注信息管理 ====================


    /**
     * 查询未申报/审核中关注信息列表（GCB表）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/list/gcb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult listBgdgzxxGcb(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxDTO dto = getParam(request.getInputStream(), YjBgdgzxxDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        dto.setSwjgdm(commonService.getQxdm());
        List<YjBgdgzxxVO> retList = yjService.getYjBgdgzxxListGcb(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    /**
     * 查询审核结束关注信息列表（JGB表）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/list/jgb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult listBgdgzxxJgb(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxDTO dto = getParam(request.getInputStream(), YjBgdgzxxDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        dto.setSwjgdm(commonService.getQxdm());
        List<YjBgdgzxxVO> retList = yjService.getYjBgdgzxxListJgb(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }


    /**
     * 根据企业税号和报关单号查询报关单详情（自动带出信息）
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/detail/nsrsbh")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult getBgdgzxxDetailByNsrsbh(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        Map<String, String> paramMap = getParam(request.getInputStream(), Map.class);
        String nsrsbh = paramMap.get("nsrsbh");
        String ckbgdh = paramMap.get("ckbgdh");
        if (StringUtils.isBlank(nsrsbh) || StringUtils.isBlank(ckbgdh)) {
            throw new BusinessException("企业税号和报关单号不能为空");
        }
        YjBgdgzxxDetailVO detail = yjService.getYjBgdgzxxDetailByNsrsbh(nsrsbh, ckbgdh,commonService.getQxdm());
        rtn.setData(detail);
        return rtn;
    }

    /**
     * 新增报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/add")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult addBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxAddDTO dto = getAndCheckParam(request.getInputStream(), YjBgdgzxxAddDTO.class);
        yjService.addYjBgdgzxx(dto);
        return rtn;
    }

    /**
     * 编辑报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult updateBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxAddDTO dto = getAndCheckParam(request.getInputStream(), YjBgdgzxxAddDTO.class);
        yjService.updateYjBgdgzxx(dto);
        return rtn;
    }

    /**
     * 删除报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bgdgzxx/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult delBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        Map<String, String> paramMap = getParam(request.getInputStream(), Map.class);
        String djxh = paramMap.get("djxh");
        String ckbgdh = paramMap.get("ckbgdh");
        if (StringUtils.isBlank(djxh) || StringUtils.isBlank(ckbgdh)) {
            throw new BusinessException("金三登记序号和报关单号不能为空");
        }
        yjService.deleteYjBgdgzxx(djxh, ckbgdh);
        return rtn;
    }

}
