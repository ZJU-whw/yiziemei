var wmckjyzt=require("./wmckjyzt.html");
avalon.component('wmckjyzt', {
    template:wmckjyzt,
    defaults: {
      params:{},
      act:1,
      tcode:"wmckjyzt",
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
        },
        initDate: function(){
          $('.wmckjyzt .datepicker.date-month').datetimepicker({
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
          $('.wmckjyzt .datepicker.date-day').datepicker({
            dateFormat: 'yy-mm-dd'
          });
        },
        createTable:function(){
            var self=this;
            var columns = [
              { name: "swjgmc", label: "自营出口企业备案户数", index: "swjgmc",width: 140, align:"right",sortable: false },
              { name: "swjgmc", label: "委托出口企业备案户数", index: "swjgmc",width: 140, align:"right",sortable: false },
              { name: "nsrmc", label: "代办退税生产企业户数", index: "nsrmc",width: 140, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return '<span class="toDbts text-blue" style="text-decoration: underline;cursor:pointer;">'+cellvalue+'</span>';
              }},
              { name: "nsrsbh", label: "市场采购贸易市场经营户户数", index: "nsrsbh",width: 160, align:"right",sortable: false },
              { name: "qyhgdm", label: "9610无票免税户数", index: "qyhgdm",width: 130, align:"right",sortable: false },
              { name: "wzhqy", label: "自营出口企业户数", index: "wzhqy",width: 130, align:"right",sortable: false },
              { name: "gllb", label: "委托出口企业户数", index: "gllb",width: 130, align:"right",sortable: false },
              { name: "tsjsfs", label: "代办退税生产企业户数", index: "tsjsfs",width: 140, align:"right",sortable: false },
              { name: "resultName", label: "市场采购贸易市场经营户户数", index: "resultName",width: 160, align:"right",sortable: false },
              { name: "applyTime", label: "9610无票免税户数", index: "applyTime",width: 120, align:"right",sortable: false },
              { name: "applyTime", label: "外贸供货企业户数", index: "applyTime",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return '<span class="toWmgh text-blue" style="text-decoration: underline;cursor:pointer;">'+cellvalue+'</span>';
              }},
              { name: "applyTime", label: "海关出口额", index: "applyTime",width: 80, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }},
              { name: "applyTime", label: "申报出口额", index: "applyTime",width: 80, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }},
              { name: "applyTime", label: "代办退税计税金额", index: "applyTime",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }},
              { name: "applyTime", label: "外贸供货计税金额", index: "applyTime",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }},
              { name: "applyTime", label: "申报应退（免）税额", index: "applyTime",width: 80, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
                return avalon.filters.number(cellvalue,2);
              }}
            ];
            $("#wmckjyzt-table").jqGrid({
              datatype: "local",
              gridview: true,
              colModel: columns,
              viewrecords: true,
              rownumbers:true,
              pager: '#wmckjyzt-tablePager',
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
                  return $(".wmckjyzt .form").height() -60;
              })(),
              beforeSelectRow:function(rowid,e){
                var row = $('#wmckjyzt-table').getRowData(rowid)
                if($(e.target).hasClass('toDbts')){
                  var params = {}
                  avalonRoot.addTab({title:"代办退税生产企业情况统计表",component:"cktsmx",params:params});
                  return true;
                } else if($(e.target).hasClass('toWmgh')){
                  var params = {}
                  avalonRoot.addTab({title:"外贸供货企业情况统计表",component:"cktsmx",params:params});
                  return true;
                }
                return true;
              },
              onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
              },
              onPaging:function(pgButton){
                var pageNo=tools.getPageNo(pgButton,"wmckjyzt-table");
                self.search(pageNo);
              }
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.wmckjyzt')).val();
            self.search(1)
        },
        search:function(pageNo){
          var self=this;
          var dateValid = tools.checkDate(this.searchData.ssnyStart, this.searchData.ssnyEnd)
          if (!dateValid) {
            tools.info('出口日期止必须大于起始时间')
            return false
          }
          this.searchData.pageSize = $(".ui-pg-selbox", $('.wmckjyzt')).val() || 20;
          var params=tools.clone(self.searchData);
          params.pageNo=pageNo
          $("#wmckjyzt-table").jqGrid('clearGridData')
          ajax("POST","/dzba/apply/list",params).done(function(res){
            if(res.code=='0'){
              $("#wmckjyzt-table").resetSelection();
              $("#wmckjyzt-table")[0].addJSONData(res.data);
              self.tableData=res.data;
            }else{
              tools.info(res.msg);
            }
          }).fail(function(err){
            tools.info(err);
          })
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
          if($('#wmckjyzt-table').jqGrid('getRowData').length<=0){
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
              $.fn.zTree.init($(".wmckjyzt .treeDiv"), setting, res.data);
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
        $('.wmckjyzt').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }

        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.wmckjyzt').off('click');
      }
    }
});