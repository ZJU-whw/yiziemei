技术栈 avalon jquery
史佳俊 2018-04-04

目录
dist：打包路径
src：源文件
├page：页面
├app.js：打包入口
├compoments：页面注册
├router.js：路由注册

static：静态资源（会自动打包）
index.html：主页面模板
webpack.config.js：webpack配置文件

### 单证核查(新)
- 新增样式文件
  + app-dzhc-new.css 新增页面的样式
  + bootstrap-extra.css  新增bootstrap的样式，避免引入bootstrap.min.css文件时样式与原有的jquery-ui.custom.css冲突
