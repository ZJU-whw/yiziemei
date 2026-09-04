package com.tl.web.bjts.shzs.service;

import com.google.gson.Gson;
import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.dao.YjSbxxHzModelMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSource;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.YjzbcxVo;
import com.tl.web.bjts.shzs.model.ZbnameVo;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.domain.YjSbxxHzModel;
import com.tl.web.bjts.shzs.model.dto.YjxxClmsgDTO;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by Neo Lin on 2017/6/20.
 */
@Service
public class SbYjxxService {

    private static final Logger logger = LoggerFactory.getLogger(SbYjxxService.class);

    @Resource
    private TlMyMapper mapper;

    @Resource
    YjSbxxHzModelMapper yjSbxxHzModelMapper;

    @Resource
    private SbLcslService sbLcslService;

    @Resource
    private CommonServiceImpl commonService;

    @Resource
    private RedisLock redisLock;

    private static final String YJ_TASK_LOCK="YJ_TASK_LOCK";

    private static Map<String,String> lcsx4SbywbMap  = new HashMap<>();

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
     * @Description: 预警信息查询
     * @param  [sbid 申报id]
     * @return  com.tl.web.bjts.shzs.model.vo.YjxxViewVO
     * @Date  2017/6/20
     */
    public YjxxViewVO getYjxxs(Long sbid){

        YjxxViewVO viewVO = new YjxxViewVO();
        Integer total = 0;
        Integer yjclose = 1;
        List<YjxxVO> yjxxs = new ArrayList<>();
        //检查当前税务机关是否开启预警信息显示
        if(!isYjClosed()){
            //查询预警信息总数
            total = mapper.countYjxxs(sbid);
            yjxxs = mapper.getYjxxs(sbid);
            yjclose = 0;
        }
        viewVO.setYjclose(yjclose);
        viewVO.setSbid(sbid);
        viewVO.setTotal(total);
        viewVO.setYjxxs(yjxxs);
        return viewVO;
    }

    private boolean isYjClosed(){
        TlUserProfile user = commonService.getCurrentUser();
        String swjgDm = user.getSwjgDm();

        String yjClose = mapper.getYjClose(swjgDm);

        if(yjClose != null && "1".equals(yjClose)){
            return true;
        }
        return false;

    }


    public List<YjxxExcelVO> getYjxxsForExcel(Long sbid){
        return mapper.getYjxxsForExcel(sbid);
    }

    // 批量更新处理意见
    public void updateClyj(YjxxClmsgDTO dto){
        TlUserProfile u= commonService.getCurrentUser();
        String  userName=u.getCzryMc();

        SbxxViewVo yjxx = getYjxxByLcslid(dto.getLcslid());
        if(yjxx==null){
            throw new BusinessException("未获取到有效的预警任务数据信息!");
        }

        Map paramp=new HashMap();
        paramp.put("clDate",new Date());
        paramp.put("clUser",userName);
        paramp.put("clMsg",dto.getClMsg());
        paramp.put("sbid",yjxx.getSbid());
        String var1[]=dto.getIds();
        for (int i=0;i<var1.length;i++) {
            paramp.put("id", Long.parseLong(var1[i]));

            mapper.updateClMsg(paramp);
        }
    }

    public List<YjzbcxVo> findyjzb() {
        List<YjzbcxVo> list=mapper.selectYjcodeAll();
        for(YjzbcxVo vo:list){
            List<ZbnameVo> list2=mapper.getYjzb(vo.getYjcode());
            vo.setYjzb(list2);
        }
        return  list;
    }

    /**
     * 根据lcslid查询预警信息
     * @param lcslid
     * @return
     */
    public YjxxViewVO getYjxxView(String lcslid) {
        try{
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            String mainLcslid  = mapper.selectMainLcslid(lcslid);
            if(StringUtils.isNotBlank(mainLcslid)){
                lcslid = mainLcslid;
            }
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        SbxxViewVo sbxxViewVo  = getYjxxByLcslid(lcslid);
        YjxxViewVO viewVO = new YjxxViewVO();
        if(sbxxViewVo==null){
            viewVO.setStatus("等待扫描");
        }else if("OK".equals(sbxxViewVo.getSbztDm()) || "YJ".equals(sbxxViewVo.getSbztDm())){
            viewVO = getYjxxs(sbxxViewVo.getSbid());
            viewVO.setStatus("扫描完成");
        }else if(sbxxViewVo.getSbcs() != 999 &&
                (sbxxViewVo.getTqbz()==null || ConstUtil.TIME_OUT_FLAG.equals(sbxxViewVo.getTimeoutFlag()))){
            //未进行人工提升优先级前提下,尚未触发预警任务或任务已超时(人工提升优先级后sbcs=999，不管是否执行只能等待)
            viewVO.setStatus("等待扫描");
        }else {
            viewVO.setStatus("正在扫描");
        }
        return viewVO;
    }

    private SbxxViewVo getYjxxByLcslid(String lcslid) {
        return mapper.selectYjxxByLcslid(lcslid);
    }

    /**
     * 手动触发执行调度生成预警任务，存在则提升优先级
     * @param lcslid
     */
    public void excuteYjTask(String lcslid) {
        SbxxViewVo sbxxViewVo  = getYjxxByLcslid(lcslid);
        boolean isExistSbxx = false;
        if(sbxxViewVo==null){
            FetchTaskVo fetchTaskVo = sbLcslService.genJsxtYjTask(lcslid);
            if(fetchTaskVo==null){
                throw new BusinessException("未获取到有效的流程数据信息!");
            }else {
                logger.info("获取流程数据信息:{}",fetchTaskVo.getLcslid());
            }
            BigDecimal djxh = fetchTaskVo.getDjxh();
            BigDecimal nsrdzdah = mapper.selectNsrdzdahByDjxh(djxh);
            try{
                /**
                 * 因为在预警服务中也使用了redis锁，所以这里需要使用redis锁进行限制，避免获取主键冲突
                 */
                if (redisLock.lock(YJ_TASK_LOCK, 5*60L)) {
                    insertYjxx(fetchTaskVo,nsrdzdah);
                }else {
                    throw new BusinessException("任务正在同步处理中,请稍后再试....");
                }
            }catch(BusinessException e){
                //如果插入的时候报错，可能数据已经存在,重新查询补偿一次
                 sbxxViewVo  = getYjxxByLcslid(lcslid);
                 if(sbxxViewVo!=null){
                     isExistSbxx = true;
                 }else{
                     throw new BusinessException("任务启动失败!");
                 }
            }finally {
                redisLock.unlock(YJ_TASK_LOCK);
            }
        }else {
            isExistSbxx = true;
        }
        if(isExistSbxx){
            yjSbxxHzModelMapper.resetSbcsAndTqbz(sbxxViewVo.getSbid());
        }
    }

    public void insertYjxx(FetchTaskVo fetchTaskVo, BigDecimal nsrdzdah) {

        YjSbxxHzModel yjSbxxHzModel = new YjSbxxHzModel();
        yjSbxxHzModel.setNsrdzdah(nsrdzdah);
        yjSbxxHzModel.setCjrq(new Date());
        yjSbxxHzModel.setXgrq(new Date());
        yjSbxxHzModel.setLcslid(fetchTaskVo.getLcslid());
        yjSbxxHzModel.setSssq(fetchTaskVo.getSsq());
        yjSbxxHzModel.setSbpc(fetchTaskVo.getSbpc()==null?1:Integer.parseInt(fetchTaskVo.getSbpc()));
        yjSbxxHzModel.setSbrq(TlUtils.parseString2Date(fetchTaskVo.getSbrq(),"yyyy-MM-dd HH:mm:ss"));
        yjSbxxHzModel.setSbsj(TlUtils.parseString2Date(fetchTaskVo.getSbrq(),"yyyy-MM-dd HH:mm:ss"));
        yjSbxxHzModel.setId(commonService.getDBPk4Admin("YJ_SBXX_HZ"));
        yjSbxxHzModel.setSbywbDm(lcsx4SbywbMap.get(fetchTaskVo.getLcswsxDm()));
        yjSbxxHzModel.setZzsbb(fetchTaskVo.getCkqygllbDm());
        yjSbxxHzModel.setSbzlDm("TSSB");

        yjSbxxHzModel.setTqbz(null);
        yjSbxxHzModel.setTqsj(null);
        yjSbxxHzModel.setSbztDm("20");
        yjSbxxHzModel.setTbcs(0);
        yjSbxxHzModel.setTqcs(0);
        yjSbxxHzModel.setSbcs(999);

        try {
            yjSbxxHzModelMapper.insertSelective(yjSbxxHzModel);
        } catch(Exception e) {
            throw new BusinessException("插入数据异常：lcslid:"+fetchTaskVo.getLcslid()+",错误信息："+e.getMessage());
        }
    }
}
