var qylxMap = {
    "" :"",
    "11": "内资生产企业",
    "12": "外商投资企业",
    "21": "外贸（工贸）企业",
    "90": "其他企业（特许退税企业）"
};
var gllbMap = {
    "":"",
    "A":"A类",
    "B":"B类",
    "C":"C类",
    "D":"D类"
};
var flagMap = {
    "0": "否",
    "1": "是"
};
avalon.filters.transfer = function (str,type) {
    if (type == "qylx") {
        return qylxMap[str];
    } else if (type == "gllb") {
        return gllbMap[str];
    } else if (type === "flag") {
        return flagMap[str];
    }
};
