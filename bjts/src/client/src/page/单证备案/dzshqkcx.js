var dzshqkcx=require("./dzshqkcx.html");
avalon.component('dzshqkcx', {
    template:dzshqkcx,
    defaults: {
      params:{},
      act:1,
      tcode:"dzshqkcx",
	    swjgmc: "",
        searchData:{
          swjg_dm:"",
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          examineTimeStart: "",
          examineTimeEnd: "",
          inspector: "",
          inspectResult: "",
          processType: "",
          bgdh: "",
          tmseStart: "",
          tmseEnd: "",
          orderSql:"",
          pageSize:config.pageSize,
        },
        searchDataDz: {
          orderSql: "",
          pageSize: config.pageSize
        },
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
            this.initTree()
            this.search(1)
            $('.dzshqkcx .datepicker').datepicker({
              dateFormat: 'yy-mm-dd'
            });
        },
        createTable:function(){
            var self=this;
            var columns = [
              { name: "inspectNo", label: "inspectNo", index: "inspectNo", hidden:true,width: 100, align:"left",sortable: true },
              { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 120, align:"center",sortable: true },
              { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
              { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"center",sortable: true },
              { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
              { name: "sbywzl", label: "退税申报业务种类", index: "sbywzl",width: 120, align:"center",sortable: true },
              { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 90, align:"center",sortable: true },
              { name: "bgdh", label: "报关单号", index: "bgdh",width: 130, align:"center",sortable: true },
              { name: "tmse", label: "退免税额", index: "tmse",width: 100, align:"right",sortable: true,formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }},
              { name: "inspectResult", label: "审核状态", index: "inspectResult",width: 60, align:"center",sortable: true },
              { name: "processType", label: "处理类型", index: "processType",width: 80, align:"center",sortable: true },
              { name: "inspector", label: "审核人", index: "inspector",width: 80, align:"center",sortable: true },
              { name: "examineTime", label: "审核时间", index: "examineTime",width: 120, align:"center",sortable: true },
              { name: "op", label:"操作", width:60, align:"center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
                return "<div class='btn check' style='float: none;display: inline-block;' title='查看'>查看</div>";
              }}
            ];
            $("#dzshqkcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#dzshqkcx-tablePager',
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
                    return $(".dzshqkcx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                  if($(e.target).hasClass('check')){ // 查看
                    var inspectNo = getCellData("dzshqkcx-table", rowid, 'inspectNo')
                    self.searchDz(inspectNo)
                  } 
                  return true;
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                  var pageNo=tools.getPageNo(pgButton,"dzshqkcx-table");
                  self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.dzshqkcx')).val();
            // self.search(1)
        },
        search:function(pageNo){
          var self=this;
	        var fields = [
		        {name:"qyhgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"企业名称最大长度为30"},
	        ];
          if (this.searchData.tmseStart!='' && this.searchData.tmseEnd!=''&& this.searchData.tmseStart > this.searchData.tmseEnd) {
            tools.info('退免税额止必须大于起始退免税额')
            return false
          }
          var dateValid = tools.checkDate(this.searchData.examineTimeStart, this.searchData.examineTimeEnd)
          if (!dateValid) {
            tools.info('审核时间截止时间必须大于起始时间')
            return false
          }
	        var isValid = tools.validate("dzshqkcx-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.dzshqkcx')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
            $("#dzshqkcx-table").jqGrid('clearGridData')
		        ajax("POST","/dzba/inspect/review/list",params).done(function(res){
			        if(res.code=='0'){
				        $("#dzshqkcx-table").resetSelection();
				        $("#dzshqkcx-table")[0].addJSONData(res.data);
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
            $('.dzshqkcx .select-sub').toggle();
            $('.dzshqkcx .select-wrapper .icon').toggleClass("active");
            if ($('.dzshqkcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.dzshqkcx .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.dzshqkcx .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
      closeHyper:function(){
        $('.dzshqkcx .select-sub').hide();
        $('.dzshqkcx .select-wrapper .icon').removeClass('active');
        $('.dzshqkcx .select-wrapper .icon').attr("title","展开查询条件")
      },
      exform:function(){
        var self=this;
        if($('#dzshqkcx-table').jqGrid('getRowData').length<=0){
            tools.info("请先查询列表");
            return ;
        }
        var params = tools.clone(self.searchData)
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", "/dzba/export/inspect/review");
        var input1 = $("<input>");
        input1.attr("type", "hidden");
        input1.attr("name", "data");
        input1.attr("value", JSON.stringify(params));
        $("body").append(form); //将表单放置在web中
        form.append(input1);
        form.submit();
        form.remove();
      },
	    reset: function() {
		    this.searchData = {
          swjg_dm:avalonRoot.user.swjgDm,
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          examineTimeStart: "",
          examineTimeEnd: "",
          inspector: "",
          inspectResult: "",
          processType: "",
          bgdh: "",
          tmseStart: "",
          tmseEnd: "",
          orderSql:"",
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
	    },
      filDate:function(e){
        var date=e.target.value;
        var res=tools.DateCheup(date);
        if(res===false){
          tools.info("日期输入错误");
          res=""
        }
        e.target.value=res;
        return ;
      },
      // 调用单证助手-预览文件
      searchDz:function(inspectNo){
        var params={
          inspectNo: inspectNo,
          mode: 'view'
        }
        ajax("POST","/dzba/inspect/view/second",params).done(function(res){
          if(res.code=='0'){
            var params = res.data
            apiClient.baywManage(params)
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
            $.fn.zTree.init($(".dzshqkcx .treeDiv"), setting, res.data);
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
        $('.dzshqkcx').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.dzshqkcx').off('click');
      },
    }
});