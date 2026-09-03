var ckmygjfb = require("./ckmygjfb.html");
var chart;
avalon.component('ckmygjfb', {
    template: ckmygjfb,
    defaults: {
        params: {},
        act: 1,
        ckmygMc: "",
        searchData: {
            swjgDm: "",
            swjgMc: "",
            qylx: [],
            qylxMc: "",
            qyhgdm: "",
            cksjStart: "",
            cksjEnd: "",
            tjlx: "1",
            gbcode: [],
            dqcode: [],
            refresh: 'N',
        },
        chartOption: {
            title: [{
                text: '出口贸易国家分布查询统计',
                subtext: '出口额单位：美元',
                textStyle: {
                    fontSize: 18
                },
                left: 'middle',
                top: 'top',
                textAlign: "center"
            }
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
                    name: '累计出口额占比',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '50%'],
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
            { name: "", label: "代码", index: "", hidden: false, sortable: false, align: "center", width: 150 },
            { name: "", label: "名称", index: "", hidden: false, sortable: false, align: "center", width: 150 },
            {
                name: "", label: "累计出口额(美元)", index: "", hidden: false, sortable: false, align: "center", width: 150, formatter: function (cellValue) {
                    return avalon.filters.number(cellValue, 2)
                }
            },
            { name: "", label: "占比", index: "", hidden: false, sortable: false, align: "center", width: 150 },
            {
                name: "", label: "上年同期(美元)", index: "", hidden: false, sortable: false, align: "center", width: 150, formatter: function (cellValue) {
                    return avalon.filters.number(cellValue, 2)
                }
            },
            { name: "", label: "同比", index: "", hidden: false, sortable: false, align: "center", width: 150 },
        ],
        onReady: function () {
            var self = this;
            $('.ckmygjfb .select-sub').show();
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
            $('.ckmygjfb .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            //统计表初始化
            $('#ckmygjfb-chart').width($('.ckmygjfb').width()).height($('.ckmygjfb .form').height());
            // self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            chart = echarts.init(document.getElementById('ckmygjfb-chart'));
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
                var zTree = $.fn.zTree.getZTreeObj("ckmygjfbTree2")
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
            var ckbzData = [];
            for (var rowNum = 0; rowNum < data.rows.length; rowNum++) {
                var row = data.rows[rowNum];
                //此处0,1,4指对应的col的name
                ckbzData.push({ value: row[self.tableArr[2].name], name: row[self.tableArr[1].name] });
            }
            ckbzData = tools.pieSelect(ckbzData, 11);
            self.chartOption.series[0].data = tools.clone(ckbzData);
            chart.setOption(tools.clone(self.chartOption));
        },
        getTableCol: function () {
            var self = this;
            ajax("POST", "/bjtssw/tjbb/profile/header", { bbdm: "D01004" }).done(function (res) {
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
            $("#ckmygjfb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers: true,
                pager: '#ckmygjfb-tablePager',
                shrinkToFit: true,
                width: "100%",
                multiselect: false,
                multiselectWidth: "30",
                autowidth: true,
                altRows: true,
                footerrow: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: 50,
                rowList: [20, 50, 100, 500],
                height: (function () { return $(".ckmygjfb .form").height() - 90; })(),
                beforeSelectRow: function (rowid, e) {
                    if (e.target.nodeName == "TD") {
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    } else {
                        return true;
                    }
                },
                gridComplete: function () {
                    var sumData = {};
                    for (var i = 0; i < self.tableArr.length; i++) {
                        if (i == 2 || i == 4) {
                            var sum = 0;
                            $("#ckmygjfb-table").getCol(self.tableArr[i].name, false).map(function (a) { sum += (a.replace(/\,/g, '') - 0) });
                            sumData[self.tableArr[i].name] = avalon.filters.number(sum, 2);
                        } else {
                            sumData[self.tableArr[i].name] = ""
                        }
                    }
                    sumData[self.tableArr[0].name] = "当前页合计";
                    $("#ckmygjfb-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    // self.searchData.orderSql = index + ' ' + sortorder;
                    // self.search(1);
                    return;
                },
                onPaging: function (pgButton) {
                    var pageNo = tools.getPageNo(pgButton, "ckmygjfb-table");
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ckmygjfb')).val();
            $("#ckmygjfb-table").setGridWidth($('.ckmygjfb').width())
        },
        //统计类型改变处理函数
        handleChange: function () {
            var self = this;
            this.hideTree();
            this.ckmygMc = "";
            var tjlx = $("#tjlxSelect").val();
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
            $.fn.zTree.getZTreeObj("ckmygjfbTree2").destroy();
            var data;
            if (tools.isIE8()) {
                data = staticCountry;
            } else {
                if (tjlx == "1") {
                    data = tools.clone(avalonRoot.ztreeNodes.gjdata);
                } else if (tjlx == "2") {
                    data = tools.clone(avalonRoot.ztreeNodes.dqdata);
                } else {
                    data = tools.clone(avalonRoot.ztreeNodes.jjtdata);
                }
            }
            this.searchData.gbcode = [];
            this.searchData.dqcode = [];
            $.fn.zTree.init($("#ckmygjfbTree2"), setting, data);
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
            $.fn.zTree.init($("#ckmygjfbTree2"), setting, avalonRoot.ztreeNodes.gjdata);
        },
        getCheckedChildNodes: function (type) {
            var res = { gbcode: [], dqcode: [] };
            var ckmygMc = "";
            var nodes = $.fn.zTree.getZTreeObj("ckmygjfbTree2").getCheckedNodes(true);
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
                if (ckmygMc && ckmygMc.length > 20) {
                    this.ckmygMc = ckmygMc.slice(1, 20) + "...";
                } else {
                    this.ckmygMc = ckmygMc ? ckmygMc.slice(1) : "";
                }
                res.gbcode = arr;
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
        //统计类型改变处理函数
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
            //    tools.info("出口贸易国不能为空");
            //    return
            // }
            var params = {
                bbdm: "D01004",
                cxtjDTO: tools.clone(self.searchData),
                pageSize: "1000",
                pageNo: page,
            };
            $("#ckmygjfb-table").jqGrid('clearGridData')
            ajax("POST", "/bjtssw/tjfx/loaddata", params).done(function (res) {
                if (res.code == '0') {
                    self.tableData = res.data;
                    $("#ckmygjfb-table").resetSelection();
                    $("#ckmygjfb-table")[0].addJSONData(res.data);
                    self.fleshChart(res.data)
                    self.searchData.refresh = 'N'
                } else if(res.code == '100'){
                    $.dialog({
                        title: "提示",
                        content: res.msg,
                        lock: true,
                        button: [
                            {
                                value: '查看结果',
                                callback: function () {
                                    self.tableData = res.data;
                                    $("#ckmygjfb-table").resetSelection();
                                    $("#ckmygjfb-table")[0].addJSONData(res.data);
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
                }else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
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
                data: {
                    key: {
                        children: "item",
                        name: "text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot, ajax).done(function (data) {
                $.fn.zTree.init($("#ckmygjfbTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            })
        },
        showTree: function (e) {
            var self = this;
            $(".treeDiv", $(e.target).parent()).show();
            $('.ckmygjfb').on('click', function (e) {
                var e = e || window.event;
                if ($('.treeDiv').find($(e.target)).length <= 0) {
                    self.hideTree();
                }

            })
        },
        hideTree: function () {
            $(".treeDiv").hide();
            $('.ckmygjfb').off('click');
        },
        showSelect: function (e) {
            var self = this;
            $(".select-container", $(e.target).parent()).show();
            $('.ckmygjfb .page').on('click', function (e) {
                var e = e || window.event;
                if ($('.select-container').find($(e.target)).length <= 0) {
                    $(".select-container").hide();
                    $('.ckmygjfb .page').off('click');
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
        exform: function () {
            var self = this;
            if ($("#ckmygjfb-table").jqGrid('getRowData').length <= 0) {
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
                bbdm: "D01004",
                cxtjDTO: tools.clone(self.searchData),
            };
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