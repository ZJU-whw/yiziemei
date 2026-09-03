var jgcx = require("./jgcx.html");
avalon.component('jgcx', {
    template: jgcx,
    defaults: {
        params: {},
        act: 1,
        tcode: "jgcx",
        swjgmc: "",
        selRows: [],
        swjg_dm: '',
        searchData: {
            swjg_dm: "",
            swjg: "",
            tjlx: "",
            tjrq: "",
            tjr: "",
            // orderSql: "",
            pageSize: config.pageSize,
        },
        onReady: function () {
            var self = this;
            try {
                this.searchData.swjg_dm = avalonRoot.user.swjgDm;
                this.swjgmc = avalonRoot.user.swjgMc;
            } catch (e) {

            }
            this.initTree();
            this.createTable();
            $('.dzzmrz .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.dzzmrz .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
        },

        changeTab: function (num) {
            this.act = num;
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
        //copy bg
        createTable: function () {
            var self = this;
            var columns = [
                { name: "id", label: "主键id", index: "主键id", hidden: true, align: "center", sortable: true },
                {
                    name: "tjlxMc", label: "统计名称", index: "qyhgdm", width: 200, align: "center", sortable: true, formatter: function (cellvalue) {
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openTj'>" + cellvalue + "</span>";
                    }
                },
                { name: "swjg", label: "税务机关", index: "swjg", width: 140, align: "center", sortable: true },
                { name: "tjr", label: "统计人", index: "tjr", width: 100, align: "center", sortable: true },
                { name: "tjrq", label: "统计日期", index: "tjrq", width: 100, align: "center", sortable: true },
                { name: "bz", label: "用时时间", index: "bz", width: 120, align: "center", sortable: true },
                { name: "tjtjMc", label: "统计条件", index: "tjtjMc", width: 350, align: "center", sortable: true },
                { name: "tjlx", label: "统计类型", index: "tjlx", width: 200, align: "center", sortable: true, hidden: true, },
                { name: "tjtj", label: "统计条件", index: "tjtj", width: 200, align: "center", sortable: true, hidden: true, },
                { name: "rwlx", label: "任务类型", hidden: true, index: "rwlx", width: 100, align: "center", sortable: true },
                { name: "rwhash", label: "任务hash", hidden: true, index: "rwhash", width: 100, align: "center", sortable: true },
                {
                    name: "sc", label: "操作", index: "", width: 100, align: "center", sortable: true, formatter: function () {
                        var str = "<div class='btn tz' style='float: none;display: inline-block;background-color:#f56c6c' title='删除'>删除</div>"
                        return str;
                    }
                },
            ];
            $("#jgcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers: true,
                pager: '#jgcx-tablePager',
                shrinkToFit: false,
                autowidth: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowList: [20,50,100,500],
                rowNum: config.pageSize,
                width: "100%",
                height: (function () {
                    return $(".dzzmrz .form").height() - 60;
                })(),
                beforeSelectRow: function (rowid, e) {
                    if ($(e.target).hasClass('btn')) {
                        var rwlx = getCellData("jgcx-table", rowid, 'rwlx')
                        var rwhash = getCellData("jgcx-table", rowid, 'rwhash')
                        var params = { rwlx: rwlx, rwhash: rwhash }
                        ajax("POST", "/bjtssw/tjfx/tjrw/delete", params).done(function (res) {
                            if (res.code == '0') {
                                tools.info("删除成功!", function () {
                                    self.search(1)
                                });
                            } else {
                                tools.info(res.msg);
                            }
                        }).fail(function (err) {
                            tools.info(err);
                        })

                    }
                    // 如果点击的统计名称
                    if ($(e.target).hasClass('openTj')) {
                        // 获取统计条件
                        var tjtj = getCellData("jgcx-table", rowid, 'tjtj')
                        tjtj = JSON.parse(tjtj)
                        tjtj.parseData = '1'
                        var tjlx = getCellData("jgcx-table", rowid, 'tjlx')
                        console.log(tjlx, rowid)
                        switch (tjlx) {
                            case 'D01002':
                                avalonRoot.addTab({ id: "", title: "地区出口退税基本情况", component: "dqckts", params: { tjtj: tjtj } },)
                                break;
                            case 'D01003':
                                avalonRoot.addTab({ id: "", title: "分大类商品出口数据统计", component: "fdlsp", params: { tjtj: tjtj } },)
                                break;
                            case 'D01004':
                                avalonRoot.addTab({ id: "", title: "出口贸易国家分布统计", component: "ckmygjfb", params: { tjtj: tjtj } },)
                                break;
                            case 'D01005':
                                avalonRoot.addTab({ id: "", title: "出口企业排名", component: "qypmsh", params: { tjtj: tjtj } },)
                                break;
                            case 'D01006':
                                avalonRoot.addTab({ id: "", title: "出口商品退税率分布情况统计", component: "sptslfb", params: { tjtj: tjtj } },)
                                break;
                            case 'D01007':
                                avalonRoot.addTab({ id: "", title: "出口企业行业分布情况统计", component: "ckqyhyfb", params: { tjtj: tjtj } },)
                                break;
                            case 'D01008':
                                avalonRoot.addTab({ id: "", title: "出口海关分布情况统计", component: "ckhgfb", params: { tjtj: tjtj } },)
                                break;
                            case 'D01009':
                                avalonRoot.addTab({ id: "", title: "出口监管方式情况统计表", component: "ckjgfs", params: { tjtj: tjtj } },)
                                break;
                            case 'D01010':
                                avalonRoot.addTab({ id: "", title: "外贸供货企业分析", component: "wmghqy", params: { tjtj: tjtj } },)
                                break;
                        }
                    }
                    // avalonRoot.addTab({ id: "", title: "出口企业排名", component: "qypmsh", params: { name: 'asdf' }, })
                    // if ($(e.target).hasClass('btn')) {
                    //     tools.confirm("是否删除该统计报表", "确定", function () {
                    //         // self.delRole(code);
                    //         console.log(1)
                    //     });
                    // }
                }, onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging: function (pgButton) {
                    var pageNo = tools.getPageNo(pgButton, "jgcx-table");
                    self.search(pageNo);
                }
            });
        },
        search: function (pageNo) {
            var self = this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.dzzmrz')).val() || 20;
            var params = tools.clone(self.searchData);
            params.pageNo = pageNo;
            $("#jgcx-table").jqGrid('clearGridData')
            console.log(self.swjgmc)
            params.swjg = self.searchData.swjg_dm
            // $("#jgcx-table")[0].addJSONData([{ tjlxMc: 'asdf', tjtj: '统计条件', swjg: '税务机关', tjr: '统计人', tjrq: '统计日期' }, { tjlxMc: 'a1111', tjtj: '统计条件', swjg: '税务机关', tjr: '统计人', tjrq: '统计日期' }]);
            ajax("POST", "/bjtssw/tjfx/tjrw/list", params).done(function (res) {
                if (res.code == '0') {
                    $("#jgcx-table")[0].addJSONData(res.data);
                    self.closeHyper()
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        initTree: function () {
            var self = this;
            var setting1 = {
                callback: {
                    onClick: function (e, id, node) {
                        self.searchData.swjg_dm = node.id;
                        console.log(self.searchData.swjg_dm)
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick: function (e, id, node) {
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data: { key: { children: "item", name: "text" } }
            };
            tools.getCachedSwjg(avalonRoot, ajax).done(function (data) {
                $.fn.zTree.init($(".dzzmrz .treeDiv"), setting1, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showHyper: function () {
            $('.dzzmrz .select-sub').toggle();
            $('.dzzmrz .select-wrapper .icon').toggleClass("active");
            if ($('.dzzmrz .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
                $('.dzzmrz .select-wrapper .icon').attr("title", "收起查询条件");
            } else {
                $('.dzzmrz .select-wrapper .icon').attr("title", "展开查询条件")
            }
        }, closeHyper: function () {
            $('.dzzmrz .select-sub').hide();
            $('.dzzmrz .select-wrapper .icon').removeClass('active');
            $('.dzzmrz .select-wrapper .icon').attr("title", "展开查询条件")
        },
        showTree: function (e) {
            var self = this;
            $(".treeDiv", $(e.target).parent()).show();
            $('.dzzmrz').on('click', function (e) {
                var e = e || window.event;
                if ($('.treeDiv').find($(e.target)).length <= 0) {
                    self.hideTree();
                }

            })
        },
        hideTree: function () {
            $(".treeDiv").hide();
            $('.dzzmrz').off('click');
        },
        exform: function () {
            var self = this;
            if ($("#jgcx-table").jqGrid('getRowData').length <= 0) {
                tools.info("请先查询列表");
                return;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/dzzmrzqd");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
    }
});