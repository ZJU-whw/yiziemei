package com.tl.bjts.sw.controller;

import com.google.zxing.WriterException;
import com.tl.bjts.sw.annotation.TLParam;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.dto.CkllfxEditDTO;
import com.tl.bjts.sw.model.dto.CkllfxListDTO;
import com.tl.bjts.sw.model.dto.CkllfxQrDTO;
import com.tl.bjts.sw.model.vo.CkllfxListVO;
import com.tl.bjts.sw.model.vo.CkllfxQrVO;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.YjService;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.ext.exception.TlBusinessException;
import com.tl.common.resolver.User;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * @Description: 出口业务物流链路综合管理控制器
 * @Author: 
 * @Date: 2026-05-13
 */
@RequestMapping("yj/ckll")
@RestController
public class CkllfxController extends TLBaseController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CkllfxController.class);

    @Autowired
    private YjService yjService;

    @Autowired
    private CommonServiceImpl commonService;
    
    /**
     * 出口业务物流链路综合管理列表查询
     * @param request HTTP请求
     * @return 查询结果
     * @throws IOException IO异常
     */
    @PostMapping("list")
    @RequiresRoles(logical = Logical.OR, value = {"czy"})
    public SimpleResult listCkllfx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult<>();
        CkllfxListDTO dto = getParam(request.getInputStream(), CkllfxListDTO.class);
        List<CkllfxListVO> retList = yjService.getCkllfxList(dto);
        rtn.setData(dealPageInfo(retList));
        return rtn;
    }
    
    /**
     * 出口业务物流链路综合管理列表导出
     * @param data 查询条件JSON字符串
     * @param response HTTP响应
     * @param exual 导出字段列表
     */
    @PostMapping("export")
    @RequiresRoles(logical = Logical.OR, value = {"czy"})
    public void exportCkllfx(String data, HttpServletResponse response, @TLParam List<String> exual) throws IOException {
        try {
            String reqStr = data.replace("&quot;", "\"");
            CkllfxListDTO dto = getParam(reqStr, CkllfxListDTO.class);
            yjService.exportCkllfxList(response, dto, exual);
        } catch (BusinessException e) {
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print(e.getMsg());
        } catch (Exception e) {
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("导出失败：" + e.getMessage());
        }
    }

    /**
     * 修改物流链路数据
     * @param request
     * @return
     * @throws IOException
     */
    @RequiresRoles(logical = Logical.OR, value = {"czy"})
    @RequestMapping("/edit")
    public SimpleResult edit(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult<>();
        CkllfxEditDTO dto = getAndCheckParam(request.getInputStream(), CkllfxEditDTO.class);
        String swjgdm = commonService.getCurrentUser().getSwjgDm();
        String name = commonService.getCurrentUser().getCzryMc();
        try {
            yjService.editCkllfx(dto, TlUtils.getPreSwjgdm(swjgdm));
        } catch (Exception e) {
            if (e instanceof BusinessException || e instanceof TlBusinessException) {
                throw e;
            }
            LOGGER.error("[name:{},swjgdm:{}]修改物流链路数据失败,请求参数:{},错误信息:", name, swjgdm, dto.toString(), e);
            throw new BusinessException("保存失败");
        }
        return rtn;
    }

    /**
     * 生成物流链路二维码
     * @param request
     * @return
     * @throws IOException
     */
    @RequiresRoles(logical = Logical.OR, value = {"czy"})
    @PostMapping("qr")
    public SimpleResult generateQrCode(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult<>();
        CkllfxQrDTO dto = getAndCheckParam(request.getInputStream(), CkllfxQrDTO.class);
        String swjgdm = commonService.getCurrentUser().getSwjgDm();
        String name = commonService.getCurrentUser().getCzryMc();
        String qxSwjgDm = TlUtils.getPreSwjgdm(swjgdm);
        try {
            CkllfxQrVO vo = yjService.generateCkllQrCode(dto, qxSwjgDm);
            rtn.setData(vo);
        } catch (Exception e) {
            if (e instanceof BusinessException || e instanceof TlBusinessException) {
                throw e;
            }
            LOGGER.error("[name:{},swjgdm:{}]生成物流链路二维码失败,请求参数:{},错误信息:", name, swjgdm, dto.toString(), e);
            throw new BusinessException("生成二维码失败");
        }
        return rtn;
    }
}