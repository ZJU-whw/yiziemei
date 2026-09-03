var ckllzhgl = require("./ckllzhgl.html");
require("./ckllzhgl.css");
// 报关单预览弹框组件（仅在本页面使用）
require("../../../../components/common/bgdDetail.js");
// 发票预览弹框组件（仅在本页面使用）
require("../../../../components/common/fpDetail.js");
avalon.component('ckllzhgl', {
    template: ckllzhgl,
    defaults: {
        params: {},
        act: 1,
        tcode: "qyckllxxb",
        // 允许排序的字段白名单
        sortableFields: ["mylaj", "ckrq", "fxdjGxrq"],
        searchData: {
            swjgDm: "",
            swjgMc: "",
            fxdjGxrqQ: "",
            fxdjGxrqZ: "",
            fxdjDm: "",
            fhmsDm: "1",
            ysfsDm: "2",
            tmsjsffDm: "",
            qybs: "",
            gybs: "",
            bgdhgbh: "",
            ckrqQ: "",
            ckrqZ: "",
            jzxh: "",
            cph: "",
            ckfph: "",
            orderSql: "",
            pageSize: config.pageSize
        },
        timer: null,
        tableArr: [],
        tableOption: [],
        tableData: {},
        cphKeyboardTimer: null,
        fxdjList: [],  // 链路概率等级列表
        editDialog: {
            currentRow: null,
            djxh: "",
            bgdhgbh: "",
            cph: "",
            cphKeyboardShow: false,
            cpysCode: "",
            cpysName: "",
            qyrq: "",
            qyd: ""
        },
        qrDialog: {
            qrBase: "",
            emptyText: "",
            qrImgError: false
        },
        cpysList: [
            { code: "2", name: "黄色" },
            { code: "3", name: "黄绿色" },
            { code: "1", name: "蓝色" }
        ],
        provinceKeys: [
            ["京", "津", "沪", "渝", "冀", "晋", "蒙", "辽", "吉", "黑"],
            ["苏", "浙", "皖", "闽", "赣", "鲁", "豫", "鄂", "湘", "粤"],
            ["桂", "琼", "川", "贵", "云", "藏", "陕", "甘", "青", "宁"],
            ["新", "港", "澳", "台"]
        ],
        charKeys: [
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
            ["A", "B", "C", "D", "E", "F", "G", "H", "J", "K"],
            ["L", "M", "N", "P", "Q", "R", "S", "T", "U", "V"],
            ["W", "X", "Y", "Z"]
        ],

        onReady: function () {
            var self = this;
            try {
                self.searchData.swjgDm = avalonRoot.user.swjgDm;
                self.searchData.swjgMc = avalonRoot.user.swjgMc;
            } catch (e) { }

            // 默认数据刷新时间：最近一个月
            var now = new Date();
            var end = self.formatDate(now);
            var startDate = new Date(now.getTime() - 30 * 24 * 3600 * 1000);
            self.searchData.fxdjGxrqQ = self.formatDate(startDate);
            self.searchData.fxdjGxrqZ = end;

            self.getTableRow();
            self.initTree();
            self.initDate();
            self.loadFxdjList();
        },
        // 初始化日期控件（与 sdhcqkcx 保持一致）
        initDate: function () {
            var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
            $('.ckllzhgl .datepicker.date-day').datetimepicker(options);
        },
        // 修复多次点击隐藏问题
        showDatetimepicker: function (e) {
            $(e.target).datetimepicker('show');
        },
        // 加载链路概率等级列表
        loadFxdjList: function() {
            var self = this;
            ajax("POST", "/bjtssw/yj/fxdjsz", { pageNo: 1, pageSize: 20 }).done(function(res) {
                if (res.code == '0' && res.data && res.data.rows) {
                    self.fxdjList = res.data.rows;
                }
            }).fail(function(err) {
                console.error('加载链路概率等级列表失败:', err);
            });
        },

        formatDate: function (d) {
            var y = d.getFullYear();
            var m = ('0' + (d.getMonth() + 1)).slice(-2);
            var dd = ('0' + d.getDate()).slice(-2);
            return y + '-' + m + '-' + dd;
        },

        getTableRow: function () {
            var self = this;
            ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode }).done(function (res) {
                if (res.code == "0") {
                    var arr = res.data.profiles || [];
                    var tableArr = [];
                    var tableOption = [];
                    tableArr.push({
                        name: "op2",
                        label: "操作",
                        width: 0,
                        frozen: true,
                        align: "center",
                        resizable: false,
                        search: false,
                        sortable: false,
                        formatter: function () {
                            return "<div class='btn op-btn op-logistics' title='国内货运信息查询'>物流查询</div>";
                        }
                    });
                    for (var i = 0; i < arr.length; i++) {
                        var name = arr[i].t_c_code;
                        var sortable = self.sortableFields.indexOf(name) >= 0;
                        var obj = {
                            name: name,
                            label: arr[i].t_c_name,
                            index: name,
                            sortable: sortable,
                            hidden: false,
                            width: arr[i].c_std_size,
                            align: arr[i].align == 0 ? "left" : arr[i].align == 1 ? "center" : "right"
                        };
                        if (arr[i].degree) {
                            (function (degree) {
                                obj.formatter = function (cellvalue) {
                                    return avalon.filters.number(cellvalue, degree);
                                };
                            })(arr[i].degree);
                        } else if (name === 'bgdhgbh') {
                            obj.formatter = function (cellvalue, options, rowObject) {
                                var v = (cellvalue === null || cellvalue === undefined) ? '' : cellvalue;
                                if (v === '') return '';
                                var djxh = self.getDjxhValue(rowObject);
                                return '<span class="bgd-preview-link" data-ckbgdh="' + v + '" data-djxh="' + djxh + '" style="color:#409eff;text-decoration:underline;cursor:pointer;" title="点击预览报关单">' + v + '</span>';
                            };
                        } else if (name === 'ckfph' || name === 'jhpzh') {
                            obj.formatter = function (cellvalue, options, rowObject) {
                                var v = (cellvalue === null || cellvalue === undefined) ? '' : cellvalue;
                                if (v === '') return '';
                                var zyfpNo = (rowObject && rowObject.ckfph != null) ? rowObject.ckfph : '';
                                return '<span class="fp-preview-link" data-zyfpno="' + zyfpNo + '" style="color:#409eff;text-decoration:underline;cursor:pointer;" title="点击预览发票详情">' + v + '</span>';
                            };
                        }
                        tableArr.push(obj);
                        if (arr[i].is_fixed == '0') {
                            tableOption.push({
                                name: name,
                                label: arr[i].t_c_name,
                                show: false
                            });
                        }
                    }
                    tableArr.push({ name: "op", label: "操作", width: 150, align: "center", resizable: false, search: false, sortable: false });
                    self.tableArr = tableArr;
                    self.tableOption = tableOption;
                    if (tableArr.length > 0) {
                        self.createTable(tableArr);
                    }
                    var selected = (res.data.select || "").split(",");
                    for (var j = 0; j < selected.length; j++) {
                        for (var k = 0; k < self.tableOption.length; k++) {
                            if (selected[j] == self.tableOption[k].name) {
                                self.tableOption[k].show = true;
                            }
                        }
                    }
                    self.resetTable();
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            });
        },

        createTable: function (arr) {
            var self = this;
            var cm = [];
            for (var i = 0; i < arr.length; i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#ckllzhgl-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers: true,
                pager: '#ckllzhgl-tablePager',
                shrinkToFit: false,
                width: "100%",
                autowidth: true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20, 50, 100, 500],
                height: (function () {
                    return $(".ckllzhgl .form").height() - 60;
                })(),
                beforeSelectRow: function (rowid, e) {
                    if ($(e.target).hasClass('op-logistics')) {
                        self.queryLogistics(rowid);
                        return false;
                    }
                    return true;
                },
                onSortCol: function (index, iCol, sortorder) {
                    if (self.sortableFields.indexOf(index) < 0) return 'stop';
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging: function (pgButton) {
                    var pageNo = tools.getPageNo(pgButton, "ckllzhgl-table");
                    self.search(pageNo);
                }
            });
            $("#ckllzhgl-table").jqGrid('setFrozenColumns');
            self.fixOperationColumn();
            $("#ckllzhgl-table").off('click.bgdPreview').on('click.bgdPreview', '.bgd-preview-link', function () {
                self.previewBgd($(this).attr('data-ckbgdh'), $(this).attr('data-djxh'));
            });
            $("#ckllzhgl-table").off('click.fpPreview').on('click.fpPreview', '.fp-preview-link', function () {
                self.previewFp($(this).attr('data-zyfpno'));
            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ckllzhgl')).val();
            self.search(1);
        },

        fixOperationColumn: function () {
            setTimeout(function () {
                tools.HeiKjNoSel('ckllzhgl', 'ckllzhgl-table');
            }, 0);
            setTimeout(function () {
                tools.HeiKjNoSel('ckllzhgl', 'ckllzhgl-table');
            }, 220);
        },

        trimVal: function (v) {
            return v == null ? "" : ("" + v).replace(/^\s+|\s+$/g, "");
        },

        getRawRow: function (rowid) {
            var row = null;
            var rows = (this.tableData && this.tableData.rows) || [];
            try {
                var rowIndex = $("#ckllzhgl-table").jqGrid('getInd', rowid);
                if (rowIndex > 0 && rows[rowIndex - 1]) {
                    return rows[rowIndex - 1];
                }
            } catch (e) { }
            var index = parseInt(rowid, 10);
            if (!isNaN(index) && index > 0 && rows[index - 1]) {
                return rows[index - 1];
            }
            try {
                row = $("#ckllzhgl-table").jqGrid('getLocalRow', rowid);
            } catch (e) { }
            if (!row) {
                row = $("#ckllzhgl-table").jqGrid('getRowData', rowid);
            }
            return row || {};
        },

        getCpysName: function (code) {
            code = this.trimVal(code);
            for (var i = 0; i < this.cpysList.length; i++) {
                if (this.cpysList[i].code == code) return this.cpysList[i].name;
            }
            return "";
        },

        selectCpys: function (code) {
            this.editDialog.cpysCode = this.trimVal(code);
            this.editDialog.cpysName = this.getCpysName(code);
        },

        getCphValue: function (row) {
            row = row || {};
            return this.trimVal(row.cph);
        },

        validatePlate: function (plate, color) {
            plate = this.trimVal(plate).toUpperCase();
            if (!plate) return true;
            var province = "京津沪渝冀晋蒙辽吉黑苏浙皖闽赣鲁豫鄂湘粤桂琼川贵云藏陕甘青宁新港澳台";
            var regular = new RegExp("^[" + province + "][A-Z][A-Z0-9]{4}[A-Z0-9挂学警港澳领]$");
            var newEnergy = new RegExp("^[" + province + "][A-Z][A-Z0-9]{6}$");
            color = this.trimVal(color);
            if (color === "3") return newEnergy.test(plate);
            if (color === "1" || color === "2") return regular.test(plate);
            return regular.test(plate) || newEnergy.test(plate);
        },

        getDjxhValue: function (row) {
            row = row || {};
            return this.trimVal(row.djxh);
        },

        getBgdhgbhValue: function (row) {
            row = row || {};
            var bgdhgbh = this.trimVal(row.bgdhgbh);
            if (bgdhgbh && bgdhgbh.indexOf("<") >= 0) {
                bgdhgbh = this.trimVal($("<div>").html(bgdhgbh).text());
            }
            return bgdhgbh;
        },

        onCphInput: function () {
            var cph = this.trimVal(this.editDialog.cph).toUpperCase();
            this.editDialog.cph = cph.length > 8 ? cph.slice(0, 8) : cph;
        },

        toggleCphKeyboard: function () {
            if (this.cphKeyboardTimer) {
                clearTimeout(this.cphKeyboardTimer);
                this.cphKeyboardTimer = null;
            }
            this.editDialog.cphKeyboardShow = !this.editDialog.cphKeyboardShow;
            if (this.editDialog.cphKeyboardShow) {
                this.bindCphKeyboardOutside();
            } else {
                this.unbindCphKeyboardOutside();
            }
        },

        showCphKeyboard: function () {
            if (this.cphKeyboardTimer) {
                clearTimeout(this.cphKeyboardTimer);
                this.cphKeyboardTimer = null;
            }
            this.editDialog.cphKeyboardShow = true;
            this.bindCphKeyboardOutside();
        },

        hideCphKeyboard: function () {
            var self = this;
            if (self.cphKeyboardTimer) {
                clearTimeout(self.cphKeyboardTimer);
            }
            self.cphKeyboardTimer = setTimeout(function () {
                self.editDialog.cphKeyboardShow = false;
                self.cphKeyboardTimer = null;
                self.unbindCphKeyboardOutside();
            }, 200);
        },

        bindCphKeyboardOutside: function () {
            var self = this;
            $(document).off("mousedown.ckllzhglCphKeyboard").on("mousedown.ckllzhglCphKeyboard", function (e) {
                if ($(e.target).closest(".ckllzhgl .ckllzhgl-cph-select").length > 0) return;
                if (self.cphKeyboardTimer) {
                    clearTimeout(self.cphKeyboardTimer);
                    self.cphKeyboardTimer = null;
                }
                self.editDialog.cphKeyboardShow = false;
                self.unbindCphKeyboardOutside();
            });
        },

        unbindCphKeyboardOutside: function () {
            $(document).off("mousedown.ckllzhglCphKeyboard");
        },

        getCphInputEl: function () {
            return $(".ckllzhgl .ckllzhgl-cph-select input")[0];
        },

        getCphCursorRange: function (cph) {
            var input = this.getCphInputEl();
            var len = cph.length;
            var start = len;
            var end = len;
            if (input && typeof input.selectionStart === "number") {
                start = input.selectionStart;
                end = input.selectionEnd;
            }
            start = Math.max(0, Math.min(start, len));
            end = Math.max(start, Math.min(end, len));
            return { start: start, end: end };
        },

        setCphCursor: function (pos) {
            var input = this.getCphInputEl();
            if (!input || typeof input.setSelectionRange !== "function") return;
            setTimeout(function () {
                input.focus();
                input.setSelectionRange(pos, pos);
            }, 0);
        },

        appendCphChar: function (key) {
            if (this.cphKeyboardTimer) {
                clearTimeout(this.cphKeyboardTimer);
                this.cphKeyboardTimer = null;
            }
            var cph = this.trimVal(this.editDialog.cph);
            var range = this.getCphCursorRange(cph);
            if (cph.length - (range.end - range.start) >= 8) return;
            this.editDialog.cph = cph.slice(0, range.start) + key + cph.slice(range.end);
            this.setCphCursor(range.start + ("" + key).length);
            this.editDialog.cphKeyboardShow = true;
            this.bindCphKeyboardOutside();
        },

        deleteCphChar: function () {
            if (this.cphKeyboardTimer) {
                clearTimeout(this.cphKeyboardTimer);
                this.cphKeyboardTimer = null;
            }
            var cph = this.trimVal(this.editDialog.cph);
            var range = this.getCphCursorRange(cph);
            if (range.start !== range.end) {
                this.editDialog.cph = cph.slice(0, range.start) + cph.slice(range.end);
                this.setCphCursor(range.start);
            } else if (range.start > 0) {
                this.editDialog.cph = cph.slice(0, range.start - 1) + cph.slice(range.start);
                this.setCphCursor(range.start - 1);
            }
            this.editDialog.cphKeyboardShow = true;
            this.bindCphKeyboardOutside();
        },

        clearCph: function () {
            if (this.cphKeyboardTimer) {
                clearTimeout(this.cphKeyboardTimer);
                this.cphKeyboardTimer = null;
            }
            this.editDialog.cph = "";
            this.editDialog.cphKeyboardShow = true;
            this.bindCphKeyboardOutside();
        },

        openLogisticsDialog: function (rowid) {
            var row = this.getRawRow(rowid);
            var cph = this.getCphValue(row);
            this.editDialog = {
                currentRow: row,
                djxh: this.getDjxhValue(row),
                bgdhgbh: this.getBgdhgbhValue(row),
                cph: cph,
                cphKeyboardShow: false,
                cpysCode: this.trimVal(row.cpysCode || row.cpysDm || row.cpysdm) || "2",
                cpysName: this.trimVal(row.cpysName || row.cpysMc || row.cpysmc),
                qyrq: this.trimVal(row.qyrq),
                qyd: this.trimVal(row.qyd)
            };
            this.qrDialog.qrBase = "";
            this.qrDialog.emptyText = "正在检查物流查询信息...";
            this.qrDialog.qrImgError = false;
            if (!this.editDialog.cpysName && this.editDialog.cpysCode) {
                this.editDialog.cpysName = this.getCpysName(this.editDialog.cpysCode);
            }
            $('.model').show();
            $('.ckllzhgl .ckllzhgl-logistics-model').show();
            setTimeout(function () {
                $('.ckllzhgl .ckllzhgl-logistics-model .datepicker.date-day').datetimepicker({
                    language: "zh-CN",
                    format: "yyyy-mm-dd",
                    autoclose: true,
                    clearBtn: true,
                    startView: 2,
                    minView: 2
                });
            }, 0);
            this.queryLogisticsByDialog();
        },

        closeLogisticsDialog: function () {
            this.editDialog = {
                currentRow: null,
                djxh: "",
                bgdhgbh: "",
                cph: "",
                cphKeyboardShow: false,
                cpysCode: "",
                cpysName: "",
                qyrq: "",
                qyd: ""
            };
            this.qrDialog.qrBase = "";
            this.qrDialog.emptyText = "";
            this.qrDialog.qrImgError = false;
            $('.ckllzhgl .ckllzhgl-logistics-model').hide();
            $('.model').hide();
            this.unbindCphKeyboardOutside();
        },

        saveEditDialog: function () {
            var self = this;
            var data = self.editDialog;
            var cpysName = self.getCpysName(data.cpysCode);
            var row = data.currentRow || {};
            var params = {
                djxh: self.trimVal(data.djxh) || self.getDjxhValue(row),
                bgdhgbh: self.trimVal(data.bgdhgbh) || self.getBgdhgbhValue(row),
                cph: self.trimVal(data.cph).toUpperCase(),
                cpysCode: self.trimVal(data.cpysCode) || "2",
                cpysName: cpysName,
                qyrq: self.trimVal(data.qyrq),
                qyd: self.trimVal(data.qyd)
            };
            if (!params.djxh || !params.bgdhgbh) {
                tools.info("缺少登记序号或报关单号，无法保存");
                return;
            }
            params.cpysName = self.getCpysName(params.cpysCode);
            if (!self.validatePlate(params.cph, params.cpysCode)) {
                tools.info("车牌号格式不正确，请检查");
                return;
            }
            ajax("POST", "/bjtssw/yj/ckll/edit", params).done(function (res) {
                if (res.code == '0') {
                    tools.info("保存成功");
                    self.editDialog.cph = params.cph;
                    self.editDialog.cpysCode = params.cpysCode;
                    self.editDialog.cpysName = params.cpysName;
                    self.editDialog.qyrq = params.qyrq;
                    self.editDialog.qyd = params.qyd;
                    self.search($("#ckllzhgl-table").jqGrid('getGridParam', 'page') || 1);
                    self.queryLogisticsByDialog();
                } else {
                    tools.info(res.msg || "保存失败");
                }
            }).fail(function (err) {
                tools.info(err);
            });
        },

        queryLogistics: function (rowid) {
            this.openLogisticsDialog(rowid);
        },

        queryLogisticsByDialog: function () {
            var self = this;
            var miss = [];
            var data = self.editDialog;
            if (!self.trimVal(data.bgdhgbh)) miss.push("报关单号");
            if (!self.trimVal(data.cph)) miss.push("车牌号");
            if (!self.trimVal(data.qyrq)) miss.push("起运日");
            if (!self.trimVal(data.qyd)) miss.push("启运地");
            if (miss.length > 0) {
                self.qrDialog.qrBase = "";
                self.qrDialog.emptyText = "请先在左侧完善" + miss.join("、") + "信息，保存后将自动刷新二维码。";
                self.qrDialog.qrImgError = false;
                return;
            }
            ajax("POST", "/bjtssw/yj/ckll/qr", {
                djxh: self.trimVal(data.djxh),
                bgdhgbh: self.trimVal(data.bgdhgbh)
            }).done(function (res) {
                if (res.code == '0' && res.data && res.data.qrBase) {
                    self.qrDialog.qrBase = res.data.qrBase;
                    self.qrDialog.emptyText = "";
                    self.qrDialog.qrImgError = false;
                } else {
                    self.qrDialog.qrBase = "";
                    self.qrDialog.emptyText = res.msg || "物流查询二维码获取失败";
                    self.qrDialog.qrImgError = false;
                }
            }).fail(function (err) {
                self.qrDialog.qrBase = "";
                self.qrDialog.emptyText = err || "物流查询二维码获取失败";
                self.qrDialog.qrImgError = false;
            });
        },

        onQrImgLoad: function () {
            this.qrDialog.qrImgError = false;
        },

        onQrImgError: function () {
            this.qrDialog.qrBase = "";
            this.qrDialog.qrImgError = true;
            this.qrDialog.emptyText = "二维码加载失败，请点击保存后重新刷新。";
        },

        closeQrDialog: function () {
            this.closeLogisticsDialog();
        },

        // 点击报关单号，弹窗预览报关单
        previewBgd: function (ckbgdh, djxh) {
            ckbgdh = (ckbgdh == null ? '' : ('' + ckbgdh)).replace(/^\s+|\s+$/g, '');
            if (!ckbgdh) return;
            var params = { ckbgdh: ckbgdh, djxh: (djxh == null ? '' : djxh) };
            ajax("POST", "/bjtssw/sbxx/bgd/view", params).done(function (res) {
                if (res.code == '0') {
                    var inst = components['bgdDetailckllzhgl-bgd'];
                    if (inst && typeof inst.showModel === 'function') {
                        inst.showModel(res.data);
                    }
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            });
        },

        // 点击出口发票号/进货凭证号，弹窗预览发票详情
        previewFp: function (zyfpNo) {
            zyfpNo = (zyfpNo == null ? '' : ('' + zyfpNo)).replace(/^\s+|\s+$/g, '');
            if (!zyfpNo) return;
            var params = { zyfpNo: zyfpNo };
            ajax("POST", "/bjtssw/sbxx/fpxx/view", params).done(function (res) {
                if (res.code == '0') {
                    var inst = components['fpDetailckllzhgl-fp'];
                    if (inst && typeof inst.showModel === 'function') {
                        inst.showModel(res.data);
                    }
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            });
        },

        setTableOption: function () {
            var self = this;
            setTimeout(function () { self.resetTable(); }, 200);
            if (self.timer == null) {
                self.timer = setTimeout(function () {
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer = null;
                }, 2000);
            } else {
                clearTimeout(self.timer);
                self.timer = setTimeout(function () {
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer = null;
                }, 2000);
            }
        },
        updataOption: function () {
            var self = this;
            var cs = [];
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    cs.push(self.tableOption[i].name);
                }
            }
            ajax("POST", "/bjtssw/basis/columprofile/update", {
                tcode: this.tcode,
                cs: cs.join(',')
            }).done(function (res) {
                if (res.code != '0') tools.info(res.msg);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        resetTable: function () {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#ckllzhgl-table").showCol(self.tableOption[i].name);
                } else {
                    $("#ckllzhgl-table").hideCol(self.tableOption[i].name);
                }
            }
            $("#ckllzhgl-table").setGridWidth($('.ckllzhgl').width());
            self.fixOperationColumn();
        },

        search: function (pageNo) {
            var self = this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ckllzhgl')).val();
            var params = tools.clone(self.searchData);
            params.pageNo = pageNo;
            $("#ckllzhgl-table").jqGrid('clearGridData');
            ajax("POST", "/bjtssw/yj/ckll/list", params).done(function (res) {
                if (res.code == '0') {
                    self.tableData = res.data;
                    var gridData = {
                        rows: res.data.rows || [],
                        page: pageNo,
                        records: res.data.count || 0,
                        total: res.data.total || 0,
                        sumData: res.data.sumData || {}
                    };
                    $("#ckllzhgl-table").resetSelection();
                    $("#ckllzhgl-table")[0].addJSONData(gridData);
                    self.closeHyper();
                    self.fixOperationColumn();
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            });
        },

        showHyper: function () {
            $('.ckllzhgl .select-sub').toggle();
            $('.ckllzhgl .select-wrapper .icon').toggleClass("active");
            this.fixOperationColumn();
            if ($('.ckllzhgl .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
                $('.ckllzhgl .select-wrapper .icon').attr("title", "收起查询条件");
            } else {
                $('.ckllzhgl .select-wrapper .icon').attr("title", "展开查询条件");
            }
        },
        closeHyper: function () {
            $('.ckllzhgl .select-sub').hide();
            $('.ckllzhgl .select-wrapper .icon').removeClass('active');
            this.fixOperationColumn();
            $('.ckllzhgl .select-wrapper .icon').attr("title", "展开查询条件");
        },
        showMenu: function (e) {
            var self = this;
            $(".dropdown-menu", e.target).show();
            $('.ckllzhgl').on('click', function (e) {
                var e = e || window.event;
                if ($('.dropdown-menu').find($(e.target)).length <= 0) {
                    self.hideMenu();
                }
            });
        },
        hideMenu: function () {
            $(".dropdown-menu").hide();
            $('.ckllzhgl').off('click');
        },

        initTree: function () {
            var self = this;
            var setting = {
                callback: {
                    onClick: function (e, id, node) {
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                    },
                    onDblClick: function (e, id, node) {
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                    }
                },
                data: { key: { children: "item", name: "text" } }
            };
            tools.getCachedSwjg(avalonRoot, ajax).done(function (data) {
                $.fn.zTree.init($(".ckllzhgl .treeDiv"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree: function (e) {
            var self = this;
            $(".treeDiv", $(e.target).parent()).show();
            $('.ckllzhgl').on('click', function (e) {
                var e = e || window.event;
                if ($('.treeDiv').find($(e.target)).length <= 0) {
                    self.hideTree();
                }
            });
        },
        hideTree: function () {
            $(".treeDiv").hide();
            $('.ckllzhgl').off('click');
        },

        reset: function () {
            var self = this;
            var now = new Date();
            var end = self.formatDate(now);
            var startDate = new Date(now.getTime() - 30 * 24 * 3600 * 1000);
            var defSwjgDm = "", defSwjgMc = "";
            try {
                defSwjgDm = avalonRoot.user.swjgDm;
                defSwjgMc = avalonRoot.user.swjgMc;
            } catch (e) { }
            self.searchData = {
                swjgDm: defSwjgDm,
                swjgMc: defSwjgMc,
                fxdjGxrqQ: self.formatDate(startDate),
                fxdjGxrqZ: end,
                fxdjDm: "",
                fhmsDm: "1",
                ysfsDm: "2",
                tmsjsffDm: "",
                qybs: "",
                gybs: "",
                bgdhgbh: "",
                ckrqQ: "",
                ckrqZ: "",
                jzxh: "",
                cph: "",
                ckfph: "",
                orderSql: "",
                pageSize: config.pageSize
            };
        },

        exform: function () {
            var self = this;
            if ($("#ckllzhgl-table").jqGrid('getRowData').length <= 0) {
                tools.info("请先查询列表");
                return;
            }
            var params = tools.clone(self.searchData);
            var form = $("<form>");
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/yj/ckll/export");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form);
            form.append(input1);
            form.submit();
            form.remove();
        }
    }
});
