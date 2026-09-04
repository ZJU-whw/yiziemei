package com.tl.web.bjts.shzs.service;


import com.tl.web.bjts.shzs.dao.TlShSbxxHzProfileMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-05-10
 **/
@Service
public class MyService {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    /**
     *通过如下方法注解获取RPC实例
    @MotanReferer
    IUserService userService;
     */

    @Autowired
    private TlShSbxxHzProfileMapper tlShSbxxHzProfileMapper;

    //Add your code

    public void test(){

    }
}
