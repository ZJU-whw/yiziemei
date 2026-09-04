package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.YjzbcxVo;
import com.tl.web.bjts.shzs.model.dto.YjxxClmsgDTO;
import com.tl.web.bjts.shzs.model.vo.YjxxExcelVO;
import com.tl.web.bjts.shzs.model.vo.YjxxViewVO;
import com.tl.web.bjts.shzs.service.SbYjxxService;
import com.tl.web.bjts.shzs.utils.JxlExcelUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Neo Lin on 2017/6/20.
 */
@RestController
@RequestMapping("sb/yjxx")
public class SbYjxxViewController {

    @Autowired
    private SbYjxxService sbYjxxService;

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    /**
     * 查询预警指标列表
     * @param data
     * @param response
     * @return
     * @throws Exception
     */
    @PostMapping("yjzb")
    public SimpleResult yjzb(String data, HttpServletResponse response) throws Exception {

        SimpleResult<List<YjzbcxVo>> rtn = new SimpleResult();
        List<YjzbcxVo> list = sbYjxxService.findyjzb();
        rtn.setData(list);
        return rtn;
    }

    /**
     * 预警信息Excel文件下载
     * @param request,response
     * @return
     * @throws Exception
     */
    @RequestMapping("/excelExport")
    public void exportExcel(Integer sbid,HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        if(sbid == null){
            LOGGER.info(ResultCode.INVALID_PARAM.getMsg());
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        LOGGER.info("【sb/yjxx/exportExcel】 params：" + sbid.toString());
        String filename = BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL;
//        String excel_name = new String(filename.getBytes("UTF-8"), "ISO8859-1");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(filename,"UTF-8") + ".xls");
        List<YjxxExcelVO> yjxxsList = sbYjxxService.getYjxxsForExcel(((Number) sbid).longValue());
        LinkedHashMap<String, String> keyMap = new LinkedHashMap<>();
        keyMap.put("id", "序号");
        keyMap.put("yjTypeName", "预警类型");
        keyMap.put("yjRecord", "预警关联号");
        keyMap.put("yjMsg", "预警信息");
        keyMap.put("yjObject", "预警对象");
        keyMap.put("yjAmt", "预警合计金额");
        keyMap.put("yjTax", "预警合计税额");
        keyMap.put("clDate", "处理时间");
        keyMap.put("clMsg", "处理意见");
        keyMap.put("qyhgdm", "企业海关代码");
        keyMap.put("nsrmc", "纳税人名称");
        keyMap.put("nsrsbh", "纳税人识别号");
        Integer[] columns_widths = {6, 19, 21, 102, 25, 25, 25,25, 25, 21, 34, 30};

        // 设置调用的方法名
        Map<String, String> methodMap = new HashMap<String, String>();
        // 方法可以在JxlExcelUtils定义，会根据名字进行调用，可以用来处理一些数据，如decode之类的功能
         methodMap.put("clDate", "dateConverter");
        JxlExcelUtil jxlExcelUtil = new JxlExcelUtil();
        OutputStream out = response.getOutputStream();

        if (null != yjxxsList
                && yjxxsList.size() > 0) {
            //生成Excel
            try {
                jxlExcelUtil.getExcelStream(response, filename, keyMap,
                       yjxxsList, out, methodMap, columns_widths);
            } catch (Exception e) {
                e.printStackTrace();
                LOGGER.error(e.getMessage(),e);
                throw  new BusinessException(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_ERROR);
            }
        }else{
            LOGGER.info(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_EMPTY);
            throw  new BusinessException(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_EMPTY);
        }
    }

    @PostMapping("view")
    public SimpleResult<YjxxViewVO> yjxxView(HttpServletRequest request) throws Exception{
        SimpleResult<YjxxViewVO> rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【sb/yjxx/view】 params：" + reqStr);
        Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
        String  lcslid = (String) param.get("lcslid");

        YjxxViewVO viewVO = sbYjxxService.getYjxxView(lcslid);

        rtn.setData(viewVO);
        rtn.setResultCode(ResultCode.OK);
        return rtn;
    }

    /**
     * 增加前端触发执行预警任务，支持预警的任务生成，采用触发任务优先级提升
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("excute")
    public SimpleResult<YjxxViewVO> excuteYjTask(HttpServletRequest request) throws Exception{
        try {
            SimpleResult rtn = new SimpleResult();
            String reqStr = CommonUtils.readStreamString(request.getInputStream());
            LOGGER.info("【sb/yjxx/excute】 params：" + reqStr);
            Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
            String  lcslid = (String) param.get("lcslid");
            sbYjxxService.excuteYjTask(lcslid);
            rtn.setResultCode(ResultCode.OK);
            return rtn;
        } catch (BusinessException e) {
            LOGGER.info("【sb/yjxx/excute】 biz error："+e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.info("【sb/yjxx/excute】 sys error："+e.getMessage());
            throw e;
        }
    }


    // zhouxi  2018-12-23
    // 新增批量处理预警信息
    @PostMapping("update/clmsg")
    public SimpleResult updateClmsg(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【sb/yjxx/update/clmsg】 params：" + reqStr);
        YjxxClmsgDTO dto=new Gson().fromJson(reqStr,YjxxClmsgDTO.class);
        if(dto == null ||dto.getIds()==null || StringUtils.isEmpty(dto.getLcslid()) ||dto.getClMsg()==null){
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }
        sbYjxxService.updateClyj(dto);
        return rtn;
    }




}
