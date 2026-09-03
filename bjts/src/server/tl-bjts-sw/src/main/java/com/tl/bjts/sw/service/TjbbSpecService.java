package com.tl.bjts.sw.service;

import com.tl.bjts.sw.dao.TjbbReportItemMapper;
import com.tl.bjts.sw.dao.TlSWJGProfileMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.model.TjbbCzLogCode;
import com.tl.bjts.sw.model.domain.TjbbReportItem;
import com.tl.bjts.sw.model.domain.TjbbTaskModel;
import com.tl.bjts.sw.model.domain.TlSWJGProfile;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.model.dto.TjbbTaskDTO;
import com.tl.bjts.sw.utils.TlUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/4/12
 * @description 统计报表特殊服务
 */
@Service
public class TjbbSpecService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private TjbbBasisService tjbbBasisService;

    @Autowired
    TlSWJGProfileMapper tlSWJGProfileMapper;

    @Autowired
    TjbbReportItemMapper tjbbReportItemMapper;

    /**
     * 对B03制表代码报表进行初始化制表操作
     * @param sbqb
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void autoMakeTjbbInit(String sbqb) {

        String  sjSwjg=null;
        List<String> dsSwjgdms= new ArrayList<>();
        List<String> xjSwjgdms= new ArrayList<>();

        TlSWJGProfile p=new TlSWJGProfile();
        p.setTsjgBz("1");
        List<TlSWJGProfile> swjgProfiles = tlSWJGProfileMapper.select(p);

        for (TlSWJGProfile profile : swjgProfiles) {
            int qxdmLen = TlUtils.getPreSwjgdm(profile.getSwjgDm()).length();
            if(qxdmLen==3){
                sjSwjg =  profile.getSwjgDm();
            }else if (qxdmLen==5){
                dsSwjgdms.add(profile.getSwjgDm());
            }else if (qxdmLen==7){
                xjSwjgdms.add(profile.getSwjgDm());
            }
        }


        TjbbReportItem param=new TjbbReportItem();
        param.setBbdldm("B03");
        List<TjbbReportItem> items = tjbbReportItemMapper.select(param);

        for(TjbbReportItem reportItem:items){

            TjbbTaskDTO tjbbTaskDTO=new TjbbTaskDTO();
            tjbbTaskDTO.setBbdldm(reportItem.getBbdldm());
            tjbbTaskDTO.setSsny(sbqb);

            //1.县局制表
            for (String swjgdm : xjSwjgdms) {
                makeTjbb(tjbbTaskDTO,swjgdm);
            }

            //2.地市局制表
            for (String swjgdm : dsSwjgdms) {
                makeTjbb(tjbbTaskDTO,swjgdm);
            }

            //3.省局制表
            makeTjbb(tjbbTaskDTO,sjSwjg);

        }

    }


    private void makeTjbb(TjbbTaskDTO dto,String swjgdm){
        try {
            int length = TlUtils.getPreSwjgdm(swjgdm).length();
            TlUserProfile userProfile=new TlUserProfile();
            userProfile.setSwjgDm(swjgdm);
            userProfile.setCzryMc("系统生成");
            //省局和市局进行汇总操作
            if(length<=5){
                tjbbBasisService.makeHzTjbb(dto,userProfile);
            }else { //县局，第三分局进行制表操作
                tjbbBasisService.makeTjbb(dto,userProfile);
            }
        } catch (Exception e) {
            logger.error("{}-自动制表B03发生错误",swjgdm,e);
        }

    }
}
