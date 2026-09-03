var dxtxlcrwcx=require("./dxtxlcrwcx.html");
avalon.component('dxtxlcrwcx', {
    template:dxtxlcrwcx,
    defaults: {
      params:{},
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        qybs:"",
        biztype:"",
        startTbDate:"",
        endTbDate:"",
        orderSql:"",
        pageSize:config.pageSize,
      },
      bizList:[],
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {
        }
        this.createTable();
        this.initTree();
        $('.dxtxlcrwcx .datepicker.date-day').datepicker({
          dateFormat: 'yy-mm-dd'
        });
        this.searchData.startTbDate = tools.getToday();
        this.searchData.endTbDate = tools.getToday();
        api.getNkglMsgYwlx().done(res=>{
          this.bizList = res.data
        })
      },

      // 初始化params，用于适配外部直接跳转到查询页 - 出口退（免）税综合信息态势感知平台
      initParams: function(ztreeObj){
        if(this.params.swjgDm) {
          this.searchData.swjgDm = this.params.swjgDm;
          var curNode = ztreeObj.getNodeByParam('id', this.params.swjgDm);
          this.swjgmc = curNode && curNode.text || '';
        }
        if(this.params.biztype){
          this.searchData.biztype = this.params.biztype=='tsbl'? '退税办理': (this.params.biztype=='hdfh'? '函调复函': '');
        }
        this.search(1);
      },

      createTable:function(){
        var self=this;
        var columns = [
          { name: "swjgDm", label: "税务机关代码", index: "swjgDm",width: 110, align:"center",sortable: true },
          { name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
          { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 170, align:"left",sortable: true },
          { name: "biztype", label: "业务类型", index: "biztype",width: 80, align:"center",sortable: true },
          // { name: "bizkey", label: "业务关键字", index: "bizkey",width: 240, align:"left",sortable: true },
          { name: "qdsj", label: "启动时间", index: "qdsj",width: 150, align:"center",sortable: true },
          { name: "jzsj", label: "截止时间", index: "jzsj",width: 150, align:"center",sortable: true },
          { name: "ywbz", label: "业务备注", index: "ywbz",width: 240, align:"left",sortable: false },
          // { name: "txcs", label: "提醒次数", index: "txcs",width: 60, align:"right",sortable: true },
          // { name: "txsj", label: "提醒时间", index: "txsj",width: 130, align:"center",sortable: true },
          { name: "sjtbsj", label: "生成日期", index: "sjtbsj",width: 90, align:"center",sortable: true },
        ];
        $("#dxtxlcrwcx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#dxtxlcrwcx-tablePager',
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
                return $(".dxtxlcrwcx .form").height() -90;
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
              var pageNo=tools.getPageNo(pgButton,"dxtxlcrwcx-table");
              self.search(pageNo);
            }

        })
        this.searchData.pageSize = $(".ui-pg-selbox", $('.dxtxlcrwcx')).val();
        // self.search(1)
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.dxtxlcrwcx')).val() || 20;
        var params=tools.clone(self.searchData);
        params.pageNo=pageNo
        $("#dxtxlcrwcx-table").jqGrid('clearGridData')
        ajax("POST","/cxfw/zbrw/pushdata/list",params).done(function(res){
          if(res.code=='0'){
            $("#dxtxlcrwcx-table").resetSelection();
            $("#dxtxlcrwcx-table")[0].addJSONData(res.data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm:avalonRoot.user.swjgDm,
          qybs:"",
          biztype:"",
          startTbDate:"",
          endTbDate:"",
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
                    self.searchData.swjgDm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                },
                onDblClick:function(e,id,node){
                    self.searchData.swjgDm = node.id;
                    self.swjgmc = node.text;
                    self.hideTree();
                    return;
                }
            },
            data:{key:{children:"item",name:"text"}}
        };

        ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
            if(res.code=='0'){
              var ztreeObj = $.fn.zTree.init($(".dxtxlcrwcx .treeDiv"), setting, res.data);
              self.initParams(ztreeObj);
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
        $('.dxtxlcrwcx').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.dxtxlcrwcx').off('click');
      },
    }
});