package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.*;
import com.tl.web.bjts.shzs.model.domain.TlShSbxxHzProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.DocFileinfoService;
import com.tl.web.bjts.shzs.service.ISbfileService;
import com.tl.web.bjts.shzs.service.SbLcslService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;

/**附件、申报文件服务
 * Created by likun on 2017/6/19.
 */
@RestController
@RequestMapping("/sb")
public class FileController {

    @Autowired
    DocFileinfoService DocFileinfoService;
    @Autowired
    private SbLcslService sbLcslService;
    @Autowired
    ISbfileService sbfileService;
    @Autowired
    CommonServiceImpl commonService;

    /**
     * 附件信息查询
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/file/view")
    public SimpleResult view(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        Map<String,Object> param=new Gson().fromJson(reqStr,Map.class);
        String lcslid = (String) param.get("lcslid");
        if (StringUtils.isEmpty(lcslid) || "null".equals(lcslid)) {
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        // 根据流程受理id获取申报id
        Long sbid = sbLcslService.getSbid(lcslid);

        //调用查询附件列表方法
        FjxxViewVo viewVo = DocFileinfoService.view(sbid);
        rtn.setData(viewVo);

        return rtn;
    }

    /**
     * 附件下载
     * @return
     * @throws Exception
     */
    @RequestMapping("/file/download")
    public SimpleResult attachMentDownload(HttpServletRequest request) throws Exception{
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        Map reqMap = new Gson().fromJson(reqStr,Map.class);
        Long fileId = ((Number)reqMap.get("fileId")).longValue();
        SimpleResult rtn = new SimpleResult();
        FjxxVo vo = DocFileinfoService.download(fileId);
        rtn.setData(vo);
        return rtn;
    }

    /**
     * 申报文件下载
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/sbfile/download")
    public SimpleResult sbfileDownload(HttpServletRequest request) throws Exception{

        TlUserProfile user = commonService.getCurrentUser();

        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        Map reqMap = new Gson().fromJson(reqStr,Map.class);

        Long sbid = null;
        try {
            sbid = ((Number)reqMap.get("sbid")).longValue();
        }catch (Exception e){
           String  sbidStr = (String)reqMap.get("sbid");
           if(StringUtils.isNotBlank(sbidStr)){
               sbid = new Long(sbidStr);
           }
        }
        if(sbid == null){
            throw new BusinessException(BusinessMsgCons.FILECONTROLLER_SBID_EMPTY);
        }

        TlShSbxxHzProfile info = sbLcslService.getSblcxxBySbid(sbid);

        if(!user.getCzryDm().equals(info.getSbr())){
            throw new BusinessException(BusinessMsgCons.FILECONTROLLER_SBFILE_DOWNLOAD);
        }
       // SimpleDateFormat  sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        TlShSbxxHzProfile info2 = new TlShSbxxHzProfile();
        info2.setId(sbid);
        info2.setTqcs((info.getTqcs() != null ? info.getTqcs() : 0) + 1);
        info2.setTqsj(new Date());
        sbLcslService.updateSblcxx(info2);
        SbfileVo vo = sbfileService.downloadSbsj(sbid);
        rtn.setData(vo);
        return rtn;
    }


}
