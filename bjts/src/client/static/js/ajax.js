'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var ajax = function ajax(type, url, data, async,isClient, ishideLoading) {
    if (!async) {
        async = true;
    }
    var data=data?data:{};
    var deferred = $.Deferred();

    type = type.toUpperCase();

    var requestObj;
    if (window.XMLHttpRequest) {
        requestObj = new XMLHttpRequest();
    } else {
        requestObj = new ActiveXObject();
    }
    if (type == 'GET') {
        var dataStr = ''; //数据拼接字符串
        for(var key in data){
            dataStr += key + '=' + data[key] + '&';
        }
        dataStr = dataStr.substr(0, dataStr.lastIndexOf('&'));
        url = url + '?' + dataStr;
        requestObj.open(type, url, async);
        requestObj.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        requestObj.send();
    } else if (type == 'POST') {
        requestObj.open(type, url, async);
        var contentType = isClient? "text/plain;charset=UTF-8": "application/json";
        requestObj.setRequestHeader("Content-type", contentType);
        requestObj.send(JSON.stringify(data));
    } else {
        deferred.reject('error type');
    }
    if (!ishideLoading) {
        $("#loading").show();
    }
    requestObj.onreadystatechange = function () {
        if (requestObj.readyState == 4) {
            $("#loading").hide();
            if (requestObj.status == 200) {
                var obj = requestObj.response ? requestObj.response : requestObj.responseText;
                if (typeof obj !== 'object') {
                    obj = JSON.parse(obj);
                }
                if(obj.code=='401'){
                    $.dialog({
                        title: "提示",
                        content: "您尚未登录，请先登录！",
                        okValue: "确定",
                        lock:true,
                        ok: function () {
                            window.location.href="login.html";
                        }
                    })
                }else{
                    deferred.resolve(obj);
                }
            } else {
                var code=requestObj.status;
                if(code==504||requestObj.statusText.indexOf("Time-out")>=0){
                    var text="服务端处理超时，请稍后再试！"
                    deferred.reject(text);
                }else{
                    text=requestObj.statusText||"";
                    deferred.reject("网络异常，请检查网络。（错误码："+code + ":" + text +"）");
                }

            }
        }
    };

    return deferred.promise();
};