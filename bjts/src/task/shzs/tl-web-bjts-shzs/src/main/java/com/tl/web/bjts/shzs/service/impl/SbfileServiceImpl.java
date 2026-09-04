package com.tl.web.bjts.shzs.service.impl;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.children.DocFileinfoChildMapper;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.exception.BusinessMsgCons;
import com.tl.web.bjts.shzs.model.SbfileVo;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.vo.sbfile.SbfileHzVO;
import com.tl.web.bjts.shzs.model.vo.sbfile.ShzsSbbwVO;
import com.tl.web.bjts.shzs.service.ISbfileService;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import com.tl.web.bjts.shzs.utils.HttpClientUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @描述: 生成申报文件服务
 * @作者: likun
 * @时间: 2020/9/21 15:08
 */
@Service
public class SbfileServiceImpl implements ISbfileService{
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
    @Autowired
    DocFileinfoChildMapper docFileinfoChildMapper;
    @Autowired
    AppProperties appProperties;

    // 申报表业务表代码对应附表清单文件名、申报文件名相关信息{key:申报业务表代码  value[生成的文件名中是否带所属期，生成文件名中包含的简称]}
    private static Map<String, String[]> sbywbdmFbqd = new HashMap<String, String[]>();
    //生成的申报文件名称中含有申报批次的申报业务表代码串
    private static String sbywbDmIncludeSpbc = "A0301001,A0401001,A0402001,A0404001,A0310001,A0410001";
    static {
        //申报表业务表代码对应附表清单文件名
        sbywbdmFbqd.put("A0101001", new String[]{"N","rdxx"});//出口退(免)税备案
        sbywbdmFbqd.put("A0102001", new String[]{"N","rdbg"});//出口退(免)税备案变更
        sbywbdmFbqd.put("A0103001", new String[]{"N","rdzx"});//出口退(免)税备案撤回(特殊)
        sbywbdmFbqd.put("A0105001", new String[]{"N","jtcy"});//集团企业备案
        sbywbdmFbqd.put("A0107001", new String[]{"N","xthh"});//先退税后核销资格申请申报
        sbywbdmFbqd.put("A0109001", new String[]{"N","wtdb_ba"});//代办退税情况备案（生产企业）
        sbywbdmFbqd.put("A0109002", new String[]{"N","wtdb_ch"});//代办退税情况备案（生产企业撤回）
        sbywbdmFbqd.put("A0110001", new String[]{"N","dbts_ba"});//代办退税情况备案（综服企业）

        sbywbdmFbqd.put("A0201001", new String[]{"Y","dlzm"});//代理出口证明申报
        sbywbdmFbqd.put("A0201002", new String[]{"Y","dljk"});//代理进口证明申报
        sbywbdmFbqd.put("A0201003", new String[]{"Y","wtck"});//委托代理证明申报
        sbywbdmFbqd.put("A0201004", new String[]{"Y","ck2nx"});//出口转内销证明申报
        sbywbdmFbqd.put("A0201005", new String[]{"Y","tgbs"});//退运已补税(未退税)证明申报
        sbywbdmFbqd.put("A0201007", new String[]{"Y","zbzm"});//中标证明通知书申报
        sbywbdmFbqd.put("A0202001", new String[]{"Y","bbzm"});//补办出口退税有关证明
        sbywbdmFbqd.put("A0203001", new String[]{"Y","llhx"});//来料加工核销证明申报
        sbywbdmFbqd.put("A0203002", new String[]{"Y","lljg"});//来料加工免税证明申报
        sbywbdmFbqd.put("A0205001", new String[]{"Y","jyhx"});//出口卷烟免税核销证明申报
        sbywbdmFbqd.put("A0205002", new String[]{"Y","zyjy"});//准予免税购进出口卷烟证明申报
        sbywbdmFbqd.put("A0205003", new String[]{"Y","jyzm"});//出口卷烟已免税证明申报

        sbywbdmFbqd.put("A0301001", new String[]{"Y","wmsb"}); //外贸免退税
        sbywbdmFbqd.put("A0302001", new String[]{"Y","txfs"});//出口非自产货物退消费税申报
        sbywbdmFbqd.put("A0303001", new String[]{"Y","ygsb"});//出口已使用旧设备免退税申报
        sbywbdmFbqd.put("A0304001", new String[]{"Y","zyhw"});//购进自用货物
        sbywbdmFbqd.put("A0305001", new String[]{"Y","scsb"});//生产免抵退税
        sbywbdmFbqd.put("A0306001", new String[]{"Y","jlhx"});//生产进料加工核销
        sbywbdmFbqd.put("A0307001", new String[]{"Y","jlba"});//生产进料加工计划分配率备案
        sbywbdmFbqd.put("A0308001", new String[]{"Y","jlbg"});//生产进料加工计划分配率调整
        sbywbdmFbqd.put("A0310001", new String[]{"Y","dbts_sb"});//综服企业代办退税申报

        sbywbdmFbqd.put("A0401001", new String[]{"Y","xxcx"});//出口退税电子信息查询申报
        sbywbdmFbqd.put("A0404001", new String[]{"Y","cksh"});//（未认定）收汇申报表
        sbywbdmFbqd.put("A0409001", new String[]{"N","txfw"});//短信提醒申报
        sbywbdmFbqd.put("A0409002", new String[]{"N","fqms"});//放弃免税权申报
        sbywbdmFbqd.put("A0409003", new String[]{"N","fqlsl"});//放弃零税率申报
        sbywbdmFbqd.put("A0409004", new String[]{"N","fqts"});//放弃退免税申报
        sbywbdmFbqd.put("A0409005", new String[]{"N","hftmsq"});//恢复适用出口退（免）税政策声明
        sbywbdmFbqd.put("A0410001", new String[]{"Y","jhpzht"});//进货凭证信息回退申请
        sbywbdmFbqd.put("A0410002", new String[]{"Y","chsb"});//企业撤回申报申请
        sbywbdmFbqd.put("A0410003", new String[]{"Y","bmdl"});//边贸代理出口备案

        sbywbdmFbqd.put("A0503001", new String[]{"N","aqypd"});//一类企业评定受理
        sbywbdmFbqd.put("A0503002", new String[]{"N","flglpd"});//分类管理复评申请
        sbywbdmFbqd.put("Z0202002", new String[]{"Y","zfzm"});//作废出口退（免）税证明
    }

    /**
     * 下载申报报文文件
     * 1、通过http方式从申报服务获取申报报文
     * 2、申报报文写入文件然后落地
     * @param sbid  申报id
     * @return SbfileVo{sbid、fileSize、fileUrl、note}
     */
    public SbfileVo downloadSbsj(Long sbid) {
        //生成返回的vo对象
        SbfileVo vo = new SbfileVo();

        // 1、通过http方式获取申报报文
        String sbbw = ""; //申报报文
        Map reqMap = new HashMap();
        reqMap.put("sbid",sbid);
        String reqParam = new Gson().toJson(reqMap, new TypeToken<Map>(){}.getType());
        SimpleResult rtn = null;
        try {
            String res = HttpClientUtils.doPost4Str(appProperties.getSbServiceUrl() + ConstUtil.URL_SHZS_GETSBBW,reqParam,null);
            rtn = new Gson().fromJson(res,new TypeToken<SimpleResult>(){}.getType());
        } catch (Exception e) {
            LOGGER.error("sbid={}-通过http调用生成申报报文服务错误={}",sbid,e);
            throw new BusinessException("sbid=" + sbid + "通过http调用成申报报文服务错误：" + e);
        }
        if(rtn == null){
            LOGGER.error("sbid={}-通过http调用成申报报文服务错误,返回对象为空",sbid);
            throw new BusinessException("sbid=" + sbid + "通过http调用生成申报报文服务出错,返回对象为空");
        }
        if(rtn.getCode() == 0){
            String sbbwData = new GsonBuilder().serializeNulls().create().toJson(rtn.getData());
            if(StringUtils.isBlank(sbbwData)){
                LOGGER.error("sbid={}-通过http调用生成申报报文服务错误,返回申报报文字符串为空",sbid);
                throw new BusinessException("sbid=" + sbid + "调用生成申报报文服务错误,返回申报报文字符串为空");
            }
            ShzsSbbwVO shzsSbbwVO = new Gson().fromJson(sbbwData,new TypeToken<ShzsSbbwVO>(){}.getType());
            if(shzsSbbwVO == null){
                LOGGER.error("sbid={}-通过http调用生成申报报文服务错误,返回申报报文对象为空",sbid);
                throw new BusinessException("sbid=" + sbid + "调用生成申报报文服务错误,返回申报报文对象为空");
            }
            sbbw = shzsSbbwVO.getSbbw();
            LOGGER.info("sbid={}-通过http调用生成申报报文服务成功，申报报文内容={}",sbid,sbbw);
        }else{
            LOGGER.error("sbid={}-通过http调用生成申报报文服务错误,返回代码={}-返回信息-{}",sbid,rtn.getCode(),rtn.getMsg());
            throw new BusinessException("sbid=" + sbid + "调用生成申报报文服务错误,返回代码="+ rtn.getCode() + "，返回信息=" + rtn.getMsg());
        }
        if(StringUtils.isBlank(sbbw)){
            LOGGER.error("sbid={}-通过http调用生成申报报文服务错误,返回申报报文内容为空",sbid);
            throw new BusinessException("sbid=" + sbid + "通过http调用生成申报报文服务错误,返回申报报文内容为空");
        }

       // 2、申报报文写入文件然后落地
        File file = null;
        //申报文件根目录
        String rootPath = appProperties.getXmlPathDir();
        file = new File(rootPath);
        if (!file.exists()) {
            file.mkdirs();
        }
        //处理申报文件名称
        //获取申报文件需要的汇总表信息
        SbfileHzVO sbfileHzVO = docFileinfoChildMapper.getSbfileHz(sbid);
        //申报业务表代码
        String sbywbDm = sbfileHzVO.getSbywbDm();
        //文件名称  规范：海关代码_所属时期_(外贸：批次)_**.xml 比如 外贸：3301299999_201704_01_wmsb.xml   生产3301299999_201704_scsb.xml
        String fileName = sbfileHzVO.getQyhgdm() + ConstUtil.IDENTIFIER_UNDERLINE;
        if (sbywbdmFbqd.get(sbywbDm) != null) {
            //文件命名：带有申报年月
            if (sbywbdmFbqd.get(sbywbDm)[0].equals("Y")) {
                fileName = fileName +sbfileHzVO.getSssq() + ConstUtil.IDENTIFIER_UNDERLINE;
            }
            //文件命名+批次：外贸免退税、无相关电子信息查询、无相关电子信息备案、（未认定）收汇申报、综服企业代办退税申报、发票误勾选退税申请带批次带批次
            if (StringUtils.isNotBlank(sbywbDm) && sbywbDmIncludeSpbc.contains(sbywbDm)) {
                fileName = fileName + String.format("%02d", Integer.valueOf(sbfileHzVO.getSbpc())) + ConstUtil.IDENTIFIER_UNDERLINE;
            }
            //文件命名：每个业务带有不同的名称，比如生产免抵退税 scsb
            fileName = fileName + sbywbdmFbqd.get(sbywbDm)[1] + ".xml";
        } else {
            LOGGER.error("申报业务代码={}没有配置生成的申报文件名。",sbywbDm);
            throw new BusinessException("申报业务代码：" + sbywbDm + "没有配置生成的申报文件名。");
        }

        file = new File(rootPath + fileName);
        //写入到文件中
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            fos.write(sbbw.getBytes());
        } catch (IOException e) {
            LOGGER.error("sbid={}写入申报文件出错{}：",sbid,e);
            throw new BusinessException(BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR);
        } finally {
            try {
                fos.close();
            } catch (IOException e) {
                LOGGER.error("sbid={}关闭文件流出错{}：",sbid,e);
                throw new BusinessException(BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR);
            }
        }
        //封装返回vo
        vo.setSbid(sbid);
        vo.setFileSize(file.length());
        vo.setNote("");
        vo.setFileUrl( appProperties.getXmlUrlPath().concat(fileName));
        vo.setSbFile(file);
        vo.setFileName(fileName);
        return  vo;
    }
}
