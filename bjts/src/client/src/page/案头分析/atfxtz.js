var atfxtz = require("./atfxtz.html");
avalon.component('atfxtz', {
  template: atfxtz,
  defaults: {
    params: {},
    searchData: {
      pageSize: config.pageSize,
      nsrmc:'',
      nsrsbh:'',
      orderSql: ''
    },
    tableData: {},
    addTitle: '',
    pageSize: 20,
    currentRowid: '',
    gtfxrymcList: [],
    editData: {
      id: "",
      sqrmc: '',
      sqrq: '', // 使用当前日期
      ckhwtmsjsffMc: "",
      nsrsbh: "",
      swjgMc: "",
      fxqq: "",
      fxqz: "",
      nsrmc: "",
      fxr2Dm: "",
      jsmode: "",
    },
    spData: {
      id: '',
      sqrMc: '',
      sqrq: '',
      nsrmc: '',
      nsrsbh: '',
      tmsjsfs: '',
      fxqq: '',
      fxqz: '',
      fxr2Mc: '',
      spjg: null
    },
    permList: {},
    onReady: function () {
      this.getPerm()

      // this.getBbdlList()
    },
    // 获取登录人权限
    getPerm() {
      var self = this;
      ajax("POST", "/auth/user/atfxtz/checkPerm").done(function (res) {
        if (res.code == '0') {
          self.permList = res.data
          self.getTableRow();
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    linkSp() {
      var self = this;
      if (!self.spData.spjg) {
        tools.info('请选择审批意见！')
        return
      }
      let params = {
        spjg: self.spData.spjg,
        uuid: self.spData.uuid,
      }
      ajax("POST", "/cxfw/atfx/tz/sh", params).done(function (res) {
        if (res.code == '0') {
          tools.info('提交成功');
          self.hidespModel()
          self.search(1);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    getTableRow: function () {
      //   已取消("100", "已取消"),
      //   待审批("110", "待审批"),
      //   数据准备("120", "数据准备"),
      //   案头分析("130", "案头分析"),
      //   出具报告("140", "出具报告"),
      //   已发放("150", "已发放"),
      var self = this;
      var tableArr = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, sortable: false, resizable: false, formatter: function (cellvalue, options, rowObject) {
            var str = "<div style='text-align:center;'>";
            if (rowObject.tzzt === '110') {
              if (self.permList['F_ATFXTZ:SP'] === '1' && rowObject.czrySwjgDm === avalonRoot.user.swjgDm) {
                str += "<div class='btn shenpi' style='float: none;display: inline-block;' title='审批'>审批</div>"
              } else {
                str += "<div class='btn disabled' style='float: none;display: inline-block;' title='审批'>审批</div>"
              }
            } else if (rowObject.tzzt === '120' || rowObject.tzzt === '999' || rowObject.tzzt === '100' || rowObject.tzzt === '150' || rowObject.czrySwjgDm !== avalonRoot.user.swjgDm || !self.isInSource(rowObject)) {
              str += "<div class='btn disabled' style='float: none;display: inline-block;' title='查看'>查看</div>"
              str += "<div class='btn disabled' style='float: none;display: inline-block;margin-left: 5px;' title='结束'>结束</div>"
            } else {
              str += "<div class='btn edit' style='float: none;display: inline-block;' title='查看'>查看</div>"
              str += "<div class='btn end-task' style='float: none;display: inline-block;margin-left: 5px;' title='结束'>结束</div>"
            }
            str += "</div>"
            return str;
          }
        },
        { name: "uuid", label: "uuid", index: "uuid", width: 180, align: "left", sortable: false, hidden: true },
        { name: "nsrmc", label: "纳税人名称", index: "nsrmc", width: 190, align: "left", sortable: false },
        {
          name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", sortable: true, align: "left", width: 165, formatter: function (cellvalue, options, rowObject) {
            if (rowObject.tzzt == '110' || rowObject.tzzt === '999'|| rowObject.tzzt == '100' || rowObject.tzzt == '120' || rowObject.tzzt == '150' || rowObject.czrySwjgDm !== avalonRoot.user.swjgDm || !self.isInSource(rowObject)) {
              return "<span style='color:#a5a5a5;' class='openMx'>" + cellvalue + "</span>"
            } else {
              return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx edit'>" + cellvalue + "</span>"
            }
          }
        },
        { name: "ckhwtmsjsffMc", label: "退(免)税计算方法", index: "ckhwtmsjsffMc", sortable: false, align: "left", width: 100 },
        { name: "ckhwtmsjsffDm", label: "退(免)税计算方法代码", index: "ckhwtmsjsffDm", sortable: false, align: "left", width: 100, hidden: true },
        { name: "fxqq", label: "分析期起", index: "fxqq", sortable: false, align: "center", width: 100, hidden: true },
        { name: "fxqz", label: "分析期止", index: "fxqz", sortable: false, align: "center", width: 100, hidden: true },
        {
          name: "atfxrqqz", label: "案头分析期起-止", index: "atfxrqqz", sortable: false, align: "center", width: 140, formatter: function (cellvalue, options, rowObject) {
            return self.getYearMonth(rowObject.fxqq)  + "至" + self.getYearMonth(rowObject.fxqz)
          }
        },
        { name: "sqrMc", label: "申请人名称", index: "sqrMc", sortable: true, align: "left", width: 100, },
        { name: "fxr2Mc", label: "共同分析人员名称", index: "fxr2Mc", sortable: true, align: "left", width: 120, },
        { name: "djxh", label: "登记序号", index: "djxh", sortable: false, align: "left", width: 100,hidden:true },
        { name: "czrySwjgDm", label: "操作人员税务机关代码", index: "czrySwjgDm", sortable: false, align: "left", width: 100, hidden:true },
        { name: "sqrq", label: "申请日期", index: "sqrq", sortable: true, align: "center", width: 100, },
        { name: "spjgStr", label: "审批意见", index: "spjg", sortable: false, align: "left", width: 80 },
        { name: "sprMc", label: "审批人名称", index: "sprMc", sortable: true, align: "left", width: 100 },
        { name: "sprq", label: "审批日期", index: "sprq", sortable: true, align: "center", width: 150, },
        { name: "tzztStr", label: "状态", index: "tzzt", sortable: true, align: "left", width: 80, },
        { name: "wcrq", label: "完成日期", index: "wcrq", sortable: true, align: "center", width: 100, },
        { name: "op",  label: "操作", width: 160, align: "center", resizable: false, search: false, sortable: false }

      ]
      self.createTable(tableArr)
    },
        /**
     * 格式化日期字符串为年月格式
     * @param {String} dateString - 日期字符串
     * @returns {String} 年月格式的日期字符串
     */
    getYearMonth: function (dateString) {
      if (!dateString) return '';
      if (/^\d{4}-\d{2}$/.test(dateString)) {
        return dateString;
      }
      if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        return dateString.substring(0, 7);
      }
      return '';
    },
    isInSource(rowObject){
      if(avalonRoot.user.czryDm === rowObject.sprDm ||avalonRoot.user.czryDm === rowObject.fxr2Dm || avalonRoot.user.czryDm === rowObject.sqrDm ){
        return true
      }else{
        return false
      }
    },
    getToday() {
      var today = new Date();
      var year = today.getFullYear();
      var month = (today.getMonth() + 1).toString().padStart(2, '0');
      var day = today.getDate().toString().padStart(2, '0');
      var currentDate = year + '-' + month + '-' + day;
      return currentDate
    },
    initDatepicker() {
      var options = { language: "zh-CN", format: "yyyy-mm", autoclose: true, clearBtn: true, startView: 3, minView: 3, endDate: new Date(), };
      // 初始化日期控件
      $('.atfxtz .datepicker.date-atfxxqz').datetimepicker(options);
      $('.atfxtz .datepicker.date-atfxxqq').datetimepicker(options);
    },
    // // 日期选择框多次点击会隐藏的bug修复
    // showDatetimepicker: function (e) {
    //   $(e.target).datetimepicker('show');
    // },
    addAtfx() {
      var self = this;
      if (!self.editData.nsrsbh) {
        tools.info('请输入纳税人识别号！');
        return
      }
      if (!self.editData.fxqq) {
        tools.info('请选择案头分析期起日期！');
        return
      }
      if (!self.editData.fxqz) {
        tools.info('请选择案头分析期止日期！');
        return
      }
      if (self.editData.fxqq > self.editData.fxqz) {
        tools.info('案头分析期起不能大于案头分析期止！');
        return
      }
      // if (!self.editData.fxr2Dm) {
      //   tools.info('共同分析人员不能为空！');
      //   return
      // }
      let params = {
        nsrsbh: self.editData.nsrsbh.trim(),
        fxqq: self.editData.fxqq+'-01',
        fxqz:  self.editData.fxqz+'-'+self.getLastDayOfMonth(self.editData.fxqz),
        fxr2Dm: self.editData.fxr2Dm,
      }
      ajax("POST", "/cxfw/atfx/tz/add", params).done(function (res) {
        if (res.code == '0') {
          tools.info('添加成功！');
          self.search(1);
          self.hideModel();
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })

    },
        /**
     * 获取指定年月的最后一天
     * @param {String} dateString - 年月字符串，格式为YYYY-MM
     * @returns {Number} 该月的天数
     */
    getLastDayOfMonth(dateString) {
      const [year, month] = dateString.split('-').map(Number);
      return new Date(year, month, 0).getDate();
    },
    getGtfxryList() {
      var self = this
      ajax("POST", "/cxfw/atfx/base/czryList").done(function (res) {
        if (res.code == '0') {
          // if (res.data.length < 1) {
          //   tools.info('未查询到共同分析人员信息！');
          // } else {
            let list = res.data || []
            self.gtfxrymcList = list
          // }
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    showModel: function () {
      var self = this
      self.editData = {
        id: "",
        sqrmc: avalonRoot.user.czrymc,
        sqrq: self.getToday(), // 使用当前日期
        phone: "",
        nsrsbh: "",
        swjgMc: "",
        fxqq: "",
        fxqz: "",
        nsrmc: "",
        fxr2Dm: "",
        jsmode:''
      };
      self.initDatepicker()
      self.getGtfxryList()
      $(".model").show();
      $(".atfxtz .atfxtz-xz-model").show();
    },
    nsrsbhChange() {
      let nsrsbh = this.editData.nsrsbh.trim()
      let params = {
        nsrsbh,
        pageNo: 1,
        pageSize: 20
      }
      var self = this;
      if (nsrsbh) {
        ajax("POST", "/cxfw/atfx/base/qycxList", params).done(function (res) {
          if (res.code == '0') {
            if (res.data.rows.length < 1) {
              tools.info('未查询到该纳税人信息！');
            } else {
              let info = res.data.rows[0]
              self.editData.nsrmc = info.nsrmc
              self.editData.jsmode = info.jsmode
            }
          } else {
            tools.info(res.msg);
          }
        }).fail(function (err) {
          tools.info(err);
        })
      }
    },
    showSpModel() {
      var row = $("#atfxtz-table").jqGrid("getRowData", this.currentRowid);
      // 处理nsrsbh字段，去除HTML标签
      var nsrsbhValue = row.nsrsbh;
      if (nsrsbhValue) {
        // 使用正则表达式去除HTML标签，只保留文本内容
        nsrsbhValue = nsrsbhValue.replace(/<[^>]*>/g, '');
      }
      var atfxrqqz = row.atfxrqqz || "";
      var startDate = "";
      var endDate = "";

      if (atfxrqqz && atfxrqqz.includes("至")) {
        var dates = atfxrqqz.split("至");
        startDate = dates[0];
        endDate = dates[1];
      }
      this.spData = {
        uuid: row.uuid,
        sqrMc: row.sqrMc,
        sqrq: row.sqrq,
        nsrmc: row.nsrmc,
        nsrsbh: nsrsbhValue,  // 使用处理后的纯文本值
        tmsjsfs: row.tmsjsfs,
        fxqq: startDate,
        fxqz: endDate,
        fxr2Mc: row.fxr2Mc,
        ckhwtmsjsffMc: row.ckhwtmsjsffMc,
        spjg: null
      };
      $(".model").show();
      $(".atfxtz .atfxtz-sp-model").show();
    },
    hideModel() {
      $(".model").hide();
      $(".atfxtz .atfxtz-xz-model").hide();
    },
    hidespModel() {
      $(".model").hide();
      $(".atfxtz .atfxtz-sp-model").hide();
    },
    createTable: function (arr) {
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      $("#atfxtz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: '#atfxtz-tablePager',
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".atfxtz .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass("shenpi")) {
            self.currentRowid = rowid;
            self.showSpModel();
            return false;
          }
          if ($(e.target).hasClass("edit")) {
            var row = $("#atfxtz-table").jqGrid("getRowData", rowid);
            var startDate = "";
            var endDate = "";
            var atfxrqqz = row.atfxrqqz || "";
            if (atfxrqqz && atfxrqqz.includes("至")) {
              var dates = atfxrqqz.split("至");
              startDate = dates[0];
              endDate = dates[1];
            }
            console.log(row,99)
            avalonRoot.addTab({
              title: "企业基础信息明细", component: "atfxmx", params: {
                uuid: row.uuid, // 跳转完成后执行一次查询
                startDate,
                endDate,
                djxh:row.djxh,
                fxqq: row.fxqq,
                fxqz: row.fxqz,
                nsrmc: row.nsrmc,
                nsrsbh: row.nsrsbh.replace(/<[^>]*>/g, ''),
                atfxrqqz: row.atfxrqqz,
                swjgDm: row.czrySwjgDm,
                ckhwtmsjsffDm: row.ckhwtmsjsffDm  // 出口货物劳务计税方法代码
              }
            });
            return false;
          }
          // 结束按钮点击事件
          if ($(e.target).hasClass("end-task")) {
            var row = $("#atfxtz-table").jqGrid("getRowData", rowid);
            // 弹出确认框
            tools.confirm('【结束】流程操作之后，无法再进行查看数据，是否继续执行此操作？', '确定', function () {
              // 点击确定，请求接口
              var params = {
                uuid: row.uuid
              };
              ajax("POST", "/cxfw/atfx/tz/js", params).done(function (res) {
                if (res.code == '0') {
                  tools.info('结束成功！');
                  self.search(1); // 刷新列表
                } else {
                  tools.info(res.msg);
                }
              }).fail(function (err) {
                tools.info(err);
              });
            });
            // 点击取消无后续操作
            return false;
          }

        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "atfxtz-table");
          self.search(pageNo);
        }

      })
      $("#atfxtz-table").jqGrid('setFrozenColumns');
      // tools.HeiKjNoSel('atfxtz', 'atfxtz-table');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.atfxtz')).val();
      self.search(1)
    },


    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $('.atfxtz')).val();
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo
      params.nsrmc = params.nsrmc.trim()
      params.nsrsbh = params.nsrsbh.trim()
      $("#atfxtz-table").jqGrid('clearGridData')
      ajax("POST", "/cxfw/atfx/tz/list", params).done(function (res) {
        if (res.code == '0') {
          $("#atfxtz-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          tools.HeiKjNoSel('atfxtz', 'atfxtz-table')
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
  }
});