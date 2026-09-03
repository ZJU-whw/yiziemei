package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tl.bjts.sw.conf.FileConfig;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.ColumnTypeVo;
import com.tl.bjts.sw.model.vo.FormulaColumnVo;
import com.tl.bjts.sw.model.vo.VirSwjgVo;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.bjts.sw.service.VirSwjgService;
import com.tl.bjts.sw.utils.JxlExcelUtil;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.StringUtils;
import org.apache.poi.util.LittleEndian;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2019/10/15.
 * @Description:
 */

@RequestMapping("tjbb/mgt")
@RestController
public class TjbbMgtController  extends BaseController{

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    JxlExcelUtil excelUtil;

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    private VirSwjgService virSwjgService;

    @PostMapping("list")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult profileReportAll(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        TjbbTaskDTO param = getParam(request.getInputStream(), TjbbTaskDTO.class);

        PageHelper.startPage(param.getPageNo(), param.getPageSize());
        List<TjbbReportModel> reportModels=tjbbBasisService.getTjbbProfileAll();

        rtn.setData(dealPageInfo(reportModels));

        return rtn;
    }

    @PostMapping("update")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult profileReportUpdate(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        TjbbReportModelDTO model = getAndCheckParam(request.getInputStream(), TjbbReportModelDTO.class);

        tjbbBasisService.saveTjbbReportModel(model);

        return rtn;
    }


    @PostMapping("bbdl")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult bbdlList(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        List<TjbbReportItem> bbdlList = tjbbBasisService.getBbdlList();

        rtn.setData(bbdlList);

        return rtn;
    }


    @PostMapping("column")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult column(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<TjbbColModel> colModels = tjbbBasisService.loadDatabaseColumn(bbdm);

        rtn.setData(colModels);

        return rtn;
    }


    @PostMapping("column/update")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult columnUpdate(HttpServletRequest request) throws IOException {
        SimpleResult<List<TjbbColModelDTO>> rtn = new SimpleResult();

        Type type = new TypeToken<SimpleResult<List<TjbbColModelDTO>>>() {
        }.getType();

        rtn= getParam(request.getInputStream(), type);

        tjbbBasisService.saveTjbbColumnModel(rtn.getData());

        return new SimpleResult();
    }

    @PostMapping("column/gen")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult columnGen(HttpServletRequest request) throws IOException {

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        tjbbBasisService.genTableColumn(bbdm);

        return new SimpleResult();
    }

    @PostMapping("column/del")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult columnDel(HttpServletRequest request) throws IOException {

        TjbbColModel param = getParam(request.getInputStream(), TjbbColModel.class);
        String bbdm = param.getBbdm();
        BigDecimal id = param.getId();
        if(id==null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        tjbbBasisService.delColumn(id,bbdm);

        return new SimpleResult();
    }



    @PostMapping("item")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult itemView(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<TjbbLineItemModel> colModels = tjbbBasisService.loadTjbbItem(bbdm);

        rtn.setData(colModels);

        return rtn;
    }


    @PostMapping("item/update")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult itemUpdate(HttpServletRequest request) throws IOException {
        SimpleResult<List<TjbbLineItemModel>> rtn = new SimpleResult();

        Type type = new TypeToken<SimpleResult<List<TjbbLineItemModel>>>() {
        }.getType();

        rtn= getAndCheckParam(request.getInputStream(), type);

        tjbbBasisService.updateItemAllowupdate(rtn.getData());

        return new SimpleResult();
    }


    @PostMapping("formula")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult formulaView(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<TjbbReportFormula> colModels = tjbbBasisService.loadFormulaList(bbdm);

        rtn.setData(colModels);

        return rtn;
    }


    @PostMapping("formula/update")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult formulaUpdate(HttpServletRequest request) throws IOException {
        SimpleResult<List<TjbbReportFormula>> rtn = new SimpleResult();

        Type type = new TypeToken<SimpleResult<List<TjbbReportFormula>>>() {
        }.getType();

        rtn= getParam(request.getInputStream(), type);

        tjbbBasisService.updateFormulaYxj(rtn.getData());

        return new SimpleResult();
    }


    @PostMapping("formula/list")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult formulaList(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        FormulaColumnVo columnVo = tjbbBasisService.loadFormulaColumnList(bbdm);

        rtn.setData(columnVo);

        return rtn;
    }


    @PostMapping("columntype/list")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult columntype(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(org.apache.commons.lang3.StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<ColumnTypeVo> retList = tjbbBasisService.loadColumnType(bbdm);

        rtn.setData(retList);

        return rtn;
    }


    @PostMapping("formula/save")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult formulaSave(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbReportFormula formula = getParam(request.getInputStream(), TjbbReportFormula.class);

        tjbbBasisService.saveFormula(formula);

        return rtn;
    }

    @PostMapping("formula/del")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult formulaDel(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbReportFormula formula = getParam(request.getInputStream(), TjbbReportFormula.class);

        tjbbBasisService.delFormula(formula.getId());

        return rtn;
    }


    @PostMapping("headTempt/auto")
    @RequiresRoles(logical= Logical.OR,value={"super"})
    public SimpleResult headTemptAuto(@RequestParam("file") MultipartFile file,HttpServletRequest request) throws Exception,IOException {
        SimpleResult rtn=new SimpleResult();

        String bbdm = request.getParameter("bbdm");
        String headCol = request.getParameter("headCol");
        String headLine = request.getParameter("headLine");
        String dataCol = request.getParameter("dataCol");
        String dataLine = request.getParameter("dataLine");
        String endLine = request.getParameter("endLine");
        String type = request.getParameter("type");
        if(StringUtils.isEmpty(bbdm)
                ||StringUtils.isEmpty(headCol)
                ||StringUtils.isEmpty(headLine)
                ||StringUtils.isEmpty(dataCol)
                ||StringUtils.isEmpty(dataLine)
                ||StringUtils.isEmpty(endLine)
                ||StringUtils.isEmpty(type)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        boolean isAddColumn="1".equals(type);

        if(isAddColumn){
            tjbbBasisService.checkTjbbTemplateFirst(bbdm);
        }


        //1.更新统计报表表头和数据坐标
        TjbbReportModel reportModel=new TjbbReportModel();
        reportModel.setBbdm(bbdm);
        reportModel.setExcelcol(new BigDecimal(dataCol));
        reportModel.setExcelrow(new BigDecimal(dataLine));
        reportModel.setHeadcol(new BigDecimal(headCol));
        reportModel.setHeadrow(new BigDecimal(headLine));
        reportModel.setEndrow(new BigDecimal(endLine));
        tjbbBasisService.updateExcelPoint(reportModel);


        tjbbBasisService.processTemplateUpload(file,request,reportModel);

        return rtn;
    }


    @PostMapping("virswjg/list")
    public SimpleResult virswjgList(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        List<VirSwjgVo> virs = virSwjgService.virSwjgList();
        rtn.setData(virs);
        return rtn;
    }

    @PostMapping("virswjg/save")
    public SimpleResult virswjgSave(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        VirSwjgDTO virSwjgDTO = getParam(request.getInputStream(), VirSwjgDTO.class);

        virSwjgService.saveVirSwjg(virSwjgDTO);

        return rtn;
    }

    @PostMapping("virswjg/del")
    public SimpleResult virswjgDel(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        VirSwjgDTO virSwjgDTO = getParam(request.getInputStream(), VirSwjgDTO.class);

        virSwjgService.delVirSwjg(virSwjgDTO);

        return rtn;
    }

    @PostMapping("virswjg/qybz")
    public SimpleResult virswjgQybz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        VirSwjgDTO virSwjgDTO = getParam(request.getInputStream(), VirSwjgDTO.class);

        virSwjgService.saveVirSwjgQybz(virSwjgDTO);

        return rtn;
    }

    @PostMapping("virswjg/update")
    public SimpleResult virswjgUpdate(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        VirSwjgDTO virSwjgDTO = getParam(request.getInputStream(), VirSwjgDTO.class);

        virSwjgService.saveVirSwjgUpdate(virSwjgDTO);

        return rtn;
    }


    @PostMapping("dynamic/profile")
    public SimpleResult dynamicProfile(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        BbdmLocationDTO bbdmLocationDTO = getParam(request.getInputStream(), BbdmLocationDTO.class);

        TjbbReportDynamic tjbbReportDynamic = tjbbBasisService.getTjbbDynamicProfile(bbdmLocationDTO);

        rtn.setData(tjbbReportDynamic);
        return rtn;
    }


    @PostMapping("dynamic/save")
    public SimpleResult saveDynamicProfile(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbReportDynamic tjbbReportDynamic = getParam(request.getInputStream(), TjbbReportDynamic.class);

        tjbbBasisService.saveDynamicProfile(tjbbReportDynamic);

        return rtn;
    }

}
