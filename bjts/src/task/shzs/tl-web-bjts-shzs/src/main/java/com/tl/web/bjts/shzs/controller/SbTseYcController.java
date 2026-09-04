package com.tl.web.bjts.shzs.controller;

import com.tl.common.ext.utils.BaseController;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcBfLogSaveDTO;
import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcInfoQueryDTO;
import com.tl.web.bjts.shzs.model.vo.TseYcInfoQueryVO;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.ISbTseYcService;
import com.tl.web.bjts.shzs.service.SbLcslService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * @Author whg
 * @create 2024/5/8 9:30
 * @description：
 */
@RestController
@RequestMapping("sb/tseyc")
public class SbTseYcController extends BaseController {

    @Autowired
    private ISbTseYcService sbTseYcService;

    @Autowired
    private SbLcslService sbLcslService;

    @Autowired
    private CommonServiceImpl commonService;


    /**
     * 保存退税额预测不符的处理日志
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("bf/save")
    public SimpleResult saveLog(HttpServletRequest request) throws IOException {
        SimpleResult result = new SimpleResult();
        TseYcBfLogSaveDTO dto = getAndCheckParam(request.getInputStream(),TseYcBfLogSaveDTO.class);
        dto.setCzymc(commonService.getCurrentUserName());
        sbTseYcService.saveLog(dto);
        return result;
    }

    /**
     * 查询退税额预测信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("info/query")
    public SimpleResult queryInfo(HttpServletRequest request) throws IOException {
        SimpleResult result = new SimpleResult();
        TseYcInfoQueryDTO dto = getAndCheckParam(request.getInputStream(),TseYcInfoQueryDTO.class);
        dto.setSwjgDm(getCurrSwjg());

        YwblxxVO ywblxxVO = sbLcslService.getYwblxxFormJsxt(dto.getLcslid());
        dto.setYwblxxVO(ywblxxVO);

        TseYcInfoQueryVO vo = sbTseYcService.queryInfo(dto);
        result.setData(vo);
        return result;
    }

    /**
     * 获取当前操作人员所属税务机关
     * @return
     */
    private String getCurrSwjg(){
        TlUserProfile user = commonService.getCurrentUser();
        return user.getSwjgDm();
    }
}
