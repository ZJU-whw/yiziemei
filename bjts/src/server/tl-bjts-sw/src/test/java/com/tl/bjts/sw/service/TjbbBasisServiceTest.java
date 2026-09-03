package com.tl.bjts.sw.service;

import com.google.common.collect.ImmutableMap;
import com.google.gson.Gson;
import com.tl.bjts.sw.dao.TlSjjcMapper;
import com.tl.bjts.sw.model.vo.MenuVo;
import com.tl.bjts.sw.model.vo.TjbbRecvMainVo;
import com.tl.bjts.sw.model.vo.jcfx.FzHzInitVo;
import com.tl.bjts.sw.model.vo.sbxx.BgdMainVO;
import com.tl.bjts.sw.model.vo.sbxx.BgdMxVO;
import com.tl.bjts.sw.service.impl.SbxxServiceImpl;
import com.tl.bjts.sw.utils.TlCalculateUtils;
import com.tl.common.ext.utils.BaseController;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
@SpringBootTest
public class TjbbBasisServiceTest {


    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TjbbBasisService basisService;


    @Test
    public void loadMenu() throws Exception {
        //MenuVo menuVo = basisService.loadMenu();
        logger.info("11111");
        FzHzInitVo fzHzInit = basisService.getFzHzInit();
        logger.info(new Gson().toJson(fzHzInit));
    }

    @Autowired
    SbxxServiceImpl sbxxService;

    @Test
    public void getTjbbRecvMain() throws Exception {

       // String b01101 = basisService.repleaceFormual("B01101", "2=4+8+12+16");

       // Map<String, Object> stringObjectMap = testService.executeSql("select a.*,b.*,a.swjg_dm as \"单位代码\" from dm_swjg a,dm_swjg_virtual  b where a.swjg_dm = b.swjg_dm");

        //System.out.println(stringObjectMap);

        BgdMainVO bgdInfo = sbxxService.getBgdInfo("320123320240310007", "10113301000046702321");


        System.out.println(bgdInfo.toString());

    }





}