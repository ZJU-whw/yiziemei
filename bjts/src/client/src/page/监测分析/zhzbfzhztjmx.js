
var zhzbfzhztjmx=require("./zhzbfzhztjmx.html");
avalon.component('zhzbfzhztjmx', {
    template:zhzbfzhztjmx,
    defaults: {
      params:{},
      act:1,
      tcode:"zhzbfzhztjmx",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        orderSql:"",
        pageSize:config.pageSize,
      },
      tableData:{},
      total: 0,
      defaultItems: [
        {zbxmbm: 'dj.nsrmc', values: []},
        {zbxmbm: 'dj.shxydm', values: []},
        {zbxmbm: 'dj.swjgdm', values: []},
      ],
      dataList: [],
      tableHeight: '',
      timer: null,
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".zhzbfzhztjmx .form").height() - 90
        this.searchData = tools.clone(this.params)
        this.searchData.fzItems = this.searchData.fzItems.concat(this.defaultItems)
        this.searchData.tjbbType = 'x01'
        this.search(1)
      },
      resetTableCol: function(){
        var columns = []
        var keys = this.title
        for (var i=0;i<this.dataList.rows.length;i++) {
          for(var j=0;j<keys.length;j++) {
            let item = keys[j]
            let isNumArr = item.split('#')
            let isNum = isNumArr[1] == '千'
            let alignArr = isNumArr[0].split('_')
            let align = alignArr[1] == '左' ? 'left' : (alignArr[1] == '右' ? 'right' : 'center')
            let name = alignArr[0]
            var contentWidth = tools.textSize(this.dataList.rows[i][item]).width + 20
            var keyWidth = tools.textSize(name).width + 20
            contentWidth = contentWidth < 100 ? 100 : contentWidth
            keyWidth = keyWidth < 100 ? 100 : keyWidth
            var width = contentWidth < keyWidth ? keyWidth : contentWidth
            if (columns.length < keys.length) {
              let obj = {}
              if (name.indexOf('同比-') > -1) {
                obj = {name: item, label: '同比(%)', index: item, width: width, align: 'right', sortable: false, formatter: function(cellvalue, options, rowObject){
                  return cellvalue? Math.round(cellvalue*100)/100 : '-'
                }}
              } else {
                obj = {name: item, label: name, index: item, width: width, align: align, sortable: false}
                if (isNum){
                  obj.formatter = function(cellvalue, options, rowObject){
                    let val = avalon.filters.number(cellvalue,2)
                    return val
                  }
                }
              }
              columns.push(obj)
            } else {
              if (columns[j].width < width) {
                columns[j].width = width
              }
            }
          }
        }
        return columns
      },
      createTable:function(){
        var self=this;
        var columns = this.resetTableCol()
        $("#zhzbfzhztjmx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers: true,
            rownumWidth: 50,
            pager: '#zhzbfzhztjmx-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            footerrow:true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: this.searchData.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return self.tableHeight;
            })(),
            beforeSelectRow:function(rowid,e){
              return true;
            },
            gridComplete: function(){
              var sumData = {}
              for (var key in self.tableData.hj) {
                sumData[key] = self.tableData.hj[key] == undefined ? '' : self.tableData.hj[key]
              }
              sumData['rn']="合计";
              $("#zhzbfzhztjmx-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"zhzbfzhztjmx-table");
              self.search(pageNo);
            }

        })
        $("#zhzbfzhztjmx-table").jqGrid('setLabel','rn', '序号', {'text-align':'center'},'')
        this.searchData.pageSize = $(".ui-pg-selbox", $('.zhzbfzhztjmx')).val();
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.zhzbfzhztjmx')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        this.tableHeight = $(".zhzbfzhztjmx .form").height() - 90
        $('.zhzbfzhztjmx .mask').show()
        $("#zhzbfzhztjmx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params,true, false, true).done(function(res){
          $('.zhzbfzhztjmx .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            self.dataList = res.data.list
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=res.data;
            $("#zhzbfzhztjmx-table").jqGrid('GridUnload')
            self.createTable()
            $("#zhzbfzhztjmx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.zhzbfzhztjmx .mask').hide()
          tools.info(err);
        })
      },
      showDropdown: function (e) {
        var self = this;
        $(".dropdown-menu", e.target).show();
        $('.zhzbfzhztjmx').on('click', function (e) {
          var e = e || window.event;
          if ($('.dropdown-menu').find($(e.target)).length <= 0) {
            self.hideDropdown();
          }
        })
      },
      hideDropdown: function () {
        $(".dropdown-menu").hide();
        $('.zhzbfzhztjmx').off('click');
      },
      exformAll: function(){
        if($('#zhzbfzhztjmx-table').jqGrid('getRowData').length<=0){
          tools.info("无导出数据！");
          return ;
        }
        this.hideDropdown();
        var self=this;
        var params = tools.clone(self.searchData);
        params.tjbbType='XLS01';
        this.exformTimer(params,true)
      },
      exformTimer: function(params,isFirst){
        var self = this
        ajax("POST","/bjtssw/sjjc/export/dynamic/init",params).done(function(res){
          if(res.code=='0'){
            var pages = res.data.pages
            if (pages == 0) {
              if (isFirst) {
                var d = $.dialog({
                  title: '提示',
                  content: '正在生成导出文件，请耐心等候...',
                  lock:true,
                  cancel: false,
                  button: [
                    {
                      value: '取消',
                      callback: function () {
                        clearTimeout(self.timer)
                      }
                    }
                  ]
                })
              }
              self.timer = setTimeout(function(){
                self.exformTimer(params)
              },2000)
            } else if (pages != 0) {
              d&&d.close().remove();
              var d2 = $.dialog({
                title: "提示",
                content: '导出文件生成完毕，正在下载',
                okValue: "确定",
                lock:true,
                ok: function () {}
              })
              for (var i=0;i<pages;i++) {
                (function(j) {
                  setTimeout(function(){
                    self.exform(j+1,res.data.pid)
                    if (j==pages-1){
                      setTimeout(function(){
                        d2&&d2.close();
                      },1000);
                    }
                  },1000*i);
                })(i)
              }
            }
          } else {
            tools.info(res.msg);
          }
        }).fail(function(){
          tools.info(err);
        })
      },
      exformCurrentPage: function(){
        if($('#zhzbfzhztjmx-table').jqGrid('getRowData').length<=0){
          tools.info("无导出数据！");
          return;
        }
        this.hideDropdown();
        this.exform();
      },
      exform:function(pageNo,pid){
        var self=this;
        var params = tools.clone(self.searchData);
        if (pageNo) {
          params.pageNo = pageNo;
          params.pid = pid;
          params.tjbbType = 'XLS01';
          delete params.pageSize;
        }
        tools.exform(params,"/bjtssw/sjjc/saveDynamicExcel")
      }
    }
});