package com.tl.web.bjts.shzs.controller;

import com.tl.web.bjts.shzs.model.SimpleResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 说明：模版下载控制器
 * 作者：王兆阳
 * 日期：2017-05-04
 **/
@RestController
@RequestMapping("/template")
public class TemplateController {


    /**
     * 声明日志
     */
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @RequestMapping("ver")
    public SimpleResult ver() throws Exception{
        SimpleResult rtn = new SimpleResult();

        return rtn;
    }

}
