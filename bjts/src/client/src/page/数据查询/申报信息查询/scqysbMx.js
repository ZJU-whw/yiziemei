var scqysbMx=require("./scqysbMx.html");
avalon.component('scqysbMx', {
    template:scqysbMx,
    defaults: {
        params:{
            lcslid:"",
            shxyno: "",
            sssq: ""
        },
        tcode: 'scqysbxxcxSbsj',
        searchData: {
            shxyno: "",
            sssq: "",
            orderSql:"",
            pageSize:config.pageSize,
        },
        activeIndex: 0,
        form:{
            baseinfo: {
                flglcd:"",
                nsrmc:"",
                qyhgdm:"",
                qylx:"",
                sb_pc:"",
                sb_ym:"",
                shxy_no:"",
                swjgmc:"",
            },
            ywsxqk: {},
            shqk: {},
            hzqk: {},
            ttkqk: {},
            jxkh: {}
        },
        isOpenTable: false,
        tableNum: 0,
        curFormHeight: 500,
        onReady:function(){
            this.tableNum = sessionStorage.getItem('tableNum')
            var form = $(".scqysbMx .form")
            this.curFormHeight = form.eq(form.length-1).height();
            this.init();
            this.searchData.shxyno = this.params.shxyno
            this.searchData.sssq = this.params.sssq
        },
        init:function(){
            var self=this;
            var params={
                lcslid:self.params.lcslid,
            }
            ajax("POST","/cxfw/sbxxcx/second",params).done(function(res){
                if(res.code=='0'){
                    self.form=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        printForm:function(e){
            $('.scqysbMx').print();
        },
        count:function(name){
            var sum=0;
            for(var i=0;i<this.form.rows.length;i++){
                if(!isNaN(this.form.rows[i][name])) {
                    sum += this.form.rows[i][name] - 0;
                }
            }
            return sum;
        },
        createTable:function(cols){
            var self=this;
            $("#scqysbMx-table"+this.tableNum).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cols,
                viewrecords: true,
                rownumbers:true,
                pager: '#scqysbMx-tablePager'+this.tableNum,
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return self.curFormHeight -264;
                })(),
                beforeSelectRow:function(rowid,e){
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    console.log(pgButton)
                    var pageNo=tools.getPageNo2(pgButton,"scqysbMx-tablePager"+self.tableNum);
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scqysbMx')).val();
            this.search(1)
        },
        //copy bg
        getTableRow:function(){
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
                        if(obj.name=='shxyno'){
                            obj.formatter=function(cellvalue, options, rowObject){
                                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                            }
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
                        self.createTable(tableArr)
                    };
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        search:function(pageNo){
            var self = this
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scqysbMx')).val() || 20;
            var params=tools.clone(this.searchData);
            params.pageNo=pageNo;
            $("#scqysbMx-table"+this.tableNum).jqGrid('clearGridData')
            ajax("POST","/cxfw/scqysbxxcx/second/sbsj",params).done(function(res){
                if(res.code=='0'){
                    $("#scqysbMx-table"+self.tableNum).resetSelection();
                    $("#scqysbMx-table"+self.tableNum)[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        changeTab:function(index){
            this.activeIndex = index
            console.log(this.isOpenTable)
            if (index == 1 && !this.isOpenTable) {
                this.isOpenTable = true
                this.getTableRow()
            }
        }
    }
});