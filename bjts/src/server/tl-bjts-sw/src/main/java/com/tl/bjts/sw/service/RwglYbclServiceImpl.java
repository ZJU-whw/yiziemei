package com.tl.bjts.sw.service;

import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.RwglYbclXxzbModelMapper;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.interceptor.RwglYbclInterceptor;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.domain.RwglYbclXxzbModel;
import com.tl.bjts.sw.model.dto.RwglYbclAfterDTO;
import com.tl.bjts.sw.model.dto.RwglYbclBeforeDTO;
import com.tl.bjts.sw.model.dto.TjfxMainDTO;
import com.tl.bjts.sw.utils.DateUtils;
import com.tl.bjts.sw.utils.RwglYbclEnum;
import com.tl.bjts.sw.utils.TlConst;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.Date;

/**
 * 描述:任务处理-异步处理服务类
 * 作者 likun
 * 时间 2020-05-11 11:33
 */
@Service
public class RwglYbclServiceImpl implements RwglYbclService{
    private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    RwglYbclXxzbModelMapper  xxzbModelMapper;

    @Autowired
    BasisService basisService;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    AppProperties appProperties;

    @Override
    public int afterServerExecutor(RwglYbclAfterDTO dto) {
        String code = dto.getCode(); //任务的代码
        String rwlx = RwglYbclEnum.valueOf(code).getRwlx(); //任务类型
        //根据任务类型和hash(主键)查询是否存在
        RwglYbclXxzbModel existParam = new RwglYbclXxzbModel();
        existParam.setRwlx(rwlx);
        existParam.setRwhash(dto.getRwhash());
        RwglYbclXxzbModel existRet = xxzbModelMapper.selectByPrimaryKey(existParam);
        if(existRet != null){
            RwglYbclXxzbModel model = new RwglYbclXxzbModel();
            model.setRwlx(rwlx);
            model.setRwhash(dto.getRwhash());
            model.setRwzt(TlConst.RWZT_CLWB); //处理完毕
            if(dto.getFreshFlag()){ //重新生成了数据(统计数据或者报表数据)
                model.setFrtime(new Date());
                model.setBz(dto.getBz());
                model.setFrnum(new Integer(existRet.getFrnum().intValue() + 1).shortValue()); //刷新次数+1
                model.setReadnum(new Short("0")); //刷新后清0
            }else{
                model.setReadnum(new Integer(existRet.getReadnum().intValue() + 1).shortValue());
            }
            model.setReadtotal(new Integer(existRet.getReadtotal().intValue() + 1).shortValue());
            //更新
           return xxzbModelMapper.updateByPrimaryKeySelective(model);
        }
        return 0;
    }


    public void addAfterServiceParam(RwglYbclAfterDTO dto,SimpleResult result) {
        //添加参数
        RwglYbclInterceptor.paramThreadLocal.set(dto);
        //添加返回结果
        RwglYbclInterceptor.resultThreadLocal.set(result);
    }

    /**
     *
     *根据任务类型和任务hash 判断任务表中是否存在记录
     *   判断正在处理的总任务和某个操作人员的总任务是否超过限制，如果超过限制，则给与提示
     *   是: 查看任务状态，如果状态没有处理完毕，则提示用户“正在处理，请稍后再试”
     *   否：创建任务
     * @param dto
     */
    @Override
    public void beforeServerExecutor(RwglYbclBeforeDTO dto) {

        Example example = new Example(RwglYbclXxzbModel.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andNotEqualTo("rwzt",TlConst.RWZT_CLWB );
        int total = xxzbModelMapper.selectCountByExample(example);

        if(total > appProperties.getTjfxCurrentTotal()){
            throw new BusinessException(TlConst.TJFX_RWZT_CLWB_REFRESH,"服务端正在处理的统计分析任务已经到达上限，请您稍后再试！");
        }
        criteria.andEqualTo("czrydm",commonService.getCurrentUser().getCzryDm());
        int one = xxzbModelMapper.selectCountByExample(example);
        if(one > appProperties.getTjfxCurrentOne()){
            throw new BusinessException(TlConst.TJFX_RWZT_CLWB_REFRESH,"正在处理的统计分析任务已经到达上限"+ + appProperties.getTjfxCurrentOne() +"笔，请您稍后再试！");
        }


        String rwlx = dto.getRwlx(); //任务类型
        String rwhash = dto.getRwhash();
        //根据任务类型和hash(主键)查询是否存在
        RwglYbclXxzbModel existParam = new RwglYbclXxzbModel();
        existParam.setRwlx(rwlx);
        existParam.setRwhash(dto.getRwhash());
        RwglYbclXxzbModel existRet = xxzbModelMapper.selectByPrimaryKey(existParam);
        //不存在时创建任务
        if(existRet == null){
            RwglYbclXxzbModel insertModel = new RwglYbclXxzbModel();
            insertModel.setRwlx(rwlx);
            insertModel.setRwhash(rwhash);
            insertModel.setRwbw(dto.getRwbw());
            insertModel.setRwms(dto.getRwms());
            insertModel.setRwname(basisService.getDnameByTypeCode("rwglLx",rwlx));
            insertModel.setRwzt(TlConst.RWZT_ZZCL);//正在处理
            insertModel.setReadnum(new Short("0")); //默认读取的次数为0
            insertModel.setFrnum(new Short("0")); //默认刷新的次数为0
            insertModel.setReadtotal(new Short("0")); //默认读取的总数为0
            insertModel.setCzrydm(commonService.getCurrentUser().getCzryDm());
            insertModel.setCzrymc(commonService.getCurrentUser().getCzryMc());
            insertModel.setCrtime(new Date());
            insertModel.setSwjgdm(commonService.getCurrentUser().getSwjgDm());
            xxzbModelMapper.insertSelective(insertModel);
        }else{
            String rwzt = existRet.getRwzt();
            if(rwzt.equals(TlConst.RWZT_DCL)){
                throw new BusinessException(TlConst.TJFX_RWZT_CLWB_REFRESH,"本统计任务服务端已受理，请稍后再获取统计结果！");
            }else if(rwzt.equals(TlConst.RWZT_ZZCL)){
                throw new BusinessException(TlConst.TJFX_RWZT_CLWB_REFRESH,"本统计任务服务端尚未处理完毕，请稍后再获取统计结果！");
            }else if(rwzt.equals(TlConst.RWZT_CLWB)){
               //用户没有主动点击重新统计时:再次判断是否超期，若超期则前端展示提示框，供用户选择是否重新统计
                if(StringUtils.isNotBlank(dto.getUserRefresh()) &&  TlConst.SF4NO.equals(dto.getUserRefresh())){
                    //获取统计的时间
                    Date frtime = existRet.getFrtime();
                    if(frtime == null || frtime.before(org.apache.commons.lang3.time.DateUtils.addDays(new Date(),org.springframework.util.StringUtils.isEmpty(appProperties.getTjfxExceedTime()) ? -2: appProperties.getTjfxExceedTime()))){
                        throw new BusinessException(TlConst.TJFX_RWZT_CLWB_REFRESH,"本统计结果已由" + existRet.getCzrymc()  + "于" + DateUtils.format(existRet.getCrtime(),DateUtils.YMD) + "生成！请选择以下方式：直接查看统计结果、重新统计刷新结果、取消。");
                    }
                }
            }
        }
    }

    /**
     * 删除异步处理任务
     * @param dto
     * @return
     */
    public int deleteRwglYbcl(RwglYbclAfterDTO dto){
        if(dto == null){
            return 0;
        }
        String code = dto.getCode(); //任务的代码
        String rwlx = RwglYbclEnum.valueOf(code).getRwlx(); //任务类型
        String rwhash = dto.getRwhash(); //任务hash
        RwglYbclXxzbModel deleteModel = new RwglYbclXxzbModel();
        deleteModel.setRwlx(rwlx);
        deleteModel.setRwhash(rwhash);
        return xxzbModelMapper.deleteByPrimaryKey(deleteModel);
    }

    /**
     * 根据任务类型和任务hash获取任务对象
     * @param param
     * @return
     */
    public RwglYbclXxzbModel getRwglYbclByPk(RwglYbclXxzbModel param){
        return xxzbModelMapper.selectByPrimaryKey(param);
    }

}
