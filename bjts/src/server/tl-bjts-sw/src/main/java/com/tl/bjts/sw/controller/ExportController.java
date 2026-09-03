package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tl.bjts.sw.annotation.TLParam;
import com.tl.bjts.sw.conf.MyAppConfig;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.NsrSampleSubModel;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.service.*;
import com.tl.bjts.sw.utils.JxlExcelUtil;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.GsonUtils;
import com.tl.common.ext.utils.TlBeanUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RequestMapping("export")
@RestController
public class ExportController extends BaseController {

    @Autowired
    ExportService exportExcelService;
    @Autowired
    YjService yjService;

    @Autowired
    TjfxService tjfxService;


    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    SjjcQueryService sjjcQueryService;

    /**
     * 主要是读取税务机关树
     * @param response
     * @return
     * @throws Exception
     */
    @PostMapping("readtree")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public String readjson(HttpServletResponse response) throws Exception {

        BufferedReader reader = null;
        String templateName="swjg.json";


        String laststr = "";
        try {
//            FileInputStream fileInputStream = new FileInputStream(Path);
            String templatePath = "template" + File.separator + templateName ;
            ClassPathResource resource = new ClassPathResource(templatePath);
            InputStream fileInputStream = resource.getInputStream();
            InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
            reader = new BufferedReader(inputStreamReader);
            String tempString = null;
            while ((tempString = reader.readLine()) != null) {
                laststr += tempString;
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return laststr;
    }

    @PostMapping("wmmgka")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void wmmgka(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="外贸免退税敏感口岸信息库维护";
        String reqStr = data.replace("&quot;", "\"");
        WmMgkaDTO dto =getParam(reqStr, WmMgkaDTO.class);
        if(dto==null){
            dto=new WmMgkaDTO();
        }
        dto.setExport(true);
        List<MgkaWmVo> retList=yjService.wmmgka(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,MgkaWmVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }
    @PostMapping("mgsp")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void mgsp(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="敏感商品信息库";

        if (data == null) {
            throw  new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        String reqStr = data.replace("&quot;","\"");
        WmMgkaDTO dto = GsonUtils.getDefaultGson().fromJson(reqStr,WmMgkaDTO.class);

        if(dto==null){
            dto=new WmMgkaDTO();
        }
        dto.setExport(true);
        List<MgspVo> retList=yjService.mgsp(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,MgspVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }
    @PostMapping("ycghqy")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void ycghqy(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="异常供货企业信息库维护";
        String reqStr = data.replace("&quot;", "\"");
        WmMgkaDTO dto =getParam(reqStr, WmMgkaDTO.class);
        if(dto==null){
            dto=new WmMgkaDTO();
        }
        dto.setExport(true);
        List<YcghVo> retList=yjService.ycghqy(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,YcghVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

    @PostMapping("scqycjka")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void scqycjka(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="生产免抵退常见口岸库查询";
        String reqStr = data.replace("&quot;", "\"");
        WmMgkaDTO dto =getParam(reqStr, WmMgkaDTO.class);
        if(dto==null){
            dto=new WmMgkaDTO();
        }
        dto.setExport(true);
        List<MGkaScVo> retList=yjService.scqycjka(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,MGkaScVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

    @PostMapping("ychd")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void ychd(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="异常函调信息库查询";
        String reqStr = data.replace("&quot;", "\"");
        YchdDTO dto =getParam(reqStr, YchdDTO.class);
        if(dto==null){
            dto=new YchdDTO();
        }
        dto.setExport(true);
        List<YchdVo> retList=yjService.ychd(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,YchdVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

    @PostMapping("cksppjj")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void cksppjj(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename;


        String reqStr = data.replace("&quot;", "\"");
        QspjdjDTO dto =getParam(reqStr, QspjdjDTO.class);
        if(dto==null){
            dto=new QspjdjDTO();
        }
        if("1".equals(dto.getType())){
            filename="生产企业出口商品平均单价";
        }else {
            filename="外贸企业出口商品平均单价";
        }

        List<PjdjVo> retList=yjService.cksppjj(dto);
        try {
            exportExcelService.exportExcel(filename,response, retList,PjdjVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }
    /*
     * @Description: 异常供货企业模板
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("ycghqy/mb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void ycghqymb(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="异常供货企业导入模板";
        List<YcghMbVo> list=new ArrayList();
        YcghMbVo vo=new YcghMbVo();
        vo.setQsrq("2019-01-01");
        vo.setJzrq("2019-01-02");
        vo.setNsrmc("示例企业");
        vo.setNsrsbh("1000000001");
        vo.setZgswjgmc("示例主管税务机关");
        vo.setYyms("示例原因");
        vo.setYxbz("Y");
        list.add(vo);
        try {
            exportExcelService.exportExcel(filename,response, list,YcghMbVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }
    /*
     * @Description: 敏感商品信息库
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("mgsp/mb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void mgspmb(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="敏感商品信息库导入模板";
        List<MgspMbVo> list=new ArrayList();
        MgspMbVo vo=new MgspMbVo();
        vo.setQsrq("2019-01-01");
        vo.setJzrq("2019-01-02");
        vo.setSpdm("1001");
        vo.setSpmc("示例名称");
        vo.setYyms("示例原因");
        vo.setYxbz("Y");
        list.add(vo);
        try {
            exportExcelService.exportExcel(filename,response, list,MgspMbVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }
    /*
     * @Description: 外贸免退税敏感口岸信息库维护
     * @param  [request]
     * @return  com.tl.bjts.sw.model.SimpleResult
     */
    @PostMapping("wmmgka/mb")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void wmmgkamb(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="外贸免退税敏感口岸信息库维护导入模板";
        List<MgkaWmMbVo> list=new ArrayList();
        MgkaWmMbVo vo=new MgkaWmMbVo();
        vo.setQsrq("2019-01-01");
        vo.setJzrq("2019-01-02");
        vo.setKacode("1001");
        vo.setKaname("示例名称");
        vo.setYyms("示例原因");
        vo.setYxbz("Y");
        list.add(vo);
        try {
            exportExcelService.exportExcel(filename,response, list,MgkaWmMbVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }



    @PostMapping("tjfx/wmghqymx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void wmghqymx(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="外贸供货企业明细列表";
        String reqStr = data.replace("&quot;", "\"");

        TjfxMainDTO mainDTO = getParam(reqStr, TjfxMainDTO.class);

        mainDTO.setExport(true);
        List<WmGhqyMxVo> retList=tjfxService.getWmghqymx(mainDTO);

        try {
            exportExcelService.exportExcel(filename,response, retList,WmGhqyMxVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }


    /*
 * @Description: 样本企业分组维护导入模板
 * @param  [request]
 * @return  com.tl.bjts.sw.model.SimpleResult
 */
    @PostMapping("sjjcfx/qyxx/template")
    public void qyxxGroupTemplate(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="样本企业分组维护导入模板";
        List<SjjcQyxxExcelVo> list=new ArrayList();
        SjjcQyxxExcelVo vo=new SjjcQyxxExcelVo();
        vo.setNsrsbh("91330000142941XXXX");
        vo.setNsrmc("企业名称(可不填)");
        list.add(vo);
        try {
            exportExcelService.exportExcel(filename,response, list,SjjcQyxxExcelVo.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }



    @PostMapping("sjjcfx/qyxx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public void qyxxQueryExport(String data, HttpServletRequest request, HttpServletResponse response , @TLParam List<String> exual) throws Exception {
        String filename="样本组企业明细列表";
        String reqStr = data.replace("&quot;", "\"");

        NsrxxQueryDTO param = getParam(reqStr, NsrxxQueryDTO.class);

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        List<NsrSampleSubModel> retList = sjjcQueryService.getNsrSampleSubList(param.getZid(),swjgDm,param.getPageNo(),param.getPageSize());

        try {
            exportExcelService.exportExcel(filename,response, retList,NsrSampleSubModel.class,exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.getWriter().print(e.getMsg());
        }
    }

}
