var zyxz = require("./zyxz.html");
avalon.component("zyxz",{
    template:zyxz,
    defaults: {
        downloadHref: '',
        list: [],
        onInit:function(){
            this.getDownloadHref();
        },
        loadList: function(){
            var self = this;
            ajax("GET", this.downloadHref + "static/zyxz.json", {t: new Date().getTime()}).done(function (res) {
                if (res.code == '0') {
                    var data = res.data || [];
                    data.sort(function(a, b){
                        return (a.xh || 0) - (b.xh || 0);
                    });
                    self.list = data;
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        getDownloadHref: function(){
            var self = this;
            ajax("POST", "/dzba/file/fileDownload", {downloadType:1}).done(function (res) {
                if (res.code == '0') {
                    var href = res.data && res.data.split('static');
                    if(href && href.length>0){
                        self.downloadHref = href[0];
                        self.loadList();
                    }
                } else {
                tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        getFileUrl: function(type){
            var self = this
            ajax("POST", "/dzba/file/fileDownload", {downloadType:type}).done(function (res) {
                if (res.code == '0') {
                    // self.funDownload(res.data)
                    window.location.href = res.data
                } else {
                tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        isAbsoluteLink: function(link){
            return link && (link.indexOf('http://') === 0 || link.indexOf('https://') === 0);
        },
        getTarget: function(item){
            return item.target || '_blank';
        },
        getHref: function(item){
            if(this.isAbsoluteLink(item.link)){
                return item.link;
            }
            return this.downloadHref + item.link;
        },
        getFileName: function(link){
            if(!link) return '';
            var idx = link.lastIndexOf('/');
            return idx >= 0 ? link.substring(idx + 1) : link;
        },
        funDownload: function(content, filename) {
            // 创建隐藏的可下载链接
            var eleLink = document.createElement('a');
            eleLink.style.display = 'none';
            // 字符内容转变成blob地址
            var blob = new Blob([content]);
            eleLink.href = URL.createObjectURL(blob);
            // 触发点击
            document.body.appendChild(eleLink);
            eleLink.click();
            // 然后移除
            document.body.removeChild(eleLink);
        }
    },
})
