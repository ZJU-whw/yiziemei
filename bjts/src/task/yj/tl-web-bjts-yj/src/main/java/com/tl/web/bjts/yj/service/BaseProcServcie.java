package com.tl.web.bjts.yj.service;

import com.tl.web.bjts.yj.dao.SysSequenceMapper;
import com.tl.web.bjts.yj.dao.YjSbxxHzModelMapper;
import com.tl.web.bjts.yj.dao.YsMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.exception.BusinessException;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.domain.SysSequence;
import com.tl.web.bjts.yj.model.domain.YjSbxxHzModel;
import com.tl.web.bjts.yj.model.vo.FetchTaskVo;
import com.tl.web.bjts.yj.utils.Tools;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2017/11/21.
 * @Description:
 */
@Service
public class BaseProcServcie {

    @Autowired
    YsMapper ysMapper;

    @Autowired
    private SysSequenceMapper sysSequenceMapper;

    @Autowired
    private YjSbxxHzModelMapper yjSbxxHzModelMapper;

    private final Long DEFAULT_VALUE = 1000L;

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

    Logger logger = LoggerFactory.getLogger(BaseProcServcie.class);

    public Long getPrimaryKey(String tableName){
        synchronized(this) {
            SysSequence sysSequence = sysSequenceMapper.selectByPrimaryKey(tableName);
            if (sysSequence == null) {
                SysSequence newSequence = new SysSequence();
                newSequence.setCurvalue(DEFAULT_VALUE);
                newSequence.setTblname(tableName);
                sysSequenceMapper.insert(newSequence);
                return DEFAULT_VALUE;
            }
            Long nextValue = sysSequence.getCurvalue() + 1L;
            sysSequence.setCurvalue(nextValue);
            sysSequenceMapper.updateByPrimaryKeySelective(sysSequence);
            return nextValue;
        }
    }

    /**
     * 记录异常日志信息
     * @param ysxx
     * @param logMsg
     */
    protected Long insertCzlog(TaskVo ysxx,String logMsg){
        Map<String, Object> fail = new HashMap<String, Object>();
        Long retLong=getPrimaryKey("CZ_LOG");
        fail.put("id", retLong);
        fail.put("lcslid", ysxx.getId().toString());
        fail.put("code", "999");
        if(StringUtils.isNotBlank(logMsg) && logMsg.length()>1000){
            logMsg=logMsg.substring(0,1000);
        }
        fail.put("sbyy", logMsg);
        ysMapper.insertCzlog(fail);
        return retLong;
    }


    protected void changeDataSource(String targe){
        MultipleDataSourceHolder.clearDBType();
        MultipleDataSourceHolder.setDBType(targe);
    }

    protected void clearDBType(){
        MultipleDataSourceHolder.clearDBType();
    }

    @Transactional
    public void insertYjxx(FetchTaskVo fetchTaskVo, BigDecimal nsrdzdah) {

        YjSbxxHzModel yjSbxxHzModel = new YjSbxxHzModel();
        yjSbxxHzModel.setNsrdzdah(nsrdzdah);
        yjSbxxHzModel.setCjrq(new Date());
        yjSbxxHzModel.setXgrq(new Date());
        yjSbxxHzModel.setLcslid(fetchTaskVo.getLcslid());
        yjSbxxHzModel.setSssq(fetchTaskVo.getSsq());
        yjSbxxHzModel.setSbpc(fetchTaskVo.getSbpc()==null?1:Integer.parseInt(fetchTaskVo.getSbpc()));
        yjSbxxHzModel.setSbrq(Tools.parseString2Date(fetchTaskVo.getSbrq(),"yyyy-MM-dd HH:mm:ss"));
        yjSbxxHzModel.setSbsj(Tools.parseString2Date(fetchTaskVo.getSbrq(),"yyyy-MM-dd HH:mm:ss"));
        yjSbxxHzModel.setId(getPrimaryKey("YJ_SBXX_HZ"));
        yjSbxxHzModel.setSbywbDm(lcsx4SbywbMap.get(fetchTaskVo.getLcswsxDm()));
        yjSbxxHzModel.setZzsbb(fetchTaskVo.getCkqygllbDm());
        yjSbxxHzModel.setSbzlDm("TSSB");



        yjSbxxHzModel.setTqbz(null);
        yjSbxxHzModel.setTqsj(null);
        yjSbxxHzModel.setSbztDm("20");
        yjSbxxHzModel.setTbcs(0);
        yjSbxxHzModel.setTqcs(0);

        try {
            yjSbxxHzModelMapper.insertSelective(yjSbxxHzModel);
        } catch(Exception e) {
            throw new BusinessException("插入数据异常：lcslid:"+fetchTaskVo.getLcslid()+",错误信息："+e.getMessage());
        }
    }
}
