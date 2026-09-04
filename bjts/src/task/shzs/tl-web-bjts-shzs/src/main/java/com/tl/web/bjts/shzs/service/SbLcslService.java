package com.tl.web.bjts.shzs.service;

import com.google.gson.Gson;
import com.tl.bjts.inner.general.model.ST4Return;
import com.tl.bjts.inner.general.service.TPSbService;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.*;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.datasource.TargetDataSource;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.domain.*;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjBgdgzxxAddDTO;
import com.tl.web.bjts.shzs.model.vo.FetchTaskVo;
import com.tl.web.bjts.shzs.model.vo.FkxxWbVO;
import com.tl.web.bjts.shzs.model.vo.SimpleSbxxVo;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.apache.shiro.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Pattern;

/**
 * Created by Neo Lin on 2017/6/19.
 */
@Service
public class SbLcslService {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    /**
     * 流程事项-申报业务表代码对应map
     * key:流程事项   value:申报业务表代码
     */
    private static Map<String,Object> lcsx4SbywbMap  = new HashMap<>();

    @Autowired
    private TlShSbxxHzProfileMapper mapper;
    @Autowired
    private TlMyMapper myMapper;
    @Autowired
    private TlGcYwlcInfoHisProfileMapper ywlcInfoHisProfileMapper;
    @Autowired
    private YjBgdgzxxGcbModelMapper yjBgdgzxxGcbModelMapper;
    @Autowired
    private CommonServiceImpl commonService;
    @Autowired
    private SbWbService sbWbService;
    @Autowired
    TlMyMapper tlMyMapper;
    @Autowired
    TPSbService tpSbService;
    @Autowired
    AppProperties appProperties;
    @Autowired
    TlJsxtMapper jsxtMapper;
    static{
        // 出口货物劳务及服务免抵退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081038005","A0305001");
        lcsx4SbywbMap.put("LCSXA081038001","A0305001");
        // 出口货物劳务及服务免退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081039005","A0301001");
        lcsx4SbywbMap.put("LCSXA081039001","A0301001");
        // 外贸综合服务企业代办退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081040003","A0310001");
        lcsx4SbywbMap.put("LCSXA081040001","A0310001");
        // 购进自用货物退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081042008","A0304001");
        lcsx4SbywbMap.put("LCSXA081042002","A0304001");
        // 航天发射退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081042010","A0309001");
        lcsx4SbywbMap.put("LCSXA081042005","A0309001");
        // 出口非自产货物退消费税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081042012","A0302001");
        lcsx4SbywbMap.put("LCSXA081042006","A0302001");
        // 出口已使用过的设备退税申报核准调查评估
        lcsx4SbywbMap.put("LCSXA081042014","A0303001");
        lcsx4SbywbMap.put("LCSXA081042001","A0303001");
    }
    /**
     * @param sbid 申报id, lcslid 流程受理id,czryDm 操作人代码
     * @Description: 回写流程受理id
     * @Date 2017/6/20
     */
    public void writeBackLcslid(Long sbid, String lcslid, String czryDm) {
        /*根据sbid获取lcslid，如果流程实例id相同，判断sbzt_dm='2B',update
        * 如果不同，直接update，让李坤的程序去判断流程
        * 2018年2月12日10:29:34修改 判断传入的流程实例id是否已经被绑定
        */

        Long bindId = getBindSbidBylcslid(lcslid,sbid);
        if(bindId !=null){//流程实例id已绑定
            SimpleSbxxVo bindHzxx = myMapper.getSbxxInfo(bindId);
            String msg = String.format("流程启动失败，当前流程id已与%s %s %s 申报绑定，请重新打开页面接单",
                    bindHzxx.getNsrmc(),bindHzxx.getSssq(),String.valueOf(bindHzxx.getSbpc()));
            LOGGER.error("【writeBackLcslid】流程重复绑定，本次id={},已绑定id={},lcslid={}",sbid,bindId,lcslid);
            throw new BusinessException(msg);
        }

        TlShSbxxHzProfile sbxxHzProfile = mapper.selectByPrimaryKey(sbid);

        TlShSbxxHzProfile sbxxHz = new TlShSbxxHzProfile();
        String lcslidOld = sbxxHzProfile.getLcslid();
        String sbztDm = sbxxHzProfile.getSbztDm();
        sbxxHz.setLcslid(lcslid);
        sbxxHz.setSbr(czryDm);
        sbxxHz.setId(sbid);
        //2017-11-22 13:22:32 修改，绑定流程实例id的同时回写21
        sbxxHz.setSbztDm("21");
        sbxxHz.setSbsj(new Date());

        if(!lcslid.equals(lcslidOld) && "2B".equals(sbztDm)) {
            LOGGER.info("【writeBackLcslid】" + sbxxHz.toString());
            mapper.updateByPrimaryKeySelective(sbxxHz);
        }
    }

    /*
     * @Description: 获取已绑定的申报id
     * @Author Neo Lin
     * @param  [lcslid, sbid]
     * @return  java.lang.Long
     * @Date  2018/2/12
     */
    public Long getBindSbidBylcslid(String lcslid,Long sbid) {
        TlShSbxxHzProfileExample example = new TlShSbxxHzProfileExample();
        TlShSbxxHzProfileExample.Criteria criteria = example.createCriteria();
        criteria.andLcslidEqualTo(lcslid);
        criteria.andIdNotEqualTo(sbid);
        List<TlShSbxxHzProfile> hzs = mapper.selectByExample(example);
        if(CollectionUtils.isEmpty(hzs)){
            return null;
        }
        return hzs.get(0).getId();
    }

    /**
     * 根据流程受理id获取申报id
     * @param lcslid 流程受理id
     * @return 申报id
     * @Description: 根据流程受理id获取申报id
     * @Date 2017/6/20
     */
    public Long getSbid(String lcslid) {
        TlShSbxxHzProfileExample example = new TlShSbxxHzProfileExample();
        example.or().andLcslidEqualTo(lcslid);
        List<TlShSbxxHzProfile> ShSbxxHzs = mapper.selectByExample(example);
        Long sbid;
        if (ShSbxxHzs.size() < 1) {
            LOGGER.info("getSbid-从汇总表中，根据lcslid={}未查询到sbid，尝试从金三业务办理信息表中获取相关数据",lcslid);
            //  根据lcslid从金三系统中获取业务办理信息
            YwblxxVO ywblxxVO = getYwblxxFormJsxt(lcslid);
            if (ywblxxVO == null){
                throw new BusinessException(BusinessMsgCons.GET_SBID_EMPTY);
            }
            //  根据业务办理信息(登记序号、流程事项、所属时期、申报批次)获取申报id
            sbid = getSbidByYwblxx(ywblxxVO);
        } else {
            sbid = ShSbxxHzs.get(0).getId();
        }

        if (sbid == null) {
            LOGGER.error("getSbid-未查询到sbid");
            throw new BusinessException(BusinessMsgCons.GET_SBID_EMPTY);
        }
        return sbid;
    }

    /**
     * 根据lcslid从金三系统中获取业务办理信息
     * @param lcslid 流程受理id
     * @return 业务办理信息(登记序号、流程事项、所属时期、申报批次)
     */
    public YwblxxVO getYwblxxFormJsxt(String lcslid){
        try {
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            YwblxxVO ywblxxVO =jsxtMapper.getYwblxxFormJsxt(lcslid);
            if (ywblxxVO == null){
                LOGGER.error("获取Ywblxx-从金三业务办理信息表根据lcslid={}中未获取相关数据",lcslid);
                throw new BusinessException(BusinessMsgCons.GET_SBID_EMPTY);
            }
           return ywblxxVO;
        }catch (Exception e){
            LOGGER.error("获取Ywblxx-从金三业务办理信息表根据lcslid={}中未获取相关数据出错， errMSg:{}", lcslid,e);
            return null;
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     * 根据业务办理信息(登记序号、申报业务表代码、所属时期、申报批次)获取申报id
     * @param ywblxxVO 业务办理信息(登记序号、流程事项、所属时期、申报批次)
     * @return 申报id
     */
    private Long getSbidByYwblxx(YwblxxVO ywblxxVO){
        Long sbid = null;
        try {
            // 1、流程事项转换为申报业务表代码
            String sbywbDm = (String)lcsx4SbywbMap.get(ywblxxVO.getLcswsxDm());
            if (StringUtils.isEmpty(sbywbDm)){
                LOGGER.error("getSbid-根据流程事项代码={}未获取到申报业务表代码",ywblxxVO.getLcswsxDm());
                return null;
            }
            ywblxxVO.setSbywbDm(sbywbDm);
            // 2、处理申报批次
            Integer sbpcI = transferSbpcStr2Number(ywblxxVO.getSbpc());
            if (sbpcI == null){
                LOGGER.error("getSbid-根据字符型申报批次={}转换为数值型申报批次为空",ywblxxVO.getSbpc());
                return null;
            }
            ywblxxVO.setSbpcI(sbpcI);
            sbid = tlMyMapper.getSbidByYwblxx(ywblxxVO);
            if (sbid == null){
                LOGGER.error("getSbid-根据(登记序号、申报业务表代码、所属时期、申报批次)=【{}】获取申报id，未获取相关数据",ywblxxVO.toString());
            }
        }catch (Exception e){
            LOGGER.error("getSbid-根据(登记序号、申报业务表代码、所属时期、申报批次)=【{}】获取申报id出错， errMSg:{}", ywblxxVO.toString(),e);
        }
        return sbid;
    }

    /**
     * 转换 字符型的申报批次为整型
     * 例如'01'=1, '001'=1，注意首位字符是英文的，如 'A0'=100,'A1'=101,'B0'=110,'B1'=111，依次规则类推。
     * 以首字母开头：   ((ascii(首字母) - ascii(A) + 10)*10  ) + 除首字母之外的整型值
     * @param sbpc
     * @return
     */
    public  Integer transferSbpcStr2Number(String sbpc){
        //因为最新版单证备案系统中附件申报上传时，如果申报批次不存在则默认为1
        if (StringUtils.isEmpty(sbpc)){
            return 1;
        }
        Integer sbpcI = null;
        // 申报批次第一个值
        String sbpcFirst = sbpc.substring(0,1);
        // 申报批次其余的值
        String sbpcOther = sbpc.substring(1);
        // 如果以大写字母开头
        if (Pattern.compile("^[A-Z]").matcher(sbpcFirst).find()){
            char[] sbpcFristC = sbpcFirst.toCharArray();
            int byteAscii1 = (int) sbpcFristC[0];
            int byteAsciiA = (int)("A".toCharArray()[0]);
            sbpcI = (((byteAscii1 - byteAsciiA) + 10) * 10) + Integer.parseInt(sbpcOther);
        }else { // 直接转为数值
            sbpcI = Integer.valueOf(sbpc);
        }
        return sbpcI;
    }

    /**
     * 绑定流程的前置校验
     * @param sbid 申报id
     * @param qyhgdm 企业海关代码
     * @param lcswsxDm 流程税务事项代码
     * @return
     */
    public int checkBindLcslidBefore(Long sbid,String qyhgdm,String lcswsxDm){
        return tlMyMapper.checkBindLcslidBefore(sbid,qyhgdm,lcswsxDm);
    }

    /**
     * 根据流程申报ID获取申报流程信息
     *
     * @param sbid 申报ID
     * @return
     */
    public TlShSbxxHzProfile getSblcxxBySbid(Long sbid) {
        TlShSbxxHzProfile obj = mapper.selectByPrimaryKey(sbid);
        if (obj == null || StringUtils.isEmpty(obj.getSbr())) {
            LOGGER.error("getCzryDmBySbid-申报人信息不存在");
            throw new BusinessException("未查询到申报ID对应申报人信息");
        }
        return obj;
    }


    /**
     * update lcslid
     */

    public boolean updateSbxxLcslid(TlShSbxxHzProfile profile) {

        TlShSbxxHzProfile tlShSbxxHzProfile = new TlShSbxxHzProfile();
        tlShSbxxHzProfile.setId(profile.getId());
        tlShSbxxHzProfile.setLcslid("null");
        mapper.updateByPrimaryKeySelective(tlShSbxxHzProfile);
        return true;
        // mapper.updateByExample(example);
    }

    /**
     * 更新申报流程信息
     *
     * @param obj
     * @return
     */
    public String updateSblcxx(TlShSbxxHzProfile obj) {

        int ret = mapper.updateByPrimaryKeySelective(obj);
        if (ret < 1) {
            LOGGER.error("updateSblcxx-更新TQSJ、TQCS失败");
            throw new BusinessException("更新数据出错");
        }
        return obj.getSbr();
    }

    /**
     * srch shxxhz by lcslid
     */
    public List<TlShSbxxHzProfile> getsByLcslid(String lcslid) {

        if (StringUtils.isEmpty(lcslid)) {
            return new ArrayList<>();
        }
        TlShSbxxHzProfileExample e = new TlShSbxxHzProfileExample();
        TlShSbxxHzProfileExample.Criteria criteria = e.or();
        criteria.andLcslidEqualTo(lcslid);
        List<TlShSbxxHzProfile> list = mapper.selectByExample(e);
        if (list != null) {
            return list;
        }
        return new ArrayList<>();
    }

    private boolean skipSomeSbywb(String sbywbDm){
        if("A0101001".equals(sbywbDm)){
            return true;
        }
        return false;
    }
    /**
     * @Description: 检查申报id是否有对应的流程受理id，并且该流程受理id是否已进入预审环节
     * @param  sbid
     * @return  java.lang.String
     * @Date  2017/8/28
     */
    public String checkLcslid(Long sbid) {
        TlShSbxxHzProfile sbxx = mapper.selectByPrimaryKey(sbid);
        if(sbxx==null){
            LOGGER.error("checkLcslid-申报信息不存在");
            throw new BusinessException("未查询到申报ID对应申报信息");
        }
        String lcslid = sbxx.getLcslid();
        String sbztDm = sbxx.getSbztDm();
        String sbywbDm = sbxx.getSbywbDm();
        if (StringUtils.isEmpty(lcslid) || "null".equals(lcslid)) {
            return null;
        }
        boolean flag = "2B".equals(sbztDm);
        if(!flag){
            return "当前申报状态已经不是待人工接单状态，请刷新列表。";
        }

        //根据sbid查询企业海关代码
        SimpleSbxxVo simpleSbxxVo = tlMyMapper.getSbxxInfo(sbid);
        if(simpleSbxxVo == null){
            return "申报id=" + sbid + "的汇总表信息为空";
        }
        String qyhgdm = simpleSbxxVo.getQyhgdm();
        if(StringUtils.isEmpty(qyhgdm)){
            return "申报id=" + sbid + "的企业海关代码为空";
        }

        ST4Return st4Return = tpSbService.stateTracking(qyhgdm,lcslid,appProperties.getSbServiceUrl());//调用自定义查询服务
        LOGGER.info("sbid={},lcslid={}校验受理流程-调用申报服务查询接口返回的信息={}",sbid,lcslid,st4Return != null ? new Gson().toJson(st4Return) : "为空");
        if(st4Return != null && st4Return.getSbztDm().startsWith(ConstUtil.SBZTDM_SUCCESS_START)){
            if(skipSomeSbywb(sbywbDm)){
                return packageShzsMsg(st4Return);
            }
            FkxxWbVO vo = new FkxxWbVO();
            vo.setSbid(sbid);
            vo.setSbztDm("21");
            sbWbService.writeBackFeedbackInfo(vo);
            return packageShzsMsg(st4Return);
        }
        return null;
    }

    /**
     * 封装审核助手反馈信息
     * @param st4Return
     * @return
     */
    public String packageShzsMsg(ST4Return st4Return){
        StringBuffer sb = new StringBuffer();
        sb.append("该业务已");
        sb.append("接单,目前在：");
        sb.append(st4Return.getLzhj());
        sb.append("环节");
        if(!StringUtils.isEmpty(st4Return.getFkxx())){
            sb.append(",反馈信息是：");
            sb.append(st4Return.getFkxx());
        }
        return sb.toString();
    }

    @TargetDataSource(name = MultipleDataSourceHolder.JSXT)
    public FetchTaskVo genJsxtYjTask(String lcslid) {
        return jsxtMapper.genJsxtYjTask(lcslid);
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
}
