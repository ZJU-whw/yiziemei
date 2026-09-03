package com.tl.bjts.sw.controller;

import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ParamModel;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.JcfxTaskModel;
import com.tl.bjts.sw.model.domain.NsrSampleModel;
import com.tl.bjts.sw.model.domain.NsrSampleSubModel;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.MgspMbVo;
import com.tl.bjts.sw.model.vo.SjjcDynamicVo;
import com.tl.bjts.sw.model.vo.SjjcQyxxExcelVo;
import com.tl.bjts.sw.model.vo.jcfx.FzHzInitVo;
import com.tl.bjts.sw.model.vo.jcfx.NsrdjxxVo;
import com.tl.bjts.sw.model.vo.jcfx.ZbItemVo;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.RedisDelayService;
import com.tl.bjts.sw.service.SjjcQueryService;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.bjts.sw.utils.*;
import com.tl.common.ext.model.BaseListDTO;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.StringUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;


/**
 * @author: Mamf
 * @date: 2021/11/3
 * @description 数据监测分析
 */

@RequestMapping("sjjc")
@RestController
public class SjjcController extends TLBaseController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    SjjcQueryService sjjcQueryService;

    @Autowired
    RedisDelayService redisDelayService;

    @Autowired
    AppProperties appProperties;

    private final String callback= "<script>top.tools.info(\"%s\");</script>";

    /**
     * 综合指标分组汇总通用查询接口
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("query/dynamic")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult queryDynamicSjjc(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        DynamicQueryDTO param = getParam(request.getInputStream(), DynamicQueryDTO.class);


        SjjcDynamicVo o = sjjcQueryService.getSjjcDynamicData(param);

        rtn.setData(o);

        return rtn;

    }

    /**
     * 出口情况统计表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("query/ckqk")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult queryCkqk(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        DynamicQueryDTO param = getParam(request.getInputStream(), DynamicQueryDTO.class);

        SjjcDynamicVo o = sjjcQueryService.getSjjcCkqkData(param);

        rtn.setData(o);

        return rtn;

    }


    /**
     * 免退税情况统计表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("query/cktms")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult queryMdtsTj(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        DynamicQueryDTO param = getParam(request.getInputStream(), DynamicQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        SjjcDynamicVo o = sjjcQueryService.queryMdtsTjData(param,swjgDm);

        rtn.setData(o);

        return rtn;

    }



    /**
     * 特殊业务
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("query/tsywxx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult queryTsyw(HttpServletRequest request) throws Exception {
        SimpleResult rtn = new SimpleResult();

        DynamicQueryDTO param = getParam(request.getInputStream(), DynamicQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        SjjcDynamicVo o = sjjcQueryService.queryTsywxxData(param,swjgDm);

        rtn.setData(o);

        return rtn;

    }


    /**
     * 查询样本企业分组
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSample(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        BaseListDTO param = getParam(request.getInputStream(), BaseListDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        List<NsrSampleModel> o = sjjcQueryService.getNsrSampleList(param,swjgDm);

        rtn.setData(dealPageInfo(o));

        return rtn;

    }



    /**
     * 新增企业信息
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/add")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSampleAdd(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrSampleModel param = getParam(request.getInputStream(), NsrSampleModel.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        String swjgDm = currentUser.getSwjgDm();
        String czryDm = currentUser.getCzryDm();

        sjjcQueryService.addNsrSample(param,swjgDm,czryDm);

        return rtn;

    }

    /**
     * 修改样本组信息
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/update")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSampleQybz(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrSampleModel param = getParam(request.getInputStream(), NsrSampleModel.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        String swjgDm = currentUser.getSwjgDm();
        String czryDm = currentUser.getCzryDm();

        sjjcQueryService.updateQybz(param,swjgDm,czryDm);

        return rtn;

    }


    /**
     * 删除企业分组信息
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSampleDel(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrSampleModel param = getParam(request.getInputStream(), NsrSampleModel.class);

        TlUserProfile currentUser = commonService.getCurrentUser();

        String swjgDm = currentUser.getSwjgDm();



        if(param.getZid() == null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        logger.info("用户{}执行删除企业分组",currentUser.getCzryDm());

        sjjcQueryService.delNsrSample(param.getZid(),swjgDm);

        return rtn;

    }

    /**
     * 查询样本企业
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/sub")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSampleSub(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrxxQueryDTO param = getParam(request.getInputStream(), NsrxxQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        List<NsrSampleSubModel> o = sjjcQueryService.getNsrSampleSubList(param.getZid(),swjgDm,param.getPageNo(),param.getPageSize());

        rtn.setData(dealPageInfo(o));

        return rtn;

    }

    /**
     * 添加样本企业信息
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/sub/add")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult addNsrSampleSub(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        SjjcSamplePramDTO param = getParam(request.getInputStream(), SjjcSamplePramDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        sjjcQueryService.addNsrSampleSub(param,swjgDm);


        return rtn;

    }


    /**
     * 移除样本企业
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/sample/sub/del")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrSampleSubDel(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        SjjcSamplePramDTO param = getParam(request.getInputStream(), SjjcSamplePramDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        sjjcQueryService.delNsrSampleSub(param,swjgDm);


        return rtn;

    }


    /**
     * 获取所有备案企业信息列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("nsr/badjxx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrBadjxx(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrxxQueryDTO param = getParam(request.getInputStream(), NsrxxQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        List<NsrdjxxVo> o = sjjcQueryService.getNsrdjxxList(param,swjgDm);

        rtn.setData(dealPageInfo(o));

        return rtn;

    }


    /**
     * 获取所有备案企业信息列表
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("task/records")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult nsrQueryTask(HttpServletRequest request) throws Exception {

        SimpleResult rtn = new SimpleResult();

        NsrxxQueryDTO param = getParam(request.getInputStream(), NsrxxQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        List<JcfxTaskModel> o = sjjcQueryService.getTaskRecords(param,swjgDm);

        rtn.setData(dealPageInfo(o));

        return rtn;

    }


    /**
     * 导出Excel报表查询
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("export/dynamic/init")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult exportDynamicDataInit(HttpServletRequest request) throws Exception {

        SimpleResult<ExcelResultDTO> ret = new SimpleResult<>();

        DynamicQueryDTO param = getParam(request.getInputStream(), DynamicQueryDTO.class);

        ExcelResultDTO excelResultDTO = sjjcQueryService.exportDynamicDataInit(param);

        ret.setData(excelResultDTO);

        return ret;
    }


    /**
     * 保存Excel报表
     * @param data
     * @param request
     * @param response
     * @throws Exception
     */
    @PostMapping("saveDynamicExcel")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void saveDynamicExcel(String data,HttpServletRequest request, HttpServletResponse response) throws Exception {

        String reqStr = data.replace("&quot;", "\"");
        DynamicQueryDTO param = getParam(reqStr, DynamicQueryDTO.class);

        SjjcDynamicVo dynamicData;
        if(TlConst.SJJC_TJBB_TYPE_02.equals(param.getTjbbType())){
             dynamicData = sjjcQueryService.queryMdtsTjData(param,commonService.getCurrentUser().getSwjgDm());
        }else if(TlConst.SJJC_TJBB_TYPE_07.equals(param.getTjbbType())){
            dynamicData = sjjcQueryService.queryTsywxxData(param,commonService.getCurrentUser().getSwjgDm());
        }else {

            if(param.getTjbbType().startsWith("XLS")){
                param.setPageSize(appProperties.getPageSize());
            }
             dynamicData = sjjcQueryService.getSjjcDynamicData(param);
        }


        List<String> title = dynamicData.getTitle();


        LinkedHashMap<String, String> keyMap =new LinkedHashMap<>();
        for (String text : title) {
            keyMap.put(text,text);
        }


        String filename = TlDateUtils.format(new Date(),"yyyyMMddHHmmss_"+String.format("%02d", param.getPageNo()));
        String[] sheetName={"Sheet1"};


        Map<String,List<LinkedHashMap>> dataMap =new HashMap<>();
        dataMap.put(sheetName[0],dynamicData.getList().getRows());


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


    /**
     * 动态条件初始化
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("dynamic/init")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult<FzHzInitVo> dynamicInit(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        String gsonContent = redisDelayService.getValueByKey(TlConst.REDIS_DM_CACHE_KEY);

        FzHzInitVo fzHzInitVo;
        if(StringUtils.isEmpty(gsonContent)){
             fzHzInitVo = tjbbBasisService.getFzHzInit();
        }else {
            fzHzInitVo = new Gson().fromJson(gsonContent,FzHzInitVo.class);
        }

        rtn.setData(fzHzInitVo);

        return rtn;
    }


    /**
     * 获取配置参数
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("param/init")
    public SimpleResult<FzHzInitVo> paramInit(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        ParamModel paramModel = tjbbBasisService.getSysParamInit();

        rtn.setData(paramModel);

        return rtn;
    }


    /**
     * 其他类初始化下拉条件
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("dynamic/init/other")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult<FzHzInitVo> dynamicInitOther(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        InitSelectOtherDTO param = getParam(request.getInputStream(), InitSelectOtherDTO.class);

        FzHzInitVo fzHzInit = tjbbBasisService.getFzHzInitOther(param.getZbxms(),param.getZbdldm());

        rtn.setData(fzHzInit);

        return rtn;
    }

    /**
     * 动态条件初始化
     * @param request
     * @return
     * @throws IOException
     */
    @GetMapping("dynamic/init/spdmtree")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult initSpdmTree(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        String codes=request.getParameter("codes");
        String level=request.getParameter("level");

        rtn.setData(tjbbBasisService.getSpdmTreeList(codes,level));

        return rtn;
    }


    /**
     * 样本企业分组维护导入
     * @param file
     * @param response
     * @throws Exception
     */
    @PostMapping("qyxx/import")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void qyxxImport(String data,@RequestParam("file") MultipartFile file, HttpServletRequest request,HttpServletResponse response) throws Exception {
        SimpleResult rtn=new SimpleResult();
        try {
            String zid = request.getParameter("zid");

            List<SjjcQyxxExcelVo> allData = checkAndGetExcel(file, SjjcQyxxExcelVo.class);
            sjjcQueryService.importQyxxGroupData(allData,Long.parseLong(zid));
        }catch (BusinessException e){
            rtn.setMsg(e.getMsg());
            rtn.setCode(e.getCode());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(new Gson().toJson(rtn));
    }


    /**
     * 刷新健康码重计算
     * @param response
     * @throws Exception
     */
    @PostMapping("jkm/refresh")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult jkmRefresh(HttpServletRequest request,HttpServletResponse response) throws Exception {
        SimpleResult rtn = new SimpleResult();

        NsrsbhDTO nsrsbhDTO = getParam(request.getInputStream(),NsrsbhDTO.class);

        sjjcQueryService.jkmRefreshProc(nsrsbhDTO);

        return rtn;
    }

    private String getJsCallback(String status,String message){
        return String.format(callback,message);
    }
}
