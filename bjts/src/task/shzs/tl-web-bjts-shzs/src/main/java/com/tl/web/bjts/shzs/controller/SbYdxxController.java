package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.vo.SbidVo;
import com.tl.web.bjts.shzs.model.vo.YdxxVo;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.service.SbLcslService;
import com.tl.web.bjts.shzs.service.SbYdxxService;
import com.tl.web.bjts.shzs.utils.JxlExcelUtil;
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
 * @Description: 疑点信息相关接口
 * @Author Neo Lin
 * @Date  2017/12/14 15:40
 */
@RestController
@RequestMapping("sb/ydxx")
public class SbYdxxController {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private SbYdxxService ydxxService;

    @Autowired
    private SbLcslService sbLcslService;


    @PostMapping("view")
    public SimpleResult<Map> getYdxxs(HttpServletRequest request) throws Exception{
        SimpleResult<Map> rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/ydxx/view】 params：" + reqStr);
        SbidVo sbidVo = new Gson().fromJson(reqStr, SbidVo.class);
        String lcslid = sbidVo.getLcslid();
        if(lcslid == null){
            rtn.setResultCode(ResultCode.INVALID_PARAM);
            return rtn;
        }

        YwblxxVO ywblxxVO = sbLcslService.getYwblxxFormJsxt(lcslid);

        List<YdxxVo> ydxxs = ydxxService.getYdxxs(lcslid,ywblxxVO.getLcswsxDm());
        Map<String,List<YdxxVo>> rtnData = new HashMap<>();
        rtnData.put("ydxxs",ydxxs);
        rtn.setData(rtnData);
        return rtn;
    }

    /**
     * 预警信息Excel文件下载
     * @param request,response
     * @return
     * @throws Exception
     */
    @RequestMapping("/excelExport")
    public void exportExcel(String lcslid,HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        if(lcslid == null){
            LOGGER.info(ResultCode.INVALID_PARAM.getMsg());
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        LOGGER.info("【sb/ydxx/exportExcel】 params：" + lcslid);

        YwblxxVO ywblxxVO = sbLcslService.getYwblxxFormJsxt(lcslid);

        String filename = BusinessMsgCons.YDXX_FILENAME;
//        String excel_name = new String(filename.getBytes("UTF-8"), "ISO8859-1");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(filename,"UTF-8") + ".xls");
        List<YdxxVo> yjxxsList = ydxxService.getYdxxs(lcslid, ywblxxVO.getLcswsxDm());
        LinkedHashMap<String, String> keyMap = new LinkedHashMap<>();
        keyMap.put("id", "序号");
        keyMap.put("errObj", "疑点对象");
        keyMap.put("errLev", "疑点级别");
        keyMap.put("ydcode", "疑点代码");
        keyMap.put("passFlag", "可否挑过");
        keyMap.put("glywb1", "关联项1");
        keyMap.put("glywb2", "关联项2");
        keyMap.put("errMsg", "疑点内容");
        Integer[] columns_widths = {6, 15, 15, 15, 15, 25, 25, 140};

        // 设置调用的方法名
        Map<String, String> methodMap = new HashMap<String, String>();
        // 方法可以在JxlExcelUtils定义，会根据名字进行调用，可以用来处理一些数据，如decode之类的功能
        // methodMap.put("cardType", "cardTypeConverter");
        JxlExcelUtil jxlExcelUtil = new JxlExcelUtil();
        OutputStream out = response.getOutputStream();

        if (null != yjxxsList
                && yjxxsList.size() > 0) {
            //生成Excel
            try {
                jxlExcelUtil.getExcelStream(response, filename, keyMap,
                        yjxxsList, out, methodMap, columns_widths);
            } catch (Exception e) {
                LOGGER.error(e.getMessage(),e);
                throw  new BusinessException(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_ERROR);
            }
        }else{
            LOGGER.info(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_EMPTY);
            throw  new BusinessException(BusinessMsgCons.SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_EMPTY);
        }
    }


}
