package com.tl.web.bjts.shzs.controller;

import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.tl.common.ext.utils.GsonUtils;
import com.tl.common.utils.CommonUtils;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.domain.RulesMainProfile;
import com.tl.web.bjts.shzs.model.domain.TlRwTxb;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.BaseIdsDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjBgdgzxxAddDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxUpdateDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxCreateDTO;
import com.tl.web.bjts.shzs.model.dto.sbxx.SbMxbBaseDTO;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.model.vo.sbxx.*;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.SbLcslService;
import com.tl.web.bjts.shzs.service.SbxxhzService;
import com.tl.web.bjts.shzs.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Author Mamf
 * @create 2017/6/19 16:49
 */

@RestController
public class ShzsBizController extends TLBaseController{

    private static final Logger LOGGER = LoggerFactory.getLogger(ShzsBizController.class);

    private static final Pattern PATTERN = Pattern.compile("[\u4e00-\u9fa5]");
    @Autowired
    private SbxxhzService sbxxhzService;
    @Autowired
    private UserService userService;
    @Autowired
    private SbLcslService sbLcslService;
    @Autowired
    private CommonServiceImpl commonService;


    /**
     * 申报任务汇总查询
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/sb/count")
    public SimpleResult getSbrwhzxx(HttpServletRequest request) throws Exception{
        SimpleResult rtn=new SimpleResult();

        TlUserProfile user = commonService.getCurrentUser();

        String czryDm=user.getCzryDm();
        List<Map<String,Object>> list=sbxxhzService.getGroupBySbxxList(czryDm);


        Map<String,Object> map=new HashMap<>(16);
        map.put("total",countXxhZ(list));
        map.put("bizs",list);
        rtn.setMsg("OK");
        rtn.setData(map);
        return  rtn;

    }

    private String countXxhZ(List<Map<String,Object>> list){
        int num=0;
        for(Map<String,Object> map:list){
            String strNum=map.get("num").toString();
            num+=Integer.parseInt(strNum);
        }
        return String.valueOf(num);
    }

    /**
     * 申报任务列表查询
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/sb/view")
    public SimpleResult getSblbxx(HttpServletRequest request) throws Exception{

        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/view】 params：" + reqStr);
        Map<String,String> parmMap=new Gson().fromJson(reqStr,Map.class);

        if(parmMap==null){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        String sbywDm=parmMap.get("sbywDm");
        if(StringUtils.isBlank(sbywDm)){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        String qybs=parmMap.get("qybs")==null?"":parmMap.get("qybs");
        String offset=parmMap.get("offset")==null?"0":parmMap.get("offset");
        String size=parmMap.get("size")==null?"0":parmMap.get("size");
        String zzsbb=parmMap.get("zzsbb")==null?"":parmMap.get("zzsbb");
        String sortname = parmMap.get("sortname")==null?"":parmMap.get("sortname");
        String ascend=parmMap.get("ascend")==null?"":parmMap.get("ascend");
        String flglcd=parmMap.get("flglcd")==null?"":parmMap.get("flglcd");

        String orderSql=" sbrq asc ";
        if(!"".equals(ascend)&&!"".equals(sortname)){
            orderSql=" "+sortname+" "+ ascend +" ";
        }

        Matcher m = PATTERN.matcher(qybs);
        String type;
        if (m.find()) {
            type="nsrmc";
        }else{
            type="qyhgdm";
        }

        int offsetInt=StringUtils.isNotBlank(offset)?Integer.parseInt(offset):0;
        int sizeInt=StringUtils.isNotBlank(size)?Integer.parseInt(size):0;

        TlUserProfile user = commonService.getCurrentUser();
        String czryDm=user.getCzryDm();

        Map<String,Object> map=sbxxhzService.getSblbxxByPage(czryDm,sbywDm,offsetInt,sizeInt,type,qybs,zzsbb,orderSql,flglcd);

        SimpleResult rtn=new SimpleResult();
        rtn.setMsg("OK");
        rtn.setData(map);
        return  rtn;

    }

    @RequestMapping("/sb/sbxx/view")
    public SimpleResult getSbxxDetails(HttpServletRequest request) throws Exception{
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/sbxx/view】 params：" + reqStr);
        Map<String,Object> parmMap=new Gson().fromJson(reqStr,Map.class);
        if(parmMap==null||parmMap.get("lcslid")==null){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }

        //初始化参数
        String lcslid = (String)parmMap.get("lcslid");

        SimpleResult rtn=new SimpleResult();
        SbxxViewVo vo =sbxxhzService.getSbxxDetails2(lcslid);
        vo.setLoginSwjgDm(commonService.getCurrentUser().getSwjgDm());
        rtn.setData(vo);
        return rtn;
    }

    @RequestMapping("/rw/view")
    public SimpleResult queryRwtx(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();

        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/rw/view】 params：" + reqStr);
        Map<String,String> paramMap = new Gson().fromJson(reqStr,new TypeToken<Map<String,String>>(){}.getType());

        TlUserProfile user = commonService.getCurrentUser();
        paramMap.put("czryDm",user.getCzryDm());

        String rwly=StringUtils.trimToEmpty(paramMap.get("rwly"));
        if("".equals(rwly)){
            paramMap.put("rwly","1");
        }

        paramMap.put("sbztDm","30");
        int count = sbxxhzService.getRwtxListCount(paramMap);
        List<RwtxVo> list = sbxxhzService.getRwtxList(paramMap);

        Map<String,Object> map=new HashMap<>(16);
        map.put("rws",list);
        map.put("total",count);
        map.put("offset",paramMap.get("offset"));
        map.put("size",paramMap.get("size"));

        rtn.setMsg("OK");
        rtn.setData(map);

        return rtn;
    }

    @RequestMapping("/rw/update")
    public SimpleResult addRwtx(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();

        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/rw/update】 params：" + reqStr);
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
        TlRwTxb rwtxb = gson.fromJson(reqStr,TlRwTxb.class);

        TlUserProfile user = commonService.getCurrentUser();

        rwtxb.setSwryDm(user.getCzryDm());
        rwtxb.setSwryMc(user.getCzryMc());
        rwtxb.setCjrq(new Date());
        rwtxb.setSwjgDm(user.getSwjgDm());
        rwtxb.setSwjgMc(userService.getSwjgmc(rwtxb.getSwjgDm()));
        rwtxb.setNsrdzdah(sbxxhzService.getNsrdzdah(rwtxb.getYwgjz()));

        if(rwtxb.getId()==null){
            if(StringUtils.isBlank(rwtxb.getLxdh())){
                rwtxb.setLxdh(user.getLxdh());
            }
            rwtxb.setRwztDm("1");
            rwtxb.setRwlxDm("1");
            rwtxb.setRwly("1");
            sbxxhzService.addRwtxb(rwtxb);
        }else{
            //暂不支持更新
            return rtn;
        }

        rtn.setMsg("OK");
        return rtn;
    }

    /**
     * @Description: 获取当前操作人员接单范围
     * @param  request
     * @return  com.tl.web.bjts.shzs.model.SimpleResult<java.lang.String>
     * @Date  2017/10/13
     */
    @PostMapping("sb/jdfw/view")
    public SimpleResult<String> getJdfwms(HttpServletRequest request) {
        SimpleResult rtn = new SimpleResult();

        TlUserProfile user = commonService.getCurrentUser();
        JdfwmsVo result = sbxxhzService.getJdfwms(user.getCzryDm());
        rtn.setData(result);
        return rtn;
    }


    @PostMapping("sb/rgjd/update")
    public SimpleResult updateRgjd(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        String reqStr = CommonUtils.readStreamString(request.getInputStream());
        LOGGER.info("【/sb/rgjd/update】 params：" + reqStr);
        BaseIdsDTO dto = new Gson().fromJson(reqStr,BaseIdsDTO.class);
        if (dto==null||dto.getIds()==null){
            return rtn;
        }else {
            sbxxhzService.updateSbztTO2A(dto);
        }
        return rtn;
    }

    /**
     *  生产免抵退税申报明细表查询
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("sb/scmdts/list")
    public SimpleResult listScmdtsMxb(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        SbMxbBaseDTO dto = getAndCheckParam(request.getInputStream(), SbMxbBaseDTO.class);

        YwblxxVO ywblxxVo = sbLcslService.getYwblxxFormJsxt(dto.getLcslid());
        dto.setYwblxxVo(ywblxxVo);

        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        //获取列表数据
        List<SbMdtsMxbVO> retList = sbxxhzService.listScmdtsMxb(dto);
        //获取合计数据
        SbMdtsMxbSumVO retSum = sbxxhzService.sumScmdtsMxb(dto);
        rtn.setData(dealPageInfoIncludeSum(retList,retSum));
        return rtn;
    }

    /**
     *  外贸免退税出口明细与进货明细数据查询
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("sb/wmmts/list")
    public SimpleResult listWmmtsMxb(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        SbMxbBaseDTO dto = getAndCheckParam(request.getInputStream(), SbMxbBaseDTO.class);

        YwblxxVO ywblxxVo = sbLcslService.getYwblxxFormJsxt(dto.getLcslid());
        dto.setYwblxxVo(ywblxxVo);
        //获取列表数据
        List retList = sbxxhzService.listWmmtsMxb(dto);
        //获取合计数据
        SbMtsMxbSumVO retSum = sbxxhzService.sumWmmtsMxb(dto);
        rtn.setData(dealPageInfoIncludeSum(retList,retSum));
        return rtn;
    }

    /**
     *  外综服代办退税申报明细表查询
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("sb/wzfdbts/list")
    public SimpleResult listWzfdbtsMxb(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        SbMxbBaseDTO dto = getAndCheckParam(request.getInputStream(), SbMxbBaseDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        //获取列表数据
        List<SbWzfdbtsMxbVO> retList = sbxxhzService.listWzfdbts(dto);
        //获取合计数据
        SbWzfdbtsMxbSumVO retSum = sbxxhzService.sumWzfdbtsMxb(dto);
        rtn.setData(dealPageInfoIncludeSum(retList,retSum));
        return rtn;
    }

    /**
     *  购进自用货物申报明细表查询
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("sb/gjzyhw/list")
    public SimpleResult listGjzyhwMxb(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        SbMxbBaseDTO dto = getAndCheckParam(request.getInputStream(), SbMxbBaseDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        //获取列表数据
        List<SbGjzyhwMxbVO> retList = sbxxhzService.listGjzyhwMxb(dto);
        //获取合计数据
        SbGjzyhwMxbSumVO retSum = sbxxhzService.sumGjzyhwMxb(dto);
        rtn.setData(dealPageInfoIncludeSum(retList,retSum));
        return rtn;
    }

    /**
     *  重要事项提醒
     *  包括审单核查在办任务、出口退税岗位在办、待复函的核实函（待定）
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("items/notice")
    public SimpleResult itemsNotice(HttpServletRequest request) {
        SimpleResult rtn = new SimpleResult();
        ItemNoticeVO ret = sbxxhzService.itemsNotice();
        rtn.setData(ret);
        return rtn;
    }

    /**
     *  获取出口口岸信息
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("dict/kaxx")
    public SimpleResult listKaxxDict(HttpServletRequest request) throws Exception{
        SimpleResult rtn = new SimpleResult();
        Map map = getAndCheckParam(request.getInputStream(), Map.class);
        if (map == null || StringUtils.isBlank( (String)map.get("kaxx"))){
            throw new BusinessException(ResultCode.INVALID_PARAM);
        }
        String kaxx = (String)map.get("kaxx");
        List<KaxxDictVO> retList = sbxxhzService.listKaxxDict(kaxx);
        rtn.setData(retList);
        return rtn;
    }

    @RequestMapping("/szzb/yjxx/keylist")
    public SimpleResult initBizKeyList(HttpServletRequest request) throws Exception{
        SimpleResult rtn=new SimpleResult();
        List<RulesMainProfile> keyList= sbxxhzService.getAllKeyList();
        rtn.setData(keyList);
        return rtn;
    }

    /**
     * 生成事中指标预警信息
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/szzb/yjxx/create")
    public SimpleResult yjxxCreate(HttpServletRequest request) throws Exception{
        SimpleResult rtn=new SimpleResult();
        YjxxCreateDTO dto = getAndCheckParam(request.getInputStream(), YjxxCreateDTO.class);
        dto.setCzryDm(commonService.getCurrentLoginName());
        YjxxCreateVO vo = sbxxhzService.yjxxCreate(dto);
        rtn.setData(vo);
        return rtn;
    }
    /**
     * 更新事中指标预警信息
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/szzb/yjxx/update")
    public SimpleResult yjxxUpdate(HttpServletRequest request) throws Exception{
        SimpleResult rtn=new SimpleResult();
        YjxxUpdateDTO dto = getAndCheckParam(request.getInputStream(), YjxxUpdateDTO.class);
        LOGGER.info("【/szzb/yjxx/update】 params：" + GsonUtils.getDefaultGson().toJson(dto));
        sbxxhzService.yjxxUpdate(dto);
        return rtn;
    }


    /**
     * 新增报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("yj/bgdgzxx/add")
    public SimpleResult addBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxAddDTO dto = getAndCheckParam(request.getInputStream(), YjBgdgzxxAddDTO.class);
        sbLcslService.addYjBgdgzxx(dto);
        return rtn;
    }

    /**
     * 编辑报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("yj/bgdgzxx/update")
    public SimpleResult updateBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        YjBgdgzxxAddDTO dto = getAndCheckParam(request.getInputStream(), YjBgdgzxxAddDTO.class);
        sbLcslService.updateYjBgdgzxx(dto);
        return rtn;
    }

    /**
     * 删除报关单关注信息
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("yj/bgdgzxx/del")
    public SimpleResult delBgdgzxx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        Map<String, String> paramMap = getParam(request.getInputStream(), Map.class);
        String djxh = paramMap.get("djxh");
        String ckbgdh = paramMap.get("ckbgdh");
        if (StringUtils.isBlank(djxh) || StringUtils.isBlank(ckbgdh)) {
            throw new BusinessException("金三登记序号和报关单号不能为空");
        }
        sbLcslService.deleteYjBgdgzxx(djxh, ckbgdh);
        return rtn;
    }

}
