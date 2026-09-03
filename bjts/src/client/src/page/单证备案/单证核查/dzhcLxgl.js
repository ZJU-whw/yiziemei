var jdglinfo = require('../../../config/jdglinfo.js');
var dzhcLxgl = require("./dzhcLxgl.html");

avalon.component('dzhcLxgl', {
  template: dzhcLxgl,
  defaults: {
    searchData: {
      swjgdm: "",
      year: "",
      nsrsbh: "",
      nsrmc: "",
      qyhgdm: "",
      qylx: "",
      flglcd: "",
      qygm: "",
      status: "",
      balx: "",
      source: "",
      inspector: "",
      yqbz: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
    },
    swjgmc: '',
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    selRows: [],
    showNsrsbhList: false,
    nsrsbhList: [],
    progressErrs: [], // 批量立项错误信息收集
    isPlfp: 0, // 批量分配弹框  0-单个企业审核/复核分配  1-多个企业审核/复核分配
    fpInspector: '', // 分配审核人
    inspectorList: [], // 审核人列表
    currentRow: '',
    activeBgIndex: -1,
    nsrxx: {
      nsrsbh: '',
      nsrmc: '',
      qyhgdm: '',
      qylx: '',
      flglcd: '',
      qygm: '',
      qygmName: '',
      spdm: '',
      mygjdq: '',
      fobqd: '',
    },
    hcConf: {
      year: '',
      deadline: '',
      inspector: '',
      lxdh: '',
    },
    editRangeList: [], // 编辑/查看时选中的核查单证类型
    typeTreeData: [], // 核查单证类型
    showNsrsbhCkywList: false,
    nsrsbhCkywList: [],
    activeBgCkywIndex: -1,
    showInspectorErr: false,
    ywccblList: [ // 业务抽查比例
    ],
    spdmCheckedList: [ // 意向商品代码 - 初始值
    ],
    spdmSearchList: [ // 意向商品代码 - 搜索
    ],
    mygCheckedList: [ // 贸易国 - 初始值
    ],
    mygSearchList: [ // 贸易国 - 搜索
    ],
    qygmList: jdglinfo.qygmList,
    searchType: 'spdm',  // spdm-意向商品代码，myg-敏感贸易国

    yearList: [],

    resetSearchData: function () {
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        year: "",
        nsrsbh: "",
        nsrmc: "",
        qyhgdm: "",
        qylx: "",
        flglcd: "",
        qygm: "",
        status: "",
        balx: "",
        source: "",
        inspector: "",
        yqbz: "",
        orderSql: "",
        pageNo: 1,
        pageSize: 20,
      };
      this.qySearchVal = '';
    },
    onInit: function (e) {
      avalonRoot.dzhcLxgl = e.vmodel;
    },

    onReady: function () {
      this.isWindows = tools.isWindows();
      this.initUser();
      this.initDate();
      this.initHeight();
      this.initTree();
      this.dzhcLxglFileuploadCb();
      this.createTable();
      this.getInspectorList();
      this.getYearList();

    },
    getYearList:function(){
      var curYear = new Date().getFullYear()
      // 定义起始年份
      const startYear = 2021;
      this.yearList = Array.from({ length: curYear - startYear + 1 }, 
        (_, index) => `${startYear + index}`);
    },
    // 初始化用户数据
    initUser: function () {
      var self = this;
      if (avalonRoot.user && avalonRoot.user.swjgDm) {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.swjgmc = avalonRoot.user.swjgMc;
          }
        })
      }
    },

    // 初始化日期输入框
    initDate: function () {
      this.hcConf.year = new Date().getFullYear() - 1 + '';
      var endDate = new Date().getFullYear() - 0 + '';
      $('.dzhc-lxgl .datepicker.date-year').datetimepicker({
        format: 'yyyy',
        language: "zh-CN",
        clearBtn: true,
        autoclose: true,
        startView: 4, // 这里就设置了默认视图为年视图
        minView: 4, // 设置最小视图为年视图
        endDate: endDate,
      });

      var startDate = tools.getNextDay(1);
      this.hcConf.deadline = tools.getNextDay(60);
      var endDate = tools.getNextDay(60);
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, startDate: startDate, endDate: endDate };
      $('.dzhc-lxgl .deadline.datepicker.date-day').datetimepicker(options);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzhc-lxgl .form").height();
        if (h > 100) {
          $("#dzhc-lxgl-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    // 文件上传回调函数
    dzhcLxglFileuploadCb: function () {
      var self = this;
      $('#dzhcLxglFileupload').fileupload({
        dataType: 'json',
        done: function (e, data) {
          if (data.result.code == "0") {
            var projects = data.result.data;
            var text = [];
            if(Array.isArray(projects)){
              for(var i=0; i<projects.length; i++){
                var item = '';
                item += projects[i].nsrsbh;
                item += '成功创建项目(序号是';
                item += projects[i].projectId;
                item += '),项目下自动生成【';
                item += projects[i].ywbs;
                item += '笔】业务，分布在【';
                item += projects[i].sbnypcs;
                item += '个】申报年月批次中';
                text.push(item);
              }
            }
            if(text.length>0){
              var textNew = '<p style="font-size: 14px; font-weight: 600;">导入成功，汇总信息如下：</p>';
              textNew += text.join('；');
              textNew += '。';
              tools.info(textNew);
            } else{
              tools.info("导入成功");
            }
            self.search(1);
          } else{
            tools.info(data.result.msg);
          }
        }
      }).on('fileuploadadd', function () {
        $('#loading').show();
      }).on('fileuploadalways', function () {
        $('#loading').hide();
      })
    },

    // 获取审核人列表
    getInspectorList: function () {
      var self = this;
      if (this.inspectorList.length == 0) {
        var params = {
          swjgdm: this.searchData.swjgdm,
        }
        api.dzbaYearProjectInspectorList(params).done(function (res) {
          if (res.code == 0) {
            self.inspectorList = res.data;
            self.fpInspector = '';
            self.hcConf.inspector = '';
          }
        })
      }
    },

    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = ""
      }
      e.target.value = res;
      return;
    },

    // 查询条件 纳税人识别号/企业名称/海关代码 变更事件
    qySearchTypeChg: function () {
      this.qySearchVal = '';
      this.searchData.nsrsbh = '';
      this.searchData.nsrmc = '';
      this.searchData.qyhgdm = '';
    },
    // 查询条件 纳税人识别号/企业名称/海关代码输入框 变更事件
    qySearchValChg: function () {
      this.qySearchVal = this.qySearchVal.trim();
      if (this.qySearchType == 'nsrsbh') {
        this.searchData.nsrsbh = this.qySearchVal;
      } else if (this.qySearchType == 'qymc') {
        this.searchData.nsrmc = this.qySearchVal;
      } else if (this.qySearchType == 'hgdm') {
        this.searchData.qyhgdm = this.qySearchVal;
      }
    },
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          }
        },
        data: { key: { children: "item", name: "text" } }
      };

      api.dzbaExportReadtree({ nodeType: "3" }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($(".dzhc-lxgl .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzhc-lxgl').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzhc-lxgl').off('click');
    },

    sbpcChange: function () {
      var sbpc = this.searchData.sbpc.replace(/[^0-9]/g, '')
      this.searchData.sbpc = sbpc
    },

    nsrsbhEnterSearch: function (e) {
      e.target.blur()
      this.showNsrsbhList = false
      this.search(1)
    },

    search: function (pageNo) {
      var self = this;
      // 处理外层查询条件切换时的问题
      this.qySearchValChg();
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-lxgl')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#dzhc-lxgl-table").jqGrid('clearGridData')
      api.dzbaYearProjectList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-lxgl-table").resetSelection();
          $("#dzhc-lxgl-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          self.selRows = [];
          tools.HeiKj('dzhc-lxgl', 'dzhc-lxgl-table')
          self.closeHyper()
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    showHyper: function () {
      $('.dzhc-lxgl .page .select-sub').toggle();
      $('.dzhc-lxgl .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-lxgl .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-lxgl .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-lxgl .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-lxgl .select-sub').hide();
      $('.dzhc-lxgl .select-wrapper .icon').removeClass('active');
      $('.dzhc-lxgl .select-wrapper .icon').attr("title", "展开查询条件")
    },

    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, op, row) {
            var eidt_til = row.status == '0' ? '编辑' : '查看'; // 0-创建 1-审核 2-复核 3-发放 9-结案
            var del_enable = row.status == '0';
            var fp_enable = row.status != '9';
            var lx_enable = row.status == '0';
            var void_enable = row.status == '1';
            var h = '';
            h += "<div class='btn op-btn op-edit' title='" + eidt_til + "'>" + eidt_til + "</div>"; // 编辑/查看
            h += "<div class='btn op-btn op-del " + (del_enable ? '' : 'op-disabled') + "' title='删除'>删除</div>"; // 删除
            h += "<div class='btn op-btn op-fp " + (fp_enable ? '' : 'op-disabled') + "' title='分配'>分配</div>"; // 分配
            h += "<div class='btn op-btn op-lx " + (lx_enable ? '' : 'op-disabled') + "' title='立项'>立项</div>"; // 立项
            h += "<div class='btn op-btn op-void " + (void_enable ? '' : 'op-disabled') + "' title='作废'>作废</div>"; // 作废
            return h
          }
        },
        { name: "id", label: "项目序号", index: "id", width: 50, align: "center", sortable: true },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 80, sortable: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", width: 125, sortable: false },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 120, sortable: false },
        { name: "balx", label: "备案方式", index: "balx", width: 80, align: "center", sortable: true },
        { name: "year", label: "年度", index: "year", width: 40, align: "center", sortable: true },
        { name: "status", label: "项目状态", index: "status", hidden: true },
        { name: "statusName", label: "项目状态", index: "statusName", width: 55, align: "center", sortable: true },
        { name: "inspector", label: "审核人", index: "inspector", width: 55, align: "center", sortable: true },
        { name: "ywbs", label: "业务笔数", index: "ywbs", width: 80, align: "right", sortable: true,
        formatter: function (cellVal, op, row) {
          cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
          if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
          return cellVal
        } },
        {
          name: "approveTime", label: "立项日期", index: "approveTime", width: 125, align: "center", sortable: true ,
          formatter: function (cellVal, op, row) {
            // 非空时，点击打开税务事项通知书
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            var h = '';
            if(row.balx=='纸质备案'){
              h += cellVal;
            } else{
              h += "<div class='op-line op-approve' title='点击预览税务事项通知书'>" + cellVal + "</div>";
            }
            return h
          }
        },
        {
          name: "receiptTime", label: "回证日期", index: "receiptTime", width: 125, align: "center", sortable: true ,
          formatter: function (cellVal, op, row) {
            // 点击打开企业回传的pdf
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            var h = '';
            if(row.balx=='纸质备案'){
              h += cellVal;
            } else{
              h += "<div class='op-line op-receipt' title='点击预览回证文书'>" + cellVal + "</div>";
            }
            return h
          }
        },
        { name: "deadline", label: "项目期限", index: "deadline", width: 70, align: "center", sortable: true },
        { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm", width: 100, sortable: false },
        { name: "qylx", label: "企业类型", index: "qylx", width: 120, align: "center", sortable: true },
        { name: "qygm", label: "企业规模", index: "qygm", width: 60, align: "center", sortable: true },
        { name: "flglcd", label: "管理等级", index: "flglcd", width: 70, align: "center", sortable: true },
        { name: "op", label: "操作", width: 285, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-lxgl-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-lxgl-tablePager',
        shrinkToFit: false,
        width: "100%",
        multiselect: true,
        multiselectWidth: "30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dzhc-lxgl .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-disabled')) return
          var row = $('#dzhc-lxgl-table').jqGrid('getRowData', rowid);
          self.currentRow = row;
          if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开日常审单页面
            row.swjgmc = self.swjgmc;
            avalonRoot.addTab({
              title: '核查项目明细',
              component: 'dzhcJcxmmx',
              params: row,
            })
            return false
          } else if ($(e.target).hasClass('op-del')) {
            self.delSingle(row);
          } else if ($(e.target).hasClass('op-fp')) {
            self.showFpDialog(0, row);
          } else if ($(e.target).hasClass('op-lx')) {
            self.approveSingle(row);
          } else if ($(e.target).hasClass('op-void')) {
            self.voidSingle(row);
          } else if ($(e.target).hasClass('op-approve')) { // 立项 - 查看税务事项通知书
            self.showViewPdfApprove(row);
            return false
          } else if ($(e.target).hasClass('op-receipt')) { // 回证 - 查看回证PDF
            self.showViewPdfReceipt(row);
            return false
          } else {
            return true;
          }
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "dzhc-lxgl-table");
          self.search(pageNo);
        },
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid)
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
        }
      })
      $("#dzhc-lxgl-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-lxgl')).val();
      this.search(1)
    },

    // 预览税务事项通知书
    showViewPdfApprove: function (row) {
      var self = this;
      var params = {
        id: row.id,
        type: '001', // 001-税务事项通知书
      }
      api.dzbaInspectYearProjectView(params).done(function (res) {
        if (res.code == '0') {
          if (!res.data) {
            tools.info('未获取到文件信息');
            return
          }
          if (self.isWindows) {
            // Windows 系统：调用单证助手客户端
            var param = {
              fileName: '',
              fileUrl: res.data.fileUrl,
              fileStream: res.data.fileStream,
              title: '税务事项通知书'
            }
            apiClient.checkDzjNew(param);
          } else {
            // 非 Windows 系统：使用 PDF.js 预览
            if (!res.data.fileStream) {
              tools.info('未获取到文件信息');
              return
            }
            components['pdfViewerglobal-pdf'].showPdf(res.data.fileStream, '税务事项通知书');
          }
        }
      });
    },

    // 预览回证PDF
    showViewPdfReceipt: function (row) {
      var self = this;
      var params = {
        bizType: 'receipt',
        bizKey: row.id,
      }
      api.dzbaFileViewPDF(params).done(function (res) {
        if (res.code == '0') {
          if (!res.data) {
            tools.info('未获取到文件信息');
            return
          }
          if (self.isWindows) {
            // Windows 系统：调用单证助手客户端
            if (!res.data.fileUrl) {
              tools.info('未获取到文件信息');
              return
            }
            var param = {
              fileName: '',
              fileUrl: res.data.fileUrl,
              title: '回证文书'
            }
            apiClient.checkDzjNew(param);
          } else {
            // 非 Windows 系统：使用 PDF.js 预览
            if (!res.data.fileStream) {
              tools.info('未获取到文件信息');
              return
            }
            components['pdfViewerglobal-pdf'].showPdf(res.data.fileStream, '回证文书');
          }
        }
      });
    },

    // 立项审核/复核 - 分配弹框显示
    showFpDialog: function (isPlfp, row) {
      this.isPlfp = isPlfp;
      this.fpInspector = '';
      if (isPlfp) {
        var selRows = this.getSelRow('plFP');
        if (selRows.row.length == 0) {
          tools.info('请至少选择一笔可分配的任务');
          return
        }
      } else{
        if(row && row.inspector) this.fpInspector=row.inspector;
      }
      $('.model').show();
      $('.dzhc-lxgl .page-model-fp').show();
      this.showInspectorErr = false;
      this.getInspectorList();
    },

    // 立项审核/复核 - 分配弹框隐藏
    hideFpDialog: function () {
      $('.model').hide();
      $('.dzhc-lxgl .page-model-fp').hide();
    },

    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function (key) {
      if (key == 'searchData') {
        this.searchData.nsrmc = '';
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
        if (this.qySearchType != 'nsrsbh') return
      }
      this[key].nsrsbh = this[key].nsrsbh.trim()
      var nsrsbh = this[key].nsrsbh
      if (nsrsbh.length < 4) {
        return;
      }
      var params = {
        qybs: nsrsbh
      }
      var self = this
      ajax("POST", "/dzba/inspect/nsrxx/list", params, false, false, true).done(function (res) {
        if (res.code == '0') {
          if (key == 'searchData') {
            self.nsrsbhList = res.data || [];
            self.activeBgIndex = self.nsrsbhList.length>0? 0: -1
            self.showNsrsbh()
          } else {
            self.nsrsbhCkywList = res.data || [];
            self.activeBgCkywIndex = self.nsrsbhCkywList.length>0? 0: -1
            self.showNsrsbhCkyw();
          }
        }
      })
    },

    getNsrxx: function (e) {
      var self = this
      this.nsrxx.nsrsbh = this.nsrxx.nsrsbh.trim()
      if (this.nsrxx.nsrsbh == '' || this.nsrxx.nsrsbh.length < 4) {
        this.resetNsrxx()
        return;
      }
      this.showNsrsbhCkywList = false
      var params = {
        nsrsbh: this.nsrxx.nsrsbh
      }
      api.dzbaYearProjectAddBaseinfo(params).done(function (res) {
        if (res.code == '0') {
          var data_k = Object.keys(res.data);
          for (var i = 0; i < data_k.length; i++) {
            res.data[data_k[i]] ? null : res.data[data_k[i]] = '';
          }
          // fob起点，数字三分位
          res.data.fobqd = avalon.filters.number(res.data.fobqd, 2);
          self.nsrxx = res.data;
          self.ywccblList = res.data.ywccblxx || [];
          self.spdmCheckedList = [];
          var v1 = res.data.spdmxx || [];
          self.spdmCheckedList = self.spdmCheckedList.concat(v1);
          self.mygCheckedList = [];
          var v2 = res.data.mygjdqxx || [];
          self.mygCheckedList = self.mygCheckedList.concat(v2);
          self.hcConf.lxdh = res.data.lxdh || '';
        } else {
          var nsrsbh = self.nsrxx.nsrsbh;
          self.resetNsrxx();
          self.nsrxx.nsrsbh = nsrsbh;
          self.sbnypcList = [];
        }
      })
      // 单证类型也需要获取
      var params = {
        nsrsbh: this.nsrxx.nsrsbh,
        entryIds: [{ ywlxCode: '', entryId: '', sbrq: '' }],
        type: 'year',
      }
      this.getTypeTreeData(params);
    },
    setNsrsbh: function (item, key) {
      this[key].nsrsbh = item.nsrsbh;
      this.showNsrsbhList = false
      if (key == 'nsrxx') {
        this[key].nsrmc = item.nsrmc;
        this.getNsrxx();
        $('#zbrwNrsbhCkywInp').blur();
      } else {
        this.qySearchVal = item.nsrsbh;
        this.search(1)
      }
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function () {
      if (this.qySearchType != 'nsrsbh') return
      var list = this.nsrsbhList
      this.showNsrsbhList = list && list.length > 0;
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function (e) {
      if ($(e.target).parent().hasClass('nsrsbh-group')) return
      this.showNsrsbhCkywList = false
    },

    keydown: function (e, id) {
      if (id == 'lxglNrsbhList') {
        if (this.qySearchType != 'nsrsbh') return
        var index = this.activeBgIndex
        var len = this.nsrsbhList.length
      } else {
        var index = this.activeBgCkywIndex
        var len = this.nsrsbhCkywList.length
      }
      //38:上  40:下
      if (e.keyCode == 38) {
        if (index > -1) {
          index--
        } else {
          index = len - 1
        }
        this.stopDefault(e)
      } else if (e.keyCode == 40) {
        if (index < len) {
          index++
        } else {
          index = 0
        }
        this.stopDefault(e)
      }
      if (index >= len) {
        index = len - 1;
      }
      if (index < 0) {
        index = 0;
      }
      if (id == 'lxglNrsbhList') {
        this.activeBgIndex = index
      } else {
        this.activeBgCkywIndex = index
      }
      var pHeight = $('#' + id + ' p:first').height() // p元素高度
      if (index > 2) {
        $("#" + id).scrollTop(pHeight * (index - 3) + 9)
      } else {
        $("#" + id).scrollTop(0)
      }
      if (e.keyCode == 13) {  // enter
        var item = {}
        var key = ''
        if (id == 'lxglNrsbhList') {
          item = this.nsrsbhList[index],
            key = 'searchData'
        } else {
          item = this.nsrsbhCkywList[index],
            key = 'nsrxx'
        }
        if (item) {
          this[key].nsrsbh = item.nsrsbh
          if (id == 'lxglNrsbhList') {
            this.qySearchVal = item.nsrsbh;
          } else {
            this[key].nsrmc = item.nsrmc;
          }
        }
      }
    },
    //阻止事件执行
    stopDefault: function (event) {
      //阻止默认浏览器动作(W3C)   
      if (event && event.preventDefault) {
        //火狐的 事件是传进来的e  
        event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式   
      else {
        //ie 用的是默认的event  
        event.returnValue = false;
      }
    },

    // 批量立项
    approveBatch: function () {
      var selRows = this.getSelRow('plLX');
      if (selRows.row.length == 0) {
        tools.info('请至少选择一笔可立项的任务');
        return
      }
      var row = selRows.row;
      this.showLxglProgress();
      this.runApproveBatch(row, row.length);
    },
    runApproveBatch: function (row, total) {
      var self = this;
      if (row.length == 0) {
        avalonRoot.pllxProgress = 100;
        setTimeout(function () {
          self.hideLxglProgress();
          self.search(self.searchData.pageNo);
          var msg = '';
          if(self.progressErrs.length>0){
            msg = self.progressErrs.join('<br />');
          } else {
            msg = '批量立项完成'
          }
          tools.info(msg);
        }, 500)
        return
      }
      var curRow = row.splice(0, 1);
      var params = {
        id: curRow[0].id
      }
      api.dzbaYearProjectApproveSingle(params, true, true).done(function (res) {
        var rotate = ((total - row.length) / total * 100).toFixed(2);
        avalonRoot.pllxProgress = rotate < 5 ? 5 : rotate;
        self.runApproveBatch(row, total);
        if(res.code!='0' && self.progressErrs.indexOf(res.msg)==-1){
          self.progressErrs.push(res.msg);
        } else if(res.code=='0' && res.data && self.progressErrs.indexOf(res.data)==-1){ // 纸质备案企业特殊处理
          self.progressErrs.push(res.data);
        }
      }).fail(function () {
        var rotate = ((total - row.length) / total * 100).toFixed(2);
        avalonRoot.pllxProgress = rotate < 5 ? 5 : rotate;
        self.runApproveBatch(row, total);
        if(self.progressErrs.indexOf('接口调用失败')==-1) self.progressErrs.push('接口调用失败');
      })
    },

    // 显示进度条
    showLxglProgress: function () {
      $('.lxgl-progress-loading').show();
      $('.lxgl-progress-loading .lxgl-progress').show();
      avalonRoot.pllxProgress = 5;
      this.progressErrs = [];
    },

    // 显示进度条
    hideLxglProgress: function () {
      $('.lxgl-progress-loading').hide();
      $('.lxgl-progress-loading .lxgl-progress').hide();
      avalonRoot.pllxProgress = 0;
    },

    showDropdown: function (e) {
      var self = this;
      $(".dropdown-menu", e.target).show();
      $('.dzhc-new').on('click', function (e) {
        var e = e || window.event;
        if ($('.dropdown-menu').find($(e.target)).length <= 0) {
          self.hideDropdown();
        }

      })
    },
    hideDropdown: function () {
      $(".dropdown-menu").hide();
      $('.dzhc-new').off('click');
    },

    /**
     * 根据参数获取选中行数据
     * type  plDel-批量删除  plFP-批量分配  plLX-批量立项  plVoid-批量作废
    */
    getSelRow: function (type) {
      var selRow = {
        row: [],
        ids: [],
      }
      if (type == 'plDel') {
        for (var i = 0; i < this.tableData.rows.length; i++) {
          if (this.tableData.rows[i].status == 0 && this.selRows.indexOf(String(this.tableData.rows[i].id)) > -1) {
            selRow.ids.push(String(this.tableData.rows[i].id));
            selRow.row.push(this.tableData.rows[i]);
          }
        }
      };
      if (type == 'plFP') {
        for (var i = 0; i < this.tableData.rows.length; i++) {
          if (this.tableData.rows[i].status != 9 && this.selRows.indexOf(String(this.tableData.rows[i].id)) > -1) {
            selRow.ids.push(String(this.tableData.rows[i].id));
            selRow.row.push(this.tableData.rows[i]);
          }
        }
      }
      if (type == 'plLX') {
        for (var i = 0; i < this.tableData.rows.length; i++) {
          if (this.tableData.rows[i].status == 0 && this.selRows.indexOf(String(this.tableData.rows[i].id)) > -1) {
            selRow.ids.push(String(this.tableData.rows[i].id));
            selRow.row.push(this.tableData.rows[i]);
          }
        }
      }
      if (type == 'plVoid') {
        for (var i = 0; i < this.tableData.rows.length; i++) {
          if (this.tableData.rows[i].status == 1 && this.selRows.indexOf(String(this.tableData.rows[i].id)) > -1) {
            selRow.ids.push(String(this.tableData.rows[i].id));
            selRow.row.push(this.tableData.rows[i]);
          }
        }
      }
      return selRow
    },

    // 批量删除
    delBatch: function () {
      var self = this;
      var selRows = this.getSelRow('plDel');
      if (selRows.row.length == 0) {
        tools.info('请至少选择一笔可删除的任务');
        return
      }
      var row = selRows.row;
      var ids = selRows.ids;
      var text = '确定删除';
      var len = row.length > 1 ? 2 : row.length;
      var nsrmcs = [];
      for (var i = 0; i < len; i++) {
        nsrmcs.push(row[i].nsrmc + '【' + row[i].year + '】立项年度');
      }
      text += nsrmcs.join('，');
      if (row.length > 1) text += '等';
      text += '的项目吗？'
      tools.confirm(text, '确定', function () {
        var params = {
          ids: ids.join(','),
        }
        api.dzbaYearProjectDelBatch(params).done(function (res) {
          if (res.code == 0) {
            tools.info('批量删除成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 批量作废
    voidBatch: function () {
      var self = this;
      var selRows = this.getSelRow('plVoid');
      if (selRows.row.length == 0) {
        tools.info('请至少选择一笔可作废的任务');
        return
      }
      var row = selRows.row;
      var ids = selRows.ids;
      var text = '确定作废';
      var len = row.length > 1 ? 2 : row.length;
      var nsrmcs = [];
      for (var i = 0; i < len; i++) {
        nsrmcs.push(row[i].nsrmc + '【' + row[i].year + '】立项年度');
      }
      text += nsrmcs.join('，');
      if (row.length > 1) text += '等';
      text += '的单证审核吗？'
      tools.confirm(text, '确定', function () {
        var params = {
          ids: ids.join(','),
        }
        api.dzbaYearProjectVoidBatch(params).done(function (res) {
          if (res.code == 0) {
            tools.info('批量作废成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 批量分配
    fpBatch: function () {
      var self = this;
      var selRows = this.getSelRow('plFP');
      var row = selRows.row;
      var ids = selRows.ids;
      var text = '确定把';
      var len = row.length > 1 ? 2 : row.length;
      var nsrmcs = [];
      for (var i = 0; i < len; i++) {
        nsrmcs.push(row[i].nsrmc + '【' + row[i].year + '】立项年度');
      }
      text += nsrmcs.join('，');
      if (row.length > 1) text += '等';
      if (!this.fpInspector) {
        this.showInspectorErr = true;
        return
      }
      text += '的单证核查分配给【' + this.fpInspector + '】吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          ids: ids.join(','),
          inspector: self.fpInspector,
        }
        api.dzbaYearProjectAssignBatch(params).done(function (res) {
          if (res.code == 0) {
            tools.info('批量分配成功');
            self.hideFpDialog();
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 开始分配
    fpConfirm: function () {
      if (this.isPlfp) {
        this.fpBatch();
      } else {
        this.fpSingle();
      }
    },

    // 单笔分配
    fpSingle: function () {
      var self = this;
      var row = this.currentRow;
      if (!this.fpInspector) {
        this.showInspectorErr = true;
        return
      }
      var text = '确定把' + row.nsrmc + '【' + row.year + '】立项年度的单证核查分配给【' + this.fpInspector + '】吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
          inspector: self.fpInspector,
        }
        api.dzbaYearProjectAssignSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('分配成功');
            self.hideFpDialog();
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 单笔删除
    delSingle: function (row) {
      var self = this;
      var text = '确定删除' + row.nsrmc + '【' + row.year + '】立项年度的项目吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
        }
        api.dzbaYearProjectDelSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('删除成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 单笔作废
    voidSingle: function (row) {
      var self = this;
      var text = '确定作废' + row.nsrmc + '【' + row.year + '】立项年度的单证核查吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
        }
        api.dzbaYearProjectVoidSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('作废成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 单笔立项
    approveSingle: function (row) {
      var self = this;
      var text = '确定对' + row.nsrmc + '【' + row.year + '】年度的单证核查进项立项吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
        }
        api.dzbaYearProjectApproveSingle(params, false).done(function (res) {
          if (res.code == 0) {
            if(res.data){ // 纸质备案企业特殊处理
              tools.info(res.data);
            } else{
              tools.info('立项成功');
            }
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 导出
    exform: function () {
      tools.exform(this.searchData, '/dzba/export/inspect/year/project');
    },

    // 新建任务 - 自动生成
    createTaskAuto: function () {
      this.showAddTask();
    },
    showAddTask: function () {
      $('.model').show();
      $('.dzhc-lxgl .page-model-addtask').show();
      this.resetNsrxx();
      this.getInspectorList();
    },
    hideAddTask: function () {
      $('.model').hide();
      $('.dzhc-lxgl .page-model-addtask').hide();
    },

    // 新建任务 - 导入
    createTaskImport: function () {
      this.showAddTaskImport();
    },
    showAddTaskImport: function () {
      $('.model').show();
      $('.dzhc-lxgl .page-model-addtaskImport').show();
    },
    hideAddTaskImport: function () {
      $('.model').hide();
      $('.dzhc-lxgl .page-model-addtaskImport').hide();
    },

    // 新建核查项目 - 自动生成
    runAddTask: function () {
      var self = this;
      if (!self.hcConf.deadline) {
        tools.info('项目期限不能为空');
        return
      }
      // 检查业务抽查比例是否合规  等级越高比例越小
      if(!this.ywccblCheck()) return
      var fobStart = this.getFobStart();
      if (!fobStart) fobStart=0;
      if (!self.nsrxx.nsrsbh) {
        tools.info('社会信用码不能为空');
        return
      }
      if (!self.hcConf.inspector) {
        tools.info('请先选择审核人');
        return
      }
      if(self.hcConf.lxdh){
        var checkMsg = tools.checkPhone(self.hcConf.lxdh);
        if(checkMsg) {
            tools.info(checkMsg);
            return
        };
      }
      var params = {
        nsrsbh: self.nsrxx.nsrsbh,
        year: self.hcConf.year,
        qygm: self.nsrxx.qygm,
        deadline: self.hcConf.deadline,
        inspector: self.hcConf.inspector,
        lxdh: self.hcConf.lxdh,
        fobqd: fobStart,
        range: self.editRangeList.join(','),
        spdmxx: self.spdmCheckedList,
        mygjdqxx: self.mygCheckedList,
        ywccblxx: self.ywccblList,
      }
      if(!params.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      api.dzbaYearProjectBaseinfoAdd(params).done(function (res) {
        if (res.code == '0') {
          if(res.data){
            var projectId	 = res.data.projectId	|| '';
            var sbnypcs = res.data.sbnypcs || '';
            var ywbs = res.data.ywbs || '';
            var text = '成功创建项目(序号是'+projectId+')，项目下自动生成【'+ywbs+'】笔业务，分布在【'+sbnypcs+'】个申报年月批次下。';
            tools.info(text);
          } else{
            tools.info('操作成功');
          }
          self.hideAddTask();
          self.search(1);
        }
      })

    },

    // 导入模板下载
    exformModel: function () {
      tools.exform({}, '/dzba/inspect/year/project/approve/download');
    },

    // 获取核查单证类型
    getTypeTreeData: function (params) {
      var self = this;
      self.typeTreeData = [];
      api.dzbaInspectTree(params).done(function (res) {
        if (res.code == '0') {
          self.typeTreeData = res.data
          self.editRangeList = [];
          for (var i = 0; i < self.typeTreeData.length; i++) {
            var item = self.typeTreeData[i].item
            for (var j = 0; j < item.length; j++) {
              if (item[j].checked) {
                self.editRangeList.push(item[j].value)
              }
            }
          }
        }
      })
    },

    // 显示纳税人识别号弹框-选择出口业务
    showNsrsbhCkyw: function () {
      var list = this.nsrsbhCkywList
      this.showNsrsbhCkywList = list && list.length > 0
    },
    //阻止事件执行
    stopDefault: function (event) {
      //阻止默认浏览器动作(W3C)   
      if (event && event.preventDefault) {
        //火狐的 事件是传进来的e  
        event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式   
      else {
        //ie 用的是默认的event  
        event.returnValue = false;
      }
    },
    resetNsrxx: function () {
      this.nsrxx = {
        nsrsbh: '',
        nsrmc: '',
        qyhgdm: '',
        qylx: '',
        flglcd: '',
        qygm: '',
        qygmName: '',
        spdm: '',
        mygjdq: '',
        fobqd: '',
      }
      this.typeTreeData = [];
    },

    // 业务比例变更事件
    ywblChg: function () {
      var ywccbl = parseFloat(this.hcConf.ywccbl);
      if (!ywccbl || ywccbl < 1) ywccbl = 1;
      if (ywccbl > 100) ywccbl = 100;
      this.hcConf.ywccbl = ywccbl;
    },
    

    // 仅限输入数字
    inpChg: function(e){
      var val = e.target.value.replace(/[^0-9|\.]/g, '');
      if(val.split('.').length>2){
        val = parseFloat(val);
        val = isNaN(val)? 0: val;
      }
      val = val? val: 0;
      e.target.value = val;
      return val
    },
    inpChgYwccbl: function(e, ywItem){
      ywItem.ywccbl = this.inpChg(e);
      if(e.target.value>100){
        e.target.value = 0;
        tools.info('业务抽查比例不可超过100');
        return
      }
      // 处理负数情况
      for(var i=0; i<this.ywccblList.length; i++){
        if(this.ywccblList[i].ywccbl<0) this.ywccblList[i].ywccbl = -parseFloat(this.ywccblList[i].ywccbl);
      }
    },

    showDropdownScrw: function (e, targetCls) {
      var self = this;
      if($(e.target, '.dzhc-lxgl .dropdown').length>0 && $(e.target).parent().length>0){
        e.target = $(e.target).parent()[0];
      }
      $(".dropdown-menu."+targetCls, e.target).show();
      $('#dzhcLxgl'+targetCls).focus();
      $('.dzhc-lxgl').on('click', function (e) {
        var e = e || window.event;
        if ($('.dropdown-menu.'+targetCls).find($(e.target)).length <= 0) {
          self.hideDropdownScrw(targetCls);
        }

      })
    },
    hideDropdownScrw: function (targetCls) {
      $(".dropdown-menu."+targetCls).hide();
      $('.dzhc-lxgl').off('click');
    },

    rersetSpdmSearchList: function(type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      var searchList = type=='spdm'? this.spdmSearchList: this.mygSearchList;
      var item = type=='spdm'? 'spdm': 'gbCode';
      for(var i=0; i<searchList.length; i++){
        searchList[i].checked = false;
        for(var j=0; j<checkList.length; j++){
          if(searchList[i][item] == checkList[j][item]){
            searchList[i].checked = true;
          }
        }
      }
    },

    // 删除已选择的意向商品
    spCheckDel: function(index, type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      checkList.splice(index, 1);
      this.rersetSpdmSearchList(type);
    },

    // 意向商品代码搜索
    spdmSearchChg: function(e){
      var self = this;
      var spdm = e.target.value;
      if(spdm.length<4) return
      var params = {
        spdm: spdm,
      }
      api.dzbaInspectYearHgspList(params).done(function(res){
        if(res.code=='0'){
          if(!res.data) {
            self.spdmSearchList = [];
            return
          }
          for(var i=0; i<res.data.length; i++){
            res.data[i].checked = false;
          }
          self.spdmSearchList = res.data;
          $(".dzhc-lxgl .dropdown-menu.spdm").show();
          self.rersetSpdmSearchList('spdm');
        }
      })
    },

    // 意向商品代码勾选/取消勾选
    spSearchChg: function(index, type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      var searchList = type=='spdm'? this.spdmSearchList: this.mygSearchList;
      var item = type=='spdm'? 'spdm': 'gbCode';
      if(searchList[index].checked){
        var spdmItem = tools.clone(searchList[index]);
        checkList.push(spdmItem);
      } else{
        var curIndex = -1;
        for(var i=0; i<checkList.length; i++){
          if(checkList[i][item] == searchList[index][item]){
            curIndex = i;
          }
        }
        checkList.splice(curIndex, 1);
      }
    },

    // 贸易国代码搜索
    mygSearchChg: function(e){
      var self = this;
      var gbxx = e.target.value;
      // 如果是数字，要求三位
      if(/^[\d|a-z]+$/.test(gbxx) && gbxx.length<3) return;
      if(gbxx.length<2) return
      var params = {
        gbxx: gbxx,
      }
      api.dzbaInspectYearBgxxGet(params).done(function(res){
        if(res.code=='0'){
          if(!res.data) {
            self.mygSearchList = [];
            return
          }
          self.mygSearchList = [
            {
              gbCode: res.data.gbCode,
              gbName: res.data.gbName,
              checked: false,
            }
          ];
          $(".dzhc-lxgl .dropdown-menu.myg").show();
          self.rersetSpdmSearchList('myg');
        }
      })
    },

    getFobStart: function(){
      var fobStart = String(this.nsrxx.fobqd).replace(/,/g, '');
      fobStart = parseFloat(fobStart);
      if(fobStart<0) fobStart = -fobStart;
      return fobStart
    },
    inpChgFob: function(e){
      this.inpChg(e);
      e.target.value = avalon.filters.number(e.target.value, 2);
    },

    // 检查业务抽查比例是否合规  等级越高比例越小
    ywccblCheck(){
      for(var i=1; i<this.ywccblList.length; i++){
        var start = parseFloat(this.ywccblList[i-1].ywccbl);
        var end = parseFloat(this.ywccblList[i].ywccbl);
        if(end>start){
          var text = '【' + this.ywccblList[i].range + '】的抽查比例不能超过【' + this.ywccblList[i-1].range + '】的抽查比例';
          tools.info(text);
          return false
        }
      }
      return true
    },

    showModelSearch: function(type){
      this.searchType = type;
      $('.model').css('z-index', 360);
      $('.dzhc-lxgl .page-model-search-lx').show();
    },
    hideModelSearch: function(){
      $('.model').css('z-index', 300);
      $('.dzhc-lxgl .page-model-search-lx').hide();
    },



  }
})