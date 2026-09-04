package com.tl.web.bjts.yj.service;

import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.dao.*;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.domain.*;
import com.tl.web.bjts.yj.model.vo.*;
import com.tl.web.bjts.yj.utils.ConstUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;

/**
 * @Author：Mamf
 * @Date: 2017/12/11.
 * @Description:
 */
@Service
public abstract class IYjService extends  BaseProcServcie{

    public static final String YjTypeSpdm = ConstUtil.YjTypeSpdm;   //预警类型(新增商品代码)
    public static final String YjTypeSupplier = ConstUtil.YjTypeSupplier; //预警类型(新增供应商)
    public static final String YjTypeEnterprise = ConstUtil.YjTypeEnterprise; //预警类型(新企业首次出口)
    public static final String YjTypeHydGhfshDiffer = ConstUtil.YjTypeHydGhfshDiffer; //预警类型(货源地与供货商税号不一致)
    public static final String YjTypeSpmcDiffer = ConstUtil.YjTypeSpmcDiffer; //预警类型(商品名称不一致)

    public static final String YjTypeYcghs = ConstUtil.YjTypeYcghs; //预警类型(异常供货商)
    public static final String YjTypeGfxsp = ConstUtil.YjTypeGfxsp; //预警类型(高风险商品)

    public static final String YjTypeCkkaWm= ConstUtil.YjTypeCkkaWm; //预警类型(敏感出口口岸)
    public static final String YjTypeCkkaSc= ConstUtil.YjTypeCkkaSc; //预警类型(敏感出口口岸)
    public static final String YjTypeGhqyhd= ConstUtil.YjTypeGhqyhd; //供货企业函调异常

    public static final String YjTypeSbckka = ConstUtil.YjTypeSbckka; //申报与出口口岸不一致
    public static final String YjTypeYcdj = ConstUtil.YjTypeYcdj; //异常单价
    public static final String YjTypeBgdfs = ConstUtil.YjTypeBgdfs; //报关行分散

    public static final String YjTypeYwBgd = ConstUtil.YjTypeYwBgd; //非金华地区义务报关行预警
    public static final String YjTypeYdBg = ConstUtil.YjTypeYdBg;

    public static final String YjTypeJgdj = ConstUtil.YjTypeJgdj; //商品单价畸高指标
    public static final String YjTypeCkkpSjjg = ConstUtil.YjTypeCkkpSjjg; //出口与开票时间间隔指标
    public static final String YjTypeWmqyMmylrl = ConstUtil.YjTypeWmqyMmylrl; //每美元利润率分析指标
    public static final String YjTypeFxqydcpg = ConstUtil.YjTypeFxqydcpg; //风险企业调查评估指标(其他关注类指标)
    public static final String YjTypeCqwbgd = ConstUtil.YjTypeCqwbgd; //长期未申报报关单指标
    public static final String YjTypeShblpd = ConstUtil.YjTypeShblpd; //收汇比例偏低指标
    public static final String YjTypeWsbWaxx = ConstUtil.YjTypeWsbWaxx; //未申报物流信息指标
    public static final String YjTypeYjbmtdtshd = ConstUtil.YjTypeYjbmtdtshd; //出口商品码多退税率核对指标
    public static final String YjTypeStzc = ConstUtil.YjTypeStzc; //视同自产货物预警指标
    public static final String YjTypeHkbccb = ConstUtil.YjTypeHkbccb; //换汇成本超阈值预警指标
    public static final String YjTypeFxbgh = ConstUtil.YjTypeFxbgh; //总局下发风险报关行预警指标

    public static final String YjTypeTszh = ConstUtil.YjTypeTszh; //预警类型(退税账户不一致)

    public static final String YjTypeHegs = ConstUtil.YjTypeHegs; //预警类型(霍尔果斯口岸毛皮出口)

    public static final String YjTypeGhqyhd_2= ConstUtil.YjTypeGhqyhd_2; //供货企业函调异常

    public static final String YjTypeDzba = ConstUtil.YjTypeDzba; //近期申报数据单证备案未完成

    public static final String YjTypeCqwsb = ConstUtil.YjTypeCqwsb; //长期未申报 已确认征/免税出口业务申报退税

    public static final String YjTypeXbqy = ConstUtil.YjTypeXbqy; //新办企业

    public static final String YjTypeSbhtzb = ConstUtil.YjTypeSbhtzb; //外贸企业申报数据含调整表

    protected ThreadLocal<Map<String,String>> yjxxMapThread=new ThreadLocal<>();
    protected ThreadLocal<Map<String,YjzbItemVo>> yjzbMapThread=new ThreadLocal<>();


    @Autowired
    YjMapper yjMapper;

    @Autowired
    YjYjxxModelMapper yjYjxxModelMapper;

    @Autowired
    YjHisBghModelMapper yjHisBghModelMapper;

    @Autowired
    YjHisCkkaModelMapper yjHisCkkaModelMapper;

    @Autowired
    YjHisSpdmModelMapper yjHisSpdmModelMapper;

    @Autowired
    YjHisGhqyModelMapper yjHisGhqyModelMapper;

    @Autowired
    SbSbxxHzProfileMapper sbxxHzProfileMapper;


//    public void executeYjInit(TaskVo ysxx){
//
//        //1.清理本sbid所有的预警信息及预警历史数据表数据
//        logger.info("1-清理SBID:{},所有的预警信息及预警历史数据表数据",ysxx.getId());
//        deleteYjHisData(ysxx.getId(),Long.parseLong(ysxx.getNsrdzdah()),ysxx.getYjsbympc());
//
//        //2.LS_*申报明细表，从审核系统history_hg取数并填入
//        super.changeDataSource(MultipleDataSourceHolder.BJTS);
//        logger.info("2-填充JCK_BJTS下LS_*申报明细表附加字段，从审核系统history_hg取数并填入");
//        List<LsFillHgVo> lsFillHgVos = fillLsHgData(ysxx.getId(), ysxx.getCpcode(), ysxx.getLcId());
//
//        super.changeDataSource(MultipleDataSourceHolder.SHZS);
//        //3.数据填充到tl_bjts下的Ls表
//        if(!lsFillHgVos.isEmpty()){
//            logger.info("3-LS_*申报明细表数据非空，复制到tl_bjts下的Ls表");
//            LsToLs(lsFillHgVos, ysxx.getLcId());
//        }
//        //4.将LS_*申报明细表，汇总写入预警历史数据表
//        writeToHis(ysxx.getId(),ysxx.getYjsbympc(),ysxx.getYjsbny(),Long.parseLong(ysxx.getNsrdzdah()));
//
//
//        SbSbxxHzProfile sbxxHzProfile = sbxxHzProfileMapper.selectByPrimaryKey(ysxx.getId());
//        SbSbxxHzProfile obj= new SbSbxxHzProfile();
//        BeanUtils.copyProperties(sbxxHzProfile,obj);
//        obj.setTqbz(null);
//        obj.setTqsj(null);
//        obj.setTbcs(0);
//
//        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
//        sbxxHzProfileMapper.insert(obj);
//
//
//    }

    public void executeYj(TaskVo ysxx){

        logger.info("{}-【业务类型：{}，执行预警处理开始】：",ysxx.getId(),ysxx.getLcId());

        //5 ,根据指标预警配置进行预警处理
        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);

        Map<String, String> swjgYjDicCodeMap = initSwjgYjDicCodeMap(ysxx.getSwcode());
        Map<String, YjzbItemVo> yjzbItemMap = initYjzbItemMap(ysxx.getSwcode());
        Map yjBmdMap = getBmdMap(Long.parseLong(ysxx.getNsrdzdah()), ysxx.getSwcode());


        Map<String,Long> tbpcMap=new HashMap<>();

        executeNewYjProcess(ysxx,swjgYjDicCodeMap,yjzbItemMap,yjBmdMap,tbpcMap);

        if(ysxx.isHaveYjxx()){
            ysxx.setTbpc(tbpcMap.get("tbpc"));
            logger.info("{}-【预警处理结束，存在预警信息,同步批次：{}】",ysxx.getId(),ysxx.getTbpc());
        }else{
            logger.info("{}-【预警处理结束，无预警信息】",ysxx.getId());
        }
        super.clearDBType();
    }

    protected abstract void executeNewYjProcess(TaskVo ysxx,Map<String, String> swjgYjDicCodeMap,
                                                Map<String, YjzbItemVo> yjzbItemMap,
                                                Map yjBmdMap,Map<String,Long> tbpcMap);

    protected  void insertYjDataYjxx(List<YjxxNewVo> list, TaskVo ysxx,Map<String,Long> tbpcMap ,
                                     Map<String,Map> bmdMap,String zbcode,Integer score){
        super.clearDBType();

        String qyFlag = getQyFlag(ysxx.getYjType());
        String syqyFlag = getSyqyFlag(zbcode);
        boolean isSync="1".equals(qyFlag) && "1".equals(syqyFlag);

        if(list != null && list.size() > 0){

            logger.debug("预警指标：{}，存在预警信息：{}条",zbcode,list.size());

            Long tbpc;
            if(tbpcMap.get("tbpc")==null){
                tbpc=ysMapper.selectTbpcNextVal();
                tbpcMap.put("tbpc",tbpc);
                ysxx.setHaveYjxx(true);

            }else{
                tbpc=tbpcMap.get("tbpc");
            }

            Date date = new Date();
            long i=1;
            for(YjxxNewVo yjxxVo: list){
                YjYjxxModel obj=new YjYjxxModel();

                obj.setId(Long.parseLong(zbcode + i));
                i++;
                if(isSync){
                    obj.setTbpc(tbpc);
                }else{
                    obj.setTbpc(0L);
                }
                obj.setSbid(ysxx.getId());
                obj.setNsrdzdah(getStr2BigDecimal(ysxx.getNsrdzdah()));
                obj.setYjcode(ysxx.getYjType());
                obj.setZbcode(zbcode);
                obj.setCjDate(date);
                obj.setSbym(ysxx.getSbym());

                obj.setYjAmt(getStr2BigDecimal(yjxxVo.getYj_amt()));

                if(yjxxVo.getYj_count()!=null && StringUtils.isNotBlank(yjxxVo.getYj_count().trim())){
                    obj.setYjCount(Integer.parseInt(yjxxVo.getYj_count()));
                }else {
                    obj.setYjCount(null);
                }

                obj.setYjObject(yjxxVo.getYj_object());
                obj.setYjRecord(yjxxVo.getYj_record());
                obj.setYjMsg(genNewYjmsg(yjxxVo,ysxx,zbcode));

                obj.setScore(score);
                obj.setYjTax(getStr2BigDecimal(yjxxVo.getYj_tax()));
                obj.setBmdflag("0");
                obj.setClFlag("0");

                if(bmdMap.containsKey(ysxx.getYjType())){
                    Map map = bmdMap.get(ysxx.getYjType());
                    Object objflag = map.get("objflag");
                    if("1".equals(objflag)){
                        Map yjobjectMap = (Map) map.get("yjobject");
                        if(StringUtils.isNotBlank(yjxxVo.getYj_object()) && yjobjectMap.containsKey(yjxxVo.getYj_object())){
                            obj.setBmdflag("1");
                            obj.setTbpc(0L);
                            logger.info("{}-【预警指标：{}】为企业白名单按单放行指标,条目：{}",ysxx.getId(),zbcode,yjxxVo.getYj_object());
                        }
                    }else{
                        logger.info("{}-【预警指标：{}】为企业白名单整体放行指标,",ysxx.getId(),ysxx.getYjType());
                        obj.setBmdflag("1");
                        obj.setTbpc(0L);
                    }
                }

                //优先设置成关闭，如果已关闭则设置成关闭
                String isPush = getIsPush(ysxx.getYjType());
                if("0".equals(isPush)){
                    obj.setBmdflag("2");
                    obj.setTbpc(0L);
                }else if(ysxx.isYjzbClosedTemp()){
                    obj.setBmdflag("2");
                    obj.setTbpc(0L);
                }



                obj.setQyflag(getSyqyFlag(zbcode));
                obj.setSwflag(getSyswFlag(zbcode));
                //写入预警信息表(sh_yjxx)
                yjYjxxModelMapper.insertSelective(obj);

            }
        }
    }

    protected abstract  String genNewYjmsg(YjxxNewVo yjxxVo,TaskVo ysxx,String zbcode);

    private BigDecimal getStr2BigDecimal(String str){
        return StringUtils.isBlank(str)?null:new BigDecimal(str);
    }


    protected Map<String,Map> getBmdMap(Long nsrdzdah,String swjgdm){
        Map<String,Map> yjBmdMap=new HashMap<>();

        List<YjBmdVo> yjBmdVos=new ArrayList<>();
        yjBmdVos=yjMapper.selectYjBmd(nsrdzdah,swjgdm);

        for(YjBmdVo yjBmdVo:yjBmdVos){
            Map innerMap;
            if(!yjBmdMap.containsKey(yjBmdVo.getYjcode())){
                innerMap=new HashMap();
                yjBmdMap.put(yjBmdVo.getYjcode(),innerMap);
            }else {
                innerMap=yjBmdMap.get(yjBmdVo.getYjcode());
            }

            innerMap.put("objflag",yjBmdVo.getObjflag());
            Map yjobjectMap;
            if(!innerMap.containsKey("yjobject")){
                yjobjectMap=new HashMap();
                innerMap.put("yjobject",yjobjectMap);
            }else{
                yjobjectMap=(Map)innerMap.get("yjobject");
            }

            yjobjectMap.put(yjBmdVo.getYjobject(),yjBmdVo.getYjobject());
        }

        return yjBmdMap;

    }

    protected Map<String,String> initSwjgYjDicCodeMap(String swjgdm){
        Map<String,String> retMap=new HashMap();

        List<DmYjxxVo> dmYjxxVos = yjMapper.selectSwjgYjcodeDic(swjgdm);

        for(DmYjxxVo dmYjxxVo:dmYjxxVos){
            retMap.put(dmYjxxVo.getYjcode(),dmYjxxVo.getIspush());
        }

        yjxxMapThread.set(retMap);

        return retMap;
    }

    protected Map<String,YjzbItemVo> initYjzbItemMap(String swjgdm){
        Map<String,YjzbItemVo> retMap=new HashMap();

        List<YjzbItemVo> yjzbItemVos = yjMapper.selectYjzbItem(swjgdm);

        for(YjzbItemVo yjzbItemVo:yjzbItemVos){
            retMap.put(yjzbItemVo.getZbcode(),yjzbItemVo);
        }


        yjzbMapThread.set(retMap);
        return retMap;
    }


    private String getIsPush(String yjcode){
        Map<String, String> map = yjxxMapThread.get();
        return map.get(yjcode);
    }

    private String getQyFlag(String yjcode){
        Map<String, String> map = yjxxMapThread.get();
        return map.get(yjcode);
    }

    /**
     * 新版查询是否适用企业服务
     * @param yjcode
     * @return
     */
    private String getSyqyFlag(String yjcode){

        Map<String, YjzbItemVo> yjzbItemVoMap = yjzbMapThread.get();

        return yjzbItemVoMap.get(yjcode).getSyqy();
    }

    /**
     * 新版查询是否适用税务服务
     * @param yjcode
     * @return
     */
    private String getSyswFlag(String yjcode){

        Map<String, YjzbItemVo> yjzbItemVoMap = yjzbMapThread.get();

        return yjzbItemVoMap.get(yjcode).getSysw();
    }

    /**
     * 是否已启用预警
     * @param args
     * @return
     */
    protected boolean isQyYj(String args){
        if(StringUtils.isBlank(args)){
            return false;
        }

        String[] split = args.split(":");
        return "1".equals(split[0]) || "Y".equals(split[0]);
    }

    protected boolean isQyYjZb(YjzbItemVo args){
        if(args==null){
            return false;
        }

        String yxbz = args.getYxbz();
        return "1".equals(yxbz) || "Y".equals(yxbz);
    }

}
