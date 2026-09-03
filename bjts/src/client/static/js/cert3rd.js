/**
 * 自定义封装jsonp跨域操作
 * @param url
 * @param params
 * @returns
 */
function ajaxJsonp( url , params ){
    var deferred = $.Deferred();
    $.ajax({
        type : "get", //jquey是不支持post方式跨域的
        async: false,
        data :params,
        url : url, //跨域请求的URL
        dataType : "jsonp",
        jsonp: "callback",//服务端用于接收callback调用的function名的参数
        jsonpCallback:"getMessage",
        timeout: 5000, //超时时间5秒
        success : function(result){
            deferred.resolve( result );
        },
        error: function(XMLHttpRequest, textStatus) {
            deferred.reject("与助手通讯失败，请检查助手","999")
        }

    });
    //处理非正常错误（例如网络不通、服务器已关闭等情况）
    var head = document.head || $('head')[0] || document.documentElement; // code from jquery
    var script = $(head).find('script')[0];
    script.onerror = function(evt) {
        if (script.parentNode) {
            script.parentNode.removeChild(script);
        }

        var src = script.src || '';
        var idx = src.indexOf('getMessage');
        if (idx != -1) {

            var idx2 = src.indexOf('&');
            if (idx2 == -1) {
                idx2 = src.length;
            }
            var jsonCallback = src.substring(idx + 13, idx2);
            delete window[jsonCallback];
            deferred.reject("与助手通讯失败，请检查助手","999")
        }
    };
    return deferred.promise();
}
var cert3rd={};
cert3rd.basicIO=function(params,url){
	var url=url||"https://127.0.0.1:56789";
	var params=params||{};
    var deferred = $.Deferred();
    //组合参数值
    var str = JSON.stringify(params);
    var data_div = document.createElement('div');
    data_div.innerHTML = str;
    data_div.setAttribute('id', 'zt_callshell');
    document.body.appendChild(data_div);
    data_div.click();
    var r = JSON.parse(data_div.innerHTML);
    document.body.removeChild(data_div);
    if (r.retCode && r.retCode == "000") {
      	deferred.resolve(r);
    } else if(r.retCode && r.retCode != "000") {
        deferred.resolve(r);
    } else{
        var requestObj = new Object();
        requestObj["request"] = JSON.stringify(params);
        ajaxJsonp(url,requestObj).done(function(res){
            deferred.resolve(res);
        }).fail(function(err){
            deferred.reject(err)
        })
    }
    return deferred.promise();
}


cert3rd.queryUrl=function(text){
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if(r!=null)return  decodeURIComponent(r[2]); return null;
}
cert3rd.login=function(password){
    var deferred = $.Deferred();
    //组合参数值
    var param = {};
    param["funcNo"] = "51";
    param["ct"] = "1";
    param["funcName"] = "getclienthello";
    param["pin"] = password;
    cert3rd.basicIO(param).done(function(res){
        if(res.retCode=='000'){
            var param = new Object();
            param["productCode"] = "netRefundYun";
            param["clientHello"] = escape(res.clienthello);
            ajax("POST","/auth/serverHello", param).done( function(result) {
                if (result.code == 0) { //成功，进行登录认证
                    var lastServerRandom = result.data.serverRandom;
                    //组合参数值
                    var param = {};
                    param["funcNo"] = "52";
                    param["ct"] = "1";
                    param["funcName"] = "makeclientauth";
                    param["pin"] = password;
                    param["key"] = result.data.serverPacket;
                    cert3rd.basicIO(param).done(function(res){  
                        if(res.retCode=='000'){
                            var param = new Object();
                            param["productCode"] = "netRefundYun";
                            param["clientAuthCode"] = res.clientauth;
                            param["serverRandom"] = lastServerRandom;
                            param["pin"] = password; //新增pin  likun 2017-06-19
                            ajax("POST","/auth/login/disk", param).done( function(result) {
                                if (result.code == 0) { //成功，转到首页
                                    deferred.resolve(result);
                                }
                                else { //失败
                                    deferred.reject(result.msg);
                                }

                            }).fail(function(err){
                                deferred.reject(err);
                            })
                        }else{
                            deferred.reject(res.retMessage)
                        }
                       
                    }).fail(function(err){
                        deferred.reject(err);
                    });
                }
                else { //失败
                    deferred.reject(result.msg);
                }
            }).fail(function(err){
                deferred.reject(err);
            });
        }else{
            deferred.reject(res.retMessage)
        }
    }).fail(function(err){
        deferred.reject(err)
    })
    return deferred.promise();

}

cert3rd.checkWebShell=function(){
    var param={};
    param["funcNo"] = 80;
    param["ct"] = "1";
    param["funcName"] = "getverinfo";

    var str = JSON.stringify(param);

    var data_div = document.createElement('div');
    data_div.innerHTML = str;
    data_div.setAttribute('id', 'zt_callshell');
    document.body.appendChild(data_div);
    data_div.click();

    var res = JSON.parse(data_div.innerHTML);
    document.body.removeChild(data_div);

    if(res.retCode!=undefined){
        return true;
    }else{
        return false
    }
}
//跳转
cert3rd.go=function(url,title){
    var param = {};
    param["funcNo"] = "go";
    param["title"] = title||"new page";
    param["url"] = url.indexOf('http')<0?("http://"+window.location.host+url):url;
    param["refresh"] = true;
    if(cert3rd.checkWebShell()){
        cert3rd.basicIO(param).done(function(res){
            if(res.retCode=='000'){

            }else{
                document.write(res.retMessage)
            }
        }).fail(function(err,errstate){
            document.write(err)
        })
    }else{
        window.open(param.url);
    }

}


/**
 * 客户端接口
*/
function ajaxClient(params, ishideLoading) {
    var url = 'https://127.0.0.1:51889/callshell/?app=ztyun';
    var deferred = $.Deferred();
    ajax('POST', url, params, true, true, ishideLoading).done(function (res) {
      deferred.resolve(res);
    }).fail(function (err) {
      deferred.reject(err)
    })
    return deferred.promise();
  }
var apiClient = {};
apiClient.basicIO = function (params ,isShowLoading) {
    var deferred = $.Deferred();
    ajaxClient(params, isShowLoading).done(function (res) {
        deferred.resolve(res);
    }).fail(function (err) {
        deferred.reject(err)
    })
  return deferred.promise();
}
// 获取助手版本号
apiClient.getVersion = function (ishideLoading) {
    var deferred = $.Deferred();
    var params = {
      funcNo: "100",
    };
    apiClient.basicIO(params, ishideLoading).done(function (res) {
      deferred.resolve(res);
    }).fail(function (err) {
        deferred.reject(err)
    })
    return deferred.promise();
}
// 检测版本号
apiClient.checkVersion = function (ishideLoading,version) {
    var version = version? version:'1.0.0.0';
    var deferred = $.Deferred();
    apiClient.getVersion(ishideLoading).done(function (res) {
      if (res.retCode == '000') {
        var isRightVersion = tools.checkVersion(res.version, version);
        if (isRightVersion) {
          deferred.resolve(true);
        } else {
          deferred.resolve(false);
          var updateDialog = $.dialog({
            title: "提示",
            content: '<p class="version-update">1. 当前单证助手版本为：' + res.version + '；</p>' + '<p>2. 版本过低，请先<a href="javascript: void(0);" id="clientUpdate" style="color: #1d67b3; text-decoration: underline;">升级</a>单证助手。</p>',
            okValue: '确定',
            lock: true,
            ok: function () { },
          })
          $('.version-update').css('line-height', '20px');
          $('.version-update').parent().parent().parent().parent().children().eq(2).addClass('version-update-bt');
          $('.version-update-bt .d-buttons').css('text-align', 'center')
          // 绑定升级事件
          $('#clientUpdate').on('click', function () {
            updateDialog.close();
            var params = {
              taskNo: '004',
              nsrsbh: '',
              pin: '',
            }
            apiClient.taskSchedule(params);
          });
        }
      }
    }).fail(function (err) {
        ajax("POST","/dzba/file/docViewDownload").done(function(response){
            if(response.code=='0'){
                $.dialog({
                    title: "提示",
                    content: '<p style="line-height: 20px">单证助手未启动</p>' + '<p style="line-height: 20px">1. 若未安装，请先 <a href="'+response.data+'" style="font-weight:bold;color: #2b87d0;text-decoration: underline">下载</a> 后手动安装</p>' + '<p style="line-height: 20px">2. 若已安装，请<a href="ztDocView:" style="font-weight:bold;color: #2b87d0;text-decoration: underline">启动</a>单证助手</p>',
                    okValue: '确定',
                    lock: true,
                    ok: function () { },
                })
            }else{
              tools.info(response.msg);
            }
        }).fail(function(error){
            tools.info(error);
        })
        deferred.reject(err)
    })
    return deferred.promise();
}
// 单证核查-业务出口 查看
apiClient.baywManage=function(params, isNewDzhc){
    var v = isNewDzhc? '1.0.1.0': '1.0.0.0';
    var deferred = $.Deferred();
    var param = {
        funcNo: '701',
        data: params
    }
    apiClient.checkVersion(false, v).done(function(res){
        if(res){
            apiClient.basicIO(param).done(function(res){
                deferred.resolve(res);
            })
        }
    })
    return deferred.promise();
}
// 单证核查-业务出口 查看 - 新版单证核查使用
apiClient.baywManageNew=function(params){
    var deferred = $.Deferred();
    apiClient.baywManage(params, true).done(function(res){
        deferred.resolve(res);
    })
    return deferred.promise();
}


// 立即触发一次客户端任务
// funcNo对应功能号如下
// 001 - MQ订阅信息下载
// 002 - MQ解密
// 003 - 自动更新报关单出口日期
// 004 - 自动系统更新
// 005 - 自动获取广告
// 006 - 自动票面信息采集
apiClient.taskSchedule = function (obj) {
    var deferred = $.Deferred();
    var params = {
      funcNo: obj.taskNo,
      nsrsbh: obj.nsrsbh,
      pin: obj.pin,
    };
    apiClient.basicIO(params).done(function (res) {
      deferred.resolve(res);
    })
    return deferred.promise();
}

// 从单证助手获取核查意见备注
apiClient.getRemark=function(params){
    var deferred = $.Deferred();
    var param = {
        funcNo: '702',
        data: params
    }
    apiClient.checkVersion(true).done(function(res){
        if(res){
            apiClient.basicIO(param, true).done(function(res){
                deferred.resolve(res);
            })
        }
    }).fail(function(err){
        deferred.reject(err)
    })
    return deferred.promise();
}

// 单证核查-查看登记表
apiClient.checkDzj=function(params, isNewDzhc){
    var v = isNewDzhc? '1.0.1.0': '1.0.0.9';
    var deferred = $.Deferred();
    var param = {
        funcNo: '801',
        fileName: params.fileName,
        fileUrl: params.fileUrl,
        fileStream: params.fileStream? params.fileStream: '',
        title: params.title
    }
    apiClient.checkVersion(false, v).done(function(res){
        if(res){
            apiClient.basicIO(param).done(function(res){
                deferred.resolve(res);
            })
        }
    })
    return deferred.promise();
}
// 单证核查-查看登记表 - 适用于新版单证核查
apiClient.checkDzjNew = function(params){
    var deferred = $.Deferred();
    apiClient.checkDzj(params, true).done(function(res){
        deferred.resolve(res);
    })
    return deferred.promise();
}