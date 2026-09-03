package com.tl.bjts.sw.service;

import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.domain.TjbbReportItem;
import com.tl.bjts.sw.model.domain.TjbbTaskModel;
import com.tl.bjts.sw.model.domain.VirtualSwjgModel;
import com.tl.bjts.sw.model.dto.VirSwjgDTO;
import com.tl.bjts.sw.model.dto.VirTjbbDTO;
import com.tl.bjts.sw.model.vo.TjbbTaskVo;
import com.tl.bjts.sw.model.vo.VirSwjgVo;
import com.tl.bjts.swgl.general.util.AesUtil;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.util.CollectionUtils;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/6/6.
 * @Description:
 */
@Service
public class VirSwjgService{

    private org.slf4j.Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    VirtualSwjgModelMapper virtualSwjgModelMapper;

    @Autowired
    TlMapper tlMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    private TjbbTaskModelMapper tjbbTaskModelMapper;

    @Autowired
    private TjbbReportItemMapper tjbbReportItemMapper;

    public void saveVirSwjg(VirSwjgDTO virSwjgDTO) {

        String swjgmc = virSwjgDTO.getVirName();
        if(StringUtils.isBlank(swjgmc)){
            throw new BusinessException("虚拟税务机关名称");
        }

        List<VirSwjgDTO.SubSwjg> subSwjgs = virSwjgDTO.getSublist();


        VirtualSwjgModel vir=new VirtualSwjgModel();
        vir.setSwjgDm(commonService.getCurrentUser().getSwjgDm());
        vir.setVirFlag("1");
        vir.setYxbz("Y");
        vir.setVirName(swjgmc);
        vir.setVirSwjgdm(genVirSwjgdm());
        virtualSwjgModelMapper.insert(vir);

        for (VirSwjgDTO.SubSwjg swjg : subSwjgs) {
            VirtualSwjgModel sub=new VirtualSwjgModel();

            sub.setVirSwjgdm(swjg.getSwjgdm());
            sub.setVirName(swjg.getSwjgmc());
            sub.setYxbz("Y");
            sub.setVirFlag("0");
            sub.setSwjgDm(vir.getVirSwjgdm());
            virtualSwjgModelMapper.insert(sub);
        }

    }

    private String genVirSwjgdm() {
        //虚拟机关代码=2+所属税务机关的2至5位+顺序号（共2位前补0）+4个0
        StringBuffer buffer = new StringBuffer("2");

        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        buffer.append(swjgDm.substring(1,5));

        String xh = tlMapper.getVirSwjgdmXh(swjgDm);
        buffer.append(xh.trim());
        buffer.append("0000");

        return buffer.toString();
    }

    public void saveVirSwjgQybz(VirSwjgDTO virSwjgDTO) {

        if(StringUtils.isBlank(virSwjgDTO.getYxbz())
                ||StringUtils.isBlank(virSwjgDTO.getVirSwjgdm())){
            throw new BusinessException("参数错误");
        }

        VirtualSwjgModel vir=new VirtualSwjgModel();
        vir.setYxbz(virSwjgDTO.getYxbz());
        vir.setVirSwjgdm(virSwjgDTO.getVirSwjgdm());
        vir.setSwjgDm(commonService.getCurrentUser().getSwjgDm());

        virtualSwjgModelMapper.updateByPrimaryKeySelective(vir);


    }

    @Transactional
    public void saveVirSwjgUpdate(VirSwjgDTO virSwjgDTO) {

        String virSwjgdm = virSwjgDTO.getVirSwjgdm();
        if(StringUtils.isBlank(virSwjgdm)){
            throw new BusinessException("参数错误");
        }

        VirtualSwjgModel vir=new VirtualSwjgModel();
        vir.setVirSwjgdm(virSwjgdm);
        vir.setSwjgDm(commonService.getCurrentUser().getSwjgDm());
        vir.setVirName(virSwjgDTO.getVirName());

        int i = virtualSwjgModelMapper.updateByPrimaryKeySelective(vir);
        if(i==0){
            return;
        }

        VirtualSwjgModel dels=new VirtualSwjgModel();
        dels.setSwjgDm(virSwjgdm);
        virtualSwjgModelMapper.delete(dels);


        List<VirSwjgDTO.SubSwjg> subSwjgs = virSwjgDTO.getSublist();

        if(CollectionUtils.isEmpty(subSwjgs)){
            return;
        }

        for (VirSwjgDTO.SubSwjg swjg : subSwjgs) {
            VirtualSwjgModel sub=new VirtualSwjgModel();

            sub.setVirSwjgdm(swjg.getSwjgdm());
            sub.setVirName(swjg.getSwjgmc());
            sub.setYxbz("Y");
            sub.setVirFlag("0");
            sub.setSwjgDm(virSwjgdm);
            virtualSwjgModelMapper.insert(sub);
        }

    }

    public List<VirSwjgVo> virSwjgList() {
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        Example ep=new Example(VirtualSwjgModel.class);
        ep.createCriteria().andEqualTo("swjgDm",swjgDm);
        ep.orderBy("virSwjgdm");
        List<VirtualSwjgModel> models = virtualSwjgModelMapper.selectByExample(ep);

        List<VirSwjgVo> retList=new ArrayList<>();
        for (VirtualSwjgModel model : models) {
            VirSwjgVo vo=new VirSwjgVo();
            BeanUtils.copyProperties(model,vo);

            String virSwjgdm = model.getVirSwjgdm();
            VirtualSwjgModel p=new VirtualSwjgModel();
            p.setSwjgDm(virSwjgdm);
            p.setYxbz("Y");
            List<VirtualSwjgModel> select = virtualSwjgModelMapper.select(p);

            List<VirSwjgVo.SubSwjg> sublist = new ArrayList<>();
            for (VirtualSwjgModel swjgModel : select) {
                VirSwjgVo.SubSwjg subSwjg=new VirSwjgVo.SubSwjg();
                subSwjg.setSwjgdm(swjgModel.getVirSwjgdm());
                subSwjg.setSwjgmc(swjgModel.getVirName());
                sublist.add(subSwjg);
            }

            vo.setSublist(sublist);

            retList.add(vo);
        }

        return retList;
    }

    @Transactional
    public void createTask(VirTjbbDTO tjbbDTO) {

        TjbbReportItem param=new TjbbReportItem();
        param.setType("1");
        List<TjbbReportItem> items = tjbbReportItemMapper.select(param);
        for (TjbbReportItem reportItem : items) {

            TjbbTaskModel obj=new TjbbTaskModel();
            obj.setNy(tjbbDTO.getSsny());
            obj.setBbdldm(reportItem.getBbdldm());
            obj.setSwjgdm(tjbbDTO.getVirSwjgdm());
            obj.setSjswjg(tjbbDTO.getVirSwjgdm());
            obj.setType("2");

            List<TjbbTaskModel> select = tjbbTaskModelMapper.select(obj);
            if(!select.isEmpty()){
                throw new BusinessException("报表任务已存在");
            }

            obj.setStatus("00");
            obj.setCjtime(new Date());
            obj.setCjr(tjbbDTO.getVirSwjgdm());
            obj.setSwjgmc(tjbbDTO.getVirName());
            obj.setSwjgjc(tjbbDTO.getVirName());

            tjbbTaskModelMapper.insert(obj);
        }
    }


    public PageInfo getTjbbTaskReceive(String ssny, String bbdldm, String swjgdm) {

        List<TjbbTaskVo> retList=new ArrayList<>();

        List<TjbbTaskModel> select=tlMapper.selectVirReceiveTask(ssny,swjgdm,bbdldm);

        PageInfo pageInfo = new BaseController().dealPageInfo(select);

        for(TjbbTaskModel model:select){
            TjbbTaskVo tjbbTaskVo=new TjbbTaskVo();
            BeanUtils.copyProperties(model,tjbbTaskVo);

            retList.add(tjbbTaskVo);
        }

        pageInfo.setRows(retList);

        return pageInfo;
    }

    public void delVirSwjg(VirSwjgDTO virSwjgDTO) throws Exception {
        String encryptVirSwjgdm = AesUtil.getTrullyEncrypt(virSwjgDTO.getVirSwjgdm());
        String virSwjgdm = AesUtil.decrypt(encryptVirSwjgdm);
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        VirtualSwjgModel vir=new VirtualSwjgModel();
        vir.setVirSwjgdm(virSwjgdm);
        vir.setSwjgDm(swjgDm);

        int i = virtualSwjgModelMapper.delete(vir);

        if(i==1){
            vir=new VirtualSwjgModel();
            vir.setSwjgDm(virSwjgdm);
            virtualSwjgModelMapper.delete(vir);
        }
    }
}
