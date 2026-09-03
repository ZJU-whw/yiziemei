package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.conf.FileConfig;
import com.tl.bjts.sw.dao.TjbbReportItemMapper;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.SwjgModel;
import com.tl.bjts.sw.model.TjbbCzLogCode;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.bjts.sw.service.TjbbSpecService;
import com.tl.bjts.sw.service.VirSwjgService;
import com.tl.bjts.sw.utils.JxlExcelUtil;
import com.tl.bjts.sw.utils.PoiExcelUtil;
import com.tl.bjts.sw.utils.TlConst;
import com.tl.bjts.sw.utils.TlDateUtils;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.TlBeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author：Mamf
 * @Date: 2019/9/16.
 * @Description:
 */
@RequestMapping("tjbb")
@RestController
public class TjbbController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private final String callback= "<script>top.tools.info(\"%s\");</script>";

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    AppProperties appProperties;

    @Autowired
    PoiExcelUtil poiExcelUtil;

    @Autowired
    VirSwjgService virSwjgService;

    @Autowired
    TjbbSpecService tjbbSpecService;

    @Autowired
    TjbbReportItemMapper tjbbReportItemMapper;


    @PostMapping("menu")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult menu(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        MenuVo menuVo = tjbbBasisService.loadMenu();

        rtn.setData(menuVo.getMenuList());

        return rtn;
    }

    @PostMapping("profile/header")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult header(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        HeadLineVo headLineVo=tjbbBasisService.getHeadLine(bbdm);

        rtn.setData(headLineVo);

        return rtn;
    }


    @PostMapping("profile")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult profile(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        if(StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        TjbbReportModel model=tjbbBasisService.getTjbbProfile(bbdm);

        rtn.setData(model);

        return rtn;
    }

    @PostMapping("dynamic/location")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult dynamicLocation(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        Map<String,String> param = getParam(request.getInputStream(), Map.class);
        String bbdm = param.get("bbdm");
        String type = param.get("type");
        if(StringUtils.isBlank(bbdm) || StringUtils.isBlank(type)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<LocationVo> list=tjbbBasisService.getDynamicLocations(bbdm,type);

        rtn.setData(list);

        return rtn;
    }



    @PostMapping("loaddata")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult loaddata(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO param = getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdm = param.getBbdm();
        String ssny = param.getSsny();
        if(StringUtils.isBlank(bbdm) || StringUtils.isBlank(ssny)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        String swjgdm = param.getSwjgdm();

        String curSwjgdm = commonService.getCurrentUser().getSwjgDm();
        List list=null;
        if(StringUtils.isBlank(swjgdm) || swjgdm.equals(curSwjgdm)){
            list = tjbbBasisService.loaddata(bbdm,ssny,param);
        }else {
            list = tjbbBasisService.loaddataBySwjgdm(bbdm,ssny,swjgdm,param);
        }

        rtn.setData(dealPageInfo(list));

        return rtn;
    }

    @PostMapping("loaddata/dynamic")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult<PageInfo> loaddataDynamic(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO param = getParam(request.getInputStream(), TjbbTaskDTO.class);


        PageInfo data = getDynamicData(param, param.getSwjgdm());
        Map map =new HashMap();
        map.put("title",processTitle((List<LinkedHashMap>)data.getRows()));
        map.put("list",data);
        rtn.setData(map);

        return rtn;
    }

    private List processTitle(List<LinkedHashMap> rows) {
        LinkedHashMap linkedHashMap = rows.get(0);
        List<String> titles = new ArrayList<>();
        for (Object o : linkedHashMap.keySet()) {
            if("ROW_ID".equals(String.valueOf(o))){
                continue;
            }
            titles.add(String.valueOf(o));
        }

        return titles;
    }


    private PageInfo getDynamicData(TjbbTaskDTO param,String swjgdm){
        String bbdm = param.getBbdm();
        String ssny = param.getSsny();
        if(StringUtils.isBlank(bbdm) || StringUtils.isBlank(param.getLocation())){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        String curSwjgdm = commonService.getCurrentUser().getSwjgDm();
        if(!StringUtils.isBlank(swjgdm) && !swjgdm.equals(curSwjgdm)){
            curSwjgdm = swjgdm;
        }

        List list = tjbbBasisService.loaddataDynamicSqlData(param.getBblc(),bbdm,ssny,param.getLocation(),curSwjgdm,param.getPageNo(),param.getPageSize());

        return dealPageInfo(list);
    }


    @PostMapping("saveDynamicExcel")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void saveDynamicExcel(String data,HttpServletRequest request, HttpServletResponse response) throws IOException {

        String reqStr = data.replace("&quot;", "\"");
        TjbbTaskDTO param = getParam(reqStr, TjbbTaskDTO.class);

        PageInfo info = getDynamicData(param,param.getSwjgdm());
        List<LinkedHashMap> rows = (List<LinkedHashMap>) info.getRows();

        LinkedHashMap<String, String> keyMap =new LinkedHashMap<>();
        for (Object o : rows.get(0).keySet()) {
            if("ROW_ID".equals(o.toString())){
                continue;
            }
            keyMap.put(o.toString(),o.toString());
        }


        String filename = TlDateUtils.format(new Date(),"yyyyMMddHHmmss");
        String[] sheetName={"Sheet1"};


        Map<String,List<LinkedHashMap>> dataMap =new HashMap<>();
        dataMap.put(sheetName[0],rows);


        ServletOutputStream out = response.getOutputStream();

        try {
            JxlExcelUtil.getExcelStream4MapData(response, out, sheetName,filename,keyMap, dataMap);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            response.setContentType("text/html");
            out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                    .getBytes("UTF-8"),"iso8859-1"));
            out.flush();
            out.close();
        }
    }

    @PostMapping("saveExcel")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void saveExcel(String data,HttpServletRequest request, HttpServletResponse response) throws IOException {

        if (data == null) {
            throw  new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        String reqStr = data.replace("&quot;","\"");
        Map<String,String> pramMap = new Gson().fromJson(reqStr,Map.class);

        String bbdm = pramMap.get("bbdm");
        String swjgdm = pramMap.get("swjgdm");
        String ssny = pramMap.get("ssny");
        String type = pramMap.get("type");

        if(StringUtils.isBlank(bbdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        String point= tjbbBasisService.getExcelDataPoint(bbdm);

        String[] split = point.split(",");
        int col = Integer.parseInt(split[0]);
        int row = Integer.parseInt(split[1]);

        int headCol = Integer.parseInt(split[2]);
        int headRow = Integer.parseInt(split[3]);
        int endRow = Integer.parseInt(split[4]);
        // 填表信息
        TbxxExtDTO extDTO=new TbxxExtDTO();
        // 制表信息
        TjbbTbxx zbxx = tjbbBasisService.getZbxx(bbdm);
        if(zbxx==null && bbdm.startsWith("B")){
            //获取用户上报信息
            TjbbTaskSubModel subModel = tjbbBasisService.getHzDate(bbdm, swjgdm, ssny);
            zbxx=getTjbbZbxx(swjgdm,bbdm,subModel.getHztime(),subModel.getHzr(),ssny);

            TlBeanUtils.copyPropertiesIgnoreNull(zbxx,extDTO);
        }


        String bbmc=split[5];

        String filename =bbmc+"-"+ssny;
        String sheetName="Sheet1";
        String templateName=bbdm+".xls";

        List<Map> dataList;
        String curSwjgdm = commonService.getCurrentUser().getSwjgDm();
        if(StringUtils.isBlank(swjgdm) || swjgdm.equals(curSwjgdm)){
            dataList = tjbbBasisService.loaddata(bbdm,ssny,null);
        }else {
            dataList = tjbbBasisService.loaddataBySwjgdm(bbdm,ssny,swjgdm,null);
        }




        List<TjbbColModel> columns = tjbbBasisService.getColumns(bbdm);

        List<String> fnames = new ArrayList<>();


        for(TjbbColModel model:columns){
            if(StringUtils.isBlank(type) || "1".equals(type)){
                fnames.add(model.getFname());
            }else{
                fnames.add(model.getFname()+"_HZ");
            }
        }

//        String templatePath = "template" + File.separator + templateName ;
//        ClassPathResource resource = new ClassPathResource(templatePath);

        File file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xls");
        if(file==null){
            file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xlsx");
        }
        InputStream stream = new FileInputStream(file);


        // 设置调用的方法名
        Map<String, String> methodMap = new HashMap<String, String>();
        // 方法可以在JxlExcelUtils定义，会根据名字进行调用，可以用来处理一些数据，如decode之类的功能
        //methodMap.put("lx", "lxConverter");
        ServletOutputStream out = response.getOutputStream();

//        if (null != dataList
//                && dataList.size() > 0) {


        if(bbdm.startsWith("E")){//这里目前只针对E01001处理，后续拓展其他统计分析报表与修改填充参数
            extDTO.setBbdm(bbdm);
            extDTO.setSsny(ssny);
            String swjgDm = commonService.getCurrentUser().getSwjgDm();
            extDTO.setSwjgmc(commonService.getSwjgMc(swjgDm).getSwjgmc());
        }

            try {
                poiExcelUtil.exportTemplateExcelStream4Poi(response, out,stream, filename, sheetName,fnames,
                        dataList, methodMap,col,row,headCol,headRow,endRow,extDTO);
            } catch (Exception e) {
                logger.error(e.getMessage(),e);
                response.setContentType("text/html");
                out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                        .getBytes("UTF-8"),"iso8859-1"));
                out.flush();
                out.close();
            }
//        }else{
//            logger.info(BusinessMsgCons.CONTROLLER_REPORTEXCEL_DATAEMPTY);
//            response.setContentType("text/html");
//            out.print(new String(getJsCallback("", "当前没有需要导出的数据")
//                    .getBytes("UTF-8"),"iso8859-1"));
//            out.flush();
//            out.close();
//        }

    }



    @PostMapping("saveSuitExcel")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void saveSuitExcel(String data,HttpServletRequest request, HttpServletResponse response) throws IOException {

        if (data == null) {
            throw  new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        String reqStr = data.replace("&quot;","\"");
        Map<String,String> pramMap = new Gson().fromJson(reqStr,Map.class);

        String bbdldm = pramMap.get("bbdldm");
        String ssny = pramMap.get("ssny");
        String type = pramMap.get("type");
        String swjgdm = pramMap.get("swjgdm");

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        List<SuitExcelDTO> suitExcelDTOS=tjbbBasisService.getBbdmBYdl(bbdldm);

        int kk=0;
        String curSwjgdm = commonService.getCurrentUser().getSwjgDm();
        for(SuitExcelDTO suitExcelDTO:suitExcelDTOS){

            suitExcelDTO.setSsny(ssny);

            String bbdm = suitExcelDTO.getBbdm();

            //非总局退税月报表，每一个sheet页都必须填充，总局月报表因为有套表间格式链接定义，除了首页无需填充
            if(kk==0 || !"B01".equals(bbdldm)){
                TjbbTaskSubModel subModel = tjbbBasisService.getHzDate(bbdm, swjgdm, ssny);
                //设置制表信息
                TjbbTbxx tjbbZbxx = getTjbbZbxx(swjgdm, bbdm, subModel.getHztime(), subModel.getHzr(),ssny);
                suitExcelDTO.setZbxx(tjbbZbxx);
            }
            kk++;

            List<Map> dataList;

            if(StringUtils.isBlank(swjgdm) || swjgdm.equals(curSwjgdm)){
                dataList = tjbbBasisService.loaddata(bbdm,ssny,null);
            }else {
                dataList = tjbbBasisService.loaddataBySwjgdm(bbdm,ssny,swjgdm,null);
            }
            suitExcelDTO.setListContent(dataList);


            List<TjbbColModel> columns = tjbbBasisService.getColumns(bbdm);
            List<String> fnames = new ArrayList<>();
            for(TjbbColModel model:columns){
                if(StringUtils.isBlank(type) || "1".equals(type)){
                    fnames.add(model.getFname());
                }else{
                    fnames.add(model.getFname()+"_HZ");
                }
            }
            suitExcelDTO.setFnameCols(fnames);


            suitExcelDTO.setMethodMap(new HashMap<>());


        }

        String filename ="浙江省出口退税月报表_"+bbdldm+"_"+ssny;
        if(appProperties.getIsNb()){
            filename ="宁波市出口退税月报表_"+bbdldm+"_"+ssny;
        }

        String templateFileName;
        if("B01".equals(bbdldm)){
            templateFileName="suit.xls";
        }else if("B02".equals(bbdldm)){
            if(!appProperties.getIsNb()){
                templateFileName="suit4zx.xls";
            }else {
                templateFileName="suit4zxNb.xls";
            }
        }else if("B03".equals(bbdldm)){
            templateFileName="suit4sj.xls";
        }else if("B04".equals(bbdldm)){
            templateFileName="suit4zx2.xls";
        }else {

            String fileName;
            if("B05".equals(bbdldm)){
                fileName="跨境电商统计表";
                saveSpecSuitExcel(swjgdm,suitExcelDTOS, response,fileName);
            }else if("B06".equals(bbdldm)){
                fileName="市场采购情况统计表";
                saveSpecSuitExcel(swjgdm,suitExcelDTOS, response,fileName);
            }else {

                TjbbReportItem reportItem = tjbbReportItemMapper.selectByPrimaryKey(bbdldm);

                if(StringUtils.isNotEmpty(reportItem.getNote())){
                    fileName = reportItem.getNote();
                }else {
                    fileName = reportItem.getBbdlmc();
                }
                saveDynamicSuitExcel(suitExcelDTOS, response,fileName);
            }
            return;
        }


        String templatePath = "template" + File.separator + templateFileName ;
        ClassPathResource resource = new ClassPathResource(templatePath);
        InputStream stream = resource.getInputStream();


        ServletOutputStream out = response.getOutputStream();


        try {
            poiExcelUtil.exportTemplateExcelStream4Poi(response, out,stream, filename, suitExcelDTOS);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            response.setContentType("text/html");
            out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                    .getBytes("UTF-8"),"iso8859-1"));
            out.flush();
            out.close();
        }
    }

    private void saveSpecSuitExcel(String swjgdm,List<SuitExcelDTO> suitExcelDTOS,HttpServletResponse response,String filename) throws IOException {

        List<InputStream> streamList = new ArrayList<>();
        for (SuitExcelDTO suitExcelDTO : suitExcelDTOS) {
            String bbdm = suitExcelDTO.getBbdm();

            File file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xls");

            InputStream stream = new FileInputStream(file);
            streamList.add(stream);
        }

        ServletOutputStream out = response.getOutputStream();
        try {
            poiExcelUtil.exportTemplateExcelStream4Poi4Spec(swjgdm,response, out,streamList, filename,suitExcelDTOS,commonService.getCurrentUser().getSwjgDm());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            response.setContentType("text/html");
            out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                    .getBytes("UTF-8"),"iso8859-1"));
            out.flush();
            out.close();
        }

    }


    private void saveDynamicSuitExcel(List<SuitExcelDTO> suitExcelDTOS,HttpServletResponse response,String filename) throws IOException {

        List<InputStream> streamList = new ArrayList<>();
        for (SuitExcelDTO suitExcelDTO : suitExcelDTOS) {
            String bbdm = suitExcelDTO.getBbdm();

            File file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xls");

            InputStream stream = new FileInputStream(file);
            streamList.add(stream);
        }

        ServletOutputStream out = response.getOutputStream();
        try {
            poiExcelUtil.exportDynamicExcelStream4Poi4Spec(response, out,streamList, filename,suitExcelDTOS);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            response.setContentType("text/html");
            out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                    .getBytes("UTF-8"),"iso8859-1"));
            out.flush();
            out.close();
        }

    }


    private TjbbTbxx getTjbbZbxx(String swjgdm,String bbdm,Date hzDate,String czryMc,String ssny){
        TjbbTbxx zbxx=new TjbbTbxx();

        SwjgModel swjgModel;
        if(swjgdm.startsWith("2")){
            swjgModel=commonService.getSwjgMc(commonService.getCurrentUser().getSwjgDm());
        }else{
            swjgModel = commonService.getSwjgMc(swjgdm);
        }

        String yyyyMM = new SimpleDateFormat("yyyy年MM月").format(TlDateUtils.parseString2Date(ssny,"yyyyMM"));
        zbxx.setBbdm(bbdm);
        zbxx.setSwjgmc(org.apache.commons.lang3.StringUtils.trimToEmpty(swjgModel.getSwjgjc()));
        zbxx.setSsny(org.apache.commons.lang3.StringUtils.trimToEmpty(yyyyMM));
        zbxx.setUnit("");
        zbxx.setZbr(org.apache.commons.lang3.StringUtils.trimToEmpty(czryMc));
        zbxx.setZbdate(hzDate);
        zbxx.setQt("");

        return zbxx;
    }

    private String getJsCallback(String status,String message){
        return String.format(callback,message);
    }

    @PostMapping("savedata")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult savedata(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        SavaDataDTO dataDTO = getAndCheckParam(request.getInputStream(), SavaDataDTO.class);

        if(!CollectionUtils.isEmpty(dataDTO.getData())){
            tjbbBasisService.updateData(dataDTO);
        }

        return rtn;
    }

    @PostMapping("task")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult task(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getAndCheckParam(request.getInputStream(), TjbbTaskDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());

        List<TjbbTaskVo> list = tjbbBasisService.getTjbbTaskBySsny(dto.getSsny(),dto.getSwjgdm());

        rtn.setData(dealPageInfo(list));

        return rtn;
    }

    @PostMapping("task/sublist")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult sublist(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getAndCheckParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();
        String swjgDm = dto.getSwjgDm();

        if(StringUtils.isBlank(bbdldm) || StringUtils.isBlank(swjgDm) ){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());

        List<TjbbTaskSubVo> list = tjbbBasisService.getTjbbTaskSubList(dto.getSsny(),bbdldm,swjgDm);

        rtn.setData(dealPageInfo(list));

        return rtn;
    }

    /**
     * 查看下级上报情况
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("task/recivelist")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult recivelist(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getAndCheckParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());

        PageInfo receive;
        if(StringUtils.isNotBlank(dto.getSwjgdm())){ //支持虚拟机关
            receive = virSwjgService.getTjbbTaskReceive(dto.getSsny(), bbdldm,dto.getSwjgdm());
        }else{
            receive = tjbbBasisService.getTjbbTaskReceive(dto.getSsny(), bbdldm);
        }

        rtn.setData(receive);

        return rtn;
    }


    /**
     * 撤回操作
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("task/reciveback")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult reciveback(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();
        String swjgdm = dto.getSwjgdm();

        if(StringUtils.isBlank(bbdldm) || StringUtils.isBlank(swjgdm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        tjbbBasisService.checkSubmit(bbdldm,dto.getSsny());

        tjbbBasisService.getTjbbReback(swjgdm,dto.getSsny(),bbdldm);

        tjbbBasisService.changeTjbbStatus(dto,"00",null);

        tjbbBasisService.savaLog(TjbbCzLogCode.CZ_CODE_CH,TjbbCzLogCode.CZ_TYPE_TASK);

        return rtn;
    }

    /**
     * 基层制表及上级数据汇总操作
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("task/make")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjbbMake(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        TlUserProfile currentUser = commonService.getCurrentUser();
        int length = commonService.getQxdm().length();

        //省局和市局进行汇总操作
        if(length<=5){

            if(!appProperties.isTest()){
                if("1".equals(dto.getIsVir())){
                    tjbbBasisService.checkVirAllSubmit(dto);
                }else {
                    tjbbBasisService.checkAllSubmit(dto);
                }
            }

            tjbbBasisService.makeHzTjbb(dto,currentUser);

            tjbbBasisService.changeTjbbStatus(dto,"10",dto.getSwjgdm());

        }else { //县局，第三分局进行制表操作
            tjbbBasisService.makeTjbb(dto,currentUser);

            tjbbBasisService.changeTjbbStatus(dto,"10",dto.getSwjgdm());
        }

        if(StringUtils.isBlank(dto.getSwjgdm())){ //虚拟表暂时不记录
            tjbbBasisService.savaLog(TjbbCzLogCode.CZ_CODE_MAKE,TjbbCzLogCode.CZ_TYPE_TASK);
        }

        return rtn;
    }

    /**
     * 基层重新勾选指标
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("task/cxmake")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjbbCxMake(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        tjbbBasisService.cxMakeTjbb(dto);

        tjbbBasisService.changeTjbbStatus(dto,"10",null);


        tjbbBasisService.savaLog(TjbbCzLogCode.CZ_CODE_CXMAKE,TjbbCzLogCode.CZ_TYPE_TASK);

        return rtn;
    }

    /**
     * 生成总表
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("task/cxmake/hz")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjbbCxMakeHz(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        return rtn;
    }


    @PostMapping("task/sb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjbbTaskSb(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdldm = dto.getBbdldm();

        if(StringUtils.isBlank(bbdldm)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        if(!"1".equals(dto.getQrflag())){

            //执行申报检测
            String swjgDm = commonService.getCurrentUser().getSwjgDm();
            tjbbBasisService.executeSbCheckProc(dto.getSsny(),swjgDm, TlConst.SB_CHECK_PROC,dto.getBbdldm());

            List<TjbbSbJyxxModel> warnList  = tjbbBasisService.getJyxxList(bbdldm,"2");
            if(!warnList.isEmpty()){
                rtn.setCode(7001);
            }
            List<TjbbSbJyxxModel> errorList  = tjbbBasisService.getJyxxList(bbdldm,"1");
            if(!errorList.isEmpty()){
                rtn.setCode(7002);
            }

            errorList.addAll(warnList);
            rtn.setData(errorList);

            if(!errorList.isEmpty()){
                return rtn;
            }
        }

        if(!appProperties.isTest()){
            tjbbBasisService.checkAllSubmit(dto);
        }

        tjbbBasisService.changeTjbbStatus(dto,"20",null);

        tjbbBasisService.savaLog(TjbbCzLogCode.CZ_CODE_SB,TjbbCzLogCode.CZ_TYPE_TASK);

        return rtn;
    }


    /**
     * 接收表查询页
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("recevMain")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult recevMain(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdm = dto.getBbdm();
        String ssny = dto.getSsny();

        if(StringUtils.isBlank(bbdm) ){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<TjbbRecvMainVo>  recvMainVoList= tjbbBasisService.getTjbbRecvMain(ssny,bbdm);


        rtn.setData(dealPageInfo(recvMainVoList));

        return rtn;
    }

    @PostMapping("zbxx/init")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult zbxxInit(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO dto =getParam(request.getInputStream(), TjbbTaskDTO.class);
        String bbdm = dto.getBbdm();

        if(StringUtils.isBlank(bbdm) ){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        TjbbTbxx tjbbTbxx=tjbbBasisService.getZbxx(bbdm);

        rtn.setData(tjbbTbxx);

        return rtn;
    }

    @PostMapping("zbxx/save")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult zbxxSave(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTbxx tbxx =getParam(request.getInputStream(), TjbbTbxx.class);

        tjbbBasisService.saveTjbbTbxx(tbxx);

        return rtn;
    }


    @PostMapping("vir/cr")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult virCreate(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        VirTjbbDTO tjbbDTO =getParam(request.getInputStream(), VirTjbbDTO.class);

        virSwjgService.createTask(tjbbDTO);

        return rtn;
    }

}
