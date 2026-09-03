package com.tl.bjts.sw.service;

import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.RwglYbclXxzbModel;
import com.tl.bjts.sw.model.dto.RwglYbclAfterDTO;
import com.tl.bjts.sw.model.dto.RwglYbclBeforeDTO;
import com.tl.bjts.sw.model.dto.TjfxMainDTO;

/**
 * 描述:任务处理-异步处理接口
 * 作者 likun
 * 时间 2020-05-11 11:32
 */
public interface RwglYbclService {
    /**
     * 后置服务执行者
     * 修改任务管理信息总表的任务状态等
     * @param dto
     * @return
     */
    int afterServerExecutor(RwglYbclAfterDTO dto);

    /**
     * 封装后置服务需要的参数
     * @param dto
     */
    void addAfterServiceParam(RwglYbclAfterDTO dto, SimpleResult result);

    /**
     * 封装后置服务需要的参数
     * @param dto
     */
//    void packageAfterServerParam(TjfxMainDTO dto, SimpleResult result);

    /**
     * 前置服务执行者
     * @param dto
     */
    void beforeServerExecutor(RwglYbclBeforeDTO dto);

    /**
     * 删除异步任务
     * @param dto
     * @return
     */
    int deleteRwglYbcl(RwglYbclAfterDTO dto);

    /**
     * 根据任务类型和任务hash获取任务对象
     * @param param
     * @return
     */
    public RwglYbclXxzbModel getRwglYbclByPk(RwglYbclXxzbModel param);

}
