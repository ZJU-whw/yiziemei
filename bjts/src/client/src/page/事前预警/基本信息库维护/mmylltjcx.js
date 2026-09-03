var mmylltjcx = require("./mmylltjcx.html");
avalon.component('mmylltjcx', {
    template: mmylltjcx,
    defaults: {
        searchData: {
            orderSql: "",
            pageSize: config.pageSize
        },
        tableData: {},
        onReady: function () {
            this.getTableRow();
        },
        getTableRow: function () {
            var self = this;
            var tableArr = [
                { name: "swjgMc", label: "税务机关", index: "swjgMc", width: 200, align: "left", sortable: false },
                { name: "sbqyhs", label: "申报户数", index: "sbqyhs", width: 100, align: "right", sortable: false },
                { name: "sbywbs", label: "申报笔数", index: "sbywbs", width: 100, align: "right", sortable: false },
                { name: "mmylllMin", label: "最小值", index: "mmylllMin", width: 100, align: "right", sortable: false },
                { name: "mmylllMax", label: "最大值", index: "mmylllMax", width: 100, align: "right", sortable: false },
                { name: "mmylllMid", label: "中位数", index: "mmylllMid", width: 100, align: "right", sortable: false },
                { name: "mmylllAvg", label: "平均值", index: "mmylllAvg", width: 100, align: "right", sortable: false },
                { name: "mmylllStd", label: "标准差", index: "mmylllStd", width: 100, align: "right", sortable: false },
                { name: "mmylllYjx", label: "全局合计值", index: "mmylllYjx", width: 100, align: "right", sortable: false }
            ];
            self.createTable(tableArr);
        },
        createTable: function (arr) {
            var self = this;
            var cm = [];
            for (var i = 0; i < arr.length; i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#mmylltjcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers: true,
                pager: '#mmylltjcx-tablePager',
                shrinkToFit: true,
                width: "100%",
                autowidth: true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20, 50, 100, 500],
                height: (function () {
                    return $(".mmylltjcx .form").height() - 60;
                })(),
                onPaging: function (pgButton) {
                    var pageNo = tools.getPageNo(pgButton, "mmylltjcx-table");
                    self.search(pageNo);
                }
            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.mmylltjcx')).val();
            self.search(1);
        },
        search: function (pageNo) {
            var self = this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.mmylltjcx')).val();
            var params = tools.clone(self.searchData);
            params.pageNo = pageNo;
            $("#mmylltjcx-table").jqGrid('clearGridData');
            ajax("POST", "/bjtssw/yj/mmyll", params).done(function (res) {
                if (res.code == '0') {
                    $("#mmylltjcx-table").resetSelection();
                    $("#mmylltjcx-table")[0].addJSONData(res.data);
                    self.tableData = res.data;
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            });
        }
    }
});
