package com.tl.web.bjts.shzs.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.UpdateVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 说明：升级Controllers
 * 作者：王兆阳
 * 日期：2017-07-25
 **/

@RestController
@RequestMapping("/update")
public class MyUpdateController {
    @Autowired
    AppProperties appProperties;

    /**
     * 声明日志
     */
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @RequestMapping("ver")
    public SimpleResult ver() throws Exception{
        SimpleResult rtn = new SimpleResult();
        try{
            List<UpdateVo> list = new Gson().fromJson(appProperties.readUpdateIni(),
                    new TypeToken<List<UpdateVo>>(){}.getType());
            rtn.setData(list);
        }catch (Exception e){
            LOGGER.error("MyUpdateController ver:"+e.getMessage());
        }

        return rtn;
    }
}
