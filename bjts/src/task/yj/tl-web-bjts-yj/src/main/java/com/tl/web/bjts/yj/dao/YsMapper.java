package com.tl.web.bjts.yj.dao;

import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.vo.GainDataVo;
import com.tl.web.bjts.yj.model.vo.LockSbxxVo;


import java.util.List;
import java.util.Map;

/**
 * Created by Mamf on 2017/6/20.
 */
public interface YsMapper {

     int insertCzlog(Map pramsMap);

     Long selectTbpcNextVal();

     List<TaskVo> gainSbhzxx4Yj(GainDataVo gainDataVo);

     int updateLockSbxx4Yj(Map pramsMap);

     TaskVo queryYsSbxx4Yj(LockSbxxVo lockSbxxVo);

     int updateLockYsbz4Yj(Map pramsMap);

     int updateYjComplete(Map pramsMap);

     /**
      * 删除和本次申报相同的申报业务和申报批次疑点信息
      * @param sbid
      */
     void deleteSbpc(Long sbid);
}
