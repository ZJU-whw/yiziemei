package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.dto.BaseIdDTO;
import com.tl.web.bjts.shzs.model.dto.dzhc.*;
import com.tl.web.bjts.shzs.model.vo.IdVO;
import com.tl.web.bjts.shzs.model.vo.dzhc.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @描述: 日常审单核查服务接口
 * @作者: likun
 * @时间: 2022/4/22 16:43
 */
@Service
public interface IInspectService {
    /**
     * 校验出口业务审单核查状态
     * @param dto ShzsInspectStateCheckDTO
     * @return List<ShzsInspectStateCheckVO>
     */
    List<ShzsInspectStateCheckVO> inspectStateCheck(ShzsInspectStateCheckDTO dto);

    /**
     *  查看日常审单核查业务
     * @param dto BaseIdDTO
     * @return
     */
    InspectTaskOpenVO inspectBusinessView(BaseIdDTO dto);

    /**
     * 获取出口业务数据
     * @param dto InspectBusinessAvailableDTO
     * @return
     */
    List<InspectBusinessAvailableVO> listInspectBusinessAvailable(InspectBusinessAvailableDTO dto);

    /**
     * 获取单证类型树
     * @return
     */
    List<InspectTreeVO> inspectTree(InspectTreeDTO dto);

    /**
     * 生成日常审单核查任务
     * @param dto InspectTaskAddDTO
     * @return
     */
    List<IdVO> inspectBusinessAdd(InspectTaskAddDTO dto);

    /**
     * 日常审单核查-批量下达
     * @param dto DailyReleaseBatchDTO
     */
    void releaseBatchDailyBusiness(DailyReleaseBatchDTO dto);

    /**
     * 获取管理系统域名
     * @return
     */
    String getGlxtUrl();

    /**
     * 校验管理系统登录状态
     * @return
     */
    String checkGlxtLoginState();

    /**
     *  登录管理系统
     * @param loginName 登录名
     */
    void loginGlxt(String loginName);

    /**
     *  获取操作人员信息
     * @return
     */
    Map getCzryInfo();

    /**
     * 查询日常审单核查列表
     * @param dto InspectQueryDTO
     * @return
     */
    List<InspectQueryVO> listInspectDaily(InspectQueryDTO dto);

    /**
     * 校验操作员是否有日常审单核查权限
     * @return Y：有 N:没有
     */
    String inspectAuth();

}
