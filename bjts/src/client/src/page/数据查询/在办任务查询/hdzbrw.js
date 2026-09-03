var hdzbrw=require("./hdzbrw.html");
avalon.component('hdzbrw', {
    template:hdzbrw,
    defaults: {
      params:{},
      act:1,
      tcode:"hdzbrwcx",
      swjgmc: "",
      searchData:{
        swjgdm: "",
        fahsjq: "",
        fahsjz: "",
        fuhsjq: "",
        fuhsjz: "",
        fuhStatus: "",
        ghqydesc: "",
        gfqydesc: "",
        hjlx: "",
        wsbh: "",
        orderSql:"",
        pageSize:config.pageSize,
      },
      timer:null,
      tableArr:[],
      tableOption:[],
      tableData:{
        sumData:{}
      },
      setData:{
        zczt:"",
        ktpt:""
      },
      groupList: [],
      fhztList: [
        { value: '1', name: '已复函'},
        { value: '2', name: '尚未复函'},
        { value: '3', name: '即将逾期未复函'},
        { value: '4', name: '已逾期未复函'}
      ],
      onReady:function(){
          var self = this;
          try {
              this.searchData.swjgdm=avalonRoot.user.swjgDm;
              this.swjgmc=avalonRoot.user.swjgMc;
          } catch (e) {

          }
          this.getTableRow();
          self.initTree();
          $('.hdzbrw .datepicker.date-day').datepicker({
              dateFormat: 'yy-mm-dd'
          });
          $('.hdzbrw .datepicker.date-month').datepicker({
              dateFormat: 'yymm'
          });
          this.getGroup()
      },
      changeTab:function(num){
          this.act=num;
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
        $("#hdzbrw-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: cm,
            viewrecords: true,
            rownumbers:true,
            pager: '#hdzbrw-tablePager',
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
                return $(".hdzbrw .form").height() -120;
            })(),
            beforeSelectRow:function(rowid,e){
              return true;
            },
            gridComplete: function(){
              var sumData=self.tableData.sumData;
              sumData[self.tableArr[0].name]="合计";
              $("#hdzbrw-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"hdzbrw-table");
              self.search(pageNo);
            }
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.hdzbrw')).val();
        if (isSearch) {
          this.search(1)
        }
      },
      setTableOption:function(){
          var self=this;
          setTimeout(function(){
              self.resetTable();
          },200);
          if(self.timer==null){
              self.timer=setTimeout(function(){
                  self.updataOption();
                  clearTimeout(self.timer);
                  self.timer=null;
              },2000)
          }else{
              clearTimeout(self.timer);
              self.timer=setTimeout(function(){
                  self.updataOption();
                  clearTimeout(self.timer);
                  self.timer=null;
              },2000)
          }
      },
      updataOption:function(){
          var self=this;
          var cs=[];
          for(var i=0;i<self.tableOption.length;i++){
              if(self.tableOption[i].show==true){
                  cs.push(self.tableOption[i].name)
              }
          }
          var params={
              tcode:this.tcode,
              cs:cs.join(',')
          }
          ajax("POST","/cxfw/basis/columprofile/update",params).done(function(res){
              if(res.code!='0'){
                  tools.info(res.msg)
              }
          }).fail(function(err){
              tools.info(err);
          })
      },
      resetTable:function() {
          var self = this;
          for (var i = 0; i < self.tableOption.length; i++) {
              if (self.tableOption[i].show == true) {
                  $("#hdzbrw-table").showCol(self.tableOption[i].name)
              } else {
                  $("#hdzbrw-table").hideCol(self.tableOption[i].name)
              }
          }
          $("#hdzbrw-table").setGridWidth($('.hdzbrw').width())
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
        var dataValid = [
          { start: 'fahsjq', end: 'fahsjz', msg: '签发日期'},
          { start: 'fuhsjq', end: 'fuhsjz', msg: '复函日期'}
        ]
        for(var i=0; i<dataValid.length; i++) {
          var item = dataValid[i]
          var validItem = tools.checkDate(this.searchData[item.start], this.searchData[item.end])
          if (!validItem) {
            tools.info(item.msg+'截止时间必须大于起始时间')
            return false
          }
        }
        this.searchData.pageSize = $(".ui-pg-selbox", $('.hdzbrw')).val() || 20;
        var params=tools.clone(self.searchData);
        params.pageNo=pageNo;
        $("#hdzbrw-table").jqGrid('clearGridData')
        ajax("POST","/cxfw/hdzbrwcx/first",params).done(function(res){
          if(res.code=='0'){
            self.tableData=res.data;
            $("#hdzbrw-table").resetSelection();
            $("#hdzbrw-table")[0].addJSONData(res.data);
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      showHyper:function(){
          $('.hdzbrw .select-sub').toggle();
          $('.hdzbrw .select-wrapper .icon').toggleClass("active");
          if ($('.hdzbrw .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
              $('.hdzbrw .select-wrapper .icon').attr("title","收起查询条件");
          } else {
              $('.hdzbrw .select-wrapper .icon').attr("title","展开查询条件")
          }
      },
      closeHyper:function(){
          $('.hdzbrw .select-sub').hide();
          $('.hdzbrw .select-wrapper .icon').removeClass('active');
          $('.hdzbrw .select-wrapper .icon').attr("title","展开查询条件")
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
      showMenu:function(e){
          var self=this;
          $(".dropdown-menu",e.target).show();
          $('.hdzbrw').on('click',function(e){
              var e=e||window.event;
              if($('.dropdown-menu').find($(e.target)).length<=0){
                  self.hideMenu();
              }

          })
      },
      hideMenu:function(){
          $(".dropdown-menu").hide();
          $('.hdzbrw').off('click');
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
          $.fn.zTree.init($(".hdzbrw .treeDiv"), setting, data);
        }).fail(function (err) {
          tools.info(err);
        })
      },
      showTree:function(e){
        var self=this;
        $(".treeDiv",$(e.target).parent()).show();
          $(".hdzbrw").on('click',function(e){
              var e=e||window.event;
              if($('.treeDiv').find($(e.target)).length<=0){
                  self.hideTree();
              }
          })
      },
      hideTree:function(){
        $(".treeDiv").hide();
          $('.hdzbrw').off('click');
      },
	    reset: function() {
        this.searchData={
          swjgdm:avalonRoot.user.swjgDm,
          fahsjq: "",
          fahsjz: "",
          fuhsjq: "",
          fuhsjz: "",
          fuhStatus: "",
          ghqydesc: "",
          gfqydesc: "",
          hjlx: "",
          wsbh: "",
          orderSql:"",
          pageSize:config.pageSize,
        };
        this.swjgmc = avalonRoot.user.swjgMc;
	    },
      getGroup: function(){
        var self = this
        ajax("POST","/cxfw/swjgjd/group",{}).done(function(res){
          if(res.code=='0'){
            self.groupList = res.data
          } else {
            tools.info(res.msg)
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      exform:function(pageNo,pid){
        var self=this;
        if($('#hdzbrw-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
        }
        var params = tools.clone(self.searchData);
        tools.exform(params,"/cxfw/export/hdzbrwcx")
      }
    }
});