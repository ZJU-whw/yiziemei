package com.tl.bjts.sw.service;

import com.github.pagehelper.Page;
import com.google.zxing.WriterException;
import com.tl.bjts.sw.annotation.QrField;
import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.bo.CkllfxQrDataFieldV1BO;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.enu.CpysEnum;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.model.vo.yjzb.ZbSelectVO;
import com.tl.bjts.sw.utils.PoiExcelUtil;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.ext.utils.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import com.github.pagehelper.PageHelper;
import com.tl.bjts.sw.dao.TlYjMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.model.domain.YjDicModel;
import com.tl.bjts.sw.model.vo.YjCsBmdModelVo;
import com.tl.bjts.sw.model.vo.YjDicModelVo;
import com.tl.bjts.sw.model.vo.YjDicYjzbModelVo;
import com.tl.bjts.sw.model.vo.YjPfxxListVO;
import com.tl.bjts.sw.model.vo.YjPfxxVO;
import com.tl.bjts.sw.model.vo.YjZhcxListVO;
import com.tl.bjts.sw.model.dto.CkllfxListDTO;
import com.tl.bjts.sw.model.vo.CkllfxListVO;
import com.tl.bjts.sw.model.bo.CkllfxQrDataBO;
import com.tl.bjts.sw.model.dto.CkllfxQrDTO;
import com.tl.bjts.sw.model.vo.CkllfxQrVO;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.utils.TlConst;
import com.tl.common.ext.utils.QrCodeUtils;
import com.tl.common.ext.utils.TlDateUtils;

import com.tl.common.ext.model.PageInfo;
import org.springframework.aop.framework.AopContext;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;
import org.apache.commons.lang3.StringUtils;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class YjService {

    private static final Logger LOGGER = LoggerFactory.getLogger(YjService.class);

    @Autowired
    YjCsBmdModelMapper yjCsBmdModelMapper;

    @Autowired
    YjCsBmdSubModelMapper yjCsBmdSubModelMapper;

    @Autowired
    YjDicSwjgModelMapper yjDicSwjgModelMapper;

    @Autowired
    YjzbSwjgModelMapper yjzbSwjgModelMapper;

    @Autowired
    YjCsMgkaWmModelMapper yjCsMgkaWmModelMapper;

    @Autowired
    YjCsMgspModelMapper yjCsMgspModelMapper;

    @Autowired
    YjCsMgkaScModelMapper yjCsMgkaScModelMapper;

    @Autowired
    YjCsYcghqyModelMapper yjCsYcghqyModelMapper;

    @Autowired
    YjCsYchdModelMapper yjCsYchdModelMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    private TlYjMapper tlYjMapper;

    @Autowired
    private CommonUtils commonUtils;

    @Autowired
    private YjBgdgzxxGcbModelMapper yjBgdgzxxGcbModelMapper;

    @Autowired
    private YjBgdgzxxJgbModelMapper yjBgdgzxxJgbModelMapper;

    @Autowired
    private YjBgdgzxxMapper yjBgdgzxxMapper;

    @Autowired
    private YjCsFxbghModelMapper yjCsFxbghModelMapper;

    @Autowired
    private AppProperties appProperties;

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<MgkaWmVo> wmmgka(WmMgkaDTO dto) {
        Example p=new Example(YjCsMgkaWmModel.class);
        Example.Criteria criteria = p.createCriteria();
        if(dto.getJkDate()!=null) {
            criteria.andLessThanOrEqualTo("qsrq",dto.getJkDate());
            criteria.andGreaterThanOrEqualTo("jzrq",dto.getJkDate());
        }
        if(dto.getKaCode()!=null && !"".equals(dto.getKaCode())) {
            criteria.andLike("kacode", "%"+dto.getKaCode()+"%");
        }
        if(dto.getKaName()!=null &&! "".equals(dto.getKaName())) {
            criteria.andLike("kaname", "%"+dto.getKaName()+"%");
        }
        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String qxdm= TlUtils.getPreSwjgdm(swjgDm);
        criteria.andLike("swjgfw",qxdm+"%");
        List<YjCsMgkaWmModel> list=yjCsMgkaWmModelMapper.selectByExample(p);
        Page<MgkaWmVo> retlist=new Page<>();
        for(YjCsMgkaWmModel vo:list){
            MgkaWmVo wmMgkVo=new MgkaWmVo();
            BeanUtils.copyProperties(vo,wmMgkVo);

            wmMgkVo.setLrswjgdm(commonService.getSwjgMc(vo.getLrswjgdm()).getSwjgjc());
            retlist.add(wmMgkVo);
        }
        if(dto.getExport()){
            return retlist;
        }
        Page list1 = (Page) list;
        BeanUtils.copyProperties(list1,retlist);

        return retlist;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void saveMgka(MgkaWmVo dto) {
        YjCsMgkaWmModel yjCsMgkaWmModel=new YjCsMgkaWmModel();
        if(dto.getQsrq()!=null&&dto.getJzrq()!=null) {
            if (dto.getQsrq().after(dto.getJzrq())) {
                throw new BusinessException("起始日期不可大于截止日期");
            }
        }
        BeanUtils.copyProperties(dto,yjCsMgkaWmModel);
        yjCsMgkaWmModel.setLrr(commonService.getCurrentUser().getCzryMc());
        yjCsMgkaWmModel.setLrrq(new Date());
        if(dto.getId()==null) {
            yjCsMgkaWmModel.setSwjgfw(commonService.getQxdm());
            yjCsMgkaWmModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgkaWmModel.setId(commonService.getDBPk("YJ_CS_MGKA_WM"));
            yjCsMgkaWmModelMapper.insertSelective(yjCsMgkaWmModel);
        }else{
            YjCsMgkaWmModel param=new YjCsMgkaWmModel();
            param.setId(dto.getId());
            YjCsMgkaWmModel model = yjCsMgkaWmModelMapper.selectByPrimaryKey(param);
            model.setYyms(dto.getYyms());
            model.setJzrq(dto.getJzrq());
            model.setQsrq(dto.getQsrq());
            model.setKacode(dto.getKacode());
            model.setKaname(dto.getKaname());
            model.setYxbz(dto.getYxbz());
            model.setLrr(commonService.getCurrentUser().getCzryMc());
            model.setLrrq(new Date());
            model.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgkaWmModelMapper.updateByPrimaryKey(model);
        }
    }



    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<MgspVo> mgsp(WmMgkaDTO dto) {
        Example example=new Example(YjCsMgspModel.class);
        Example.Criteria criteria = example.createCriteria();
        if(dto.getJkDate()!=null) {
            criteria.andLessThanOrEqualTo("qsrq",dto.getJkDate());
            criteria.andGreaterThanOrEqualTo("jzrq",dto.getJkDate());
        }
        if(dto.getSpdm()!=null &&! "".equals(dto.getSpdm())) {
            criteria.andLike("spdm", "%"+dto.getSpdm()+"%");
        }
        if(dto.getSpmc()!=null && !"".equals(dto.getSpmc())) {
            criteria.andLike("spmc", "%"+dto.getSpmc()+"%");
        }
        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String qxdm= TlUtils.getPreSwjgdm(swjgDm);
        criteria.andLike("swjgfw",qxdm+"%");
        List<YjCsMgspModel> list=yjCsMgspModelMapper.selectByExample(example);
        Page<MgspVo> retlist=new Page<>();
        for(YjCsMgspModel vo:list){
            MgspVo mgspVo=new MgspVo();
            BeanUtils.copyProperties(vo,mgspVo);
            if(mgspVo.getSpmc()==null){
                mgspVo.setSpmc("");
            }
            if(mgspVo.getYyms()==null){
                mgspVo.setYyms("");
            }
            mgspVo.setLrswjgdm(commonService.getSwjgMc(vo.getLrswjgdm()).getSwjgjc());
            retlist.add(mgspVo);
        }
        if(dto.getExport()){
            return retlist;
        }
        Page list1 = (Page) list;
        BeanUtils.copyProperties(list1,retlist);

        return retlist;
    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void mgspup(MgspVo dto) {
        YjCsMgspModel yjCsMgspModel=new YjCsMgspModel();
        BeanUtils.copyProperties(dto,yjCsMgspModel);
        if(yjCsMgspModel.getQsrq()!=null&&yjCsMgspModel.getJzrq()!=null) {
            if (yjCsMgspModel.getQsrq().after(yjCsMgspModel.getJzrq())) {
                throw new BusinessException("起始日期不可大于截止日期");
            }
        }
        yjCsMgspModel.setLrr(commonService.getCurrentUser().getCzryMc());

        yjCsMgspModel.setLrrq(new Date());
        if(dto.getId()==null) {
            yjCsMgspModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgspModel.setSwjgfw(commonService.getQxdm());
            yjCsMgspModel.setId(commonService.getDBPk("YJ_CS_MGSP"));
            yjCsMgspModelMapper.insertSelective(yjCsMgspModel);
        }else {
            YjCsMgspModel param=new YjCsMgspModel();
            param.setId(dto.getId());
            YjCsMgspModel model = yjCsMgspModelMapper.selectByPrimaryKey(param);
            model.setYyms(dto.getYyms());
            model.setJzrq(dto.getJzrq());
            model.setQsrq(dto.getQsrq());
            model.setSpdm(dto.getSpdm());
            model.setSpmc(dto.getSpmc());
            model.setYxbz(dto.getYxbz());
            model.setLrr(commonService.getCurrentUser().getCzryMc());
            model.setLrrq(new Date());
            model.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgspModelMapper.updateByPrimaryKey(model);
        }

    }



    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YcghVo> ycghqy(WmMgkaDTO dto) {
        Example example=new Example(YjCsYcghqyModel.class);
        Example.Criteria criteria = example.createCriteria();
        if(dto.getJkDate()!=null) {
            criteria.andLessThanOrEqualTo("qsrq",dto.getJkDate());
            criteria.andGreaterThanOrEqualTo("jzrq",dto.getJkDate());
        }
        if(dto.getNsrsbh()!=null &&! "".equals(dto.getNsrsbh())) {
            criteria.andLike("nsrsbh", "%"+dto.getNsrsbh()+"%");
        }
        if(dto.getNsrmc()!=null &&! "".equals(dto.getNsrmc())) {
            criteria.andLike("nsrmc", "%"+dto.getNsrmc()+"%");
        }
        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String qxdm= TlUtils.getPreSwjgdm(swjgDm);
        criteria.andLike("swjgfw",qxdm+"%");
        List<YjCsYcghqyModel> list=yjCsYcghqyModelMapper.selectByExample(example);
        Page<YcghVo> retlist=new Page<>();
        for(YjCsYcghqyModel vo:list){
            YcghVo ycghVo=new YcghVo();
            BeanUtils.copyProperties(vo,ycghVo);

            ycghVo.setLrswjgdm(commonService.getSwjgMc(vo.getLrswjgdm()).getSwjgjc());
            retlist.add(ycghVo);
        }
        if(dto.getExport()){
            return retlist;
        }
        Page list1 = (Page) list;
        BeanUtils.copyProperties(list1,retlist);

        return retlist;
    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void ycghqyup(YcghVo dto) {
        YjCsYcghqyModel yjCsYcghqyModel=new YjCsYcghqyModel();
        BeanUtils.copyProperties(dto,yjCsYcghqyModel);
        yjCsYcghqyModel.setLrr(commonService.getCurrentUser().getCzryMc());
        yjCsYcghqyModel.setLrrq(new Date());
        if(dto.getQsrq()!=null&&dto.getJzrq()!=null) {
            if (dto.getQsrq().after(dto.getJzrq())) {
                throw new BusinessException("起始日期不可大于截止日期");
            }
        }
        if(dto.getId()==null){
            yjCsYcghqyModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsYcghqyModel.setSwjgfw(commonService.getQxdm());
            yjCsYcghqyModel.setId(commonService.getDBPk("YJ_CS_YCGHQY"));
            YjCsYcghqyModel vo=yjCsYcghqyModelMapper.selectOne(yjCsYcghqyModel);
            if(vo!=null){
                throw new BusinessException("该企业已存在");
            }
            yjCsYcghqyModelMapper.insertSelective(yjCsYcghqyModel);
        }else {
            YjCsYcghqyModel param=new YjCsYcghqyModel();
            param.setId(dto.getId());
            YjCsYcghqyModel model = yjCsYcghqyModelMapper.selectByPrimaryKey(param);
            model.setYyms(dto.getYyms());
            model.setJzrq(dto.getJzrq());
            model.setQsrq(dto.getQsrq());
            model.setZgswjgmc(dto.getZgswjgmc());
            model.setNsrmc(dto.getNsrmc());
            model.setNsrsbh(dto.getNsrsbh());
            model.setYxbz(dto.getYxbz());
            model.setLrr(commonService.getCurrentUser().getCzryMc());
            model.setLrrq(new Date());
            model.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsYcghqyModelMapper.updateByPrimaryKey(model);
        }

    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<MGkaScVo> scqycjka(WmMgkaDTO dto) {
        Example example=new Example(YjCsMgkaScModel.class);
        Example.Criteria criteria = example.createCriteria();
        if(dto.getKaCode()!=null &&! "".equals(dto.getKaCode())) {
            criteria.andLike("kacode", "%"+dto.getKaCode()+"%");
        }
        if(dto.getKaName()!=null && !"".equals(dto.getKaName())) {
            criteria.andLike("kaname", "%"+dto.getKaName()+"%");
        }
        List<YjCsMgkaScModel> list=yjCsMgkaScModelMapper.selectByExample(example);
        Page<MGkaScVo> retlist=new Page<>();
        for(YjCsMgkaScModel vo:list){
            MGkaScVo mGkaScVo=new MGkaScVo();
            BeanUtils.copyProperties(vo,mGkaScVo);
            retlist.add(mGkaScVo);
        }
        if(dto.getExport()){
            return retlist;
        }
        Page list1 = (Page) list;

        BeanUtils.copyProperties(list1,retlist);

        return retlist;
    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YchdVo> ychd(YchdDTO dto) {
        if(dto.getFhrqq()!=null &&dto.getFhrqz()!=null) {
            if (dto.getFhrqq().after(dto.getFhrqz())) {
                throw new BusinessException("复函日期起必须小于等于复函日期止");
            }
        }
        Example example=new Example(YjCsYchdModel.class);
        Example.Criteria criteria = example.createCriteria();
        if(dto.getNsrsbh()!=null && !"".equals(dto.getNsrsbh())) {
            criteria.andLike("nsrsbh", "%"+dto.getNsrsbh()+"%");
        }
        if(dto.getNsrmc()!=null &&! "".equals(dto.getNsrmc())) {
            criteria.andLike("nsrmc", "%"+dto.getNsrmc()+"%");
        }
        if(dto.getFhrqq()!=null) {
            criteria.andGreaterThanOrEqualTo("fhrq",dto.getFhrqq());
        }
        if(dto.getFhrqz()!=null) {
            criteria.andLessThanOrEqualTo("fhrq",dto.getFhrqz());
        }
        List<YjCsYchdModel> list=yjCsYchdModelMapper.selectByExample(example);
        Page<YchdVo> retlist=new Page<>();
        for(YjCsYchdModel vo:list){
            YchdVo ychdVo=new YchdVo();
            BeanUtils.copyProperties(vo,ychdVo);
            retlist.add(ychdVo);
        }
        if(dto.getExport()){
            return retlist;
        }
        Page list1 = (Page) list;

        BeanUtils.copyProperties(list1,retlist);

        return retlist;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<PjdjVo> cksppjj(QspjdjDTO dto) {
        if(!("".equals(dto.getDjq())||dto.getDjq()==null)&&!("".equals(dto.getDjz())||dto.getDjz()==null)) {
            if (new BigDecimal(dto.getDjq()) .compareTo( new BigDecimal(dto.getDjz()))==1) {
                throw new BusinessException("金额范围错误，请核对");
            }
        }
        List<PjdjVo> list;
        if("1".equals(dto.getType())){
            list=tlYjMapper.cksppjj4Sc(dto);
        }else {
            list=tlYjMapper.cksppjj4Wm(dto);
        }
        return list;
    }

    /**
     * 海关货源地区域对照表查询
     * @param dto 查询条件
     * @return 海关货源地列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjHghydVO> queryYjHghydList(YjHghydDTO dto) {
        return tlYjMapper.queryYjHghydList(dto);
    }

    /**
     * 查询行政区划表
     * @param dto 查询条件
     * @return 行政区划表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjHghydVO> queryYjXzqhList(YjHghydDTO dto) {
        return tlYjMapper.selectYjXzqhList(dto);
    }

    /**
     * 查询行政区划字典列表（下拉用）
     * @return 区域代码和名称列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjHghydVO> queryYjXzqhDicList() {
        return tlYjMapper.queryYjXzqhDicList();
    }

    /**
     * 海关口岸区域对照表查询
     * @param dto 查询条件
     * @return 海关口岸列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjHgcodeVO> queryYjHgcodeList(YjHgcodeDTO dto) {
        return tlYjMapper.queryYjHgcodeList(dto);
    }

    /**
     * 风险报关行信息查询
     * @param dto 查询条件
     * @return 风险报关行列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjCsFxbghVO> queryYjCsFxbghList(YjCsFxbghDTO dto) {
        return yjCsFxbghModelMapper.queryYjCsFxbghList(dto);
    }

    /**
     * 最终目的国区域对照表查询
     * @param dto 查询条件
     * @return 国别列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjGbcodeVO> queryYjGbcodeList(YjGbcodeDTO dto) {
        return tlYjMapper.queryYjGbcodeList(dto);
    }

    /**
     * 查询目的国区域字典列表（下拉用）
     * @return 国家区域代码和名称列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjGbcodeVO> queryYjGbcodeDicList() {
        return tlYjMapper.queryYjGbcodeDicList();
    }

    /**
     * 出口链路风险等级参数表查询
     * @param dto 查询条件
     * @return 风险等级列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<YjFxdjszVO> queryYjFxdjszList(YjFxdjszDTO dto) {
        return tlYjMapper.queryYjFxdjszList(dto);
    }

    /**
     * 出口链路异常分析模型（外贸）查询
     * @param dto 查询条件
     * @return 链路列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<YjWmllVO> queryYjWmllList(YjWmllDTO dto) {
        dto.setSwjgdm(commonService.getCurrentUser().getSwjgDm());
        return tlYjMapper.queryYjWmllList(dto);
    }

    /**
     * 保存出口链路风险等级调整（外贸）
     * @param dto 调整信息
     */
    public void saveYjWmllFxdjtz(YjWmllFxdjtzDTO dto) {
        // 获取当前用户信息
        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String czryMc = commonService.getCurrentUser().getCzryMc();
        
        // 设置税务机关和调整人员
        dto.setSwjgDm(swjgDm);
        dto.setFxdjTzry(czryMc);
        
        // 调用Mapper保存（使用MERGE语句，存在则更新，不存在则插入）
        try{
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);
            tlYjMapper.saveYjWmllFxdjtz(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

    }

    /**
     * 每美元利润率分析结果查询
     * @param dto 查询条件
     * @return 利润率列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjMmyllVO> queryYjMmyllList(YjMmyllDTO dto) {
        dto.setQxdm(commonService.getQxdm());
        return tlYjMapper.queryYjMmyllList(dto);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public PageInfo queryYjDicList(TsjgDTO dto) {

        List<YjDicModelVo> retList=new ArrayList<>();

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        List<YjDicModel> select = tlYjMapper.queryYjcodes(swjgDm,commonService.getQxdm());

        for(YjDicModel yjDicModel:select){
            YjDicModelVo yjDicModelVo=new YjDicModelVo();

            BeanUtils.copyProperties(yjDicModel,yjDicModelVo);
            retList.add(yjDicModelVo);
        }

        PageInfo pageInfo = new BaseController().dealPageInfo(select);

        pageInfo.setRows(retList);
        return pageInfo;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateYjProfileQybz(YjcodeQybzDTO dto) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        //只有市局可进行修改上级定义的指标代码的权限
        if(commonService.getQxdm().length()!=5){
            throw new BusinessException("无权限修改");
        }

        YjDicSwjgModel yjDicSwjgModel=new YjDicSwjgModel();
        yjDicSwjgModel.setSwjgdm(swjgDm);
        yjDicSwjgModel.setYjcode(dto.getYjcode());
        yjDicSwjgModel.setQyflag(dto.getYxbz());

        YjDicSwjgModel model = yjDicSwjgModelMapper.selectByPrimaryKey(yjDicSwjgModel);

        if(model==null){
            yjDicSwjgModelMapper.insert(yjDicSwjgModel);
        }else {
            yjDicSwjgModelMapper.updateByPrimaryKey(yjDicSwjgModel);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjDicYjzbModelVo> queryYjzbs(String yjcode) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        if(commonService.getQxdm().length()==3){
            return null;
        }

        return  tlYjMapper.queryYjzbs(TlUtils.getPreSwjgdm(swjgDm),swjgDm,yjcode,null);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjDicYjzbModelVo> queryYjzbsQsmr(String yjcode) {

        return  tlYjMapper.queryYjzbsQsmr(yjcode);
    }

    /**
     * 根据税务机关代码和指标代码删除预警参数指标的相关信息
     * @param swjgdm  税务机关代码
     * @param zbcode  指标代码
     */
    public void deleteYjzbSwjg(String swjgdm,String  zbcode) {
          tlYjMapper.deleteYjzbSwjg(swjgdm,zbcode);
    }


    /**
     * 查询地市的预警指标
     * @param yjcode  预警代码
     * @param zbcode  指标代码
     * @return
     */
    public List<YjDicYjzbModelVo> queryYjzbsDs(String yjcode,String zbcode) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        return  tlYjMapper.queryYjzbs(TlUtils.getPreSwjgdm(swjgDm),swjgDm,yjcode,zbcode);
    }

    /**
     * 根据预警代码获取预警的指标信息
     * @param yjcode  预警代码
     * @return
     */
    public List<ZbSelectVO> getZbSelect(String yjcode) {
        return  tlYjMapper.getZbSelect(yjcode);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateYjzbQybz(YjzbcodeQybzDTO dto) {

        String swjgDm = dto.getSwjgdm();
        if(StringUtils.isBlank(swjgDm)){
            swjgDm =    commonService.getCurrentUser().getSwjgDm();
        }

        if(commonService.getQxdm().length()==3){
            swjgDm=dto.getSwjgdm();
        }

        if(dto.getP1val()!=null){
            if(dto.getP1val().compareTo(new BigDecimal(9999999999999.99))==1){
                throw new BusinessException("数值1过大请重新输入");
            }
        }
        if(dto.getP2val()!=null){
            if(dto.getP2val().compareTo(new BigDecimal(9999999999999.99))==1){
                throw new BusinessException("数值2过大请重新输入");
            }
        }
        if(dto.getP3val()!=null){
            if(dto.getP3val().compareTo(new BigDecimal(9999999999999.99))==1){
                throw new BusinessException("数值3过大请重新输入");
            }
        }
        if(dto.getP4val()!=null){
            if(dto.getP4val().compareTo(new BigDecimal(9999999999999.99))==1){
                throw new BusinessException("数值4过大请重新输入");
            }
        }
        if(dto.getScore()!=null){
            if(dto.getScore()>99999999){
                throw new BusinessException("分值过大请重新输入");
            }
        }

        YjzbSwjgModel yjzbSwjgModel=new YjzbSwjgModel();
        yjzbSwjgModel.setSwjgdm(swjgDm);
        yjzbSwjgModel.setZbcode(dto.getZbcode());
        yjzbSwjgModel.setP1val(dto.getP1val());
        yjzbSwjgModel.setP2val(dto.getP2val());
        yjzbSwjgModel.setP3val(dto.getP3val());
        yjzbSwjgModel.setP4val(dto.getP4val());
        yjzbSwjgModel.setScore(dto.getScore());
        YjzbSwjgModel model = yjzbSwjgModelMapper.selectByPrimaryKey(yjzbSwjgModel);
        //加了启用标记会在关闭启用的时候新增一条，不能先把yxbz放进去不然会变成新增
        yjzbSwjgModel.setYxbz(dto.getYxbz());



        if(model==null){
            yjzbSwjgModelMapper.insert(yjzbSwjgModel);
        }else {
            yjzbSwjgModelMapper.updateByPrimaryKey(yjzbSwjgModel);
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjCsBmdModelVo> queryYjBmds(YjBmdDTO dto) {

        String qxdm = commonService.getQxdm();

        dto.setQxdm(qxdm);
        if(StringUtils.isNotBlank(dto.getTsjg())){
            dto.setTsjg(commonService.getQxdm(dto.getTsjg()));
        }

        return tlYjMapper.queryYjBmds(dto);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void addYjBmd(YjCsBmdModelVo obj) {

        TlUserProfile currentUser = commonService.getCurrentUser();

        BigDecimal nsrdzdah=tlYjMapper.queryQyxx(obj.getQybs());

        if(nsrdzdah==null){
            throw new BusinessException("企业标识无效，不存在对应的企业信息");
        }
        YjCsBmdModel bmdModel=new YjCsBmdModel();
        bmdModel.setObjflag(obj.getObjflag());
        bmdModel.setYjcode(obj.getYjcode());
        bmdModel.setNsrdzdah(nsrdzdah);
        YjCsBmdModel vo=yjCsBmdModelMapper.selectOne(bmdModel);
        if(vo!=null){
            throw new BusinessException("已存在的白名单配置，不能重复添加");
        }

        bmdModel.setId(commonService.getDBPk("YJ_CS_BMD"));
        bmdModel.setSwjgdm(currentUser.getSwjgDm());
        bmdModel.setLrrq(new Date());
        bmdModel.setLrr(currentUser.getCzryMc());
        bmdModel.setYxbz("Y");
        bmdModel.setYyms(obj.getYyms());

        bmdModel.setXgr(currentUser.getCzryMc());
        bmdModel.setXgrq(new Date());


        yjCsBmdModelMapper.insert(bmdModel);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public String addCheckYjBmd(YjCsBmdModelVo obj) {
        TlUserProfile currentUser = commonService.getCurrentUser();

        String nsrmc=tlYjMapper.queryQymc(obj.getQybs());

        if(nsrmc==null){
            throw new BusinessException("企业标识无效，不存在对应的企业信息");
        }

        return nsrmc;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void delYjBmd(Long aLong) {



        String swjgDm = commonService.getQxdm();

        Example ep=new Example(YjCsBmdModel.class);

        Example.Criteria criteria = ep.createCriteria();

        criteria.andEqualTo("id",aLong);
        criteria.andLike("swjgdm",swjgDm+"%");

        int i = yjCsBmdModelMapper.deleteByExample(ep);

        if(i!=0){
            YjCsBmdSubModel yjCsBmdSubModel=new YjCsBmdSubModel();
            yjCsBmdSubModel.setBmdid(aLong);
            yjCsBmdSubModelMapper.delete(yjCsBmdSubModel);
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void addYjBmdSub(YjCsBmdSubModel model) {

        TlUserProfile currentUser = commonService.getCurrentUser();

        model.setBsid(commonService.getDBPk("YJ_CS_BMD_SUB"));
        model.setLrr(currentUser.getCzryMc());
        model.setLrrq(new Date());
        model.setYxbz("Y");
        model.setXgr(currentUser.getCzryMc());
        model.setXgrq(new Date());
        YjCsBmdModel yjCsBmdModel=new YjCsBmdModelVo();
        yjCsBmdModel.setId(model.getBmdid());
        YjCsBmdModel res=yjCsBmdModelMapper.selectByPrimaryKey(yjCsBmdModel);
        if(res==null){
            throw  new BusinessException("该白名单已被删除");
        }
        YjCsBmdSubModel yjCsBmdSubModel=new YjCsBmdSubModel();
        yjCsBmdSubModel.setBmdid(model.getBmdid());
        yjCsBmdSubModel.setYjObject(model.getYjObject());
        YjCsBmdSubModel vo=yjCsBmdSubModelMapper.selectOne(yjCsBmdSubModel);
        if(vo!=null){
            throw new BusinessException("该白名单商品已存在");
        }
        yjCsBmdSubModelMapper.insert(model);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjCsBmdSubModel> viewYjBmdSub(Long id) {

        YjCsBmdSubModel p=new YjCsBmdSubModel();
        p.setBmdid(id);
        return yjCsBmdSubModelMapper.select(p);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void delYjBmdSub(Long aLong) {
        yjCsBmdSubModelMapper.deleteByPrimaryKey(aLong);
    }


    /*
     * @Description: 获取预警综合查询列表
     * @param  [dto]
     * @return  java.util.List<com.tl.bjts.sw.model.vo.YjZhcxListVO>
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjZhcxListVO> getYjZhcxList(YjZhcxListDTO dto) throws ParseException {
        String qxdm = commonService.getQxdm();
        String tsjg = commonService.getQxdm(dto.getSwjgDm());
        dto.setSwjgDm(tsjg);
        DateFormat formatter = new SimpleDateFormat("yyyyMM");
        if(!"".equals(dto.getSbym())) {
            Date date = formatter.parse(dto.getSbym());
            if (!dto.getSbym().equals(formatter.format(date))) {
                throw new BusinessException("申报年月输入格式有误，请重新选择");
            }
        }
        DateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
           if(!StringUtils.isBlank(dto.getClrqq())&&!StringUtils.isBlank(dto.getClrqz())){
            if (formatter2.parse(dto.getClrqq()).after(formatter2.parse(dto.getClrqz()))) {
                throw new BusinessException("预警时间起始必须小于等于截止时间");
            }
        }
        if(dto.getYjAmtStart()!=null&&dto.getYjAmtEnd()!=null) {
            if (dto.getYjAmtStart() .compareTo(dto.getYjAmtEnd())==1) {
                throw new BusinessException("金额范围错误，请核对");
            }
        }
        dto.setPreSwjgdm(qxdm);
        commonUtils.setPageParam(dto);
        List<YjZhcxListVO> list= tlYjMapper.getYjZhcxList(dto);
        for(YjZhcxListVO vo:list){
            //这里在string为null时塞入空字符串所以就没用isblank
            if(vo.getBsy1Mc()==null){
                vo.setBsy1Mc("");
            }
            if(vo.getBsy2Mc()==null){
                vo.setBsy2Mc("");
            }
            if(vo.getFddbrmc()==null){
                vo.setFddbrmc("");
            }
        }
        return list;
    }

    /**
     * 获取预警综合查询-合计数据
     * @param dto
     * @return
     */
    public Map getYjZhcxSum(YjZhcxListDTO dto){
        return tlYjMapper.getYjZhcxSum(dto);
    }


    /*
     * @Description:  获取预警综合查询列表(导出用)
     * @param  [dto]
     * @return  java.util.List<com.tl.bjts.sw.model.vo.YjZhcxListVO>
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjZhcxListVO> getYjZhcxList4Export(YjZhcxListDTO dto) {
        String qxdm = commonService.getQxdm();
        String tsjg = commonService.getQxdm(dto.getSwjgDm());
        dto.setSwjgDm(tsjg);
        dto.setPreSwjgdm(qxdm);
        return tlYjMapper.getYjZhcxList(dto);
    }

    /*
     * @Description: 导出预警综合查询列表
     * @param  [response, dto]
     * @return  void
     */
    public void exportYjZhcxList(HttpServletResponse response,YjZhcxListDTO dto,List<String> exual) throws Exception {
        YjService yjService = (YjService) AopContext.currentProxy();
        List<YjZhcxListVO> yjZhcxList4Export = yjService.getYjZhcxList4Export(dto);
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = "预警综合查询" + TlDateUtils.format(new Date(), "yyyyMMdd");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", yjZhcxList4Export, YjZhcxListVO.class,exual,false);

        // 关闭流
        outputStream.flush();
        outputStream.close();
    }

    /*
     * @Description:  获取企业预警评分信息
     * @param  [nsrsbh]
     * @return  com.tl.bjts.sw.model.vo.YjPfxxVO
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public YjPfxxVO getYjPfxx(String nsrsbh) {
        YjPfxxVO vo= tlYjMapper.getYjPfxx(nsrsbh);
        if(vo.getBsyMc()==null){
            vo.setBsyMc("");
        }
        if(vo.getFddbrmc()==null){
            vo.setFddbrmc("");
        }
        return vo;
    }

    /*
     * @Description: 获取企业预警评分列表
     * @param  [dto]
     * @return  java.util.List<com.tl.bjts.sw.model.vo.YjPfxxListVO>
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjPfxxListVO> getYjPfxxList(YjPfxxListDTO dto) {
        if(dto.getYjAmtStart()!=null&&dto.getYjAmtEnd()!=null) {
            if (dto.getYjAmtStart() .compareTo(dto.getYjAmtEnd())==1) {
                throw new BusinessException("金额范围错误，请核对");
            }
        }
        commonUtils.setPageParam(dto);
        return tlYjMapper.getYjPfxxList(dto);
    }

    /*
     * @Description: 获取企业预警评分列表（导出用）
     * @param  [dto]
     * @return  java.util.List<com.tl.bjts.sw.model.vo.YjPfxxListVO>
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjPfxxListVO> getYjPfxxList4export(YjPfxxListDTO dto) {
        return tlYjMapper.getYjPfxxList(dto);
    }

    /*
     * @Description:  导出企业评分列表
     * @param  [response, dto]
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void exportYjPfxxList(HttpServletResponse response,YjPfxxListDTO dto,List<String> exual) throws Exception {
        String nsrsbh = dto.getNsrsbh();
        YjService yjService = (YjService) AopContext.currentProxy();
        List<YjPfxxListVO> yjPfxxList4export = yjService.getYjPfxxList4export(dto);
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = "企业评分详情【" + nsrsbh + "】" + TlDateUtils.format(new Date(), "yyyyMMdd");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", yjPfxxList4export, YjPfxxListVO.class, exual, false);

        // 关闭流
        outputStream.flush();
        outputStream.close();
    }

    /*
     * @Description:  外贸免退税敏感口岸信息库删除
     * @param
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void wmmmgkadel(IdsDTO dto) {
        for(Long id:dto.getIds()){
            yjCsMgkaWmModelMapper.deleteByPrimaryKey(id);
        }
    }
    /*
     * @Description:  敏感商品删除
     * @param
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void mgspdel(IdsDTO dto) {
        for(Long id:dto.getIds()){
            yjCsMgspModelMapper.deleteByPrimaryKey(id);
        }
    }
    /*
     * @Description:  外异常供货企业删除
     * @param
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void ycghqydel(IdsDTO dto) {
        for(Long id:dto.getIds()){
            yjCsYcghqyModelMapper.deleteByPrimaryKey(id);
        }
    }
    /*
     * @Description:  生产免抵退常见口岸插入（kacode为主键，不提供update接口只提提供insert和delete）
     * @param
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void scqycjkaup(MGkaScVo dto) {
        YjCsMgkaScModel yjCsMgkaScModel=new YjCsMgkaScModel();
        BeanUtils.copyProperties(dto,yjCsMgkaScModel);
         YjCsMgkaScModel res=yjCsMgkaScModelMapper.selectByPrimaryKey(dto.getKacode());
            if(res!= null){
                throw new BusinessException(BusinessMsgCons.EXIST_KACODE);
            }
            yjCsMgkaScModelMapper.insertSelective(yjCsMgkaScModel);

    }
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void scqycjkadel(IdsDTO dto) {
        for(Long id:dto.getIds()){
            yjCsMgkaScModelMapper.deleteByPrimaryKey(id);
        }
    }
    /*
     * @Description:  异常函调（只提供insert和delete）
     * @param
     * @return  void
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void ychdup(YchdVo dto) {
        YjCsYchdModel yjCsYchdModel=new YjCsYchdModel();
        BeanUtils.copyProperties(dto,yjCsYchdModel);
          YjCsYchdModel res=yjCsYchdModelMapper.selectByPrimaryKey(dto.getFhbh());
        yjCsYchdModel.setTbsj(new Date());
//        yjCsYchdModel.setZgswjgmc(commonService.getCurrentUser().getSwjgDm()); 主管税务机关是自己填还是我们去获取？
        if(res!= null){
            throw new BusinessException(BusinessMsgCons.EXIST_FHBH);
        }
            yjCsYchdModelMapper.insertSelective(yjCsYchdModel);
    }
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void ychddel(IdsDTO dto) {
        for(Long id:dto.getIds()){
            yjCsYchdModelMapper.deleteByPrimaryKey(id);
        }
    }
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<YjzbcxVo> findyjzb() {
        List<YjzbcxVo> list=tlYjMapper.selectYjcodeAll(commonService.getQxdm(),commonService.getCurrentUser().getSwjgDm());
        for(YjzbcxVo vo:list){
            List<ZbnameVo> list2=tlYjMapper.getYjzb(vo.getYjcode());
            vo.setYjzb(list2);
        }
        return  list;
    }
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    @Transactional
    public void importYcghqy(List<YcghMbVo> allData) throws ParseException {
        DateFormat fmt =new SimpleDateFormat("yyyy-MM-dd");
        if(allData.size()==0){
            throw new BusinessException("请在文件中输入内容");
        }

        for (int i=0;i<allData.size();i++){
            YjCsYcghqyModel yjCsYcghqyModel=new YjCsYcghqyModel();
            BeanUtils.copyProperties(allData.get(i),yjCsYcghqyModel);
            if(StringUtils.isNotBlank(allData.get(i).getQsrq())) {
                yjCsYcghqyModel.setQsrq(fmt.parse(allData.get(i).getQsrq()));
            }
            if(StringUtils.isNotBlank(allData.get(i).getJzrq())) {
                yjCsYcghqyModel.setJzrq(fmt.parse(allData.get(i).getJzrq()));
            }
            if(yjCsYcghqyModel.getQsrq()!=null&&yjCsYcghqyModel.getJzrq()!=null) {
                if (yjCsYcghqyModel.getQsrq().after(yjCsYcghqyModel.getJzrq())) {
                    throw new BusinessException("第"+(i+2)+"行起始日期不可大于截止日期,请检查");
                }
            }
            if(!"Y".equals(yjCsYcghqyModel.getYxbz())&&!"N".equals(yjCsYcghqyModel.getYxbz())){
                throw new BusinessException("第"+(i+2)+"行有效标志必须为Y或者为N,请检查");
            }
            yjCsYcghqyModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsYcghqyModel.setSwjgfw(commonService.getQxdm());
            yjCsYcghqyModel.setLrrq(new Date());
            yjCsYcghqyModel.setLrr(commonService.getCurrentUser().getCzryMc());
            yjCsYcghqyModel.setId(commonService.getDBPk("YJ_CS_YCGHQY"));
            yjCsYcghqyModelMapper.insertSelective(yjCsYcghqyModel);
        }
    }
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    @Transactional
    public void importMgsp(List<MgspMbVo> allData) throws ParseException {
        DateFormat fmt =new SimpleDateFormat("yyyy-MM-dd");
        if(allData.size()==0){
            throw new BusinessException("请在文件中输入内容");
        }
        for (int i=0;i<allData.size();i++){
           YjCsMgspModel yjCsMgspModel=new YjCsMgspModel();
            BeanUtils.copyProperties(allData.get(i),yjCsMgspModel);
            if(!"".equals(allData.get(i).getQsrq())) {
                yjCsMgspModel.setQsrq(fmt.parse(allData.get(i).getQsrq()));
            }
            if(!"".equals(allData.get(i).getJzrq())) {
                yjCsMgspModel.setJzrq(fmt.parse(allData.get(i).getJzrq()));
            }
            if(yjCsMgspModel.getQsrq()!=null&&yjCsMgspModel.getJzrq()!=null) {
                if (yjCsMgspModel.getQsrq().after(yjCsMgspModel.getJzrq())) {
                    throw new BusinessException("第"+(i+2)+"行起始日期不可大于截止日期,请检查");
                }
            }
            if(!"Y".equals(yjCsMgspModel.getYxbz())&&!"N".equals(yjCsMgspModel.getYxbz())){
                throw new BusinessException("第"+(i+2)+"行有效标志必须为Y或者为N,请检查");
            }
            yjCsMgspModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgspModel.setLrrq(new Date());
            yjCsMgspModel.setSwjgfw(commonService.getQxdm());
            yjCsMgspModel.setLrr(commonService.getCurrentUser().getCzryMc());
            yjCsMgspModel.setId(commonService.getDBPk("YJ_CS_MGSP"));
            yjCsMgspModelMapper.insertSelective(yjCsMgspModel);
        }
    }



    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    @Transactional
    public void importWmmgka(List<MgkaWmMbVo> allData) throws ParseException {
        DateFormat fmt =new SimpleDateFormat("yyyy-MM-dd");
        if(allData.size()==0){
            throw new BusinessException("请在文件中输入内容");
        }
        for (int i=0;i<allData.size();i++){
            YjCsMgkaWmModel yjCsMgkaWmModel =new YjCsMgkaWmModel();
            BeanUtils.copyProperties(allData.get(i),yjCsMgkaWmModel);
            if(!"".equals(allData.get(i).getQsrq())) {
                yjCsMgkaWmModel.setQsrq(fmt.parse(allData.get(i).getQsrq()));
            }
            if(!"".equals(allData.get(i).getJzrq())) {
                yjCsMgkaWmModel.setJzrq(fmt.parse(allData.get(i).getJzrq()));
            }
            if(yjCsMgkaWmModel.getQsrq()!=null&&yjCsMgkaWmModel.getJzrq()!=null) {
                if (yjCsMgkaWmModel.getQsrq().after(yjCsMgkaWmModel.getJzrq())) {
                    throw new BusinessException("第"+(i+2)+"行起始日期不可大于截止日期,请检查");
                }
            }
            if(!"Y".equals(yjCsMgkaWmModel.getYxbz())&&!"N".equals(yjCsMgkaWmModel.getYxbz())){
                throw new BusinessException("第"+(i+2)   +"行有效标志必须为Y或者为N,请检查");
            }
            yjCsMgkaWmModel.setId(commonService.getDBPk("YJ_CS_MGKA_WM"));
            yjCsMgkaWmModel.setLrswjgdm(commonService.getCurrentUser().getSwjgDm());
            yjCsMgkaWmModel.setLrrq(new Date());
            yjCsMgkaWmModel.setSwjgfw(commonService.getQxdm());
            yjCsMgkaWmModel.setLrr(commonService.getCurrentUser().getCzryMc());
            yjCsMgkaWmModelMapper.insertSelective(yjCsMgkaWmModel);
        }
    }


    public void resetPfxx(String nsrsbh) {

        BigDecimal nsrdzdah=tlYjMapper.queryQyxx(nsrsbh);

        String czrymc = commonService.getCurrentUser().getCzryMc();

        tlYjMapper.updateResetSocre(nsrdzdah,czrymc);
    }

    // ==================== 出口业务物流链路综合管理 ====================

    /**
     * 获取出口业务物流链路综合管理列表
     * @param dto 查询条件
     * @return 链路列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<CkllfxListVO> getCkllfxList(CkllfxListDTO dto) {
        // 设置权限机关代码
        String qxdm = commonService.getQxdm();
        if (StringUtils.isNotBlank(dto.getSwjgDm())) {
            dto.setSwjgDm(commonService.getQxdm(dto.getSwjgDm()));
        } else {
            dto.setSwjgDm(qxdm);
        }
        // 设置分页参数
        commonUtils.setPageParam(dto);
        return tlYjMapper.queryCkllfxList(dto);
    }

    /**
     * 获取出口业务物流链路综合管理列表（导出用）
     * @param dto 查询条件
     * @return 链路列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<CkllfxListVO> getCkllfxList4Export(CkllfxListDTO dto) {
        String qxdm = commonService.getQxdm();
        if (StringUtils.isNotBlank(dto.getSwjgDm())) {
            dto.setSwjgDm(commonService.getQxdm(dto.getSwjgDm()));
        } else {
            dto.setSwjgDm(qxdm);
        }
        return tlYjMapper.queryCkllfxList(dto);
    }

    /**
     * 导出出口业务物流链路综合管理列表
     * @param response HTTP响应
     * @param dto 查询条件
     * @param exual 导出字段列表
     * @throws Exception 导出异常
     */
    public void exportCkllfxList(HttpServletResponse response, CkllfxListDTO dto, List<String> exual) throws Exception {
        YjService yjService = (YjService) AopContext.currentProxy();
        List<CkllfxListVO> ckllfxList4Export = yjService.getCkllfxList4Export(dto);
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = "出口业务物流链路综合管理" + TlDateUtils.format(new Date(), "yyyyMMdd");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", ckllfxList4Export, CkllfxListVO.class, exual, false);

        // 关闭流
        outputStream.flush();
        outputStream.close();
    }

    // ==================== 出口业务物流链路数据修改 ====================

    /**
     * 物流链路数据修改保存
     * @param dto 修改参数
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void editCkllfx(CkllfxEditDTO dto, String qxSwjgDm) {

        // 校验记录是否存在
        checkCkllfxRecordExists(dto, qxSwjgDm);

        // 执行数据更新
        tlYjMapper.updateCkllfxData(dto);
    }

    /**
     * 校验物流链路记录是否存在
     * @param dto 修改参数
     */
    private void checkCkllfxRecordExists(CkllfxEditDTO dto, String qxSwjgDm) {
        int count = tlYjMapper.countCkllfxRecord(new BigDecimal(dto.getDjxh()), dto.getBgdhgbh(), qxSwjgDm);
        if (count == 0) {
            throw new BusinessException("未找到对应的物流链路数据记录");
        }
    }

    // ==================== 物流链路二维码生成 ====================

    /**
     * 生成物流链路二维码
     * @param dto 请求参数
     * @return 二维码VO
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public CkllfxQrVO generateCkllQrCode(CkllfxQrDTO dto, String qxSwjgDm) {

        /*
            查询及构建待使用数据
         */
        CkllfxQrDataBO qrData = queryAndValidateQrData(dto, qxSwjgDm);

        /*
            构建二维码内容
         */
        String qrContentUrl = buildQrContentUrlFieldV1(qrData);

        /*
            生成二维码图片
         */
        String qrBase64 = null;
        try {
            qrBase64 = generateQrCodeImage(qrContentUrl);
        } catch (Exception e) {
            LOGGER.error("生成二维码图片失败。qxSwjgDm:{}, dto:{}, content:{}", qxSwjgDm, dto, qrContentUrl, e);
            throw new BusinessException("生成二维码图片失败");
        }

        /*
            构建返回值
         */
        CkllfxQrVO vo = new CkllfxQrVO();
        vo.setQrBase(qrBase64);
        vo.setFormat("png");
        return vo;
    }

    /**
     * 查询并校验二维码参数数据
     * @param dto 请求参数
     * @param qxSwjgDm 权限税务机关代码
     * @return 二维码参数数据
     */
    private CkllfxQrDataBO queryAndValidateQrData(CkllfxQrDTO dto, String qxSwjgDm) {
        CkllfxQrDataBO qrData = tlYjMapper.queryCkllfxQrData(new BigDecimal(dto.getDjxh()), dto.getBgdhgbh(), qxSwjgDm);

        if (qrData == null) {
            throw new BusinessException("未找到对应的物流链路数据记录");
        }

        validateQrDataFields(qrData);

        /*
            车牌颜色如果为空，赋值为黄色
         */
        if (StringUtils.isBlank(qrData.getCpysCode())) {
            qrData.setCpysCode(CpysEnum.YELLOW.getCode());
        }

        return qrData;
    }

    /**
     * 校验二维码必填字段
     * @param qrData 二维码参数数据
     */
    private void validateQrDataFields(CkllfxQrDataBO qrData) {
        StringBuilder errorMsg = new StringBuilder();
        if (StringUtils.isBlank(qrData.getCph())) {
            errorMsg.append("【车牌号】为空，请先将对应的数据补充完整；");
        }
        if (qrData.getQyrq() == null) {
            errorMsg.append("【起运日】为空，请先将对应的数据补充完整；");
        }
        if (StringUtils.isBlank(qrData.getQydAddr())) {
            errorMsg.append("【启运地】为空，请先将对应的数据补充完整；");
        }
        if (errorMsg.length() > 0) {
            throw new BusinessException(errorMsg.toString());
        }
    }

    /**
     * 构建二维码内容URL(?data=base64url(json))
     * @param qrData 二维码参数数据
     * @return 完整URL
     * ps:
     *  1.示例：https://api.com/qrYsy/yy-gnwlcx?data=xxxxxxxxxxxxxxxxx
     *  2.data参数为json数据，需要base64url编码。
     */
    private String buildQrContentUrl(CkllfxQrDataBO qrData) {
        String jsonData = GsonUtils.getDefaultGson().toJson(qrData);
        String base64UrlData = TlUtils.base64UrlEncode(jsonData.getBytes(StandardCharsets.UTF_8));
        return appProperties.getQrYsyBaseUrl() + TlConst.QR_YSY_FUNC_ID + "?data=" + base64UrlData;
    }

    /**
     * 构建二维码内容URL（备选方案?k1=urlencode(v1)&k2=v2...）
     * @param qrData 二维码参数数据
     * @return 完整URL
     * ps:
     *  1.示例：https://api.com/qrYsy/yy-gnwlcx?bgdhgbh=xxx&cph=xxx&qyrq=2026-07-21...
     *  2.字符串属性空值不保留，日期/BigDecimal属性为null时不拼接
     *  3.日期格式化为yyyy-MM-dd，BigDecimal使用toPlainString避免科学计数法
     */
    private String buildQrContentUrlV1(CkllfxQrDataBO qrData) {
        StringBuilder sb = new StringBuilder();
        //二维码地址头
        sb.append(appProperties.getQrYsyBaseUrl()).append(TlConst.QR_YSY_FUNC_ID).append("?");

        //bo所有属性，属性名为key，属性值为value，&拼接
        Field[] fields = qrData.getClass().getDeclaredFields();
        boolean first = true;

        for (Field field : fields) {
            try {
                field.setAccessible(true);
                String key = field.getName();
                Object value = field.get(qrData);
                String paramValue = buildParamValue(field, value, TlDateUtils.YMD);

                if (paramValue == null) {
                    continue;
                }
                if (!first) {
                    sb.append("&");
                }
//                sb.append(key).append("=").append(paramValue);
                sb.append(key).append("=").append(URLEncoder.encode(paramValue, "UTF-8"));
                first = false;
            } catch (IllegalAccessException | UnsupportedEncodingException e) {
                LOGGER.error("构建二维码URL参数失败, field:{}", field.getName(), e);
                throw new BusinessException("构建二维码URL参数失败");
            }
        }
        return sb.toString();
    }

    /**
     * 根据字段类型构建参数值字符串
     * @param field 字段
     * @param value 字段值
     * @param dateFormat 日期格式化器
     * @return 参数值字符串，null表示不拼接
     */
    private String buildParamValue(Field field, Object value, String dateFormat) {

        if (value == null) {
            return null;
        }

        if (field.getType() == String.class) {
            if (StringUtils.isBlank((String) value)) {
                return null;
            }
        }

        if (value instanceof Date) {
            return TlDateUtils.format((Date) value, StringUtils.isNotBlank(dateFormat) ? dateFormat : "yyyy-MM-dd");
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).toPlainString();
        }
        return value.toString();
    }

    /**
     * 构建二维码内容URL-v1版本（管道分隔无key方案，注解驱动）
     * @param qrData
     * @return
     * ps：
     *  1.详细处理方案见buildQrContentUrlFieldVersion方法说明
     */
    private String buildQrContentUrlFieldV1(CkllfxQrDataBO qrData) {
        CkllfxQrDataFieldV1BO v1Bo = new CkllfxQrDataFieldV1BO();
        TlBeanUtils.copyPropertiesIgnoreNull(qrData, v1Bo);
        return this.buildQrContentUrlFieldVersion(v1Bo, TlConst.QR_PARAM_VERSION_V1);
    }

    /**
     * 构建二维码内容URL（管道分隔无key方案，注解驱动）
     * @param fieldObj 带@QrField注解的字段定义对象（如CkllfxQrDataBOFieldV1）
     * @param version 版本号
     * @return 完整URL
     * ps:
     *  1.示例：https://api.com/qrYsy/yy-gnwlcx?d=fv1|val1|val2|...
     *  2.只拼接带@QrField注解的属性，按order升序排列
     *  3.每个value先格式化再base64URLEncode，保证|分隔符不被值污染
     *  4.null值保留空位，保证位置严格对齐
     */
    private String buildQrContentUrlFieldVersion(Object fieldObj, String version) {
        StringBuilder sb = new StringBuilder();
        sb.append(appProperties.getQrYsyBaseUrl())
                .append(TlConst.QR_YSY_FUNC_ID)
                .append("?d=")
                .append(version);

        List<Field> sortedFields = getQrSortedFields(fieldObj.getClass());

        for (Field field : sortedFields) {
            sb.append(TlConst.QR_PARAM_DELIMITER);
            try {
                field.setAccessible(true);
                sb.append(formatAndEncodeFieldValue(field, field.get(fieldObj)));
            } catch (IllegalAccessException e) {
                LOGGER.error("构建管道分隔二维码参数失败, field:{}", field.getName(), e);
                throw new BusinessException("构建二维码参数失败");
            }
        }
        return sb.toString();
    }

    /**
     * 获取带@QrField注解的字段，按order排序（带缓存）
     */
    private static final Map<Class<?>, List<Field>> QR_SORTED_FIELDS_CACHE = new HashMap<>();

    private List<Field> getQrSortedFields(Class<?> clazz) {
        return QR_SORTED_FIELDS_CACHE.computeIfAbsent(clazz, c -> {
            List<Field> list = new ArrayList<>();
            for (Field field : c.getDeclaredFields()) {
                if (field.isAnnotationPresent(QrField.class)) {
                    list.add(field);
                }
            }
            list.sort(Comparator.comparingInt(f -> f.getAnnotation(QrField.class).order()));
            return list;
        });
    }

    /**
     * 将字段值按类型格式化后base64URLEncode
     */
    private String formatAndEncodeFieldValue(Field field, Object value) {
        String formatted = formatFieldValue(field, value);
        /*try {
            return URLEncoder.encode(formatted, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return formatted;
        }*/
        return TlUtils.base64UrlEncode(formatted.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 将字段值按类型格式化为字符串
     */
    private String formatFieldValue(Field field, Object value) {
        if (value == null) {
            return "";
        }
        if (value instanceof Date) {
            return TlDateUtils.format((Date) value, TlDateUtils.YMD);
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).toPlainString();
        }
        return value.toString();
    }

    /**
     * 生成二维码图片并转为base64
     * @param content 二维码内容
     * @return base64编码的PNG图片
     */
    private String generateQrCodeImage(String content) throws IOException, WriterException {
        Integer qrCodeSize = appProperties.getQrCodeSize();
        int size = (qrCodeSize != null && qrCodeSize > 0) ? qrCodeSize : 300;
        byte[] qrCodeBytes = QrCodeUtils.createQrCodeToBytesCustomize(content, size);
        return TlUtils.base64Encode(qrCodeBytes);
    }

    // ==================== 报关单关注信息管理 ====================

    /**
     * 查询未申报/审核中关注信息列表（GCB表）
     * @param dto 查询条件
     * @return 关注信息列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public List<YjBgdgzxxVO> getYjBgdgzxxListGcb(YjBgdgzxxDTO dto) {
        return yjBgdgzxxMapper.listGcb(
                dto.getSwjgdm(),
                dto.getCkbgdh(),
                dto.getNsrsbh(),
                dto.getNsrmc(),
                dto.getCzrqStart(),
                dto.getCzrqEnd(),
                dto.getOrderSql()
        );
    }

    /**
     * 查询审核结束关注信息列表（JGB表）
     * @param dto 查询条件
     * @return 关注信息列表
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<YjBgdgzxxVO> getYjBgdgzxxListJgb(YjBgdgzxxDTO dto) {
        return yjBgdgzxxMapper.listJgb(
                dto.getSwjgdm(),
                dto.getCkbgdh(),
                dto.getNsrsbh(),
                dto.getNsrmc(),
                dto.getCzrqStart(),
                dto.getCzrqEnd(),
                dto.getOrderSql()
        );
    }

    /**
     * 根据企业税号和报关单号查询报关单详情
     * @param nsrsbh 企业税号
     * @param ckbgdh 报关单号
     * @param qxdm
     * @return 报关单详情
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public YjBgdgzxxDetailVO getYjBgdgzxxDetailByNsrsbh(String nsrsbh, String ckbgdh, String qxdm) {
        return yjBgdgzxxMapper.getBgdDetailByNsrsbh(nsrsbh, ckbgdh,qxdm);
    }

    /**
     * 新增报关单关注信息（保存到GCB表）
     * @param dto 新增参数
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public void addYjBgdgzxx(YjBgdgzxxAddDTO dto) {
        // 校验是否已存在
        YjBgdgzxxGcbModel param = new YjBgdgzxxGcbModel();
        param.setDjxh(new BigDecimal(dto.getDjxh()));
        param.setCkbgdh(dto.getCkbgdh());
        YjBgdgzxxGcbModel existModel = yjBgdgzxxGcbModelMapper.selectOne(param);
        if (existModel != null) {
            throw new BusinessException("该报关单已存在关注信息，请勿重复添加");
        }

        // 创建新记录
        YjBgdgzxxGcbModel model = new YjBgdgzxxGcbModel();
        model.setDjxh(new BigDecimal(dto.getDjxh()));
        model.setCkbgdh(dto.getCkbgdh());
        model.setGzxx(dto.getGzxx());
        model.setCzrDm(commonService.getCurrentUser().getCzryDm());
        model.setCzrq(new Date());
        yjBgdgzxxGcbModelMapper.insertSelective(model);
    }

    /**
     * 编辑报关单关注信息（GCB表）
     * @param dto 编辑参数
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public void updateYjBgdgzxx(YjBgdgzxxAddDTO dto) {
        YjBgdgzxxGcbModel param = new YjBgdgzxxGcbModel();
        param.setDjxh(new BigDecimal(dto.getDjxh()));
        param.setCkbgdh(dto.getCkbgdh());
        YjBgdgzxxGcbModel model = yjBgdgzxxGcbModelMapper.selectOne(param);
        if (model == null) {
            throw new BusinessException("未找到对应的关注信息记录");
        }
        model.setGzxx(dto.getGzxx());
        model.setCzrDm(commonService.getCurrentUser().getCzryDm());
        model.setCzrq(new Date());
        yjBgdgzxxGcbModelMapper.updateByPrimaryKey(model);
    }

    /**
     * 删除报关单关注信息（GCB表）
     * @param djxh 金三登记序号
     * @param ckbgdh 报关单号
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public void deleteYjBgdgzxx(String djxh, String ckbgdh) {
        YjBgdgzxxGcbModel param = new YjBgdgzxxGcbModel();
        param.setDjxh(new BigDecimal(djxh));
        param.setCkbgdh(ckbgdh);
        yjBgdgzxxGcbModelMapper.deleteByPrimaryKey(param);
    }

    /**
     * 迁移报关单关注信息到JGB表
     * 将zj_bjts用户下已转申报的报关单迁移到tl_tssh用户下，并从zj_bjts用户下清除
     * 确保zj_bjts用户下报关单关注信息都是未申报或审核在途的
     * 确保tl_tssh用户下报关单关注信息都是审核结束的
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public void transferBgdgzxxToJgb() {
        // 1. 查询zj_bjts用户下需要迁移的报关单列表（已转申报的）
        List<YjBgdgzxxGcbModel> list4Transfer = yjBgdgzxxMapper.listGcb4Transfer();

        if (list4Transfer == null || list4Transfer.isEmpty()) {
            return;
        }

        // 2. 批量插入数据到tl_tssh用户下的JGB表
        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);
        for (YjBgdgzxxGcbModel model : list4Transfer) {
            yjBgdgzxxMapper.insertToJgb(
                    model.getDjxh(),
                    model.getCkbgdh(),
                    model.getGzxx(),
                    model.getCzrDm(),
                    model.getCzrq()
            );
        }

        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
        // 3. 批量从zj_bjts用户下的GCB表删除数据
        yjBgdgzxxMapper.batchDeleteFromGcb(list4Transfer);
    }
}
