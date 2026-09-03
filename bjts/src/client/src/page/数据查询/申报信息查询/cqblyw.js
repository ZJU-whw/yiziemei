var cqblyw=require("./cqblyw.html");
avalon.component('cqblyw', {
    template:cqblyw,
    defaults: {
      params:{},
	    swjgmc: "",
      searchData:{
        swjgdm:"",
        gllb:"",
        qybs:"",
        exceedType:"1",
        exceedDays:"3",
        orderSql:"",
        pageSize:config.pageSize,
      },
      gllbList: [
        { value: 'A', name: 'A' },
        { value: 'B', name: 'B' },
        { value: 'C', name: 'C' },
        { value: 'D', name: 'D' }
      ],
      sumData:{},
      onReady:function(){
        try {
          this.searchData.swjgdm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {
        }
        this.createTable();
        this.initTree();
        this.search(1)
      },
      createTable:function(){
        var self=this;
        var columns = [
          { name: "id", label: "id", index: "id", hidden:true,width: 100, align:"left",sortable: true },
          { name: "swjgdm", label: "税务机关代码", index: "swjgdm",width: 90, align:"center",sortable: true },
          { name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 90, align:"center",sortable: true },
          { name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
          { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 150, align:"center",sortable: true },
          { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
          { name: "sbywb", label: "业务类型", index: "sbywb",width: 140, align:"left",sortable: true },
          { name: "sbnypc", label: "申报年月批次", index: "sbnypc",width: 80, align:"center",sortable: true },
          { name: "zlcTmsAmt", label: "主流程退免税额", index: "zlcTmsAmt",width: 100, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
            return avalon.filters.number(cellvalue,2);
          } },
          { name: "gllb", label: "管理类别", index: "gllb",width: 70, align:"center",sortable: true },
          { name: "slDate", label: "受理日期", index: "slDate",width: 135, align:"center",sortable: true },
          { name: "bljzDate", label: "办理截止日期", index: "bljzDate",width: 135, align:"center",sortable: true },
          { name: "dqgw", label: "当前岗位", index: "dqgw",width: 80, align:"center",sortable: true },
          { name: "rwzt", label: "任务状态", index: "rwzt",width: 80, align:"center",sortable: true },
        ];
        $("#cqblyw-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#cqblyw-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            footerrow:true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: config.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return $(".cqblyw .form").height() -90;
            })(),
            beforeSelectRow:function(rowid,e){
              return;
            },
            gridComplete: function(){
                var sumData=self.sumData;
                sumData['swjgdm']="合计";
                $("#cqblyw-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"cqblyw-table");
              self.search(pageNo);
            }

        })
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cqblyw')).val();
        // self.search(1)
      },
      search:function(pageNo){
        var self=this;
        if (this.searchData.exceedType == '1') {
          if(this.searchData.exceedDays == '') {
            tools.info('即将超期天数不能为空！');
            return;
          } else if (this.searchData.exceedDays<=0 || this.searchData.exceedDays>=5) {
            tools.info('即将超期天数必须大于0且小于5');
            return;
          }
        } else {
          if(this.searchData.exceedDays == '') {
            tools.info('已经超期天数不能为空！');
            return;
          } else if (this.searchData.exceedDays<0) {
            tools.info('即将超期天数必须大于等于0');
            return;
          }
        }
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cqblyw')).val() || 20;
        var params=tools.clone(self.searchData);
        params.pageNo=pageNo
        $("#cqblyw-table").jqGrid('clearGridData')
        ajax("POST","/cxfw/exceed/list",params).done(function(res){
          if(res.code=='0'){
            self.sumData= tools.clone(res.data.sumData);
            $("#cqblyw-table").resetSelection();
            $("#cqblyw-table")[0].addJSONData(res.data);
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      showHyper:function(){
          $('.cqblyw .select-sub').toggle();
          $('.cqblyw .select-wrapper .icon').toggleClass("active");
          if ($('.cqblyw .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
              $('.cqblyw .select-wrapper .icon').attr("title","收起查询条件");
          } else {
              $('.cqblyw .select-wrapper .icon').attr("title","展开查询条件")
          }
      },
      closeHyper:function(){
        $('.cqblyw .select-sub').hide();
        $('.cqblyw .select-wrapper .icon').removeClass('active');
        $('.cqblyw .select-wrapper .icon').attr("title","展开查询条件")
      },
	    reset: function() {
		    this.searchData = {
          swjgdm:avalonRoot.user.swjgDm,
          gllb:"",
          qybs:"",
          exceedType:"1",
          exceedDays:"3",
          orderSql:"",
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
	    },
      exform:function(){
          if($('#cqblyw-table').jqGrid('getRowData').length<=0){
              tools.info("请先查询列表");
              return ;
          }
          var self=this;
          var params = tools.clone(self.searchData)
          var form = $("<form>"); //定义一个form表单
          form.attr("style", "display:none");
          form.attr("method", "post");
          form.attr("action", "/cxfw/export/exceed");
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
                    self.searchData.swjgdm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                },
                onDblClick:function(e,id,node){
                    self.searchData.swjgdm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                }
            },
            data:{key:{children:"item",name:"text"}}
        };

        ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
            if(res.code=='0'){
              $.fn.zTree.init($(".cqblyw .treeDiv"), setting, res.data);
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
        $('.cqblyw').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }

        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.cqblyw').off('click');
      },
      regExceedDays:function(){
        this.searchData.exceedDays = this.searchData.exceedDays.replace(/[^\d]/g,'') 
      }
    }
});