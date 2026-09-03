var gjzyhwsbMx=require("./gjzyhwsbMx.html");
avalon.component('gjzyhwsbMx', {
    template:gjzyhwsbMx,
    defaults: {
        params:{},
        tcode: 'gjzyhwcxSbsj',
        searchData: {
            shxyno: "",
            sssq: "",
            orderSql:"",
            pageSize:config.pageSize,
        },
        form:{},
        activeIndex: 0,
        countData:{
            qnt:0,
            amt:0,
            se:0,
            ts_amt:0
        },
        isOpenTable: false,
        tableNum: 0,
        curFormHeight: 500,
        onReady:function(){
            this.tableNum = sessionStorage.getItem('tableNum')
            var form = $(".gjzyhwsbMx .form")
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
        elecSum:function(){
            this.countData={
                qnt:this.count('qnt'),
                amt:this.count('amt'),
                se:this.count('se'),
                ts_amt:this.count('ts_amt'),
            }
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
        printForm:function(e){
            $('.gjzyhwsbMx').print();
        },
        createTable:function(cols){
            var self=this;
            $("#gjzyhwsbMx-table"+this.tableNum).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cols,
                viewrecords: true,
                rownumbers:true,
                pager: '#gjzyhwsbMx-tablePager'+this.tableNum,
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
                    var pageNo=tools.getPageNo2(pgButton,"gjzyhwsbMx-tablePager"+self.tableNum);
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.gjzyhwsbMx')).val();
            this.search(1)
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var sbywbDm = this.form.baseinfo.sbywbDm
            if (sbywbDm == 'A0302001') {
                this.tcode = 'fzchwxfscxSbsj'
            } else if (sbywbDm == 'A0303001') {
                this.tcode = 'ysyjsbcxSbsj'
            } else if (sbywbDm == 'A0304001') {
                this.tcode = 'gjzyhwcxSbsj'
            }
            ajax("POST","/cxfw/basis/columprofile",{tcode: this.tcode}).done(function(res){
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
            this.searchData.pageSize = $(".ui-pg-selbox", $('.gjzyhwsbMx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            params.sbpc = this.form.baseinfo.sb_pc
            params.sbywbDm = this.form.baseinfo.sbywbDm
            $("#gjzyhwsbMx-table"+this.tableNum).jqGrid('clearGridData')
            ajax("POST","/cxfw/qtywsbcx/second/sbsj",params).done(function(res){
                if(res.code=='0'){
                    $("#gjzyhwsbMx-table"+self.tableNum).resetSelection();
                    $("#gjzyhwsbMx-table"+self.tableNum)[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        changeTab:function(index){
            this.activeIndex = index
            if (index == 1 && !this.isOpenTable) {
                this.isOpenTable = true
                this.getTableRow()
            }
        },
        $computed: {
        }
    }
});