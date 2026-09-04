package com.tl.web.bjts.shzs.service.impl;

import com.tl.common.ext.exception.TlBusinessException;
import com.tl.common.ext.utils.CommonUtils;
import com.tl.common.ext.utils.GsonUtils;
import com.tl.common.ext.utils.StringUtils;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.TlLinkedMapper;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.BaseIdDTO;
import com.tl.web.bjts.shzs.model.dto.dzhc.*;
import com.tl.web.bjts.shzs.model.vo.IdVO;
import com.tl.web.bjts.shzs.model.vo.dzhc.*;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.IInspectService;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.shiro.util.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @描述: 日常审单核查服务实现类
 * @作者: likun
 * @时间: 2022/4/22 16:44
 */
@Service
public class InspectServiceImpl implements IInspectService{
    @Autowired
    private CommonUtils commonUtils;
    @Autowired
    AppProperties appProperties;

    @Qualifier(value = "nonLoadRestTemplate")
    @Autowired
    private RestTemplate restTemplate4Ip;
    @Autowired
    TlLinkedMapper tlLinkedMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Override
    public List<ShzsInspectStateCheckVO> inspectStateCheck(ShzsInspectStateCheckDTO dto) {
        /**
         *  转换21位报关单到18位报关单
         */
        List<String> entryIds18 = transferEntryId21To18(dto.getEntryIds());
        dto.setEntryIds(entryIds18);
        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_STATE_CHECK, GsonUtils.getDefaultGson().toJson(dto),dto.getNsrsbh());
        try {
            List<ShzsInspectStateCheckVO> retList = commonUtils.rpc4List(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,ShzsInspectStateCheckVO.class,restTemplate4Ip);
            return retList;
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public InspectTaskOpenVO inspectBusinessView(BaseIdDTO dto) {
        /**
         * 校验并登录管理系统
         */
        checkAndLoginGlxt();

        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_INSPECT_VIEW, GsonUtils.getDefaultGson().toJson(dto),null);
        try {
            InspectTaskOpenVO vo = commonUtils.rpc(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,InspectTaskOpenVO.class,restTemplate4Ip);
            return vo;
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public List<InspectBusinessAvailableVO> listInspectBusinessAvailable(InspectBusinessAvailableDTO dto) {
        /**
         * 校验并登录管理系统
         */
        checkAndLoginGlxt();

        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_BUSINESS_LIST, GsonUtils.getDefaultGson().toJson(dto),dto.getNsrsbh());
        try {
            List<InspectBusinessAvailableVO> retList = commonUtils.rpc4List(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,InspectBusinessAvailableVO.class,restTemplate4Ip);
            return retList;
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public List<InspectTreeVO> inspectTree(InspectTreeDTO dto) {
        /**
         * 校验并登录管理系统
         */
        checkAndLoginGlxt();

        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_INSPECT_RANGE, GsonUtils.getDefaultGson().toJson(dto),dto.getNsrsbh());
        try {
            List<InspectTreeVO> retList = commonUtils.rpc4List(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,InspectTreeVO.class,restTemplate4Ip);
            return retList;
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public List<IdVO> inspectBusinessAdd(InspectTaskAddDTO dto) {
        /**
         * 校验并登录管理系统
         */
        checkAndLoginGlxt();

        // 对于代理证明的数据，对报关单去重
        distinctInspectDatasByEntryId(dto);

        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_INSPECT_GENERATE, GsonUtils.getDefaultGson().toJson(dto),dto.getNsrsbh());
        try {
            List<IdVO> retList = commonUtils.rpc4List(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,IdVO.class,restTemplate4Ip);
            return retList;
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    /**
     *  根据报关单号对核查的业务请求数据去重
     * @param dto
     */
    public void distinctInspectDatasByEntryId(InspectTaskAddDTO dto) {
        List<InspectTaskAddDTO.AvailableAddDTO> inspectDatasBefore = dto.getInspectDatas();
        if (CollectionUtils.isEmpty(inspectDatasBefore)) {
            return;
        }
        // 根据报关单号对数据去重
        ArrayList<InspectTaskAddDTO.AvailableAddDTO> inspectDatasAfter = inspectDatasBefore.stream().collect(
                // 将集合先放到 treeSet 集合然后将他们转换成数组
                Collectors.collectingAndThen(
                        Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(item -> item.getEntryId())))
                        , ArrayList::new)
        );
        if (!CollectionUtils.isEmpty(inspectDatasAfter)) {
            dto.setInspectDatas(inspectDatasAfter);
        }
    }

    @Override
    public void releaseBatchDailyBusiness(DailyReleaseBatchDTO dto) {
        /**
         * 校验并登录管理系统
         */
        checkAndLoginGlxt();

        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_INSPECT_RELEASE, GsonUtils.getDefaultGson().toJson(dto),null);
        try {
            commonUtils.rpc(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,String.class,restTemplate4Ip);
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public String getGlxtUrl() {
        return appProperties.getGlxtAuthUrl();
    }

    @Override
    public String checkGlxtLoginState() {
        String loginName = commonService.getCurrentLoginName();
        ShzsGlxtLoginInfoDTO loginInfoDTO = new ShzsGlxtLoginInfoDTO();
        loginInfoDTO.setLoginName(loginName);
        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_GLXT_LOGIN_CHECK, GsonUtils.getDefaultGson().toJson(loginInfoDTO),null);
        try {
            commonUtils.rpc(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,String.class,restTemplate4Ip);
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                TlBusinessException te = (TlBusinessException)t;
                // 管理系统未登录状态时，尝试登录管理系统
                if (te.getCode() == 500 && !StringUtils.isEmpty(te.getSubMsg()) && "用户未登录".equals(te.getSubMsg())){
                    return ConstUtil.WHETHER_NO;
                } else {
                    throw te;
                }
            } else {
                throw new BusinessException(t.toString());
            }
        }
        return ConstUtil.WHETHER_YES;
    }

    /**
     *  校验并登录管理系统
     *  如果管理系统没有登陆，则尝试登录
     */
    public void checkAndLoginGlxt(){
        String loginName = commonService.getCurrentLoginName();
        ShzsGlxtLoginInfoDTO loginInfoDTO = new ShzsGlxtLoginInfoDTO();
        loginInfoDTO.setLoginName(loginName);
        // 调用管理系统单证备案服务
        ShzsBaseDTO baseDTO = generateShzsBaseDTO(ConstUtil.SZHZ_FUNCNO_GLXT_LOGIN_CHECK, GsonUtils.getDefaultGson().toJson(loginInfoDTO),null);
        try {
            commonUtils.rpc(baseDTO,appProperties.getGlxtDzbaUrl() + ConstUtil.GLXT_DZBA_URL,String.class,restTemplate4Ip);
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                TlBusinessException te = (TlBusinessException)t;
                // 管理系统未登录状态时，尝试登录管理系统
                if (te.getCode() == 500 && !StringUtils.isEmpty(te.getSubMsg()) && "用户未登录".equals(te.getSubMsg())){
                    /**
                     *  利用审核助手的登录账号体系，通过token的方式登录管理系统
                     */
                    loginGlxt(loginName);
                }
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    /**
     *  利用审核助手的登录账号体系，通过token的方式登录管理系统
     *  1、从管理系统获取token
     *  2、利用token机制登录管理系统
     * @param loginName
     */
    @Override
    public void loginGlxt(String loginName){
        if (StringUtils.isEmpty(loginName)){
             loginName = commonService.getCurrentLoginName();
        }
        // 1、从管理系统获取token
        ShzsGlxtLoginInfoDTO loginInfoDTO = new ShzsGlxtLoginInfoDTO();
        loginInfoDTO.setLoginName(loginName);
        // 从关系系统获取token凭证
        String token = null;
        try {
             token = commonUtils.rpc(loginInfoDTO,appProperties.getGlxtAuthUrl() + ConstUtil.GLXT_AUTH_TOKENG_URL,String.class,restTemplate4Ip);
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
        if (StringUtils.isEmpty(token)){
            throw new BusinessException("从管理系统获取登录token失败");
        }

        // 2、利用token机制登录管理系统
        loginInfoDTO.setToken(token);
        try {
             commonUtils.rpc(loginInfoDTO,appProperties.getGlxtAuthUrl() + ConstUtil.GLXT_AUTH_TOKEN_URL,String.class,restTemplate4Ip);
        } catch(Throwable t){
            if (t instanceof TlBusinessException){
                throw t;
            } else {
                throw new BusinessException(t.toString());
            }
        }
    }

    @Override
    public Map getCzryInfo() {
        TlUserProfile user = commonService.getCurrentUser();
        Map retMap = new HashMap();
        retMap.put("lxr",user.getCzryMc());
        // 从管理系统tl_admin用户的sys_user表中获取用户联系电话
        String lxrdh = tlLinkedMapper.getLxrdhFromGlxt(user.getCzryDm());
        retMap.put("lxrDh",lxrdh);
        return retMap;
    }

    @Override
    public List<InspectQueryVO> listInspectDaily(InspectQueryDTO dto) {
        TlUserProfile user = commonService.getCurrentUser();
        //设置权限税务机关代码
        dto.setSwjgdm(TlUtils.getPreSwjgdm(user.getSwjgDm()));
        dto.setReleaser(user.getCzryMc());
        List<InspectQueryVO> retList = tlLinkedMapper.listInspectDaily(dto);
        /**
         *  处理状态，转换为中文字段
         */
        if (!CollectionUtils.isEmpty(retList)){
            for (InspectQueryVO item : retList){
                item.setStatusName(inspectStateCode2Name(item.getStatus()));
                // 如果状态为1，并且退回次数大于0，状态中文为“已退回”
                if (ConstUtil.INSPECT_STATUS_RELEASE_YES.equals(item.getStatus()) && item.getBackCount() > 0){
                    item.setStatusName(ConstUtil.INSPECT_STATUS_NAME_BACK);
                }
            }
        }
        return retList;
    }

    @Override
    public String inspectAuth() {
        String loginName = commonService.getCurrentLoginName();
        String hasAuth = ConstUtil.WHETHER_NO;
        int count = tlLinkedMapper.countInspectDailyAuth(loginName);
        if (count > 0){
            hasAuth = ConstUtil.WHETHER_YES;
        }
        return hasAuth;
    }

    /**
     *  转换21位报关单到18位报关单
     * @param entryIds21 21位报关集合
     * @return 18位报关单集合
     */
    public List<String> transferEntryId21To18(List<String> entryIds21){
        // 18位报关单
        List<String> entryIds18 = new ArrayList<>();

        /**
         * 21为报关单转换为18位报关单
         */
        for (String entryId : entryIds21){
            entryIds18.add(entryId.substring(0,18));
        }

        if (CollectionUtils.isEmpty(entryIds18)){
            throw new BusinessException("报关单数据不合规");
        }
        // 18位报关单去重
        entryIds18 = entryIds18.stream().distinct().collect(Collectors.toList());
        return  entryIds18;
    }

    /**
     *  封装请求单证备案服务的请求
     * @param funcNo 功能号
     * @param content 请求报文
     * @param nsrsbh 操作的纳税人识别号
     * @return
     */
    public ShzsBaseDTO generateShzsBaseDTO(String funcNo,String content,String nsrsbh){
        ShzsBaseDTO baseDTO = new ShzsBaseDTO();
        baseDTO.setFuncNo(funcNo);
        baseDTO.setNsrsbh(nsrsbh);
        baseDTO.setContent(content);
        baseDTO.setTransno(UUID.randomUUID().toString());
        TlUserProfile user = commonService.getCurrentUser();
        baseDTO.setCzry(user.getCzryDm() + " " + user.getCzryMc());
        return baseDTO;
    }

    /**
     * 日常审单核查状态代码转中文
     * @param code 代码
     * @return 中文
     */
    public static String inspectStateCode2Name(String code){
        if(StringUtils.isEmpty(code)){
            return null;
        }
        if(code.equals(ConstUtil.INSPECT_STATUS_RELEASE_NOT)){
            return ConstUtil.INSPECT_STATUS_NAME_RELEASE_NOT;
        }else if(code.equals(ConstUtil.INSPECT_STATUS_RELEASE_YES)){
            return ConstUtil.INSPECT_STATUS_NAME_RELEASE_YES;
        }else if(code.equals(ConstUtil.INSPECT_STATUS_ACCEPT)){
            return ConstUtil.INSPECT_STATUS_NAME_ACCEPT;
        }else if(code.equals(ConstUtil.INSPECT_STATUS_REPORT)){
            return ConstUtil.INSPECT_STATUS_NAME_REPORT;
        }else if(code.equals(ConstUtil.INSPECT_STATUS_VERITY)){
            return ConstUtil.INSPECT_STATUS_NAME_VERITY;
        }
        return null;
    }

}
