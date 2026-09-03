var sbfjyl = require("./sbfjyl.html");

avalon.component('sbfjyl', {
  template: sbfjyl,
  defaults: {
    searchData: {
      swjgdm: "",
      qybs: "",
      sbywb: "",
      fjzt: "1",
      sssqStart: "",
      sssqEnd: "",
      yxscrqq: "",
      yxscrqz: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
    },
    swjgmc: '',
    curSbxxRow: {},
    sbywbMap: [
      {
        value: 'A0301001',
        label: '外贸企业免退税申报',
      },
      {
        value: 'A0305001',
        label: '生产企业免抵退申报',
      },
      {
        value: 'A0101001',
        label: '出口退(免)税备案',
      },
      {
        value: 'A0102001',
        label: '出口退(免)税备案变更',
      },
      {
        value: 'A0103001',
        label: '出口退(免)税备案撤回',
      },
      {
        value: 'A0105001',
        label: '集团企业备案',
      },
      {
        value: 'A0107001',
        label: '先退税后核销资格申请申报',
      },
      {
        value: 'A0109001',
        label: '生产企业委托代办退税情况备案',
      },
      {
        value: 'A0110001',
        label: '外贸综合服务企业代办退税情况备案',
      },
      {
        value: 'A0111001',
        label: '生产企业委托代办退税情况备案撤回',
      },
      {
        value: 'A0201001',
        label: '代理出口证明申报',
      },
      {
        value: 'A0201002',
        label: '代理进口证明申报',
      },
      {
        value: 'A0201003',
        label: '委托代理证明申报',
      },
      {
        value: 'A0201004',
        label: '出口转内销证明申报',
      },
      {
        value: 'A0201005',
        label: '退运已补税(未退税)证明申报',
      },
      {
        value: 'A0201007',
        label: '中标证明通知书申报',
      },
      {
        value: 'A0202001',
        label: '补办出口退税有关证明',
      },
      {
        value: 'A0203001',
        label: '来料加工核销证明申报',
      },
      {
        value: 'A0203002',
        label: '来料加工免税证明申报',
      },
      {
        value: 'A0205001',
        label: '出口卷烟免税核销证明申报',
      },
      {
        value: 'A0205002',
        label: '准予免税购进出口卷烟证明申报',
      },
      {
        value: 'A0205003',
        label: '出口卷烟已免税证明申报',
      },
      {
        value: 'A0302001',
        label: '出口非自产货物退消费税申报',
      },
      {
        value: 'A0303001',
        label: '出口已使用旧设备免退税申报',
      },
      {
        value: 'A0304001',
        label: '购进自用货物免退税申报',
      },
      {
        value: 'A0306001',
        label: '生产企业进料加工核销申报',
      },
      {
        value: 'A0307001',
        label: '生产企业进料加工备案申报',
      },
      {
        value: 'A0308001',
        label: '生产企业进料加工计划分配率变更申报',
      },
      {
        value: 'A0309001',
        label: '航天发射免退税申报',
      },
      {
        value: 'A0310001',
        label: '综服企业代办退税申报',
      },
      {
        value: 'A0401001',
        label: '出口退税电子信息查询申报',
      },
      {
        value: 'A0402001',
        label: '无相关电子信息备案',
      },
      {
        value: 'A0404001',
        label: '出口收汇数据申报（未认定）',
      },
      {
        value: 'A0405001',
        label: '出口数据延期申报',
      },
      {
        value: 'A0409001',
        label: '短信提醒申报',
      },
      {
        value: 'A0409002',
        label: '放弃免税权申报',
      },
      {
        value: 'A0409003',
        label: '放弃零税率申报',
      },
      {
        value: 'A0409004',
        label: '放弃退免税申报',
      },
      {
        value: 'A0409005',
        label: '恢复适用出口退(免)税政策声明',
      },
      {
        value: 'A0410001',
        label: '未申报的误勾选退税发票回退申请',
      },
      {
        value: 'A0410002',
        label: '企业撤回申报数据申请',
      },
      {
        value: 'A0503001',
        label: '管理类别评定资料申报',
      },
      {
        value: 'Z0202002',
        label: '作废出口退税有关证明申请',
      },
    ],
    resetSearchData: function () {
      var sssqStart = tools.getFontMonths(3)
      var sssqEnd = tools.getToday()
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        qybs: "",
        sbywb: "",
        fjzt: "1",
        sssqStart: tools.getMonth(sssqStart),
        sssqEnd: tools.getMonth(sssqEnd),
        yxscrqq: "",
        yxscrqz: "",
        orderSql: "",
        pageNo: 1,
        pageSize: 20,
      };
    },
    onInit: function (e) {
      avalonRoot.sbfjyl = e.vmodel;
    },

    onReady: function () {
      this.initUser();
      this.initDate();
      var sssqStart = tools.getFontMonths(3)
      var sssqEnd = tools.getToday()
      this.searchData.sssqStart = tools.getMonth(sssqStart)
      this.searchData.sssqEnd = tools.getMonth(sssqEnd)
      this.initTree();
      this.initHeight();
      this.createTable();
      this.createTableFjlb();
    },

    // 初始化用户数据
    initUser: function () {
      var self = this;
      if (avalonRoot.user && avalonRoot.user.swjgDm) {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
        this.searchData.releaser = avalonRoot.user.czrymc;
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.swjgmc = avalonRoot.user.swjgMc;
            self.searchData.releaser = avalonRoot.user.czrymc;
          }
        })
      }
    },

    // 初始化日期输入框
    initDate: function () {
      var self = this;
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, endDate: new Date(), };
      $('.sb-fjyl .datepicker.date-day').datetimepicker(options);
      $('.sb-fjyl .datepicker.date-month').datetimepicker({
        language: 'zh-CN',
        format: 'yyyymm',
        weekStart: 1,
        // todayBtn: true,
        // clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        endDate: new Date(),
        forceParse: 0,
      }).on('hide', function (e) {
        if (!e.target.value) self.searchData.sbpc = '';
      })
    },
    ssqChange: function(key){
      if (key == 'sssqStart') {
        var date = this.searchData.sssqStart.substring(0,4)+ '-' + this.searchData.sssqStart.substring(4,6) + '-01'
        var max_end = tools.getNextMonths(12, date);
        max_end = tools.getMonth(max_end)
        if (this.searchData.sssqEnd > max_end || this.searchData.sssqStart > this.searchData.sssqEnd) {
          this.searchData.sssqEnd = max_end
        }
      }
      if (key == 'sssqEnd') {
        var date = this.searchData.sssqEnd.substring(0,4)+ '-' + this.searchData.sssqEnd.substring(4,6) + '-01'
        var min_start = tools.getFontMonths(12, date);
        min_start = tools.getMonth(min_start)
        if (this.searchData.sssqStart < min_start || this.searchData.sssqStart > this.searchData.sssqEnd) {
          this.searchData.sssqStart = min_start
        }
      }
    },
    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".sb-fjyl .form").height();
        if (h > 100) {
          $("#sb-fjyl-table").jqGrid('setGridHeight', h - 70);
        }
      })
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
          $.fn.zTree.init($(".sb-fjyl .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.sb-fjyl').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.sb-fjyl').off('click');
    },

    search: function (pageNo) {
      var self = this;
      var dateValid1 = tools.checkDate(this.searchData.sssqStart, this.searchData.sssqEnd)
      if (!dateValid1) {
        tools.info('所属期截止日期必须大于起始日期')
        return false
      }
      var dateValid2 = tools.checkDate(this.searchData.yxscrqq, this.searchData.yxscrqz)
      if (!dateValid2) {
        tools.info('上传日期截止日期必须大于起始日期')
        return false
      }
      this.searchData.pageSize = $(".ui-pg-selbox", $('.sb-fjyl')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#sb-fjyl-table").jqGrid('clearGridData')
      api.bjtsswSbxxList(params).done(function (res) {
        if (res.code == '0') {
          $("#sb-fjyl-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "sbid", label: "申报id", index: "sbid", hidden: true },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "nsrdzdah", label: "纳税人电子档案号", index: "nsrdzdah", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", align: "left", sortable: false },
        { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm", width: 100, align: "left", sortable: false },
        { name: "nsrsbh", label: "纳税人税号", index: "nsrsbh", width: 135, align: "left" },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", align: "left", sortable: false },
        { name: "lyZh", label: "来源", index: "lyZh", width: 70, align: "center", sortable: false },
        { name: "sbywbZh", label: "申报业务种类", index: "sbywbZh", align: "center", sortable: false },
        { name: "sssq", label: "所属期", index: "sssq", width: 80, align: "center" },
        { name: "sbpc", label: "申报批次", index: "sbpc", width: 80, align: "center", sortable: true, },
        { name: "sbrq", label: "申报提交日期", index: "sbrq", width: 100, align: "center" },
        { name: "sbztZh", label: "申报状态", index: "sbztZh", width: 80, align: "center", sortable: false },
        {
          name: "fjsl", label: "附件数量", index: "fjsl", width: 75, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "op", label: "操作", width: 0, frozen: true, align: "center", resizable: false, sortable: false, formatter: function (cellVal, op, row) {
            var enableClass = row.fjsl > 0? '': 'disabled';
            var titleName = row.fjsl>0? '显示附件': '不存在附件';
            var res = "<div class='btn op-btn op-fjlb "+enableClass+"' title='"+titleName+"'>附件</div>";

            return res
          }
        },
      ];
      $("#sb-fjyl-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#sb-fjyl-tablePager',
        shrinkToFit: true,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".sb-fjyl .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $('#sb-fjyl-table').jqGrid('getRowData', rowid);
          if ($(e.target).hasClass('op-fjlb')) { // 附件列表弹框
            if($(e.target).hasClass('disabled')) return
            self.curSbxxRow = row;
            self.showFjlb(1);
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
          var pageNo = tools.getPageNo(pgButton, "sb-fjyl-table");
          self.search(pageNo);
        },
      })
      $("#sb-fjyl-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('#sb-fjyl-tablePager')).val();
      this.search(1)
    },

    createTableFjlb: function () {
      var self = this;
      var columns = [
        { name: "id", label: "文件id", index: "id", hidden: true },
        { name: "nsrdzdah", label: "纳税人电子档案号", index: "nsrdzdah", hidden: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", hidden: true },
        { name: "title", label: "文件标题", index: "title", align: "left", sortable: false },
        {
          name: "filesize", label: "文件大小(kb)", index: "filesize", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) {
              cellVal = cellVal / 1000; // 将 bite 转化为 kb
              cellVal = avalon.filters.number(cellVal, 0);
            }
            return cellVal
          }
        },
        { name: "fmcode", label: "文件格式", index: "fmcode", width: 80, align: "center", sortable: false },
        { name: "yxscrq", label: "上传日期", index: "yxscrq", width: 130, align: "center", sortable: false },
        { name: "note", label: "备注", index: "note", align: "left", sortable: false },
        {
          name: "op", label: "操作", width: 0, frozen: true, align: "center", resizable: false, sortable: false, formatter: function (cellVal, op) {
            var res = "<div>";
            res += "<div class='btn op-btn op-fjyl' title='附件'>附件</div>";
            res += "<div class='btn op-btn op-fj-download' title='下载'>下载</div>";
            res += '</div>';
            return res
          }
        },
      ];
      $("#sb-fjyl-fj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#sb-fjyl-fj-tablePager',
        shrinkToFit: true,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: 300,
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-fjyl')) { // 附件预览
            var row = $('#sb-fjyl-fj-table').jqGrid('getRowData', rowid);
            self.showModelPdf(row)
            return false
          } if($(e.target).hasClass('op-fj-download')){ // 附件下载
            var row = $('#sb-fjyl-fj-table').jqGrid('getRowData', rowid);
            self.downloadPdf(row);
            return false
          } else {
            return true;
          }
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "sb-fjyl-fj-table");
          self.searchFjlb(pageNo);
        },
      })
    },

    showFjlb: function(){
      $('.model').show();
      $('.page-model-fjlb').show();
      this.searchFjlb(1)
    },

    hideFjlb: function(){
      $('.model').hide();
      $('.page-model-fjlb').hide();
    },

    searchFjlb: function(pageNo){
      var row = this.curSbxxRow;
      var params = {
        sbid: row.sbid,
        nsrdzdah: row.nsrdzdah,
        nsrsbh: row.nsrsbh,
        pageSize: $(".ui-pg-selbox", $('#sb-fjyl-fj-tablePager')).val(),
        pageNo: pageNo,
        orderSql: '',
      }
      $("#sb-fjyl-fj-table").jqGrid('clearGridData')
      api.sbxxDocList(params).done(function (res) {
        if (res.code == '0') {
          $("#sb-fjyl-fj-table")[0].addJSONData(res.data);
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },
    createPdf: function(url) {
      var options = {
        pdfOpenParams: {
          navpanes: 0,
          toolbar: 0,
          statusbar: 0,
          view: "FitV",
          pagemode: "thumbs",
          page: 1
        },
        forcePDFJS: true,
        PDFJS_URL: "../../jdgl/static/pdfjs/web/viewer.html"
      };

      var myPDF = PDFObject.embed(url, "#sb-fjyl-pdf", options);

      var el = document.querySelector("#sb-fjyl-results");
      el.setAttribute("class", (myPDF) ? "success" : "fail");
      el.innerHTML = (myPDF) ? "" : "Uh-oh, the embed didn't work.";
    },
    showModelPdf: function(row){
      var params = {
        nsrdzdah: row.nsrdzdah,
        nsrsbh: row.nsrsbh,
        fileId: row.id
      }
      var self = this
      api.sbxxDocView(params).done(function(res){
        if(res.code=='0' && res.data){
          $('.model').show();
          $('.sb-fjyl .page-model-pdf').show();
          var pdfSrc = res.data;
          var pdfBlob = tools.dataURLtoBlob('data:application/pdf;base64,' + pdfSrc);
          var pdfUrl = URL.createObjectURL(pdfBlob);
          self.createPdf(pdfUrl)
        }
      })
    },
    hideModelPdf:function(){
      $('.sb-fjyl .page-model-pdf').hide();
    },
    // 下载pdf
    downloadPdf: function(row){
      var params = {
        nsrdzdah: row.nsrdzdah,
        nsrsbh: row.nsrsbh,
        fileId: row.id
      }
      api.sbxxDocView(params).done(function(res){
        if(res.code=='0' && res.data){
          tools.downloadByBlob(res.data, row.title);
        }
      })
    },


  }
})