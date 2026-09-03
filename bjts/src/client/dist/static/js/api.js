var api = {}

function apiAjax(type, url, data, ishideLoading, ishideErr){
  var deferred = $.Deferred();
  ajax(type, url, data, true, false, ishideLoading).done(function(res){
    deferred.resolve(res);
    if(res.code!='0' && !ishideErr) tools.info(res.msg);
  }).fail(function(err){
    deferred.reject(err);
    if(!ishideErr) tools.info(err);
  })
  return deferred.promise()
}

// 获取登录用户信息
api.preLogin = function(){
  return apiAjax('post', '/auth/preLogin', {})
}

// 审单核查在办 - 查询
api.dzbaInspectDailyProcessList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/process/list', params)
}

// 审单核查在办 - 新增任务弹框  获取出口业务数量
api.dzbaAvaliableList = function(params){
  params = params? params: {};
  params.tsjsfsChg = params.tsjsfsChg || '';
  return apiAjax('post', '/dzba/inspect/daily/business/avaiable/list', params)
}

// 审单核查在办- 新增任务弹框  根据企业标识获取企业信息
api.dzbaNsrxxGet = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/nsrxx/get', params)
}

// 审单核查在办 - 新增任务弹框  根据企业标识获取申报年月批次组合数据列表
api.dzbaDailySbnypcList = function(params){
  params = params? params: {};
  params.tsjsfsChg = params.tsjsfsChg || '';
  return apiAjax('post', '/dzba/inspect/daily/business/sbnypc/list', params)
}

// 审单核查在办 - 新增任务弹框  生成日常审单核查任务
api.dzbaDailyBusinessAdd = function(params){
  params = params? params: {};
  params.tsjsfsChg = params.tsjsfsChg || '';
  return apiAjax('post', '/dzba/inspect/daily/business/add', params)
}

// 审单核查在办 - 新增任务弹框  获取核查单证范围(新)
api.dzbaDailyRangeGet = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/range/get', params)
}

// 审单核查在办 - 新增时，校验企业是否开通单证备案
api.dzbaNsrxxWhether = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/apply/nsrxx/whether', params)
}

// 审单核查在办 - 新增任务下一步时，判断当前批次是否在开通数字化单证备案前
api.dzbaDailyJudge = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/inspect/daily/sbnypc/apply/judge', params)
}

// 预警信息
api.dzbaDailyYjxxList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/yjxx/list', params)
}

// 日常审单 - 按钮  批量下达 
api.dzbaDailyReleaseBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/release/batch', params)
}

// 日常审单 - 按钮  批量作废
api.dzbaDailyWithdrawBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/withdraw/batch', params)
}

// 日常审单 - 按钮  批量退回
api.dzbaDailyBackBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/back/batch', params)
}

// 日常审单 - 按钮  批量审核
api.dzbaDailyExamineBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/examine/batch', params)
}

// 日常审单 - 按钮  单笔下达
api.dzbaDailyReleaseSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/release/single', params)
}

// 日常审单 - 按钮  单笔作废
api.dzbaDailyWithdrawSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/withdraw/single', params)
}

// 日常审单 - 按钮  单笔退回
api.dzbaDailyBackSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/back/single', params)
}

// 退回 - 前置，将审核意见写入退回原因
api.businessBackPre = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/inspect/daily/business/back/pre', params)
}

// 日常审单 - 按钮  单笔审核-前置
api.dzbaDailyExamineSinglePre = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/examine/single/pre', params)
}

// 日常审单 - 按钮  单笔审核
api.dzbaDailyExamineSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/examine/single', params)
}

// 日常审单 - 按钮  单笔审核撤销
api.dzbaDailyExamineRevokeSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/examine/revoke/single', params)
}

// 日常审单 - 状态查询
api.dzbaInspectViewBaseinfo = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/process/view/baseinfo', params)
}

// 日常审单 - 列表查询
api.dzbaInspectViewDetails = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/process/view/details', params)
}

// 任务查询 - 列表查询
api.dzbaDailyQueryList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/query/list', params)
}

// 业务详情弹框 - 查询
api.dzbaDailyBusinessView = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/view', params)
}

// 业务详情弹框 - 保存
api.dzbaDailyBusinessSave = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/business/save', params)
}

// 业务详情弹框 - 查看单证
api.dzbaInspectViewSecond = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/view/second', params)
}

// 根据nsrsbh和entryIds获取核查单证类型
api.dzbaInspectTree = function(params){
  params = params? params: {};
  params.tsjsfsChg = params.tsjsfsChg || '';
  return apiAjax('post', '/dzba/inspect/tree', params)
}

// 重置预警信息
api.dzbaInspectYjxxReset = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/yjxx/reset', params, false, true)
}

// 单证核查立项 - 查询
api.dzbaYearProjectList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/list', params)
}

// 单证核查立项 - 根据税号获取年度核查基本信息
api.dzbaYearProjectAddBaseinfo = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/add/baseinfo', params, false, true)
}

// 单证核查立项 - 生成年度核查业务数据
api.dzbaYearProjectBaseinfoAdd = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/business/add', params)
}

// 单证核查立项 - 批量删除
api.dzbaYearProjectDelBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/del/batch', params)
}

// 单证核查立项 - 批量分配
api.dzbaYearProjectAssignBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/assign/batch', params)
}

// 单证核查立项 - 审核人列表
api.dzbaYearProjectInspectorList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/inspector/list', params)
}

// 单证核查立项 - 批量作废
api.dzbaYearProjectVoidBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/void/batch', params)
}

// 单证核查立项 - 单笔删除
api.dzbaYearProjectDelSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/del/single', params)
}

// 单证核查立项 - 单笔分配
api.dzbaYearProjectAssignSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/assign/single', params)
}

// 单证核查立项 - 单笔作废
api.dzbaYearProjectVoidSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/void/single', params)
}

// 单证核查立项 - 单笔立项
api.dzbaYearProjectApproveSingle = function(params, ishideLoading, ishideErr){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/approve/single', params, ishideLoading, ishideErr)
}

// 核查项目明细 - 基础信息
api.dzbaYearProjectBaseinfo = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/baseinfo', params)
}

// 核查项目明细 - 列表
api.dzbaYearProjectBusinessList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/business/list', params)
}

// 核查项目明细 - 添加
api.dzbaYearBusinessAdd = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/add', params)
}

// 核查项目明细 - 批量删除
api.dzbaYearBusinessDelBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/del/batch', params)
}

// 核查项目明细 - 单证查看
api.dzbaYearBusinessView = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/view', params)
}

// 核查项目明细 - 单证保存
api.dzbaYearBusinessSave = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/save', params)
}

// 核查项目明细 - 单笔删除
api.dzbaYearBusinessDelSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/del/single', params)
}

// 核查项目明细 - 单笔退回
api.dzbaYearBusinessBackSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/back/single', params)
}

// 核查项目明细 - 审核结束 - 前置
api.dzbaYearBusinessExamineSinglePre = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/examine/single/pre', params)
}

// 核查项目明细 - 审核结束
api.dzbaYearBusinessExamineSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/examine/single', params)
}

// 核查项目明细 - 审核撤销
api.dzbaYearBusinessExamineRevokeSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/examine/revoke/single', params)
}

// 年度单证核查审核 - 查询
api.dzbaYearExamineList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/list', params)
}

// 年度单证核查审核 - 核查完成 - 批量 - 前置检查
api.dzbaYearExamineInspectBatchCheck = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/inspect/batch/check', params)
}

// 年度单证核查审核 - 核查完成 - 批量 - 前置获取信息
api.dzbaYearExamineInspectPre = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/inspect/pre', params)
}

// 年度单证核查审核 - 核查完成 - 批量
api.dzbaYearExamineInspectBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/inspect/batch', params)
}

// 年度单证核查审核 - 核查完成 - 单笔
api.dzbaYearExamineInspectSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/inspect/single', params)
}

// 年度单证核查审核 - 发送 - 批量
api.dzbaYearExamineIssueBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/issue/batch', params)
}

// 年度单证核查审核 - 核查完成 - 单笔
api.dzbaYearExamineIssueSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/examine/issue/single', params)
}

// 年度单证核查复核 - 查询
api.dzbaYearReviewList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/review/list', params)
}

// 年度单证核查复核 - 复核完成 - 批量
api.dzbaYearReviewInspectBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/review/inspect/batch', params)
}

// 年度单证核查复核 - 复核完成 - 单笔
api.dzbaYearReviewInspectSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/review/inspect/single', params)
}

// 年度单证核查复核 - 退回 - 批量
api.dzbaYearReviewBackBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/review/back/batch', params)
}

// 年度单证核查复核 - 退回 - 单笔
api.dzbaYearReviewBackSingle = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/review/back/single', params)
}

// 年度单证核查-出口业务 - 审核 - 批量
api.dzbaYearExamineBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/examine/batch', params)
}

// 年度单证核查-出口业务 - 退回 - 批量
api.dzbaYearBackBatch = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/business/back/batch', params)
}

// 日常审单核查情况统计
api.dzbaInspectDailyList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/daily/list', params)
}

// 日常审单核查情况(分户)统计
api.dzbaInspectDailySeparateList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/daily/separate/list', params)
}

// 日常审单核查情况(月度)统计
api.dzbaInspectDailyMonthList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/daily/month/list', params)
}

// 获取下达人列表
api.getReleaserList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/releaser/list', params)
}

// 获取退回记录列表
api.getBackList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/back/list', params)
}

// 获取退回文件视图
api.getBackFileView = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/daily/back/file/view', params)
}

// 年度单证核查工作考核统计
api.dzbaInspectYearList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/year/list', params)
}

// 单证备案推广情况统计
api.dzbaInspectSpreadList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/spread/list', params)
}

// 单证备案数字化成果统计
api.dzbaInspectOutcomeList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/outcome/list', params)
}

// 备案单证数字化情况分析
api.dzbaInspectAnalysisList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/stat/inspect/analysis/list', params)
}

// 参数设置 - 查询
api.dzbaInspectConfigureList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/configure/list', params)
}

// 参数设置 - 保存
api.dzbaInspectConfigureSave = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/configure/save', params)
}

// 参数设置 - 根据商品代码获取商品信息
api.dzbaInspectYearHgspList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/dm/hgsp/list', params)
}

// 参数设置 - 根据商品代码获取商品信息
api.dzbaInspectYearBgxxGet = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/dm/gbxx/get', params)
}

// 查看税务事项通知书/检查报告
api.dzbaInspectYearProjectView = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/inspect/year/project/file/view', params)
}

// 查看年度核查的回证
api.dzbaFileViewPDF = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/file/viewPdf', params)
}

// 查看年度核查的回证
api.dzbaExportReadtree = function(params){
  params = params? params: {};
  return apiAjax('post', '/cxfw/export/readtree', params)
}

// 未开通数字化单证备案企业查询
api.dzbaApplyNotList = function(params){
  params = params? params: {};
  return apiAjax('post', '/dzba/apply/not/list', params)
}

// 获取用户信息
api.getPrelogin = function(){
  var deffered = $.Deferred();
  if(avalonRoot.user && avalonRoot.user.swjgDm){
    deffered.resolve(avalonRoot.user);
  } else{
    api.preLogin().done(function(res){
      if(res.code=='0'){
        deffered.resolve(res.data);
        avalonRoot.user = res.data;
      }
    })
  }
  return deffered.promise()
}

api.tjbbMenu = function(){
  return apiAjax('post', '/bjtssw/tjbb/menu', {}, false, true)
}

api.getAuthMenu = function(params){
  params = params || {};
  return apiAjax('post', '/auth/getmenu', params)
}
api.releaserCheckRole = function(params){
  params = params || {};
  return apiAjax('post', '/auth/user/releaser/checkRole', params)
}
// 健康码评定-获取原健康码
api.getJkmY= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getJkmY', params)
}
// 健康码评定-获取新健康码
api.getJkmN= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getJkmN', params)
}
// 健康码评定-健康码指标核查
api.jkmpdZbhc= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/zbhc', params)
}
// 健康码评定-新增
api.jkmpdAdd= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/add', params)
}
// 健康码评定-查询企业是否已存在健康码评定审批
api.jkmpdCheckJkmPd= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/checkJkmPd', params)
}
// 三三智检风险健康总览-查询健康码统计信息
api.jkmpdGetJkmInfo= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getJkmInfo', params)
}
// 三三智检风险健康总览-查询指标统计信息
api.jkmpdGetZbInfo= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getZbInfo', params)
}
// 三三智检风险健康总览-查询风险业务统计信息
api.jkmpdGetFxYwInfo= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getFxYwInfo', params)
}
// 指标赋分明细下钻查询
api.jkmpdGetZbFfMxXz= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/jkmpd/getZbFfMxXz', params)
}
// 查询企业分组字典值
api.getQyjkmQyfz= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbgl/qyjkm/qyfz', params)
}
// 通用数据查询器-查询数据源列表
api.getDtsList= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/dts/list', params)
}
// 通用数据查询器-查询数据源对应数据项的配置列表，以及界面输出字段配置信息
api.getDtsPz= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/dts/pz', params)
}
// 通用数据查询器-执行查询
api.queryExecute= function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/execute', params)
}
// 通用数据查询器-保存方案
api.cxqSavePlan = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/plan/save', params)
}
// 通用数据查询器-查询方案列表
api.getPlanList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/plan/list', params)
}
// 通用数据查询器-查询方案详情
api.getPlanDetail = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/plan/detail', params)
}
// 通用数据查询器-导出前权限判断
api.exportCheckPer = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/export/queryExport/checkPer', params)
}
// 通用数据查询器-查询字典信息
api.getDfDict = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/dynamicQuery/df/dict', params)
}
// 税务机关短信接收人配置-新增或修改短信用户
api.msgplanUserUpdate = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/zbrw/msgplan/user/update', params)
}
// 税务机关短信接收人配置-删除短信用户
api.msgplanUserDel = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/zbrw/msgplan/user/del', params)
}
// 样本企业指标分析-添加样本企业
api.zbfxAdd = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbfx/add', params)
}
// 样本企业指标分析-删除样本企业
api.zbfxDel = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbfx/del', params)
}
// 样本企业指标分析-查询样本企业信息
api.zbfxYbqyList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbfx/ybqyList', params)
}
// 样本企业指标分析-查询异常指标统计结果
api.zbfxYczbList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbfx/yczbList', params)
}
// 样本企业指标分析-查询异常指标命中的企业
api.zbfxHitQyList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbfx/hitQyList', params)
}
// 企业画像报告-企业报告列表查询
api.qyReportList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/report/list', params)
}
// 企业画像报告-生成企业报告
api.qyReportGenerate = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/report/generate', params)
}
// 企业画像报告-查询报告下载记录
api.qyReportDownloadList = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/report/downloadList', params)
}
// 查询出口退（免）税退调库数据
api.getMapData = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/total/mapData', params)
}

// 申报信息(附件预览)查询
api.bjtsswSbxxList = function(params){
  params = params || {};
  return apiAjax('post', '/bjtssw/sbxx/list', params)
}

// 申报信息(附件预览)查询 - 附件列表
api.sbxxDocList = function(params){
  params = params || {};
  return apiAjax('post', '/bjtssw/sbxx/doc/list', params)
}

// 申报信息(附件预览)查询 - 附件预览
api.sbxxDocView = function(params){
  params = params || {};
  return apiAjax('post', '/bjtssw/sbxx/doc/view', params)
}

api.zbdataRefresh = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zbdata/refresh', params)
}

// 内控风险点树结构信息
api.getTsgzSecondETree = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/tsgz/secondETree', params)
}

// 内控风险处理明细信息
api.getTsgzSecondEClMx = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/tsgz/secondEClMx', params)
}

// 内控风险处理单条明细信息
api.getTsgzSecondEClMxSingle = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/tsgz/secondEClMx/single', params)
}

// 保存内控风险处理结果
api.getTsgzSecondESaveResult = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/tsgz/secondE/saveResult', params)
}

// 修改事前提醒信息
api.sqtxUpdate = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/sq/update', params)
}

// 事前提醒信息查询
api.getSqtxResult = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/sq/query', params)
}

// 事中预警信息查询
api.getSzyjResult = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/sz/query', params)
}

// 内控风险指标树形结构
api.getNkfxTree = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/zb/tree', params)
}

// 查询内控风险指标
api.getNkfxConfig = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/zb/config', params)
}

// 查询内控管理成果统计
api.getNkfxStatistic = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/statistic', params)
}

// 查询短信关联业务的业务类型
api.getNkglMsgYwlx = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/nkgl/msg/ywlx/dm', params)
}

// 查询退税额预测不符接单日志
api.getTseycQuery = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/query/log', params)
}

// 退税预测企业报送状态查询
api.getTsycqybszt = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/bszt/query', params)
}

// 退税预测企业报送结果查询
api.getTsycqybsjg = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/bsjg/query', params)
}

// 退税预测企业报送结果统计
api.getTsycqybsjgstat = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/bsjg/stat', params)
}

// 退税预测企业报送结果统计执行
api.getTsycqybsjgexecute = function(params, ishideLoading, ishideErr){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/bsjg/stat/execute', params, ishideLoading, ishideErr)
}

// 重点企业查询
api.getZdqyQuery = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/page', params)
}

// 新增重点企业
api.getZdqyAdd = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/add', params)
}

// 修改重点企业
api.getZdqyUpdate = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/update', params)
}

// 删除重点企业
api.getZdqyDelete = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/delete', params)
}

// 导入重点企业
api.getZdqyImport = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/import', params)
}

// 档案表企业模糊查询
api.getZdqymhQuery = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/query', params)
}
// 重点企业导入模板
api.getZdqyImportTemplate = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/zdqy/import/template', params)
}
// 退税预测企业报送结果统计权限校验
api.getBsjgCheck = function(params){
  params = params || {};
  return apiAjax('post', '/glfw/tseyc/qy/bsjg/stat/check', params)
}
// 风险应对新增
api.updateFxyd = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/fxgl/fxyd/update', params)
}
// 风险商品新增
api.updateFxsp = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/fxgl/fxsp/update', params)
}
// 风险供应商新增
api.updateFxgys = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/fxgl/fxgys/update', params)
}
// 即将逾期退税审核提醒设置
api.updateJjyqtssh = function(params){
  params = params || {};
  return apiAjax('post', '/cxfw/fxgl/jjyq/update', params)
}
// 查询审单核查情况
api.getSdhcqk = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/record/sdhc/list', params)
}
// 内控风险处理明细信息
api.getTsgzZxjgSecondEClMx = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zxjg/zxjgClMx', params)
}
// 风险商品新增
api.updateZxjg = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zxjg/update', params)
}
// 查询专项日常监管疑点统计
api.getTjcxConfig = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zxjg/tjcx', params)
}
// 获取专项指标
api.getZxzblist = function(params){
  params = params || {};
  return apiAjax('post', '/sszj/zxjg/zxzblist', params)
}
api.dzbaFileViewPdf = function(params, ishideErr){
  params = params || {};
  return apiAjax('post', '/dzba/file/viewPdf', params, false, ishideErr)
}
// 获取核查任务退回记录的树形结构数据
api.dzbaInspectDailyBackTree = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/inspect/daily/back/tree', params)
}
// 获取核查任务退回记录的单证文件数据
api.dzbaInspectDailyBackFileViewPdf = function(params, ishideErr){
  params = params || {};
  return apiAjax('post', '/dzba/inspect/daily/back/file/viewPdf', params, false, ishideErr)
}
api.dzbaFileRemarkSave = function(params){
  params = params || {};
  return apiAjax('post', '/dzba/file/remark/save', params)
}

// 风险报关行 - 查询
api.yjFxbghList = function(params){
  params = params || {};
  return apiAjax('post', '/bjtssw/yj/fxbgh', params)
}
export default api
