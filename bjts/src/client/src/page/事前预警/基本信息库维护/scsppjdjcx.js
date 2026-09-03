var scsppjdjcx=require("./scsppjdjcx.html");
avalon.component('scsppjdjcx', {
    template:scsppjdjcx,
    defaults: {
        params:{
            type:""
        },
        type:1,
        act:1,
        tcode:"scsppjdjcx",
        searchData:{
            spdm:"",
            spmc:"",
            djq:"",
            djz:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        swjgDm:"",
        swjgMc:"",
        onReady:function(){

            var self = this;
            this.type=this.params.type;
            this.getTableRow();
            $('.scsppjdjcx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
        },

        changeTab:function(num){
            this.act=num;
        },
        reset: function() {
            var self=this;
            self.searchData={
                spdm:"",
                spmc:"",
                djq:"",
                djz:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "spdm", label: "商品代码", index: "spdm", width: 150, align:"center",sortable: true },
                { name: "spmc", label: "商品名称", index: "spmc", sortable: true,align:"left", width: 200 },
                { name: "qnt", label: "数量", index: "qnt", width: 100, align:"right",sortable: true,formatter:function(cellvalue, options, rowObject){
                        return avalon.filters.number(cellvalue,2);
                    }},
                { name: "amt", label: "出口销售额", index: "amt", sortable: true,align:"right", width: 100,formatter:function(cellvalue, options, rowObject){
                        return avalon.filters.number(cellvalue,2);
                    }},
                { name: "dj", label: "平均单价", index: "dj", sortable: true,align:"right", width: 100,formatter:function(cellvalue, options, rowObject){
                        return avalon.filters.number(cellvalue,2);
                    }},
                { name: "qyhs", label: "企业户数", index: "qyhs", sortable: true,align:"right", width: 100},
                // { name: "", label: "录入人", index: "spmc", sortable: true,align:"left", width: 150 },
                // { name: "", label: "录入日期", index: "spmc", sortable: true,align:"left", width: 150 },
                // { name: "", label: "录入税务机关", index: "spmc", sortable: true,align:"left", width: 150 },
                // { name: "", label:"有效标志", width:60, align:"center", resizable: false, search: false, sortable: true,formatter: function(cellvalue, options, rowObject){
                //         if(rowObject.kpbz==""||!rowObject.kpbz){
                //             return "<div class='btn dzzd' style='float: none;display: inline-block;' title='有效'>有效</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='无效'>无效</div>"
                //         }else{
                //             return "<div class='btn dzzd' style='float: none;display: inline-block;' title='有效'>有效</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='无效'>无效</div>"
                //         }
                //     }}
            ]
            self.createTable(tableArr)

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#scsppjdjcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#scsppjdjcx-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".scsppjdjcx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("scsppjdjcx-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"不予退税明细",component:"scsppjdjcxMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"scsppjdjcx-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scsppjdjcx')).val();
            self.search(1)
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
            ajax("POST","/bjtssw/basis/columprofile/update",params).done(function(res){
                if(res.code!='0'){
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        resetTable:function() {
            $("#scsppjdjcx-table").setGridWidth($('.scsppjdjcx').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scsppjdjcx')).val();
            var params=tools.clone(self.searchData);
            if(!/^[\.0-9]*$/.test(params.djq)||!/^[\.0-9]*$/.test(params.djz)){
                tools.info('平均单价范围必须为数字')
                return ;
            }
            params.pageNo=pageNo
            params.type=self.type;
            $("#scsppjdjcx-table").jqGrid('clearGridData');
            ajax("POST","/bjtssw/yj/cksppjj",params).done(function(res){
                if(res.code=='0'){
                    $("#scsppjdjcx-table").resetSelection();
                    $("#scsppjdjcx-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
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


        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".scsppjdjcx .treeDiv"), setting, res.data);
                    $.fn.zTree.init($(".scsppjdjcx .treeDiv2"), setting2, res.data);
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
            $('.scsppjdjcx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        showSwjg:function(e){
            var self=this;
            $(".treeDiv2",$(e.target)).show();
            $('body').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv2').find($(e.target)).length<=0){
                    self.hideSwjg();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.scsppjdjcx').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        exform:function(){
            if($('#scsppjdjcx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData);
            params.type=self.type;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/cksppjj");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        }
    }
});