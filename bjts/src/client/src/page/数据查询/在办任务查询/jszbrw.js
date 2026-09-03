var jszbrw=require("./jszbrw.html");
avalon.component('jszbrw', {
    template:jszbrw,
    defaults: {
      params:{},
      act:1,
      tcode:"jszbrwcx",
      swjgmc: "",
      searchData:{
        swjgdm: "",
        slrqQ: "",
        slrqZ: "",
        gllbs: ['A','B'],
        qybs: "",
        blqx: "1",
        orderSql:"",
        pageSize:config.pageSize,
      },
      tableArr:[],
      tableOption:[],
      tableData:{},
      gllbList: [
        { value: 'A', name: '一类'},
        { value: 'B', name: '二类'},
        { value: 'C', name: '三类'},
        { value: 'D', name: '四类'}
      ],
      onReady:function(){
        try {
          this.searchData.swjgdm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {

        }
        this.getTableRow();
        this.initTree();
        $('.jszbrw .datepicker.date-day').datepicker({
          dateFormat: 'yy-mm-dd'
        });
        $('.jszbrw .datepicker.date-month').datepicker({
          dateFormat: 'yymm'
        });
        this.initMultiselect()
      },
      initMultiselect: function(){
        var self = this
        let options = []
        for(var i=0;i<this.gllbList.length;i++) {
          let tmp = this.gllbList[i]
          var selected = ['A','B'].indexOf(tmp.value) > -1
          options.push({label: tmp.name, title: tmp.name, value: tmp.value, selected: selected})
        }
        $('#jszbrw-gllb-select').multiselect({
          nonSelectedText: '',
          nSelectedText: '项已选择',
          allSelectedText: '全部选中',
          onChange: function(option, checked, select) {
            let val = $(option).val()
            let gllbs = self.searchData.gllbs;
            if (checked) {
              gllbs.push(val)
            } else {
              let i = gllbs.indexOf(val)
              gllbs.splice(i,1)
            }
            self.searchData.gllbs = gllbs
          }
        });
        $('#jszbrw-gllb-select').multiselect('dataprovider', options);
      },
      //copy bg
      getTableRow:function(isSearch){
        var self=this;
        ajax("POST","/cxfw/basis/columprofile",{tcode:self.tcode}).done(function(res){
          if(res.code=="0"){
            var arr=res.data.profiles;
            var tableArr=[];
            var tableOption=[];
            for(var i=0;i<arr.length;i++){
              var obj={
                name: arr[i].t_c_code,
                label: arr[i].t_c_name,
                index: arr[i].t_c_code,
                sortable: arr[i].is_order==0?false:true,
                hidden:false,
                width: arr[i].c_std_size ,
                align:arr[i].align==0?"left":arr[i].align==1?"center":"right",
              }
              if(arr[i].degree){
                var degree=arr[i].degree
                obj.formatter=function(cellvalue, options, rowObject){
                  return avalon.filters.number(cellvalue,degree);
                }
              }
              tableArr.push(obj)
              if(arr[i].is_fixed=='0'){
                tableOption.push({
                  name: arr[i].t_c_code,
                  label: arr[i].t_c_name,
                  show:false
                })
            }
            }
            self.tableArr=tableArr;
            self.tableOption=tableOption;
            if(tableArr.length>0){
              self.createTable(tableArr, isSearch)
            };
            var selected=res.data.select.split(",")
            for(var j=0;j<selected.length;j++){
              var name=selected[j]
              for(var k=0;k<self.tableOption.length;k++){
                if(name==self.tableOption[k].name){
                  self.tableOption[k].show=true;
                }
              }
            }
            self.resetTable();
          }else{
            tools.info(res.msg)
          }
        }).fail(function(err){
            tools.info(err);
        })
      },
      createTable:function(arr,isSearch){
        var self=this;
        var cm = [];
        for(var i=0;i<arr.length;i++) {
          cm[i] = tools.clone(arr[i]);
        }
        $("#jszbrw-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: cm,
            viewrecords: true,
            rownumbers:true,
            pager: '#jszbrw-tablePager',
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
                return $(".jszbrw .form").height() -120;
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
              var pageNo=tools.getPageNo(pgButton,"jszbrw-table");
              // self.search(pageNo);
              self.dealData(pageNo);
            }
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.jszbrw')).val();
        if (isSearch) {
          this.search(1)
        }
      },
      resetTable:function() {
          var self = this;
          for (var i = 0; i < self.tableOption.length; i++) {
              if (self.tableOption[i].show == true) {
                  $("#jszbrw-table").showCol(self.tableOption[i].name)
              } else {
                  $("#jszbrw-table").hideCol(self.tableOption[i].name)
              }
          }
          $("#jszbrw-table").setGridWidth($('.jszbrw').width())
      },
      normalSearch(){
          this.searchData.orderSql="";
          $('.s-ico').hide();
          this.search(1)
      },
      searchInit: function(){
        if (this.tableArr.length <= 0) {
          this.getTableRow(true)
        } else {
          this.search(1)
        }
      },
      search:function(pageNo){
        var self=this;
        if(this.searchData.swjgdm == '') {
          tools.info('请选择【税务机关】！');
          return false;
        }
        var dataValid = [
          { start: 'slrqQ', end: 'slrqZ', msg: '受理日期'}
        ]
        for(var i=0; i<dataValid.length; i++) {
          var item = dataValid[i]
          var validItem = tools.checkDate(this.searchData[item.start], this.searchData[item.end])
          if (!validItem) {
            tools.info(item.msg+'截止时间必须大于起始时间')
            return false
          }
        }
        this.searchData.pageSize = $(".ui-pg-selbox", $('.jszbrw')).val() || 20;
        var params=tools.clone(self.searchData);
        params.pageNo=pageNo;
        $("#jszbrw-table").jqGrid('clearGridData')
        ajax("POST","/cxfw/zbrw/list",params).done(function(res){
          if(res.code=='0'){
            var data = res.data
            self.tableData = {
              count: data.length,
              page: 1,
              records: data.length,
              rows: data,
              total: Math.ceil(data.length / self.searchData.pageSize)
            }
            self.dealData(pageNo)
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      dealData: function(pageNo){
        var pageSize = $(".ui-pg-selbox", $('.jszbrw')).val() || 20;
        var data = tools.clone(this.tableData)
        data.page = pageNo
        data.rows = this.tableData.rows.slice((pageNo-1)*pageSize, pageNo*pageSize);
        data.total = Math.ceil(this.tableData.rows.length / pageSize);
        setTimeout(function(){
          $("#jszbrw-table").jqGrid('clearGridData')
          $("#jszbrw-table").resetSelection();
          $("#jszbrw-table")[0].addJSONData(data);
        },0)
      },
      showHyper:function(){
          $('.jszbrw .select-sub').toggle();
          $('.jszbrw .select-wrapper .icon').toggleClass("active");
          if ($('.jszbrw .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
              $('.jszbrw .select-wrapper .icon').attr("title","收起查询条件");
          } else {
              $('.jszbrw .select-wrapper .icon').attr("title","展开查询条件")
          }
      },
      closeHyper:function(){
          $('.jszbrw .select-sub').hide();
          $('.jszbrw .select-wrapper .icon').removeClass('active');
          $('.jszbrw .select-wrapper .icon').attr("title","展开查询条件")
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
      filMonth:function(e){
          var date=e.target.value;
          var res=tools.MonCheup(date);
          if(res===false){
              tools.info("所属期输入错误");
              res=""
          }
          e.target.value=res;
          return ;
      },
      //copy
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
        tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
          $.fn.zTree.init($(".jszbrw .treeDiv"), setting, data);
        }).fail(function (err) {
          tools.info(err);
        })
      },
      showTree:function(e){
        var self=this;
        $(".treeDiv",$(e.target).parent()).show();
          $(".jszbrw").on('click',function(e){
              var e=e||window.event;
              if($('.treeDiv').find($(e.target)).length<=0){
                  self.hideTree();
              }
          })
      },
      hideTree:function(){
        $(".treeDiv").hide();
          $('.jszbrw').off('click');
      },
	    reset: function() {
        this.searchData={
          swjgdm:avalonRoot.user.swjgDm,
          slrqQ: "",
          slrqZ: "",
          gllbs: ['A','B'],
          qybs: "",
          blqx: "1",
          orderSql:"",
          pageSize:config.pageSize,
        };
        this.initMultiselect();
        this.swjgmc=avalonRoot.user.swjgMc;
	    },
      exform:function(pageNo,pid){
        var self=this;
        if($('#jszbrw-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
        }
        var params = tools.clone(self.searchData);
        tools.exform(params,"/cxfw/export/jszbrw")
      }
    }
});