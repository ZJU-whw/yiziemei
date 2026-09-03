var ENV = process.env.ENV || "tonlan";
var path = require("path");
var webpack =require("webpack");
var HtmlWebpackPlugin = require('html-webpack-plugin');
var CopyWebpackPlugin =require('copy-webpack-plugin');
// var CleanWebpackPlugin=require('clean-webpack-plugin')
var ExtractTextPlugin = require('extract-text-webpack-plugin');
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
// if(ENV=="test") {
//     var d_path = "./dist_test";
//     var index_src = "index-test.html";
//     var login_src="static/login-test.html";
// }else{
    var d_path = './dist';
    var index_src="index.html";
    var login_src="static/login.html";
// }
console.log(d_path);
module.exports = {
    entry: {
        app: './src/app'
    },
    output: {
        path: path.join(__dirname, d_path),
        filename: '[name].js',
    }, //页面引用的文件
    module: {
        loaders: [
            {test: /\.html$/, loader: 'html-loader'},
            {test: /\.js$/, loader: 'babel-loader'},
            {
                test:/\.css$/,
                use:ExtractTextPlugin.extract({
                    fallback:"style-loader",
                    use: "css-loader"
                })
            },
            {
                test:/\.(png|jpeg|gif|svg|jpg)$/,
                loader:'url-loader',
                options:{
                    limit:10,
                     name:'static/image/[name].[ext]'
                }
            },

        ]
    },

    plugins:[
        // new CleanWebpackPlugin(['dist']),
        new CopyWebpackPlugin([
            {
                from:path.resolve(__dirname,'static'),
                to:'static',
                ignore:['.*']
            }
        ]),
        // 自动生成html插件，如果创建多个HtmlWebpackPlugin的实例，就会生成多个页面
        new HtmlWebpackPlugin({
            filename:'index.html',
            template:index_src,
            hash:true,
            inject:true,
        }),
        new HtmlWebpackPlugin({
            filename:'login.html',
            template:login_src,
            inject:false,
        }),
        //单独打包css
        new ExtractTextPlugin("[name].css"),

        // 分析打包文件
        // new BundleAnalyzerPlugin({ analyzerPort: 8919 }),

    ]

}

