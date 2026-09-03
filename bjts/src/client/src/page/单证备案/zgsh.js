var zgsh=require("./zgsh.html");
avalon.component('zgsh', {
    template:zgsh,
    defaults: {
      params:{},
      act:1,
      tcode:"zgsh",
      applyUser: {
        name: '',
        shxyno: '',
        qyhgdm: '',
        gllb: '',
        tsjsfs: '',
        swjgmc: '',
        address: '',
        contacts: '',
        tel: '',
      },
      nowDateZh: '',
	    swjgmc: "",
        searchData:{
          swjg_dm:"",
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          result:"",
          gllb: "",
          tsjsfs: "",
          applyTimeStart: "",
          applyTimeEnd: "",
          orderSql:"",
          pageSize:config.pageSize,
        },
        applyResult: [
          { value: '1', name: '登记中' },
          { value: '2', name: '已登记' },
          { value: '3', name: '未登记' },
        ],
        gllbList: [
          { value: 'A', name: 'A' },
          { value: 'B', name: 'B' },
          { value: 'C', name: 'C' },
          { value: 'D', name: 'D' },
        ],
        tsjsfsList: [
          { value: '1', name: '免抵退' },
          { value: '2', name: '免退税' },
          { value: '3', name: '免税' },
          { value: '9', name: '其他' },
        ],
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        onReady:function(){
          
            try {
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
			      this.createTable();
            this.initTree();
            this.search(1)
            $('.zgsh .datepicker.date-day').datepicker({
              dateFormat: 'yy-mm-dd'
            });
            $('.zgsh .datepicker.date-month').datepicker({
              dateFormat: 'yymm'
            });
        },
        createTable:function(){
            var self=this;
            var columns = [
              { name: "op2", label:"操作", width: 0, frozen: true, align:"center", resizable: false, sortable: false,formatter: function(cellvalue, options, rowObject){
                var h = '<div style="display: flex; justify-content: center;">';
                if(rowObject.result=='2') {
                  h += '<span class="btn apply" title="登记表">登记表</span>';
                } else{
                  h += '<span class="btn pass" title="通过" style="min-width: 36px">通过</span>';
                }
                h += '</div>';
                return h
              }},
              { name: "id", label: "id", index: "id", hidden:true,width: 100, align:"left",sortable: true },
              { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 90, align:"center",sortable: true },
              { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 138, align:"center",sortable: true },
              { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 120, align:"center",sortable: true },
              { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"left",sortable: true },
              { name: "wzhqy", label: "无纸化申报", index: "wzhqy",width: 80, align:"center",sortable: true },
              { name: "gllb", label: "管理类别", index: "gllb",width: 60, align:"center",sortable: true },
              { name: "gllbName", label: "管理类别", index: "gllbName",width: 60,hidden:true, align:"left"},
              { name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: true },
              { name: "result", label: "登记状态", index: "result", hidden: true },
              { name: "resultName", label: "登记状态", index: "resultName",width: 70, align:"center",sortable: true },
              { name: "applyTime", label: "登记时间", index: "applyTime",width: 80, align:"center",sortable: true },
              { name: "concacts", label: "联系人", index: "concacts",width: 70, align:"left",sortable: true },
              { name: "tel", label: "联系电话", index: "tel",width: 100, align:"left",sortable: true },
              { name: "remark", label: "备注", index: "remark",width: 100, align:"left",sortable: true },
              { name: "address", label: "联系地址", index: "address",width: 0, align:"left",hidden:true },
              { name: "op", label: "操作", width: 110, align: "center", resizable: false, search: false, sortable: false }
              
            ];
            $("#zgsh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#zgsh-tablePager',
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rownumWidth: 40,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".zgsh .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                  var id = getCellData("zgsh-table", rowid, 'id')
                  var row= $("#zgsh-table").jqGrid("getRowData",rowid);
                  if($(e.target).hasClass('pass')){
                    tools.confirm("确定通过？",'确定',function(){
                      ajax("POST","/dzba/apply/verity",{id}).done(function(res){
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
                  } else if($(e.target).hasClass('apply')){
                    // self.showModelPdf(id)
                    self.showDjb(row)
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
                  var pageNo=tools.getPageNo(pgButton,"zgsh-table");
                  self.search(pageNo);
                }

            })
            $("#zgsh-table").jqGrid('setFrozenColumns');
            this.searchData.pageSize = $(".ui-pg-selbox", $('.zgsh')).val();
            // self.search(1)
        },
        search:function(pageNo){
          var self=this;
          
          var dateValid = tools.checkDate(this.searchData.applyTimeStart, this.searchData.applyTimeEnd)
          if (!dateValid) {
            tools.info('登记时间止必须大于起始时间')
            return false
          }
	        var fields = [
		        {name:"qyhgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"纳税人名称最大长度为30"},
	        ];
	        var isValid = tools.validate("zgsh-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.zgsh')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
            $("#zgsh-table").jqGrid('clearGridData')
		        ajax("POST","/dzba/apply/list",params).done(function(res){
			        if(res.code=='0'){
				        $("#zgsh-table").resetSelection();
				        $("#zgsh-table")[0].addJSONData(res.data);
				        self.tableData=res.data;
                tools.HeiKjNoSel('zgsh', 'zgsh-table')
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
            $('.zgsh .select-sub').toggle();
            $('.zgsh .select-wrapper .icon').toggleClass("active");
            if ($('.zgsh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.zgsh .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.zgsh .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
          $('.zgsh .select-sub').hide();
          $('.zgsh .select-wrapper .icon').removeClass('active');
          $('.zgsh .select-wrapper .icon').attr("title","展开查询条件")
        },
	    reset: function() {
		    this.searchData = {
          swjg_dm:avalonRoot.user.swjgDm,
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          result:"",
          gllb: "",
          tsjsfs: "",
          applyTimeStart: "",
          applyTimeEnd: "",
          orderSql:"",
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
	    },
      showDjb(e){
        console.log(e)
        this.applyUser ={
            name: e.nsrmc,
            shxyno: e.nsrsbh,
            qyhgdm: e.qyhgdm,
            gllb:e.gllb,
            gllbName:e.gllbName,
            tsjsfs: e.resultName,
            swjgmc: e.swjgmc,
            address: e.address,
            applyTime: e.applyTime,
            contacts: e.concacts,
            tel: e.tel,
        }
        $('#dzdjb').modal('show');
      },
      showModelPdf (id){
        var params = {
          bizType: 'apply',
          bizKey: id
        }
        var self = this
        $('.loading').show();
        ajax("POST","/dzba/file/viewPdf",params).done(function(res){
          if(res.code=='0'){
            let param = {
              fileName: '',
              fileUrl: res.data.fileUrl,
              title: '数字化单证备案登记表'
            }
            apiClient.checkDzj(param)
          }else{
            tools.info(res.msg);
          }
          $('.loading').hide();
        }).fail(function(err){
          tools.info(err);
          $('.loading').hide();
        })
      },
      hideModelPdf:function(){
        $('.model').hide();
        $('.zgsh .page-model-pdf').hide();
      },
      exform:function(){
        tools.exform(this.searchData, '/dzba/export/apply');
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
              $.fn.zTree.init($(".zgsh .treeDiv"), setting, res.data);
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
        $('.zgsh').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }

        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.zgsh').off('click');
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
    }
});