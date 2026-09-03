package com.tl.bjts.sw.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.dao.TlMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.*;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.model.vo.jcfx.FzHzInitVo;
import com.tl.bjts.sw.model.vo.jcfx.SelectItemVo;
import com.tl.bjts.sw.model.vo.jcfx.ZbItemVo;
import com.tl.bjts.sw.utils.*;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StopWatch;
import org.springframework.web.multipart.MultipartFile;
import tk.mybatis.mapper.entity.Example;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import java.io.*;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.*;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Author：Mamf
 * @Date: 2019/9/16.
 * @Description:
 */
@Service
public class TjbbBasisService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    JcfxTaskSubModelMapper jcfxTaskSubModelMapper;

    @Autowired
    TjbbReportModelMapper tjbbReportModelMapper;

    @Autowired
    TjbbTbxxMapper tjbbTbxxMapper;

    @Autowired
    TjbbHeaderModelMapper tjbbHeaderModelMapper;

    @Autowired
    TjbbColModelMapper tjbbColModelMapper;

    @Autowired
    TjbbLineItemModelMapper tjbbLineItemModelMapper;

    @Autowired
    TjbbReportFormulaMapper tjbbReportFormulaMapper;

    @Autowired
    TjbbTaskModelMapper tjbbTaskModelMapper;

    @Autowired
    TjbbTaskSubModelMapper tjbbTaskSubModelMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    TlTjbbMapper tlTjbbMapper;

    @Autowired
    JxlExcelUtil excelUtil;

    @Autowired
    TjbbReportItemMapper tjbbReportItemMapper;

    @Autowired
    TlSWJGProfileMapper tlSWJGProfileMapper;

    @Autowired
    TjbbCzLogModelMapper tjbbCzLogModelMapper;

    @Autowired
    ZbItemCacheService zbItemCacheService;

    @Autowired
    DictinfoCacheService dictinfoCacheService;

    @Autowired
    TjbbReportDynamicMapper tjbbReportDynamicMapper;


    @Autowired
    JcfxZbxmModelMapper jcfxZbxmModelMapper;

    @Autowired
    SjjcQueryService sjjcQueryService;

    @Autowired
    TlMapper tlMapper;

    @Autowired
    JcfxTaskModelMapper jcfxTaskModelMapper;

    @Autowired
    SysParamModelMapper sysParamModelMapper;

    @Autowired
    DataSource datasource;

    @Autowired
    RedisDelayService redisDelayService;

    @Autowired
    AppProperties appProperties;


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public HeadLineVo getHeadLine(String bbdm) {

        HeadLineVo retVo=new HeadLineVo();

        List<List<HeadLineVo.Header>> header = new ArrayList<>();
        List<List<HeadLineVo.Header>> liner = new ArrayList<>();

        retVo.setHeader(header);
        retVo.setLiner(liner);


        Example ep=new Example(TjbbHeaderModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbdm",bbdm);
        ep.setOrderByClause("type,horder,vorder");

        List<TjbbHeaderModel> headerModels = tjbbHeaderModelMapper.selectByExample(ep);

        int horder4Head=-1;
        int horder4Line=-1;
        List<HeadLineVo.Header> headers=new ArrayList<>();
        List<HeadLineVo.Header> liners=new ArrayList<>();
        for(TjbbHeaderModel headerModel:headerModels){
            if("1".equals(headerModel.getType()) ){
                if(headerModel.getHorder().intValue()!=horder4Head){
                    headers=new ArrayList<>();
                    header.add(headers);
                    horder4Head=headerModel.getHorder().intValue();
                }
                HeadLineVo headLineVo = new HeadLineVo();
                HeadLineVo.Header headerContent=headLineVo.new Header();
                BeanUtils.copyProperties(headerModel,headerContent);

                //为了前端提高性能，封装结构多添加一个CSSVo的节点
                CssVo css=new CssVo();
                boolean isEmpt=StringUtils.isBlank(headerContent.getDisphight());
                css.setHeight(isEmpt?"auto":headerContent.getDisphight()+"px");
                isEmpt=StringUtils.isBlank(headerContent.getDispwidth());
                css.setWidth(isEmpt?"auto":headerContent.getDispwidth()+"px");
                headerContent.setCss(css);

                headers.add(headerContent);

            }else{

                if(headerModel.getHorder().intValue()!=horder4Line){
                    liners=new ArrayList<>();
                    liner.add(liners);
                    horder4Line=headerModel.getHorder().intValue();
                }

                HeadLineVo headLineVo = new HeadLineVo();
                HeadLineVo.Header headerContent=headLineVo.new Header();
                BeanUtils.copyProperties(headerModel,headerContent);

                //为了前端提高性能，封装结构多添加一个CSSVo的节点
                CssVo css=new CssVo();
                boolean isEmpt=StringUtils.isBlank(headerContent.getDisphight());
                css.setHeight(isEmpt?"auto":headerContent.getDisphight()+"px");
                isEmpt=StringUtils.isBlank(headerContent.getDispwidth());
                css.setWidth(isEmpt?"auto":headerContent.getDispwidth()+"px");
                headerContent.setCss(css);

                liners.add(headerContent);

            }
        }

        List<TjbbColModel> colModels = getColumns(bbdm);


        //2.封装数据绑定column名
        List<HeadLineVo.ColumnProfile> column = new ArrayList<>();

        for(TjbbColModel colModel:colModels){
            HeadLineVo.ColumnProfile columnProfile=retVo.new ColumnProfile();
            BeanUtils.copyProperties(colModel,columnProfile);
            if(colModel.getDegree()!=null){
                columnProfile.setDegree(colModel.getDegree().toString());
            }
            column.add(columnProfile);
        }

        retVo.setColumn(column);

        //3.封装行列公式

        for(int i=1;i<=2;i++){

            Example formuEp=new Example(TjbbReportFormula.class);
            Example.Criteria crit = formuEp.createCriteria();
            crit.andEqualTo("bbdm",bbdm);
            crit.andEqualTo("type",i+"");
            crit.andNotLike("formula","BZ:%");
            formuEp.setOrderByClause("yxj");

            List<TjbbReportFormula> formulas = tjbbReportFormulaMapper.selectByExample(formuEp);

            List<String> strings=new ArrayList<>();
            for(TjbbReportFormula formula:formulas){
                strings.add(formula.getFormula());
            }

            if(i==1){
                retVo.setHeaderFormula(strings);
            }else {
                retVo.setLinerFormula(strings);
            }

        }

        //4封装比重公式

        Example formuEp=new Example(TjbbReportFormula.class);
        Example.Criteria crit = formuEp.createCriteria();
        crit.andEqualTo("bbdm",bbdm);
        crit.andEqualTo("type","1");
        crit.andLike("formula","BZ:%");
        formuEp.setOrderByClause("yxj");

        List<TjbbReportFormula> formulas = tjbbReportFormulaMapper.selectByExample(formuEp);

        List<String> strings=new ArrayList<>();
        for(TjbbReportFormula formula:formulas){
            String s = formula.getFormula();
            String[] split = s.split("BZ:");
            strings.add(split[1]);
        }

        retVo.setBzFormula(strings);


        return retVo;

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbColModel> getColumns(String bbdm){
        Example ep4Col=new Example(TjbbColModel.class);
        Example.Criteria criteria4Col = ep4Col.createCriteria();
        criteria4Col.andEqualTo("bbdm",bbdm);
        criteria4Col.andIsNotNull("showorder");
        ep4Col.setOrderByClause("showorder");

        return tjbbColModelMapper.selectByExample(ep4Col);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbColModel> getColumns4Tjfx(String bbdm){
        Example ep4Col=new Example(TjbbColModel.class);
        Example.Criteria criteria4Col = ep4Col.createCriteria();
        criteria4Col.andEqualTo("bbdm",bbdm);
        criteria4Col.andIsNotNull("xlscol");
        ep4Col.setOrderByClause(" to_number(xlscol) ");

        return tjbbColModelMapper.selectByExample(ep4Col);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public TjbbReportModel getTjbbProfile(String bbdm) {

        return tjbbReportModelMapper.selectByPrimaryKey(bbdm);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbReportModel> getTjbbProfileAll() {

        Example ep=new Example(TjbbReportModel.class);
        ep.setOrderByClause("showorder");

        return tjbbReportModelMapper.selectByExample(ep);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List loaddata(String bbdm, String ssny, TjbbTaskDTO tjbbTaskDTO) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        String fname = model.getFname();
        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String preSwjgdm=commonService.getQxdm();
        String prochz = model.getProchz();
        //boolean isProchz = !StringUtils.isBlank(prochz);

        if(tjbbTaskDTO!=null){
            PageHelper.startPage(tjbbTaskDTO.getPageNo(), tjbbTaskDTO.getPageSize());
        }

        //根据不同报表查询不同SQL
        String hztype = model.getHztype();
        boolean isNotXj=preSwjgdm.length()<=5;
        if("3".equals(hztype) && isNotXj ){
            boolean isDs=preSwjgdm.length()==5;

            return tlTjbbMapper.loaddataMxAll(bbdm,ssny,fname,swjgDm,isDs,model.getBbdldm());
        }else if("5".equals(hztype) && isNotXj ){

            List<Map> hj = tlTjbbMapper.loaddata(bbdm, ssny, fname, swjgDm);

            List<TjbbColModel> columns = getColumns(bbdm);
            TjbbColModel colModel = columns.get(0);
            if(!hj.isEmpty()){
                Map map = hj.get(0);
                map.put(colModel.getFname(),"合计");
            }
            List<Map> mxs = tlTjbbMapper.loaddataMx(bbdm, ssny, fname, swjgDm, preSwjgdm, model.getBbdldm());
            hj.addAll(mxs);

            return hj;

        }else {
            return tlTjbbMapper.loaddata(bbdm,ssny,fname,swjgDm);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List loaddataBySwjgdm(String bbdm, String ssny, String swjgdm, TjbbTaskDTO tjbbTaskDTO) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        String fname = model.getFname();
        String curSwjgdm = commonService.getCurrentUser().getSwjgDm();

        if(tjbbTaskDTO!=null){
            PageHelper.startPage(tjbbTaskDTO.getPageNo(), tjbbTaskDTO.getPageSize());
        }

        String bbtype = model.getHztype();
        if("3".equals(bbtype) || "5".equals(bbtype)){
            //swjgdm= TlUtils.getPreSwjgdm(swjgdm);
            return tlTjbbMapper.loaddataBySwjgdmMx(bbdm,ssny,fname,swjgdm);
        }else {
            return tlTjbbMapper.loaddataBySwjgdm(bbdm,ssny,fname,curSwjgdm,swjgdm);
        }

    }

    private void importHeaderExcel(List<TjbbHeaderModel> headerList) {

        if(headerList.size()>0){
            String bbdm = headerList.get(0).getBbdm();
            TjbbHeaderModel p=new TjbbHeaderModel();
            p.setBbdm(bbdm);
            List<TjbbHeaderModel> select = tjbbHeaderModelMapper.select(p);
            if(select.size()>0){
                throw new BusinessException("报表代码："+bbdm+",配置已存在");
            }
        }

        TjbbBasisService basisService = (TjbbBasisService) AopContext.currentProxy();
        basisService.saveHeader(headerList);
    }

    @Transactional
    public void saveHeader(List<TjbbHeaderModel> headerList){
        for(TjbbHeaderModel headerModel:headerList){
            tjbbHeaderModelMapper.insert(headerModel);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbHeaderModel> initLineItem(String bbdm,String isUpdateItem) {
        List<TjbbHeaderModel> lineItemList = tlTjbbMapper.initLineItem(bbdm);

        //选择性根据用户选择绝对是否需要更新指标定义项
        if(isUpdateItem==null || "true".equals(isUpdateItem)){
            for(TjbbHeaderModel headerModel:lineItemList){
                TjbbLineItemModel lineItemModel=new TjbbLineItemModel();
                lineItemModel.setBbdm(bbdm);
                lineItemModel.setAllowupdate("Y");
                lineItemModel.setLcmc(headerModel.getShowname());
                lineItemModel.setShoworder(headerModel.getHorder());
                lineItemModel.setQybj("Y");
                lineItemModel.setAllowformula("Y");
                lineItemModel.setHztype("1");

                BigDecimal horder = headerModel.getHorder();
                String s = horder.toString();
                s=s.length()==1?"0"+s:s;
                lineItemModel.setBblc(s);
                lineItemModel.setXlsrow(headerModel.getHorder().toString());

                tjbbLineItemModelMapper.insertSelective(lineItemModel);
            }
        }
        return lineItemList;
    }

    private void insertFormula(String bbdm, String type, String trim,Integer yxj) {

        TjbbReportFormula formula=new TjbbReportFormula();
        formula.setId(new BigDecimal(commonService.getDBPk("TJBB_REPORT_FORMULA")));
        formula.setBbdm(bbdm);
        formula.setQybz("Y");
        formula.setType(type);
        formula.setFormula(trim);
        formula.setYxj(new BigDecimal(yxj));

        trim=trim.replace("（", "(");
        trim=trim.replace("）", ")");

        if("1".equals(type)){
            formula.setFormula(repleaceFormual(bbdm,trim));
        }else{
            formula.setFormula(trim.replaceAll("\\s+",""));
        }

        if(formula.getFormula().contains("/")){
            formula.setIshzjs("1");
        }
        tjbbReportFormulaMapper.insert(formula);

    }

    public   String repleaceFormual(String bbdm,String formula ){

        String spiltRules = "\\+|-|\\*|/|=|\\(|\\)";

        String[] array = formula.split(spiltRules);

        StringBuffer str=new StringBuffer();
        int index=0;
        int sublen=0;
        for (String s : array) {
            if(StringUtils.isNotBlank(s)){
                String xlscol = getColByXlscol(bbdm, s);
                if(StringUtils.isBlank(xlscol)){
                    throw new BusinessException("未找到下标列【"+s+"】对应配置字段列");
                }

                formula=formula.replaceFirst(s,"("+xlscol+")");

                index=formula.indexOf(xlscol);
                sublen=xlscol.length();

                str.append(formula.substring(0,index+sublen));
                formula=formula.substring(index+sublen,formula.length());
            }

        }

        return str.append(formula).toString();
    }


    private String getColByXlscol(String bbdm,String colsNum){

        return tlTjbbMapper.getColByXlscol(bbdm,colsNum);

    }

    private List<TjbbHeaderModel> getHeadLineFormula(String bbdm) {

        return tlTjbbMapper.getHeadLineFormula(bbdm);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbTaskVo> getTjbbTaskBySsny(String ssny,String swjgdm) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        if(StringUtils.isNotBlank(swjgdm)){ //支持虚拟税务机关  By 2020.6.8
            swjgDm=swjgdm;
        }

        return tlTjbbMapper.getTaskList(swjgDm,ssny);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbTaskSubVo> getTjbbTaskSubList(String ssny, String bbdldm,String swjgDm) {

        return tlTjbbMapper.getTaskSubList(swjgDm,ssny,bbdldm);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public PageInfo getTjbbTaskReceive(String ssny, String bbdldm) {

        List<TjbbTaskVo> retList=new ArrayList<>();

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        Example example=new Example(TjbbTaskModel.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("sjswjg",swjgDm);
        criteria.andEqualTo("ny",ssny);
        criteria.andEqualTo("bbdldm",bbdldm);
        example.orderBy("swjgdm");

        List<TjbbTaskModel> select = tjbbTaskModelMapper.selectByExample(example);

        PageInfo pageInfo = new BaseController().dealPageInfo(select);

        for(TjbbTaskModel model:select){
            TjbbTaskVo tjbbTaskVo=new TjbbTaskVo();
            BeanUtils.copyProperties(model,tjbbTaskVo);

            retList.add(tjbbTaskVo);
        }

        pageInfo.setRows(retList);

        return pageInfo;
    }

    private boolean checkVirSwjgIsAllSb(String swjgdm,String ssny,String bbdldm) {

        int ret = tlMapper.countVirswjgSb(swjgdm,ssny,bbdldm);
        if(ret>0){
            return false;
        }else {
            return true;
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void checkAllSubmit(TjbbTaskDTO dto){

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        TjbbTaskModel p=new TjbbTaskModel();
        p.setSjswjg(swjgDm);
        p.setNy(dto.getSsny());
        p.setBbdldm(dto.getBbdldm());

        List<TjbbTaskModel> select = tjbbTaskModelMapper.select(p);

        for(TjbbTaskModel tjbbTaskModel:select){
            if(!"20".equals(tjbbTaskModel.getStatus())){
                throw new BusinessException("下级单位尚未全部上报，不能进行此操作");
            }
        }
    }

    public void checkVirAllSubmit(TjbbTaskDTO dto){

        boolean isAllSb=checkVirSwjgIsAllSb(dto.getSwjgdm(),dto.getSsny(),dto.getBbdldm());
        if(!isAllSb){
            throw new BusinessException("下级机关未全部上报");
        }


    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void getTjbbReback(String swjgdm, String ssny, String bbdldm) {

        TjbbTaskModel p=new TjbbTaskModel();

        String czryMc = commonService.getCurrentUser().getCzryMc();

        Example example=new Example(TjbbTaskModel.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("swjgdm",swjgdm);
        criteria.andEqualTo("ny",ssny);
        criteria.andEqualTo("bbdldm",bbdldm);

        TjbbTaskModel model = tjbbTaskModelMapper.selectOneByExample(example);
        BeanUtils.copyProperties(model,p);

        p.setChtime(new Date());
        p.setStatus("10");
        p.setChr(czryMc);
        p.setSbtime(null);

        tjbbTaskModelMapper.updateByExample(p,example);

    }

    public MenuVo loadMenu() {

        logger.info("加载菜单...");
        MenuVo menuVo =new MenuVo();

        List<MenuVo.Menu> dlMenuList=new ArrayList<>();

        menuVo.setMenuList(dlMenuList);

        String menuCache = redisDelayService.getValueByKey("menu");
        List<TjbbItemVo> itemVoList;
        if(StringUtils.isEmpty(menuCache)){
            TjbbBasisService currentProxy = (TjbbBasisService)AopContext.currentProxy();
            itemVoList = currentProxy.getMenuFromDb();
            redisDelayService.putKeyValue("menu",new Gson().toJson(itemVoList));
        }else {
            Type type =new TypeToken<List<TjbbItemVo>>(){}.getType();
            itemVoList = new Gson().fromJson(menuCache,type);
        }

        String bbdldm="";
        List<MenuVo.Menu> subList;
        MenuVo.Menu menu=menuVo.new Menu();
        for(TjbbItemVo itemVo:itemVoList){

            if(!itemVo.getBbdldm().equals(bbdldm)){
                bbdldm=itemVo.getBbdldm();
                menu=menuVo.new Menu();
                menu.setSublist(new ArrayList<>());
                menu.setBbdm(itemVo.getBbdldm());
                menu.setBbmc(itemVo.getBbdlmc());
                dlMenuList.add(menu);
            }

            subList=menu.getSublist();
            MenuVo.Menu subMenu=menuVo.new Menu();
            subMenu.setBbdm(itemVo.getBbdm());
            subMenu.setBbmc(itemVo.getBbmc());
            subList.add(subMenu);
        }

        logger.info("加载菜单完成");
        return menuVo;

    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbItemVo> getMenuFromDb(){
        return tlTjbbMapper.getTjbbItemList();
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbRecvMainVo> getTjbbRecvMain(String ssny, String bbdm) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        int length = commonService.getQxdm().length();

        // 是否基层，县局是基层
        boolean isJc=length>5;

        if(StringUtils.isBlank(ssny)){
            return tlTjbbMapper.getTjbbRecvMain(bbdm,swjgDm,isJc);
        }else {
            return tlTjbbMapper.getTjbbRecvMainByNy(ssny,bbdm,swjgDm,isJc);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    @Deprecated
    public void saveData(SavaDataDTO savedatas) {

        String bbdm = savedatas.getBbdm();

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        String fname = model.getFname();
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        Map sqlPram=new HashMap();
        sqlPram.put("fname",fname);

        for (Map<String, String> map:savedatas.getData()){
            String ssny = map.get("SSNY");
            String bblc = map.get("BBLC");
            String swjgdm = map.get("SWJGDM");

            if(!swjgDm.equals(swjgdm)){
                throw new BusinessException("越权操作数据");
            }
            if(StringUtils.isBlank(ssny)||StringUtils.isBlank(bblc)||StringUtils.isBlank(swjgdm)){
                throw new BusinessException(ResultCode.DATA_PARAM);
            }

            StringBuffer sbStr=new StringBuffer("'"+ssny+"'").append(",'"+bblc+"'").append(",'"+swjgdm+"'");
            StringBuffer colStr=new StringBuffer("SSNY,BBLC,SWJGDM");

            Example ep4Col=new Example(TjbbColModel.class);
            Example.Criteria criteria4Col = ep4Col.createCriteria();
            criteria4Col.andEqualTo("bbdm",bbdm);
            criteria4Col.andIsNotNull("showorder");
            ep4Col.setOrderByClause("showorder");

            List<TjbbColModel> colModels = tjbbColModelMapper.selectByExample(ep4Col);

            for(TjbbColModel colModel:colModels){
                String colModelFname = colModel.getFname();
                colStr.append(","+colModelFname);

                String data = map.get(colModelFname);
                sbStr.append(",'"+data+"'");
            }

            sqlPram.put("cols",colStr.toString());
            sqlPram.put("datas",sbStr.toString());

            tlTjbbMapper.insertSaveTjbb(sqlPram);
        }
    }

    private void saveData(String fname,List<TjbbColModel> colModels,Map<String, String> map) {

        Map sqlPram=new HashMap();
        sqlPram.put("fname",fname);

        String ssny = map.get("SSNY");
        String bblc = map.get("BBLC");
        String swjgdm = map.get("SWJGDM");

        StringBuffer sbStr=new StringBuffer("'"+ssny+"'").append(",'"+bblc+"'").append(",'"+swjgdm+"'");
        StringBuffer colStr=new StringBuffer("SSNY,BBLC,SWJGDM");

        for(TjbbColModel colModel:colModels){
            String colModelFname = colModel.getFname();
            if("RN".equals(colModelFname)){
                continue;
            }

            colStr.append(","+colModelFname);

            String data = map.get(colModelFname);
            try {
                new DecimalFormat().parse(data).doubleValue();//处理千分符
                data=data.replace(",","");
            } catch (ParseException e) {

            }

            if("DATE".equals(colModel.getFtype()) && StringUtils.isNotBlank(data)){
                Date strToDate = DateUtils.strToDate(data);
                if(strToDate==null){
                    throw new BusinessException("【"+data+"】日期格式有误，支持格式“YYYY-MM-DD");
                }

                sbStr.append(",to_date('"+data+"','yyyy-mm-dd')" );
            }else if("NUMBER".equals(colModel.getFtype()) && StringUtils.isNotBlank(data)){
                if(!TlCalculateUtils.isNumeric(data)){
                    throw new BusinessException("请输入正确的数字格式");
                }
                sbStr.append(",'"+data+"'");
            }else {
                sbStr.append(",'"+data+"'");
            }

        }

        sqlPram.put("cols",colStr.toString());
        sqlPram.put("datas",sbStr.toString());

        try{
            tlTjbbMapper.insertSaveTjbb(sqlPram);
        }catch (Exception e){
            logger.error("未知异常：",e);
            throw new BusinessException("保存失败，请检查输入数字及内容是否存在非法字符或超长现象");
        }

    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateData(SavaDataDTO savedatas) {



        String bbdm = savedatas.getBbdm();
        String bbid = savedatas.getBbid();

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        String fname = model.getFname();
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        //删除
        if(!CollectionUtils.isEmpty(savedatas.getDelBblcs())){
            delDtDelDatas(fname,savedatas.getSsny(),savedatas.getDelBblcs());
        }


        Map sqlPram=new HashMap();
        sqlPram.put("fname",fname);

        List<Map<String,String>> datalist=null;

        for (Map<String, String> map:savedatas.getData()){
            String ssny = map.get("SSNY");
            String bblc = map.get("BBLC");
            String swjgdm = map.get("SWJGDM");

            if(!swjgDm.equals(swjgdm)){
                throw new BusinessException("越权操作数据");
            }
            if(StringUtils.isBlank(ssny)||StringUtils.isBlank(bblc)||StringUtils.isBlank(swjgdm)){
                throw new BusinessException(ResultCode.DATA_PARAM);
            }

            sqlPram.put("ssny",ssny);
            sqlPram.put("bblc",bblc);
            sqlPram.put("swjgdm",swjgdm);

            datalist=new ArrayList<>();

            Example ep4Col=new Example(TjbbColModel.class);
            Example.Criteria criteria4Col = ep4Col.createCriteria();
            criteria4Col.andEqualTo("bbdm",bbdm);
            criteria4Col.andIsNotNull("showorder");
            ep4Col.setOrderByClause("showorder");

            List<TjbbColModel> colModels = tjbbColModelMapper.selectByExample(ep4Col);

            if("1".equals(map.get("isAdd"))){
                saveData(fname,colModels,map);
                continue;
            }

            Map itemMap;
            for(TjbbColModel colModel:colModels){

                itemMap=new HashMap();

                String colModelFname = colModel.getFname();
                if("RN".equals(colModelFname)){
                    continue;
                }


                itemMap.put("col",colModelFname);

                String data = map.get(colModelFname);

                try {
                    new DecimalFormat().parse(data).doubleValue();//处理千分符
                    data=data.replace(",","");
                } catch (ParseException e) {

                }

                if("DATE".equals(colModel.getFtype()) && StringUtils.isNotBlank(data)){
                    Date strToDate = DateUtils.strToDate(data);
                    if(strToDate==null){
                       throw new BusinessException("【"+data+"】日期格式有误，支持格式“YYYY-MM-DD");
                    }
                    itemMap.put("coldata",strToDate);
                }else if("NUMBER".equals(colModel.getFtype()) && StringUtils.isNotBlank(data)){
                    if(!TlCalculateUtils.isNumeric(data)){
                        throw new BusinessException("请输入正确的数字格式");
                    }
                    itemMap.put("coldata",data);
                }else {
                    itemMap.put("coldata",data);
                }

                //itemMap.put("coldata",data);

                datalist.add(itemMap);
            }

            sqlPram.put("datalist",datalist);

            try{
                tlTjbbMapper.updateSaveTjbb(sqlPram);
            }catch (Exception e){
                logger.error("未知异常：",e);
                throw new BusinessException("保存失败，请检查输入数字及内容是否存在非法字符或超长现象");
            }

        }


        Example ep=new Example(TjbbTaskSubModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbid",bbid);
        criteria.andEqualTo("bbdm",bbdm);
        criteria.andEqualTo("swjgdm",swjgDm);

        TjbbTaskSubModel obj=new TjbbTaskSubModel();
        obj.setXgtime(new Date());
        obj.setXgr(commonService.getCurrentUser().getCzryMc());

        tjbbTaskSubModelMapper.updateByExampleSelective(obj,ep);

    }

    private void delDtDelDatas(String fname,String ssny,List<String> delBblcs){
        //删除数据
        if(StringUtils.isBlank(ssny)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }

        Map delP=new HashMap();
        delP.put("tablename",fname);
        delP.put("swjgdm",commonService.getCurrentUser().getSwjgDm());
        delP.put("ssny",ssny);

        for(String bblc:delBblcs){
            delP.put("bblc",bblc);
            tlTjbbMapper.deleteHzTjbbData(delP);
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public String getExcelDataPoint(String bbdm) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);

        BigDecimal excelcol = model.getExcelcol();
        BigDecimal excelrow = model.getExcelrow();

        if(excelcol==null || excelrow==null){
            throw new BusinessException("Excel模板数据起始行列配置项维护不全");
        }

        String s = excelcol.toString();
        String s1 = excelrow.toString();
        String bbmc = model.getBbmc();
        BigDecimal headcol = model.getHeadcol();
        BigDecimal headrow = model.getHeadrow();
        BigDecimal endrow = model.getEndrow();

        return s+","+s1+","+headcol+","+headrow+","+endrow+","+bbmc;
    }


    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void saveTjbbReportModel(TjbbReportModelDTO model) {

        String isAdd = model.getIsAdd();

        TjbbReportModel obj=new TjbbReportModel();

        BeanUtils.copyProperties(model,obj);

        obj.setBbdm(obj.getBbdm().toUpperCase());

        if("1".equals(isAdd)){
            TjbbReportModel reportModel = tjbbReportModelMapper.selectByPrimaryKey(model.getBbdm());

            if(reportModel!=null){
                throw new BusinessException("报表代码"+model.getBbdm()+"已存在");
            }

            TjbbBasisService service = (TjbbBasisService) AopContext.currentProxy();
            service.initAddTjbb(obj);
        }else {
            TjbbReportModel reportModel = tjbbReportModelMapper.selectByPrimaryKey(model.getBbdm());

            BeanUtils.copyProperties(model,reportModel);
            tjbbReportModelMapper.updateByPrimaryKey(reportModel);
        }

    }

    @Transactional
    public void initAddTjbb(TjbbReportModel model){

        String bbdm = model.getBbdm();

        String tablename="TJBB_DT_"+bbdm;

        model.setFname(tablename);

        List<TjbbColModel> dataList=new ArrayList<>();

        TjbbColModel obj_1=new TjbbColModel();
        Long pk = commonService.getDBPk("TJBB_HEADER_COLS");
        obj_1.setId(new BigDecimal(pk));
        obj_1.setBbdm(model.getBbdm());
        obj_1.setFname("SWJGDM");
        obj_1.setFtype("VARCHAR2");
        obj_1.setNote("OWN");
        obj_1.setAlign("0");
        obj_1.setQybj("Y");
        obj_1.setAllowupdate("N");
        obj_1.setAllowformula("N");
        obj_1.setAllowsum("N");
        obj_1.setHztype("0");
        obj_1.setMaxlen(new BigDecimal(32));
        obj_1.setCname("税务机关代码");

        TjbbColModel obj_2=new TjbbColModel();
        obj_2.setId(new BigDecimal(commonService.getDBPk("TJBB_HEADER_COLS")));
        obj_2.setBbdm(model.getBbdm());
        obj_2.setFname("BBLC");
        obj_2.setFtype("VARCHAR2");
        obj_2.setNote("OWN");
        obj_2.setAlign("0");
        obj_2.setQybj("Y");
        obj_2.setAllowupdate("N");
        obj_2.setAllowformula("N");
        obj_2.setAllowsum("N");
        obj_2.setHztype("0");
        obj_2.setMaxlen(new BigDecimal(10));
        obj_2.setCname("指标代码");

        TjbbColModel obj_3=new TjbbColModel();

        if(bbdm.startsWith("D")){
            obj_3.setId(new BigDecimal(commonService.getDBPk("TJBB_HEADER_COLS")));
            obj_3.setBbdm(model.getBbdm());
            obj_3.setFname("PARAMHASH");
            obj_3.setFtype("VARCHAR2");
            obj_3.setNote("OWN");
            obj_3.setAlign("0");
            obj_3.setQybj("Y");
            obj_3.setAllowupdate("N");
            obj_3.setAllowformula("N");
            obj_3.setAllowsum("N");
            obj_3.setHztype("0");
            obj_3.setMaxlen(new BigDecimal(64));
            obj_3.setCname("参数Hash");

        }else{
            obj_3.setId(new BigDecimal(commonService.getDBPk("TJBB_HEADER_COLS")));
            obj_3.setBbdm(model.getBbdm());
            obj_3.setFname("SSNY");
            obj_3.setFtype("VARCHAR2");
            obj_3.setNote("OWN");
            obj_3.setAlign("0");
            obj_3.setQybj("Y");
            obj_3.setAllowupdate("N");
            obj_3.setAllowformula("N");
            obj_3.setAllowsum("N");
            obj_3.setHztype("0");
            obj_3.setMaxlen(new BigDecimal(6));
            obj_3.setCname("所属年月");
        }


        dataList.add(obj_1);
        dataList.add(obj_2);
        dataList.add(obj_3);

        tlTjbbMapper.insertDyncTableColumn(dataList);
        model.setQybj("Y");
        tjbbReportModelMapper.insert(model);

        if(bbdm.startsWith("D")){ //统计分析初始化
            tlTjbbMapper.dyncCreateTable4Tjfx(tablename);
            tlTjbbMapper.dyncCreateTablePk4Tjfx(tablename,"PK_"+tablename);
        }else{
            tlTjbbMapper.dyncCreateTable(tablename);
            tlTjbbMapper.dyncCreateTablePk(tablename,"PK_"+tablename);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbColModel> loadDatabaseColumn(String bbdm) {

        Example ep=new Example(TjbbColModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbdm",bbdm);

        ep.setOrderByClause("showorder,note");

        return tjbbColModelMapper.selectByExample(ep);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void saveTjbbColumnModel(List<TjbbColModelDTO> models) {

        String bbdm="";

        for(TjbbColModelDTO dto:models){

            bbdm=dto.getBbdm();

            if("OWN".equals(dto.getNote())){
                continue;
            }

            TjbbColModel obj=new TjbbColModel();
            BeanUtils.copyProperties(dto,obj);

            obj.setFname(obj.getFname().toUpperCase());
            obj.setQybj("Y");
            if("1".equals(dto.getIsAdd())){

                if(dto.getFname()!=null && "RN".equals(dto.getFname().toUpperCase())){
                    obj.setNote("GEN");
                }else {
                    obj.setNote("DEFAULT");
                }
                Long pk = commonService.getDBPk("TJBB_HEADER_COLS");
                obj.setId(new BigDecimal(pk));
                tjbbColModelMapper.insert(obj);

            }else {
                tjbbColModelMapper.updateByPrimaryKey(obj);
            }
        }


        if(StringUtils.isNotBlank(bbdm) && !isDyncTjbb(bbdm)){
            genFormula4Column(bbdm);
        }

    }

    private void createAlterTableColumn(TjbbColModel obj){

        boolean isNumberType=false;
        String tablename="TJBB_DT_"+obj.getBbdm();
        String ftype=obj.getFtype();
        if("VARCHAR2".equals(ftype) || " CHAR".equals(ftype)){
            obj.setDegree(null);
            if(obj.getMaxlen()==null){
                throw new BusinessException("请输入字符型字段的长度");
            }
            ftype=ftype+"("+obj.getMaxlen()+")";
        }else if("NUMBER".equals(ftype) ){

            if(obj.getMaxlen()==null){
                throw new BusinessException("请输入数字型字段的长度");
            }

            isNumberType=true;

            if(obj.getMaxlen()!=null && obj.getDegree()==null){
                ftype=ftype+"("+obj.getMaxlen()+")";
            }else if(obj.getMaxlen()!=null && obj.getDegree()!=null){
                ftype=ftype+"("+obj.getMaxlen()+","+obj.getDegree()+")";
            }
        }


        tlTjbbMapper.dyncAddTableColumn(tablename,obj.getFname(),ftype);
        tlTjbbMapper.dyncAddTableColumnComment(tablename,obj.getFname(),obj.getCname());

        String bbdm = obj.getBbdm(); //当统计分析报表使用时，不需要生成Hz列
        if(isNumberType && !bbdm.startsWith("D")){
            tlTjbbMapper.dyncAddTableColumn(tablename,obj.getFname()+"_HZ",ftype);
        }

    }

    public void saveTjbbColumnModel4Excel(List<TjbbColModelDTO> models) {

        for(TjbbColModelDTO dto:models){

            TjbbColModel obj=new TjbbColModel();
            BeanUtils.copyProperties(dto,obj);

            Long pk = commonService.getDBPk("TJBB_HEADER_COLS");
            obj.setId(new BigDecimal(pk));
            obj.setFname(obj.getFname().toUpperCase());
            obj.setQybj("Y");
            obj.setNote("DEFAULT");
            tjbbColModelMapper.insert(obj);
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbLineItemModel> loadTjbbItem(String bbdm) {

        Example ep=new Example(TjbbLineItemModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbdm",bbdm);

        ep.setOrderByClause("showorder");

        return tjbbLineItemModelMapper.selectByExample(ep);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateItemAllowupdate(List<TjbbLineItemModel> data) {

        for(TjbbLineItemModel model:data){
            tjbbLineItemModelMapper.updateByPrimaryKey(model);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbReportFormula> loadFormulaList(String bbdm) {

        Example ep=new Example(TjbbReportFormula.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbdm",bbdm);
        criteria.andEqualTo("qybz","Y");

        ep.setOrderByClause("type");

        return tjbbReportFormulaMapper.selectByExample(ep);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateFormulaYxj(List<TjbbReportFormula> data) {

        for(TjbbReportFormula model:data){
            TjbbReportFormula obj=new TjbbReportFormula();
            obj.setId(model.getId());
            obj.setYxj(model.getYxj());
            obj.setIshzjs(model.getIshzjs());
            tjbbReportFormulaMapper.updateByPrimaryKeySelective(obj);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public FormulaColumnVo loadFormulaColumnList(String bbdm) {

        List<FormulaColumnVo.FormulaColumn> cols =  tlTjbbMapper.loadFormulaCols(bbdm);
        List<FormulaColumnVo.FormulaColumn> rows =  tlTjbbMapper.loadFormulaRows(bbdm);


        FormulaColumnVo retVo=new FormulaColumnVo();
        retVo.setCols(cols);
        retVo.setRows(rows);

        return retVo;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void saveFormula(TjbbReportFormula formula) {

        formula.setId(new BigDecimal(commonService.getDBPk("TJBB_REPORT_FORMULA")));
        formula.setYxj(BigDecimal.ZERO);
        formula.setQybz("Y");

        tjbbReportFormulaMapper.insert(formula);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void delFormula(BigDecimal id) {
        tjbbReportFormulaMapper.deleteByPrimaryKey(id);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateExcelPoint(TjbbReportModel reportModel) {

        tjbbReportModelMapper.updateByPrimaryKeySelective(reportModel);
    }

    private void saveTemplateFile(MultipartFile file) throws IllegalStateException, IOException {

        //初试化文件路径
        File dir=new File(appProperties.getTemplateTjbbDir());
        if(!dir.exists()){
            dir.mkdirs();
        }

        if(file != null){
            String myFileName = file.getOriginalFilename();
            if(myFileName.trim() !=""){

                String filePath =appProperties.getTemplateTjbbDir() + file.getOriginalFilename();
                File localFile = new File(filePath);
                file.transferTo(localFile);
            }
        }

    }

    private void clear(String bbdm,String isUpdateItem,String isUpdateFormula) {

        TjbbHeaderModel headerModel=new TjbbHeaderModel();
        headerModel.setBbdm(bbdm);
        tjbbHeaderModelMapper.delete(headerModel);

        if(isUpdateFormula==null || "true".equals(isUpdateFormula)){
            TjbbReportFormula formula=new TjbbReportFormula();
            formula.setBbdm(bbdm);
            formula.setType("2");
            tjbbReportFormulaMapper.delete(formula);
        }


        if(isUpdateItem==null||"true".equals(isUpdateItem)){
            TjbbLineItemModel tjbbLineItemModel=new TjbbLineItemModel();
            tjbbLineItemModel.setBbdm(bbdm);
            tjbbLineItemModelMapper.delete(tjbbLineItemModel);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void checkTjbbTemplateFirst(String bbdm) {

        String tablename="TJBB_DT_"+bbdm;

        int dataRows=tlTjbbMapper.countDataTables(tablename);

        if(dataRows>0){
            throw new BusinessException("数据已存在，非首次操作不能创建模板配置");
        }

        int colRows = tlTjbbMapper.countColumnByBbdm(bbdm);

        if(colRows>3){
            throw new BusinessException("字段列配置已存在，非首次操作不能创建模板配置");
        }


    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void processTemplateUpload(MultipartFile file, HttpServletRequest request, TjbbReportModel reportModel) throws Exception,IOException{

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();
        proxy.process(file,request,reportModel);
    }

    @Transactional
    public void process(MultipartFile file, HttpServletRequest request, TjbbReportModel reportModel) throws Exception {

        String bbdm = request.getParameter("bbdm");
        String type = request.getParameter("type");
        String endLine = request.getParameter("endLine");
        boolean isAddColumn="1".equals(type);

        InputStream stream = getUploadFile(file, request);

//        boolean isDefaultGenFname=false;
//        if(isAddColumn){
//            isDefaultGenFname=isDyncTjbb(bbdm);
//        }

        //1.获取表头配置列信息
        List<TjbbHeaderModel> headerList = excelUtil.getReportHeaderList(stream,reportModel,Integer.parseInt(endLine),isAddColumn);

        //2.将表头配置插入数据库
        importHeaderExcel(headerList);

        //3,1）生成栏次代码表初始配置  2）将模板公式处理后导入到数据库表
        if(headerList.size()>0){
            String isUpdateItem = request.getParameter("isUpdateItem");
            String isUpdateFormula = request.getParameter("isUpdateFormula");

            List<TjbbHeaderModel> lines = initLineItem(bbdm,isUpdateItem);

            //如果需要更新公式则进行更新操作
            if(isUpdateFormula==null || "true".equals(isUpdateFormula)){

                Map<String, YxjNode> yxjMap = getYxjMap(lines);

                for(TjbbHeaderModel lineItem:lines){
                    if(lineItem.getShowname()!=null && lineItem.getShowname().contains("=")){
                        String key = processStr(lineItem.getShowname().split("=")[0]);
                        insertFormula(bbdm,"2",lineItem.getShowname().trim(),yxjMap.get(key).getYxj());
                    }
                }
            }



//            if(!isAddColumn){
//                List<TjbbHeaderModel> linesFormula=getHeadLineFormula(bbdm);
//
//                for(TjbbHeaderModel lineItem:linesFormula){
//                    if(lineItem.getShowname()!=null && lineItem.getShowname().contains("=")){
//                        insertFormula(bbdm,"1",lineItem.getShowname().trim());
//                    }
//                }
//            }
        }

    }

    private boolean isDyncTjbb(String bbdm) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);

        return !"OWN".equals(model.getNote());
    }


    private Map<String,YxjNode> getYxjMap(List<TjbbHeaderModel> lines){

        Map<String,YxjNode> yxjMap=new HashMap<>();


        for(TjbbHeaderModel lineItem:lines){
            if(lineItem.getShowname()!=null && lineItem.getShowname().contains("=")){
                String[] split = lineItem.getShowname().split("=");


                String leftStr=split[0];

                String key = processStr(leftStr);
                YxjNode leftNode=new YxjNode();
                if(yxjMap.containsKey(key)){
                    leftNode=yxjMap.get(key);
                }else {
                    leftNode.setId(key);
                    yxjMap.put(key,leftNode);
                }


                String rightStr=split[1];

                rightStr=rightStr.replace("（", "(");
                rightStr=rightStr.replace("）", ")");

                String spiltRules = "\\+|-|\\*|/|=|\\(|\\)";

                String[] array = rightStr.split(spiltRules);

                for (String s : array) {
                    if(StringUtils.isNotBlank(s)){
                        YxjNode child=new YxjNode();
                        if(!yxjMap.containsKey(s)){
                            yxjMap.put(s,child);
                        }else {
                            child=yxjMap.get(s);
                        }

                        child.setPid(leftNode.getId());
                        child.setId(s);
                        List<YxjNode> temList=new ArrayList<>();
                        if(leftNode.getChildren()==null){
                            leftNode.setChildren(temList);
                        }else {
                            temList=leftNode.getChildren();
                        }
                        temList.add(child);

                    }

                }
            }
        }

        List<YxjNode> pNodes=new ArrayList<>();

        Set<String> keys = yxjMap.keySet();
        for(String key:keys){
            YxjNode yxjNode = yxjMap.get(key);
            if(yxjNode.getPid()==null){
                pNodes.add(yxjNode);
            }
        }


        for(YxjNode yxjNode:pNodes){
            yxjNode.setYxj(100);

            List<YxjNode> children = yxjNode.getChildren();
            if(children!=null){
                for(YxjNode node:children){
                    setYxj(node,90);
                }
            }

        }


        return yxjMap;
    }

    private void setYxj(YxjNode yxjNode,Integer yxj){
        if(yxjNode.getYxj()==null){
            yxjNode.setYxj(yxj);
        }else if(yxjNode.getYxj()>yxj){
            yxjNode.setYxj(yxj);
        }

        if(CollectionUtils.isEmpty(yxjNode.getChildren())){
            return;
        }else{
            for(YxjNode innerNode:yxjNode.getChildren()){
                setYxj(innerNode,yxj-10);
            }
        }
    }

    private String processStr(String str){
        str=str.replace("（", "(");
        str=str.replace("）", ")");

        String spiltRules = "\\+|-|\\*|/|=|\\(|\\)";

        return str.replaceAll(spiltRules, "");
    }


    private InputStream getUploadFile(MultipartFile file,HttpServletRequest request)
            throws Exception{
        String bbdm = request.getParameter("bbdm");

        //2.获取文件并保存模板
        String fileName = file.getOriginalFilename();
        if (!(fileName.endsWith(".xls"))) {
            throw new BusinessException(BusinessMsgCons.ONLY_XLS);
        }else{
            String[] split = fileName.split("\\.");
            if(!bbdm.equals(split[0])){
                throw new BusinessException("报表代码【"+bbdm+"】与导入文件模板"+fileName+"不符");
            }
        }

        saveTemplateFile(file);

        String isUpdateItem = request.getParameter("isUpdateItem");
        String isUpdateFormula = request.getParameter("isUpdateFormula");
        clear(bbdm,isUpdateItem,isUpdateFormula);

        //3.获取Excel模板里模板信息
        File templdateFile =new File(appProperties.getTemplateTjbbDir()+bbdm+".xls");
        if(!templdateFile.exists()){
            throw new BusinessException("文件不存在");
        }
        InputStream stream = new FileInputStream(templdateFile);

        return stream;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void genTableColumn(String bbdm) {

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();

        proxy.genTableColumnProxy(bbdm);
    }

    @Transactional
    public void genTableColumnProxy(String bbdm){
        Example ep=new Example(TjbbColModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("note","DEFAULT");
        criteria.andEqualTo("bbdm",bbdm);

        List<TjbbColModel> colModels = tjbbColModelMapper.selectByExample(ep);

        for(TjbbColModel colModel:colModels){

//            if(hasDigit(colModel.getFname())){
//                throw new BusinessException(colModel.getFname()+",字段列中不允许存在数字");
//            }

            createAlterTableColumn(colModel);

            TjbbColModel temp=new TjbbColModel();
            temp.setId(colModel.getId());
            temp.setNote("GEN");
            tjbbColModelMapper.updateByPrimaryKeySelective(temp);
        }

        genFormula4Column(bbdm);
    }

    // 判断一个字符串是否含有数字
    private boolean hasDigit(String content) {
        boolean flag = false;
        Pattern p = Pattern.compile(".*\\d+.*");
        Matcher m = p.matcher(content);
        if (m.matches()) {
            flag = true;
        }
        return flag;
    }


    private void genFormula4Column(String bbdm){
        TjbbReportFormula param=new TjbbReportFormula();
        param.setBbdm(bbdm);
        param.setType("1");
        tjbbReportFormulaMapper.delete(param);

        List<TjbbHeaderModel> linesFormula=getHeadLineFormula(bbdm);

        Map<String, YxjNode> yxjMap = getYxjMap(linesFormula);

        for(TjbbHeaderModel lineItem:linesFormula){
            if(lineItem.getShowname()!=null && lineItem.getShowname().contains("=")){
                String key = processStr(lineItem.getShowname().split("=")[0]);
                insertFormula(bbdm,"1",lineItem.getShowname().trim(),yxjMap.get(key).getYxj());
            }
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<ColumnTypeVo> loadColumnType(String bbdm) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);

        if(StringUtils.isBlank(model.getFname())){

            throw new BusinessException("未读取到数据表配置信息");
        }

         return tlTjbbMapper.selectColumnType(model.getFname().toUpperCase());

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void delColumn(BigDecimal id,String bbdm) {
        TjbbColModel col=new TjbbColModel();
        col.setId(id);
        col.setBbdm(bbdm);
        tjbbColModelMapper.delete(col);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void makeTjbb(TjbbTaskDTO dto, TlUserProfile currentUser) {
        Date hzDate = new Date();
        String bbdldm = dto.getBbdldm();
        String yyyyMM = dto.getSsny();
        TjbbReportModel tjbbReportModel=new TjbbReportModel();
        tjbbReportModel.setBbdldm(bbdldm);
        tjbbReportModel.setQybj("Y");

        List<TjbbReportModel> modelList = tjbbReportModelMapper.select(tjbbReportModel);

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();
        proxy.makeTjbbProxy(modelList,currentUser,yyyyMM,bbdldm,hzDate,false,null);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void cxMakeTjbb(TjbbTaskDTO dto) {
        Date hzDate = new Date();

        TlUserProfile currentUser = commonService.getCurrentUser();
        String bbdldm = dto.getBbdldm();
        String yyyyMM = dto.getSsny();

        Example ep=new Example(TjbbReportModel.class);
        Example.Criteria criteria = ep.createCriteria();

        String[] split = dto.getBbdm().split(",");
        List<String> list = Arrays.asList(split);

        criteria.andEqualTo("bbdldm",bbdldm);
        criteria.andIn("bbdm",list);

        List<TjbbReportModel> modelList = tjbbReportModelMapper.selectByExample(ep);

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();
        proxy.makeTjbbProxy(modelList,currentUser,yyyyMM,bbdldm,hzDate,true,list);
    }

    @Transactional
    public void makeTjbbProxy(List<TjbbReportModel> modelList,TlUserProfile
            currentUser,String yyyyMM,String bbdldm,Date hzDate,boolean isCxMake,List<String> bbdms){

        List<TjbbTaskSubModel> retList=new ArrayList<>();

        for(TjbbReportModel model:modelList){

            logger.info("处理报表代码:"+model.getBbdm());

            String fname = model.getFname();
            String proc = model.getProc();

            //数据初始化之前先删除数据
            Map delP=new HashMap();
            delP.put("tablename",fname);
            delP.put("swjgdm",currentUser.getSwjgDm());
            delP.put("ssny",yyyyMM);
            tlTjbbMapper.deleteHzTjbbData(delP);

            //默认采用初始化空行数据
            if(StringUtils.isBlank(proc)){
                List<TjbbBaseColumnVo> baseColumnVos=new ArrayList<>();

                TjbbLineItemModel itemModel=new TjbbLineItemModel();
                itemModel.setBbdm(model.getBbdm());
                itemModel.setQybj("Y");

                //获取指标代码表
                List<TjbbLineItemModel> itemModels = tjbbLineItemModelMapper.select(itemModel);
                for(TjbbLineItemModel lineItemModel:itemModels){
                    TjbbBaseColumnVo columnVo=new TjbbBaseColumnVo();
                    columnVo.setBblc(lineItemModel.getBblc());
                    columnVo.setSwjgdm(currentUser.getSwjgDm());
                    columnVo.setSsny(yyyyMM);

                    baseColumnVos.add(columnVo);
                }



                Map parmMap=new HashMap();
                parmMap.put("fname",fname);
                parmMap.put("baseColumnVos",baseColumnVos);
                tlTjbbMapper.insertInitTjbbLine(parmMap);
            }else{
                executeProc(yyyyMM,currentUser.getSwjgDm(),proc);
            }

            TjbbTaskSubModel subTaskModel=new TjbbTaskSubModel();
            subTaskModel.setBbdldm(bbdldm);
            subTaskModel.setBbdm(model.getBbdm());
            subTaskModel.setBbid(commonService.getUUId());
            subTaskModel.setNy(yyyyMM);
            subTaskModel.setHzr(currentUser.getCzryMc());
            subTaskModel.setHztime(hzDate);
            subTaskModel.setSwjgdm(currentUser.getSwjgDm());

            retList.add(subTaskModel);
        }

        Example ep=new Example(TjbbTaskSubModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("bbdldm",bbdldm);
        criteria.andEqualTo("ny",yyyyMM);
        criteria.andEqualTo("swjgdm",currentUser.getSwjgDm());
        if(isCxMake){
            criteria.andIn("bbdm",bbdms);
        }
        tjbbTaskSubModelMapper.deleteByExample(ep);

        Map map=new HashMap();
        map.put("retList",retList);
        tlTjbbMapper.insertSubTaskList(map);
    }

    /**
     * 执行汇总存储过程
     * @param yyyyMM
     * @param swjgdm
     * @param procname
     */
    private void executeProc(String yyyyMM,String swjgdm,String procname){
        ProcParam param = new ProcParam();
        param.setV_SSNY(yyyyMM);
        param.setV_SWCODE(swjgdm);
        param.setProcname(procname);
        tlTjbbMapper.excuteProcedure(param);
        dealResult(param);
    }


    public void executeSbCheckProc(String yyyyMM,String swjgdm,String procname,String bbdldm){
        ProcParam param = new ProcParam();
        param.setV_SSNY(yyyyMM);
        param.setV_SWCODE(swjgdm);
        param.setProcname(procname);
        param.setV_BBDLDM(bbdldm);
        tlTjbbMapper.excuteProcedureCheck(param);
        dealResult(param);
    }

    private void dealResult(ProcParam param) {
        Integer v_error = param.getV_ERROR();
        if(v_error != null && v_error!=0){
            logger.info("调用存储过程出现错误:年月{}-税务机关{}-存储过程{}-{}={}：",param.getV_SSNY(),param.getV_SWCODE(),param.getProcname(),v_error,param.getV_MSG());
            BusinessException bex=new BusinessException(v_error+":"+param.getV_MSG());
            throw bex;

        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void changeTjbbStatus(TjbbTaskDTO dto,String status,String swjgdm){

        Date hzDate = new Date();
        TlUserProfile currentUser = commonService.getCurrentUser();
        if(StringUtils.isBlank(swjgdm)){
            swjgdm=currentUser.getSwjgDm();
        }


        String yyyyMM = dto.getSsny();
        String bbdldm = dto.getBbdldm();
        TjbbTaskModel p=new TjbbTaskModel();
        p.setNy(dto.getSsny());
        p.setSwjgdm(swjgdm);
        p.setBbdldm(bbdldm);

        p.setStatus(status);

        if("10".equals(status)){
            p.setZbtime(hzDate);
            p.setZbr(currentUser.getCzryMc());
        }else if ("20".equals(status)){
            p.setSbtime(hzDate);
            p.setSbr(currentUser.getCzryMc());

            //同时将上级税务机关代码的流程状态设置为00
            TjbbTaskModel model = tjbbTaskModelMapper.selectByPrimaryKey(p);
            String sjswjg = model.getSjswjg();
            TjbbTaskModel tt=new TjbbTaskModel();
            tt.setNy(yyyyMM);
            tt.setSwjgdm(sjswjg);
            tt.setBbdldm(bbdldm);
            tt.setStatus("00");
            tjbbTaskModelMapper.updateByPrimaryKeySelective(tt);
        }

        tjbbTaskModelMapper.updateByPrimaryKeySelective(p);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void makeHzTjbb(TjbbTaskDTO dto,TlUserProfile currentUser) {
        Date hzDate = new Date(); //汇总时间
        String bbdldm = dto.getBbdldm(); //报表大类代码
        String yyyyMM = dto.getSsny();
        TjbbReportModel tjbbReportModel=new TjbbReportModel();
        tjbbReportModel.setBbdldm(bbdldm);

        List<TjbbReportModel> modelList = tjbbReportModelMapper.select(tjbbReportModel);

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();


        if(StringUtils.isNotBlank(dto.getSwjgdm())){
            proxy.makeHzTjbbProxy(modelList,currentUser,yyyyMM,bbdldm,hzDate,dto.getSwjgdm());
        }else{
            proxy.makeHzTjbbProxy(modelList,currentUser,yyyyMM,bbdldm,hzDate,currentUser.getSwjgDm());
        }

    }


    @Transactional
    public void makeHzTjbbProxy(List<TjbbReportModel> modelList,TlUserProfile
            currentUser,String yyyyMM,String bbdldm,Date hzDate,String swjgdm){

        List<TjbbTaskSubModel> retList=new ArrayList<>();

        //遍历所有报表，按张进行汇总操作
        for(TjbbReportModel model:modelList){
            String fname = model.getFname();
            String hztype = model.getHztype();
            String prochz = model.getProchz();

            logger.info("汇总处理报表代码:"+model.getBbdm());

            //初始化允许汇总的字段列
            List<String> cols = initAllowSumCols(model.getBbdm());

            Map pramMap=new HashMap();
            //根据不同类型汇总，1和5都采用将下级上报数据进行汇总
            if(("1".equals(hztype) ||"5".equals(hztype)) && !cols.isEmpty()){

                pramMap.put("bbdm",model.getBbdm());
                pramMap.put("bbdldm",bbdldm);
                pramMap.put("tablename",fname);
                pramMap.put("swjgdm",swjgdm);
                pramMap.put("ssny",yyyyMM);
                pramMap.put("cols",cols);

                tlTjbbMapper.deleteHzTjbbData(pramMap);

                //针对类型5的合计汇总表进行首列名称的生成
                if("5".equals(hztype)){
                    List<TjbbColModel> columns = getColumns(model.getBbdm());
                    TjbbColModel colModel = columns.get(0);
                    pramMap.put("fname",colModel.getFname());

                    SwjgModel swjgModel = commonService.getSwjgMc(currentUser.getSwjgDm());
                    String swjgmctype = model.getSwjgmctype();
                    String fvalue;
                    if("1".equals(swjgmctype)){
                        fvalue=swjgModel.getSwjgmc();
                    }else if("3".equals(swjgmctype)){
                        fvalue=swjgModel.getDispsx();
                    }else{
                        fvalue=swjgModel.getSwjgjc();
                    }

                    if(StringUtils.isBlank(fvalue)){
                        fvalue=swjgModel.getSwjgmc();
                    }
                    pramMap.put("fvalue",fvalue);
                    tlTjbbMapper.insertHzTjbb4Type5(pramMap);
                }else{
                    //按指标代码进行分类汇总数据
                    tlTjbbMapper.insertHzTjbb4Sum(pramMap);
                }

                //根据行指标配置，添加行同比值
                Map p=new HashMap();
                List<HzTypeVo> hzTypeVos=tlTjbbMapper.getTbHzItems(model.getBbdm());
                if(!hzTypeVos.isEmpty()){
                    p.put("zbdms",hzTypeVos);
                    p.put("tablename",fname);
                    p.put("cols",cols);
                    p.put("swjgdm",swjgdm);
                    p.put("ssny",yyyyMM);
                    tlTjbbMapper.insertTbDataList4Lines(p);
                }
                //根据列字段定义配置，添加列同比值
                Map pp=new HashMap();
                List<HzTypeVo> hzTypeCols=tlTjbbMapper.getTbHzCols(model.getBbdm());
                if(!hzTypeCols.isEmpty()){
                    pp.put("zbdms",hzTypeCols);
                    pp.put("tablename",fname);
                    pp.put("swjgdm",swjgdm);
                    pp.put("ssny",yyyyMM);
                    tlTjbbMapper.updateTbDataList4Cols(pp);
                }

                //根据列字段定义配置，添加列占比值
                Map zbParam=new HashMap();
                List<HzTypeVo> hzZbTypeCols=tlTjbbMapper.getZbHzCols(model.getBbdm());
                if(!hzZbTypeCols.isEmpty()){
                    zbParam.put("zbdms",hzZbTypeCols);
                    zbParam.put("tablename",fname);
                    zbParam.put("swjgdm",swjgdm);
                    zbParam.put("ssny",yyyyMM);
                    tlTjbbMapper.updateZbDataList4Cols(zbParam);
                }


                //根据列除法公式计算汇总列
                Map ppp=new HashMap();
                List<HzTypeVo> zbCols=tlTjbbMapper.getZbFormulaHzCols(model.getBbdm());
                for(HzTypeVo typeVo:zbCols){
                    String s = typeVo.getBblc();
                    String[] split = s.split(",");
                    String str=split[split.length-1];
                    typeVo.setFmCol(str);

                    String formula = typeVo.getFormula();
                    formula = formula.replaceAll("\\)", "_HZ)");
                    formula=formula.replaceAll("_HZ\\)_HZ\\)","_HZ))");
                    typeVo.setFormulaHz(formula);
                }
                if(!hzTypeCols.isEmpty()){
                    ppp.put("zbcols",zbCols);
                    ppp.put("tablename",fname);
                    ppp.put("swjgdm",swjgdm);
                    ppp.put("ssny",yyyyMM);
                    tlTjbbMapper.updateZbFormulaDataList4Cols(ppp);
                }

                //计算参与公式计算的行指标
                processProfileFormula(model.getBbdm(),fname,swjgdm,yyyyMM);

            }else if( "3".equals(hztype)
                    && !cols.isEmpty()){
                //先采用从下级汇总方式，数据上级汇总不落地
//                pramMap.put("tablename",fname);
//                pramMap.put("swjgdm",currentUser.getSwjgDm());
//                pramMap.put("ssny",yyyyMM);
//
//                tlTjbbMapper.deleteHzTjbbData(pramMap);
//                tlTjbbMapper.insertHzMxTjbb4Sum(pramMap);
            }


            if(StringUtils.isNotBlank(prochz)){
                executeProc(yyyyMM,swjgdm,prochz);
            }

            TjbbTaskSubModel subTaskModel=new TjbbTaskSubModel();
            subTaskModel.setBbdldm(bbdldm);
            subTaskModel.setBbdm(model.getBbdm());
            subTaskModel.setBbid(commonService.getUUId());
            subTaskModel.setNy(yyyyMM);
            subTaskModel.setHzr(currentUser.getCzryMc());
            subTaskModel.setHztime(hzDate);
            subTaskModel.setSwjgdm(swjgdm);

            retList.add(subTaskModel);
        }


        Map pMap=new HashMap();
        pMap.put("swjgdm",swjgdm);
        pMap.put("ssny",yyyyMM);
        pMap.put("bbdldm",bbdldm);
        tlTjbbMapper.deleteTaskSub(pMap);

        Map map=new HashMap();
        map.put("retList",retList);
        tlTjbbMapper.insertSubTaskList(map);
    }


    private void processProfileFormula (String bbdm,String tableName,String swjgdm,String ssny){

        List<ProfileFormulaVo> profileFormulaVos=tlTjbbMapper.selectLineProfileFormula(bbdm);

        if(profileFormulaVos.isEmpty()){
            return;
        }

        Example ep=new Example(TjbbColModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("allowformula","Y");
        criteria.andNotEqualTo("note","OWN");
        criteria.andEqualTo("bbdm",bbdm);
        List<TjbbColModel> colModels = tjbbColModelMapper.selectByExample(ep);


            for(ProfileFormulaVo formulaVo:profileFormulaVos){
                String bblcstr = formulaVo.getBblcstr();
                String[] split = bblcstr.split(",");
                List<String> strings = Arrays.asList(split);

                //循环组装需要更新的指标行数据
                List<ColumnValueDTO> savaColumn=new ArrayList<>();
                for(TjbbColModel col:colModels){
                    String formula = formulaVo.getFormula();


                    String colFname = col.getFname();

                    //将公式子项值替换到公式
                    String value=null;
                    String valueHz=null;
                    Map pramMap=new HashMap();
                    Map pramMapHz=new HashMap();
                    char pram='a';
                    int i=0;
                    for(String bblc:strings){
                        Map p=new HashMap();
                        p.put("tablename",tableName);
                        p.put("swjgdm",swjgdm);
                        p.put("ssny",ssny);
                        p.put("bblc",bblc.length()==1?"0"+bblc:bblc);
                        p.put("col",colFname);
                        value=tlTjbbMapper.selectColumnValue(p);
                        valueHz=tlTjbbMapper.selectColumnValueHz(p);

                        formula=formula.replaceFirst("\\("+bblc+"\\)",(char)(pram+i)+"");

                        pramMap.put((char)(pram+i)+"","".equals(StringUtils.trimToEmpty(value))?BigDecimal.ZERO:new BigDecimal(value));
                        pramMapHz.put((char)(pram+i)+"","".equals(StringUtils.trimToEmpty(valueHz))?BigDecimal.ZERO:new BigDecimal(valueHz));

                        i++;
                    }

                    //根据公式进行计算
                    String result=callFormula(value,formula,pramMap);
                    String result_hz=callFormula(valueHz,formula,pramMapHz);

                    ColumnValueDTO valueDTO = new ColumnValueDTO();
                    valueDTO.setColName(colFname);
                    valueDTO.setColValue(result);
                    valueDTO.setColValueHz(result_hz);
                    savaColumn.add(valueDTO);
                }


                Map updateObj=new HashMap();
                updateObj.put("swjgdm",swjgdm);
                updateObj.put("ssny",ssny);
                updateObj.put("tablename",tableName);
                updateObj.put("bblc",formulaVo.getBblc());
                updateObj.put("colVaules", savaColumn);

                if(!savaColumn.isEmpty()){
                    tlTjbbMapper.jsProfileLineFormula(updateObj);
                }

            }

    }

    private String  callFormula(String value,String formula,Map<String,Object> pramMap){
        String result;
        if(StringUtils.isBlank(value)){
            result="";
        }else if(Double.parseDouble(value)==0){
            result="99.99";
        }else{
            result = TlCalculateUtils.getResult(formula,pramMap,4).toString();
        }

        return result;
    }


    private List<String> initAllowSumCols(String bbdm){

        List<String> retList=new ArrayList<>();

        TjbbColModel colModel=new TjbbColModel();
        colModel.setBbdm(bbdm);
        colModel.setHztype("1");

        List<TjbbColModel> select = tjbbColModelMapper.select(colModel);

        for(TjbbColModel temp:select){

            retList.add(temp.getFname());
        }

        return retList;

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public TjbbTbxx getZbxx(String bbdm) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        TjbbTbxx p=new TjbbTbxx();
        p.setSwjgdm(swjgDm);
        p.setBbdm(bbdm);

        return tjbbTbxxMapper.selectOne(p);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void saveTjbbTbxx(TjbbTbxx tbxx) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        BigDecimal id = tbxx.getId();
        if(id==null){
            Long dbPk = commonService.getDBPk("TJBB_REPORT_TBXX");
            tbxx.setId(new BigDecimal(dbPk));
            tbxx.setSwjgdm(swjgDm);
            tjbbTbxxMapper.insert(tbxx);
        }else {
            tjbbTbxxMapper.updateByPrimaryKey(tbxx);
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public int countTaskNum(String sbqb) {

        TjbbTaskModel p=new TjbbTaskModel();
        p.setNy(sbqb);
        return tjbbTaskModelMapper.selectCount(p);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void initTaskList(String sbqb) {

        TlSWJGProfile p=new TlSWJGProfile();
        p.setTsjgBz("1");
        p.setQybz("Y");
        List<TlSWJGProfile> swjgProfiles = tlSWJGProfileMapper.select(p);

        TjbbReportItem param=new TjbbReportItem();
        param.setType("1");
        List<TjbbReportItem> items = tjbbReportItemMapper.select(param);

        TjbbBasisService proxy = (TjbbBasisService)AopContext.currentProxy();
        proxy.initTaskListProxy(items,swjgProfiles,sbqb);
    }

    @Transactional
    public void initTaskListProxy(List<TjbbReportItem> items, List<TlSWJGProfile> swjgProfiles, String sbqb) {

        for(TjbbReportItem reportItem:items){

            for(TlSWJGProfile swjgProfile:swjgProfiles){
                TjbbTaskModel obj=new TjbbTaskModel();
                obj.setNy(sbqb);
                obj.setBbdldm(reportItem.getBbdldm());
                obj.setSwjgdm(swjgProfile.getSwjgDm());
                obj.setSjswjg(swjgProfile.getSwjgDmSj());
                obj.setStatus("00");
                obj.setCjtime(new Date());
                obj.setCjr("system");
                obj.setType("1");
                obj.setSwjgmc(swjgProfile.getSwjgMc());
                obj.setSwjgjc(swjgProfile.getSwjgJc());

                tjbbTaskModelMapper.insert(obj);
            }
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<SuitExcelDTO> getBbdmBYdl(String bbdldm) {
        return tlTjbbMapper.getBbdmBYdl(bbdldm);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void checkSubmit(String bbdldm,String ssny) {
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        Example example=new Example(TjbbTaskModel.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("swjgdm",swjgDm);
        criteria.andEqualTo("ny",ssny);
        criteria.andEqualTo("bbdldm",bbdldm);

        TjbbTaskModel model = tjbbTaskModelMapper.selectOneByExample(example);

        if(model!=null && "20".endsWith(model.getStatus())){
            throw new BusinessException("报表已上报，无法进行【撤回】操作");
        }
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void savaLog(TjbbCzLogCode czcode,TjbbCzLogCode cztype){
        TlUserProfile currentUser = commonService.getCurrentUser();
        String swjgDm = currentUser.getSwjgDm();
        String czryDm = currentUser.getCzryDm();

        Date date = new Date();
        TjbbCzLogModel czLogModel=new TjbbCzLogModel();
        czLogModel.setId(commonService.getUUId());
        czLogModel.setCzry(czryDm);
        czLogModel.setSwjgdm(swjgDm);
        czLogModel.setCztime(date);
        czLogModel.setCzcode(czcode.getCode());
        czLogModel.setCztype(cztype.getCode());

        tjbbCzLogModelMapper.insert(czLogModel);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbSbJyxxModel> getJyxxList(String bbdldm, String msgLevel) {
        TlUserProfile currentUser = commonService.getCurrentUser();
        String swjgDm = currentUser.getSwjgDm();

        return tlTjbbMapper.selectJyxxList(bbdldm,swjgDm,msgLevel);

    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public TjbbTaskSubModel getHzDate(String bbdm, String swjgdm, String ssny) {

        TjbbTaskSubModel p=new TjbbTaskSubModel();
        p.setSwjgdm(swjgdm);
        p.setNy(ssny);
        p.setBbdm(bbdm);

        return tjbbTaskSubModelMapper.selectOne(p);
    }

    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public List<TjbbReportItem> getBbdlList() {
        return  tjbbReportItemMapper.selectAll();
    }


    public TjbbReportDynamic getTjbbDynamicProfile(BbdmLocationDTO bbdmLocationDTO) {

        String bbdm = bbdmLocationDTO.getBbdm();
        Integer x = bbdmLocationDTO.getX();
        Integer y = bbdmLocationDTO.getY();

        TjbbReportModel reportModel = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        BigDecimal excelcol = reportModel.getExcelcol();

        TjbbReportDynamic tjbbReportDynamic =new TjbbReportDynamic();
        tjbbReportDynamic.setBbdm(bbdm);
        tjbbReportDynamic.setLocation(String.valueOf(x)+"-"+String.valueOf(y));

        TjbbReportDynamic selectOne = tjbbReportDynamicMapper.selectOne(tjbbReportDynamic);

        if(selectOne==null){
            selectOne=new TjbbReportDynamic();
            List<String> bblcs =  tlMapper.selectBblcHeader(bbdm,x);
            List<String> clumnTitles =  tlMapper.selectTitleHeader(bbdm,Integer.valueOf(excelcol.toString())+y-1);

            selectOne.setBbdm(bbdm);
            selectOne.setBblcName(StringUtils.join(bblcs.toArray(),"-"));
            selectOne.setColumnTitle(StringUtils.join(clumnTitles.toArray(),"-"));
            selectOne.setLocation(tjbbReportDynamic.getLocation());
        }

        selectOne.setCrtime(null);
        selectOne.setUptime(null);
        return selectOne;


    }

    public void saveDynamicProfile(TjbbReportDynamic tjbbReportDynamic) {

        TjbbReportDynamic dynamic = tjbbReportDynamicMapper.selectByPrimaryKey(tjbbReportDynamic);

        if(dynamic==null){
            tjbbReportDynamic.setCrtime(new Date());
            tjbbReportDynamicMapper.insert(tjbbReportDynamic);
        }else {
            tjbbReportDynamic.setUptime(new Date());
            tjbbReportDynamicMapper.updateByPrimaryKeySelective(tjbbReportDynamic);
        }

    }

    public List<LocationVo> getDynamicLocations(String bbdm,String type) {

        TjbbReportDynamic tjbbReportDynamic = new TjbbReportDynamic();
        tjbbReportDynamic.setBbdm(bbdm);
        if("1".equals(type)){
            tjbbReportDynamic.setIsValid("1");
        }


        List<TjbbReportDynamic> select = tjbbReportDynamicMapper.select(tjbbReportDynamic);

        List<LocationVo> retList = new ArrayList<>();

        for (TjbbReportDynamic reportDynamic : select) {
            LocationVo locationVo =new LocationVo();
            locationVo.setLocation(reportDynamic.getLocation());
            locationVo.setIsValid(reportDynamic.getIsValid());
            retList.add(locationVo);
        }

        return retList;

    }

    public List loaddataDynamicSqlData(String bblc,String bbdm, String ssny, String location, String curSwjgdm, Integer pageNo, Integer pageSize) {

        TjbbReportModel model = tjbbReportModelMapper.selectByPrimaryKey(bbdm);
        if("1".equals(model.getBbtype())){
            bblc="";
        }

        TjbbReportDynamic p = new TjbbReportDynamic();
        p.setBbdm(bbdm);
        p.setLocation(location);
        p.setIsValid("1");

        TjbbReportDynamic reportDynamic = tjbbReportDynamicMapper.selectByPrimaryKey(p);

        if(reportDynamic!=null){
            String sqlScript = reportDynamic.getSqlScript();

            if(!TlUtils.isValidQuerySql(sqlScript)){
                throw new BusinessException("配置条件无效");
            }

            if(!StringUtils.isBlank(sqlScript)){
                String dbTarget = reportDynamic.getDbTarget();
                if("2".equals(dbTarget)){
                    commonService.changeDataSource(MultipleDataSourceHolder.JSXT);
                }

                if(sqlScript.contains("#{swjgdm}")){
                    sqlScript=sqlScript.replace("#{swjgdm}","'"+curSwjgdm+"'");
                }

                if(sqlScript.contains("#{ssny}")){
                    sqlScript=sqlScript.replace("#{ssny}","'"+ssny+"'");
                }

                if(sqlScript.contains("#{bblc}")){
                    sqlScript=sqlScript.replace("#{bblc}","'"+bblc+"'");
                }


                List<LinkedHashMap> retList =  tlMapper.selectDynamicTableDetails(sqlScript);
                if(CollectionUtils.isEmpty(retList)){

                    LinkedHashMap linkedHashMap = new LinkedHashMap();
                    Page<LinkedHashMap> ret = new Page<LinkedHashMap>();

                    List<String> list = queryMetaData(sqlScript);
                    for (String s : list) {
                        linkedHashMap.put(s,"");
                    }

//                    Page<LinkedHashMap> ret = new Page<LinkedHashMap>();
//
//                    String[] strings = TlUtils.dynnamicColumn.get();
//                    LinkedHashMap linkedHashMap = new LinkedHashMap();
//                    for (String string : strings) {
//                        linkedHashMap.put(string,"");
//                    }

                    ret.add(linkedHashMap);

                    return ret;
                }else {
                    PageHelper.startPage(pageNo, pageSize);
                    retList =  tlMapper.selectDynamicTableDetails(sqlScript);
                }

                return retList;
            }
        }

        return  null;
    }


    private  Page<LinkedHashMap> sjjcDynamicQuery(String taskid, DynamicQueryDTO param, String qxdm, StringBuffer sqltext) throws UnsupportedEncodingException {


        String fromTableScript= getFromTableScript(param);

        String wherTableScript= getWhereTableScript(param,qxdm);

        String groupByScriptSelect=null;
        String groupByScript=null;
        if(!CollectionUtils.isEmpty(param.getFzItems())){
            groupByScriptSelect= getgroupByScriptSelect(param);

            groupByScript=getGroupByScript(groupByScriptSelect);
        }


        //用户分组项
        StringBuffer sb1 = new StringBuffer();
        boolean isGroupByQuery = StringUtils.isNotBlank(groupByScript);
        if(isGroupByQuery){
            sb1.append(" "+groupByScript+",");
        }

        String selectHzScript= getselectHzScript(param);

        String selectScript = sb1.append(selectHzScript).toString();

        logger.info("组装动态查询语句，汇总指标项目：{}",selectScript);

        StringBuffer sqlScriptBuffer = new StringBuffer();

        int i=0;
        while(wherTableScript.contains("#->") && wherTableScript.contains("<-#")){

            /**
             *拼接程with P0 as (select from ),P1 as (select from) ORACLE SQL语法
             */
            String prefix;
            if(i==0){
                prefix = "with ";
            }else {
                prefix = ",";
            }

            String items = wherTableScript.split("#->")[1].split("<-#")[0];

            StringBuffer sb = new StringBuffer();
            for (String item : items.split(",")) {
                if(StringUtils.isNotBlank(sb.toString())){
                    sb.append("  union all ");
                }

                sb.append(" select ").append(item).append(" as col from dual");
            }

            if(StringUtils.isNotBlank(sb.toString())){
                String table = "P"+(i++);
                sqlScriptBuffer.append(prefix+table+" as (").append(sb.toString()).append(")");
                String substring = wherTableScript.substring(wherTableScript.indexOf("#->"), wherTableScript.indexOf("<-#") + 3);
                wherTableScript=wherTableScript.replace(substring,"");
            }
        }

        sqlScriptBuffer.append(" select ");
        sqlScriptBuffer.append(selectScript);
        sqlScriptBuffer.append(" from ");
        sqlScriptBuffer.append(fromTableScript);
        sqlScriptBuffer.append(" where ");
        sqlScriptBuffer.append(wherTableScript);

        if(StringUtils.isNotBlank(groupByScript)){
            sqlScriptBuffer.append(" group by ");
            sqlScriptBuffer.append(groupByScript);
        }

        /**
         * 对生成后的查询SQL外面套一层，用于关联字段表进行获取中文字段
         */

        sqlScriptBuffer=process2OutDictSql(sqlScriptBuffer,groupByScriptSelect,selectHzScript);



        String sqlScript = sqlScriptBuffer.toString();

        if(!TlUtils.isValidQuerySql(sqlScript)){
            logger.warn(sqlScript);
            throw new BusinessException("异常查询操作");
        }

        if(StringUtils.isNotBlank(sqltext.toString())){
            sqltext.append(";");
        }
        sqltext.append(sqlScript);



        logger.info("执行动态SQL查询-{}",sqlScript);
        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);
        saveTaskExcuteSql(taskid,sqltext);

        Page<LinkedHashMap> retList = excuteDynamicSql(param,sqlScript);

        if(CollectionUtils.isEmpty(retList)){

            LinkedHashMap linkedHashMap = new LinkedHashMap();
            Page<LinkedHashMap> ret = new Page<LinkedHashMap>();

            List<String> list = queryMetaData(sqlScript);
            for (String s : list) {
                linkedHashMap.put(s,"");
            }

            ret.add(linkedHashMap);

            return ret;
        }

        for (LinkedHashMap linkedHashMap : retList) {

            StringBuffer sb = new StringBuffer();
            for (DynamicQueryDTO.FzItem fzItem : param.getFzItems()) {
                String zbxmbm = fzItem.getZbxmbm();

                JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(zbxmbm);

                String fmt = zbxmModel.getFormat()==null?"":zbxmModel.getFormat();

                String zbxmmc = zbxmModel.getZbxmmc();

                Object o = linkedHashMap.get(zbxmmc+fmt);

                if(o==null){
                    continue;
                }

                sb.append(o.toString()+"-");
            }

            linkedHashMap.put("fzhash",TlUtils.getHashValue4String(sb.toString()));

        }

        return retList;

    }


    private Page<LinkedHashMap> excuteDynamicSql(DynamicQueryDTO param, String sqlScript){

        PageHelper.startPage(param.getPageNo(), param.getPageSize());
        Page<LinkedHashMap> retList =  tlMapper.selectDynamicTableDetails(sqlScript);

        return retList;
    }

    private List<String> queryMetaData(String querySql){

        try {
            Connection con = datasource.getConnection();
            PreparedStatement pStatement = con.prepareStatement(querySql);
            ResultSet executeQuery = pStatement.executeQuery();
            ResultSetMetaData meta = executeQuery.getMetaData();
            int columnCount = meta.getColumnCount();
            List<String> cols = new ArrayList<>();
            for (int i = 1; i <= columnCount; i++) {
                cols.add(meta.getColumnName(i));
            }

            return cols;

        } catch (SQLException e) {
            logger.error("异常：",e);
        }

        return null;
    }


    private void saveTaskExcuteSql(String taskid, StringBuffer sqltext) {

        JcfxTaskModel up= new JcfxTaskModel();
        up.setId(taskid);
        up.setSqltext(sqltext.toString());

        jcfxTaskModelMapper.updateByPrimaryKeySelective(up);
    }

    /**
     * 对sql外层进行嵌套处理
     * @param sqlScriptBuffer
     * @param groupByScript
     * @param selectHzScript
     */
    private StringBuffer process2OutDictSql(StringBuffer sqlScriptBuffer, String groupByScript, String selectHzScript) {
        
        if(StringUtils.isEmpty(groupByScript)){
            return sqlScriptBuffer;
        }

        Map<String, String> mc = dictinfoCacheService.getCacheDictInfoMap("mc");
        Map<String, String> dm = dictinfoCacheService.getCacheDictInfoMap("dm");

        if(mc==null || dm ==null){
            return sqlScriptBuffer;
        }

        String[] split = groupByScript.split(",");

        StringBuffer leftJoinSqlBuffer = new StringBuffer("("+sqlScriptBuffer+") T ");
        StringBuffer selectOutSql  = new StringBuffer();

        /**
         * baseNoDictScript 用于生成那些没有字典表信息的分组字段
         */
        StringBuffer baseNoDictScript = new StringBuffer();
        for (String item : split) {

            String[] temp = item.split("as");
            String title = temp[1];
            String str = temp[0];

            String field = str.split("\\.")[1].toUpperCase().trim();

            String mcStr = mc.get(field);

            if(StringUtils.isEmpty(mcStr)){

                if(StringUtils.isNotBlank(baseNoDictScript.toString())){
                    baseNoDictScript.append(",");
                }

                baseNoDictScript.append("T.").append(field).append(" as ").append(title);
                continue;
            }

            String[] mcArray = mcStr.split("-");


            String dmStr = dm.get(field);
            String[] dmArray = dmStr.split("-");

            if(StringUtils.isNotBlank(selectOutSql.toString())){
                selectOutSql.append(",");
            }
            selectOutSql.append("T."+field).append("||'-'||").append(mcArray[0]).append(".").append(mcArray[1]).append(" as "+title);
            leftJoinSqlBuffer.append(" left join ").append(mcArray[0]).append(" on ").append(dmArray[0]).append(".").append(dmArray[1]).append("=").append("T.").append(field);

            if(field.equals("SPDM_8")){
                leftJoinSqlBuffer.append(" and jcfx_dm_cksptree.cksp_jc=4 ");
            }else if(field.equals("CKSP_DM")){
                leftJoinSqlBuffer.append(" and jcfx_dm_cksptree.cksp_jc=5 ");
            }
        }




        //获取汇总项标题列
        String[] hzTitleSplit = selectHzScript.split(",");
        for (String item : hzTitleSplit) {

            String[] temp = item.split("as");
            String title = temp[1];

            if(StringUtils.isNotBlank(selectOutSql.toString())){
                selectOutSql.append(",");
            }
            selectOutSql.append(title);
        }

        StringBuffer retBuf = new StringBuffer();

        retBuf.append(" select ");
        if(StringUtils.isNotBlank(baseNoDictScript.toString())){
            retBuf.append(baseNoDictScript).append(",");
        }
        retBuf.append(selectOutSql.toString());
        retBuf.append(" from ");
        retBuf.append(leftJoinSqlBuffer.toString());


        return retBuf;

    }

    private String getGroupByScript(String groupByScriptSelect){

        String[] sts = groupByScriptSelect.split(",");
        StringBuffer sb = new StringBuffer();
        for (String st : sts) {
            String[] split = st.split("as");
            String s = split[0];

            if(!StringUtils.isEmpty(sb.toString())){
                sb.append(",");
            }

            sb.append(s);
        }

        return sb.toString();
    }

    private String getgroupByScriptSelect(DynamicQueryDTO param) {

        List<DynamicQueryDTO.FzItem> fzItems = param.getFzItems();

        StringBuffer sb = new StringBuffer();
        for (DynamicQueryDTO.FzItem fzItem : fzItems) {

            JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(fzItem.getZbxmbm());

            if(zbxmModel==null){
                throw new BusinessException("不存在的指标分组");
            }

            if(!StringUtils.isEmpty(sb.toString())){
                sb.append(",");
            }

            String fmt = StringUtils.isNoneBlank(zbxmModel.getFormat())?zbxmModel.getFormat():"";

            if(StringUtils.isNotBlank(fzItem.getRange())){
                sb.append("substr(");
                sb.append(zbxmModel.getDatatable()+"."+zbxmModel.getField());
                sb.append(",1,"+Integer.parseInt(fzItem.getRange())+") as \""+zbxmModel.getZbxmmc()+fmt+"\"");
            }else {
                sb.append(zbxmModel.getDatatable()+"."+zbxmModel.getField()+" as \""+zbxmModel.getZbxmmc()+fmt+"\"");
            }
        }

        return sb.toString();
    }

    private String getWhereTableScript(DynamicQueryDTO param,String qxdm) {

        List<String> zbxmList = new ArrayList<>();

        String swjgDm = param.getSwjgDm();
        String ssnyStart = param.getSsnyStart();
        String ssnyEnd = param.getSsnyEnd();

        String preSwjgdm = TlUtils.getPreSwjgdm(swjgDm);

        StringBuffer sb = new StringBuffer("JCFX_NSR_BADJ.swjgdm like '"+preSwjgdm+"%' and JCFX_NSR_BADJ.swjgdm like '"+qxdm+"%'");


        zbxmList.addAll(param.getHzItems());

        //处理条件过滤
        int i=0;
        for (DynamicQueryDTO.FzItem fzItem : param.getFzItems()) {
            zbxmList.add(fzItem.getZbxmbm());

            List<String> values = fzItem.getValues();

            //替换自定义指标代码组的子项指标代码
            values=replaceZdyZbdm(values);

            if(!CollectionUtils.isEmpty(values)){
                JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(fzItem.getZbxmbm());
                String datatable = zbxmModel.getDatatable();
                String field = zbxmModel.getField();
                sb.append(" and "+datatable+"."+field+" in (");
                String inSql = "'"+StringUtils.join(values.toArray(), "','")+"'";

                if(inSql.length()<995){
                    sb.append(inSql);
                }else {
                    sb.append("select col #->").append(inSql).append("<-# from P"+(i++));
                }
                sb.append(")");
            }
        }


        //处理表间关联
        Set<String> tabSet = new HashSet<>();
        for (String zbxmdm : zbxmList) {

            JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(zbxmdm);

            String datatable = zbxmModel.getDatatable();

            if(tabSet.contains(datatable.toUpperCase())||datatable.toUpperCase().equals("JCFX_NSR_BADJ")){
                continue;
            }else {
                tabSet.add(datatable.toUpperCase());
            }




            if(datatable.toUpperCase().equals("JCFX_DM_CKSP")){

                if(TlConst.SJJC_TJBB_HZTYPE_TS.equals(param.getHztype())){
                    sb.append(" and JCFX_DATA_TSSBMX.CKSP_DM="+datatable+".CKSP_DM");
                }else if(TlConst.SJJC_TJBB_HZTYPE_CK.equals(param.getHztype())){
                    sb.append(" and JCFX_DATA_BGDMX.CKSP_DM="+datatable+".CKSP_DM");
                }

            }else {

                sb.append(" and JCFX_NSR_BADJ.djxh="+datatable+".djxh");

                if(StringUtils.isNotBlank(ssnyStart)){
                    sb.append(" and "+datatable+".ny>='"+ssnyStart+"'");
                }

                if(StringUtils.isNotBlank(ssnyEnd)){
                    sb.append(" and "+datatable+".ny<='"+ssnyEnd+"'");
                }
            }

        }


        /**
         * 样本组企业信息过滤
         */
        Long zid = param.getZid();
        if(zid!=null){

            List<NsrSampleSubModel>  list = sjjcQueryService.getNsrSampleSubListByZid(zid);
            List<BigDecimal> values = new ArrayList<>();
            for (NsrSampleSubModel subModel : list) {
                values.add(subModel.getDjxh());
            }

            if(!CollectionUtils.isEmpty(values)){
                sb.append(" and JCFX_NSR_BADJ.DJXH in (");
                sb.append(StringUtils.join(values.toArray(), ","));
                sb.append(")");
            }

        }

        return sb.toString();

    }

    private List<String> replaceZdyZbdm(List<String> values) {

        if(CollectionUtils.isEmpty(values)){
            return null;
        }

        List<String> retList = new ArrayList<>();
        for (String value : values) {
            if(value.contains("-ZDY")){
                String[] split = value.split("-");
                Long zid = Long.parseLong(split[0]);
                List<String> dms = tlMapper.selectZbxmByZid(zid);
                if(!CollectionUtils.isEmpty(dms)){
                    retList.addAll(dms);
                }
            }else {
                retList.add(value);
            }
        }

        return retList;

    }

    private String getFromTableScript(DynamicQueryDTO param) {
        List<String> tableItems = new ArrayList<>();

        List<String> hzItems = param.getHzItems();
        List<DynamicQueryDTO.FzItem> fzItems = param.getFzItems();

        tableItems.addAll(hzItems);

        for (DynamicQueryDTO.FzItem fzItem : fzItems) {
            tableItems.add(fzItem.getZbxmbm());
        }

        StringBuffer sb = new StringBuffer("jcfx_nsr_badj");

        Set<String> tableSet = new HashSet<>();
        tableSet.add("JCFX_NSR_BADJ");
        for (String zbxmdm : tableItems){

            JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(zbxmdm);

            if(tableSet.contains(zbxmModel.getDatatable().toUpperCase())){
                continue;
            }

            tableSet.add(zbxmModel.getDatatable().toUpperCase());

            if(!StringUtils.isEmpty(sb.toString())){
                sb.append(",");
            }

            sb.append(zbxmModel.getDatatable());

        }

        if(StringUtils.isEmpty(sb.toString())){
            throw new BusinessException("异常操作");
        }

        return sb.toString();

    }

    private String getselectHzScript(DynamicQueryDTO param) {
        List<String> hzItems = param.getHzItems();

        StringBuffer sb = new StringBuffer();
        sb.append("count(distinct JCFX_NSR_BADJ.nsrsbh) as \"户数\"");



        for (String hzItem : hzItems) {

            JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(hzItem);

            if(zbxmModel==null){
                throw new BusinessException("不存在的指标代码");
            }


            String datatable = zbxmModel.getDatatable();

            if(datatable.toUpperCase().equals("JCFX_NSR_BADJ")){
                continue;
            }


            String item=datatable+"."+zbxmModel.getField();


            if(!StringUtils.isEmpty(sb.toString())){
                sb.append(",");
            }


            item=" sum("+item+")";

            String fmt = StringUtils.isNoneBlank(zbxmModel.getFormat())?zbxmModel.getFormat():"";

            sb.append(item+" as \""+zbxmModel.getZbxmmc()+fmt+"\"");

        }

        if(StringUtils.isEmpty(sb.toString())){
            throw new BusinessException("异常操作");
        }

        return sb.toString();
    }

    /**
     * 获取初始化条件
     * @return
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public FzHzInitVo getFzHzInit() {

        //String swjgDm = commonService.getCurrentUser().getSwjgDm();
        String swjgDm = "133";

        StopWatch stopWatch = new StopWatch();


        FzHzInitVo retVo = new FzHzInitVo();

        stopWatch.start("生成出口类汇总指标");
        List<ZbItemVo> hzItemsCk = new ArrayList<>();
        fillItemList(hzItemsCk, TlConst.ZBDL_HZ_CK,swjgDm,null);
        retVo.setHzItemsCk(hzItemsCk);
        stopWatch.stop();

        stopWatch.start("生成退税类汇总指标");
        List<ZbItemVo> hzItemsTs = new ArrayList<>();
        fillItemList(hzItemsTs, TlConst.ZBDL_HZ_TS, swjgDm, null);
        retVo.setHzItemsTs(hzItemsTs);
        stopWatch.stop();

        stopWatch.start("生成办理类汇总指标");
        List<ZbItemVo> hzItemsBl = new ArrayList<>();
        fillItemList(hzItemsBl, TlConst.ZBDL_HZ_BL, swjgDm, null);
        retVo.setHzItemsBl(hzItemsBl);
        stopWatch.stop();


        stopWatch.start("生成登记类分组指标");
        List<ZbItemVo> fzItemsDj = new ArrayList<>();
        fillItemList(fzItemsDj, TlConst.ZBDL_FZ_DJ, swjgDm, null);
        retVo.setFzItemsDj(fzItemsDj);
        stopWatch.stop();

        stopWatch.start("生成出口类分组指标");
        List<ZbItemVo> fzItemsCk = new ArrayList<>();
        fillItemList(fzItemsCk, TlConst.ZBDL_FZ_CK, swjgDm, null);
        retVo.setFzItemsCk(fzItemsCk);
        stopWatch.stop();

        stopWatch.start("生成财务类分组指标");
        List<ZbItemVo> fzItemsCw = new ArrayList<>();
        fillItemList(fzItemsCw, TlConst.ZBDL_FZ_CW, swjgDm, null);
        retVo.setFzItemsCw(fzItemsCw);
        stopWatch.stop();

        stopWatch.start("生成退税类分组指标");
        List<ZbItemVo> fzItemsTs = new ArrayList<>();
        fillItemList(fzItemsTs, TlConst.ZBDL_FZ_TS, swjgDm, null);
        retVo.setFzItemsTs(fzItemsTs);
        stopWatch.stop();

        logger.info(stopWatch.prettyPrint());

        return retVo;

    }


    /**
     * 填充分组指标及初始化选项
     * @param hzItems
     * @param zbdldm
     * @param swjgDm
     * @param zbxms
     */
    private void fillItemList(List<ZbItemVo> hzItems, String zbdldm, String swjgDm, List<String> zbxms){

        Example ep = new Example(JcfxZbxmModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("zbdlbm",zbdldm);
        criteria.andEqualTo("isvalid","1");

        //默认展示展示项，如果有指定对应编码，则展示对应大类的指定编码
        if(CollectionUtils.isEmpty(zbxms)){
            criteria.andEqualTo("isshow","1");
        }else {
            criteria.andIn("zbxmbm",zbxms);
        }

        ep.setOrderByClause("pxno");


        List<JcfxZbxmModel> select = jcfxZbxmModelMapper.selectByExample(ep);

        StopWatch stopWatch = new StopWatch();
        for (JcfxZbxmModel zbxmModel : select) {

            ZbItemVo zbItemVo = new ZbItemVo();
            zbItemVo.setZbxmbm(zbxmModel.getZbxmbm());
            zbItemVo.setZbxmmc(zbxmModel.getZbxmmc());

            stopWatch.start("生成出指标代码数据："+zbxmModel.getZbxmmc());

            List<SelectItemVo> selectItemVos = new ArrayList<>();

            boolean isTree =false;
            if(StringUtils.isNotBlank(zbxmModel.getDicttable())){

                String sqlScript = "select * from "+zbxmModel.getDicttable();

                if(zbxmModel.getDicttable().toUpperCase().equals("JCFX_DM_SZQJZB")){
                    sqlScript = sqlScript + " where zbxm='"+zbxmModel.getZbxmbm()+"'";
                }

                List<LinkedHashMap> retList =  tlMapper.selectDynamicTableDetails(sqlScript);


                if(retList.size()>0){
                    isTree = retList.get(0).keySet().contains("PID");
                }

                for (LinkedHashMap linkedHashMap : retList) {

                    if(isTree && (linkedHashMap.get("PID") == null || "NULL".equals(linkedHashMap.get("PID").toString()) )){
                        continue;
                    }

                    SelectItemVo selectItemVo = new SelectItemVo();
                    for (Object o : linkedHashMap.keySet()) {

                        if(o.toString().toUpperCase().contains("DM")){
                            selectItemVo.setCode(linkedHashMap.get(o).toString());
                        }else if(o.toString().toUpperCase().contains("PID")){
                            selectItemVo.setParentId(linkedHashMap.get(o).toString());
                        }else if(o.toString().toUpperCase().contains("MC")){
                            selectItemVo.setName(linkedHashMap.get(o).toString());
                        }

                    }
                    selectItemVos.add(selectItemVo);

                }
            }

            String  treeLable = "全部";
            List<SelectItemVo> treeMenus=new ArrayList<>();
            if(isTree){
                zbItemVo.setIsTree("1");
                treeMenus = createMutiTreeMenus(selectItemVos,treeLable);
            }else {
                zbItemVo.setIsTree("0");
                zbItemVo.setValues(selectItemVos);
            }


            //从自定义指标表中获取自定义分组代码
            List<SelectItemVo> zdyDms =  tlMapper.selectZdyZbdm(zbxmModel.getZbxmbm(),TlUtils.getPreSwjgdm(swjgDm));
            if(!CollectionUtils.isEmpty(zdyDms)){

                zbItemVo.setIsTree("1");
                List<SelectItemVo> treeMenusZdy = createMutiTreeMenus(zdyDms,"自定义选项");
                treeMenus.addAll(treeMenusZdy);
            }

            if(!CollectionUtils.isEmpty(treeMenus)){
                zbItemVo.setValues(treeMenus);
            }

            hzItems.add(zbItemVo);

            stopWatch.stop();

        }

        logger.info(stopWatch.prettyPrint());
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<SelectItemVo> getSpdmTreeList(String codes, String level){

        StopWatch stopWatch = new StopWatch();

        stopWatch.start("执行商品代树加载："+codes+"-"+level);

        if("01".equals(level)){
            level="1";
        }else if("02".equals(level)){
            level="2";
        }else if("04".equals(level)){
            level="3";
        }else if("08".equals(level)){
            level="4";
        }else if("10".equals(level)){
            level="5";
        }



        String sqlScript = "select * from jcfx_dm_cksptree where cksp_jc<='"+level+"'";

        HashSet<String> codeSet = new HashSet<>();
        if(StringUtils.isNotBlank(codes)){
            String[] split = codes.split(",");
            codeSet = new HashSet<>(Arrays.asList(split));
        }


        if(!TlUtils.isValidQuerySql(sqlScript)){
            logger.warn(sqlScript);
            throw new BusinessException("异常查询操作");
        }

        List<LinkedHashMap> retList =  tlMapper.selectDynamicTableDetails(sqlScript);

        List<SelectItemVo> selectItemVos = new ArrayList<>();
        for (LinkedHashMap linkedHashMap : retList) {

            if(linkedHashMap.get("PID") == null || "NULL".equals(linkedHashMap.get("PID").toString())){
                continue;
            }

            SelectItemVo selectItemVo = new SelectItemVo();

            for (Object o : linkedHashMap.keySet()) {

                if(o.toString().toUpperCase().contains("DM")){
                    selectItemVo.setCode(linkedHashMap.get(o).toString());

                    if(codeSet.contains(selectItemVo.getCode())){
                        selectItemVo.setChecked(true);
                    }else {
                        selectItemVo.setChecked(false);
                    }

                }else if(o.toString().toUpperCase().contains("PID_JC")){
                    selectItemVo.setpLevel(linkedHashMap.get(o).toString());
                }else if(o.toString().toUpperCase().contains("PID")){
                    selectItemVo.setParentId(linkedHashMap.get(o).toString());
                }else if(o.toString().toUpperCase().contains("MC")){
                    selectItemVo.setName(linkedHashMap.get(o).toString());
                }else if(o.toString().toUpperCase().contains("CKSP_JC")){
                    selectItemVo.setLevel(linkedHashMap.get(o).toString());
                }

            }
            selectItemVos.add(selectItemVo);

        }

        List<SelectItemVo> treeMenus = createCkspTreeMenus(selectItemVos,"全部");


        String swjgDm = commonService.getCurrentUser().getSwjgDm();
        //从自定义指标表中获取自定义分组代码
        List<SelectItemVo> zdyDms =  tlMapper.selectZdyZbdm("cksp.10",TlUtils.getPreSwjgdm(swjgDm));
        if(!CollectionUtils.isEmpty(zdyDms)){
            List<SelectItemVo> treeMenusZdy = createMutiTreeMenus(zdyDms,"自定义选项");
            treeMenus.addAll(treeMenusZdy);
        }

        stopWatch.stop();

        logger.info(stopWatch.prettyPrint());

        return treeMenus;

    }

    public JcfxTaskModel getQueryTask(DynamicQueryDTO dynamicQueryDTO, StringBuffer sb) throws Exception {

        Integer pageNo = dynamicQueryDTO.getPageNo();
        String pid = dynamicQueryDTO.getPid();

        if(dynamicQueryDTO.getHzItems()==null){
            dynamicQueryDTO.setHzItems(new ArrayList<>());
        }
        if(dynamicQueryDTO.getFzItems()==null){
            dynamicQueryDTO.setFzItems(new ArrayList<>());
        }

        String flushFlag = dynamicQueryDTO.getFlushFlag();

        TlUserProfile userProfile = commonService.getCurrentUser();

        String swjgDm = userProfile.getSwjgDm();
        dynamicQueryDTO.setLogonSwjgDm(TlUtils.getPreSwjgdm(swjgDm));


        /**
         * 剔除不需要参与HASH的字段
         */
        dynamicQueryDTO.setFlushFlag(null);


        dynamicQueryDTO.setPageNo(null);
        dynamicQueryDTO.setPid(null);
        String jsonReq = new Gson().toJson(dynamicQueryDTO);
        String hash = TlUtils.getHashValue4String(jsonReq);


        dynamicQueryDTO.setPageNo(pageNo);
        dynamicQueryDTO.setPid(pid);
        String json = new Gson().toJson(dynamicQueryDTO);

        //查询首页主任务记录是否存在
        JcfxTaskModel taskModel = jcfxTaskModelMapper.selectByPrimaryKey(hash);


        if(taskModel!=null){

            //首页刷新，则删除所有任务记录
            if("1".equals(flushFlag) && StringUtils.isEmpty(pid)){
                jcfxTaskModelMapper.deleteByPrimaryKey(hash);

                JcfxTaskSubModel jcfxTaskSubModel = new JcfxTaskSubModel();
                jcfxTaskSubModel.setPid(hash);
                jcfxTaskSubModelMapper.delete(jcfxTaskSubModel);

                taskModel = null;
            }else if(!StringUtils.isEmpty(pid)){ //翻页任务查询

                JcfxTaskSubModel jcfxTaskSubModel = new JcfxTaskSubModel();
                jcfxTaskSubModel.setPid(hash);
                jcfxTaskSubModel.setPageNo(new BigDecimal(pageNo));

                JcfxTaskSubModel subModel = jcfxTaskSubModelMapper.selectOne(jcfxTaskSubModel);

                /**
                 * 通过将翻页数据封装成首页任务的形式返回给前端，有数据则设置成2，已完成，否则设置1，表示翻页记录未数据查询完成。
                 */
                JcfxTaskModel retModel = new JcfxTaskModel();
                if(subModel==null){
                    /**
                     * 当异步翻页查询任务未执行完成，没产生子任务记录数据时，同步尝试实时查询数据
                     */
                    StringBuffer sqltext = new StringBuffer();
                    SjjcDynamicVo sjjcDynamicVo = getDynamicData(hash, dynamicQueryDTO, sqltext);
                    byte[] data = GZipUitl.genZip(new Gson().toJson(sjjcDynamicVo));

                    if(data!=null && data.length>0){
                        retModel.setTaskFlag("2");
                        retModel.setRespData(data);
                    }else {
                        throw new BusinessException("数据查询异常");
                    }
                }else {
                    retModel.setTaskFlag("2");
                    retModel.setRespData(subModel.getRespData());
                }

                return retModel;
            }

        }

        if(taskModel==null){
            taskModel = new JcfxTaskModel();
            taskModel.setId(hash);
            taskModel.setCzryDm(userProfile.getCzryDm());
            taskModel.setReqParam(json);
            taskModel.setTaskFlag("0");
            taskModel.setTqcs(new BigDecimal(0l));
            taskModel.setCrtime(new Date());
            taskModel.setSwjgdm(userProfile.getSwjgDm());
            taskModel.setTitle(dynamicQueryDTO.getTitle());
            taskModel.setBbtype(dynamicQueryDTO.getTjbbType());
            jcfxTaskModelMapper.insert(taskModel);

            sb.append(hash);
            return null;
        }else{
            return taskModel;
        }
    }


    public JcfxTaskModel getQuerySubDetailTask(DynamicQueryDTO dynamicQueryDTO, StringBuffer sb) throws UnsupportedEncodingException {


        if(dynamicQueryDTO.getHzItems()==null){
            dynamicQueryDTO.setHzItems(new ArrayList<>());
        }
        if(dynamicQueryDTO.getFzItems()==null){
            dynamicQueryDTO.setFzItems(new ArrayList<>());
        }

        String flushFlag = dynamicQueryDTO.getFlushFlag();

        TlUserProfile userProfile = commonService.getCurrentUser();

        String swjgDm = userProfile.getSwjgDm();
        dynamicQueryDTO.setLogonSwjgDm(TlUtils.getPreSwjgdm(swjgDm));


        /**
         * 剔除不需要参与HASH的字段
         */
        dynamicQueryDTO.setFlushFlag(null);


        String jsonReq = new Gson().toJson(dynamicQueryDTO);
        String hash = TlUtils.getHashValue4String(jsonReq);

        String json = new Gson().toJson(dynamicQueryDTO);

        JcfxTaskModel taskModel = jcfxTaskModelMapper.selectByPrimaryKey(hash);


        if(taskModel!=null && "1".equals(flushFlag)){
            jcfxTaskModelMapper.deleteByPrimaryKey(hash);
            taskModel=null;
        }

        if(taskModel==null){
            taskModel = new JcfxTaskModel();
            taskModel.setId(hash);
            taskModel.setCzryDm(userProfile.getCzryDm());
            taskModel.setReqParam(json);
            taskModel.setTaskFlag("0");
            taskModel.setTqcs(new BigDecimal(0l));
            taskModel.setCrtime(new Date());
            taskModel.setSwjgdm(userProfile.getSwjgDm());
            taskModel.setTitle(dynamicQueryDTO.getTitle());
            taskModel.setBbtype(dynamicQueryDTO.getTjbbType());
            jcfxTaskModelMapper.insert(taskModel);

            sb.append(hash);
            return null;
        }else{
            return taskModel;
        }


    }

    /**
     * 动态查询数据检测分析数据
     *
     * @param taskid
     * @param param
     * @param sqltext
     * @return
     * @throws Exception
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public SjjcDynamicVo getDynamicData(String taskid, DynamicQueryDTO param, StringBuffer sqltext) throws Exception {

        /**
         * 初始化分组指标集合变量
         */
        Set<String> hzItemSet = new HashSet<>();
        for (String hzItem : param.getHzItems()) {
            JcfxZbxmModel zbxmModel = zbItemCacheService.getCacheJcfxZbxmModel(hzItem);
            hzItemSet.add(zbxmModel.getZbxmmc());
        }


        String qxdm = param.getLogonSwjgDm();

        Page<LinkedHashMap> list = sjjcDynamicQuery(taskid,param,qxdm,sqltext);

        /**
         * 计算同比数据
         */
        Page<LinkedHashMap> lastYearList;
        if("1".equals(param.getIsHaveTb())){
            param.setSsnyStart(TlDateUtils.getLastYearSsny(param.getSsnyStart()));
            param.setSsnyEnd(TlDateUtils.getLastYearSsny(param.getSsnyEnd()));
            lastYearList=sjjcDynamicQuery(taskid, param,qxdm, sqltext);

            list = processAddTb(list, lastYearList,hzItemSet);
        }

        //计算合计值
        Map hjMap = genHjDataMap(hzItemSet,list);

        PageInfo<List<LinkedHashMap>> data =  TlUtils.dealPageInfo(list);

        SjjcDynamicVo sjjcDynamicVo =new SjjcDynamicVo();
        sjjcDynamicVo.setTitle(processTitle(data.getRows()));
        sjjcDynamicVo.setList(data);
        sjjcDynamicVo.setHj(hjMap);
        sjjcDynamicVo.setPid(taskid);

        return sjjcDynamicVo;
    }

    private Map genHjDataMap(Set<String> fzItemSet, Page<LinkedHashMap> list) {

        if(CollectionUtils.isEmpty(list) || list.get(0).get("fzhash")==null){
            return null;
        }

        Map<String,BigDecimal> retMap = new HashMap<>();

        for (LinkedHashMap linkedHashMap : list) {
            for (Object o : linkedHashMap.keySet()) {
                Object value = linkedHashMap.get(o);
                String match = o.toString().split("_")[0].split("-")[0];
                if(fzItemSet.contains(match) || "户数".equals(match)){

                    value = value==null?0:value;

                    BigDecimal sumValue = retMap.get(o.toString());
                    if(sumValue==null){
                        retMap.put(o.toString(),new BigDecimal(value.toString()));
                    }else {
                        retMap.put(o.toString(),sumValue.add(new BigDecimal(value.toString())));
                    }
                }
            }
        }

        return retMap;
    }

    private Page<LinkedHashMap> processAddTb(Page<LinkedHashMap> list, Page<LinkedHashMap> lastYearList, Set<String> fzItemSet) {

        Map<String,LinkedHashMap> lastYearData = new HashMap<>();
        for (LinkedHashMap lastYearMap : lastYearList) {
            //只有一行标题的情况下，fzhash值为空
            Object fzhash = lastYearMap.get("fzhash");

            if(fzhash==null){
                continue;
            }

            for (LinkedHashMap yearMap : list) {


                Object nowHash = yearMap.get("fzhash");

                if(fzhash.toString().equals(String.valueOf(nowHash))){
                    lastYearData.put(fzhash.toString(),lastYearMap);
                }

            }

        }


        Page<LinkedHashMap> retList = new Page<LinkedHashMap>();


        for (LinkedHashMap linkedHashMap : list) {

            Object fzhash = linkedHashMap.get("fzhash");


            LinkedHashMap lastYearRecord = null;
            if(fzhash!=null){
                 lastYearRecord = lastYearData.get(fzhash.toString());
            }


            LinkedHashMap newMap = new LinkedHashMap();
            int index=0;
            for (Object o : linkedHashMap.keySet()) {
                Object value = linkedHashMap.get(o);

                String match = o.toString().split("_")[0].split("-")[0].split("#")[0];
                if((fzItemSet.contains(match) || "户数".equals(match)) ){

                    value=value==null?0:value;
                    newMap.put(o,value);
                    String tbVlaue = "99.99";

                    if(lastYearRecord!=null){
                        Object lastValue = lastYearRecord.get(o.toString());
                        if(lastValue!=null
                                && StringUtils.isNotBlank(lastValue.toString())
                                && new BigDecimal(lastValue.toString()).compareTo(BigDecimal.ZERO)!=0){
                            tbVlaue=new BigDecimal(value.toString()).subtract(new BigDecimal(lastValue.toString()))
                                    .divide(new BigDecimal(lastValue.toString()),4, RoundingMode.HALF_UP).multiply(new BigDecimal(100L)).toString();
                        }
                        newMap.put("同期-"+index,lastValue);
                        newMap.put("同比-"+index++,tbVlaue);
                    }else {
                        newMap.put("同期-"+index,"");
                        newMap.put("同比-"+index++,tbVlaue);
                    }

                }else {
                    newMap.put(o,value);
                }
            }

            retList.setPageNum(list.getPageNum());
            retList.setPageSize(list.getPageSize());
            retList.setPages(list.getPages());
            retList.setTotal(list.getTotal());

            retList.setStartRow(list.getStartRow());
            retList.setEndRow(list.getEndRow());


            retList.add(newMap);
        }


        return retList;

    }

    private List processTitle(List<LinkedHashMap> rows) {
        LinkedHashMap linkedHashMap = rows.get(0);
        List<String> titles = new ArrayList<>();
        for (Object o : linkedHashMap.keySet()) {
            if("ROW_ID".equals(String.valueOf(o)) || "fzhash".equals(String.valueOf(o))){
                continue;
            }
            titles.add(String.valueOf(o));
        }

        return titles;
    }


    public static List<SelectItemVo> createTreeMenus(List<SelectItemVo> menus) {
        List<SelectItemVo> treeMenus = null;
        if (null != menus && !menus.isEmpty()) {
            // 创建根节点
            SelectItemVo root = new SelectItemVo();
            root.setItem(new ArrayList<>());

            root.setName("菜单根目录");

            // 组装Map数据
            Map<String, SelectItemVo> dataMap = new HashMap();
            for (SelectItemVo menu : menus) {
                dataMap.put(menu.getCode(), menu);
            }

            // 组装树形结构
            Set<Map.Entry<String, SelectItemVo>> entrySet = dataMap.entrySet();
            for (Map.Entry<String, SelectItemVo> entry : entrySet) {
                SelectItemVo menu = entry.getValue();
                if ("0".equals(menu.getParentId())) {
                    root.getItem().add(menu);
                } else {
                    if(dataMap.get(menu.getParentId())==null){
                        continue;
                    }
                    if(CollectionUtils.isEmpty(dataMap.get(menu.getParentId()).getItem())){
                        dataMap.get(menu.getParentId()).setItem(new ArrayList<>());
                    }
                    dataMap.get(menu.getParentId()).getItem().add(menu);
                }
            }

            // 对树形结构进行二叉树排序
            root.sortChildren();
            treeMenus = root.getItem();
        }
        return treeMenus;
    }

    public static List<SelectItemVo> createMutiTreeMenus(List<SelectItemVo> menus,String rootLable) {
        List<SelectItemVo> treeMenus = new ArrayList<>();
        if (null != menus && !menus.isEmpty()) {
            // 创建根节点
            SelectItemVo root = new SelectItemVo();
            root.setItem(new ArrayList<>());
            root.setCode("");
            root.setName(rootLable);

            // 组装Map数据
            Map<String, SelectItemVo> dataMap = new HashMap();
            for (SelectItemVo menu : menus) {
                dataMap.put(menu.getCode(), menu);
            }

            // 组装树形结构
            for (SelectItemVo menu : menus) {
                if ("0".equals(menu.getParentId())) {
                    root.getItem().add(menu);
                } else {
                    if(dataMap.get(menu.getParentId())==null){
                        continue;
                    }
                    if(CollectionUtils.isEmpty(dataMap.get(menu.getParentId()).getItem())){
                        dataMap.get(menu.getParentId()).setItem(new ArrayList<>());
                    }
                    dataMap.get(menu.getParentId()).getItem().add(menu);
                }
            }

            // 对树形结构进行二叉树排序
            root.sortChildren();
            treeMenus.add(root);
        }
        return treeMenus;
    }

    public static List<SelectItemVo> createCkspTreeMenus(List<SelectItemVo> menus,String lableText) {
        List<SelectItemVo> treeMenus = new ArrayList<>();
        if (null != menus && !menus.isEmpty()) {
            // 创建根节点
            SelectItemVo root = new SelectItemVo();
            root.setItem(new ArrayList<>());
            root.setCode("");
            root.setName(lableText);

            // 组装Map数据
            Map<String, SelectItemVo> dataMap = new HashMap();
            for (SelectItemVo menu : menus) {
                dataMap.put(menu.getCode()+"-"+menu.getLevel(), menu);
            }

            // 组装树形结构
            Set<Map.Entry<String, SelectItemVo>> entrySet = dataMap.entrySet();
            for (Map.Entry<String, SelectItemVo> entry : entrySet) {
                SelectItemVo menu = entry.getValue();
                if ("0".equals(menu.getParentId())) {
                    root.getItem().add(menu);
                } else {
                    String parKey = menu.getParentId()+"-"+menu.getpLevel();
                    if(dataMap.get(parKey)==null){
                        continue;
                    }
                    if(CollectionUtils.isEmpty(dataMap.get(parKey).getItem())){
                        dataMap.get(parKey).setItem(new ArrayList<>());
                    }
                    dataMap.get(parKey).getItem().add(menu);
                }
            }

            // 对树形结构进行二叉树排序
            root.sortChildren();
            //treeMenus = root.getItem();
            treeMenus.add(root);
        }
        return treeMenus;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public FzHzInitVo getFzHzInitOther(List<String> zbxms,String zbdldm) {

        String swjgDm = "133";

        StopWatch stopWatch = new StopWatch();


        FzHzInitVo retVo = new FzHzInitVo();

        stopWatch.start("生成其他类分组指标");
        List<ZbItemVo> hzItemsOther = new ArrayList<>();

        if(StringUtils.isEmpty(zbdldm)){
            zbdldm = TlConst.ZBDL_QT;
        }

        fillItemList(hzItemsOther, zbdldm,swjgDm, zbxms);
        retVo.setFzItemsOther(hzItemsOther);
        stopWatch.stop();

        logger.info(stopWatch.prettyPrint());

        return retVo;

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public ParamModel getSysParamInit() {

        SysParamModel p = new SysParamModel();
        p.setDtype("sjjc");

        List<SysParamModel> select = sysParamModelMapper.select(p);

        ParamModel retObj = new ParamModel();
        for (SysParamModel sysParamModel : select) {
            if("dateCrossYearFlag".equals(sysParamModel.getDcode())){
                retObj.setDateCrossYearFlag(sysParamModel.getDvalue());
            }else if("dataSsnyStart".equals(sysParamModel.getDcode())){
                retObj.setDataSsnyStart(sysParamModel.getDvalue());
            }else if("dataSsnyEnd".equals(sysParamModel.getDcode())){
                retObj.setDataSsnyEnd(sysParamModel.getDvalue());
            }
        }

        return retObj;

    }
}
