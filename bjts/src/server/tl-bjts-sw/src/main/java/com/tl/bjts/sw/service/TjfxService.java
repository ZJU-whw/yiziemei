package com.tl.bjts.sw.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageRowBounds;
import com.google.gson.Gson;
import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.JsZbModel;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.StateVo;
import com.tl.bjts.sw.model.vo.TjbbBaseColumnVo;
import com.tl.bjts.sw.model.vo.TjrwListVO;
import com.tl.bjts.sw.model.vo.WmGhqyMxVo;
import com.tl.bjts.sw.utils.*;
import com.tl.common.ext.utils.GsonUtils;
import com.tl.common.utils.MD5;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import tk.mybatis.mapper.entity.Example;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.Format;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

/**
 * @Author：Mamf
 * @Date: 2020/2/29.
 * @Description:
 */
@Service
public class TjfxService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    DqModelMapper dqModelMapper;

    @Autowired
    TlTjfxMapper tlTjfxMapper;

    @Autowired
    SpmlModelMapper spmlModelMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    private TlTjbbMapper tlTjbbMapper;

    @Autowired
    private TjbbReportModelMapper tjbbReportModelMapper;

    @Autowired
    private TjbbLineItemModelMapper tjbbLineItemModelMapper;

    @Autowired
    RwglYbclService rwglYbclService;

    @Autowired
    JsxtMapper jsxtMapper;

    public List<SpmlModel> initSpdlList() {

        Example e=new Example(SpmlModel.class);
        e.setOrderByClause(" spml ");

        return spmlModelMapper.selectByExample(e);

    }

    public StateVo initStates() {

        StateVo stateVo=new StateVo();
        List<StateVo.Continent> contis = new ArrayList<>();
        List<StateVo.Continent> areas = new ArrayList<>();

        stateVo.setAreas(areas);
        stateVo.setContis(contis);


        //1.初始化七大洲及国家
        DqModel p = new DqModel();
        p.setDqType("DQ");
        List<DqModel> select = dqModelMapper.select(p);
        for(DqModel model:select){

            StateVo.Continent continent = getContinent(model, stateVo);

            contis.add(continent);
        }


        //2.初始化经济体及国家
        Example ep=new Example(DqModel.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("dqType","ZZ");
        List<DqModel> models = dqModelMapper.selectByExample(ep);
        for(DqModel model:models){

            StateVo.Continent continent = getContinent(model, stateVo);

            areas.add(continent);
        }


        //3.初始化国家列表
        List<StateVo.State> states = tlTjfxMapper.selectStates();
        stateVo.setStates(states);


        return stateVo;

    }

    private StateVo.Continent getContinent(DqModel model,StateVo stateVo){
        StateVo.Continent continent= stateVo.new Continent();
        continent.setCode(model.getDqCode());
        continent.setName(model.getDqName());

        List<StateVo.State> contiStates=tlTjfxMapper.selectStatesByDq(model.getDqCode());
        continent.setStates(contiStates);

        return continent;
    }

    public String getCurUserPramHash(TjfxMainDTO obj){

        obj.setSwjgdm(commonService.getCurrentUser().getSwjgDm());
        obj.getCxtjDTO().setSwjgDm(commonService.getQxdm(obj.getCxtjDTO().getSwjgDm()));
        String bodyStr = GsonUtils.getDefaultGson().toJson(obj);
        try{
            byte[] bytes = bodyStr.getBytes("UTF-8");
            return MD5.digest(bytes);
        }catch (Exception e){
            logger.error("计算Hash值出错：",e);
            throw new BusinessException("计算Hash值出错");
        }
    }

    /**
     * 获取E01001的hash值
     * @param dto
     * @return
     */
    public String getE01001Hash(TjbbTaskDTO dto){
        dto.setSwjgdm(commonService.getCurrentUser().getSwjgDm());
        String bodyStr = GsonUtils.getDefaultGson().toJson(dto);
        try{
            byte[] bytes = bodyStr.getBytes("UTF-8");
            return MD5.digest(bytes);
        }catch (Exception e){
            logger.error("计算Hash值出错：",e);
            throw new BusinessException("计算Hash值出错");
        }
    }

    /**
     * 判断出口退税审核审批表是否存在
     * @param pramHash
     * @return
     */
    private boolean isExistHashRecord4Shspb(String pramHash){
        String tablename="TJBB_CX_CKTSSHSPQK";
        int ret = tlTjfxMapper.selectExistHashRecord(pramHash,tablename);
        return ret>0;
    }

    /**
     * 判断统计结果是否存在
     * @param pramHash
     * @param bbdm
     * @return
     */
    private boolean isExistHashRecord(String pramHash,String bbdm){
        String tablename="TJBB_DT_"+bbdm;
        //pramHash="TEMP-"+pramHash;
        int ret = tlTjfxMapper.selectExistHashRecord(pramHash,tablename);
        logger.info("判断统计结果是否存在,bbdm={}-hash={},是否存在={}"+bbdm,pramHash,(ret>0));
        return ret>0;
    }

    /**
     * 分大类商品出口数据统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01003(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                //计算明细数据的时候，pramHash前面会加上"TEMP-",方便在下面计算占比的时候会使用到带"TEMP-"前缀的pramHash，然后会更新不带前缀的paramHash
                tlTjfxMapper.insertInitD01003Data(mainDTO); //插入明细行数据
                //计算占比
                JsZbModel jsZbModel=new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01003");

                List<JsZbModel.ZbColumn> list=new ArrayList<>();
                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);

                JsZbModel.ZbColumn column2 = jsZbModel.new ZbColumn();
                column2.setUpdateColumn("ts_amt_zb");
                column2.setJsColumn("ts_amt");
                list.add(column2);
                jsZbModel.setZblist(list);

                //更新占比信息
                tlTjfxMapper.updateDynZbJs(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectD01003(pramHash);
        return retList;
    }

    /**
     * 出口贸易国家分布统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01004(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                if("1".equals(mainDTO.getCxtjDTO().getTjlx())){
                    tlTjfxMapper.insertInitD01004Data4Gb(mainDTO);
                }else{
                    tlTjfxMapper.insertInitD01004Data4Dq(mainDTO);
                }

                JsZbModel jsZbModel=new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01004");

                List<JsZbModel.ZbColumn> list=new ArrayList<>();
                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);
                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJs(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01004");

        return retList;
    }

    /**
     * 出口企业排名情况统计
     * @param mainDTO
     * @return
     */
    public List loadD01005(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                tlTjfxMapper.insertInitD01005Data(mainDTO);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }

            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        //commonUtils.setPageParam(mainDTO);
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01005");
        return retList;
    }

    /**
     * 出口商品退税率分布情况统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01006(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                tlTjfxMapper.deleteTempData(mainDTO);
                tlTjfxMapper.insertInitD01006Data(mainDTO);

                JsZbModel jsZbModel=new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01006");
                List<JsZbModel.ZbColumn> list=new ArrayList<>();

                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);
                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJs(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01006");
        return retList;
    }

    /**
     * 出口企业行业分布情况统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01007(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                tlTjfxMapper.insertInitD01007Data(mainDTO);

                //上级行业再次汇总
                tlTjfxMapper.insertInitHyD01007Data(mainDTO);

                JsZbModel jsZbModel=new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01007");

                List<JsZbModel.ZbColumn> list=new ArrayList<>();

                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);

                JsZbModel.ZbColumn column2 = jsZbModel.new ZbColumn();
                column2.setUpdateColumn("ts_amt_zb");
                column2.setJsColumn("ts_amt");
                list.add(column2);

                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJsD01007(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectD01007(pramHash);
        return retList;
    }

    /**
     * 出口海关分布情况统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01008(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList;
        String pramHash = mainDTO.getPramHash();
        if (!isExistHashRecord(pramHash, mainDTO.getBbdm())) {
            try {
                tlTjfxMapper.insertInitD01008Data(mainDTO);

                JsZbModel jsZbModel = new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01008");

                List<JsZbModel.ZbColumn> list = new ArrayList<>();

                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);

                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJs(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            } catch (Throwable e) {
                logger.error("初始化数据出错：", e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01008");
        return retList;
    }

    /**
     * 出口监管方式情况统计
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01009(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList;
        String pramHash = mainDTO.getPramHash();
        if (!isExistHashRecord(pramHash, mainDTO.getBbdm())) {
            try {
                tlTjfxMapper.insertInitD01009Data(mainDTO);

                JsZbModel jsZbModel = new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01009");
                List<JsZbModel.ZbColumn> list = new ArrayList<>();

                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("usd_amt_zb");
                column.setJsColumn("usd_amt");
                list.add(column);
                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJs(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            } catch (Throwable e) {
                logger.error("初始化数据出错：", e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01009");
        return retList;
    }

    /**
     * 外贸供货企业分析
     * @param mainDTO
     * @return
     */
    @Transactional
    public List loadD01010(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                tlTjfxMapper.insertInitD01010Data(mainDTO);

                //再次汇总上级行政区划
                tlTjfxMapper.insertInitSjXzqhD01010Data(mainDTO);

                JsZbModel jsZbModel=new JsZbModel();
                jsZbModel.setParamhash(pramHash);
                jsZbModel.setTablename("TJBB_DT_D01010");

                List<JsZbModel.ZbColumn> list=new ArrayList<>();
                JsZbModel.ZbColumn column = jsZbModel.new ZbColumn();
                column.setUpdateColumn("jhamt_zb");
                column.setJsColumn("jhamt");
                list.add(column);
                JsZbModel.ZbColumn column2 = jsZbModel.new ZbColumn();
                column2.setUpdateColumn("tse_zb");
                column2.setJsColumn("tse");
                list.add(column2);
                jsZbModel.setZblist(list);

                tlTjfxMapper.updateDynZbJsD01010(jsZbModel);
                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectD01010(pramHash);
        return retList;
    }

    /**
     * 出口退税审核审批表查询
     * @param mainDTO
     * @return
     */
    public List loadCX10001(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord4Shspb(pramHash)){
            try{
                String swjgDm = mainDTO.getCxtjDTO().getSwjgDm();
                String tjny = mainDTO.getCxtjDTO().getNy(); //需要统计的年月
                if(StringUtils.isBlank(tjny)){
                    throw new BusinessException("年月不能为空");
                }
                if(!StringUtils.isBlank(swjgDm)){
                    swjgDm = TlUtils.getPreSwjgdm(swjgDm);
                }else {
                    swjgDm = TlUtils.getPreSwjgdm(commonService.getQxdm());
                }

                //查询本月需要的年月，即传递过来月份的下一个月
                String byNy = DateUtilSelf.getNextYm(tjny.substring(0,4),tjny.substring(4,6));
                //查询本年累计需要的年月，即年初
                String bnljNy = tjny.substring(0,4) + "01";
                TjfxService proxy=(TjfxService) AopContext.currentProxy();
                ShspqkSaveDTO shspqkSaveDTO =  proxy.getShspqkSaveDto( mainDTO,swjgDm,pramHash,tjny,byNy,bnljNy);

                //写入数据
                tlTjfxMapper.insertShspb(shspqkSaveDTO);

                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("出口退税审核审批表查询出错：",e);
                throw new BusinessException("出口退税审核审批表查询报错");
            }
        }
        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectTjbbCxCktsshspqk(pramHash);
        return retList;
    }

    /**
     * 获取审核审批表保存的dto参数
     * @param mainDTO
     * @param swjgDm 税务机关代码
     * @param pramHash
     * @param tjny  统计年月
     * @param byNy 统计年月的下个月
     * @param bnljNy 统计年月的年初月
     * @return
     */
    @TargetDataSource(name= MultipleDataSourceHolder.SHXT)
    public ShspqkSaveDTO getShspqkSaveDto(TjfxMainDTO mainDTO,String swjgDm,String pramHash, String tjny,String byNy,String bnljNy){
        ShspqkSaveDTO shspqkSaveDTO = new ShspqkSaveDTO();

        //本月：查询已复审退税额、已核准退税额、已审批退税额、已退税税额
        List<Map<String,Object>> shspb4By1 = SnippetUtils.transformUpperCase4List(tlTjfxMapper.getShspb1(swjgDm, DateUtilSelf.strToDate(tjny,"yyyyMM"),DateUtilSelf.strToDate(byNy,"yyyyMM")));

        //本年累计：查询已复审退税额、已核准退税额、已审批退税额、已退税税额
        List<Map<String,Object>> shspb4Bnlj1 = SnippetUtils.transformUpperCase4List(tlTjfxMapper.getShspb1(swjgDm, DateUtilSelf.strToDate(bnljNy,"yyyyMM"),DateUtilSelf.strToDate(byNy,"yyyyMM")));


        //本月：当前待核准退税额（月份为当前月时进行只统计，其他月份不统计）
        List<Map<String,Object>> shspb4By2 = SnippetUtils.transformUpperCase4List(tlTjfxMapper.getShspb2(swjgDm));

        //当前待审批退税额、当前已审批未退税
        List<Map<String,Object>> shspb4By3 = SnippetUtils.transformUpperCase4List(tlTjfxMapper.getShspb3(swjgDm));

        //本月
        BigDecimal tseFh = BigDecimal.ZERO;
        BigDecimal tseHz = BigDecimal.ZERO;
        BigDecimal tseSp = BigDecimal.ZERO;
        BigDecimal tseKp = BigDecimal.ZERO;
        //本年累计
        BigDecimal ljtseFh = BigDecimal.ZERO;
        BigDecimal ljtseHz = BigDecimal.ZERO;
        BigDecimal ljtseSp = BigDecimal.ZERO;
        BigDecimal ljtseKp = BigDecimal.ZERO;
        BigDecimal dqdhztse = BigDecimal.ZERO;

        BigDecimal dqdsptse = BigDecimal.ZERO;
        BigDecimal dqdkptse = BigDecimal.ZERO;
        if(!CollectionUtils.isEmpty(shspb4By1)){
            for(Map<String,Object> map: shspb4By1){
                tseFh = tseFh.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_fh")));
                tseHz = tseHz.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_hz")));
                tseSp = tseSp.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_sp")));
                tseKp = tseKp.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_kp")));
            }
        }

        if(!CollectionUtils.isEmpty(shspb4Bnlj1)){
            for(Map<String,Object> map: shspb4Bnlj1){
                ljtseFh = ljtseFh.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_fh")));
                ljtseHz = ljtseHz.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_hz")));
                ljtseSp = ljtseSp.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_sp")));
                ljtseKp = ljtseKp.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_kp")));
            }
        }

        if(!CollectionUtils.isEmpty(shspb4By2)){
            for(Map<String,Object> map: shspb4By2){
                dqdhztse = dqdhztse.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_whz")));
            }
        }

        if(!CollectionUtils.isEmpty(shspb4By3)){
            for(Map<String,Object> map: shspb4By3){
                dqdsptse = dqdsptse.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_wsp")));
                dqdkptse = dqdkptse.add(TlCalculateUtils.nullToZero((BigDecimal) map.get("tse_wkp")));
            }
        }

        shspqkSaveDTO.setSwjgdm(mainDTO.getSwjgdm());
        shspqkSaveDTO.setParamhash(pramHash);
        shspqkSaveDTO.setBblc("0001");
        shspqkSaveDTO.setBqtse_fh(tseFh);
        shspqkSaveDTO.setBqtse_hz(tseHz);
        shspqkSaveDTO.setBqtse_sp(tseSp);
        shspqkSaveDTO.setBqtse_kp(tseKp);

        shspqkSaveDTO.setLjtse_fh(ljtseFh);
        shspqkSaveDTO.setLjtse_hz(ljtseHz);
        shspqkSaveDTO.setLjtse_sp(ljtseSp);
        shspqkSaveDTO.setLjtse_kp(ljtseKp);

        shspqkSaveDTO.setDqdhztse(dqdhztse);
        shspqkSaveDTO.setDqdsptse(dqdsptse);
        shspqkSaveDTO.setDqdkptse(dqdkptse);
       return  shspqkSaveDTO;
    }

    public List<WmGhqyMxVo> getWmghqymx(TjfxMainDTO mainDTO) {
        mainDTO.setSwjgdm(commonService.getCurrentUser().getSwjgDm());
        mainDTO.getCxtjDTO().setSwjgDm(commonService.getQxdm(mainDTO.getCxtjDTO().getSwjgDm()));

        String xzqh = mainDTO.getCxtjDTO().getXzqh();
        if(xzqh.length()==2){
            mainDTO.getCxtjDTO().setSjxzqh(xzqh.substring(0,2));
        }
        if(!mainDTO.isExport()){
            PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        }
        return tlTjfxMapper.getWmghqymx(mainDTO);
    }

    public List<String> getYears() {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        return tlTjfxMapper.getYears(swjgDm);
    }

    public List<String> getYears4TaskE01001(String swjgDm) {

        return tlTjfxMapper.getYears(swjgDm);
    }


    public List<String> getSwjddm4E01001() {

        return tlTjfxMapper.getSwjgdms4E01001();
    }



    public void initE01001(String ssny) {

        List<String> years = getYears();

        initBblc("E01001",ssny);

        String qxdm = commonService.getQxdm();
        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        initE01001Data(ssny,null,qxdm,swjgDm);

        for(int i=years.size()-1;i>=0;i--){
            String s = years.get(i);
            if(s.compareTo(ssny)>0){
                initE01001Data(s,null,qxdm,swjgDm);
                break; //只刷新后一年的数据
            }
        }
    }

    /**
     * 处理出口退税和外贸出口情况数据
     * 出口退税额：从金三系统取数逻辑 -likun -2020-05-21修改
     * 1、外贸出口额 -数据来源为用户输入(本方法不处理本月，处理上年同期)
     * 2、出口退税额 -数据来源为用户输入(本方法不处理本月，处理上年同期:注意数据会被后者覆盖)或者从金三系统获取(既处理本月，也处理上年同期)
     * 3、报关单出口额 -数据来源为tl_tssh下数据(既处理本月，也处理上年同期)
     * @param ssny  年度
     * @param selectMonth  具体每一个月
     * @param qxdm  权限代码
     * @param swjgdm 税务机关代码
     */
    public void initE01001Data(String ssny,Integer selectMonth,String qxdm,String swjgdm){

        InitBgdDataDTO initBgdDataDTO=new InitBgdDataDTO();
        initBgdDataDTO.setSsny(ssny);

        List<InitBgdDataDTO.Month> monthsList = new ArrayList<>();
        //符合查询出口退税额的month对象
        List<InitBgdDataDTO.MonthCktse> monthsCktseList = new ArrayList<>();
        Format f1 = new DecimalFormat("00");
        String lastSsny = (Integer.parseInt(ssny)-1)+"";//上年度
        String nextSsny = (Integer.parseInt(ssny)+1)+"";//下年度
        for(int i=1;i<=12;i++){
            if(selectMonth!=null && i!=selectMonth){
                continue;
            }

            String yue = f1.format(i);
            InitBgdDataDTO.Month month = initBgdDataDTO.new Month();
            month.setYue(yue);
            month.setMonth(TlConst.monthMap.get(i));
            monthsList.add(month);

            //组装符合查询出口退税额的month对象
            InitBgdDataDTO.MonthCktse monthCktse = initBgdDataDTO.new MonthCktse();
            monthCktse.setYue(yue);
            monthCktse.setMonth(TlConst.monthMap.get(i));
            //本月起，需要符合yyyy-MM-dd，例如如果查询2月，则为2020-02-01
            monthCktse.setByq(ssny + "-" + yue + "-01");
            //上年同期起，需要符合yyyy-MM-dd，例如如果查询2月，则为2019-02-01
            monthCktse.setSntqq(lastSsny + "-" + yue + "-01");
            if(i < 12){ //月份小于12月份
                //本月止，需要符合yyyy-MM-dd（使用下个月的1号，原因为数据库sql中，截止日期使用小于<）
                monthCktse.setByz(ssny + "-" + f1.format(i + 1) + "-01");
                //上年同期止，需要符合yyyy-MM-dd
                monthCktse.setSntqz(lastSsny + "-" + f1.format(i + 1) + "-01");
            }else{ //月份等于12月份
                //本月止，需要符合yyyy-MM-dd（使用下一年度的1月1号，例如如果查询2019年12月份，则截止时间为2020-01-01）
                monthCktse.setByz(nextSsny + "-" +"01-01");
                //上年同期止，需要符合yyyy-MM-dd
                monthCktse.setSntqz(ssny + "-" +"01-01");
            }
            monthsCktseList.add(monthCktse);
        }
        initBgdDataDTO.setMonths(monthsList);
        initBgdDataDTO.setMonthCktses(monthsCktseList);

        initBgdDataDTO.setQxdm(qxdm);
        initBgdDataDTO.setSwjgdm(swjgdm);
        initBgdDataDTO.setLastssny(lastSsny);

        Map map=new HashMap();
        map.put("swjgdm",initBgdDataDTO.getSwjgdm());
        map.put("qxdm",initBgdDataDTO.getQxdm());
        map.put("ssny",initBgdDataDTO.getSsny());
        map.put("lastssny",initBgdDataDTO.getLastssny());
        map.put("months",initBgdDataDTO.getMonths());
        //处理报关单出口额（美元）本月、上年同期; 外贸出口额（美元）-上期（数据来源为通览tl_tssh用户）
        tlTjfxMapper.updateBgdData(map);

        //处理出口退税额（元）本月、上年同期(数据来源为金三系统)  likun  2020-05-21
        try {
            //由于使用到金三系统，判断当前运行环境是否支持，如果不支持，直接返回
            if(!commonService.supportDb()){
                return;
            }
            TjfxService proxy=(TjfxService) AopContext.currentProxy();
            //map中加入符合查询出口退税额的month对象
            map.put("monthsCktse",initBgdDataDTO.getMonthCktses());
            //查询并更新出口退税额（元）本月数据
            proxy.selectAndUpdateE01001Cktse(map,"04");
            //查询并更新出口退税额（元）上年同期数据
            proxy.selectAndUpdateE01001Cktse(map,"05");
        }catch (Exception e){
            logger.error("出口退税和外贸出口情况-从金三系统获取并更新出口退税额出错-请求参数-{}-{}",map.toString(),e);
        }
    }

    /**
     * 统计分析 - 出口退税和外贸出口情况
     * 从金三系统查询出口退税额数据，然后更新该数据
     * @param map
     * @param bblc
     */
    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public void selectAndUpdateE01001Cktse(Map map,String bblc){
        //出口退税额List
        List<Map<String,Object>> cktseList = new ArrayList<>();
        //税务机关代码
        String swjgdm = (String)map.get("swjgdm");
        //所属年度
        String ssny = "";
        if(bblc.equals("04")){ //报表栏次为出口退税额(本月)
            //获取出口退税额数据(金三系统)
            cktseList = jsxtMapper.selectE01001Cktse(map);
            ssny = (String)map.get("ssny");
        }else{ //报表栏次为出口退税额(上年同期)
            //获取出口退税额数据上年同期数据(金三系统)
            cktseList = jsxtMapper.selectE01001Cktse4LastSsny(map);
            ssny = (String)map.get("lastssny");
        }
        //如果数据为空，返回
        if(CollectionUtils.isEmpty(cktseList)){
            return;
        }
        //map的key转为小写
        cktseList = SnippetUtils.transformUpperCase4List(cktseList);

        TjfxService proxy=(TjfxService) AopContext.currentProxy();
        Stream<Map<String,Object>> cktseStream = cktseList.stream();
        //循环更新TJBB_DT_E01001表中的月份字段的出口退税额
        Map updateMap = new HashMap();
        updateMap.put("bblc",bblc); //出口退税额的本月
        updateMap.put("swjgdm",swjgdm);
        updateMap.put("ssny",ssny);
        String finalSsny = ssny;
        cktseStream.forEach(item -> {
              String updateColumn = TlConst.monthMap.get(Integer.parseInt((String)item.get("yue")));
              BigDecimal  updateValue = (BigDecimal)item.get("cktse");
              updateMap.put("updateColumn",updateColumn); //例如Apr、Mar
              updateMap.put("updateValue",updateValue); //出口退税额
              proxy.updateE01001Cktse(updateMap);
              logger.info("出口退税和外贸出口情况-更新{}-{}-{}-{}-{}成功",swjgdm, finalSsny,(bblc.equals("04") ? "本月" : "上年同期"),updateColumn,updateValue);
        });
    }

    /**
     * 更新出口退税和外贸出口情况出口退税额数据
     * @param updateMap
     */
    @TargetDataSource(name = MultipleDataSourceHolder.SHZS)
    public void updateE01001Cktse(Map updateMap ){
        tlTjfxMapper.updateE01001Cktse(updateMap);
    }

    private void initBblc(String bbdm,String ssny){

        List<String> years = getYears();
        for(String year:years){
            if(year.equals(ssny)){
                throw new BusinessException("当前新增统计年份【"+ssny+"】已存在!");
            }
        }

        TlUserProfile currentUser = commonService.getCurrentUser();

        List<TjbbBaseColumnVo> baseColumnVos=new ArrayList<>();

        TjbbLineItemModel itemModel=new TjbbLineItemModel();
        itemModel.setBbdm(bbdm);
        itemModel.setQybj("Y");

        //获取指标代码表
        List<TjbbLineItemModel> itemModels = tjbbLineItemModelMapper.select(itemModel);
        for(TjbbLineItemModel lineItemModel:itemModels){
            TjbbBaseColumnVo columnVo=new TjbbBaseColumnVo();
            columnVo.setBblc(lineItemModel.getBblc());
            columnVo.setSwjgdm(currentUser.getSwjgDm());
            columnVo.setSsny(ssny);
            baseColumnVos.add(columnVo);
        }

        String fname="TJBB_DT_"+bbdm;

        Map parmMap=new HashMap();
        parmMap.put("fname",fname);
        parmMap.put("baseColumnVos",baseColumnVos);
        tlTjbbMapper.insertInitTjbbLine(parmMap);
    }

    /**
     * 出口退税基本情况统计
     * @param mainDTO
     * @return
     */
    public List loadD01002(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel) {
        List retList ;
        String pramHash = mainDTO.getPramHash();
        if(!isExistHashRecord(pramHash,mainDTO.getBbdm())){
            try{
                tlTjfxMapper.insertInitD01002Data(mainDTO); //插入明细行数据
/**
 * 这个查询的时候，由于生成免抵比的地方数据源不适用了，所以报错。暂时先吧生成免抵比的这一段注释掉
 * By 2025.1.14 严工
 */
//                if(mainDTO.isHaveSc()){
//                    Map<String,Object> dataMap=new HashMap();
//                    try{
//                        commonService.changeDataSource(MultipleDataSourceHolder.SHXT);
//                        dataMap = tlTjfxMapper.selectMdbzData(mainDTO);
//
//                    }finally {
//                        commonService.clearDBType();
//                    }
//                    dataMap.put("swjgdm",mainDTO.getSwjgdm());
//                    dataMap.put("pramHash",mainDTO.getPramHash());
//                    tlTjfxMapper.insertInitD01002Data4Mdbz(dataMap);
//                }

                //设置异步处理任务-刷新标志为ture
                if(!isExportExcel){
                    rwglYbclDTO.setFreshFlag(true);
                }
            }catch (Throwable e){
                logger.error("初始化数据出错：",e);
                throw new BusinessException("数据初始化报错");
            }
        }

        PageHelper.startPage(mainDTO.getPageNo(), mainDTO.getPageSize());
        retList=tlTjfxMapper.selectDyncTableData(pramHash,"TJBB_DT_D01002");
        return retList;
    }

    public void delTjfxDataTask() {

        TjbbReportModel p=new TjbbReportModel();
        p.setBbdldm("D01");
        List<TjbbReportModel> select = tjbbReportModelMapper.select(p);
        for(TjbbReportModel tjbbReportModel:select){
            if(!tjbbReportModel.getBbdm().startsWith("D01")){
                continue;
            }
            Map pramMap=new HashMap();
            pramMap.put("tablename",tjbbReportModel.getFname());
            tlTjbbMapper.deleteTjfxData(pramMap);
        }
    }

    /**
     * 添加任务管理前置服务
     * 1、参数初始化
     * 2、(非excel导出时) 调用任务管理前置服务具体逻辑
     * @param mainDTO
     */
    public void addBeforeService(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel){
        //企业类型
        List<String> qylx = mainDTO.getCxtjDTO().getQylx();
        if(qylx==null){
            qylx=new ArrayList<>();
        }
        //为企业类型赋值
        for(String obj:qylx){
            if(obj.equals(TlConst.QYLX_JC_SC)){
                mainDTO.setHaveSc(true);
            }else if(obj.equals(TlConst.QYLX_JC_WM)){
                mainDTO.setHaveWm(true);
            }else if(obj.equals(TlConst.QYLX_JC_WZF)){
                mainDTO.setHaveWzf(true);
            }
        }
        //国别代码赋值
        if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getGbcode())){
            mainDTO.setHaveGbcode(true);
        }
        if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getSpmlcode())){
            mainDTO.setHaveSpmlcode(true);
        }
        //退税率代码赋值
        if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getTslcode())){
            mainDTO.setHaveTslcode(true);
        }
        //地区代码赋值
        if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getDqcode())){
            mainDTO.setHaveDqcode(true);
        }

        int pageNo = mainDTO.getPageNo();
        int pageSize = mainDTO.getPageSize();
        mainDTO.setPageNo(0); //暂时设置成一样避免分页重新初始化数据，待Hash接收再设置回去。
        mainDTO.setPageSize(0);
        String pramHash = getCurUserPramHash(mainDTO); //计算hash
        mainDTO.setPramHash(pramHash);

        if(isExportExcel){ //导出excel时,设置pageno和pagesize
            mainDTO.setPageNo(1);
            mainDTO.setPageSize(PageRowBounds.NO_ROW_LIMIT);
        }else{//非excel导出时，执行异步处理任务模式
            //重新设置pageno和pagesize
            mainDTO.setPageNo(pageNo);
            mainDTO.setPageSize(pageSize);

            //增加任务管理前置服务
            rwglYbclDTO.setCode(mainDTO.getBbdm()); //任务代码
            rwglYbclDTO.setRwhash(pramHash); //任务的hash
            rwglYbclDTO.setRwbw(GsonUtils.getDefaultGson().toJson(mainDTO));
            String userRefresh = mainDTO.getCxtjDTO().getRefresh(); //用户点击重新统计标志（Y/N）
            if(StringUtils.isBlank(userRefresh)){
                userRefresh = TlConst.SF4NO;
            }
            //调用任务管理前置服务具体逻辑
            addBeforeServiceCommon(rwglYbclDTO,userRefresh);
        }
    }

    /**
     * 通用的前置服务，创建任务
     * @param dto
     * @param userRefresh  用户点击重新统计标志（Y/N）
     */
    public void addBeforeServiceCommon(RwglYbclAfterDTO dto,String userRefresh){
        RwglYbclBeforeDTO rwglYbclBeforeDTO = new RwglYbclBeforeDTO();
        rwglYbclBeforeDTO.setRwlx(RwglYbclEnum.valueOf(dto.getCode()).getRwlx());
        rwglYbclBeforeDTO.setRwhash(dto.getRwhash());
        rwglYbclBeforeDTO.setRwms(RwglYbclEnum.valueOf(dto.getCode()).getRwms());
        rwglYbclBeforeDTO.setRwbw(dto.getRwbw());
        rwglYbclBeforeDTO.setUserRefresh(userRefresh);
        rwglYbclService.beforeServerExecutor(rwglYbclBeforeDTO);
    }

    /**
     * 查询统计任务列表
     * @param tjrwDTO
     * @return
     */
    public List<TjrwListVO> tjrwList(TjrwDTO tjrwDTO){
        if (StringUtils.isBlank(tjrwDTO.getSwjg())){
            tjrwDTO.setSwjg(TlUtils.getPreSwjgdm(commonService.getQxdm()));
        }else {
            tjrwDTO.setSwjg(TlUtils.getPreSwjgdm(tjrwDTO.getSwjg()));

        }
        List<TjrwListVO> list = tlTjbbMapper.selectTjrwList(tjrwDTO);
        list.forEach(item -> {
            TjfxMainDTO mainDTO = GsonUtils.getDefaultGson().fromJson(item.getTjtj(),TjfxMainDTO.class);
            item.setTjlx(mainDTO.getBbdm());
            item.setTjlxMc(RwglYbclEnum.valueOf(mainDTO.getBbdm()).getRwms());
            item.setTjtjMc(item.getTjtj());
        });
        return  list;
    }

    /**
     * 删除统计任务
     * @param rwlx  任务类型
     * @param rwhash  任务hash
     */
    @Transactional
    public void tjrwDelete(String rwlx,String rwhash){
        tlTjbbMapper.deleteTjrw(rwlx,rwhash);
    }

}
