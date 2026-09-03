package com.tl.bjts.sw.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.conf.TaskProperties;
import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ProcParam;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.SjjcDynamicVo;
import com.tl.bjts.sw.model.vo.SjjcQyxxExcelVo;
import com.tl.bjts.sw.model.vo.SjjcTmsqkVo;
import com.tl.bjts.sw.model.vo.SjjcTswyQkVo;
import com.tl.bjts.sw.model.vo.jcfx.NsrdjxxVo;
import com.tl.bjts.sw.utils.GZipUitl;
import com.tl.bjts.sw.utils.TlDateUtils;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.ext.model.BaseListDTO;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author: Mamf
 * @date: 2021/11/25
 * @description 数据监测查询服务
 */
@Service
public class SjjcQueryService extends BasisService{

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    NsrSampleModelMapper nsrSampleModelMapper;

    @Autowired
    NsrBadjModelMapper nsrBadjModelMapper;

    @Autowired
    NsrSampleSubModelMapper nsrSampleSubModelMapper;

    @Autowired
    JcfxTaskModelMapper jcfxTaskModelMapper;

    @Autowired
    TlSjjcMapper tlSjjcMapper;

    @Autowired
    TlTjbbMapper tlTjbbMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    TaskProperties taskProperties;

    @Autowired
    AppProperties appProperties;

    @Autowired
    RedisDelayService redisDelayService;

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public SjjcDynamicVo getSjjcDynamicData(DynamicQueryDTO param) throws Exception {

        StringBuffer tips = new StringBuffer();
        JcfxTaskModel taskModel = getQueryTask(param,tips);

        String taskFlag = taskModel.getTaskFlag();
        if("1".equals(taskFlag)||"0".equals(taskFlag)){
            throw new BusinessException(22,"查询任务正在执行中，请稍后查询结果");
        }else if ("2".equals(taskFlag)){
            String unzip = GZipUitl.genUnzip(taskModel.getRespData());
            SjjcDynamicVo o = new Gson().fromJson(unzip, SjjcDynamicVo.class);

            List<String> retTitlList = o.getTitle().stream().filter(s -> !s.contains("同期-")).collect(Collectors.toList());
            o.setTitle(retTitlList);

            o.setTips(tips.toString());

            return o;
        }else {
            throw new BusinessException("查询异常，请联系技术运维人员");
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public ExcelResultDTO exportDynamicDataInit(DynamicQueryDTO param) throws Exception{

        ExcelResultDTO excelResultDTO = new ExcelResultDTO();

        param.setPageSize(appProperties.getPageSize());

        StringBuffer tips = new StringBuffer();
        JcfxTaskModel taskModel = getQueryTask(param,tips);

        String taskFlag = taskModel.getTaskFlag();
        if("1".equals(taskFlag)||"0".equals(taskFlag)){
            excelResultDTO.setPages(0);
        }else if ("2".equals(taskFlag)){
            String unzip = GZipUitl.genUnzip(taskModel.getRespData());
            SjjcDynamicVo vo = new Gson().fromJson(unzip, SjjcDynamicVo.class);

            excelResultDTO.setPages(vo.getList().getTotal());
            excelResultDTO.setPid(vo.getPid());

        }else {
            throw new BusinessException("准备数据失败");
        }

        return excelResultDTO;

    }


    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public SjjcDynamicVo getSjjcCkqkData(DynamicQueryDTO param) throws Exception {

        StringBuffer tips = new StringBuffer();
        JcfxTaskModel taskModel = getQueryTask(param, tips);

        String taskFlag = taskModel.getTaskFlag();
        if("1".equals(taskFlag)||"0".equals(taskFlag)){
            throw new BusinessException(22,"查询任务正在执行中，请稍后查询结果");
        }else if ("2".equals(taskFlag)){
            String unzip = GZipUitl.genUnzip(taskModel.getRespData());
            SjjcDynamicVo o = new Gson().fromJson(unzip, SjjcDynamicVo.class);


            List<String> retTitlList = new ArrayList<>();
            for (String s : o.getTitle()) {
                if(s.contains("同期-") && !s.contains("同期-0")){
                    continue;
                }else if(s.contains("同比-") && !s.contains("同比-0")){
                    continue;
                }else {
                    retTitlList.add(s);
                }

            }

            o.setTips(tips.toString());

            o.setTitle(retTitlList);


            return o;
        }else {
            throw new BusinessException("查询异常，请联系技术运维人员");
        }

    }

    /**
     * 获取查询任务，不存在则创建任务
     * @param param
     * @param tips
     * @return
     * @throws Exception
     */
    private JcfxTaskModel getQueryTask(DynamicQueryDTO param, StringBuffer tips) throws Exception {


        StringBuffer sb = new StringBuffer();

        boolean isMxDetail = false;

        /**
         * x为前缀的tjbbType类型为下钻明细查询,明细页翻页不需要直接提前初始化多页
         * 不带前缀或者带xls前缀的分别为查询首页或者excel导出所有数据需要加载全部数据
         */
        if(param.getTjbbType()!=null && param.getTjbbType().startsWith("x")){
            isMxDetail = true;
        }


        JcfxTaskModel taskModel=getTaskModelIfMx(isMxDetail,param,sb);

        if(taskModel==null){

            redisDelayService.putKeyValue(sb.toString(),"0");

            int i =1;
            String value;
            int waitSec = taskProperties.getTaskWaitSec();
            do{
                Thread.sleep(1000);
                value=redisDelayService.getValueByKey(sb.toString());
                if("1".equals(value)){
                    redisDelayService.removeValueByKey(sb.toString());
                }
            }while ("0".equals(value) && (i++)<waitSec);

            param.setFlushFlag("0");
            taskModel = getTaskModelIfMx(isMxDetail,param,sb);
        }else {
            //如果上次执行结果已经存在数据，则标记为已存在数据
            boolean isBefore=false;

            if(taskModel.getWcsj()!=null){
                String format = TlDateUtils.format(taskModel.getWcsj(), "yyyy-MM-dd");
                String now = TlDateUtils.format(new Date(), "yyyy-MM-dd");
                isBefore = format.compareTo(now)<0;
            }


            if("2".equals(taskModel.getTaskFlag()) && isBefore){
                tips.append("该统计条件下，已存在历史统计结果，上次统计时间："+TlDateUtils.format(taskModel.getWcsj(),"yyyy-MM-dd HH:mm:ss")).append(",是否立即查看结果？");
            }

        }

        return taskModel;
    }

    /**
     * 根据是否明细查询，从不同任务表返回查询任务
     * @param isMxDetail
     * @param param
     * @param sb
     * @return
     * @throws Exception
     */
    JcfxTaskModel  getTaskModelIfMx(boolean isMxDetail, DynamicQueryDTO param, StringBuffer sb) throws Exception {

        JcfxTaskModel jcfxTaskModel;
        if(isMxDetail){
            jcfxTaskModel = tjbbBasisService.getQuerySubDetailTask(param,sb);
        }else {
            //查新翻页数据数据时，taskModel返回对象永远不会为空
            jcfxTaskModel = tjbbBasisService.getQueryTask(param,sb);
        }

        return jcfxTaskModel;
    }


    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<NsrSampleModel> getNsrSampleList(BaseListDTO param, String swjgDm) {

        param.setOrderSql(" xgsj desc");

        PageHelper.startPage(param.getPageNo(), param.getPageSize());

        NsrSampleModel nsrSampleModel = new NsrSampleModel();
        nsrSampleModel.setSwjgdm(swjgDm);


        return nsrSampleModelMapper.select(nsrSampleModel);

    }

    /**
     * 获取样本组企业信息
     * @param id
     * @param swjgDm
     * @param pageNo
     * @param pageSize
     * @return
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<NsrSampleSubModel> getNsrSampleSubList(Long id, String swjgDm, Integer pageNo, Integer pageSize) {

        PageHelper.startPage(pageNo, pageSize);

        return tlSjjcMapper.selectNsrSampleSubList(id,swjgDm);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<NsrdjxxVo> getNsrdjxxList(NsrxxQueryDTO param, String swjgDm) {

        PageHelper.startPage(param.getPageNo(), param.getPageSize());

        return tlSjjcMapper.getNsrdjxxList(param,TlUtils.getPreSwjgdm(swjgDm));
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void addNsrSample(NsrSampleModel param, String swjgDm, String czryDm) {

        if(StringUtils.isEmpty(param.getSname())){
            throw new BusinessException("分组名称不能为空");
        }

        if(StringUtils.isEmpty(param.getSyfwSwjg())){
            throw new BusinessException("应用范围不能为空");
        }

        param.setZid(commonService.getDBPk("JCFX_NSR_SAMPLE"));
        param.setSwjgdm(swjgDm);
        param.setSyfwSwjg(TlUtils.getPreSwjgdm(param.getSyfwSwjg()));
        param.setXgsj(new Date());
        param.setQybz("Y");
        param.setXgr(czryDm);

        nsrSampleModelMapper.insert(param);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void updateQybz(NsrSampleModel param, String swjgDm, String czryDm) {

        if(param.getZid()==null || (StringUtils.isEmpty(param.getQybz()) && StringUtils.isEmpty(param.getSname()))){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }


        Example ep = new Example(NsrSampleModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("zid",param.getZid());
        criteria.andEqualTo("swjgdm",swjgDm);


        NsrSampleModel obj = new NsrSampleModel();
        obj.setQybz(param.getQybz());
        obj.setSname(param.getSname());
        obj.setXgr(czryDm);
        obj.setXgsj(new Date());

        nsrSampleModelMapper.updateByExampleSelective(obj,ep);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    @Transactional
    public void delNsrSample(Long zid, String swjgDm) {

        Example ep = new Example(NsrSampleModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("zid",zid);
        criteria.andEqualTo("swjgdm",swjgDm);

        int i = nsrSampleModelMapper.deleteByExample(ep);

        if(i>0){
            Example epsub = new Example(NsrSampleSubModel.class);
            Example.Criteria criteriaSub = epsub.createCriteria();
            criteriaSub.andEqualTo("zid",zid);

            nsrSampleModelMapper.deleteByExample(epsub);

        }else {
            throw new BusinessException("删除数据不存在");
        }
    }

    /**
     * 添加企业至企业分组
     * @param param
     * @param swjgDm
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void addNsrSampleSub(SjjcSamplePramDTO param, String swjgDm) {

        Long zid = param.getZid();

        List<NsrBadjModel> nsrBadjModels = getAddQyxx(param.getDjxhs(),swjgDm);

        for (NsrBadjModel nsrBadjModel : nsrBadjModels) {

            NsrSampleSubModel nsrSampleSubModel = new NsrSampleSubModel();
            nsrSampleSubModel.setZid(zid);
            nsrSampleSubModel.setNsrsbh(nsrBadjModel.getNsrsbh());
            nsrSampleSubModel.setNsrmc(nsrBadjModel.getNsrmc());
            nsrSampleSubModel.setDjxh(nsrBadjModel.getDjxh());
            nsrSampleSubModel.setId(commonService.getDBPk("JCFX_NSR_SAMPLE_SUB"));
            nsrSampleSubModel.setQybz("Y");

            nsrSampleSubModelMapper.insert(nsrSampleSubModel);

        }

    }

    private List<NsrBadjModel> getAddQyxx(List<BigDecimal> djxhs, String swjgDm) {

        Example ep = new Example(NsrBadjModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andIn("djxh",djxhs);
        criteria.andLike("swjgdm",TlUtils.getPreSwjgdm(swjgDm)+"%");


        return nsrBadjModelMapper.selectByExample(ep);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void delNsrSampleSub(SjjcSamplePramDTO param, String swjgDm) {

        if(param.getZid()==null){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        NsrSampleModel nsrSampleModel = new NsrSampleModel();
        nsrSampleModel.setZid(param.getZid());
        nsrSampleModel.setSwjgdm(swjgDm);

        NsrSampleModel model = nsrSampleModelMapper.selectOne(nsrSampleModel);

        if(model==null){
            throw new BusinessException("分组信息不存在");
        }


        Example ep = new Example(NsrSampleSubModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("zid",param.getZid());
        criteria.andIn("id",param.getIds());

        nsrSampleSubModelMapper.deleteByExample(ep);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<NsrSampleSubModel> getNsrSampleSubListByZid(Long zid) {

        Example ep = new Example(NsrSampleSubModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("zid",zid);

        List<NsrSampleSubModel> subModels = nsrSampleSubModelMapper.selectByExample(ep);

        return subModels;

    }

    /**
     * 查询免退税情况统计数据
     * @param param
     * @param swjgDm
     * @return
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public SjjcDynamicVo queryMdtsTjData(DynamicQueryDTO param, String swjgDm) {
        String ssnyStart = param.getSsnyStart();
        String ssnyEnd = param.getSsnyEnd();

        String lastYearSsnyStart = TlDateUtils.getLastYearSsny(ssnyStart);
        String lastYearSsnyEnd = TlDateUtils.getLastYearSsny(ssnyEnd);

        String preSwjgdm = TlUtils.getPreSwjgdm(swjgDm);

        String swjgdm =  TlUtils.getPreSwjgdm(param.getSwjgDm());

        PageHelper.startPage(param.getPageNo(), param.getPageSize());

        Page<SjjcTmsqkVo>  retList = tlSjjcMapper.selectMdtsTjDataList(ssnyStart,ssnyEnd,lastYearSsnyStart,lastYearSsnyEnd,preSwjgdm,swjgdm);

        BigDecimal tb;
        for (SjjcTmsqkVo sjjcTmsqkVo : retList) {
             tb = sjjcTmsqkVo.getBaHsL()==null||sjjcTmsqkVo.getBaHsL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                     :(sjjcTmsqkVo.getBaHs().subtract(sjjcTmsqkVo.getBaHsL())).divide(sjjcTmsqkVo.getBaHsL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
             sjjcTmsqkVo.setBaHsTb(tb);

             //申报
            tb = sjjcTmsqkVo.getSbHsL()==null||sjjcTmsqkVo.getSbHsL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getSbHs().subtract(sjjcTmsqkVo.getSbHsL())).divide(sjjcTmsqkVo.getSbHsL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setSbHsTb(tb);

            tb = sjjcTmsqkVo.getSbTseL()==null||sjjcTmsqkVo.getSbTseL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getSbTse().subtract(sjjcTmsqkVo.getSbTseL())).divide(sjjcTmsqkVo.getSbTseL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setSbTseTb(tb);

            tb = sjjcTmsqkVo.getSbMdeL()==null||sjjcTmsqkVo.getSbMdeL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getSbMde().subtract(sjjcTmsqkVo.getSbMdeL())).divide(sjjcTmsqkVo.getSbMdeL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setSbMdeTb(tb);


            //核准
            tb = sjjcTmsqkVo.getHzHsL()==null||sjjcTmsqkVo.getHzHsL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getHzHs().subtract(sjjcTmsqkVo.getHzHsL())).divide(sjjcTmsqkVo.getHzHsL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setHzHsTb(tb);

            tb = sjjcTmsqkVo.getHzTseL()==null||sjjcTmsqkVo.getHzTseL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getHzTse().subtract(sjjcTmsqkVo.getHzTseL())).divide(sjjcTmsqkVo.getHzTseL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setHzTseTb(tb);

            tb = sjjcTmsqkVo.getHzMdeL()==null||sjjcTmsqkVo.getHzMdeL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getHzMde().subtract(sjjcTmsqkVo.getHzMdeL())).divide(sjjcTmsqkVo.getHzMdeL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setHzMdeTb(tb);


            //办理
            tb = sjjcTmsqkVo.getBlHsL()==null||sjjcTmsqkVo.getBlHsL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getBlHs().subtract(sjjcTmsqkVo.getBlHsL())).divide(sjjcTmsqkVo.getBlHsL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setBlHsTb(tb);

            tb = sjjcTmsqkVo.getBlTseL()==null||sjjcTmsqkVo.getBlTseL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getBlTse().subtract(sjjcTmsqkVo.getBlTseL())).divide(sjjcTmsqkVo.getBlTseL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setBlTseTb(tb);

            tb = sjjcTmsqkVo.getBlMdeL()==null||sjjcTmsqkVo.getBlMdeL().compareTo(BigDecimal.ZERO)==0 ? BigDecimal.ZERO
                    :(sjjcTmsqkVo.getBlMde().subtract(sjjcTmsqkVo.getBlMdeL())).divide(sjjcTmsqkVo.getBlMdeL(),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
            sjjcTmsqkVo.setBlMdeTb(tb);

        }

        SjjcDynamicVo sjjcDynamicVo = new SjjcDynamicVo();


        Page<LinkedHashMap> dataList = new Page<LinkedHashMap>();


        for (SjjcTmsqkVo sjjcTmsqkVo : retList) {

            LinkedHashMap newMap = new LinkedHashMap();

            newMap.put("税务机关",sjjcTmsqkVo.getSwjgdm());

            newMap.put("户数",sjjcTmsqkVo.getBaHs());
            newMap.put("同比-0",sjjcTmsqkVo.getBaHsTb());

            newMap.put("申报户数",sjjcTmsqkVo.getSbHs());
            newMap.put("同比-1",sjjcTmsqkVo.getSbHsTb());

            newMap.put("申报退税额",sjjcTmsqkVo.getSbTse());
            newMap.put("同比-2",sjjcTmsqkVo.getSbTseTb());

            newMap.put("申报免抵额",sjjcTmsqkVo.getSbMde());
            newMap.put("同比-3",sjjcTmsqkVo.getSbMdeTb());



            newMap.put("核准户数",sjjcTmsqkVo.getHzHs());
            newMap.put("同比-4",sjjcTmsqkVo.getHzHsTb());

            newMap.put("核准退税额",sjjcTmsqkVo.getHzTse());
            newMap.put("同比-5",sjjcTmsqkVo.getHzTseTb());

            newMap.put("核准免抵额",sjjcTmsqkVo.getHzMde());
            newMap.put("同比-6",sjjcTmsqkVo.getHzMdeTb());



            newMap.put("办理户数",sjjcTmsqkVo.getBlHs());
            newMap.put("同比-7",sjjcTmsqkVo.getBlHsTb());

            newMap.put("办理退税额",sjjcTmsqkVo.getBlTse());
            newMap.put("同比-8",sjjcTmsqkVo.getBlTseTb());

            newMap.put("办理免抵额",sjjcTmsqkVo.getBlMde());
            newMap.put("同比-9",sjjcTmsqkVo.getBlMdeTb());


            dataList.setPageNum(retList.getPageNum());
            dataList.setPageSize(retList.getPageSize());
            dataList.setPages(retList.getPages());
            dataList.setTotal(retList.getTotal());

            dataList.setStartRow(retList.getStartRow());
            dataList.setEndRow(retList.getEndRow());


            dataList.add(newMap);
        }


        fillTtile(dataList,sjjcDynamicVo);

        return sjjcDynamicVo;

    }

    private void fillTtile( Page<LinkedHashMap> dataList ,SjjcDynamicVo sjjcDynamicVo){

        List<String> titles = new ArrayList<>();
        if(dataList.size()>0){
            sjjcDynamicVo.setList(TlUtils.dealPageInfo(dataList));
            for (Object o : dataList.get(0).keySet()) {
                titles.add(String.valueOf(o));
            }
            sjjcDynamicVo.setTitle(titles);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public SjjcDynamicVo queryTsywxxData(DynamicQueryDTO param, String swjgDm) {

        String ssnyStart = param.getSsnyStart();
        String ssnyEnd = param.getSsnyEnd();

        String lastYearSsnyStart = TlDateUtils.getLastYearSsny(ssnyStart);
        String lastYearSsnyEnd = TlDateUtils.getLastYearSsny(ssnyEnd);

        String preSwjgdm = TlUtils.getPreSwjgdm(swjgDm);

        List<DynamicQueryDTO.FzItem> fzItems = param.getFzItems();
        String tsywlxSql = "";
        for (DynamicQueryDTO.FzItem fzItem : fzItems) {
            if(fzItem.getZbxmbm().toUpperCase().equals("CX.TSYW")){
                List<String> values = fzItem.getValues();
                String join = StringUtils.join(values, "','");
                tsywlxSql = "'"+join+"'";
            }
        }

        PageHelper.startPage(param.getPageNo(), param.getPageSize());

        Page<SjjcTswyQkVo>  retList = tlSjjcMapper.selectTsywTjDataList(ssnyStart,ssnyEnd,preSwjgdm,tsywlxSql);

        List<SjjcTswyQkVo>  lastList = tlSjjcMapper.selectTsywTjDataList(lastYearSsnyStart,lastYearSsnyEnd,preSwjgdm,tsywlxSql);

        Map<String,SjjcTswyQkVo> lastYearDataMap = new HashMap<>();

        for (SjjcTswyQkVo sjjcTswyQkVo : lastList) {
            lastYearDataMap.put(sjjcTswyQkVo.getTsywlx()+"-"+sjjcTswyQkVo.getSwjg(),sjjcTswyQkVo);
        }



        SjjcDynamicVo sjjcDynamicVo = new SjjcDynamicVo();


        Page<LinkedHashMap> dataList = new Page<LinkedHashMap>();


        for (SjjcTswyQkVo sjjcTswyQkVo : retList) {

            String key = sjjcTswyQkVo.getTsywlx() + "-" + sjjcTswyQkVo.getSwjg();
            SjjcTswyQkVo qkVo = lastYearDataMap.get(key);

            if(qkVo!=null){
                BigDecimal mylaj = qkVo.getMylaj();
                BigDecimal rmblaj = qkVo.getRmblaj();
                BigDecimal sbTmse = qkVo.getSbTmse();
                BigDecimal hztmse = qkVo.getHztmse();

                sjjcTswyQkVo.setMylajTb(BigDecimal.ZERO);
                sjjcTswyQkVo.setRmblajTb(BigDecimal.ZERO);
                sjjcTswyQkVo.setSbTmseTb(BigDecimal.ZERO);
                sjjcTswyQkVo.setHztmseTb(BigDecimal.ZERO);

                if(mylaj!=null && mylaj.compareTo(BigDecimal.ZERO)>0){

                    BigDecimal tb = (sjjcTswyQkVo.getMylaj().subtract(mylaj)).divide(mylaj, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
                    sjjcTswyQkVo.setMylajTb(tb);
                }

                if(rmblaj!=null && rmblaj.compareTo(BigDecimal.ZERO)>0){
                    BigDecimal tb = (sjjcTswyQkVo.getRmblaj().subtract(rmblaj)).divide(rmblaj, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
                    sjjcTswyQkVo.setRmblajTb(tb);
                }

                if(sbTmse!=null && sbTmse.compareTo(BigDecimal.ZERO)>0){
                    BigDecimal tb = (sjjcTswyQkVo.getSbTmse().subtract(sbTmse)).divide(sbTmse, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
                    sjjcTswyQkVo.setSbTmseTb(tb);
                }

                if(hztmse!=null && hztmse.compareTo(BigDecimal.ZERO)>0){
                    BigDecimal tb = (sjjcTswyQkVo.getHztmse().subtract(hztmse)).divide(hztmse, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100l));
                    sjjcTswyQkVo.setHztmseTb(tb);
                }
            }

            LinkedHashMap newMap = new LinkedHashMap();

            newMap.put("退税机关代码",sjjcTswyQkVo.getSwjg());
            newMap.put("特殊业务",sjjcTswyQkVo.getTsywlx());

            newMap.put("申报出口额（美元）",sjjcTswyQkVo.getMylaj());
            newMap.put("同比-0",sjjcTswyQkVo.getMylajTb());

            newMap.put("申报出口额（人民币）",sjjcTswyQkVo.getRmblaj());
            newMap.put("同比-1",sjjcTswyQkVo.getRmblajTb());

            newMap.put("申报退（免）税额",sjjcTswyQkVo.getSbTmse());
            newMap.put("同比-2",sjjcTswyQkVo.getSbTmseTb());

            newMap.put("业务核准退（免）税额",sjjcTswyQkVo.getHztmse());
            newMap.put("同比-3",sjjcTswyQkVo.getHztmseTb());


            dataList.setPageNum(retList.getPageNum());
            dataList.setPageSize(retList.getPageSize());
            dataList.setPages(retList.getPages());
            dataList.setTotal(retList.getTotal());

            dataList.setStartRow(retList.getStartRow());
            dataList.setEndRow(retList.getEndRow());


            dataList.add(newMap);
        }

        fillTtile(dataList,sjjcDynamicVo);

        return sjjcDynamicVo;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void importQyxxGroupData(List<SjjcQyxxExcelVo> allData, Long zid) {

        if(allData.size()==0){
            throw new BusinessException("请在文件中输入内容");
        }

        List<String> nsrList = new ArrayList<>();
        for (int i=0;i<allData.size();i++){
            SjjcQyxxExcelVo qyxxExcelVo = allData.get(i);
            String nsrsbh = qyxxExcelVo.getNsrsbh();

            nsrList.add(nsrsbh);

        }


        Example ep = new Example(NsrBadjModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andIn("nsrsbh",nsrList);
        List<NsrBadjModel> nsrBadjModels = nsrBadjModelMapper.selectByExample(ep);


        //过滤原有数据，增量添加
        NsrSampleSubModel param = new NsrSampleSubModel();
        param.setZid(zid);
        List<NsrSampleSubModel> select = nsrSampleSubModelMapper.select(param);
        Set<String> collect = select.stream().map(NsrSampleSubModel::getNsrsbh).collect(Collectors.toSet());

        SjjcQueryService proxy = (SjjcQueryService)AopContext.currentProxy();
        proxy.saveNsrSampleSubData(nsrBadjModels,zid,collect);

    }

    @Transactional
    public void saveNsrSampleSubData(List<NsrBadjModel> nsrBadjModels, Long zid,Set<String> collect){

        for (NsrBadjModel nsrBadjModel : nsrBadjModels) {

            if(collect.contains(nsrBadjModel.getNsrsbh())){
                continue;
            }

            NsrSampleSubModel nsrSampleSubModel = new NsrSampleSubModel();

            nsrSampleSubModel.setDjxh(nsrBadjModel.getDjxh());
            nsrSampleSubModel.setId(commonService.getDBPk("JCFX_NSR_SAMPLE_SUB"));
            nsrSampleSubModel.setNsrsbh(nsrBadjModel.getNsrsbh());
            nsrSampleSubModel.setNsrmc(nsrBadjModel.getNsrmc());
            nsrSampleSubModel.setQybz("Y");
            nsrSampleSubModel.setZid(zid);

            nsrSampleSubModelMapper.insert(nsrSampleSubModel);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<JcfxTaskModel> getTaskRecords(NsrxxQueryDTO param, String swjgDm) {

        PageHelper.startPage(param.getPageNo(), param.getPageSize(),param.getOrderSql());

        JcfxTaskModel p = new JcfxTaskModel();
        p.setSwjgdm(swjgDm);
        p.setBbtype(param.getTjbbType());

        return jcfxTaskModelMapper.select(p);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void jkmRefreshProc(NsrsbhDTO nsrsbhDTO) {

        ProcParam param = new ProcParam();

        if(nsrsbhDTO.getDjxh()!=null){
            param.setP_DJXH(new BigDecimal(nsrsbhDTO.getDjxh()));
        }else {
            return;
        }

        if(StringUtils.isEmpty(nsrsbhDTO.getSssq())){
            Date date = TlDateUtils.addDay(TlDateUtils.getFirstDayOfMonth(), -1);
            nsrsbhDTO.setSssq(TlDateUtils.format(date,"yyyyMM"));
        }

        param.setP_SSSQ(nsrsbhDTO.getSssq());
        param.setP_ZBDM("");
        param.setProcname("PRO_JKGL_COMPUTE_ZB");
        tlTjbbMapper.excuteJkglProcedure(param);
    }
}
