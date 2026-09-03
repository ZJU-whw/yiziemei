var ckqyhyfb = require("./ckqyhyfb.html");
var chart;
avalon.component('ckqyhyfb', {
    template: ckqyhyfb,
    defaults: {
        params: {},
        act: 1,
        bbdm: "D01007",
        ckmygMc: "",
        searchData: {
            refresh: 'N',
            swjgDm: "",
            swjgMc: "",
            qylx: [],
            qylxMc: "",
            qyhgdm: "",
            cksjStart: "",
            cksjEnd: "",
            tjlx: "1",
            gbcode: [],
            dqcode: []
        },
        chartOption: {
            title: [{
                text: '出口企业行业分布情况统计',
                subtext: '出口额单位：美元，退税额单位：元',
                textStyle: {
                    fontSize: 18
                },
                left: 'middle',
                top: 'top',
                textAlign: "center"
            }, {
                text: '出口额比重',
                textStyle: {
                    fontSize: 15
                },
                left: '25%',
                top: '7%',
                textAlign: "center"
            }, {
                text: '退税额比重',
                textStyle: {
                    fontSize: 15
                },
                left: '75%',
                top: '7%',
                textAlign: "center"
            },
            ],
            tooltip: {
                trigger: 'item',
                formatter: "{b} : {c} ({d}%)"
            },
            legend: {
                type: 'scroll',
                pageButtonPosition: "start",
                x: 'center',
                y: 'bottom',
            },
            calculable: true,
            series: [
                {
                    name: '出口额比重',
                    type: 'pie',
                    radius: [0, 120],
                    center: ['25%', '50%'],
                    label: {
                        formatter: '{d}%'
                    },
                    data: [

                    ]
                },
                {
                    name: '退税额比重',
                    type: 'pie',
                    radius: [0, 120],
                    center: ['75%', '50%'],
                    label: {
                        formatter: '{d}%'
                    },
                    data: [

                    ]
                }
            ]
        },
        tableCol: [],
        tableArr: [
            { name: "", label: "主行业", index: "", hidden: false, sortable: false, align: "center", width: 150, },
            { name: "", label: "子行业", index: "", hidden: false, sortable: false, align: "center", width: 150, },
            { name: "", label: "户数", index: "", hidden: false, sortable: false, align: "right", width: 100 },
            {
                name: "", label: "累计出口额(美元)", index: "", hidden: false, sortable: false, align: "right", width: 150, formatter: function (cellvalue, options, rowObject) {
                    return avalon.filters.number(cellvalue, 2);
                }
            },
            { name: "", label: "占比", index: "", hidden: false, sortable: false, align: "center", width: 50 },
            { name: "", label: "同比", index: "", hidden: false, sortable: false, align: "center", width: 50 },
            {
                name: "", label: "累计退税额(元)", index: "", hidden: false, sortable: false, align: "right", width: 150, formatter: function (cellvalue, options, rowObject) {
                    return avalon.filters.number(cellvalue, 2);
                }
            },
            { name: "", label: "占比", index: "", hidden: false, sortable: false, align: "center", width: 50 },
            { name: "", label: "同比", index: "", hidden: false, sortable: false, align: "center", width: 50 },
            { name: "HYDM", label: "行业代码", index: "HYDM", hidden: true, sortable: false, align: "center", width: 50 },
        ],
        onReady: function () {
            var self = this;
            this.getTableCol();
            this.initTree();
            this.initTree2();
            try {
                this.searchData.swjgDm = avalonRoot.user.swjgDm;
                this.searchData.swjgMc = avalonRoot.user.swjgMc;
                this.searchData.qylxMc = "生产企业,外贸企业,外综服企业";
                this.searchData.cksjStart = tools.getToday();
                this.searchData.cksjEnd = tools.getToday();
            } catch (e) {
            }
            $('.ckqyhyfb .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            //统计表初始化
            $('#ckqyhyfb-chart').width($('.ckqyhyfb').width()).height($('.ckqyhyfb .form').height());
            // self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            chart = echarts.init(document.getElementById('ckqyhyfb-chart'));
            chart.setOption(tools.clone(self.chartOption));

            this.searchData.qylxMc = ""
            // 如果有初始值 赋值并进行查询
            if (this.params.tjtj && this.params.tjtj.parseData === '1') {
                if (this.params.tjtj.cxtjDTO.swjgDm) self.searchData.swjgDm = this.params.tjtj.cxtjDTO.swjgDm
                if (this.params.tjtj.cxtjDTO.swjgMc) self.searchData.swjgMc = this.params.tjtj.cxtjDTO.swjgMc
                if (this.params.tjtj.cxtjDTO.qylx) self.searchData.qylx = this.params.tjtj.cxtjDTO.qylx
                if (this.params.tjtj.cxtjDTO.qylxMc) self.searchData.qylxMc = this.params.tjtj.cxtjDTO.qylxMc
                if (this.params.tjtj.cxtjDTO.qyhgdm) self.searchData.qyhgdm = this.params.tjtj.cxtjDTO.qyhgdm
                if (this.params.tjtj.cxtjDTO.cksjEnd) self.searchData.cksjEnd = this.params.tjtj.cxtjDTO.cksjEnd
                if (this.params.tjtj.cxtjDTO.cksjStart) self.searchData.cksjStart = this.params.tjtj.cxtjDTO.cksjStart
                if (this.params.tjtj.cxtjDTO.dqcode) self.searchData.dqcode = this.params.tjtj.cxtjDTO.dqcode
                if (this.params.tjtj.cxtjDTO.gbcode) self.searchData.gbcode = this.params.tjtj.cxtjDTO.gbcode
                if (this.params.tjtj.cxtjDTO.cmcode) self.searchData.cmcode = this.params.tjtj.cxtjDTO.cmcode
                var zTree = $.fn.zTree.getZTreeObj("ckqyhyfbTree2")
                var text = ''
                for (var key of this.params.tjtj.cxtjDTO.gbcode) {
                    zTree.getNodeByParam("id", key).checked = true
                    zTree.getNodeByParam("id", key).getParentNode().checked = true
                    zTree.updateNode(zTree.getNodeByParam("id", key).getParentNode());
                    text += zTree.getNodeByParam("id", key).name + ','
                }
                text=text.slice(0,-1)
                self.ckmygMc = text
                self.search(1)
            }
        },

        changeTab: function (num) {
            this.act = num;
        },
        fleshChart: function (data) {
            var self = this;
            var ckbzData = [], tsbzData = [];
            for (var rowNum = 0; rowNum < data.rows.length; rowNum++) {
                var row = data.rows[rowNum];
                //此处0,1,4指对应的col的name
                if (row[self.tableArr[1].name]) {
                    ckbzData.push({ value: row[self.tableArr[3].name], name: row[self.tableArr[1].name] })
                    tsbzData.push({ value: row[self.tableArr[6].name], name: row[self.tableArr[1].name] })
                }
            }
            ckbzData = tools.pieSelect(ckbzData, 11);
            tsbzData = tools.pieSelect(tsbzData, 11);
            self.chartOption.series[0].data = tools.clone(ckbzData);
            self.chartOption.series[1].data = tools.clone(tsbzData);
            chart.setOption(tools.clone(self.chartOption));
        },
        getTableCol: function () {
            var self = this;
            ajax("POST", "/bjtssw/tjbb/profile/header", { bbdm: self.bbdm }).done(function (res) {
                if (res.code == "0") {
                    if (res.data.column.length > 0) {
                        for (var i = 0; i < res.data.column.length; i++) {
                            self.tableArr[i].name = res.data.column[i].fname;
                            self.tableArr[i].index = res.data.column[i].fname;
                        }
                    }
                    self.createTable(self.tableArr);
                } else {
                    tools.info(res.msg)
                }

            }).fail(function (err) {
                tools.info(err);
            })
        },
        createTable: function (arr) {
            var self = this;
            var cm = [];
            for (var i = 0; i < arr.length; i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#ckqyhyfb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers: true,
                pager: '#ckqyhyfb-tablePager',
                shrinkToFit: true,
                width: "100%",
                multiselect: false,
                multiselectWidth: "30",
                autowidth: true,
                altRows: true,
                footerrow: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: -1,
                pgbuttons: false,
                pginput: false,
                // rowList: [20,50,100,500],
                height: (function () { return $(".ckqyhyfb .form").height() - 90; })(),
                beforeSelectRow: function (rowid, e) {
                    if ($(e.target).hasClass('dzzd')) {
                        var b = getCellData("ckqyhyfb-table", rowid, 'taxpayerCode')
                        vm.addTab({ title: "企业信息采集", component: "qyxxcj", params: { taxpayerCode: b } });
                        return false;
                    } else if ($(e.target).hasClass('aqm')) {
                        var url = getCellData("ckqyhyfb-table", rowid, 'securityCodeUrl')
                        if (!url) { tools.info('链接不存在'); return false; }
                        window.open(url)
                        return false;
                    } else if ($(e.target).hasClass('zcwj')) {
                        var url = getCellData("ckqyhyfb-table", rowid, 'zcmUrl')
                        if (!url) { tools.info('链接不存在'); return false; }
                        window.open(url);
                        return false;
                    } else if (e.target.nodeName == "TD") {
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    } else {
                        return true;
                    }

                },
                gridComplete: function () {
                    // var data = self.data.rows;
                    // var len = data.length;
                    var sumData = {}
                    for (var i = 0; i < self.tableArr.length; i++) {
                        if (i == 2 || i == 3 || i == 6) {
                            var sum = 0;
                            $("#ckqyhyfb-table").getCol(self.tableArr[i].name, false).map(function (a, key) {
                                if (self.tableData.rows[key].HYDM.length == 1) {

                                } else {
                                    sum += (a.replace(/\,/g, '') - 0)
                                }
                            });
                            sumData[self.tableArr[i].name] = avalon.filters.number(sum, 2);
                        } else {
                            sumData[self.tableArr[i].name] = ""
                        }
                    }
                    sumData[self.tableArr[0].name] = "当前页合计";
                    $("#ckqyhyfb-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    // self.searchData.orderSql = index + ' ' + sortorder;
                    // self.search(1);
                    return;
                },
                onPaging: function (pgButton) {
                    var pageNo = tools.getPageNo(pgButton, "ckqyhyfb-table");
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqyhyfb')).val();
            $("#ckqyhyfb-table").setGridWidth($('.ckqyhyfb').width())
        },
        search: function (page) {
            var self = this;
            if (this.searchData.qylx.length == 0) {
                tools.info("企业类型不能为空");
                return
            }
            this.searchData.qylx = this.searchData.qylx.sort(function (a, b) { return a - b });
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd) {
                tools.info("出口时间止不能为空");
                return
            }
            if (!tools.betweenYear(cksjStart, cksjEnd)) {
                tools.info('出口日期起和止的跨度不能超过1个自然年度');
                return;
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params = {
                bbdm: self.bbdm,
                cxtjDTO: tools.clone(self.searchData),
                pageSize: "1000",
                pageNo: page,
            }
            $("#ckqyhyfb-table").jqGrid('clearGridData')
            ajax("POST", "/bjtssw/tjfx/loaddata", params).done(function (res) {
                if (res.code == '0') {
                    self.tableData = res.data;
                    $("#ckqyhyfb-table").resetSelection();
                    $("#ckqyhyfb-table")[0].addJSONData(res.data);
                    self.fleshChart(res.data)
                    self.searchData.refresh = 'N'
                }else if (res.code == '100') {
                    $.dialog({
                        title: "提示",
                        content: res.msg,
                        lock: true,
                        button: [
                            {
                                value: '查看结果',
                                callback: function () {
                                    self.tableData = res.data;
                                    $("#ckqyhyfb-table").resetSelection();
                                    $("#ckqyhyfb-table")[0].addJSONData(res.data);
                                    self.fleshChart(res.data)
                                }
                            },
                            {
                                value: '重新统计',
                                callback: function () {
                                    self.searchData.refresh = "Y"
                                    self.search(1)
                                }
                            },
                            {
                                value: '取消'
                            }
                        ]
                    })
                } else{
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        initTree2: function () {
            var self = this;
            var setting = {
                check: {
                    enable: true,
                    chkboxType: { "Y": "ps", "N": "ps" },
                    chkStyle: "checkbox"
                },
                view: {
                    showIcon: false,
                    selectedMulti: false,
                },
                data: {
                    key: {
                        children: "states"
                    }
                },
                callback: {
                    onCheck: function () {
                        var tjlx = self.searchData.tjlx;
                        var type = tjlx == "1" ? "gbcode" : "dqcode";
                        var resObj = self.getCheckedChildNodes(type);
                        self.searchData.gbcode = resObj.gbcode;
                        self.searchData.dqcode = resObj.dqcode;
                    }
                }
            };
            var data;
            if (tools.isIE8()) {
                data = staticCountry;
            } else {
                data = tools.clone(avalonRoot.ztreeNodes.gjdata);
            }
            $.fn.zTree.init($("#ckqyhyfbTree2"), setting, data);
        },
        getCheckedChildNodes: function (type) {
            var res = { gbcode: [], dqcode: [] };
            var ckmygMc = "";
            var nodes = $.fn.zTree.getZTreeObj("ckqyhyfbTree2").getCheckedNodes(true);
            //按照国家 所有的统计方式gbcode都传国家代码进去
            if (type == "gbcode") {
                var arr = [];
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].isParent) {
                        continue;
                    }
                    arr.push(nodes[i].id);
                    ckmygMc += "," + nodes[i].name;
                }
                res.gbcode = arr;
                if (ckmygMc && ckmygMc.length > 20) {
                    this.ckmygMc = ckmygMc.slice(1, 20) + "...";
                } else {
                    this.ckmygMc = ckmygMc ? ckmygMc.slice(1) : "";
                }
            }
            //其他按大洲按经济体
            else {
                var arr1 = [], arr2 = [];
                var children;
                for (var i = 0; i < nodes.length; i++) {
                    arr1.push(nodes[i].id);
                    ckmygMc += "," + nodes[i].name;
                    children = nodes[i].states;
                    for (var j = 0; j < children.length; j++) {
                        arr2.push(children[j].id);
                    }
                }
                if (ckmygMc && ckmygMc.length > 20) {
                    this.ckmygMc = ckmygMc.slice(1, 20) + "...";
                } else {
                    this.ckmygMc = ckmygMc ? ckmygMc.slice(1) : "";
                }
                res.gbcode = arr2;
                res.dqcode = arr1;
            }
            return res;
        },
        showSelect: function (e) {
            var self = this;
            $(".select-container", $(e.target).parent()).show();
            $('.ckqyhyfb .page').on('click', function (e) {
                var e = e || window.event;
                if ($('.select-container').find($(e.target)).length <= 0) {
                    $(".select-container").hide();
                    $('.ckqyhyfb .page').off('click');
                }
            })
        },
        selectChange: function (e) {
            var map = { "1": "生产企业", "2": "外贸企业", "3": "外综服企业" };
            if (this.searchData.qylx && this.searchData.qylx.length == 0) {
                this.searchData.qylxMc = "";
            } else {
                var str = ""
                for (var i = 0; i < this.searchData.qylx.length; i++) {
                    str += "," + map[this.searchData.qylx[i]];
                }
                this.searchData.qylxMc = str.slice(1);
            }
        },
        handleChange: function () {
            var self = this;
            this.hideTree();
            this.ckmygMc = "";
            var tjlx = $(".ckqyhyfb .tjlxSelect").val();
            var childrenType = tjlx == "1" ? "states" : "none";
            var setting = {
                check: {
                    enable: true,
                    chkboxType: { "Y": "ps", "N": "ps" },
                    chkStyle: "checkbox"
                },
                view: {
                    showIcon: false,
                    selectedMulti: false,
                },
                data: {
                    key: {
                        children: childrenType
                    }
                },
                callback: {
                    onCheck: function () {
                        var tjlx = self.searchData.tjlx;
                        var type = tjlx == "1" ? "gbcode" : "dqcode";
                        var resObj = self.getCheckedChildNodes(type);
                        self.searchData.gbcode = resObj.gbcode;
                        self.searchData.dqcode = resObj.dqcode;
                    }
                }
            };
            $.fn.zTree.getZTreeObj("ckqyhyfbTree2").destroy();
            var data;
            if (tjlx == "1") {
                data = tools.clone(avalonRoot.ztreeNodes.gjdata);
            } else if (tjlx == "2") {
                data = tools.clone(avalonRoot.ztreeNodes.dqdata);
            } else {
                data = tools.clone(avalonRoot.ztreeNodes.jjtdata);
            }
            $.fn.zTree.init($("#ckqyhyfbTree2"), setting, data);
        },
        reset: function () {
            var self = this;
            self.searchData = {
                tsjg: "",
                qylx: "",
                cksjStart: "",
                cksjEnd: "",
                gbcode: []
            }
        },
        filDate: function (e) {
            var date = e.target.value;
            var res = tools.DateCheup(date);
            if (res === false) {
                tools.info("日期输入错误");
                res = ""
            }
            e.target.value = res;

            return;
        },
        initTree: function () {
            var tree;
            var self = this;
            var setting = {
                callback: {
                    onClick: function (e, id, node) {
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        // console.log(tree.getCheckedNodes(true));
                        self.hideTree();
                        return;
                    },
                    onDblClick: function (e, id, node) {
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                // check:{
                //     autoCheckTrigger: true,
                //     enable: true,
                //     chkStyle: "checkbox",
                //     nocheckInherit: false,
                //     chkDisabledInherit: false,
                //
                //     chkboxType: { "Y": "ps", "N": "ps" }
                // },
                data: {
                    key: {
                        children: "item",
                        name: "text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot, ajax).done(function (data) {
                $.fn.zTree.init($("#ckqyhyfbTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });


        },
        showTree: function (e) {
            var self = this;
            $(".treeDiv", $(e.target).parent()).show();
            $('.ckqyhyfb').on('click', function (e) {
                var e = e || window.event;
                if ($('.treeDiv').find($(e.target)).length <= 0) {
                    self.hideTree();
                }

            })
        },
        hideTree: function () {
            $(".treeDiv").hide();
            $('.ckqyhyfb').off('click');
        },

        exform: function () {
            var self = this;
            if ($("#ckqyhyfb-table").jqGrid('getRowData').length <= 0) {
                tools.info("请先查询列表");
                return;
            }
            if (this.searchData.qylx.length == 0) {
                tools.info("企业类型不能为空");
                return
            }
            this.searchData.qylx = this.searchData.qylx.sort(function (a, b) { return a - b });
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd) {
                tools.info("出口时间止不能为空");
                return
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params = {
                bbdm: self.bbdm,
                cxtjDTO: tools.clone(self.searchData),
                pageSize: "20",
                pageNo: 1
            }
            params.cxtjDTO.gjmc = self.ckmygMc;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/tjfx/loaddata/export");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        $computed: {
            qylxMc: function () {
                var map = {
                    "1": "生产企业",
                    "2": "外贸企业",
                    "3": "外综服企业",
                }
                var arr = this.searchData.qylx.map(function (a) {
                    return map[a];
                })
                var str = arr.join(',')
                this.searchData.qylxMc = str;
                return str;
            },
            spdlMc: function () {
                var xdtjMc = "";
                var self = this;
                $.each(this.spdl, function (index, item) {
                    if (self.searchData.spmlcode.indexOf(item.spml) > -1) {
                        xdtjMc += "," + item.mldm;
                    }
                })
                if (xdtjMc.length > 20) {
                    xdtjMc = xdtjMc.slice(1, 20)
                } else {
                    xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
                this.xdtjMc = xdtjMc;
                return xdtjMc
            },
            tslMc: function () {
                var xdtjMc = "";
                var self = this;
                $.each(this.searchData.tslcode, function (index, item) {
                    xdtjMc += "," + item + "%";
                });
                xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                this.xdtjMc = xdtjMc;
                return xdtjMc
            }
        }
    }
});