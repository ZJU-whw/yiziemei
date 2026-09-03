package com.tl.bjts.sw.service;

import com.google.gson.Gson;
import com.tl.bjts.sw.conf.TaskProperties;
import com.tl.bjts.sw.dao.JcfxTaskModelMapper;
import com.tl.bjts.sw.dao.JcfxTaskSubModelMapper;
import com.tl.bjts.sw.dao.TlMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.model.domain.JcfxTaskModel;
import com.tl.bjts.sw.model.domain.JcfxTaskSubModel;
import com.tl.bjts.sw.model.dto.DynamicQueryDTO;
import com.tl.bjts.sw.model.vo.SjjcDynamicVo;
import com.tl.bjts.sw.utils.Cache;
import com.tl.bjts.sw.utils.GZipUitl;
import com.tl.bjts.sw.utils.TlUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import tk.mybatis.mapper.entity.Example;

import java.math.BigDecimal;
import java.util.*;

/**
 * 说明：从数据库获取任务服务
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@Service
public class TaskGainService {

    public static String TASK_POOL = "dynamic-query-pool-";


    private static Map<String,Integer> poolTask = new HashMap<>();

    Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    JcfxTaskModelMapper jcfxTaskModelMapper;

    @Autowired
    JcfxTaskSubModelMapper jcfxTaskSubModelMapper;

    @Autowired
    RedisDelayService redisDelayService;

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    TaskProperties taskProperties;

    @Autowired
    TlMapper tlMapper;

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public JcfxTaskModel lockTask() {

        //每次获取多条记录，防止多线程锁定任务时冲突，而导致多次查询数据库
        List<JcfxTaskModel> tasks = getTaskList();
        if(CollectionUtils.isEmpty(tasks)){
            return null;
        }


        JcfxTaskModel model = null;
        for (JcfxTaskModel obj : tasks) {
            model=getLockTask(obj.getId(),obj.getTqbz());
            if(model != null){//锁定成功
                break;
            }
        }

        return model;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public List<JcfxTaskModel> getTaskList(){

        Map pramMap = new HashMap();
        double time=taskProperties.getLockTimeout()/(24.0*60.0);
        BigDecimal delayTime = new BigDecimal(time);


        pramMap.put("delay",delayTime);
        pramMap.put("start","0");
        pramMap.put("end",String.valueOf(taskProperties.getTaskMaxSize()));
        pramMap.put("orderByCaluse","crtime desc,tqsj");

        List<JcfxTaskModel> taskModels = tlMapper.selectDynamicTaskList(pramMap);

        return taskModels;
    }


    /**
     * 获取锁定数据
     * @param
     * @return
     */
    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public JcfxTaskModel getLockTask(String id,String lastTqbz) {
        JcfxTaskModel retTask=null;

        String tqbz = TlUtils.getTqbz();

        Map map=new HashMap<>();
        map.put("tqbz",tqbz);
        map.put("idkey",id);
        map.put("lastTqbz",lastTqbz);

        int ret = tlMapper.lockDynamicQueryTask(map);



        if(ret==1){
            logger.info("{}-【锁定数据】-成功",id);

            JcfxTaskModel param=new JcfxTaskModel();
            param.setTqbz(tqbz);
            param.setId(id);

            retTask=jcfxTaskModelMapper.selectOne(param);
        }else{
            logger.error("{}-【锁定数据】-失败",id);
        }

        return retTask;
    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void completeTask(String id, byte[] data, StringBuffer sqltext) {

        JcfxTaskModel up= new JcfxTaskModel();
        up.setId(id);
        up.setWcsj(new Date());
        up.setTaskFlag("2");
        up.setRespData(data);
        up.setSqltext(sqltext.toString());

        tlMapper.updateTaskFish(up);

        redisDelayService.putKeyValue(id,"1");

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void updateErrorTask(String id) {

        JcfxTaskModel model = jcfxTaskModelMapper.selectByPrimaryKey(id);

        if(model.getTqcs().compareTo(new BigDecimal(10l))>0){
           // jcfxTaskModelMapper.deleteByPrimaryKey(id);
        }

    }

    @TargetDataSource(name = MultipleDataSourceHolder.TSSH)
    public void processSubTaskQuery(SjjcDynamicVo sjjcDynamicVo, DynamicQueryDTO dynamicQueryDTO, JcfxTaskModel task) throws Exception {


            StringBuffer sqltext = new StringBuffer();

            Integer total = sjjcDynamicVo.getList().getTotal();
            for (int j = 1; j < total; j++) {
                Integer page = j+1;

                dynamicQueryDTO.setPageNo(page);
                sjjcDynamicVo = tjbbBasisService.getDynamicData(task.getId(),dynamicQueryDTO,sqltext);
                byte[] data = GZipUitl.genZip(new Gson().toJson(sjjcDynamicVo));

                JcfxTaskSubModel jcfxTaskSubModel = new JcfxTaskSubModel();
                jcfxTaskSubModel.setPid(task.getId());
                jcfxTaskSubModel.setPageNo(new BigDecimal(page));
                jcfxTaskSubModel.setRespData(data);

                MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);
                jcfxTaskSubModelMapper.insert(jcfxTaskSubModel);
            }
    }
}
