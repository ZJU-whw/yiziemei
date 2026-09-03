var tools={
    DateCheup:function( date ){
        if(!date){
            return "";
        }
        var d=[],res;
        if(date.indexOf('-')>=0){
            d=date.split('-');
        }else if(date.indexOf('/')>=0){
            d=date.split('/');
        }else if(date.indexOf('.')>=0){
            d=date.split('.');
        }else if(!isNaN(date)){
            if(date.length==6){
                d[0]="20"+date.slice(0,2);
                d[1]=date.slice(2,4);
                d[2]=date.slice(4,6);
            }else if(date.length==8){
                d[0]=date.slice(0,4);
                d[1]=date.slice(4,6);
                d[2]=date.slice(6,8);
            }else{
                return false;
            }
        }
        if(d.length==3){
            if(isNaN(d[0])||isNaN(d[1])||isNaN(d[2])){
                return false;
            }
            if(d[0].length==2){
                d[0]="20"+d[0];
            }
            if(d[0].length>4){
                return false;
            }
            if(d[1].length==1){
                d[1]="0"+d[1];
            }
            if(d[1].length>2){
                return false;
            }
            if(d[2].length==1){
                d[2]="0"+d[2];
            }
            if(d[2].length>2){
                return false;
            }
            if(d[0]<1900||d[0]>2100){
                return false;
            }
            if(d[1]<1||d[1]>12){
                return false;
            }
            if(d[2]<1||d[2]>31){
                return false;
            }
            res=d[0]+"-"+d[1]+"-"+d[2];
            return res;
        }else{
            return false;
        }

    },
    MonCheup:function( date ){
        if(!date){
            return "";
        }
        var d=[],res;
        if(date.indexOf('-')>=0){
            d=date.split('-');
        }else if(date.indexOf('/')>=0){
            d=date.split('/');
        }else if(date.indexOf('.')>=0){
            d=date.split('.');
        }else if(!isNaN(date)){
            if(date.length==4){
                d[0]="20"+date.slice(0,2);
                d[1]=date.slice(2,4);
            }else if(date.length==6){
                d[0]=date.slice(0,4);
                d[1]=date.slice(4,6);
            }else{
                return false;
            }
        }
        if(d.length==2){
            if(isNaN(d[0])||isNaN(d[1])){
                return false;
            }
            if(d[0].length==2){
                d[0]="20"+d[0];
            }
            if(d[0].length>4){
                return false;
            }
            if(d[1].length==1){
                d[1]="0"+d[1];
            }
            if(d[1].length>2){
                return false;
            }
            if(d[0]<1900||d[0]>2100){
                return false;
            }
            if(d[1]<1||d[1]>12){
                return false;
            }
            res=d[0]+""+d[1];
            return res;
        }else{
            return false;
        }

    },
    checkDate: function (startTime, endTime) {
        var valid = true;
        var validDateStart = startTime;
        var validDateEnd = endTime;
        if (validDateStart.length > 0 && validDateEnd.length > 0) {
            var startDateTemp = validDateStart.substring(0,10);
            var endDateTemp = validDateEnd.substring(0,10);
            var time1 = new Date(startDateTemp.replace(/\-/g, "\/"));
            var time2 = new Date(endDateTemp.replace(/\-/g, "\/"));
            if (time1 > time2) {
                valid = false;
                return valid;
            }
        }
        return valid
    },
    Num2CN:function(money){
        //汉字的数字
        var cnNums = new Array('零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖');
        //基本单位
        var cnIntRadice = new Array('', '拾', '佰', '仟');
        //对应整数部分扩展单位
        var cnIntUnits = new Array('', '万', '亿', '兆');
        //对应小数部分单位
        var cnDecUnits = new Array('角', '分','厘', '毫' );
        //整数金额时后面跟的字符
        var cnInteger = '整';
        //整型完以后的单位
        var cnIntLast = '元';
        //最大处理的数字
        var maxNum = 999999999999999.9999;
        //金额整数部分
        var integerNum;
        //金额小数部分
        var decimalNum;
        //输出的中文金额字符串
        var chineseStr = '';
        //分离金额后用的数组，预定义
        var parts;
        if (money == '') { return '零元整'; }
        money = parseFloat(money);
        if (money >= maxNum) {
            //超出最大处理数字
            return '';
        }
        if (money == 0) {
            chineseStr = cnNums[0] + cnIntLast + cnInteger;
            return chineseStr;
        }
        //转换为字符串
        money = money.toString();
        if (money.indexOf('.') == -1) {
            integerNum = money;
            decimalNum = '';
        } else {
            parts = money.split('.');
            integerNum = parts[0];
            decimalNum = parts[1].substr(0, 4);
        }
        //获取整型部分转换
        if (parseInt(integerNum, 10) > 0) {
            var zeroCount = 0;
            var IntLen = integerNum.length;
            for (var i = 0; i < IntLen; i++) {
                var n = integerNum.substr(i, 1);
                var p = IntLen - i - 1;
                var q = p / 4;
                var m = p % 4;
                if (n == '0') {
                    zeroCount++;
                } else {
                    if (zeroCount > 0) {
                        chineseStr += cnNums[0];
                    }
                    //归零
                    zeroCount = 0;
                    chineseStr += cnNums[parseInt(n)] + cnIntRadice[m];
                }
                if (m == 0 && zeroCount < 4) {
                    chineseStr += cnIntUnits[q];
                }
            }
            chineseStr += cnIntLast;
        }
        //小数部分
        if (decimalNum != '') {
            var zeroLen=0;
            var decLen = decimalNum.length;
            for (var i = 0; i < decLen; i++) {
                var n = decimalNum.substr(i, 1);
                if (n != '0') {
                    if(zeroLen>0){
                        zeroLen=0;
                        chineseStr += cnNums[0];
                    }
                    chineseStr += cnNums[Number(n)] + cnDecUnits[i];
                }else{
                    zeroLen++;
                }
            }
        }
        if (chineseStr == '') {
            chineseStr += cnNums[0] + cnIntLast + cnInteger;
        } else if (decimalNum == '') {
            chineseStr += cnInteger;
        }
        return chineseStr;
    },
    //获取url中的参数方法
    GetQueryString: function (name) {
        var reg = new RegExp("(^|\|)" + name + "=([^\|]*)(\||$)");
        var r = window.location.hash.substring(1).match(reg);
        if (r != null) return decodeURIComponent(r[2]); return null;
    },
    //截取税务机关代码
    getPreSwjgdm:function(swjgDm){
        if (!swjgDm){
            return "";
        }
        for(;/^[0-9]+00$/.test(swjgDm);){
            swjgDm=swjgDm.slice(0,-2);
        }
        return swjgDm;
    },
    isXianju:function(swjgDm){
        var pre=this.getPreSwjgdm(swjgDm);
        if(pre.length>5){
            return true
        }else{
            return false
        }
    },
    //解决分页问题
    getPageNo:function (pgButton,tableName){
        //由于支持多表头的jqgrid版本   获取页号 getGridParam("page")和每页显示数 getGridParam("rowNum")在onPaging 存在问题,不能实时的获取。
        //获取页号
        var pageno = $('#' + tableName + 'Pager_center > table > tbody > tr > td:nth-child(4) > input').val();
        if(pgButton.indexOf('next')>=0){ //点击下一页
            pageno = parseInt(pageno) + 1;
        }else if(pgButton.indexOf('prev')>=0){ //点击上一页
            pageno = parseInt(pageno) -1;
        }else if(pgButton.indexOf('user')>=0){ //自主输入页号
            var s = ($("span#sp_1_" + tableName + "Pager").text());
            var lastPageno = s.split(',').join('').replace(/[\t|\s]/g, '');
            lastPageno = parseFloat(lastPageno) || 0;
            pageno = parseFloat(pageno) || 0;
            if(pageno<1 || pageno>lastPageno) pageno = 1;
            pageno = pageno ;
        }else if(pgButton.indexOf('last')>=0){ //  最后一页
            var s = ($("span#sp_1_"+tableName+"Pager").text());
            pageno = s.split(',').join('').replace(/[\s|\t]/g, '');
        }else if(pgButton.indexOf('first')>=0){ //首页
            pageno = 1 ;
        }else if(pgButton.indexOf('records')>=0){ //改变每页显示行数，pageno 变为1
            pageno = 1 ;
        }
        if (typeof pageno === "string") {
            pageno = pageno.replace(/\s/g,"");
        }
        return pageno;
    },
    getPageNo2:function (pgButton,tableName){
        //由于支持多表头的jqgrid版本   获取页号 getGridParam("page")和每页显示数 getGridParam("rowNum")在onPaging 存在问题,不能实时的获取。
        //获取页号
        var pageno = $('#' + tableName + '_center > table > tbody > tr > td:nth-child(4) > input').val();
        if(pgButton.indexOf('next')>=0){ //点击下一页
            pageno = parseInt(pageno) + 1;
        }else if(pgButton.indexOf('prev')>=0){ //点击上一页
            pageno = parseInt(pageno) -1;
        }else if(pgButton.indexOf('user')>=0){ //自主输入页号（含非数字时回退到第 1 页）
            var s = ($("span#sp_1_" + tableName).text());
            var lastPageno = s.split(',').join('').replace(/[\t|\s]/g, '');
            lastPageno = parseFloat(lastPageno) || 0;
            pageno = parseFloat(pageno) || 0;
            if(pageno<1 || pageno>lastPageno) pageno = 1;
        }else if(pgButton.indexOf('last')>=0){ //  最后一页
            var s = ($("span#sp_1_"+tableName).text());
            pageno = s.split(',').join('');
        }else if(pgButton.indexOf('first')>=0){ //首页
            pageno = 1 ;
        }else if(pgButton.indexOf('records')>=0){ //改变每页显示行数，pageno 变为1
            pageno = 1 ;
        }
        if (typeof pageno === "string") {
            pageno = pageno.replace(/\s/g,"");
        }
        return pageno;
    },
    toDecimal2 : function(x) {
        if(x>=0){
            var f = parseFloat(x);
            if (isNaN(f)) {
                return false;
            }
            var f = Math.round(parseInt(x*1000)/10)/100;
            var s = f.toString();
            var rs = s.indexOf('.');
            if (rs < 0) {
                rs = s.length;
                s += '.';
            }
            while (s.length <= rs + 2) {
                s += '0';
            }
            return s;
        }
        else if(x<0){
            return -this.toDecimal2(-x);
        }
    },
    info:function(text,fun){
        if(typeof text !='string'){
            console.log(text);
        }else {
            $.dialog({
                title: "提示",
                content: text,
                okValue: "确定",
                lock:true,
                ok: fun?fun:function () {

                }
            })
        }
    },
    success:function(text){
        if(typeof text !='string'){
            console.log(text);
        }else {
            $.dialog({
                title:"2秒后自动关闭",
                time: 2000,
                content:text
            });
        }
    },
    confirm:function(text, okVal,ok, cancel,cancelVal){
        if(typeof text !='string'||typeof okVal !='string'){
            console.log(text);
        }else {
            $.dialog({
                title: "提示",
                content: text,
                okValue: okVal,
                lock:true,
                ok: ok,
                cancelValue: cancelVal||'取消',
                cancel:cancel?cancel:function(){

                }
            })
        }
    },
    infoList:function(arr, okVal,ok, cancel,cancelVal){
        if(!arr||arr.length<=0){
           console.log(arr)
            return false;
        }else {
            var text="<table>";
            text+="<tr><th>序号</th><th>报表代码</th><th>检测类型</th><th>提示内容</th><th>错误类型</th></tr>"
            for(var i=0;i<arr.length;i++){
                text+="<tr>"
                text+="<td style='text-align: center'>"+(i+1)+"</td>";
                text+="<td title='"+arr[i].msg+"'>"+arr[i].bbdm+"</td>";
                text+="<td style='text-align: center'>"+(arr[i].msgType=="1"?"表内关系检测":"表间关系检测")+"</td>";
                text+="<td title='"+arr[i].msg+"'>"+arr[i].msg+"</td>";
                text+="<td style='text-align: center'>"+(arr[i].msgLevel=="1"?"错误":"提示")+"</td>";
                text+="</tr>"
            }
            text+="</table>"
            return $.dialog({
                title: "提示",
                padding: 0,
                content: text,
                okValue: okVal,
                lock:true,
                ok: ok,
                cancelValue: cancelVal||'取消',
                cancel:cancel?cancel:function(){

                }
            })
        }
    },
    getTodayYM:function(date){
        var date= date || new Date();
        var y=date.getFullYear();
        var m=date.getMonth()+1;
        if(m<10){
            m="0"+m;
        }
        return y.toString()+m.toString();
    },
    getFirstMounth:function(date){
        var date= date || new Date();
        var y=date.getFullYear();
        return y+"01";
    },
    getToday:function(date){
        var date= date || new Date();
        var y=date.getFullYear();
        var m=date.getMonth()+1;
        if(m<10){
            m="0"+m;
        }
        var d=date.getDate();
        if(d<10){
            d="0"+d;
        }
        return y+"-"+m+"-"+d;
    },
    getPreviousDay:function() {
        const date = new Date(); // 获取当前时间
        date.setDate(date.getDate() - 1); // 设置为前一天

        const year = date.getFullYear(); // 获取年份，如 2025
        const month = String(date.getMonth() + 1).padStart(2, '0'); // 获取月份，从 0 开始，所以要 +1，并用 padStart 补零
        const day = String(date.getDate()).padStart(2, '0'); // 获取日期，并补零

        return `${year}-${month}-${day}`;
    },
    getFirstDayOfYear:function(date){
        const now = new Date(); // 获取当前日期
        const year = now.getFullYear(); // 获取当前年份
        const firstDay = new Date(year, 0, 1); // 创建当年的第一天（月份从0开始，0表示1月）

        // 格式化为 YYYY-MM-DD
        const yearStr = firstDay.getFullYear();
        const monthStr = String(firstDay.getMonth() + 1).padStart(2, '0'); // 月份+1，且补零
        const dayStr = String(firstDay.getDate()).padStart(2, '0');

        return `${yearStr}-${monthStr}-${dayStr}`;
    },
    // 获取几天后或几天前的日期
    getNextDay: function(n){
        n = Number(n)? n: 0;
        var endDate = new Date(new Date().getTime() + n * 24 * 60 * 60 * 1000)
        return tools.getToday(endDate);
    },
    // 获取多少月前的日期
    getFontMonths: function(months, date){
        var date= date || new Date();
        date = new Date(date);
        var y=date.getFullYear();
        var m=date.getMonth()+1 - months;
        if(m<1){
            m = 12 + m;
            y -= 1;
        }
        if(m<10){
            m="0"+m;
        }
        var d=date.getDate();
        if(d<10){
            d="0"+d;
        }
        var max_d = new Date(y, m, 0).getDate();
        if(d>max_d){
            d = max_d;
        }
        return y+"-"+m+"-"+d;
    },
    // 获取多少月后的日期
    getNextMonths: function(months, date){
        var date= date || new Date();
        var now = new Date();
        date = new Date(date);
        var y=date.getFullYear();
        var m=date.getMonth()+1 + months;
        if(m>12){
            m = m - 12;
            y += 1;
        }
        if(m<10){
            m="0"+m;
        }
        var d=date.getDate();
        if(d<10){
            d="0"+d;
        }
        var max_d = new Date(y, m, 0).getDate();
        if(new Date(y, m, 0).getFullYear()==now.getFullYear() && new Date(y, m, 0).getMonth()==now.getMonth() && d>now.getDate()){
            d = now.getDate();
        } else if(d>max_d){
            d = max_d;
        }
        if(new Date(y+"-"+m+"-"+d).getTime()>now.getTime()){
            return tools.getToday()
        }

        return y+"-"+m+"-"+d;
    },
    getPrevMonth:function(time){
        var date= time?new Date(time):new Date();
        var y=date.getFullYear();
        var m=date.getMonth();
        if(m==0){
            m="12"
            y-=1;
        }else if(m<10){
            m="0"+m;
        }
        return y+""+m
    },
    getMonth:function(time, symbol){
        var date= time?new Date(time):new Date();
        symbol = symbol || '';
        var y=date.getFullYear();
        var m=date.getMonth()+1;
        if(m<10){
            m="0"+m;
        }
        return y+symbol+m
    },
    getMonthFormat:function(symbol){
        symbol = symbol || '';
        var date= new Date();
        var y=date.getFullYear();
        var m=date.getMonth()+1;
        if(m<10){
            m="0"+m;
        }
        return y+symbol+m
    },
    getMonStart:function(time){
        var date= time?new Date(time):new Date();
        var y=date.getFullYear();
        var m=date.getMonth()+1;
        if(m<10){
            m="0"+m;
        }
        var d="01"
        return y+"-"+m+"-"+d;
    },
    // 获取月份最后一天
    getMonthLast: function(time) {
        var date= time?new Date(time):new Date();
        var y=date.getFullYear();
        var currentMonth = date.getMonth()
        var nextMonth = ++currentMonth
        var nextMonthFirstDay = new Date(date.getFullYear(), nextMonth, 1)  // 下个月的第一天
        var oneDay = 1000*60*60*24
        var lastTime = new Date(nextMonthFirstDay - oneDay) // 下个月的第一天减去一天，就是上个月的最后一天
        var month = parseInt(lastTime.getMonth() + 1)
        if (month < 10) {
            month="0"+month;
        }
        var day = lastTime.getDate()
        if (day < 10) {
            day = '0' + day
        }
        return y + '-' +month + '-' + day
    },
    getYearStart:function(){
        var date= new Date();
        var y=date.getFullYear();
        return y+"-01-01";
    },
    getDateStr:function(AddDayCount) {
        var date = new Date();
        date.setDate(date.getDate()+AddDayCount);//获取AddDayCount天后的日期
        var y = date.getFullYear();
        var m = date.getMonth()+1;//获取当前月份的日期
        var d = date.getDate();
        if(m<10){
            m="0"+m;
        }
        if(d<10){
            d="0"+d;
        }
        return y+"-"+m+"-"+d;
    },
    getScrollBarWidth:function(){
        var el = document.createElement("p"),
            styles = {
                width: "100px",
                height: "100px",
                overflowY: "scroll"
            },
            i;
        for (i in styles) {
            el.style[i] = styles[i];
        }


        document.body.appendChild(el);

        var scrollBarWidth = el.offsetWidth - el.clientWidth;

        $(el).remove();
        return scrollBarWidth;
    },
    // 获得某季度的开始日期
    getQuarterStartDate: function(paraYear, paraSeason) {
        switch(paraSeason) {
            case '1': return paraYear+'-01-01';
            case '2': return paraYear+'-04-01';
            case '3': return paraYear+'-07-01';
            case '4': return paraYear+'-10-01';
        }
    },
    // 获得某季度的结束日期
    getQuarterEndDate: function(paraYear, paraSeason) {
        switch(paraSeason) {
            case '1': return paraYear+'-03-31';
            case '2': return paraYear+'-06-30';
            case '3': return paraYear+'-09-30';
            case '4': return paraYear+'-12-31';
        }
    }
    ,
    // 操作栏靠右，有多选框的情况使用
    HeiKj: function (clas,id) {
        $('.'+clas+' #'+id+'_op2').css('width', '0px');
        $($('.'+clas+' #'+id+' .jqgfirstrow td')[2]).css('width', '0px');
        $('.'+clas+' #'+id+' td[aria-describedby="'+id+'_op2"]').html("");
        $('.'+clas+' .frozen-bdiv .jqgrid-rownum').css('visibility', "hidden");
        $('.'+clas+' .frozen-div #'+id+'_op2').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 30 + 'px');
        $('.'+clas+' .frozen-bdiv tr td:last-child').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 30 + 'px');
        $('.'+clas+' .frozen-bdiv').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() + 13 + 'px');

        $('.'+clas+' #'+id+'_r').css('visibility', "hidden");
        var w = $('.'+clas+' .ui-jqgrid-bdiv').width() - $('.'+clas+' #'+id).width();
        if(w<0) w=-1;
        if ($('.'+clas+' .ui-jqgrid-bdiv').height() > $('.'+clas+' .ui-jqgrid-bdiv > div').height()) {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', w+'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', w+'px');
            }, 200)
        } else {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 +w+'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 + w + 'px');
            }, 200)
        }
        $('.'+clas+' .frozen-div').css('left', "auto").css('right', '0');
        $($('.'+clas+' .frozen-bdiv #'+id+'_frozen .jqgfirstrow td')[1]).css('width', '0px');
        $('.'+clas+' .frozen-div #jqgh_'+id+'_cb').html('')
        $('.frozen-div #'+id+'_rn').remove()
    },

    // 操作栏靠右，有多选框的情况使用 - 新版单证核查特殊处理
    HeiKjNewDzhc: function (clas,id) {
        $('.'+clas+' #'+id+'_op2').css('width', '0px');
        $($('.'+clas+' #'+id+' .jqgfirstrow td')[2]).css('width', '0px');
        $('.'+clas+' #'+id+' td[aria-describedby="'+id+'_op2"]').html("");
        $('.'+clas+' .frozen-bdiv .jqgrid-rownum').css('visibility', "hidden");
        $('.'+clas+' .frozen-div #'+id+'_op2').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 30 + 'px');
        $('.'+clas+' .frozen-bdiv tr td:last-child').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 30 + 'px');
        $('.'+clas+' .frozen-bdiv').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() + 13 + 'px');

        $('.'+clas+' #'+id+'_r').css('visibility', "hidden");
        var w = $('.'+clas+' .ui-jqgrid-bdiv').width() - $('.'+clas+' #'+id).width();
        if(w<0) w=-1;
        if ($('.'+clas+' .ui-jqgrid-bdiv').height() > $('.'+clas+' .ui-jqgrid-bdiv > div').height()) {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', w+'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', w+'px');
            }, 200)
        } else {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 + w + 'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 + w + 'px');
            }, 200)
        }
        $('.'+clas+' .frozen-div').css('left', "auto").css('right', '0');
        $($('.'+clas+' .frozen-bdiv #'+id+'_frozen .jqgfirstrow td')[1]).css('width', '0px');
        $('.'+clas+' .frozen-div #jqgh_'+id+'_cb').html('')
        $('.frozen-div #'+id+'_rn').remove()
    },
    // 操作栏靠右，无多选框的情况使用
    HeiKjNoSel: function (clas,id) {
        $('.'+clas+' #'+id+'_op2').css('width', '0px').css('border-left', '1px solid #ddd').css('border-right', 'none');
        $($('.'+clas+' #'+id+' .jqgfirstrow td')[1]).css('width', '0px');
        $('.'+clas+' #'+id+' td[aria-describedby="'+id+'_op2"]').html("");
        $('.'+clas+' #'+id+' td[aria-describedby="'+id+'_op2"]').css('border-right', 'none');
        $('.'+clas+' .frozen-bdiv .jqgrid-rownum').css('visibility', "hidden");
        $('.'+clas+' .frozen-div #'+id+'_op2').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 40 + 'px');
        $('.'+clas+' .frozen-bdiv tr td:last-child').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 30 + 'px');
        $('.'+clas+' .frozen-bdiv').css('width', $('.'+clas+' #jqgh_'+id+'_op').width() - 17 + 'px');

        $('.'+clas+' #'+id+'_r').css('visibility', "hidden");
        var w = $('.'+clas+' .ui-jqgrid-bdiv').width() - $('.'+clas+' #'+id).width();
        if(w<0) w=-1;
        if ($('.'+clas+' .ui-jqgrid-bdiv').height() > $('.'+clas+' .ui-jqgrid-bdiv > div').height()) {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', w+'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', w+'px');
            }, 200)
        } else {
            $('.'+clas+' .frozen-bdiv').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 + w + 'px');
            setTimeout(function(){
                $('.'+clas+' .frozen-div').css('left', "auto").css('right', tools.getScrollBarWidth() - 2 + w + 'px');
            }, 200)
        }
        $('.'+clas+' .frozen-div').css('left', "auto").css('right', '0');
        $($('.'+clas+' .frozen-bdiv #'+id+'_frozen .jqgfirstrow td')[0]).css('width', '0px');
        $('.'+clas+' .frozen-div #jqgh_'+id+'_cb').html('')
        $('.frozen-div #'+id+'_rn').remove()
    },
    yydj:function(){
        $.dialog({
            title: "提示",
            content: "<p style='line-height: 24px;'>您当前使用的是体验版本，不支持此功能。如有使用意向或了解详情，请留下您的联系方式,稍后会有客服人员主动与您联系。</p>"+
                    "<p style='line-height: 24px;text-align: center;'>联系人姓名: <input type='text' class='width-m' id='yydj-user'></p>"+
                    "<p style='line-height: 24px;text-align: center;'>联系人电话: <input type='text' class='width-m' id='yydj-phone'></p>",
            okValue: "提交",
            ok: function(){
                var user=$('#yydj-user').val();
                var phone=$('#yydj-phone').val();
                if(!user||!phone){
                    tools.info("联系人信息不能为空！")
                    return false;
                }else{
                    ajax("POST","/dzfp/vip/book",{name:user,phone:phone}).done(function(res){
                        if(res.code!='0'){
                            tools.info(res.msg)
                        }
                    }).fail(function(err){
                        tools.info(err);
                    })
                }
            },
            cancelValue: '取消',
            cancel:function(){

            }
        })
    },
    clone:function (data) {
        var self=this;
        if(data.$model){
            return data.$model
        }
        var copyData =  Array.isArray(data)? [] : {};
        if(avalon&&avalon.mix){
            return avalon.mix(true, copyData, data)
        }
        for (var val in data) {
            if (data.hasOwnProperty(val)) {
                if(data[val]==null){
                    copyData[val]=null
                }else if (typeof(data[val]) === "object") {
                    copyData[val] = self.clone(data[val]);
                } else {
                    copyData[val] = data[val];
                }
            }
        }
        return copyData;
    },
    go:function(url){
        var param = {};
        param["funcNo"] = "go";
        param["title"] = "电子发票平台";
        param["url"] = url.indexOf("http")>=0?url:'https://yun.hzztsoft.com'+url;
        param["refresh"] = true;
        var str = JSON.stringify(param);

        var data_div = document.createElement('div');
        data_div.innerHTML = str;
        data_div.setAttribute('id', 'zt_callshell');
        document.body.appendChild(data_div);
        data_div.click();

        var r = JSON.parse(data_div.innerHTML);
        document.body.removeChild(data_div);

        if (r.retCode && r.retCode == "000") {

        } else {
            window.open(param.url);
        }
    },
    cachedSwjg: {},
    getCachedSwjg: function(avalonRoot,ajax) {
        var self = this;
        var swjgDm = avalonRoot.user.swjgDm;
        var P = $.Deferred();
        if (swjgDm in this.cachedSwjg) {
            P.resolve(this.cachedSwjg[swjgDm]);
        } else {
            ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    self.cachedSwjg[swjgDm] = res.data;
                    P.resolve(res.data);
                }else{
                    P.reject(res.msg);
                }
            }).fail(function(err){
                P.reject(err);
            })
        }
        return P.promise();
    },
    //税务机关树为4级
    getCachedSwjg4J: function(avalonRoot,ajax) {
        var self = this;
        var swjgDm = avalonRoot.user.swjgDm;
        var P = $.Deferred();
        if (swjgDm in this.cachedSwjg) {
            P.resolve(this.cachedSwjg[swjgDm]);
        } else {
            ajax("POST","/cxfw/export/readtree",{}).done(function(res){
                if(res.code=='0'){
                    self.cachedSwjg[swjgDm] = res.data;
                    P.resolve(res.data);
                }else{
                    P.reject(res.msg);
                }
            }).fail(function(err){
                P.reject(err);
            })
        }
        return P.promise();
    },
    // 版本号比较，用于比较3.0.0.6和12.0.0.6
    checkVersion: function (currentVersion, needVersion) {
        var currentList = currentVersion.split('.');
        var needList = needVersion.split('.');
        var len = currentList.length > needList.length ? needList.length : currentList.length;
        for (var i = 0; i < len; i++) {
            if (currentList[i] != needList[i]) {
                return parseInt(currentList[i]) >= parseInt(needList[i])
            }
        }
        return true
    },
	//fomrName表单的名称，fields表单域的配置集合、结构为数组，[{name:"hgdm",rules:"max_length[10]",message:"最大长度为10"}]
	validate: function(formName,fields) {
		var ruleRegex = /^(.+?)\[(.+)\]$/;
    	var validator = new FormValidator(formName,fields);
    	var method,parts,methods,messages;
    	for (var i=0;i< fields.length;i++) {
    		 methods= fields[i].rules.split("|");
    		 messages = fields[i].message.split("|");
    		//rules类似于max_length[5],其中max_length是method,5是传参
            for (var j= 0;j < methods.length;j++) {
                parts = ruleRegex.exec(methods[j]);
                if (parts) {
                    method = parts[1];
                } else {
                    method = methods[j];
                }
                //为每个表单域定制错误提示信息
                validator.setMessage(fields[i].name + "." + method,messages[j]);
            }
	    }
		validator._validateForm();
    	if (validator.errors.length == 0) {
    		return true;
	    } else {
    		tools.info(validator.errors[0].message);
    		return false;
	    }
	},
    isBroswer: function () {//检测浏览器内核--返回的是两个key，name：浏览器内核的名称---version：浏览器的版本号
        var _broswer = {};
        var sUserAgent = navigator.userAgent;
        var isOpera = sUserAgent.indexOf("Opera") > -1;
        if (isOpera) {
            //首先检测Opera是否进行了伪装
            if (navigator.appName == 'Opera') {
                //如果没有进行伪装，则直接后去版本号
                _broswer.version = parseFloat(navigator.appVersion);
            } else {
                var reOperaVersion = new RegExp("Opera (\\d+.\\d+)");
                //使用正则表达式的test方法测试并将版本号保存在RegExp.$1中
                reOperaVersion.test(sUserAgent);
                _broswer.version = parseFloat(RegExp['$1']);
            }
            _broswer.opera = true;
            _broswer.name = 'opera';
        }
        var isChrome = sUserAgent.indexOf("Chrome") > -1;
        if (isChrome) {
            var reChorme = new RegExp("Chrome/(\\d+\\.\\d+(?:\\.\\d+\\.\\d+))?");
            reChorme.test(sUserAgent);
            _broswer.version = parseFloat(RegExp['$1']);
            _broswer.chrome = true;
            _broswer.name = 'chrome';
        }
        //排除Chrome信息，因为在Chrome的user-agent字符串中会出现Konqueror/Safari的关键字
        var isKHTML = (sUserAgent.indexOf("KHTML") > -1
            || sUserAgent.indexOf("Konqueror") > -1 || sUserAgent
                .indexOf("AppleWebKit") > -1)
            && !isChrome;
        if (isKHTML) {//判断是否基于KHTML，如果时的话在继续判断属于何种KHTML浏览器
            var isSafari = sUserAgent.indexOf("AppleWebKit") > -1;
            var isKonq = sUserAgent.indexOf("Konqueror") > -1;
            if (isSafari) {
                var reAppleWebKit = new RegExp("Version/(\\d+(?:\\.\\d*)?)");
                reAppleWebKit.test(sUserAgent);
                var fAppleWebKitVersion = parseFloat(RegExp["$1"]);
                _broswer.version = parseFloat(RegExp['$1']);
                _broswer.safari = true;
                _broswer.name = 'safari';
            } else if (isKonq) {
                var reKong = new RegExp(
                    "Konqueror/(\\d+(?:\\.\\d+(?\\.\\d)?)?)");
                reKong.test(sUserAgent);
                _broswer.version = parseFloat(RegExp['$1']);
                _broswer.konqueror = true;
                _broswer.name = 'konqueror';
            }
        }
        // !isOpera 避免是由Opera伪装成的IE
        var isIE = sUserAgent.indexOf("compatible") > -1
            && sUserAgent.indexOf("MSIE") > -1 && !isOpera;
        if (isIE) {
            var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
            reIE.test(sUserAgent);
            _broswer.version = parseFloat(RegExp['$1']);
            _broswer.msie = true;
            _broswer.name = 'msie';
        }
        // 排除Chrome 及 Konqueror/Safari 的伪装
        var isMoz = sUserAgent.indexOf("Gecko") > -1 && !isChrome && !isKHTML;
        if (isMoz) {
            var reMoz = new RegExp("rv:(\\d+\\.\\d+(?:\\.\\d+)?)");
            reMoz.test(sUserAgent);
            _broswer.version = parseFloat(RegExp['$1']);
            _broswer.mozilla = true;
            _broswer.name = 'mozilla';
        }
        return _broswer;
    },
    isIE8: function () {
        var DEFAULT_VERSION = 8.0;
        var ua = navigator.userAgent.toLowerCase();
        var isIE = ua.indexOf("msie")>-1;
        var safariVersion;
        if(isIE){
            safariVersion =  ua.match(/msie ([\d.]+)/)[1];
        }
        if(safariVersion <= DEFAULT_VERSION ){
            return true
        } else {
            return false
        }
    },
    pieSelect:function(list,len){
        if(!list.length||list.length<=len){
            return list;
        }
        var list1=tools.clone(list);
        list1=list1.sort(function(a,b){return b.value-a.value});
        var list2=list1.splice(len-1);
        var total=0;
        for(var i=0;i<list2.length;i++){
            var val = isNaN(parseFloat(list2[i].value))? 0: parseFloat(list2[i].value);
            total+= val;
        }
        list1.push({name:"其他",value:total})
        return list1;
    },
    betweenYear:function(str,end){
        var str=str.replace(/\-/g, "\/");
        var end=end.replace(/\-/g, "\/");
        if(new Date(end)-new Date(str)<31536000000||new Date(end).getFullYear()==new Date(str).getFullYear()){
            return true
        }else{
            return false
        }

    },
    getVis:function(list,addV) {
        if (!list.length) {
            return [0, 0];
        }
        var list1 = tools.clone(list);
        list1 = list1.sort(function (a, b) {
            return b.value - a.value
        });
        var addVal = addV || 100;
        for (var maxVal = 0; maxVal < list1[0].value; maxVal += addVal) ;
        for (var minVal = 0; minVal < list1[list1.length-1].value; minVal += addVal) ;
        minVal-=addVal;
        return [minVal,maxVal];
    },
    decalcu:function(calStr){
        var str=calStr.trim()
        var res={
            result:"",
            signs:[],
            cells:[],
            formula:"",
        }
        var str=str.replace(/\([0-9A-Za-z\_]+\)/g,function(a,b){
            var sign=a.match(/[0-9A-Za-z\_]+/)[0];
            return "#"+sign
        })
        res.formula=str;
        var list=res.formula.split('=')||[];
        if(list.length<=0){
            return false;
        }
        if(list.length==1){
            res.result="";
            res.formula=list[0]
        }
        if(list.length==2){
            res.result=list[0].slice(1);
            res.formula=list[1]
        }
        [0].slice(1);
        res.formula=res.formula.split('=')[1]||res.formula.split('=')[0];

    },
    // base64转url
    dataURLtoBlob: function(dataurl) {
        var arr = dataurl.split(',');
        //注意base64的最后面中括号和引号是不转译的   
        var _arr = arr[1].substring(0, arr[1].length - 2);
        var mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(_arr),
            n = bstr.length,
            u8arr = new Uint8Array(n);
        while (n--) {
            u8arr[n] = bstr.charCodeAt(n);
        }
        return new Blob([u8arr], {
            type: mime
        });
    },
    // 获取文本宽高
    textSize: function(text) {
        var span = document.createElement("span");
        var result = {};
        result.width = span.offsetWidth;
        result.height = span.offsetWidth; 
        span.style.visibility = "hidden";
        document.body.appendChild(span);
        if (typeof span.textContent != "undefined")
            span.textContent = text;
        else span.innerText = text;
        result.width = span.offsetWidth - result.width;
        result.height = span.offsetHeight - result.height;
        span.parentNode.removeChild(span);
        return result;
    },
    // 导出
    exform: function(params, url){
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", url);
        var input1 = $("<input>");
        input1.attr("type", "hidden");
        input1.attr("name", "data");
        input1.attr("value", JSON.stringify(params));
        $("body").append(form); //将表单放置在web中
        form.append(input1);
        form.submit();
        form.remove();
    },
    ajaxExform: function(params, url){
        var deferred = $.Deferred();
        if (tools.getBrowserInfo()) {
            tools.exform(params, url)
            deferred.reject();
            return deferred.promise();
        }
        $('#loading').show();
        var formData = new FormData();
        formData.append('data',JSON.stringify(params))
        var xhr = new XMLHttpRequest();
        xhr.open('post', url);
        xhr.send(formData);
        xhr.responseType = 'blob'; //设置请求回来的数据为blob方式
        xhr.onreadystatechange = function() {
            var responseHeaders = 'getAllResponseHeaders' in xhr ? tools.parseHeaders(xhr.getAllResponseHeaders()) : null;
            //  响应头content-disposition存放的文件名字符串数据,
            //  格式如（Content-Disposition: attachment;filename=2022011340798353+%287%29+%281%29.pdf
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    // 数据在 this.response 保存
                    // var blob = new Blob([this.response], {
                    //     type: "application/octet-stream"
                    // });
                    var disposition = responseHeaders["content-disposition"];
                    var blob = this.response;
                    if (blob.type.indexOf('text/html')>-1) {
                        $('#loading').hide();
                        var reader = new FileReader();
                        reader.onload = function(event) {
                            //读取之后进行操作的代码区域，event.currentTarget.result 指读取到的内容
                            var data = event.currentTarget.result
                            var msgs = data.split('("')
                            msgs.splice(0,1)
                            var msg = msgs.join('')
                            msgs = msg.split('")')
                            msgs.splice(-1,1)
                            msg = msgs.join('')
                            tools.info(msg)
                        }
                        //调用方法读取
                        reader.readAsText(blob);
                        return;
                    }
                    var href = window.URL.createObjectURL(blob);
                    var fileName = disposition && decodeURI(disposition.split(";")[1].split("filename=")[1])
                    if (window.navigator.msSaveBlob) {
                        try {
                        window.navigator.msSaveBlob(blob, fileName)
                        } catch (e) {
                        console.log(e);
                        }
                    } else {
                        // 创建a链接 href链接地址 download为下载下来后文件的名称
                        var aa = document.createElement('a');
                        aa.href = href;
                        // aa.innerHTML = 'a链接';
                        aa.download = fileName;
                        aa.style.display = 'none'; //隐藏a标签 直接调用a标签的点击事件
                        document.body.appendChild(aa);
                        aa.click();
                    }
                    $('#loading').hide();
                    deferred.resolve();
                } else {
                    var code=xhr.status;
                    if(code==504||xhr.statusText.indexOf("Time-out")>=0){
                        var text="服务端处理超时，请稍后再试！"
                        tools.info(text)
                    }else{
                        text=xhr.statusText||"";
                        tools.info("网络异常，请检查网络。（错误码："+code + ":" + text +"）");
                    }
                    $('#loading').hide();
                    deferred.reject();
                }
            }
        }
        return deferred.promise()
    },
    parseHeaders: function(headers) {
        var parsed = {};
        var key;
        var val;
        var i;
        if (!headers) { return parsed; }
        tools.myForEach(headers.split('\n'), function parser(line) {
            i = line.indexOf(':');
            key = tools.trim(line.substr(0, i)).toLowerCase();
            val = tools.trim(line.substr(i + 1));

            if (key) {
                if (parsed[key] && ignoreDuplicateOf.indexOf(key) >= 0) {
                    return;
                }
                if (key === 'set-cookie') {
                    parsed[key] = (parsed[key] ? parsed[key] : []).concat([val]);
                } else {
                    parsed[key] = parsed[key] ? parsed[key] + ', ' + val : val;
                }
            }
        });

        return parsed;
    },
    myForEach: function(obj, fn) {
        if (obj === null || typeof obj === 'undefined') {
            return;
        }
        if (typeof obj !== 'object') {
            /*eslint no-param-reassign:0*/
            obj = [obj];
        }

        if (Array.isArray(obj)) {
            for (var i = 0, l = obj.length; i < l; i++) {
                fn.call(null, obj[i], i, obj);
            }
        } else {
            for (var key in obj) {
                if (Object.prototype.hasOwnProperty.call(obj, key)) {
                    fn.call(null, obj[key], key, obj);
                }
            }
        }
    },
    trim: function(str) {
        return str.replace(/^\s*/, '').replace(/\s*$/, '');
    },
    getBrowserInfo: function(){
        var agent = navigator.userAgent.toLowerCase();
        var regStr_ie = /msie [\d.]+;/gi ;
        //IE
        if(agent.indexOf("msie") > 0)
        {
          var browser = agent.match(regStr_ie);
          var verinfo = (browser+"").replace(/[^0-9.]/ig,"");
          var version = verinfo ? verinfo.split('.')[0] : 0
          if (version < 10) {
            return true
          }
        }
    },
    // 校验联系电话
    checkPhone: function(phone){
        var msg = '';
        var reg_mobile_phone = /^1[3-9]\d{9}$/;
        var reg_tel_phone = /^\d{3,4}\s*-\s*\d{7,14}$/;
        if(!(reg_mobile_phone.test(phone) || reg_tel_phone.test(phone))){
            msg = '请输入正确的联系电话：<br>1.移动电话请输入11位号码；<br>2.固定电话以“-”分隔。';
        }
        return msg
    },
    // 根据文件流下载文件
    downloadByBlob: function(pdfSrc, name){
        var pdfBlob = tools.dataURLtoBlob('data:application/pdf;base64,' + pdfSrc);
        if(navigator.msSaveBlob){
            // 使用navigator.msSaveBlo方法下载，后边跟上你的文件名和后缀
            return navigator.msSaveBlob(pdfBlob, name+'.pdf')
        }else{
            var pdfUrl = URL.createObjectURL(pdfBlob);
            // 创建一个a标签
            let a = document.createElement('a')
            // 插入到body中
            document.body.appendChild(a);
            // 隐藏a标签
            a.style.display = 'none'
            // 设置a标签href属性为刚才获取到的临时地址
            a.setAttribute('href', pdfUrl)
            // 不加download不会下载哦，后边跟上你的文件名和后缀
            a.setAttribute('download', name+'.pdf')
            // 执行下载
            a.click();
            // 释放缓存
            URL.revokeObjectURL(pdfUrl);
        }
    },
    // 判断当前操作系统是否为Windows
    // 在控制台设置 window.__forceNonWindows = true 可强制返回 false，方便调试非Windows环境
    isWindows: function(){
        if(window.__forceNonWindows === true){
            return false;
        }
        var platform = navigator.platform;
        var userAgent = navigator.userAgent;
        if(platform && (platform.indexOf('Win') > -1 || platform.indexOf('win') > -1)){
            return true;
        }
        if(userAgent && (userAgent.indexOf('Windows') > -1 || userAgent.indexOf('windows') > -1)){
            return true;
        }
        return false;
    },
    pdfOptions: function(){
        return {
            pdfOpenParams: {
              navpanes: 0,
              toolbar: 0,
              statusbar: 0,
              view: "FitV",
              pagemode: "thumbs",
              page: 1
            },
            forcePDFJS: true,
            PDFJS_URL: "../../jdgl/static/pdfjs/web/viewer.html"
        };
    },

}
var config = {
    pageSize: 20, //分页查询页面默认每页行数
    pageSizeList: [20,50,100], //分页查询页面可选每页行数
}
var staticCountry=[
    {
        "id": "YZ",
        "name": "亚洲",
        "states": [
            {
                "id": "101",
                "name": "阿富汗"
            },
            {
                "id": "102",
                "name": "巴林"
            },
            {
                "id": "103",
                "name": "孟加拉国"
            },
            {
                "id": "104",
                "name": "不丹"
            },
            {
                "id": "105",
                "name": "文莱"
            },
            {
                "id": "106",
                "name": "缅甸"
            },
            {
                "id": "107",
                "name": "柬埔寨"
            },
            {
                "id": "108",
                "name": "塞浦路斯"
            },
            {
                "id": "109",
                "name": "朝鲜"
            },
            {
                "id": "110",
                "name": "香港"
            },
            {
                "id": "111",
                "name": "印度"
            },
            {
                "id": "112",
                "name": "印度尼西亚"
            },
            {
                "id": "113",
                "name": "伊朗"
            },
            {
                "id": "114",
                "name": "伊拉克"
            },
            {
                "id": "115",
                "name": "以色列"
            },
            {
                "id": "116",
                "name": "日本"
            },
            {
                "id": "117",
                "name": "约旦"
            },
            {
                "id": "118",
                "name": "科威特"
            },
            {
                "id": "119",
                "name": "老挝"
            },
            {
                "id": "120",
                "name": "黎巴嫩"
            },
            {
                "id": "121",
                "name": "澳门"
            },
            {
                "id": "122",
                "name": "马来西亚"
            },
            {
                "id": "123",
                "name": "马尔代夫"
            },
            {
                "id": "124",
                "name": "蒙古"
            },
            {
                "id": "125",
                "name": "尼泊尔联邦民主共和国"
            },
            {
                "id": "126",
                "name": "阿曼"
            },
            {
                "id": "127",
                "name": "巴基斯坦"
            },
            {
                "id": "128",
                "name": "巴勒斯坦"
            },
            {
                "id": "129",
                "name": "菲律宾"
            },
            {
                "id": "130",
                "name": "卡塔尔"
            },
            {
                "id": "131",
                "name": "沙特阿拉伯"
            },
            {
                "id": "132",
                "name": "新加坡"
            },
            {
                "id": "133",
                "name": "韩国"
            },
            {
                "id": "134",
                "name": "斯里兰卡"
            },
            {
                "id": "135",
                "name": "叙利亚"
            },
            {
                "id": "136",
                "name": "泰国"
            },
            {
                "id": "137",
                "name": "土耳其"
            },
            {
                "id": "138",
                "name": "阿联酋"
            },
            {
                "id": "139",
                "name": "也门"
            },
            {
                "id": "141",
                "name": "越南"
            },
            {
                "id": "142",
                "name": "中国"
            },
            {
                "id": "143",
                "name": "台澎金马关税区"
            },
            {
                "id": "144",
                "name": "东帝汶"
            },
            {
                "id": "145",
                "name": "哈萨克斯坦"
            },
            {
                "id": "146",
                "name": "吉尔吉斯斯坦"
            },
            {
                "id": "147",
                "name": "塔吉克斯坦"
            },
            {
                "id": "148",
                "name": "土库曼斯坦"
            },
            {
                "id": "149",
                "name": "乌兹别克斯坦"
            },
            {
                "id": "199",
                "name": "亚洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "OZ",
        "name": "欧洲",
        "states": [
            {
                "id": "301",
                "name": "比利时"
            },
            {
                "id": "302",
                "name": "丹麦"
            },
            {
                "id": "303",
                "name": "英国"
            },
            {
                "id": "304",
                "name": "德国"
            },
            {
                "id": "305",
                "name": "法国"
            },
            {
                "id": "306",
                "name": "爱尔兰"
            },
            {
                "id": "307",
                "name": "意大利"
            },
            {
                "id": "308",
                "name": "卢森堡"
            },
            {
                "id": "309",
                "name": "荷兰"
            },
            {
                "id": "310",
                "name": "希腊"
            },
            {
                "id": "311",
                "name": "葡萄牙"
            },
            {
                "id": "312",
                "name": "西班牙"
            },
            {
                "id": "313",
                "name": "阿尔巴尼亚"
            },
            {
                "id": "314",
                "name": "安道尔"
            },
            {
                "id": "315",
                "name": "奥地利"
            },
            {
                "id": "316",
                "name": "保加利亚"
            },
            {
                "id": "318",
                "name": "芬兰"
            },
            {
                "id": "320",
                "name": "直布罗陀"
            },
            {
                "id": "321",
                "name": "匈牙利"
            },
            {
                "id": "322",
                "name": "冰岛"
            },
            {
                "id": "323",
                "name": "列支敦士登"
            },
            {
                "id": "324",
                "name": "马耳他"
            },
            {
                "id": "325",
                "name": "摩纳哥"
            },
            {
                "id": "326",
                "name": "挪威"
            },
            {
                "id": "327",
                "name": "波兰"
            },
            {
                "id": "328",
                "name": "罗马尼亚"
            },
            {
                "id": "329",
                "name": "圣马力诺"
            },
            {
                "id": "330",
                "name": "瑞典"
            },
            {
                "id": "331",
                "name": "瑞士"
            },
            {
                "id": "334",
                "name": "爱沙尼亚"
            },
            {
                "id": "335",
                "name": "拉脱维亚"
            },
            {
                "id": "336",
                "name": "立陶宛"
            },
            {
                "id": "337",
                "name": "格鲁吉亚"
            },
            {
                "id": "338",
                "name": "亚美尼亚"
            },
            {
                "id": "339",
                "name": "阿塞拜疆"
            },
            {
                "id": "340",
                "name": "白俄罗斯"
            },
            {
                "id": "341",
                "name": "哈萨克"
            },
            {
                "id": "342",
                "name": "吉尔吉斯"
            },
            {
                "id": "343",
                "name": "摩尔多瓦"
            },
            {
                "id": "344",
                "name": "俄罗斯联邦"
            },
            {
                "id": "345",
                "name": "塔吉克"
            },
            {
                "id": "346",
                "name": "土库曼"
            },
            {
                "id": "347",
                "name": "乌克兰"
            },
            {
                "id": "348",
                "name": "乌兹别克"
            },
            {
                "id": "349",
                "name": "塞尔维亚和黑山"
            },
            {
                "id": "350",
                "name": "斯洛文尼亚"
            },
            {
                "id": "351",
                "name": "克罗地亚"
            },
            {
                "id": "352",
                "name": "捷克"
            },
            {
                "id": "353",
                "name": "斯洛伐克"
            },
            {
                "id": "354",
                "name": "前南马其顿"
            },
            {
                "id": "355",
                "name": "波黑"
            },
            {
                "id": "356",
                "name": "梵蒂冈城国"
            },
            {
                "id": "357",
                "name": "法罗群岛"
            },
            {
                "id": "358",
                "name": "塞尔维亚"
            },
            {
                "id": "359",
                "name": "黑山"
            },
            {
                "id": "399",
                "name": "欧洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "FZ",
        "name": "非洲",
        "states": [
            {
                "id": "201",
                "name": "阿尔及利亚"
            },
            {
                "id": "202",
                "name": "安哥拉"
            },
            {
                "id": "203",
                "name": "贝宁"
            },
            {
                "id": "204",
                "name": "博茨瓦纳"
            },
            {
                "id": "205",
                "name": "布隆迪"
            },
            {
                "id": "206",
                "name": "喀麦隆"
            },
            {
                "id": "207",
                "name": "加那利群岛"
            },
            {
                "id": "208",
                "name": "佛得角"
            },
            {
                "id": "209",
                "name": "中非"
            },
            {
                "id": "210",
                "name": "塞卜泰(休达)"
            },
            {
                "id": "211",
                "name": "乍得"
            },
            {
                "id": "212",
                "name": "科摩罗"
            },
            {
                "id": "213",
                "name": "刚果(布)"
            },
            {
                "id": "214",
                "name": "吉布提"
            },
            {
                "id": "215",
                "name": "埃及"
            },
            {
                "id": "216",
                "name": "赤道几内亚"
            },
            {
                "id": "217",
                "name": "埃塞俄比亚"
            },
            {
                "id": "218",
                "name": "加蓬"
            },
            {
                "id": "219",
                "name": "冈比亚"
            },
            {
                "id": "220",
                "name": "加纳"
            },
            {
                "id": "221",
                "name": "几内亚"
            },
            {
                "id": "222",
                "name": "几内亚比绍"
            },
            {
                "id": "223",
                "name": "科特迪瓦"
            },
            {
                "id": "224",
                "name": "肯尼亚"
            },
            {
                "id": "225",
                "name": "利比里亚"
            },
            {
                "id": "226",
                "name": "利比亚"
            },
            {
                "id": "227",
                "name": "马达加斯加"
            },
            {
                "id": "228",
                "name": "马拉维"
            },
            {
                "id": "229",
                "name": "马里"
            },
            {
                "id": "230",
                "name": "毛里塔尼亚"
            },
            {
                "id": "231",
                "name": "毛里求斯"
            },
            {
                "id": "232",
                "name": "摩洛哥"
            },
            {
                "id": "233",
                "name": "莫桑比克"
            },
            {
                "id": "234",
                "name": "纳米比亚"
            },
            {
                "id": "235",
                "name": "尼日尔"
            },
            {
                "id": "236",
                "name": "尼日利亚"
            },
            {
                "id": "237",
                "name": "留尼汪"
            },
            {
                "id": "238",
                "name": "卢旺达"
            },
            {
                "id": "239",
                "name": "圣多美和普林西比"
            },
            {
                "id": "240",
                "name": "塞内加尔"
            },
            {
                "id": "241",
                "name": "塞舌尔"
            },
            {
                "id": "242",
                "name": "塞拉利昂"
            },
            {
                "id": "243",
                "name": "索马里"
            },
            {
                "id": "244",
                "name": "南非"
            },
            {
                "id": "245",
                "name": "西撒哈拉"
            },
            {
                "id": "246",
                "name": "苏丹"
            },
            {
                "id": "247",
                "name": "坦桑尼亚"
            },
            {
                "id": "248",
                "name": "多哥"
            },
            {
                "id": "249",
                "name": "突尼斯"
            },
            {
                "id": "250",
                "name": "乌干达"
            },
            {
                "id": "251",
                "name": "布基纳法索"
            },
            {
                "id": "252",
                "name": "刚果(金)"
            },
            {
                "id": "253",
                "name": "赞比亚"
            },
            {
                "id": "254",
                "name": "津巴布韦"
            },
            {
                "id": "255",
                "name": "莱索托"
            },
            {
                "id": "256",
                "name": "梅利利亚"
            },
            {
                "id": "257",
                "name": "斯威士兰"
            },
            {
                "id": "258",
                "name": "厄立特里亚"
            },
            {
                "id": "259",
                "name": "马约特"
            },
            {
                "id": "260",
                "name": "南苏丹共和国"
            },
            {
                "id": "299",
                "name": "非洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "DYZ",
        "name": "大洋洲",
        "states": [
            {
                "id": "601",
                "name": "澳大利亚"
            },
            {
                "id": "602",
                "name": "库克群岛"
            },
            {
                "id": "603",
                "name": "斐济"
            },
            {
                "id": "604",
                "name": "盖比群岛"
            },
            {
                "id": "605",
                "name": "马克萨斯群岛"
            },
            {
                "id": "606",
                "name": "瑙鲁"
            },
            {
                "id": "607",
                "name": "新喀里多尼亚"
            },
            {
                "id": "608",
                "name": "瓦努阿图"
            },
            {
                "id": "609",
                "name": "新西兰"
            },
            {
                "id": "610",
                "name": "诺福克岛"
            },
            {
                "id": "611",
                "name": "巴布亚新几内亚"
            },
            {
                "id": "612",
                "name": "社会群岛"
            },
            {
                "id": "613",
                "name": "所罗门群岛"
            },
            {
                "id": "614",
                "name": "汤加"
            },
            {
                "id": "615",
                "name": "土阿莫土群岛"
            },
            {
                "id": "616",
                "name": "土布艾群岛"
            },
            {
                "id": "617",
                "name": "萨摩亚"
            },
            {
                "id": "618",
                "name": "基里巴斯"
            },
            {
                "id": "619",
                "name": "图瓦卢"
            },
            {
                "id": "620",
                "name": "密克罗尼西亚联邦"
            },
            {
                "id": "621",
                "name": "马绍尔群岛"
            },
            {
                "id": "622",
                "name": "帕劳"
            },
            {
                "id": "623",
                "name": "法属波利尼西亚"
            },
            {
                "id": "625",
                "name": "瓦利斯和浮图纳"
            },
            {
                "id": "699",
                "name": "大洋洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "BMZ",
        "name": "北美洲",
        "states": [
            {
                "id": "501",
                "name": "加拿大"
            },
            {
                "id": "502",
                "name": "美国"
            },
            {
                "id": "503",
                "name": "格陵兰"
            },
            {
                "id": "504",
                "name": "百慕大"
            },
            {
                "id": "599",
                "name": "北美洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "NMZ",
        "name": "南美洲",
        "states": [
            {
                "id": "401",
                "name": "安提瓜和巴布达"
            },
            {
                "id": "402",
                "name": "阿根廷"
            },
            {
                "id": "403",
                "name": "阿鲁巴"
            },
            {
                "id": "404",
                "name": "巴哈马"
            },
            {
                "id": "405",
                "name": "巴巴多斯"
            },
            {
                "id": "406",
                "name": "伯利兹"
            },
            {
                "id": "408",
                "name": "多民族玻利维亚国"
            },
            {
                "id": "409",
                "name": "博内尔"
            },
            {
                "id": "410",
                "name": "巴西"
            },
            {
                "id": "411",
                "name": "开曼群岛"
            },
            {
                "id": "412",
                "name": "智利"
            },
            {
                "id": "413",
                "name": "哥伦比亚"
            },
            {
                "id": "414",
                "name": "多米尼克"
            },
            {
                "id": "415",
                "name": "哥斯达黎加"
            },
            {
                "id": "416",
                "name": "古巴"
            },
            {
                "id": "417",
                "name": "库腊索岛"
            },
            {
                "id": "418",
                "name": "多米尼加共和国"
            },
            {
                "id": "419",
                "name": "厄瓜多尔"
            },
            {
                "id": "420",
                "name": "法属圭亚那"
            },
            {
                "id": "421",
                "name": "格林纳达"
            },
            {
                "id": "422",
                "name": "瓜德罗普"
            },
            {
                "id": "423",
                "name": "危地马拉"
            },
            {
                "id": "424",
                "name": "圭亚那"
            },
            {
                "id": "425",
                "name": "海地"
            },
            {
                "id": "426",
                "name": "洪都拉斯"
            },
            {
                "id": "427",
                "name": "牙买加"
            },
            {
                "id": "428",
                "name": "马提尼克"
            },
            {
                "id": "429",
                "name": "墨西哥"
            },
            {
                "id": "430",
                "name": "蒙特塞拉特"
            },
            {
                "id": "431",
                "name": "尼加拉瓜"
            },
            {
                "id": "432",
                "name": "巴拿马"
            },
            {
                "id": "433",
                "name": "巴拉圭"
            },
            {
                "id": "434",
                "name": "秘鲁"
            },
            {
                "id": "435",
                "name": "波多黎各"
            },
            {
                "id": "436",
                "name": "萨巴"
            },
            {
                "id": "437",
                "name": "圣卢西亚"
            },
            {
                "id": "438",
                "name": "圣马丁岛"
            },
            {
                "id": "439",
                "name": "圣文森特和格林纳丁斯"
            },
            {
                "id": "440",
                "name": "萨尔瓦多"
            },
            {
                "id": "441",
                "name": "苏里南"
            },
            {
                "id": "442",
                "name": "特立尼达和多巴哥"
            },
            {
                "id": "443",
                "name": "特克斯和凯科斯群岛"
            },
            {
                "id": "444",
                "name": "乌拉圭"
            },
            {
                "id": "445",
                "name": "委内瑞拉"
            },
            {
                "id": "446",
                "name": "英属维尔京群岛"
            },
            {
                "id": "447",
                "name": "圣其茨和尼维斯"
            },
            {
                "id": "448",
                "name": "圣皮埃尔和密克隆"
            },
            {
                "id": "449",
                "name": "荷属安地列斯"
            },
            {
                "id": "499",
                "name": "拉丁美洲其他国家(地区)"
            }
        ]
    },
    {
        "id": "OM",
        "name": "欧盟",
        "states": [
            {
                "id": "108",
                "name": "塞浦路斯"
            },
            {
                "id": "301",
                "name": "比利时"
            },
            {
                "id": "302",
                "name": "丹麦"
            },
            {
                "id": "304",
                "name": "德国"
            },
            {
                "id": "305",
                "name": "法国"
            },
            {
                "id": "306",
                "name": "爱尔兰"
            },
            {
                "id": "307",
                "name": "意大利"
            },
            {
                "id": "308",
                "name": "卢森堡"
            },
            {
                "id": "309",
                "name": "荷兰"
            },
            {
                "id": "310",
                "name": "希腊"
            },
            {
                "id": "311",
                "name": "葡萄牙"
            },
            {
                "id": "312",
                "name": "西班牙"
            },
            {
                "id": "315",
                "name": "奥地利"
            },
            {
                "id": "316",
                "name": "保加利亚"
            },
            {
                "id": "318",
                "name": "芬兰"
            },
            {
                "id": "321",
                "name": "匈牙利"
            },
            {
                "id": "324",
                "name": "马耳他"
            },
            {
                "id": "327",
                "name": "波兰"
            },
            {
                "id": "328",
                "name": "罗马尼亚"
            },
            {
                "id": "330",
                "name": "瑞典"
            },
            {
                "id": "334",
                "name": "爱沙尼亚"
            },
            {
                "id": "335",
                "name": "拉脱维亚"
            },
            {
                "id": "336",
                "name": "立陶宛"
            },
            {
                "id": "350",
                "name": "斯洛文尼亚"
            },
            {
                "id": "351",
                "name": "克罗地亚"
            },
            {
                "id": "352",
                "name": "捷克"
            },
            {
                "id": "353",
                "name": "斯洛伐克"
            }
        ]
    },
    {
        "id": "ZD",
        "name": "中东",
        "states": [
            {
                "id": "102",
                "name": "巴林"
            },
            {
                "id": "108",
                "name": "塞浦路斯"
            },
            {
                "id": "113",
                "name": "伊朗"
            },
            {
                "id": "114",
                "name": "伊拉克"
            },
            {
                "id": "115",
                "name": "以色列"
            },
            {
                "id": "117",
                "name": "约旦"
            },
            {
                "id": "118",
                "name": "科威特"
            },
            {
                "id": "120",
                "name": "黎巴嫩"
            },
            {
                "id": "126",
                "name": "阿曼"
            },
            {
                "id": "128",
                "name": "巴勒斯坦"
            },
            {
                "id": "130",
                "name": "卡塔尔"
            },
            {
                "id": "131",
                "name": "沙特阿拉伯"
            },
            {
                "id": "135",
                "name": "叙利亚"
            },
            {
                "id": "137",
                "name": "土耳其"
            },
            {
                "id": "138",
                "name": "阿联酋"
            },
            {
                "id": "139",
                "name": "也门"
            },
            {
                "id": "215",
                "name": "埃及"
            }
        ]
    },
    {
        "id": "DM",
        "name": "东盟",
        "states": [
            {
                "id": "105",
                "name": "文莱"
            },
            {
                "id": "106",
                "name": "缅甸"
            },
            {
                "id": "107",
                "name": "柬埔寨"
            },
            {
                "id": "112",
                "name": "印度尼西亚"
            },
            {
                "id": "119",
                "name": "老挝"
            },
            {
                "id": "122",
                "name": "马来西亚"
            },
            {
                "id": "129",
                "name": "菲律宾"
            },
            {
                "id": "132",
                "name": "新加坡"
            },
            {
                "id": "136",
                "name": "泰国"
            },
            {
                "id": "141",
                "name": "越南"
            }
        ]
    },
    {
        "id": "YDYL",
        "name": "一带一路国家",
        "states": [
            {
                "id": "101",
                "name": "阿富汗"
            },
            {
                "id": "102",
                "name": "巴林"
            },
            {
                "id": "103",
                "name": "孟加拉国"
            },
            {
                "id": "104",
                "name": "不丹"
            },
            {
                "id": "105",
                "name": "文莱"
            },
            {
                "id": "106",
                "name": "缅甸"
            },
            {
                "id": "107",
                "name": "柬埔寨"
            },
            {
                "id": "111",
                "name": "印度"
            },
            {
                "id": "112",
                "name": "印度尼西亚"
            },
            {
                "id": "113",
                "name": "伊朗"
            },
            {
                "id": "114",
                "name": "伊拉克"
            },
            {
                "id": "115",
                "name": "以色列"
            },
            {
                "id": "117",
                "name": "约旦"
            },
            {
                "id": "118",
                "name": "科威特"
            },
            {
                "id": "119",
                "name": "老挝"
            },
            {
                "id": "120",
                "name": "黎巴嫩"
            },
            {
                "id": "122",
                "name": "马来西亚"
            },
            {
                "id": "123",
                "name": "马尔代夫"
            },
            {
                "id": "124",
                "name": "蒙古"
            },
            {
                "id": "125",
                "name": "尼泊尔联邦民主共和国"
            },
            {
                "id": "126",
                "name": "阿曼"
            },
            {
                "id": "127",
                "name": "巴基斯坦"
            },
            {
                "id": "128",
                "name": "巴勒斯坦"
            },
            {
                "id": "129",
                "name": "菲律宾"
            },
            {
                "id": "130",
                "name": "卡塔尔"
            },
            {
                "id": "131",
                "name": "沙特阿拉伯"
            },
            {
                "id": "132",
                "name": "新加坡"
            },
            {
                "id": "134",
                "name": "斯里兰卡"
            },
            {
                "id": "135",
                "name": "叙利亚"
            },
            {
                "id": "136",
                "name": "泰国"
            },
            {
                "id": "137",
                "name": "土耳其"
            },
            {
                "id": "138",
                "name": "阿联酋"
            },
            {
                "id": "139",
                "name": "也门"
            },
            {
                "id": "141",
                "name": "越南"
            },
            {
                "id": "144",
                "name": "东帝汶"
            },
            {
                "id": "145",
                "name": "哈萨克斯坦"
            },
            {
                "id": "146",
                "name": "吉尔吉斯斯坦"
            },
            {
                "id": "147",
                "name": "塔吉克斯坦"
            },
            {
                "id": "148",
                "name": "土库曼斯坦"
            },
            {
                "id": "149",
                "name": "乌兹别克斯坦"
            },
            {
                "id": "215",
                "name": "埃及"
            },
            {
                "id": "313",
                "name": "阿尔巴尼亚"
            },
            {
                "id": "316",
                "name": "保加利亚"
            },
            {
                "id": "321",
                "name": "匈牙利"
            },
            {
                "id": "327",
                "name": "波兰"
            },
            {
                "id": "328",
                "name": "罗马尼亚"
            },
            {
                "id": "334",
                "name": "爱沙尼亚"
            },
            {
                "id": "335",
                "name": "拉脱维亚"
            },
            {
                "id": "336",
                "name": "立陶宛"
            },
            {
                "id": "337",
                "name": "格鲁吉亚"
            },
            {
                "id": "338",
                "name": "亚美尼亚"
            },
            {
                "id": "339",
                "name": "阿塞拜疆"
            },
            {
                "id": "340",
                "name": "白俄罗斯"
            },
            {
                "id": "343",
                "name": "摩尔多瓦"
            },
            {
                "id": "344",
                "name": "俄罗斯联邦"
            },
            {
                "id": "347",
                "name": "乌克兰"
            },
            {
                "id": "350",
                "name": "斯洛文尼亚"
            },
            {
                "id": "351",
                "name": "克罗地亚"
            },
            {
                "id": "352",
                "name": "捷克"
            },
            {
                "id": "353",
                "name": "斯洛伐克"
            },
            {
                "id": "354",
                "name": "前南马其顿"
            },
            {
                "id": "355",
                "name": "波黑"
            },
            {
                "id": "358",
                "name": "塞尔维亚"
            },
            {
                "id": "359",
                "name": "黑山"
            }
        ]
    }
];