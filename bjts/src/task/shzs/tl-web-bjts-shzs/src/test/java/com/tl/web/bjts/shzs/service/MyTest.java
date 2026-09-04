package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.cache.DictCache;
import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest
public class MyTest {
    @Autowired
    TlMyMapper tlMyMapper;
        List<String> list = new ArrayList<>();
        String[] strs = new String[]{"a","b","c"};
//        System.out.println(strs[5]);

    @Autowired
    private SbWbService sbWbService;

    @Autowired
    private SbLcslService sbLcslService;

    @Autowired
    private DictCacheService dictCacheService;

    @Autowired
    private DictCache dictCache;
    @Test
    public void shit(){

        System.out.println(dictCache.getCacheKeyloadingCache(ConstUtil.DICT_BICODE).size());
    }

//    @Test
//    public void testWbSbyy(){
//
//        FkxxWbSbyyVo sbyyVo = new FkxxWbSbyyVo();
//
//        sbyyVo.setSbid(398622L);
//        sbyyVo.setSbyy("出去吃饭了！！");
//        sbWbService.writeBackSbyyInfo(sbyyVo);
//    }
//
//    @Test
//    public void lalala(){
//        sbLcslService.writeBackLcslid(378412L,"dsfsdfsdfdsfdsfsfsf","01kfxy");
//    }
//
//    @Autowired
//    private TlTsshMapper tlTsshMapper;
//    @Test
//    public void testGetFpxx(){
//        FpxxVo  vo= tlTsshMapper.getFpxx("310013314013455607");
//
//            System.out.println(vo);
//
////        System.out.println(tlTsshMapper.getHwxx("310013314013455607"));
//    }
//
//    @Test
//    public void testGetBgd(){
//        BgdVo vo= tlTsshMapper.getBgdInfo("292120160216826303");
//        vo= tlTsshMapper.getBgdInfo("292120160216826303");
//        System.out.println(vo);
//    }
//
//    @Test
//    public void testCkAndJh(){
//
//        LdlpParamVo param = new LdlpParamVo();
//        param.setLdlpNo("2017050001");
//        param.setSbid(398040L);
//        List<TsckVo> vos = tlMyMapper.getTsckInfo(param);
//        for(TsckVo vo : vos){
//            String bgdNo = vo.getBgdNo();
//            bgdNo = bgdNo.substring(0,18);
//            System.out.println(bgdNo);
//            BgdVo bgdVo= tlTsshMapper.getBgdInfo(bgdNo);
//            vo.setBgdInfo(bgdVo);
//        }
//        List<TsjhVo> vos2 = tlMyMapper.getTsjhInfo(param);
//        System.out.println(666);
//    }

}
