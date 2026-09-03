package com.tl.bjts.sw.controller;

import com.github.pagehelper.PageHelper;
import com.tl.bjts.sw.annotation.RwclYbclAfter;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.conf.FileConfig;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.*;
import com.tl.bjts.sw.model.dto.*;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.RwglYbclService;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.bjts.sw.service.TjfxService;
import com.tl.bjts.sw.utils.JxlExcelUtil;
import com.tl.bjts.sw.utils.PerConst;
import com.tl.bjts.sw.utils.RwglYbclEnum;
import com.tl.bjts.sw.utils.TlConst;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.GsonUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Stream;

/**
 * @Author：Mamf
 * @Date: 2019/9/16.
 * @Description:
 */
@RequestMapping("tjfx")
@RestController
public class TjfxController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    //同比占比需要转换为%的key值
    String tbzbKey[] = {"USD_AMT_TB","USD_AMT_ZB","TS_AMT_TB","TS_AMT_ZB","TSE_TB","TSE_ZB","JHAMT_TB","JHAMT_ZB","TB"};

    @Autowired
    TjfxService tjfxService;

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    JxlExcelUtil jxlExcelUtil;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    RwglYbclService rwglYbclService;

    @Autowired
    AppProperties appProperties;

    private final String callback= "<script>top.tools.info(\"%s\");</script>";

    @PostMapping("loaddata")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    @RequiresPermissions(logical= Logical.OR,value={PerConst.F_CKHGFB_CX,PerConst.F_CKJGFS_CX,PerConst.F_CKMYGJFB_CX,PerConst.F_CKQYPMSH_CX,
                         PerConst.F_CKSPTSLFB_CX, PerConst.F_DQCKTS_CX,PerConst.F_FDLSPCK_CX,PerConst.F_SCQYHYFB_CX,PerConst.F_WMGHQYFX_CX})
    @RwclYbclAfter
    public SimpleResult loaddata(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        //统计分析主对象
        TjfxMainDTO mainDTO = getAndCheckParam(request.getInputStream(), TjfxMainDTO.class);
        //任务后置服务对象
        RwglYbclAfterDTO rwglYbclDTO = new RwglYbclAfterDTO();
        try {
            //增加任务管理前置服务
            tjfxService.addBeforeService(mainDTO,rwglYbclDTO,false);

            //获取统计的列表数据
            List list = queryData(mainDTO,rwglYbclDTO,false);

            rtn.setData(dealPageInfo(list));

        }catch (BusinessException be){
            //可供用户选择直接查看数据或者重新统计刷新的情况下，返回前端的代码为100，此时需要做一步额外处理，把data数据返回到前端
            if(be.getCode() == TlConst.TJFX_RWZT_CLWB_REFRESH){
                List list = queryData(mainDTO,rwglYbclDTO,false);
                rtn.setData(dealPageInfo(list));
            }
            rtn.setCode(be.getCode());
            rtn.setMsg(be.getMsg());
        }finally {
            //增加后置服务(封装后置服务需要的参数,真正的后置服务处理逻辑在拦截器中执行)
            rwglYbclService.addAfterServiceParam(rwglYbclDTO,rtn);
        }
        return rtn;
    }

    @PostMapping("loaddata/export")
//    @RequiresRoles(logical= Logical.OR,value={"czy"})
    @RequiresPermissions(logical= Logical.OR,value={PerConst.F_CKHGFB_DC,PerConst.F_CKJGFS_DC,PerConst.F_CKMYGJFB_DC,PerConst.F_CKQYPMSH_DC,
            PerConst.F_CKSPTSLFB_DC, PerConst.F_DQCKTS_DC,PerConst.F_FDLSPCK_DC,PerConst.F_SCQYHYFB_DC,PerConst.F_WMGHQYFX_DC})
    public void loaddataExport(String data,HttpServletRequest request, HttpServletResponse response) throws IOException {
        String reqStr = data.replace("&quot;", "\"");
        TjfxMainDTO mainDTO = getParam(reqStr, TjfxMainDTO.class);
        String bbdm = mainDTO.getBbdm();

        String point= tjbbBasisService.getExcelDataPoint(bbdm);

        String[] split = point.split(",");
        int col = Integer.parseInt(split[0]);
        int row = Integer.parseInt(split[1]);

        int headCol = Integer.parseInt(split[2]);
        int headRow = Integer.parseInt(split[3]);
        int endRow = Integer.parseInt(split[4]);


        TbxxExtDTO zbxx=GenZbxx(mainDTO);

        String bbmc=split[5];

        String filename =bbmc+"-"+new SimpleDateFormat("yyyyMMdd").format(new Date());
        String sheetName="Sheet1";

        mainDTO.setPageNo(1);
        mainDTO.setPageSize(RowBounds.NO_ROW_LIMIT);
        //增加任务管理前置服务
        tjfxService.addBeforeService(mainDTO,null,true);

        //获取统计的列表数据
        List list = queryData(mainDTO,null,true);

        List<TjbbColModel> columns = tjbbBasisService.getColumns4Tjfx(bbdm);

        List<String> fnames = new ArrayList<>();
        for(TjbbColModel model:columns){
            fnames.add(model.getFname());
        }
        File file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xls");
        if(file==null){
            file =new File(appProperties.getTemplateTjbbDir()+bbdm+".xlsx");
        }
        InputStream stream = new FileInputStream(file);

        // 设置调用的方法名
        Map<String, String> methodMap = new HashMap<String, String>();
        // 方法可以在JxlExcelUtils定义，会根据名字进行调用，可以用来处理一些数据，如decode之类的功能
        //methodMap.put("lx", "lxConverter");
        ServletOutputStream out = response.getOutputStream();

//        if (null != dataList
//                && dataList.size() > 0) {
        try {
            jxlExcelUtil.exportTemplateExcelStream(response, out,stream, filename, sheetName,fnames,
                    list, methodMap,col,row,headCol,headRow,endRow,zbxx);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            response.setContentType("text/html");
            out.print(new String(getJsCallback("", BusinessMsgCons.CONTROLLER_REPORTEXCEL_DOWNLOADERROR)
                    .getBytes("UTF-8"),"iso8859-1"));
            out.flush();
            out.close();
        }
    }

    private TbxxExtDTO GenZbxx(TjfxMainDTO mainDTO){
        TbxxExtDTO zbxx=new TbxxExtDTO();
        zbxx.setBbdm(mainDTO.getBbdm());
        Date cksjStart = mainDTO.getCxtjDTO().getCksjStart();
        Date cksjEnd = mainDTO.getCxtjDTO().getCksjEnd();
        SimpleDateFormat sdf =new SimpleDateFormat("yyyy年MM月dd日");
        String ssqb=sdf.format(cksjStart)+" 至 "+sdf.format(cksjEnd);
        zbxx.setSsny(ssqb);
        zbxx.setSwjgmc(mainDTO.getCxtjDTO().getSwjgMc());
        zbxx.setQylx(StringUtils.trimToEmpty(mainDTO.getCxtjDTO().getQylxMc()));
        zbxx.setMyg("");
        if("1".equals(mainDTO.getCxtjDTO().getPmlx())){
            zbxx.setPmtj("按出口额排名");
        }else if("2".equals(mainDTO.getCxtjDTO().getPmlx())){
            zbxx.setPmtj("按退税额排名");
        }else{
            zbxx.setPmtj("");
        }

        StringBuffer sb=new StringBuffer();
        boolean isFisrt=true;
        StateVo stateVo=tjfxService.initStates();
        List<StateVo.State> states = stateVo.getStates();
        List<StateVo.Continent> contis = stateVo.getContis();
        List<StateVo.Continent> areas = stateVo.getAreas();
        if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getDqcode())){
            //大洲
            for(String dqcode:mainDTO.getCxtjDTO().getDqcode()){
                for(StateVo.Continent  obj: contis){
                    if(obj.getCode().equals(dqcode)){
                        if(isFisrt){
                            sb.append(obj.getName());
                            isFisrt=false;
                        }else{
                            sb.append("、").append(obj.getName());
                        }

                    }
                }
            }
            //经济共同体
            for(String dqcode:mainDTO.getCxtjDTO().getDqcode()){
                for(StateVo.Continent  obj: areas){
                    if(obj.getCode().equals(dqcode)){
                        if(isFisrt){
                            sb.append(obj.getName());
                            isFisrt=false;
                        }else{
                            sb.append("、").append(obj.getName());
                        }

                    }
                }
            }
        }else if(!CollectionUtils.isEmpty(mainDTO.getCxtjDTO().getGbcode())){
            for(String gbcode:mainDTO.getCxtjDTO().getGbcode()){
                for(StateVo.State  obj: states){
                    if(obj.getCode().equals(gbcode)){
                        if(isFisrt){
                            sb.append(obj.getName());
                            isFisrt=false;
                        }else{
                            sb.append("、").append(obj.getName());
                        }

                    }
                }
            }
        }
        if(sb.toString().length()>10){
            zbxx.setMyg(sb.toString().substring(0,10)+"...");
        }else{
            zbxx.setMyg(sb.toString());
        }
        return zbxx;
    }

    @Transactional
    private List queryData(TjfxMainDTO mainDTO,RwglYbclAfterDTO rwglYbclDTO,boolean isExportExcel){
        //报表代码
        String bbdm = mainDTO.getBbdm();
        List list=new ArrayList();
        if("D01002".equals(bbdm)){//出口退税基本情况统计
            list = tjfxService.loadD01002(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01003".equals(bbdm)){ //分大类商品出口数据统计
            list = tjfxService.loadD01003(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01004".equals(bbdm)){ //出口贸易国家分布统计
            list = tjfxService.loadD01004(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01005".equals(bbdm)){ //出口企业排名情况统计
            list = tjfxService.loadD01005(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01006".equals(bbdm)){ //出口商品退税率分布情况统计
            list = tjfxService.loadD01006(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01007".equals(bbdm)){ //出口企业行业分布情况统计
            list = tjfxService.loadD01007(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01008".equals(bbdm)){ //出口海关分布情况统计
            list = tjfxService.loadD01008(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01009".equals(bbdm)){ //出口监管方式情况统计
            list = tjfxService.loadD01009(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("D01010".equals(bbdm)){ //外贸供货企业分析
            list = tjfxService.loadD01010(mainDTO,rwglYbclDTO,isExportExcel);
        }else if("CX10001".equals(bbdm)){ //出口退税审核审批表查询
            list = tjfxService.loadCX10001(mainDTO,rwglYbclDTO,isExportExcel);
        }

        //同比(*100)、占比 加上百分号
        if(!CollectionUtils.isEmpty(list)){
            Stream<Map> stream = list.stream();
            stream.forEach(item ->{
                for(String key :tbzbKey){
                    boolean containsKey = item.containsKey(key);
                    if(containsKey){
                        Object value = item.get(key);
                        if(value != null){
                            if(key.contains("TB")){ //同比的数值需要先乘以100,占比在sql脚本中已作处理，这里不做处理
                                BigDecimal tbValue = ((BigDecimal)value).multiply(new BigDecimal(100));
                                value = tbValue;
                            }
                            item.put(key,String.format("%.2f",(BigDecimal)value).concat("%"));
                        }
                    }
                }
            });
        }
        return list;
    }

    /**
     * 查询出口退税和外贸出口情况E01001的数据
     * @param taskDTO
     * @return
     */
    private List queryDataE01001(TjbbTaskDTO taskDTO,RwglYbclAfterDTO rwglYbclDTO){
        String bbdm = taskDTO.getBbdm(); //报表代码
        String ssny = taskDTO.getSsny(); //所属年月
        String qxdm = commonService.getQxdm(); //权限代码
        String swjgDm = commonService.getCurrentUser().getSwjgDm(); //税务机关代码

        //根据任务类型和任务hash 查询是否已经存在任务数据
        RwglYbclXxzbModel paramModel = new RwglYbclXxzbModel();
        paramModel.setRwlx(RwglYbclEnum.valueOf(bbdm).getRwlx());
        paramModel.setRwhash(taskDTO.getPramHash());
        RwglYbclXxzbModel retModel  = rwglYbclService.getRwglYbclByPk(paramModel);

        //任务表中不存在或者已经存在并且上次刷新时间超过规定的时间，此时重新刷新数据
        if(retModel == null || (retModel != null && retModel.getFrtime() != null)
                && retModel.getFrtime().before(DateUtils.addDays(new Date(),org.springframework.util.StringUtils.isEmpty(appProperties.getRefreshPeriod4E01001()) ? -7: appProperties.getRefreshPeriod4E01001()))){
            tjfxService.initE01001Data(ssny,null,qxdm,swjgDm);
            //设置异步处理任务-刷新标志为ture
            rwglYbclDTO.setFreshFlag(true);
        }
        List loaddata = tjbbBasisService.loaddata(bbdm, ssny, taskDTO);
        return loaddata;
    }

    private String getJsCallback(String status,String message){
        return String.format(callback,message);
    }


    @PostMapping("states")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult getStates(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        StateVo stateVo=tjfxService.initStates();

        rtn.setData(stateVo);
        return rtn;
    }

    @PostMapping("spml")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult getSpml(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        List<SpmlModel> retList=tjfxService.initSpdlList();

        Map p=new HashMap();
        p.put("spdl",retList);

        rtn.setData(p);
        return rtn;
    }

    @PostMapping("wmghqymx")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult getGhqymx(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjfxMainDTO mainDTO = getAndCheckParam(request.getInputStream(), TjfxMainDTO.class);


        List<WmGhqyMxVo> retList=tjfxService.getWmghqymx(mainDTO);

        rtn.setData(dealPageInfo(retList));
        return rtn;
    }

    @PostMapping("year")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult getYears(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        List<String> retList=tjfxService.getYears();

        Map map =new HashMap();
        map.put("rows",retList);
        rtn.setData(map);
        return rtn;
    }

    /**
     * 统计分析 - 出口退税和外贸出口情况:初始化数据
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("initE01001")
    @RequiresPermissions(PerConst.F_CKTSWMCK_XZQB)
    public SimpleResult initE01001(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();

        TjbbTaskDTO param = getParam(request.getInputStream(), TjbbTaskDTO.class);

        String ssny = param.getSsny();

        tjfxService.initE01001(ssny);

        return rtn;
    }

    /**
     * 统计分析 - 出口退税和外贸出口情况:刷新数据
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("flushE01001")
    @RequiresPermissions(PerConst.F_CKTSWMCK_SX)
    @RwclYbclAfter
    public SimpleResult flushE01001(HttpServletRequest request) throws IOException {
        SimpleResult rtn=new SimpleResult();
        TjbbTaskDTO taskDTO = getParam(request.getInputStream(), TjbbTaskDTO.class);
        RwglYbclAfterDTO rwglYbclDTO = new RwglYbclAfterDTO();
        try {
           //增加任务管理前置服务
            rwglYbclDTO.setCode(taskDTO.getBbdm()); //任务代码
            rwglYbclDTO.setRwhash(tjfxService.getE01001Hash(taskDTO)); //任务的hash
            rwglYbclDTO.setRwbw(GsonUtils.getDefaultGson().toJson(taskDTO));
            tjfxService.addBeforeServiceCommon(rwglYbclDTO, TlConst.SF4NO);

            //询出口退税和外贸出口情况E01001的数据
            List loaddata = queryDataE01001(taskDTO,rwglYbclDTO);
            rtn.setData(dealPageInfo(loaddata));
        }catch (BusinessException be){
            rtn.setCode(be.getCode());
            rtn.setMsg(be.getMsg());
        }finally {
            //增加后置服务(封装后置服务需要的参数,真正的后置服务处理逻辑在拦截器中执行)
            rwglYbclService.addAfterServiceParam(rwglYbclDTO,rtn);
        }
        return rtn;
    }

    /**
     * 查询统计任务列表
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("tjrw/list")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjrwList(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        TjrwDTO dto = getAndCheckParam(request.getInputStream(), TjrwDTO.class);
        PageHelper.startPage(dto.getPageNo(), dto.getPageSize());
        PageInfo pageInfo=dealPageInfo(tjfxService.tjrwList(dto));
        rtn.setData(pageInfo);
        return rtn;
    }

    /**
     * 统计任务列表-删除
     * @param request
     * @return
     * @throws IOException
     */
    @PostMapping("tjrw/delete")
    @RequiresRoles(logical= Logical.OR,value={"czy"})
    public SimpleResult tjrwDelete(HttpServletRequest request) throws IOException {
        SimpleResult rtn = new SimpleResult();
        Map map = getAndCheckParam(request.getInputStream(), Map.class);
        String rwlx = (String)map.get("rwlx");
        String rwhash = (String)map.get("rwhash");
        if(StringUtils.isBlank(rwlx) || StringUtils.isBlank(rwhash)){
            throw new BusinessException(ResultCode.REQ_FORMAT_ERROR);
        }
        tjfxService.tjrwDelete(rwlx,rwhash);
        return rtn;
    }
}
