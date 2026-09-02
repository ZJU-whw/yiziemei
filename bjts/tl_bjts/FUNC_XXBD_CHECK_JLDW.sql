CREATE OR REPLACE FUNCTION FUNC_XXBD_CHECK_JLDW(V_JLDWMC IN VARCHAR2, V_JLDWDM IN VARCHAR2)
  RETURN NUMBER
/*
 * 编 制 人: 严国平
 * 编制日期: 20201112
 * 功    能: 检查计量单位名称与计量单位代码是否匹配
 * 返 回 值：返回查询结果记录数
 * 修改记录：20210604，针对发票计量单位名称有两个分组，其中一个分组中计量单位名称集合包含海关记录单位代码对应单位名称的情况进行调整
 *           案例：发票单位为“件”，对应分组01,011；海关成交单位分组为007（个），“个”对应分组01,007，两者有01分组重叠，暂认定相符
 */
IS
  V_NUMBER NUMBER(10);
BEGIN
/*
  SELECT COUNT(*)
    INTO V_NUMBER
    FROM CKTS_DM_HGJLDW T
   WHERE T.HGJLDW_DM=V_JLDWDM
     AND '.'||T.HGJLDWQC||'.' LIKE '%.'||UPPER(V_JLDWMC)||'.%';
*/
  SELECT COUNT(*)
    INTO V_NUMBER
    FROM CKTS_DM_HGJLDW T
   WHERE T.HGJLDW_DM IN (SELECT S.HGJLDW_DM 
                           FROM CKTS_DM_HGJLDW S 
                          WHERE '.'||S.HGJLDWQC||'.' LIKE '%.'||UPPER(V_JLDWMC)||'.%')
     AND T.HGJLDW_DM IN (SELECT S.HGJLDW_DM 
                           FROM CKTS_DM_HGJLDW S 
                          WHERE '.'||S.HGJLDWQC||'.' LIKE '%.'||(SELECT R.HGJLDWQC FROM CKTS_DM_HGJLDW R WHERE R.HGJLDW_DM=V_JLDWDM)||'.%');

  RETURN V_NUMBER;
END;
/
