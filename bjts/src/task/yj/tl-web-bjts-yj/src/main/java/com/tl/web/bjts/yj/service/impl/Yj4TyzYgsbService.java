package com.tl.web.bjts.yj.service.impl;

import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.datasource.TargetDataSource;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.vo.YjxxNewVo;
import com.tl.web.bjts.yj.model.vo.YjxxVo;
import com.tl.web.bjts.yj.model.vo.YjzbItemVo;
import com.tl.web.bjts.yj.service.IYjService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2017/12/29.
 * @Description:
 */
@Service
public class Yj4TyzYgsbService extends IYjService{

    @Autowired
    YjMapper yjMapper;

    @Autowired
    Yj4TssbService yj4TssbService;


    @Override
    protected void executeNewYjProcess(TaskVo ysxx, Map<String, String> swjgYjDicCodeMap, Map<String, YjzbItemVo> yjzbItemMap, Map yjBmdMap, Map<String, Long> tbpcMap) {
        yj4TssbService.executeNewYjProcess(ysxx, swjgYjDicCodeMap, yjzbItemMap, yjBmdMap, tbpcMap);
    }

    @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx, String zbcode) {
        return null;
    }
}
