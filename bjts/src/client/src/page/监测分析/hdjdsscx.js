var hdjdsscx=require("./hdjdsscx.html");
avalon.component('hdjdsscx', {
    template:hdjdsscx,
    defaults: {
      params:{},
      act:1,
      tcode:"hdjdsscx",
	    swjgmc: "",
        searchData:{
          ssnyStart: "",
          ssnyEnd: "",
          orderSql:"",
          pageSize:config.pageSize,
        },
        fhStatusOptions: [
          { value: '1', name: '逾期未复函' },
          { value: '2', name: '逾期已复函' },
          { value: '3', name: '未复函' }
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
            this.initDate()
			      this.createTable();
            this.initTree();
            this.search(1)
        },
        initDate: function(){
          $('.hdjdsscx .datepicker.date-month').datetimepicker({
            language:'zh-CN',
            format: 'yyyymm',
            weekStart: 1,
            // todayBtn: true,
            // clearBtn: true,
            autoclose: 1,
            todayHighlight: 1,
            startView: 3, // 这里就设置了默认视图为年视图
            minView: 3, // 设置最小视图为年视图
            forceParse: 0,
          })
          this.searchData.ssnyStart = new Date().getFullYear() + '01'
          this.searchData.ssnyEnd = tools.getMonth()
          $('.hdjdsscx .datepicker.date-day').datepicker({
            dateFormat: 'yy-mm-dd'
          });
        },
        createTable:function(){
            var self=this;
            var columns = [
              { name: "swjgmc", label: "核实函编号", index: "swjgmc",width: 90, align:"center",sortable: false },
              { name: "swjgmc", label: "发起方税务机关", index: "swjgmc",width: 90, align:"center",sortable: false },
              { name: "nsrmc", label: "购货企业名称", index: "nsrmc",width: 200, align:"center",sortable: false },
              { name: "nsrsbh", label: "企业统一社会信用代码", index: "nsrsbh",width: 138, align:"center",sortable: false },
              { name: "qyhgdm", label: "接收方主管税务科（所、分局）", index: "qyhgdm",width: 170, align:"center",sortable: false },
              { name: "wzhqy", label: "供货企业名称", index: "wzhqy",width: 80, align:"center",sortable: false },
              { name: "gllb", label: "供货企业统一社会信用代码", index: "gllb",width: 150, align:"center",sortable: false },
              { name: "tsjsfs", label: "起草人姓名", index: "tsjsfs",width: 80, align:"center",sortable: false },
              { name: "resultName", label: "在办环节", index: "resultName",width: 70, align:"center",sortable: false },
              { name: "applyTime", label: "接收日期", index: "applyTime",width: 80, align:"center",sortable: false },
              { name: "applyTime", label: "函截至日期", index: "applyTime",width: 80, align:"center",sortable: false },
              { name: "applyTime", label: "复函状态", index: "applyTime",width: 80, align:"center",sortable: false },
            ];
            $("#hdjdsscx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#hdjdsscx-tablePager',
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".hdjdsscx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                  return true;
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                  var pageNo=tools.getPageNo(pgButton,"hdjdsscx-table");
                  self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.hdjdsscx')).val();
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
	        var isValid = tools.validate("hdjdsscx-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.hdjdsscx')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
            $("#hdjdsscx-table").jqGrid('clearGridData')
		        ajax("POST","/dzba/apply/list",params).done(function(res){
			        if(res.code=='0'){
				        $("#hdjdsscx-table").resetSelection();
				        $("#hdjdsscx-table")[0].addJSONData(res.data);
				        self.tableData=res.data;
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
            $('.hdjdsscx .select-sub').toggle();
            $('.hdjdsscx .select-wrapper .icon').toggleClass("active");
            if ($('.hdjdsscx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.hdjdsscx .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.hdjdsscx .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
          $('.hdjdsscx .select-sub').hide();
          $('.hdjdsscx .select-wrapper .icon').removeClass('active');
          $('.hdjdsscx .select-wrapper .icon').attr("title","展开查询条件")
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
      exform:function(){
          if($('#hdjdsscx-table').jqGrid('getRowData').length<=0){
              tools.info("请先查询列表");
              return ;
          }
          var self=this;
          var params = tools.clone(self.searchData)
          var form = $("<form>"); //定义一个form表单
          form.attr("style", "display:none");
          form.attr("method", "post");
          form.attr("action", "/dzba/export/apply");
          var input1 = $("<input>");
          input1.attr("type", "hidden");
          input1.attr("name", "data");
          input1.attr("value", JSON.stringify(params));
          $("body").append(form); //将表单放置在web中
          form.append(input1);
          form.submit();
          form.remove();
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
              $.fn.zTree.init($(".hdjdsscx .treeDiv"), setting, res.data);
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
        $('.hdjdsscx').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }

        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.hdjdsscx').off('click');
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