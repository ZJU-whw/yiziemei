var express = require("express");
var webpack = require("webpack");
var path = require('path');
var config = require("./webpack.config.js");
var webpackDevMiddleware = require("webpack-dev-middleware");
var webpackHotMiddleware = require('webpack-hot-middleware');
var {createProxyMiddleware} = require('http-proxy-middleware');
var staticPath = path.posix.join('/static');


var app = express();

var compiler = webpack(config);

// 为了修改html文件也能实现热加载，使用webpack插件来监听html源文件改变事件
//compiler.plugin('compilation',function(compilation){
//    compilation.plugin('html-webpack-plugin-after-emit', function (data, cb) {
//        // 发布事件
//        hotMiddleware.publish({ action: 'reload' });
//        cb();
//    })
//})
app.use(staticPath, express.static('./static'));
app.use(webpackDevMiddleware(compiler,{
    publicPatch:"./",
    quiet:true
}));

// proxy api requests
var proxyAPIs = {
    req1: ['/developer', '/dzfp', '/gdzs', '/support', '/sso', '/dzba'],
    req2: ['/bjtssw'],
    req3: ['/cxfw'],
    req4: ['/glfw'],
    req5: ['/sszj'],
    req6: ['/auth'],
    conf1: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.48:20005',
        // target:'http://80.64.64.54:20005',
        secure: false,
        changeOrigin: false,
    },
    conf2: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.154:70',
        // target:'http://80.64.64.116:20001',
        // target:'http://80.64.64.136:20001',
        secure: false,
        changeOrigin: false,
    },
    conf3: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.68:20002',
        // target:'http://80.64.64.59:20002',
        // target:'http://80.64.64.53:20002',
        // target:'http://80.64.64.154:70',
        // target:'http://80.64.64.116:20002',
        // target:'http://80.64.64.57:20002',
        // target:'http://80.64.64.82:20002',
        // target:'http://80.64.64.116:20002',
        //80.64.64.116:20002
        secure: false,
        changeOrigin: false,
    },
    conf4: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.116:20004',
        // target:'http://80.64.64.73:20004',
        // target:'http://80.64.64.121:20004',//wlt
        // target:'http://80.64.64.110:20004', //sxf
        // target:'http://80.64.64.54:20004',
        secure: false,
        changeOrigin: false,
    },
    conf5: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.116:20104',
        // target:'http://80.64.64.159:20104',
        secure: false,
        changeOrigin: false,
    },
    conf6: {
        target:'http://80.64.64.9',
        // target:'http://80.64.64.123:20006',
        // target:'http://80.64.64.154:20006',
        secure: false,
        changeOrigin: false,
    }
}
proxyAPIs.req1.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf1))
})
proxyAPIs.req2.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf2))
})
proxyAPIs.req3.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf3))
})
proxyAPIs.req4.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf4))
})
proxyAPIs.req5.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf5))
})
proxyAPIs.req6.forEach(function (route) {
    app.use(route, createProxyMiddleware(proxyAPIs.conf6))
})

app.use(webpackHotMiddleware(compiler));

app.listen(7003,function(){
    console.log('Listening at http://localhost:7003');
});