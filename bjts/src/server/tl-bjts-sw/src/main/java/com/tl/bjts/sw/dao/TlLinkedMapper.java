package com.tl.bjts.sw.dao;



import com.tl.bjts.sw.model.SwjgModel;
import com.tl.bjts.sw.model.domain.TlUserProfile;
import com.tl.bjts.sw.model.vo.UserInfoVo;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by Mamf on 2017/6/20.
 */
public interface TlLinkedMapper {

     int updateToNextVal(String tblname);//更新主键

     Long selectCurvalue(String tblname);//获取主键

     int insertSequence(String tblname); //新增序列

     List<Map<String, String>> getFpglXx(String czryDM); //获取分片管理信息按照操作人代码

     int querySbhzxxCount(Map parmMap);//申报任务查询

     List<Map<String,String>> queryRoleInfo(String czryDm); //查询角色信息

     List<Map<String,String>> querySwjgxx(String czryDm); //查询用户所属税务机关信息

     int getRwtxListCount(Map map); //根据操作人员代码获取税企交互任务信息

     List<Map<String,Object>> queryReportHzxx(String sbqb);

     Integer checkJdMode(String swjgDm); //返回退税税务机关的接单方式

     int removeSbr(Long sbid);

     int removeSbrs(Set<Long> sbids);

     int getEtpInfoCount(Map parmMap);//返回企业管理信息查询总数

     int getYjxxsCount(Map parmMap);//返回预警信息查询总数

     int queryWrjdCount(Map parmMap);//返回无人接单数

     int queryMdtZzsSbCount(Map parmMap);//返回增值税免抵退情况列表-总数

     int checkLastMonthData(String sbqb);

     Long selectGcClyjInfoHisbByCnt(Map params);//查询退回的申报

     TlUserProfile findByUsername(String czryDm);

     String queryFlglcd(Long nsrdzdah);

     int  updateZzsbbBySbid(Map paramp);

     int dealCqsbdata(Map paramp);

     List<UserInfoVo> queryUsersWithRole(Map parmMap);//授权管理获取用户

     List<UserInfoVo> queryUsersWithFpgl(Map parmMap);//分片管理获取用户

     SwjgModel getSwjgmcByCode(String swjgdm);
}
