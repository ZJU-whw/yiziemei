package com.tl.web.bjts.shzs.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.tl.common.ext.utils.GsonUtils;
import com.tl.common.ext.utils.TlBeanUtils;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.*;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.domain.*;
import com.tl.web.bjts.shzs.model.dto.BaseIdsDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxCreateDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxCreateParam;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxUpdateDTO;
import com.tl.web.bjts.shzs.model.dto.sbxx.SbMxbBaseDTO;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.sbxx.*;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import com.tl.web.bjts.shzs.utils.SnippetUtils;
import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.*;

/**
 * @Author Mamf
 * @create 2017/6/19 16:49
 */
@Service
public class SbxxhzServiceImpl implements SbxxhzService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SbxxhzServiceImpl.class);

    private static final DecimalFormat SBNO_DECIMAL_FORMAT_8 = new DecimalFormat(
            "00000000"); // 申报表序号数值格式化(8位)。
    /**
     *  支持通过预警类型进入到申报明细表的数组
     *  101   新增出口商品
     *  102	新增供货商
     *  104   货源地不一致
     *  105	商品名称不一致
     *  107	异常供货商
     *  108	敏感出口商品
     *  109	敏感口岸(外贸)
     *  110	敏感口岸(生产)
     *  111	供货企业异常函调
     *  112	申报与出口口岸不一致
     */
    protected static final String[] YJ_TYPE_IN_SBMX_ARR = {"101","102","104","105","107","108","109","110","111","112","120","121","161","162","163","164"};

    @Autowired
    private TlMyMapper mapper;
    @Autowired
    TlLinkedMapper linkedMapperMapper;
    @Autowired
    TlShSbxxHzProfileMapper shSbxxHzProfileMapper;
    @Autowired
    TlRwTxbMapper rwTxbMapper;
    @Autowired
    TlUserProfileMapper tlUserProfileMapper;
    @Autowired
    TlJsxtMapper jsxtMapper;
    @Autowired
    CommonServiceImpl commonService;
    @Autowired
    DictCacheMapper dictCacheMapper;
    @Autowired
    IInspectService inspectService;
    @Autowired
    private FxnkNbfxdmxSzProfileMapper szMapper;
    @Autowired
    private FxnkZjBjtsSzProfileMapper zjBjtsSzMapper;
    @Autowired
    RulesMainProfileMapper rulesMainProfileMapper;
    @Autowired
    RulesMxProfileMapper rulesMxProfileMapper;
    @Autowired
    AppProperties appProperties;

    @Override
    public List<Map<String, Object>> getGroupBySbxxList(String czryDm) {
        List<Map<String, Object>> rtList=new ArrayList<>();
        List<Map<String, Object>> dataList = linkedMapperMapper.getSbywxx(czryDm);

        Map<String,Object> tempMap=new HashMap<>();

        Map<String, Object> retMap=null;
        List<Map> retList;
        for(Map<String,Object> dataMap:dataList){

            String ywzlDm=(String)dataMap.get("YWZLDM");
            if(tempMap.containsKey(ywzlDm)){
                retMap=(Map)tempMap.get(ywzlDm);
                retMap.put("num",numAdd((String)retMap.get("num"),(BigDecimal)dataMap.get("NUM")));
                retMap.put("cqcnt",numAdd((String)retMap.get("cqcnt"),(BigDecimal)dataMap.get("CQCNT")));
            }else{
                retMap=new HashMap<>();
                retMap.put("num",numAdd("0",(BigDecimal)dataMap.get("NUM")));
                retMap.put("cqcnt",numAdd("0",(BigDecimal)dataMap.get("CQCNT")));
                retMap.put("ywzlDm",dataMap.get("YWZLDM"));
                retMap.put("ywzlMc",dataMap.get("YWZLMC"));
                rtList.add(retMap);
            }

            if(retMap.containsKey("details")){
                retList=(List)retMap.get("details");
            }else{
                retList=new ArrayList();
            }

            if(dataMap.get("SBYWDM")!=null){
                Map detail=new HashMap();
                detail.put("num",dataMap.get("NUM"));
                detail.put("cqcnt",dataMap.get("CQCNT"));
                detail.put("sbywDm",dataMap.get("SBYWDM"));
                detail.put("sbywMc",dataMap.get("SBYWMC"));
                retList.add(detail);
            }

            tempMap.put(ywzlDm,retMap);
            retMap.put("details",retList);

        }

        return rtList;
    }

    private String numAdd(String num,BigDecimal obj){
        BigDecimal totalAmount = null;
        if(StringUtils.isBlank(num)){
            totalAmount=new BigDecimal("0");
        }else{
            totalAmount=new BigDecimal(num);
        }
        totalAmount=totalAmount.add(obj);
        return totalAmount.toString();
    }

    @Override
    public Map<String, Object> getSblbxxByPage(String czryDm, String sbywDm, int offset, int size,String type,String cons,
                                               String isZzsbb,String orderSql,String flglcd) {

        Map<String, Object> retMap=new HashMap<>();

        Map<String,Object> paramMap=new HashMap<>();

        StringBuffer sqls=new StringBuffer("  1=1 ");
        if(StringUtils.isNotBlank(cons)){
            sqls.append("and ").append(type).append(" like '%").append(cons).append("%'");
        }

        // 拼接分类管理 相关的查询条件
        if(flglcd.length()==1) { //传递值是 A B C D
            sqls.append(" and ").append(" FLGLCD in ('")
                    .append(flglcd).append("')");
        }else if(flglcd.length()==2){
            sqls.append(" and ").append(" FLGLCD in ('")
                    .append(flglcd.substring(0,1)).append("', '")
                    .append(flglcd.substring(1,2)).append("')");
        }


        /**
         * 获取总数，从申报汇总函数中获取
         * 根据申报业务代码查找出对应的申报数
         */
        List<Map<String, Object>> dataSbhzList = linkedMapperMapper.getSbywxx(czryDm);
        // 返回总数
        Integer total = 0;
        if(!CollectionUtils.isEmpty(dataSbhzList)){
            for(Map<String,Object> dataMap : dataSbhzList){
                String sbywdmHz=(String)dataMap.get("SBYWDM");
                if (StringUtils.isBlank(sbywdmHz)){
                    continue;
                }
                if (sbywdmHz.equals(sbywDm)){
                    total = ((BigDecimal)dataMap.get("NUM")).intValue();
                    break;
                }
            }
        }
        LOGGER.info("czryDm={}-获取申报列表总数={}",czryDm,total);
        paramMap.put("czryDm",czryDm);
        paramMap.put("sbywDm",sbywDm);
        paramMap.put("type",sqls.toString());
        paramMap.put("offset",offset);
        paramMap.put("size",size);
        paramMap.put("orderSql",orderSql);
        LOGGER.info("czryDm={}-获取申报列表查询参数={}",czryDm,paramMap.toString());
        List<TlSbxxProfile> dataList = linkedMapperMapper.getSblbxxByPage(paramMap);

        retMap.put("total",total);
        retMap.put("offset",offset);
        retMap.put("size",size);
        retMap.put("sbyws",dataList);

        return  retMap;
    }

    @Override
    public List<TlSbxxProfile> getSbxxDetails(Long sbid) {
        return linkedMapperMapper.getSbxxDetails(sbid);
    }

    @Override
    public SbxxViewVo getSbxxDetails2(String lcslid) {

        int sbcs=0;

        List<String> ywjktxs = new ArrayList<>();

        SbxxViewVo sbxxViewVo;
        try {
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            sbxxViewVo = jsxtMapper.getSbxxDetail(lcslid);
            if (sbxxViewVo==null){
                return  null;
            }else {
                sbxxViewVo.setYwjktx(ywjktxs);
            }

            sbcs = jsxtMapper.countSbcs(lcslid);
            int resultCnt = jsxtMapper.selectScsbWcqk(lcslid);
            if(resultCnt>0){
                ywjktxs.add("该企业首次申报尚未完成。");
            }
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

        //增加企业关注信息返回
        String qygzxx = linkedMapperMapper.selectQygzxx(sbxxViewVo.getDjxh());
        if(StringUtils.isNotBlank(qygzxx)){
            ywjktxs.add(qygzxx);
        }

        //便捷退税数据源：补充联系人、联系电话、企业分组名称、税务机关名称、标签
        SbxxViewVo lxrxxVo = linkedMapperMapper.queryLxrxx(sbxxViewVo.getNsrsbh());
        if(lxrxxVo!=null){
            sbxxViewVo.setLxr(lxrxxVo.getLxr());
            sbxxViewVo.setLxrdh(lxrxxVo.getLxrdh());
            sbxxViewVo.setZsswjgMc(lxrxxVo.getZsswjgMc());
            sbxxViewVo.setSwjgMc(lxrxxVo.getSwjgMc());
            sbxxViewVo.setTag(lxrxxVo.getTag());
        }

        sbxxViewVo.setSbid(0L);
        sbxxViewVo.setSbcs(sbcs);
        sbxxViewVo.setSbztDm("30");

        /**
         *  如果乡镇街道为空，从则金三系统中获取，并写入到便捷退税中
         */
        if (StringUtils.isBlank(sbxxViewVo.getJdxzmc())){
            Map<String,String> paramp=new HashMap<>();
            LOGGER.info("查询乡镇街道信息-取金三数据库 查询条件 nsrsbh{}",sbxxViewVo.getNsrsbh());
            paramp.put("nsrsbh",sbxxViewVo.getNsrsbh());
            paramp.put("shxydm",sbxxViewVo.getNsrsbh());

            String jdxzmc=getXzjdFormJsxt(paramp);
            LOGGER.info("查询乡镇街道信息-取金三数据库 取得结果 jdxzmc{}",jdxzmc);
            if (jdxzmc==null) {
                paramp.put("jdxzmc", "");
                sbxxViewVo.setJdxzmc("");
            }else {
                paramp.put("jdxzmc",jdxzmc);
                sbxxViewVo.setJdxzmc(jdxzmc);
            }
            linkedMapperMapper.updateJdxzmc(paramp);
        }

        /**
         *  处理无纸化备案标志
         */
        Map edocApplyMap = linkedMapperMapper.getEdocApplyByNsrsbh(sbxxViewVo.getNsrsbh());
        if (edocApplyMap == null || edocApplyMap.isEmpty()){
            sbxxViewVo.setWzhba(ConstUtil.WHETHER_NO_CN);
        } else {
            sbxxViewVo.setWzhba(ConstUtil.WHETHER_YES_CN);
            sbxxViewVo.setLxrBa((String)edocApplyMap.get("CONCACTS"));
            sbxxViewVo.setLxrdhBa((String)edocApplyMap.get("TEL"));
        }
        return sbxxViewVo;
    }

    @Override
    public List<RwtxVo> getRwtxList(Map<String,String> paramMap) {
        String offset=paramMap.get("offset");
        String size=paramMap.get("size");
        if(StringUtils.isNotBlank(offset)&&StringUtils.isNotBlank(size)){
            String start=offset;
            int temp=Integer.parseInt(offset)+Integer.parseInt(size)-1;
            String end=Integer.valueOf(temp)+"";
            paramMap.put("start",start);
            paramMap.put("end",end);
        }

        return linkedMapperMapper.getRwtxList(paramMap);
    }

    @Override
    public int getRwtxListCount(Map<String,String> paramMap) {
        return linkedMapperMapper.getRwtxListCount(paramMap);
    }

    @Override
    @Transactional(rollbackFor = BusinessException.class)
    public int addRwtxb(TlRwTxb rwTxb) {
        int ret=0;
        Long id=commonService.getDBPk("RW_RWTXB");
        rwTxb.setId(id);
        try {
            ret=rwTxbMapper.insertSelective(rwTxb);
            TlUserProfile user=new TlUserProfile();
            user.setCzryDm(rwTxb.getSwryDm());
            user.setLxdh(rwTxb.getLxdh());
            tlUserProfileMapper.updateByPrimaryKeySelective(user);
            insertDtbsj(rwTxb.getId(),"RW_RWTXBToYun");
        } catch (Exception e) {
            LOGGER.error("任务提醒新增插入异常",e);
            throw new BusinessException(BusinessMsgCons.SERVICE_SBXXHZ_RWTXPK);
        }
        return ret;
    }

    @Override
    public BigDecimal getNsrdzdah(Long sbid) {
        TlShSbxxHzProfile profile = shSbxxHzProfileMapper.selectByPrimaryKey(sbid);
        if(profile!=null&&profile.getNsrdzdah()!=null){
            return profile.getNsrdzdah();
        }else {
            return null;
        }
    }

    @Override
    public JdfwmsVo getJdfwms(String czryDm) {
        JdfwmsVo jdfwmsVo = new JdfwmsVo();
        jdfwmsVo.setCzryDm(czryDm);
        mapper.getJdfwms(jdfwmsVo);
        return jdfwmsVo;
    }

    @Override
    public int updateSbztTO2A(BaseIdsDTO dto) {
        int ret=0;
        Long [] ids=dto.getIds();
        LOGGER.info("转自动接单业务笔数 -{}",ids.length);
        for (int i=0;i<ids.length;i++){
            int var1=  mapper.updateSbztTO2A(ids[i]);
            ret=ret+var1;
        }
        LOGGER.info("转自动接单成功业务笔数 -{}",ret);
        return ret;
    }

    @Override
    public List<SbMdtsMxbVO> listScmdtsMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageScmdtDto(dto);

        List<SbMdtsMxbVO> retList;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            retList = linkedMapperMapper.listScmdtsMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

        /**
         *  1、处理字典表，代码转中文
         *  2、如果存在代理证明号，则从金三系统中根据20位代理证明号获取21位报关单号
         */
        if (!CollectionUtils.isEmpty(retList)){
            // 根据sbid查询登记序号
            String djxh = dto.getYwblxxVo().getDjxh();
            for (SbMdtsMxbVO item : retList){
                commonService.convertCode2Name(item);
                String ckbgdh = item.getCkbgdh();
                String dlzmh = item.getDlzmh();
                if (StringUtils.isNotBlank(ckbgdh)){
                    continue;
                }
                if (StringUtils.isNotBlank(dlzmh)){
                    ckbgdh = getCkbgdhByDlzmhFromJsxt(djxh,dlzmh);
                    if (StringUtils.isNotBlank(ckbgdh)){
                        item.setCkbgdh(ckbgdh);
                    }
                }
            }
        }
        return retList;
    }

    @Override
    public SbMdtsMxbSumVO sumScmdtsMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageScmdtDto(dto);

        // 查询合计信息
        SbMdtsMxbSumVO sumData;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            sumData = linkedMapperMapper.sumScmdtsMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

        return sumData;
    }

    /**
     *  封装生产免抵退查询明细dto
     * @param dto
     */
    public  void packageScmdtDto(SbMxbBaseDTO dto){
        /**
         * 对申报序号进行处理
         */
        if (StringUtils.isNotBlank(dto.getSbxh())){
            if (!TlUtils.isNumeric(dto.getSbxh())){
                throw new BusinessException("查询条件中申报序号不能为非数字!");
            }
            dto.setSbxh(getSbno_8(Integer.valueOf(dto.getSbxh())));
        }

        // 查询类型
        String queryType = dto.getQueryType();

        /**
         *  根据查询类型，重新组装请求参数
         *  从疑点信息页面进入,
         */
        if (ConstUtil.QUERYTYPE_YDXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYdxxDTO> ydxxDTOS = dto.getYdxx();
            if (CollectionUtils.isEmpty(ydxxDTOS)){
                throw new BusinessException("疑点信息参数不能为空");
            }
            // 据疑点信息数据，经过处理加入到申报明细查询请求
            addSbMxbBaseDTOViaYd(dto,ydxxDTOS,ConstUtil.SBYWB_SCMDT);
        } else if (ConstUtil.QUERYTYPE_YJXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYjxxDTO> yjxxDTOS = dto.getYjxx();
            if (CollectionUtils.isEmpty(yjxxDTOS)){
                throw new BusinessException("预警信息参数不能为空");
            }
            /**
             * 校正预警信息,传递的预警信息类型只有特定类型才参与过滤查询
             */
            List<SbMxbBaseDTO.SbMxbYjxxDTO> targetYjxxDTOS = correctSbMxbBaseDTOViaYj(yjxxDTOS);
            if (CollectionUtils.isEmpty(targetYjxxDTOS)){
                throw new BusinessException("选择的预警类型不支持查询申报明细");
            }
            dto.setYjxx(targetYjxxDTOS);
        }
        dto.setSbywdm(ConstUtil.SBYWB_SCMDT);
    }

    @Override
    public List listWmmtsMxb(SbMxbBaseDTO dto) {

        Page page=null;
        // 封装dto
        packageWmmtsDto(dto);
        // 查询列表数据
        List<SbMtsCkmxVO> retList;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
            retList = linkedMapperMapper.listWmmtsMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

        /**
         *  其他处理
         *  1、处理字典表，代码转中文
         *  2、根据sbid+glh加入进货明细列表
         *  3、如果存在代理证明号，则从金三系统中根据20位代理证明号获取21位报关单号
         */
        if (!CollectionUtils.isEmpty(retList)){
            // 根据sbid查询登记序号
            String djxh = dto.getYwblxxVo().getDjxh();
            // 获取供货方纳税人税号
            String ghfnsrsbh = dto.getGhfnsrsbh();
            if (StringUtils.isBlank(ghfnsrsbh) && !CollectionUtils.isEmpty(dto.getYjxx())) {
                SbMxbBaseDTO.SbMxbYjxxDTO yjxxDTO = dto.getYjxx().get(0);
                /**
                 * 102  新增供货商
                 * 107  异常供货商
                 * 111	供货企业异常函调
                 */
                if (Objects.equals("102", yjxxDTO.getYjType()) ||
                        Objects.equals("107", yjxxDTO.getYjType()) ||
                        Objects.equals("111", yjxxDTO.getYjType())) {
                    ghfnsrsbh = yjxxDTO.getYjObject();
                }
            }

            Map<String,SbMtsCkmxVO> maps = new LinkedHashMap<>();
            Map<String,List<SbMtsJhmxVO>> mapsJhmx = new LinkedHashMap<>();
            for (SbMtsCkmxVO item : retList) {
                if(!maps.containsKey(item.getGlh())){
                    maps.put(item.getGlh(),item);
                }
                /**
                 *  存在从预警页面(新增供货商)，从进货明细中查询数据时需要加上供货方税号的条件,解决相同关联号下有多个供货方税号的问题
                 */
                if(StringUtils.isEmpty(ghfnsrsbh) || ghfnsrsbh.equals(item.getGhfnsrsbh())){
                    SbMtsJhmxVO mtsJhmxVO = new SbMtsJhmxVO();
                    TlBeanUtils.copyPropertiesIgnoreNull(item,mtsJhmxVO);
                    mtsJhmxVO.setSbxh(item.getSbxhJh());

                    String key = item.getGlh();
                    if(!mapsJhmx.containsKey(key)){
                        List<SbMtsJhmxVO> list = new ArrayList<>();
                        list.add(mtsJhmxVO);
                        mapsJhmx.put(key,list);
                    }else {
                        mapsJhmx.get(key).add(mtsJhmxVO);
                    }
                }
            }

            page = (Page)retList;
            List pagelist = page.toPageInfo().getList();
            pagelist.clear();

            for (String glh : maps.keySet()){

                List<SbMtsJhmxVO> sbMtsJhmxVOS = mapsJhmx.get(glh);

                SbMtsCkmxVO sbMtsCkmxVO = maps.get(glh);
                sbMtsCkmxVO.setJhmx(sbMtsJhmxVOS);

                commonService.convertCode2Name(sbMtsCkmxVO);
                pagelist.add(sbMtsCkmxVO);

                String ckbgdh = sbMtsCkmxVO.getCkbgdh();
                String dlzmh = sbMtsCkmxVO.getDlzmh();
                if (StringUtils.isNotBlank(ckbgdh)){
                    continue;
                }
                if (StringUtils.isNotBlank(dlzmh)){
                    ckbgdh = getCkbgdhByDlzmhFromJsxt(djxh,dlzmh);
                    if (StringUtils.isNotBlank(ckbgdh)){
                        sbMtsCkmxVO.setCkbgdh(ckbgdh);
                    }
                }
            }
        }
        return page;
    }


    @Override
    public SbMtsMxbSumVO sumWmmtsMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageWmmtsDto(dto);
        // 查询合计信息
        SbMtsMxbSumVO sumData;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            sumData = linkedMapperMapper.sumWmmtsMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return sumData;
    }

    /**
     *  封装外贸免退退查询明细dto
     * @param dto
     */
    public  void packageWmmtsDto(SbMxbBaseDTO dto){
        // 查询类型
        String queryType = dto.getQueryType();

        /**
         *  根据查询类型，重新组装请求参数
         *  从疑点信息页面进入,
         */
        if (ConstUtil.QUERYTYPE_YDXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYdxxDTO> ydxxDTOS = dto.getYdxx();
            if (CollectionUtils.isEmpty(ydxxDTOS)){
                throw new BusinessException("疑点信息参数不能为空");
            }
            // 据疑点信息数据，经过处理加入到申报明细查询请求
            addSbMxbBaseDTOViaYd(dto,ydxxDTOS,ConstUtil.SBYWB_WMMTS);
        } else if (ConstUtil.QUERYTYPE_YJXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYjxxDTO> yjxxDTOS = dto.getYjxx();
            if (CollectionUtils.isEmpty(yjxxDTOS)){
                throw new BusinessException("预警信息参数不能为空");
            }
            /**
             * 校正预警信息,传递的预警信息类型只有特定类型才参与过滤查询
             */
            List<SbMxbBaseDTO.SbMxbYjxxDTO> targetYjxxDTOS = correctSbMxbBaseDTOViaYj(yjxxDTOS);
            if (CollectionUtils.isEmpty(targetYjxxDTOS)){
                throw new BusinessException("选择的预警类型不支持查询申报明细");
            }
            dto.setYjxx(targetYjxxDTOS);
        }
        dto.setSbywdm(ConstUtil.SBYWB_WMMTS);
    }


    @Override
    public List<SbWzfdbtsMxbVO> listWzfdbts(SbMxbBaseDTO dto) {
        // 封装dto
        packageWzfdbtsDto(dto);
        // 查询明细数据
        List<SbWzfdbtsMxbVO> retList;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            retList = linkedMapperMapper.listWzfdbts(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        /**
         *  其他处理
         *  1、处理字典表，代码转中文
         */
        if (!CollectionUtils.isEmpty(retList)){
            for (SbWzfdbtsMxbVO item : retList){
                commonService.convertCode2Name(item);
            }
        }
        return retList;
    }

    @Override
    public SbWzfdbtsMxbSumVO sumWzfdbtsMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageWzfdbtsDto(dto);
        // 查询合计数据
        SbWzfdbtsMxbSumVO sumData;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            sumData = linkedMapperMapper.sumWzfdbtsMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return sumData;
    }

    /**
     *  封装外综服代办退税查询明细dto
     * @param dto
     */
    public void packageWzfdbtsDto(SbMxbBaseDTO dto){
        /**
         * 对申报序号进行处理
         */
        if (StringUtils.isNotBlank(dto.getSbxh())){
            if (!TlUtils.isNumeric(dto.getSbxh())){
                throw new BusinessException("查询条件中申报序号不能为非数字!");
            }
            dto.setSbxh(getSbno_8(Integer.valueOf(dto.getSbxh())));
        }

        // 查询类型
        String queryType = dto.getQueryType();

        /**
         *  根据查询类型，重新组装请求参数
         *  从疑点信息页面进入,
         */
        if (ConstUtil.QUERYTYPE_YDXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYdxxDTO> ydxxDTOS = dto.getYdxx();
            if (CollectionUtils.isEmpty(ydxxDTOS)){
                throw new BusinessException("疑点信息参数不能为空");
            }
            // 据疑点信息数据，经过处理加入到申报明细查询请求
            addSbMxbBaseDTOViaYd(dto,ydxxDTOS,ConstUtil.SBYWB_SCMDT);
        } else if (ConstUtil.QUERYTYPE_YJXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYjxxDTO> yjxxDTOS = dto.getYjxx();
            if (CollectionUtils.isEmpty(yjxxDTOS)){
                throw new BusinessException("预警信息参数不能为空");
            }
            /**
             * 校正预警信息,传递的预警信息类型只有特定类型才参与过滤查询
             */
            List<SbMxbBaseDTO.SbMxbYjxxDTO> targetYjxxDTOS = correctSbMxbBaseDTOViaYj(yjxxDTOS);
            if (CollectionUtils.isEmpty(targetYjxxDTOS)){
                throw new BusinessException("选择的预警类型不支持查询申报明细");
            }
            dto.setYjxx(targetYjxxDTOS);
        }
        dto.setSbywdm(ConstUtil.SBYWB_WZFDBTS);
    }

    @Override
    public List<SbGjzyhwMxbVO> listGjzyhwMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageGjzyhwDto(dto);
        // 查询明细数据
        List<SbGjzyhwMxbVO> retList;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            retList = linkedMapperMapper.listGjzyhwMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        /**
         *  其他处理
         *  1、处理字典表，代码转中文
         */
        if (!CollectionUtils.isEmpty(retList)){
            for (SbGjzyhwMxbVO item : retList){
                commonService.convertCode2Name(item);
            }
        }
        return retList;
    }

    @Override
    public SbGjzyhwMxbSumVO sumGjzyhwMxb(SbMxbBaseDTO dto) {
        // 封装dto
        packageGjzyhwDto(dto);
        // 查询合计数据
        SbGjzyhwMxbSumVO sumData;
        try {
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            sumData = linkedMapperMapper.sumGjzyhwMxb(dto);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return sumData;
    }

    /**
     *  封装购进自用货物查询明细dto
     * @param dto
     */
    public void packageGjzyhwDto(SbMxbBaseDTO dto){
        /**
         * 对申报序号进行处理
         */
        if (StringUtils.isNotBlank(dto.getSbxh())){
            if (!TlUtils.isNumeric(dto.getSbxh())){
                throw new BusinessException("查询条件中申报序号不能为非数字!");
            }
            dto.setSbxh(getSbno_8(Integer.valueOf(dto.getSbxh())));
        }

        // 查询类型
        String queryType = dto.getQueryType();

        /**
         *  根据查询类型，重新组装请求参数
         *  从疑点信息页面进入,
         */
        if (ConstUtil.QUERYTYPE_YDXX.equals(queryType)){
            List<SbMxbBaseDTO.SbMxbYdxxDTO> ydxxDTOS = dto.getYdxx();
            if (CollectionUtils.isEmpty(ydxxDTOS)){
                throw new BusinessException("疑点信息参数不能为空");
            }
            // 据疑点信息数据，经过处理加入到申报明细查询请求
            addSbMxbBaseDTOViaYd(dto,ydxxDTOS,ConstUtil.SBYWB_SCMDT);
        }
        dto.setSbywdm(ConstUtil.SBYWB_GJZYHW);
    }

    @Override
    public ItemNoticeVO itemsNotice() {
        TlUserProfile profile = commonService.getCurrentUser();
        // 操作人员代码
        String czryDm = profile.getCzryDm();
        // 操作人员名称
        String czryMc = profile.getCzryMc();
        // 税务机关代码
        String swjgdm = profile.getSwjgDm();
        // 权限税务机关代码
        swjgdm = TlUtils.getPreSwjgdm(swjgdm);

        /**
         * 1、从金三系统中获取出口岗位在办的出口退税的流程笔数、即将超期的业务笔数
         */
        ItemNoticeVO noticeVO = countCkGwzbFromJsxt(czryDm);

        /**
         *  2、获取审单核查在办任务数量
         *  如果操作员具有日常审单核查角色，则查询在办任务数量，否则返回0
         */
        String hasAuth = inspectService.inspectAuth();
        Integer dzhxZbbs = 0;
        if (ConstUtil.WHETHER_YES.equals(hasAuth)){
            dzhxZbbs = linkedMapperMapper.countInspectWorking(swjgdm,czryMc);
        }
        noticeVO.setDzhxZbbs(dzhxZbbs);
        return noticeVO;
    }

    @Override
    public List<KaxxDictVO> listKaxxDict(String kaxx) {
        try {
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            return dictCacheMapper.listKaxxDict(kaxx);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     *  从金三系统中获取出口岗位在办的出口退税的流程笔数、即将超期的业务笔数
     * @param czryDm 操作人员代码
     */
    public ItemNoticeVO countCkGwzbFromJsxt(String czryDm){
        ItemNoticeVO noticeVO = new ItemNoticeVO();
        try{
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            noticeVO = jsxtMapper.countCkGwzbFromJsxt(czryDm);
        }catch (Exception e){
            LOGGER.error("出口岗位在办(金三系统)获取数据出错-{}",e);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return noticeVO;
    }

    /**
     * 从金三系统中,根据20位代理证明号获取21位报关单号
     * @param djxh 金三登记序号
     * @param dlzmh 20位代理证明号
     * @return 21位报关单号
     */
    public String getCkbgdhByDlzmhFromJsxt(String djxh, String dlzmh) {
        try {
            if (StringUtils.isBlank(djxh)){
                return null;
            }
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            return jsxtMapper.getCkbgdhByDlzmhFromJsxt(djxh,dlzmh);
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     *  根据疑点信息数据，经过处理加入到申报明细查询请求
     *  生产免抵退、外综服代办退税、购进自用货物  根据业务关联项1=申报序号
     *  外贸免退税根据业务关联项1=关联号（2021年12月之前） 业务关联项1=申报序号(2021年12月之后)
     * @param dto 申报明细数据请求对象
     * @param ydxxDTOS 疑点信息请求对象列表
     * @param sbywbdm 申报业务表代码
     */
    public void addSbMxbBaseDTOViaYd(SbMxbBaseDTO dto,List<SbMxbBaseDTO.SbMxbYdxxDTO> ydxxDTOS,String sbywbdm){
        if (ConstUtil.SBYWB_WMMTS.equals(sbywbdm)){
            // 外贸免退税关联业务表1  关联号（2021年12月之前） 业务关联项1=申报序号(2021年12月之后)
            List<String> glhList = new ArrayList<>();
            List<String> sbxhWmckList = new ArrayList<>();
            List<String> sbxhWmjhList = new ArrayList<>();
            for (SbMxbBaseDTO.SbMxbYdxxDTO ydxxDTO : ydxxDTOS){
                String glywb1 = ydxxDTO.getGlywb1();
                String glb = ydxxDTO.getGlb();
                glhList.add(glywb1);
                // 申报序号
                if (StringUtils.isNotBlank(glb) ){
                    // 出口明细
                    if ("CKTS_SB_MTS_TSSB_LSB".equals(glb)){
                        sbxhWmckList.add(glywb1);
                    } else if ("CKTS_SB_MTS_TSJH_LSB".equals(glb)) { // 进货明细
                        sbxhWmjhList.add(glywb1);
                    }
                }
            }
            dto.setGlhList(glhList);
            dto.setSbxhWmckList(sbxhWmckList);
            dto.setSbxhWmjhList(sbxhWmjhList);
        } else {
            // 生产免抵退关联业务表1  代表申报序号
            List<String> sbxhList = new ArrayList<>();
            for (SbMxbBaseDTO.SbMxbYdxxDTO ydxxDTO : ydxxDTOS){
                String glywb1 = ydxxDTO.getGlywb1();
                sbxhList.add(glywb1);
            }
            dto.setSbxhList(sbxhList);
        }
    }

    /**
     *  校正预警信息,传递的预警信息类型只有下述类型才参与过滤查询
     *  101   新增出口商品
     *  102	新增供货商
     *  108	敏感出口商品
     *  104   货源地不一致
     *  105	商品名称不一致
     *  107	异常供货商
     *  108	敏感出口商品
     *  109	敏感口岸(外贸)
     *  110	敏感口岸(生产)
     *  111	供货企业异常函调
     *  112	申报与出口口岸不一致
     * @param sourceYjxx 预警信息请求对象列表
     */
    public List<SbMxbBaseDTO.SbMxbYjxxDTO> correctSbMxbBaseDTOViaYj(List<SbMxbBaseDTO.SbMxbYjxxDTO> sourceYjxx){
        List<SbMxbBaseDTO.SbMxbYjxxDTO> targetYjxx = new ArrayList<>();
        for (SbMxbBaseDTO.SbMxbYjxxDTO item : sourceYjxx){
            if (SnippetUtils.judgeArrContainElement(YJ_TYPE_IN_SBMX_ARR,item.getYjType())){
                targetYjxx.add(item);
            }
        }
        return  targetYjxx;
    }

    /**
     * 生成8位sbno
     * @param xh  序号
     * @return 8位sbno
     */
    public static String getSbno_8(int xh){
        String sbno = SBNO_DECIMAL_FORMAT_8.format(xh);
        return sbno;
    }

    /**
     * 同步数据
     * 获奖状态变动的数据同步到云端
     * @param mainid
     * @param tblx
     */
    public int insertDtbsj(Long mainid, String tblx) {
        TbDtbsj ysfkdtbsj = new TbDtbsj();
        ysfkdtbsj.setMainid(mainid);
        ysfkdtbsj.setTblxDm(tblx);
        ysfkdtbsj.setCjsj(new Date());
        ysfkdtbsj.setTbcs(0);
        ysfkdtbsj.setYxj(0);//优先级设置为0：表示最优先
        return  mapper.insertTb(ysfkdtbsj);
    }

    /**
     * 从金三数据库中获取乡镇街道信息
     * @param map
     * @return
     */
    private String getXzjdFormJsxt(Map map){
        try {
            Map resMap;
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
             resMap=jsxtMapper.getXzjdFromJsxt(map);
            LOGGER.info("取金三系统街道乡镇地址 查询结果re-{}",resMap);
            return (String) resMap.get("JDXZMC");
        }catch (Exception e){
            LOGGER.error("调用金三系统取乡镇街道出错 nsrsbh:{} errMSg:{}", map.get("nsrsbh"),e.getMessage());
            return "";
        }
        finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     * 生成事中指标预警信息
     * @param dto
     * @return
     */
    @Override
    public YjxxCreateVO yjxxCreate(YjxxCreateDTO dto) {
        YjxxCreateVO vo = new YjxxCreateVO();
        //处理入参信息
        YjxxCreateParam param = handleDto(dto);
        if (null == param.getBizKey() || StringUtils.isEmpty(param.getLcslid())){
            return null;
        }
        vo.setLcslid(param.getLcslid());
        LOGGER.info("{}-解析报文得到的参数为：{}",dto.getCzryDm(), GsonUtils.getDefaultGson().toJson(param));
        try{
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            //调用存储过程，生成事中明细
            mapper.yjxxCreate(param);
            LOGGER.info("{}调用存储过程，生成的事中明细数量为：",dto.getCzryDm(),param.getNum());
            if (param.getNum() > 0){
                //查询事中明细并返回
                FxnkZjBjtsSzProfile szParam = new FxnkZjBjtsSzProfile();
                szParam.setLcslid(param.getLcslid());
                List<FxnkZjBjtsSzProfile> szList = zjBjtsSzMapper.select(szParam);
                if (!CollectionUtils.isEmpty(szList)){
                    List<String> list = new ArrayList<>();
                    vo.setNkywms(list);
                    for (FxnkZjBjtsSzProfile item : szList){
                        list.add(item.getNkywms());
                    }
                }
            }
        }catch (Exception e){
            LOGGER.error("生成事中指标预警信息异常",e);
            throw new BusinessException("生成事中指标预警信息异常");
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return vo;
    }

    /**
     * 更新事中指标预警信息
     * @param dto
     */
    @Override
    public void yjxxUpdate(YjxxUpdateDTO dto) {
        try{
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            //查询事中信息
            //查询事中明细并返回
            FxnkZjBjtsSzProfile param = new FxnkZjBjtsSzProfile();
            param.setLcslid(dto.getLcslid());
            List<FxnkZjBjtsSzProfile> szList = zjBjtsSzMapper.select(param);
            if (!CollectionUtils.isEmpty(szList)){
                //切换审核助手数据源
                MultipleDataSourceHolder.clearDBType();
                //同步事中信息到TL_TSSH
                for (FxnkZjBjtsSzProfile item : szList){
                    FxnkNbfxdmxSzProfile profile = new FxnkNbfxdmxSzProfile();
                    BeanUtils.copyProperties(item,profile);
                    profile.setCldz(dto.getCldz());
                    profile.setHxczsm(dto.getHxczsm());
                    szMapper.insertSelective(profile);
                }
            }
        }catch (Exception e){
            LOGGER.error("更新事中指标预警信息异常：{}",e.getMessage(),e);
            throw new BusinessException("更新事中指标预警信息异常");
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    @Override
    public List<RulesMainProfile> getAllKeyList() {
        RulesMainProfile p = new RulesMainProfile();
        p.setIsValid("Y");
        return rulesMainProfileMapper.select(p);
    }

    /**
     * 处理入参信息
     * @param dto
     * @return
     */
    private YjxxCreateParam handleDto(YjxxCreateDTO dto){

        JsonNode jsonNode = initJsonNode(dto.getJsonStr());

        YjxxCreateParam param = new YjxxCreateParam();
        param.setSwryDm(dto.getCzryDm());

        //1、从报文解析业务关键字
        String bizKey = getBizKeyFromJson(jsonNode);
        if (StringUtils.isEmpty(bizKey)){
            LOGGER.info("{}解析报文没有获取到有效的BIZKEY",dto.getCzryDm());
            return param;
        }else {
            param.setBizKey(bizKey);
            LOGGER.info("{}解析报文获取到BIZKEY：{}",dto.getCzryDm(),bizKey);
        }

        //2、获取规则根据bizKey
        List<RulesMxProfile> mxProfiles=null;
        if(StringUtils.isNotBlank(bizKey)){
            mxProfiles = getMxRulesByBizKey(bizKey);
        }

        //3、根据规则集提取Json报文内参数变量值
        fillParamByRulesMx(mxProfiles,param,jsonNode);

        return param;
    }

    private static JsonNode initJsonNode(String jsonStr) {
        JsonNode rootNode;
        if (StringUtils.isEmpty(jsonStr)){
            throw new BusinessException("请求报文格式为空");
        }else {
            jsonStr = jsonStr.replaceAll("\\\\\"","\"").replaceAll("\"\\{","{").replaceAll("}\"","}");
            ObjectMapper objectMapper = new ObjectMapper();
            try {
                rootNode = objectMapper.readTree(jsonStr);
            } catch (JsonProcessingException e) {
                throw new BusinessException("请求报文格式异常");
            }
        }
        return rootNode;
    }

    private void fillParamByRulesMx(List<RulesMxProfile> mxProfiles, YjxxCreateParam param, JsonNode jsonNode) {
        if(CollectionUtils.isEmpty(mxProfiles) || jsonNode==null){
            return;
        }

        String lcswsxConst = appProperties.getLcswsxParam();
        String lcslidConst = appProperties.getLcslidParam();

        List<String> propsParams = new ArrayList<>();
        List<String> valuesParams = new ArrayList<>();
        propsParams.add("bizkey");
        valuesParams.add(param.getBizKey());

        for (RulesMxProfile mxProfile : mxProfiles) {
            JsonNode tempNode = jsonNode;

            String propPath = mxProfile.getPropPath();

            String propName = mxProfile.getPropName();
            if(StringUtils.isNotBlank(propPath)){
                String[] split = propPath.split(ConstUtil.SPLIT_RULES_PATH);
                if(StringUtils.isBlank(propName)){
                    LOGGER.info("路径:{}，未正确配置参数名属性",propPath);
                    throw new BusinessException("规则未正确定义");
                }
                JsonNode subJsonNode = (JsonNode)traverseJsonNode(tempNode,split,0,propName);
                if(subJsonNode!=null){
                    tempNode = subJsonNode;
                }
            }

            String paramAlias = mxProfile.getParamAlias();
            if(StringUtils.isNotBlank(mxProfile.getValuePath())){
                String valuePath = mxProfile.getValuePath();
                String[] split = valuePath.split(ConstUtil.SPLIT_RULES_PATH);
                String value = (String)traverseJsonNode(tempNode,split,0,null);
                LOGGER.info("参数别名:{}，值：{}",paramAlias,value);
                if(lcswsxConst.equals(paramAlias)){
                    param.setLcswsxDm(value);
                }else if(lcslidConst.equals(paramAlias)){
                    param.setLcslid(value);
                }else {
                    propsParams.add(paramAlias);
                    valuesParams.add(StringUtils.trimToEmpty(value));
                }
            }
        }

        if(!CollectionUtils.isEmpty(propsParams)){
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < propsParams.size(); i++) {
                sb.append(propsParams.get(i)).append(":")
                        .append(Optional.ofNullable(valuesParams.get(i)).orElse(""))
                        .append(";");
            }
            param.setProps(sb.toString());
        }
    }

    private List<RulesMxProfile> getMxRulesByBizKey(String bizKey) {
        RulesMxProfile r = new RulesMxProfile();
        r.setIsValid("Y");
        r.setBizKey(bizKey);
        return rulesMxProfileMapper.select(r);
    }

    private String getBizKeyFromJson(JsonNode rootNode) {
        RulesMainProfile r = new RulesMainProfile();
        r.setIsValid("Y");
        List<RulesMainProfile> mainProfiles = rulesMainProfileMapper.select(r);
        for (RulesMainProfile profile : mainProfiles) {
            LOGGER.info("配置关键字：{},路径：{}",profile.getBizKey(),profile.getBizPath());
            String bizPath = profile.getBizPath();
            String[] split = bizPath.split(ConstUtil.SPLIT_RULES_PATH);
            if(rootNode!=null){
                String bizKeyStr = (String)traverseJsonNode(rootNode,split,0,null);
                if(bizKeyStr!=null && bizKeyStr.contains(profile.getBizKey())){
                    return profile.getBizKey();
                }
            }
        }
        return null;
    }

    /**
     * 根据规则路径字符串strs解析JsonNode,并获取对应值。若propNameValue不为空，匹配上则返回对应JsonNde节点
     * @param jsonNode  报文JsonNode
     * @param strs 路径字符数组
     * @param index 路径坐标
     * @param propNameValue 属性参数名
     * @return
     */
    private static Object traverseJsonNode(JsonNode jsonNode, String[] strs, int index, String propNameValue) {
        if (jsonNode.isObject()) {
            Iterator<String> fieldNames = jsonNode.fieldNames();
            while (fieldNames.hasNext()) {
                String fieldName = fieldNames.next();
                JsonNode fieldValue = jsonNode.get(fieldName);
                if(strs[index].equals(fieldName)){
                    index++;
                    if(index==strs.length){
                        index=0;
                        if(StringUtils.isNotBlank(propNameValue)){
                            if(propNameValue.equals(fieldValue.asText())){
                                return jsonNode;
                            }
                        }else {
                            return fieldValue.asText();
                        }
                    }else {
                        Object nodeValue = traverseJsonNode(fieldValue, strs, index,propNameValue);
                        if(nodeValue!=null){
                            return nodeValue;
                        }
                    }
                }
            }
        } else if (jsonNode.isArray()) {
            for (JsonNode arrayElement : jsonNode) {
                Object nodeValue = traverseJsonNode(arrayElement, strs, index,propNameValue);
                if(nodeValue!=null){
                    return nodeValue;
                }
            }
        }
        return null;
    }

}
