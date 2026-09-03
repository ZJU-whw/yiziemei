var hcgl=require("./hcgl.html");
avalon.component('hcgl', {
    template:hcgl,
    defaults: {
      params:{},
      act:1,
      tcode:"hcgl",
	    swjgmc: "",
        selRows: [], // 选中项
        searchData:{
          swjg_dm: "",
          nsrsbh:"",
          nsrmc:"",
          qyhgdm: "",
          status: "",
          sfyq: "",
          releaseStart: "", // 受理下达日期起
          releaseEnd: "", // 受理下达日期止
          reportStart: "", // 上报日期起
          reportEnd: "", // 上报日期止
          inspectStart: "", // 核查日期起
          inspectEnd: "", // 核查日期止
          releaser:"",//下达人
          sbywzl: "",
          sbnypc: "",
          entryId: "",
          sssq: "",
          sbpc: "",
          orderSql: "",
          pageSize: config.pageSize,
        },
        searchAddCkywData: {
          sbywzl: '',
          nsrsbh: '',
          sssq: '',
          sbpc: '',
          ckbgdh: '',
          hth: '',
          glh: '',
          ckrqq: '',
          ckrqz: '',
          orderSql: "",
          pageSize: config.pageSize,
        },
        sbpcList: [],
        mainSbpcList: [], // 主列表查询条件中申报批次列表
        typeTreeData: [], // 核查单证类型
        editData: {},
        editRow: {},
        addIndex: 0,
        selRowsCkyw: [],
        ckywChooseList: [],
        defaultRangeList: [],
        rangeList: [], // 新增时选中的核查单证类型
        editRangeList: [], // 编辑/查看时选中的核查单证类型
        isError: false,
        finisnData: {
          failNum: 0,
          faillTmse: 0,
          notDoneNum: 0,
          notDoneTmse: 0,
          successNum: 0,
          successTmse: 0,
          totalNum: 0,
          totalTmse: 0,
        },
        finisnList: [
          { label: '企业税号', key: 'nsrsbh'},
          { label: '企业名称', key: 'nsrmc'},
          { label: '退税方式', key: 'tsjsfs'},
          { label: '管理类别', key: 'gllb'},
          { label: '申报批次', key: 'sbnypc'},
          { label: '退免税额', key: 'tmse', type: 'number'},
          { label: '报关单号', key: 'entryId'},
          { label: '出口日期', key: 'eDate'},
          { label: '贸易方式', key: 'supvModeCodeName'},
          { label: '合同号', key: 'contrNo'},
          { label: '备案号', key: 'manualNo'},
          { label: '运输方式', key: 'cusTrafModeName'},
          { label: '运输工具', key: 'trafName'},
          { label: '提运单号', key: 'billNo'},
          { label: '贸易国', key: 'cusTradeNationCodeName'}
        ],
        modelData: {
          id: '',
          inspectNo: '',
          inspectResult: '1',
          processType: '',
          resultState: ''
        },
        statusOption: [
          { name: '未下达', value: '0' },
          { name: '已下达', value: '1' },
          { name: '已退回', value: '1A' },
          { name: '已收讫', value: '2' },
          { name: '已上报', value: '3' },
          { name: '已审核', value: '4' }
        ],
        disabled: false,
        nsrxx: {
          nsrsbh: '',
          nsrmc: '',
          qyhgdm: '',
          tsjsfs: '',
          gllb: '',
          tsjsfsName: '',
          jydz: '',
          lxr: '',
          lxrDh: ''
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        modelAddStyle: {
          0: {
            width: '1060px',
            marginLeft: '-530px',
            height: '540px',
            marginTop: '-270px',
            contentHeight: '450px'
          },
          1: {
            width: '580px',
            marginLeft: '-290px',
            height: '314px',
            marginTop: '-157px',
            contentHeight: '225px'
          }
        },
        showNsrsbhList: false,
        nsrsbhList: [],
        showNsrsbhCkywList: false,
        nsrsbhCkywList: [],
        timeout: null,
        activeBgIndex: -1,
        activeBgCkywIndex: -1,
        onReady:function(){
            try {
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
			      this.createTable();
            this.createTableAddCkyw();
            this.initTree();
            $('.hcgl .datepicker.date-day').datepicker({
              dateFormat: 'yy-mm-dd'
            });
            $('.hcgl .datepicker.date-month').datetimepicker({
              language:'zh-CN',
              format: 'yyyymm',
              weekStart: 1,
              // todayBtn: true,
              clearBtn: true,
              autoclose: 1,
              todayHighlight: 1,
              startView: 3, // 这里就设置了默认视图为年视图
              minView: 3, // 设置最小视图为年视图
              forceParse: 0,
            })
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
        onInit:function(e){
          avalonRoot.hcgl = e.vmodel;
        },
        createTable:function(){
          var self=this;
          var columns = [
            { name: "op2", label:"操作", width:0, frozen: true, align:"center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
              var status = rowObject.status
              var isEditVal = status == 0 ? '编辑' : '查看'
              var releaseVal = status == 3 ? '退回' : '下达'
              var auditVal = status == 4 ? '审核撤销' : '审核结束'
              var auditDisable = status == 0 || status == 1 || status == 2
              return "<div class='btn op-btn edit' title='"+isEditVal+"'>"+isEditVal+"</div>" // 编辑/查看
              +"<div class='btn op-btn del "+(status==4?"disabled" : "")+"' title='删除'>删除</div>"
              +"<div class='btn op-btn "+(status==3?"back" : "release")+(status!='0' && status!='3'?" disabled" : "")+"' title='"+releaseVal+"'>"+releaseVal+"</div>" // 下达/退回
              +"<div class='btn op-btn hcend "+(auditDisable?"disabled" : "")+"' title='"+auditVal+"'>"+auditVal+"</div>"; // 审核结束/审核撤销
            }},
            { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
            { name: "inspectNo", label: "核查序号", index: "inspectNo", width: 70, align:"center" },
            { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 100, align:"center" },
            { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left" },
            { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 80, align:"center" },
            { name: "entryId", label: "报关单号", index: "entryId",width: 135, align:"center" },
            { name: "status", label: "状态", index: "status", hidden: true},
            { name: "statusName", label: "状态", index: "statusName",width: 60, align:"center",sortable: false },
            { name: "releaser", label: "下达人", index: "releaser",width: 70, align:"center" },
            { name: "releaseTime", label: "下达日期", index: "releaseTime",width: 80, align:"center" },
            { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center" },
            { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 135, align:"center" },
            { name: "sbywzl", label: "退税申报业务种类", index: "sbywzl",width: 100, align:"center" },
            { name: "reportTime", label: "上报日期", index: "reportTime",width: 125, align:"center" },
            { name: "inspectTime", label: "核查日期", index: "inspectTime",width: 125, align:"center" },
            { name: "deadline", label: "资料报送期限", index: "deadline",width: 80, align:"center" },
            { name: "inspectState", label: "审核意见", index: "inspectState",width: 80, align:"left" },
            { name: "range", label: "单证核查范围", index: "range",width: 140, align:"center" },
            { name: "withdrawReason", label: "退回原因", index: "withdrawReason",width: 140 },
            { name: "op", label:"操作", width:280, align:"center", resizable: false, search: false, sortable: false}
          ];
          $("#hcgl-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#hcgl-tablePager',
            shrinkToFit: false,
            width:"100%",
            multiselect: true,
            multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: config.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return $(".hcgl .form").height() -60;
            })(),
            beforeSelectRow:function(rowid,e){
              var row = $('#hcgl-table').jqGrid('getRowData',rowid); 
              if (row.status == '0') {
                if($(e.target).hasClass('release')){ // 下达
                  var params = {
                    inspectNo: row.inspectNo,
                  }
                  self.dialogDate("确定下达核查序号为"+row.inspectNo+"的核查任务？","/dzba/inspect/release/single",params)
                }
              }
              if($(e.target).hasClass('del')){ // 删除
                if (row.status == '4') {
                  return false
                }
                var url = ''
                if (row.status == '0') {
                  url = '/dzba/inspect/task/delete'
                } else {
                  url = '/dzba/inspect/task/withdraw'
                }
                tools.confirm('确定删除核查序号为'+row.inspectNo+'的核查任务？','确定',function(){
                  ajax("POST", url, {inspectNo: row.inspectNo}).done(function(res){
                      if(res.code=='0'){
                          tools.info("操作成功")
                          self.search(1);
                      }else{
                          tools.info(res.msg);
                      }
                  }).fail(function(err){
                      tools.info(err);
                  })
                })
              }
              if ($(e.target).hasClass('hcend')) {
                if (row.status == '3') { // 审核结束
                  self.showModel({inspectNo: row.inspectNo, id: row.id})
                } else if (row.status == '4') { // 审核撤销
                  tools.confirm("确定对核查序号为"+row.inspectNo+"的核查任务进行审核撤销操作？",'确定',function(){
                    ajax("POST","/dzba/inspect/finish/withdraw",{inspectNo: row.inspectNo}).done(function(res){
                      if(res.code=='0'){
                          tools.info("审核撤销成功")
                          self.search(1);
                      }else{
                          tools.info(res.msg);
                      }
                    }).fail(function(err){
                        tools.info(err);
                    })
                  })
                }
              } else if($(e.target).hasClass('edit')) { // 编辑
                $('.model').show();
                $('.hcgl .page-model-edit').show()
                self.editRow = row
                self.getTypeTreeData({nsrsbh: row.nsrsbh,entryIds:[{ywlxCode:row.ywlxCode}]})
                self.getInfo({inspectNo: row.inspectNo, nsrsbh: row.nsrsbh})
                return false
              } else if($(e.target).hasClass('back')){ // 退回
                var html = '<p class="mb-5">原因描述:</p><textarea rows="8" cols="60" id="hcglBackReason"></textarea><p id="hcglBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p>'
                $.dialog({
                  padding: '10px 20px',
                  title: "核查任务退回重报(核查序号："+row.inspectNo+")",
                  content: html,
                  okValue: '确定',
                  lock:true,
                  ok: function() {
                    var val = $('#hcglBackReason').val().trim()
                    if (val == '') {
                      $('#hcglBackReasonTip').show()
                      return false;
                    }
                    $('.d-buttons').css('text-align','right');
                    var params = {
                      inspectNo: row.inspectNo,
                      remark: val
                    }
                    ajax("POST","/dzba/inspect/task/back", params).done(function(res){
                      if(res.code=='0'){
                          tools.info("退回成功！")
                          self.search(1);
                      }else{
                          tools.info(res.msg);
                      }
                    }).fail(function(err){
                        tools.info(err);
                    })
                  },
                  cancelValue: '取消',
                  cancel:function(){
                    $('.d-buttons').css('text-align','right');
                  }
                })
                $('.d-buttons').css('text-align','center');
              } else{
                return true;
              }
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"hcgl-table");
              self.search(pageNo);
            },
            onSelectRow: function(rowid,status){
              var index = self.selRows.indexOf(rowid);
              if (status) {
                self.selRows.push(rowid)
              } else {
                self.selRows.splice(index,1);
              }
            },
            onSelectAll: function(rowids,status) {
              if (status) {
                self.selRows = JSON.parse(JSON.stringify(rowids));
              } else {
                self.selRows = [];
              }
            }
          })
          $("#hcgl-table").jqGrid('setFrozenColumns');
          this.searchData.pageSize = $(".ui-pg-selbox", $('.hcgl')).val();
          this.search(1)
        },
        nsrsbhEnterSearch: function(e) {
          e.target.blur()
          this.showNsrsbhList = false
          this.search(1)
        },
        search:function(pageNo){
          var self=this;
	        var fields = [
		        {name:"hgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"shxydm",rules:'max_length[21]',message:"社会信用代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"纳税人名称最大长度为30"},
	        ];

          var dateValid1 = tools.checkDate(this.searchData.releaseStart, this.searchData.releaseEnd)
          var dateValid2 = tools.checkDate(this.searchData.reportStart, this.searchData.reportEnd)
          var dateValid3 = tools.checkDate(this.searchData.inspectStart, this.searchData.inspectEnd)
          if (!dateValid1) {
            tools.info('下达日期截止日期必须大于起始日期')
            return false
          }
          if (!dateValid2) {
            tools.info('上报日期截止日期必须大于起始日期')
            return false
          }
          if (!dateValid3) {
            tools.info('核查日期截止日期必须大于起始日期')
            return false
          }
          if (!this.searchData.sssq && !this.searchData.sbpc) {
            this.searchData.sbnypc = ''
          }
          if (this.searchData.sssq) {
            if (!this.searchData.sbpc) {
              tools.info('申报年月不为空时，申报批次也不能为空')
              return;
            } else {
              this.searchData.sbnypc = this.searchData.sssq + '-' + this.searchData.sbpc
            }
          } 
          if (!this.searchData.sssq && this.searchData.sbpc) {
            tools.info('申报批次不为空时，申报年月也不能为空')
            return;
          }
	        var isValid = tools.validate("hcgl-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.hcgl')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
            $("#hcgl-table").jqGrid('clearGridData')
		        ajax("POST","/dzba/inspect/list",params).done(function(res){
			        if(res.code=='0'){
				        $("#hcgl-table").clearGridData();
				        $("#hcgl-table").resetSelection();
                self.selRows = [];
				        $("#hcgl-table")[0].addJSONData(res.data);
				        self.tableData=res.data;
                tools.HeiKj('hcgl', 'hcgl-table')
                self.closeHyper()
			        }else{
				        tools.info(res.msg);
			        }
		        }).fail(function(err){
			        tools.info(err);
		        })
	        }
        },
        showHyper:function(){
          $('.hcgl .page .select-sub').toggle();
          $('.hcgl .page .select-wrapper .icon').toggleClass("active");
          if ($('.hcgl .page .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
              $('.hcgl .page .select-wrapper .icon').attr("title","收起查询条件");
          } else {
              $('.hcgl .page .select-wrapper .icon').attr("title","展开查询条件")
          }
        },
        closeHyper:function(){
          $('.hcgl .select-sub').hide();
          $('.hcgl .select-wrapper .icon').removeClass('active');
          $('.hcgl .select-wrapper .icon').attr("title","展开查询条件")
        },
      // 导出
      exform:function(){
        var self=this;
        if($('#hcgl-table').jqGrid('getRowData').length<=0){
            tools.info("请先查询列表");
            return ;
        }
        var params = tools.clone(self.searchData)
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", "/dzba/export/inspect");
        var input1 = $("<input>");
        input1.attr("type", "hidden");
        input1.attr("name", "data");
        input1.attr("value", JSON.stringify(params));
        $("body").append(form); //将表单放置在web中
        form.append(input1);
        form.submit();
        form.remove();
      },
      // 批量下达
      batchRelease () {
        if (this.selRows.length <=0) {
          tools.info("请至少选择一条记录！");
          return false;
        }
        var inspectNosArr = []
        for (var i = 0; i < this.selRows.length;i++ ){
          let no = getCellData("hcgl-table", this.selRows[i], 'inspectNo')
          let status = getCellData("hcgl-table", this.selRows[i], 'status')
          if (status != '0') {
            tools.info("只能勾选状态为未下达的任务")
            return false
          }
          inspectNosArr.push(no);
        }
        var inspectNos =  inspectNosArr.join(',')
        var params = {
          inspectNos: inspectNos,
        }
        this.dialogDate("确定下达？","/dzba/inspect/release/batch",params)
      },
      dialogDate: function(text,url,param) {
        var self = this
        var content = "<div style='padding: 10px 60px 20px 20px'><div style='padding-bottom: 10px;'><label>资料报送期限:</label><input id='hcgl-deadline' type='text' /></div><div>"+text+"</div></div>"
        $.dialog({
          title: "提示",
          padding: 0,
          content: content,
          okValue: '确定',
          lock:true,
          ok: function() {
            var params = tools.clone(param)
            params.deadline = $('#hcgl-deadline').val()
            ajax("POST",url,params).done(function(res){
              if(res.code=='0'){
                tools.info("操作成功")
                self.search(1);
              }else{
                tools.info(res.msg);
              }
            }).fail(function(err){
                tools.info(err);
            })
          },
          cancelValue: '取消',
          cancel:function(){
          }
        })
        $('#hcgl-deadline').datepicker({
          dateFormat: 'yy-mm-dd',
          defaultDate: '+15d',
          minDate: '+1d',
          maxDate: '+30d'
        })
        var defaultDeadline = tools.getDateStr(15)
        $('#hcgl-deadline').val(defaultDeadline)
      },
	    reset: function() {
		    this.searchData = {
          swjg_dm: avalonRoot.user.swjgDm,
          nsrsbh:"",
          nsrmc:"",
          qyhgdm: "",
          releaser:"",
          status: "",
          sfyq: "",
          releaseStart: "", // 受理下达日期起
          releaseEnd: "", // 受理下达日期止
          reportStart: "", // 上报日期起
          reportEnd: "", // 上报日期止
          inspectStart: "", // 核查日期起
          inspectEnd: "", // 核查日期止
          sbywzl: "",
          sbnypc: "",
          entryId: "",
          sssq: "",
          sbpc: "",
          orderSql:"",
          pageSize:config.pageSize,
        };
	    },
      createTask: function () {
        $('.model').show();
        $('.hcgl .page-model-add').show();
      },
      // 新增任务-出口业务表格
      createTableAddCkyw:function(){
        var self=this;
        var columns =  [
          { name: "ywlxCode", label: "ywlxCode", index: "ywlxCode", hidden: true},
          { name: "inspectNo", label: "inspectNo", index: "inspectNo", hidden: true},
          { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true},
          { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName",width: 100, align:"center",sortable: false },
          { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 80, align:"center",sortable: false },
          { name: "entryId", label: "报关单号", index: "entryId",width: 140, align:"center",sortable: false },
          { name: "ckrq", label: "出口日期", index: "ckrq",width: 80, align:"center",sortable: false },
          // { name: "hth", label: "合同号", index: "hth",width: 140, align:"center",sortable: false },
          { name: "je", label: "FOB价(美元)", index: "je", hidden: true },
          { name: "jeName", label: "FOB价(美元)", index: "jeName", width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){return avalon.filters.number( rowObject.je,2);} },
          { name: "se", label: "退免税额", index: "se", hidden: true },
          { name: "seName", label: "退免税额", index: "seName", width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){return avalon.filters.number( rowObject.se,2);} },
          { name: "sbrq", label: "退税申报日期", index: "sbrq", width: 80, align:"center",sortable: false },
          { name: "slrq", label: "退税受理日期", index: "slrq", width: 80, align:"center",sortable: false },
          { name: "ywgjz", label: "业务关键字", index: "ywgjz", width: 140, align:"center",sortable: false },
        ]
        $("#hcgl-ckyw-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            rownumbers:true,
            shrinkToFit: false,
            autoScroll: true, 
            multiselect: true,
            viewrecords: true,
            pager: '#hcgl-ckyw-tablePager',
            multiselectWidth:"30",
            altRows: true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: config.pageSize,
            rowList: [20,50,100,500],
            width: 1060,
            height:210,
            onSortCol: function (index, iCol, sortorder) {
              self.searchAddCkywData.orderSql = index + ' ' + sortorder;
              return;
            },
            onSelectRow: function(rowid,status){
              var rowObj = $('#hcgl-ckyw-table').getRowData(rowid)
              var index = self.selRowsCkyw.indexOf(rowid);
              if (status) {
                self.ckywChooseList.push(rowObj)
                self.selRowsCkyw.push(rowid)
              } else {
                self.ckywChooseList.splice(index,1);
                self.selRowsCkyw.splice(index,1);
              }
            },
            onSelectAll: function(rowids,status) {
              var idArr = rowids.map(function(item){
                return $('#hcgl-ckyw-table').getRowData(item)
              })
              if (status) {
                self.ckywChooseList = idArr;
                self.selRowsCkyw = JSON.parse(JSON.stringify(rowids));
              } else {
                self.ckywChooseList = [];
                self.selRowsCkyw = []
              }
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"hcgl-ckyw-table");
              self.searchCkyw(pageNo);
            }
        })
        this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.hcgl .page-model-add .hcgl-ckyw-table')).val();
      },
      // 查询出口业务列表
      searchCkyw:function(pageNo){
        var self=this;
        this.searchAddCkywData.nsrsbh = this.nsrxx.nsrsbh
        if (!this.searchAddCkywData.nsrsbh || !this.searchAddCkywData.sbywzl) {
          tools.info('请输入正确的社会信用码！');
          return false;
        }
        if (!this.searchAddCkywData.sssq){
          tools.info('请选择申报批次！');
          return false;
        }
        var dateValid = tools.checkDate(this.searchAddCkywData.ckrqq, this.searchAddCkywData.ckrqz)
        if (!dateValid) {
          tools.info('出口日期截止日期必须大于起始日期');
          return false;
        }
        this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.hcgl .page-model-add')).val() || 20;
        var params=tools.clone(self.searchAddCkywData);
        params.pageNo=pageNo
        $("#hcgl-ckyw-table").jqGrid('clearGridData')
        $('.loading').show()
        ajax("POST","/dzba/inspect/task/available/list",params).done(function(res){
          if(res.code=='0'){
            $("#hcgl-ckyw-table").resetSelection();
            $("#hcgl-ckyw-table")[0].addJSONData(res.data);
            self.ckywChooseList = []
            self.selRowsCkyw = []
          }else{
            tools.info(res.msg);
          }
          $('.loading').hide()
        }).fail(function(err){
          tools.info(err);
          $('.loading').hide()
        })
      },
      nextStep: function(){
        if (this.ckywChooseList.length<=0) {
          tools.info('请先查询并选择出口业务数据！')
          return false;
        }
        this.addIndex = 1
        var entryIds = []
        for (var i=0;i<this.ckywChooseList.length;i++) {
          let ywlxCode = this.ckywChooseList[i].ywlxCode ? this.ckywChooseList[i].ywlxCode : '';
          let sbrq = this.ckywChooseList[i].sbrq ? this.ckywChooseList[i].sbrq : '';
          entryIds.push({ywlxCode:ywlxCode, sbrq: sbrq})
        }
        this.getTypeTreeData({nsrsbh: this.nsrxx.nsrsbh,entryIds:entryIds})
      },
      getNsrxx:function() {
        var self = this
        this.nsrxx.nsrsbh = this.nsrxx.nsrsbh.trim()
        if (this.nsrxx.nsrsbh == '') {
          this.resetNsrxx()
          return;
        }
        this.showNsrsbhCkywList = false
        var params = {
          qybs: this.nsrxx.nsrsbh
        }
        ajax("POST","/dzba/inspect/nsrxx/get",params).done(function(res){
          if(res.code=='0'){
            self.nsrxx = res.data
            self.searchAddCkywData.nsrsbh = res.data.nsrsbh
            self.searchAddCkywData.sbywzl = res.data.sbywzl
            if (self.searchAddCkywData.sssq) {
              self.getSbpcs()
            }
          }else{
            var nsrsbh = self.nsrxx.nsrsbh
            self.resetNsrxx()
            self.nsrxx.nsrsbh = nsrsbh
            self.sbpcList = []
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      resetNsrxx: function () {
        this.nsrxx = {
          nsrsbh: '',
          nsrmc: '',
          qyhgdm: '',
          tsjsfs: '',
          gllb: '',
          tsjsfsName: '',
          jydz: '',
          lxr: '',
          lxrDh: ''
        }
        this.searchAddCkywData = {
          sbywzl: '',
          nsrsbh: '',
          sssq: '',
          sbpc: '',
          ckbgdh: '',
          hth: '',
          glh: '',
          ckrqq: '',
          ckrqz: '',
          orderSql: "",
          pageSize: config.pageSize,
        }
        this.sbpcList = []
      },
      resetTask: function() {
        this.resetNsrxx()
        this.resetCkywTable()
        this.nsrsbhCkywList = []
      },
      resetCkywTable: function(){
        this.rangeList = tools.clone(this.defaultRangeList)
        this.ckywChooseList = []
        this.selRowsCkyw = []
        $("#hcgl-ckyw-table").resetSelection();
        $("#hcgl-ckyw-table")[0].addJSONData([]);
      },
      // 新增
      createTaskConfirm: function(){
        var self = this
        var params = {
          nsrsbh: this.searchAddCkywData.nsrsbh,
          range: this.rangeList.join(','),
          inspectDatas: this.ckywChooseList
        }
        if(!params.range){
          tools.info('请至少选择一种核查单证类型');
          return
        }
        ajax("POST","/dzba/inspect/task/add",params).done(function(res){
          if(res.code=='0'){
            self.hideModelTask()
            tools.info('操作成功');
            self.search(1)
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
            tools.info(err);
        })
      },
      showModel:function(row){
        var self = this
        ajax("POST","/dzba/inspect/finish/pre",{inspectNo: row.inspectNo}).done(function(res){
          if(res.code=='0'){
            self.finisnData = res.data
            self.modelData = {
              id: row.id,
              inspectNo: row.inspectNo,
              inspectResult: self.finisnData.failNum > 0 ? '2':'1',
              processType: '',
              resultState: self.finisnData.resultState || ''
            }
            $('.model').show();
            $('.hcgl .page-model-end').show();
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
        
      },
      hideModel:function(){
        $('.model').hide();
        $('.hcgl .page-model-end').hide();
        this.modelData={
          id: '',
          inspectNo: '',
          inspectResult: '1',
          processType: '',
          resultState: ''
        }
      },
      hideModelTask:function(){
        $('.model').hide();
        $('.hcgl .page-model-add').hide();
        this.addIndex = 0
        this.resetTask()
        this.activeBgCkywIndex = -1
      },
      saveModel:function () {
        var self = this
        if (this.modelData.inspectResult == '2' && this.modelData.inspectState == '') {
          this.isError = true
          return false
        } else {
          this.isError = false
        }
        ajax("POST","/dzba/inspect/finish",this.modelData).done(function(res){
          if(res.code=='0'){
            tools.info('操作成功！')
            self.hideModel();
            self.search(1)
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      initTree:function() {
        var self = this;
        var setting = {
            callback:{
                onClick:function(e,id,node){
                    self.searchData.swjg_dm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                },
                onDblClick:function(e,id,node){
                    self.searchData.swjg_dm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                }
            },
            data:{key:{children:"item",name:"text"}}
        };

        ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
            if(res.code=='0'){
                $.fn.zTree.init($(".hcgl .treeDiv"), setting, res.data);
            }else{
                tools.info(res.msg)
            }
        }).fail(function(err){
            tools.info(err)
        })
      },
      showTree:function(e){
        var self=this;
        $(".treeDiv",$(e.target).parent()).show();
        $('.hcgl').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.hcgl').off('click');
      },
      // 编辑
      hideEdit: function(){
        $('.model').hide()
        $('.hcgl .page-model-edit').hide()
        this.editData = {}
        this.editRangeList = []
      },
      // 编辑
      saveEdit: function(){
        var self = this
        var params = {
          inspectNo: this.editRow.inspectNo,
          range: this.editRangeList.join(','),
          remark: this.editData.remark,
        }
        if(!params.range){
          tools.info('请至少选择一种核查单证类型');
          return
        }
        $('.loading').show()
        ajax("POST","/dzba/inspect/task/save", params).done(function(res){
          $('.loading').hide()
          if(res.code=='0'){
            self.hideEdit()
            tools.info('保存成功！')
            self.search(1)
          }else{
            tools.info(res.msg)
          }
        }).fail(function(err){
          $('.loading').hide()
          tools.info(err)
        })
      },
      // 根据申报年月过滤申报批次
      getSbpcs: function() {
        if (!this.nsrxx.nsrsbh) {
          tools.info('请先输入社会信用码')
          this.searchAddCkywData.sssq = ''
          return false
        }
        var params = {
          nsrsbh: this.searchAddCkywData.nsrsbh,
          sbywzl: this.searchAddCkywData.sbywzl,
          sssq: this.searchAddCkywData.sssq
        }
        var self = this
        ajax("POST","/dzba/inspect/task/available/sbpcs",params).done(function(res){
          if(res.code=='0'){
            self.sbpcList = (res.data&&res.data.sbpcs) || []
            self.searchAddCkywData.sbpc = ''
          }else{
            self.sbpcList= []
            self.searchAddCkywData.sbpc = ''
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      // 获取核查单证类型
      getTypeTreeData: function(params) {
        var self = this
        ajax("POST","/dzba/inspect/tree",params).done(function(res){
          if(res.code=='0'){
            self.typeTreeData = res.data
            self.rangeList = []
            self.defaultRangeList = []
            for (var i=0; i<self.typeTreeData.length; i++) {
              var item = self.typeTreeData[i].item
              for (var j=0; j<item.length; j++) {
                if (item[j].checked) {
                  self.rangeList.push(item[j].value)
                  self.defaultRangeList.push(item[j].value)
                }
              }
            }
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      // 编辑/查看 获取单条数据
      getInfo:function(row) {
        var self = this
        var params = {
          inspectNo: row.inspectNo,
          nsrsbh: row.nsrsbh
        }
        ajax("POST","/dzba/inspect/task/open",params).done(function(res){
          if(res.code=='0'){
            var data = res.data
            var newObj = {}
            self.editData = Object.assign(newObj, data.nsrxx, data.extra, data.business)
            self.editData.remark = self.editData.remark || ''
            self.editRangeList = data.range && data.range.split(',') || []
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      // 调用单证助手-预览文件
      searchDz:function(){
        var self = this
        if (this.editRow.status < 3) {
          return;
        }
        var params={
          inspectNo: this.editRow.inspectNo,
          mode: 'edit'
        }
        ajax("POST","/dzba/inspect/view/second",params).done(function(res){
          if(res.code=='0'){
            var params = res.data
            if (!params) {
              return;
            }
            apiClient.baywManage(params).done(function(res){
              clearTimeout(self.timer)
              self.timer = setTimeout(self.getRemark, 1000);
            })
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      // 从单证助手获取核查意见备注
      getRemark: function(){
        var self = this
        apiClient.getRemark({taskType: '01'}).done(function(res){
          var docInfo = res.docInfo
          if (docInfo.length<=0 && res.inspectInfo.length<=0) {
            clearTimeout(self.timer)
          } else {
            self.timer = setTimeout(self.getRemark, 1000);
          }
          if(docInfo.length > 0) {
            self.resetDocinfo(docInfo);
            ajax("POST","/dzba/file/remark/save",{docInfo: docInfo})
          }
        }).fail(function(err){
          clearTimeout(self.timer)
        })
      },
      // 挂载 changeFlag
      resetDocinfo: function(docInfo){
        for(var i=0; i<docInfo.length; i++){
          docInfo[i].changeFlag = docInfo[i].changeFlag? docInfo[i].changeFlag: 'Y';
        }
      },
      sbpcChange: function() {
        var sbpc = this.searchData.sbpc.replace(/[^0-9]/g,'')
        this.searchData.sbpc = sbpc
      },
      // 格式化申报批次 - '001'
      formatInt: function(number){
        var mask = "";
        var returnVal = "";
        for(var i=0;i<3;i++) mask+="0";
        returnVal = mask + number;
        returnVal = returnVal.substr(returnVal.length-3,3);
        return returnVal;
      },
      sbpcFormat: function(key){
        if (this[key].sbpc != '') {
          this[key].sbpc = this.formatInt(this[key].sbpc)
        }
      },
      // 模糊查询税号，获取税号列表
      inpChangeNsrsbh: function(key){
        if (key == 'searchData') {
          this.searchData.nsrmc = ''
        }
        this[key].nsrsbh = this[key].nsrsbh.trim()
        var nsrsbh = this[key].nsrsbh
        if (nsrsbh.length<4) {
          return;
        }
        var params = {
          qybs: nsrsbh
        }
        var self = this
        ajax("POST","/dzba/inspect/nsrxx/list",params, false, false, true ).done(function(res){
          if(res.code=='0'){
            if (key == 'searchData') {
              self.nsrsbhList = res.data
              self.showNsrsbh()
            } else {
              self.nsrsbhCkywList = res.data
              self.showNsrsbhCkyw()
            }
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
            tools.info(err);
        })
      },
      setNsrsbh: function(item, key){
        this[key].nsrsbh = item.nsrsbh
        this[key].nsrmc = item.nsrmc
        this.showNsrsbhList = false
        if (key == 'nsrxx') {
          this.getNsrxx()
          $('#hcglNrsbhCkywInp').blur()
        } else {
          this.search(1)
        }
      },
      // 显示纳税人识别号弹框
      showNsrsbh: function(){
        var list = this.nsrsbhList
        if (list&&list.length>0) {
          this.showNsrsbhList = true
        }
      },
      // 隐藏纳税人识别号弹框
      hideNsrsbh: function(e){
        if($(e.target).parent().hasClass('nsrsbh-group')) return
        this.showNsrsbhList = false
        this.showNsrsbhCkywList = false
      },
      // 显示纳税人识别号弹框-选择出口业务
      showNsrsbhCkyw: function(){
        var list = this.nsrsbhCkywList
        if (list&&list.length>0) {
          this.showNsrsbhCkywList = true
        }
      },
      keydown: function(e, id){
        if (id == 'hcglNrsbhList') {
          var index = this.activeBgIndex
          var len = this.nsrsbhList.length
        } else {
          var index = this.activeBgCkywIndex
          var len = this.nsrsbhCkywList.length
        }
        //38:上  40:下
        if (e.keyCode == 38) {
          if (index > -1) {
            index --
          } else {
            index = len - 1
          }
          this.stopDefault(e)
        } else if (e.keyCode == 40) {
          if (index < len) {
            index ++
          } else {
            index = 0
          }
          this.stopDefault(e)
        }
        if (id == 'hcglNrsbhList') {
          this.activeBgIndex = index
        } else {
          this.activeBgCkywIndex = index
        }
        var pHeight = $('#'+id+' p:first').height() // p元素高度
        if (index > 2) {
          $("#"+id).scrollTop(pHeight * (index - 3) + 9)
        } else {
          $("#"+id).scrollTop(0)
        }
        if(e.keyCode==13){  // enter
          var item = {}
          var key = ''
          if (id == 'hcglNrsbhList') {
            item = this.nsrsbhList[index],
            key = 'searchData'
          } else {
            item = this.nsrsbhCkywList[index],
            key = 'nsrxx'
          }
          if (item) {
            this[key].nsrsbh = item.nsrsbh
            this[key].nsrmc = item.nsrmc
          }
        }
      },
      //阻止事件执行
      stopDefault:function (event) {
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
      }
    }
});