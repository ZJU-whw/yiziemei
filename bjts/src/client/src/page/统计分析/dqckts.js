var dqckts = require("./dqckts.html");
avalon.component('dqckts', {
    template: dqckts,
    defaults: {
        params: {},
        act: 1,
        searchData: {
            qylx: "1",
            swjgDm: "",
            swjgMc: "",
            cksjStart: "",
            cksjEnd: "",
            refresh: 'N',
        },
        formData: [{ JE: "", JE_SQ: "", TB: "" }, { JE: "", JE_SQ: "", TB: "" }, { JE: "", JE_SQ: "", TB: "" },],
        onReady: function () {
            var self = this;
            try {
                this.searchData.swjgDm = avalonRoot.user.swjgDm;
                this.searchData.swjgMc = avalonRoot.user.swjgMc;
                this.searchData.cksjStart = tools.getToday();
                this.searchData.cksjEnd = tools.getToday();
            } catch (e) {
            }
            self.initTree();
            $('.dqckts .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            this.searchData.qylxMc = ""
            // 如果有初始值 赋值并进行查询
            if (this.params.tjtj && this.params.tjtj.parseData === '1') {
                console.log(this.params.tjtj)
                if (this.params.tjtj.cxtjDTO.swjgDm) self.searchData.swjgDm = this.params.tjtj.cxtjDTO.swjgDm
                if (this.params.tjtj.cxtjDTO.swjgMc) self.searchData.swjgMc = this.params.tjtj.cxtjDTO.swjgMc
                if (this.params.tjtj.cxtjDTO.qylx) self.searchData.qylx = this.params.tjtj.cxtjDTO.qylx
                if (this.params.tjtj.cxtjDTO.qylxMc) self.searchData.qylxMc = this.params.tjtj.cxtjDTO.qylxMc
                if (this.params.tjtj.cxtjDTO.qyhgdm) self.searchData.qyhgdm = this.params.tjtj.cxtjDTO.qyhgdm
                if (this.params.tjtj.cxtjDTO.cksjEnd) self.searchData.cksjEnd = this.params.tjtj.cxtjDTO.cksjEnd
                if (this.params.tjtj.cxtjDTO.cksjStart) self.searchData.cksjStart = this.params.tjtj.cxtjDTO.cksjStart
                self.search(1)
            }
        },
        changeTab: function (num) {
            this.act = num;
        },
        search: function (pageNo) {
            var self = this;
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjEnd) {
                tools.info("出口时间止不能为空");
                return
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            var cxtjDTO = tools.clone(self.searchData);
            cxtjDTO.qylx = cxtjDTO.qylx ? [].concat(cxtjDTO.qylx) : [];
            var params = {
                bbdm: "D01002",
                cxtjDTO: cxtjDTO,
                pageNo: 1,
                pageSize: 1000
            };
            ajax("POST", "/bjtssw/tjfx/loaddata", params).done(function (res) {
                if (res.code == '0') {
                    var data = res.data.rows;
                    self.formData[0].JE = data[0].JE + "" ? avalon.filters.number(data[0].JE, 2) : data[0].JE;
                    self.formData[0].JE_SQ = data[0].JE_SQ + "" ? avalon.filters.number(data[0].JE_SQ, 2) : data[0].JE_SQ;
                    self.formData[0].TB = data[0].TB + "" ? avalon.filters.number(data[0].TB, 2) + "%" : data[0].TB;
                    self.formData[1].JE = data[1].JE + "" ? avalon.filters.number(data[1].JE, 2) + "%" : data[1].JE;
                    self.formData[1].JE_SQ = data[1].JE_SQ + "" ? avalon.filters.number(data[1].JE_SQ, 2) + "%" : data[1].JE_SQ;
                    self.formData[1].TB = data[1].TB + "" ? avalon.filters.number(data[1].TB, 2) + "%" : data[1].TB;
                    self.formData[2].JE = (data[2]) ? avalon.filters.number(data[2].JE, 2) + "%" : "——";
                    self.formData[2].JE_SQ = (data[2]) ? avalon.filters.number(data[2].JE_SQ, 2) + "%" : "——";
                    self.formData[2].TB = (data[2]) ? avalon.filters.number(data[2].TB, 2) + "%" : "——";
                } else if (res.code == '100') {
                    $.dialog({
                        title: "提示",
                        content: res.msg,
                        lock: true,
                        button: [
                            {
                                value: '查看结果',
                                callback: function () {
                                    var data = res.data.rows;
                                    self.formData[0].JE = data[0].JE + "" ? avalon.filters.number(data[0].JE, 2) : data[0].JE;
                                    self.formData[0].JE_SQ = data[0].JE_SQ + "" ? avalon.filters.number(data[0].JE_SQ, 2) : data[0].JE_SQ;
                                    self.formData[0].TB = data[0].TB + "" ? avalon.filters.number(data[0].TB, 2) + "%" : data[0].TB;
                                    self.formData[1].JE = data[1].JE + "" ? avalon.filters.number(data[1].JE, 2) + "%" : data[1].JE;
                                    self.formData[1].JE_SQ = data[1].JE_SQ + "" ? avalon.filters.number(data[1].JE_SQ, 2) + "%" : data[1].JE_SQ;
                                    self.formData[1].TB = data[1].TB + "" ? avalon.filters.number(data[1].TB, 2) + "%" : data[1].TB;
                                    self.formData[2].JE = (data[2]) ? avalon.filters.number(data[2].JE, 2) + "%" : "——";
                                    self.formData[2].JE_SQ = (data[2]) ? avalon.filters.number(data[2].JE_SQ, 2) + "%" : "——";
                                    self.formData[2].TB = (data[2]) ? avalon.filters.number(data[2].TB, 2) + "%" : "——";
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
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
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
        showMenu: function (e) {
            var self = this;
            $(".dropdown-menu", e.target).show();
            $('.dqckts').on('click', function (e) {
                var e = e || window.event;
                if ($('.dropdown-menu').find($(e.target)).length <= 0) {
                    self.hideMenu();
                }
            })
        },
        hideMenu: function () {
            $(".dropdown-menu").hide();
            $('.dqckts').off('click');
        },
        initTree: function () {
            var self = this;
            var setting = {
                callback: {
                    onClick: function (e, id, node) {
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
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
                $.fn.zTree.init($(".dqckts .treeDiv"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            })
        },
        showTree: function (e) {
            var self = this;
            $(".treeDiv", $(e.target).parent()).show();
            $('.dqckts').on('click', function (e) {
                var e = e || window.event;
                if ($('.treeDiv').find($(e.target)).length <= 0) {
                    self.hideTree();
                }
            })
        },
        hideTree: function () {
            $(".treeDiv").hide();
            $('.dqckts').off('click');
        },
        exform: function () {
            var self = this;
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
            var cxtjDTO = tools.clone(self.searchData);
            cxtjDTO.qylx = cxtjDTO.qylx ? [].concat(cxtjDTO.qylx) : [];
            var params = {
                bbdm: "D01002",
                cxtjDTO: cxtjDTO,
                pageSize: 1000,
                pageNo: 1
            };
            params.cxtjDTO.qylxMc = self.searchData.qylx == 1 ? "生产企业" : "外贸企业";
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
        }
    }
});