package com.tl.web.bjts.shzs.service.impl;

import com.google.gson.Gson;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.TlDateUtils;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.controller.TLBaseController;
import com.tl.web.bjts.shzs.dao.ShzsWpSwryProfileMapper;
import com.tl.web.bjts.shzs.dao.ShzsWpTaskProfileMapper;
import com.tl.web.bjts.shzs.dao.TlJsxtMapper;
import com.tl.web.bjts.shzs.dao.TlLinkedMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.model.domain.ShzsWpSwryProfile;
import com.tl.web.bjts.shzs.model.domain.ShzsWpTaskProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbrwmxVo;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbwpDTO;
import com.tl.web.bjts.shzs.model.dto.dbwp.LoggeQueryDTO;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpResultVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpSlVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.LcswsxVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.SwryVo;
import com.tl.web.bjts.shzs.service.IDbwpService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.math.BigDecimal;
import java.util.*;

/**
 * @description 待办委派任务服务
 * @author: Mamf
 * @date: 2024/9/18 14:05
 */
@Service
public class DbwpServiceImpl implements IDbwpService{

    private static final Logger LOGGER = LoggerFactory.getLogger(DbwpServiceImpl.class);

    @Autowired
    TlJsxtMapper tlJsxtMapper;

    @Autowired
    TlLinkedMapper tlLinkedMapper;

    @Autowired
    ShzsWpTaskProfileMapper shzsWpTaskProfileMapper;

    @Autowired
    AppProperties appProperties;

    @Autowired
    ShzsWpSwryProfileMapper wpSwryProfileMapper;

    @Override
    public DbwpSlVo getDbwpTaskNum(ShzsWpSwryProfile swryProfile) {


        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);

            String sfswjgDm = swryProfile.getSfswjgdm();
            if(StringUtils.isEmpty(sfswjgDm)){
                return null;
            }
            String xndbrdm = "@"+sfswjgDm+"#"+appProperties.getZjgwdm();

            DbwpSlVo dbwpSlVo = new DbwpSlVo();
            dbwpSlVo.setGwdbsl(tlJsxtMapper.countGwdbsl(xndbrdm));

            String gwxh = swryProfile.getGwxh();
            String sfdm = swryProfile.getSfdm();
            dbwpSlVo.setGrdbsl(tlJsxtMapper.countGrdbsl(gwxh,sfdm));
            dbwpSlVo.setGrzbsl(tlJsxtMapper.countGrzbsl(gwxh,sfdm));

            return dbwpSlVo;
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }

    }

    @Override
    public PageInfo getDbrwmx(DbwpDTO dbwpDTO, ShzsWpSwryProfile swryProfile) {

        PageInfo<List<DbrwmxVo>> pageInfo;
        TLBaseController baseController = new TLBaseController();
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            if("0".equals(dbwpDTO.getType())){
                String xndbrdm = "@"+swryProfile.getSfswjgdm()+"#"+appProperties.getZjgwdm();
                TLBaseController.setPageParam(dbwpDTO);

                List<String> lcswsxdms = null;
                if(!StringUtils.isEmpty(dbwpDTO.getLcswsxdm())){
                    String[] split = dbwpDTO.getLcswsxdm().split(",");
                    lcswsxdms=Arrays.asList(split);
                }

                Date sbrqZ=null;
                if(dbwpDTO.getSbrqZ()!=null){
                    sbrqZ = TlDateUtils.addDay(dbwpDTO.getSbrqZ(), 1);
                }
                LOGGER.info("xndbrdm:{},param:{}",xndbrdm,new Gson().toJson(dbwpDTO));
                pageInfo = baseController.dealPageInfo(tlJsxtMapper.queryGwdbmx(xndbrdm,lcswsxdms,dbwpDTO.getQybs(),dbwpDTO.getSbrqQ(),sbrqZ));
            }else{
                String gwxh = swryProfile.getGwxh();
                LOGGER.info("sfdm:{},gwxh:{}",swryProfile.getSfdm(),gwxh);
                TLBaseController.setPageParam(dbwpDTO);
                if("1".equals(dbwpDTO.getType())){
                    return baseController.dealPageInfo(tlJsxtMapper.queryGrdbmx(gwxh,swryProfile.getSfdm()));
                }else {
                    return baseController.dealPageInfo(tlJsxtMapper.queryGrzbmx(gwxh, swryProfile.getSfdm()));
                }
            }
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
        LOGGER.info("获取到数据"+pageInfo.getRows().size()+"条");
        fillWpResult(pageInfo.getRows());
        //填充委派结果信息
        return pageInfo;
    }

    private void fillWpResult(List<DbrwmxVo> dbrwmxVos) {

        for (DbrwmxVo dbrwmxVo : dbrwmxVos) {
            String rwmc = dbrwmxVo.getRwmc();
            String[] split = rwmc.split("-");
            dbrwmxVo.setLcswsxMc(split[0]);
            if(split.length==4){
                dbrwmxVo.setLzhj(split[1].substring(split[1].length()-2));
            }else {
                dbrwmxVo.setLzhj("");
            }
        }
    }

    @Override
    public List<SwryVo> getSwryBySwjg(String swjgDm, String gwxh) {

        LOGGER.info("swjgDm:{},gwxh:{}",swjgDm,gwxh);
        return tlJsxtMapper.querySwrysFromShzs(swjgDm,gwxh);
    }

    @Override
    public void fillSwryStatus(List<SwryVo> swryVos) {
        for (SwryVo swryVo : swryVos) {
            swryVo.setIsOnline(!"0".equals(swryVo.getStatus()));
        }
    }

    @Override
    public void dbswryUpdateStatus(DbwpDTO dbwpDTO, String gwxh) {

        tlJsxtMapper.updateDbswryStatus(dbwpDTO.getSfdm(),gwxh,dbwpDTO.getStatus());
    }

    @Override
    @Transactional
    public List<DbwpResultVo> submitAutoDbwp(List<DbrwmxVo> wpMxs, String swjgDm, TlUserProfile currentUser) {

        List<DbwpResultVo> retList = new ArrayList<>();

        for (DbrwmxVo wpMx : wpMxs) {
            if(StringUtils.isEmpty(wpMx.getGzxid())){
                continue;
            }

            Map<String,Object> result = tlJsxtMapper.selectAutoDbrwwp(swjgDm,appProperties.getZjgwdm(),wpMx.getNsrsbh(),wpMx.getLcswsxDm());

            DbwpResultVo dbwpResultVo = new DbwpResultVo();
            dbwpResultVo.setGzxid(wpMx.getGzxid());
            String error = (String)result.get("ERRMSG");
            if(StringUtils.isNotEmpty(error)){
                dbwpResultVo.setErrorMsg(error);
                continue;
            }

            dbwpResultVo.setWpsfdm((String)result.get("WPDXSFDM"));
            dbwpResultVo.setWpdx((String)result.get("WPDXMC"));
            dbwpResultVo.setWpdxqyfz((String)result.get("QYFZMC"));
            dbwpResultVo.setJdmode((String)result.get("JDMODE"));
            dbwpResultVo.setGwdm(appProperties.getZjgwdm());

            ShzsWpSwryProfile swryProfile = getWpswryBySfdm(appProperties.getZjgwdm(), dbwpResultVo.getWpsfdm());
            dbwpResultVo.setSwrydm(swryProfile.getSwrydm());
            dbwpResultVo.setSfswjgdm(swryProfile.getSfswjgdm());

            String xndbrdm = "@"+swryProfile.getSfswjgdm()+"#"+appProperties.getZjgwdm();
            dbwpResultVo.setXndbrdm(xndbrdm);


            retList.add(dbwpResultVo);

            //初始化任务表
            ShzsWpTaskProfile taskProfile = new ShzsWpTaskProfile();
            taskProfile.setId(dbwpResultVo.getGzxid());
            taskProfile.setStatus("0");
            taskProfile.setWpr(currentUser.getCzryMc());
            shzsWpTaskProfileMapper.delete(taskProfile);

            taskProfile.setJdmode(dbwpResultVo.getJdmode());
            taskProfile.setWpdxqyfz(dbwpResultVo.getWpdxqyfz());
            taskProfile.setWpdx(dbwpResultVo.getWpdx());
            taskProfile.setWpsfdm(dbwpResultVo.getWpsfdm());

            taskProfile.setSwsxdm(wpMx.getLcswsxDm());
            taskProfile.setNsrsbh(wpMx.getNsrsbh());
            taskProfile.setNsrmc(wpMx.getNsrmc());
            taskProfile.setLcslid(wpMx.getLcslid());
            taskProfile.setSwjgdm(currentUser.getSwjgDm());
            taskProfile.setSbrq(wpMx.getRwfqsj());
            taskProfile.setWpsj(new Date());

            try {
                shzsWpTaskProfileMapper.insertSelective(taskProfile);
            } catch (Exception e) {
                shzsWpTaskProfileMapper.updateByPrimaryKeySelective(taskProfile);
            }

        }

        return retList;
    }


    @Override
    public List<ShzsWpTaskProfile> initTaskProfiles(List<ShzsWpTaskProfile> mxs, TlUserProfile userProfile) {


        List<ShzsWpTaskProfile> profiles;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            profiles = new ArrayList<>();
            for (ShzsWpTaskProfile mx : mxs) {
                ShzsWpTaskProfile model = new ShzsWpTaskProfile();
                model.setId(mx.getId());

                DbrwmxVo dbrwmx = tlJsxtMapper.queryGwdbmxById(mx.getId());

                model.setNsrmc(dbrwmx.getNsrmc());
                model.setNsrsbh(dbrwmx.getNsrsbh());
                model.setSbrq(dbrwmx.getRwfqsj());
                model.setSsqpc(dbrwmx.getSssq());
                model.setSwjgdm(userProfile.getSwjgDm());
                model.setWpr(userProfile.getCzryDm());
                model.setSwsxdm(dbrwmx.getLcswsxDm());
                model.setWpsj(new Date());
                model.setLcslid(dbrwmx.getLcslid());

                profiles.add(model);
            }
            return profiles;
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }

    }

    @Override
    public void writebackWpResult(List<ShzsWpTaskProfile> results, String czryMc) {

        for (ShzsWpTaskProfile result : results) {

            ShzsWpTaskProfile p = new ShzsWpTaskProfile();
            p.setWpjg(result.getWpjg());
            p.setStatus("1");

            Example ep = new Example(ShzsWpTaskProfile.class);
            Example.Criteria criteria = ep.createCriteria();
            criteria.andEqualTo("id",result.getId());
            criteria.andEqualTo("wpr",czryMc);

            shzsWpTaskProfileMapper.updateByExampleSelective(p,ep);
        }

    }


    @Override
    public ShzsWpSwryProfile getWpswry(String gwdm,String czryDm){
        ShzsWpSwryProfile p = new ShzsWpSwryProfile();
        p.setGwdm(gwdm);
        p.setSwrydm(czryDm);

        return wpSwryProfileMapper.selectOne(p);
    }

    private ShzsWpSwryProfile getWpswryBySfdm(String gwdm,String sfdm){
        ShzsWpSwryProfile p = new ShzsWpSwryProfile();
        p.setGwdm(gwdm);
        p.setSfdm(sfdm);

        return wpSwryProfileMapper.selectOne(p);
    }

    @Override
    public List<LcswsxVo> selectLcswsxList(ShzsWpSwryProfile swryProfile) {
        String sfswjgDm = swryProfile.getSfswjgdm();
        if(StringUtils.isEmpty(sfswjgDm)){
            return null;
        }
        String xndbrdm = "@"+sfswjgDm+"#"+appProperties.getZjgwdm();
        try{
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            return tlJsxtMapper.selectLcswsxList(xndbrdm);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    @Override
    public List queryLoggerList(LoggeQueryDTO loggeQueryDTO, String swjgDm) {
        if(loggeQueryDTO.getWpsjEnd()!=null){
            loggeQueryDTO.setWpsjEnd(TlDateUtils.addDay(loggeQueryDTO.getWpsjEnd(),1));
        }
        return tlLinkedMapper.queryLoggerList(loggeQueryDTO,swjgDm);
    }

    @Override
    public List<LcswsxVo> selectAllLcswsxList() {
        return tlJsxtMapper.selectAllLcswsxList();
    }
}
