var bagl=require("./bagl.html");
avalon.component('bagl', {
    template:bagl,
    defaults: {
      params:{},
      act:1,
      tcode:"bagl",
	    swjgmc: "",
        searchData:{
          swjg_dm:"",
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          bazt: "",
          sfyq: "",
          slrqq: "",
          slrqz: "",
          barqq: "",
          barqz: "",
          orderSql:"",
          pageSize:config.pageSize,
        },
        baztOption: [ // 备案状态
          { name: '待备案', value: '1'},
          { name: '备案完成', value: '3'}
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
          var self = this
            try {
              if (self.params.swjgdm) {
                self.searchData.swjg_dm = self.params.swjgdm
                self.searchData.barqq = self.params.startDate
                self.searchData.barqz = self.params.endDate
                self.searchData.bazt = self.params.bazt
                self.searchData.swjg_dm=self.params.swjgdm;
                self.swjgmc=self.params.swjgMc;
              }else{
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
              }
            } catch (e) {

            }
            this.initDate();
			      this.createTable();
            this.initTree()
            this.search(1)
        },
        initDate: function(){
          var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
          $('.bagl .datepicker.date-day').datetimepicker(options);
        },

        // 日期选择框多次点击会隐藏的bug修复
        showDatetimepicker: function(e){
          $(e.target).datetimepicker('show');
        },
        createTable:function(){
            var self=this;
            var columns = [
              { name: "id", label: "id", index: "id", hidden:true,width: 100, align:"left",sortable: true },
              { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 80, align:"left",sortable: true },
              { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 135, align:"left",sortable: true },
              { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 130, align:"left",sortable: true },
              { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"left",sortable: true },
              { name: "sbywzl", label: "退税申报业务种类", index: "sbywzl",width: 120, align:"center",sortable: true },
              { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 80, align:"center",sortable: true },
              { name: "baztName", label: "备案状态", index: "baztName",width: 70, align:"center",sortable: true },
              { name: "sbrq", label: "退税申报日期", index: "sbrq",width: 80, align:"center",sortable: true },
              { name: "slrq", label: "退税受理日期", index: "slrq",width: 80, align:"center",sortable: true },
              { name: "basj", label: "备案时间", index: "basj",width: 80, align:"center",sortable: true },
              { name: "baqx", label: "备案期限", index: "baqx",width: 80, align:"center",sortable: true },
              { name: "ckywbs", label: "出口业务笔数", index: "ckywbs",width: 80, align:"right",sortable: true,
              formatter: function (cellVal, op, row) {
                cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
                return cellVal
              } },
              { name: "dzfs", label: "单证份数", index: "dzfs",width: 80, align:"right",sortable: true,
              formatter: function (cellVal, op, row) {
                cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
                return cellVal
              } },
              { name: "concacts", label: "联系人", index: "concacts",width: 70, align:"left",sortable: true },
              { name: "tel", label: "联系电话", index: "tel",width: 100, align:"left",sortable: true },
            ];
            $("#bagl-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#bagl-tablePager',
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
                    return $(".bagl .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                  return;
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                  var pageNo=tools.getPageNo(pgButton,"bagl-table");
                  self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.bagl')).val();
            // self.search(1)
        },
        search:function(pageNo){
          var self=this;
	        var fields = [
		        {name:"qyhgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"企业名称最大长度为30"},
	        ];
	        var isValid = tools.validate("bagl-form",fields);
          if(self.searchData.slrqq && self.searchData.slrqz && self.searchData.slrqz<self.searchData.slrqq){
            tools.info('退税受理日期截止日期必须大于起始日期');
            return
          }
          if(self.searchData.barqq && self.searchData.barqz && self.searchData.barqz<self.searchData.barqq){
            tools.info('备案日期截止日期必须大于起始日期');
            return
          }
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.bagl')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
            $("#bagl-table").jqGrid('clearGridData')
            console.log(params,'params');
            
		        ajax("POST","/dzba/record/list",params).done(function(res){
			        if(res.code=='0'){
				        $("#bagl-table").resetSelection();
				        $("#bagl-table")[0].addJSONData(res.data);
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
            $('.bagl .select-sub').toggle();
            $('.bagl .select-wrapper .icon').toggleClass("active");
            if ($('.bagl .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.bagl .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.bagl .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
          $('.bagl .select-sub').hide();
          $('.bagl .select-wrapper .icon').removeClass('active');
          $('.bagl .select-wrapper .icon').attr("title","展开查询条件")
        },
      exform:function(){
        var self=this;
        if($('#bagl-table').jqGrid('getRowData').length<=0){
            tools.info("请先查询列表");
            return ;
        }
        var params = tools.clone(self.searchData)
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", "/dzba/export/record");
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
		    // this.searchData = {
        //   swjg_dm:avalonRoot.user.swjgDm,
        //   qyhgdm:"",
        //   nsrsbh:"",
        //   nsrmc:"",
        //   bazt: "",
        //   sfyq: "",
        //   orderSql:"",
        //   pageSize:config.pageSize,
        // };
        this.searchData = {
          swjg_dm:avalonRoot.user.swjgDm,
          qyhgdm:"",
          nsrsbh:"",
          nsrmc:"",
          bazt: "",
          sfyq: "",
          slrqq: "",
          slrqz: "",
          barqq: "",
          barqz: "",
          orderSql:"",
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
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
                $.fn.zTree.init($(".bagl .treeDiv"), setting, res.data);
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
        $('.bagl').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }

        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.bagl').off('click');
      },
    }
});