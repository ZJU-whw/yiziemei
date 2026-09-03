var gzbjq=require("./gzbjq.html");
avalon.component('gzbjq', {
	template:gzbjq,
	defaults: {
    zid: '',
    expressionMcList: [],
    expressionDmList: [],
    expressionMc: '',
    note: '',
    elList: [
      { value: ['0'], name: ['0'] },{ value: ['1'], name: ['1'] },{ value: ['2'], name: ['2'] },{ value: ['3'], name: ['3'] },{ value: ['4'], name: ['4'] },{ value: ['5'], name: ['5'] },{ value: ['6'], name: ['6'] },{ value: ['7'], name: ['7'] },{ value: ['8'], name: ['8'] },{ value: ['9'], name: ['9'] },{ value: ['.'], name: ['.'] },{ value: ['+'], name: ['+'] },{ value: ['-'], name: ['-']},{ value: ['*'], name: ['*'] },{ value: ['/'], name: ['/'] },{ value: ['='], name: ['='] },{ value: ['<>'], name: ['<>'] },{ value: ['<'], name: ['<'] },{ value: ['>'], name: ['>'] },{ value: ['<='], name: ['<='] },{ value: ['>='], name: ['>='] },{ value: ['('], name: ['('] },{ value: [')'], name: [')'] },{ value: [' NOT '], name: ['非'] },{ value: [' OR '], name: ['或者'] },{ value: [' AND '], name: ['并且'] },
      { value: [' in (',')'], name: ['在列表(',')'], label: ['在列表'] },
      { value: [' notin  (',')'], name: ['不在列表(',')'], label: ['不在列表'] },
      { value: [' like '], name: ['包含'], tips: "语法示例：包含'091%'" },{ value: [' notlike '], name: ['不包含'], tips: "语法示例：不包含'091%'" }],
    isOpen: true,
    isOpenFunc: true,
    isEdit: false,
    isShowZb: true,
    funcList: [
      { name: '常规函数', item: [
        {name: '条件函数', arrDm: ['{IF(',')',',',',','}'], arrMc: ['{条件(',')',',',',','}'], ywms: '<div>调用规范： [{条件(EXP),T,F}]</div><div>函数说明：根据条件判断成立或不成立来输出不同的值。</div><div>返回值类型：任意，T和F的值类型需保持一致。</div><div>参数说明：</div><div style="text-indent:2em;">EXP 返回BOOL类型的判定表达式</div><div style="text-indent:2em;">T   表达式为真时的值</div><div style="text-indent:2em;">F   表达式为假时的值</div><div>示例（1）输出平均每单美元出口额，当报关单数量为0时直接返回0。</div><div style="text-indent:2em;">[{条件([u:出口_报关单数量]=0),0,[u:出口_出口额USD]/[u:出口_报关单数量]}]</div>'},
        {name: '模糊匹配', arrDm: ['{LIKE(',')',',','}'], arrMc: ['{匹配(',')',',','}'], ywms: "<div>调用规范： {匹配(obj),pat}</div><div>函数说明：判断一个字符类值是否满足某个匹配模式。</div><div>返回值类型：布尔</div><div>参数说明：</div><div style='text-indent:2em;'>obj 对象引用，可以是某个指标或指标元</div><div style='text-indent:2em;'>pat 匹配模式，和数据库用法类似。</div><div>示例（1）判断法人籍贯地是否为本省，是返回，身份证号330开头表示省内。</div><div style='text-indent:2em;'>{匹配([u:法人代表身份证]),330%}</div>"},
        {name: '不匹配', arrDm: ['{NOTLIKE(',')',',','}'], arrMc: ['{不匹配(',')',',','}'], ywms: "<div>调用规范： {不匹配(obj),pat}</div><div>函数说明：判断一个字符类值是否不满足某个匹配模式。</div><div>返回值类型：布尔</div><div>参数说明：</div><div style='text-indent:2em;'>obj 对象引用，可以是某个指标或指标元</div><div style='text-indent:2em;'>pat 匹配模式，和数据库用法类似。</div><div>示例（1）判断法人身份证号不是以330开头的，表示法人籍贯地为省外。</div><div style='text-indent:2em;'>{不匹配([u:法人代表身份证]),330%}</div>"},
        {name: '计数', arrDm: ['{COUNT(',')','}'], arrMc: ['{计数(',')','}'], ywms: "<div>调用规范： {计数(obj),cond,group}</div><div>函数说明：对明细表某个字段进行计数，相当于数据库的count()。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是元数据表的字段。</div><div style='text-indent:2em;'>cond 条件表达式，对计数做条件限定。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：统计出口企业的供货商数量</div><div style='text-indent:2em;'>{计数([f:供货_企业税号])}</div><div>示例2：统计出口企业的省外供货商数量。</div><div style='text-indent:2em;'>{计数([f:供货_企业税号]),[f:供货_省内外]=1}</div>"},
        {name: '去重计数', arrDm: ['{COUNTDIST(',')','}'], arrMc: ['{去重计数(',')','}'], ywms: "<div>调用规范： {去重计数(obj),cond,group}</div><div>函数说明：对明细表某个字段做去重后的计数，用法和“计数”类似，相当于数据库的count(distinct)。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是元数据表的字段。</div><div style='text-indent:2em;'>cond 条件表达式，对去重计数做条件限定。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：统计出口企业的贸易国数量</div><div style='text-indent:2em;'>{去重计数([f:贸易国别代码])}</div><div>示例2：统计出口企业-监管方式为一般贸易的贸易国数量。</div><div style='text-indent:2em;'>{去重计数([f:贸易国别代码]),[f:监管方式代码]='0110'}</div>"},
        {name: '分组函数', arrDm: ['{GROUPBY(',')','}'], arrMc: ['{分组函数(',')','}'], ywms: "<div>调用规范： {分组函数(obj,obj,…) [,Type][,Having]}</div><div>函数说明：分组函数不单独使用，一般用在计数、去重计数等函数的条件扩展，在主函数计算前先按相关字段进行分组。</div><div>返回值类型：无</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，参与分组的元数据表字段，可以是一或多个。</div><div style='text-indent:2em;'>Type：分组后的操作，可选项是：MAX、MIN、MID、COUNT、SUM、COUNTDIST，分别表示分组后取统计数的最大值、最小值、中位数、计数、求和、去重计数，必选</div><div style='text-indent:2em;'>Having:分组筛选函数，可选。具体使用示例，参见分组筛选函数。</div><div>示例1：统计出口企业在同一天同一口岸出口到同一贸易国的报关行数量。</div><div style='text-indent:2em;'>{去重计数([f:申报单位代码]),{分组函数([f:出口日期],[f:贸易国别代码],[f:海关关区代码]),MAX}}</div>"},
        {name: '分组筛选函数', arrDm: ['HAVING(',')'], arrMc: ['分组筛选函数(',')'], ywms: "<div>调用规范：分组筛选函数(obj) op V [,Type]</div><div>函数说明：分组筛选函数作为分组函数的条件使用，类似SQL语法中HAVING字句，对分组过滤筛选。</div><div>参数说明：</div><div style='text-indent:2em;'>obj:对象引用，参与筛选的元数据表字段列（可使用截取函数，对字段进行截取），必选</div><div style='text-indent:2em;'>op:操作符，用于条件过滤的 &gt;、&lt;、=、&gt;=、&lt;=操作符，必选</div><div style='text-indent:2em;'>V：具体参与过滤比对的数值，必选</div><div style='text-indent:2em;'>Type：指定过滤算法类型，可选值为：MAX、MIN、MID、COUNT、SUM、COUNTDIST，分别代表：最大值、最小值、中位数、计数、求和、去重计数。</div><div style='text-indent:2em;'>默认值类型同外层明细函数的算法，如外层使用【按明细取合计值】，则默认采用SUM作为分组过滤算法。可选。</div><div>示例：统计同一天、同一个商品代码、出口到同一个贸易国的出口报关单数大于3出现的次数大于5</div><div style='text-indent:2em;'>{去重计数([f:出口报关单号]),{分组函数([f:出口日期],[f:贸易国别代码],[f:出口商品代码]),COUNT,分组筛选函数(截取函数([f:出口报关单号],1,18))>3}}&gt;5</div>"},
        {name: '截取函数', arrDm: ['SUBSTR(',',',',',')'], arrMc: ['截取函数(',',',',',')'], ywms: "<div>调用规范：截取函数(obj,startPos,length)</div><div>函数说明：截取字符串中的一段子字符串。</div><div>返回值类型：字符串</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是字符类型的指标（元）或元数据表字段。</div><div style='text-indent:2em;'>startPos，截取起始位置，字符串首位为1。</div><div style='text-indent:2em;'>length，截取子字符串的长度。</div><div>示例1：截取21位报关单号的前18位，即18位报关单号码。</div><div style='text-indent:2em;'>截取函数([f:海关报关单号],1,18)</div>"},
        {name: '存在函数', arrDm: ['EXIST(',',',')'], arrMc: ['存在函数(',',',')'], ywms: "<div>调用规范：存在函数/不存在函数(obj,Type)</div><div>函数说明：在明细函数中使用，通过Type指定特定判断条件的过滤函数。</div><div>参数说明：</div><div style='text-indent:2em;'>obj:对象引用，参与筛选的元数据表字段列（可使用截取函数，对字段进行截取），必选</div><div style='text-indent:2em;'>Type：指定条件判断类型，可选值为：TB、HB、MGSP、FXDQ、FXQY、FXKA，分别代表：同比、环比、敏感商品、风险地区、风险企业、风险口岸的特定过滤条件，必选。</div><div>示例1：筛选风险供货地（从税号判定存在）的出口额大于1000的企业。</div><div style='text-indent:2em;'>{按明细取合计值([f:出口销售（美元）]),存在函数(截取函数([f:供货方识别号],3,6),FXDQ)}>1000</div><div>示例2：筛选分析期内新增供货企业数量&gt;10的企业。解释：分析期内新增，即分析期的上一个年度同比周期内不存在的供货企业</div><div style='text-indent:2em;'>{去重计数([f:供货方识别号]),不存在函数([f:供货方识别号],TB)}&gt;10</div>"},
        {name: '不存在函数', arrDm: ['NOTEXIST(',',',')'], arrMc: ['不存在函数(',',',')'], ywms: "<div>调用规范：存在函数/不存在函数(obj,Type)</div><div>函数说明：在明细函数中使用，通过Type指定特定判断条件的过滤函数。</div><div>参数说明：</div><div style='text-indent:2em;'>obj:对象引用，参与筛选的元数据表字段列（可使用截取函数，对字段进行截取），必选</div><div style='text-indent:2em;'>Type：指定条件判断类型，可选值为：TB、HB、MGSP、FXDQ、FXQY、FXKA，分别代表：同比、环比、敏感商品、风险地区、风险企业、风险口岸的特定过滤条件，必选。</div><div>示例1：筛选风险供货地（从税号判定存在）的出口额大于1000的企业。</div><div style='text-indent:2em;'>{按明细取合计值([f:出口销售（美元）]),存在函数(截取函数([f:供货方识别号],3,6),FXDQ)}>1000</div><div>示例2：筛选分析期内新增供货企业数量&gt;10的企业。解释：分析期内新增，即分析期的上一个年度同比周期内不存在的供货企业</div><div style='text-indent:2em;'>{去重计数([f:供货方识别号]),不存在函数([f:供货方识别号],TB)}&gt;10</div>"},
      ]},
      { name: '明细函数',item: [
        {name: '按明细取合计值', arrDm: ['{SUMIF(',')','}'], arrMc: ['{按明细取合计值(',')','}'], ywms: "<div>调用规范：{按明细取合计值(obj),cond,group}</div><div>函数说明：统计元数据（明细）表的某字段符合某特定条件的合计值，</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是数值型的元数据表字段。</div><div style='text-indent:2em;'>cond，统计的扩展条件。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：统计出口企业报告期内出口销售额（美元）合计。</div><div style='text-indent:2em;'>{按明细取合计值([f:美元离岸价])}</div><div>示例2：统计出口企业报告期内出口美国的销售额（美元）合计。</div><div style='text-indent:2em;'>{按明细取合计值([f:美元离岸价]), [f:贸易国别代码]=502}</div>"},
        {name: '按明细取最大值', arrDm: ['{MAX(',')','}'], arrMc: ['{按明细取最大值(',')','}'], ywms: "<div>调用规范：{按明细取最大值(obj),cond,group}</div><div>函数说明：统计元数据（明细）表的某字段符合某特定条件的最大值，</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是数值型的元数据表字段。</div><div style='text-indent:2em;'>cond，统计的扩展条件，允许为空。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：海关报关单201表，取每一票出口货物出口销售额（美元）的最大值。</div><div style='text-indent:2em;'>{按明细取最大值([f:美元离岸价]])}</div><div>示例2：海关报关单201表，统计出口美国的出口货物的销售额（美元）最大值。</div><div style='text-indent:2em;'>{按明细取最大值([f:美元离岸价]), [f:贸易国别代码]=502}</div>"},
        {name: '按明细取最小值', arrDm: ['{MIN(',')','}'], arrMc: ['{按明细取最小值(',')','}'], ywms: "<div>调用规范：{按明细取最小值(obj),cond,group}</div><div>函数说明：统计元数据（明细）表的某字段符合某特定条件的最小值，</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是数值型的元数据表字段。</div><div style='text-indent:2em;'>cond，统计的扩展条件，允许为空。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：海关报关单201表，取每一票出口货物出口销售额（美元）的最小值。</div><div style='text-indent:2em;'>{按明细取最小值([f:美元离岸价]])}</div><div>示例2：海关报关单201表，统计出口美国的出口货物的销售额（美元）最小值。</div><div style='text-indent:2em;'>{按明细取最小值([f:美元离岸价]), [f:贸易国别代码]=502}</div>"},
        {name: '按明细取平均值', arrDm: ['{AVG(',')','}'], arrMc: ['{按明细取平均值(',')','}'], ywms: "<div>调用规范：{按明细取平均值(obj),cond,group}</div><div>函数说明：统计元数据（明细）表的某字段符合某特定条件的平均值，</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是数值型的元数据表字段。</div><div style='text-indent:2em;'>cond，统计的扩展条件，允许为空。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：海关报关单201表，取每一票出口货物出口销售额（美元）的平均值。</div><div style='text-indent:2em;'>{按明细取平均值([f:美元离岸价]])}</div><div>示例2：海关报关单201表，统计出口美国的出口货物的销售额（美元）平均值。</div><div style='text-indent:2em;'>{按明细取平均值([f:美元离岸价]), [f:贸易国别代码]=502}</div>"},
        {name: '按明细取中位值', arrDm: ['{MID(',')','}'], arrMc: ['{按明细取中位值(',')','}'], ywms: "<div>调用规范：{按明细取中位值(obj),cond,group}</div><div>函数说明：统计元数据（明细）表的某字段符合某特定条件的中位值，</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，必须是数值型的元数据表字段。</div><div style='text-indent:2em;'>cond，统计的扩展条件，允许为空。</div><div style='text-indent:2em;'>group:分组函数，可选，对明细数据进行分组统计，具体说明参见【分组函数】</div><div>示例1：海关报关单201表，取每一票出口货物出口销售额（美元）的中位值。</div><div style='text-indent:2em;'>{按明细取中位值([f:美元离岸价]])}</div><div>示例2：海关报关单201表，统计出口美国的出口货物的销售额（美元）中位值。</div><div style='text-indent:2em;'>{按明细取中位值([f:美元离岸价]), [f:贸易国别代码]=502}</div>"},
      ]},
      { name: '复合函数',item: [
        {name: '上年同期', arrDm: ['{LYEAR(',')}'], arrMc: ['{上年同期(',')}'], ywms: "<div>调用规范：{上年同期(obj)}</div><div>函数说明：返回某指标（元）的上年同期值，用于计算同比。</div><div>返回值类型：任意，和指标（元）数据类型一致</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，指标或指标元。</div><div>示例1：取本报告期出口额USD的上年同期值。</div><div style='text-indent:2em;'>{上年同期(u:出口_出口额USD)}</div>"},
        {name: '上期', arrDm: ['{LMONTH(',')}'], arrMc: ['{上期(',')}'], ywms: "<div>调用规范：{上期(obj)}</div><div>函数说明：返回某指标（元）的上期值，用于计算环比。</div><div>返回值类型：任意，和指标（元）数据类型一致</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，指标或指标元。</div><div>示例1：取本报告期出口额USD的上期值。</div><div style='text-indent:2em;'>{上期(u:出口_出口额USD)}</div>"}
      ]},
      { name: '聚合函数',item: [
        {name: '全省平均值', arrDm: ['{PAVG(',')}'], arrMc: ['{全省平均值(',')}'], ywms: "<div>调用规范：{全省平均值(obj)}</div><div>函数说明：返回某指标（元）的全省平均值。平均值算法同oracle的avg函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省平均值。</div><div style='text-indent:2em;'>{全省平均值(u:财务_毛利率)}</div>"},
        {name: '样本平均值', arrDm: ['{SAVG(',')}'], arrMc: ['{样本平均值(',')}'], ywms: "<div>调用规范：{样本平均值(obj)}</div><div>函数说明：返回某指标（元）的样本平均值，样本平均值以当前筛选项目的目标企业为样本范围。平均值算法同oracle的avg函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本平均值。</div><div style='text-indent:2em;'>{样本平均值(u:财务_毛利率)}</div>"},
        {name: '全省中位值', arrDm: ['{PMID(',')}'], arrMc: ['{全省中位值(',')}'], ywms: "<div>调用规范：{全省中位值(obj)}</div><div>函数说明：返回某指标（元）的全省中位值。中位数算法同oracle的median函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省中位值。</div><div style='text-indent:2em;'>{全省中位值(u:财务_毛利率)}</div>"},
        {name: '样本中位值', arrDm: ['{PMID(',')}'], arrMc: ['{样本中位值(',')}'], ywms: "<div>调用规范：{样本中位值(obj)}</div><div>函数说明：返回某指标（元）的样本中位值，样本中位值以当前筛选项目的目标企业为样本范围。中位数算法同oracle的median函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本中位值。</div><div style='text-indent:2em;'>{样本中位值(u:财务_毛利率)}</div>"},
        {name: '全省方差', arrDm: ['{PVARIANCE(',')}'], arrMc: ['{全省方差(',')}'], ywms: "<div>调用规范：{全省方差(obj)}</div><div>函数说明：返回某指标（元）的全省方差。方差算法同oracle的var_pop函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省方差。</div><div style='text-indent:2em;'>{全省方差(u:财务_毛利率)}</div>"},
        {name: '样本方差', arrDm: ['{SVARIANCE(',')}'], arrMc: ['{样本方差(',')}'], ywms: "<div>调用规范：{样本方差(obj)}</div><div>函数说明：返回某指标（元）的样本方差，样本方差以当前筛选项目的目标企业为样本范围。方差算法同oracle的var_pop函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本方差。</div><div style='text-indent:2em;'>{样本方差(u:财务_毛利率)}</div>"},
        {name: '全省标准差', arrDm: ['{PSTD(',')}'], arrMc: ['{全省标准差(',')}'], ywms: "<div>调用规范：{全省标准差(obj)}</div><div>函数说明：返回某指标（元）的全省标准差。标准差算法同oracle的stddev函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省标准差。</div><div style='text-indent:2em;'>{全省标准差(u:财务_毛利率)}</div>"},
        {name: '样本标准差', arrDm: ['{SSTD(',')}'], arrMc: ['{样本标准差(',')}'], ywms: "<div>调用规范：{样本标准差(obj)}</div><div>函数说明：返回某指标（元）的样本标准差，样本标准差以当前筛选项目的目标企业为样本范围。标准差算法同oracle的stddev函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本标准差。</div><div style='text-indent:2em;'>{样本标准差(u:财务_毛利率)}</div>"},
        {name: '全省最大值', arrDm: ['{PMAX(',')}'], arrMc: ['{全省最大值(',')}'], ywms: "<div>调用规范：{全省最大值(obj)}</div><div>函数说明：返回某指标（元）的全省最大值。最大值算法同oracle的max函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省最大值。</div><div style='text-indent:2em;'>{全省最大值(u:财务_毛利率)}</div>"},
        {name: '样本最大值', arrDm: ['{SMAX(',')}'], arrMc: ['{样本最大值(',')}'], ywms: "<div>调用规范：{样本最大值(obj)}</div><div>函数说明：返回某指标（元）的样本最大值，样本最大值以当前筛选项目的目标企业为样本范围。最大值算法同oracle的max函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本最大值。</div><div style='text-indent:2em;'>{样本最大值(u:财务_毛利率)}</div>"},
        {name: '全省最小值', arrDm: ['{PMIN(',')}'], arrMc: ['{全省最小值(',')}'], ywms: "<div>调用规范：{全省最小值(obj)}</div><div>函数说明：返回某指标（元）的全省最小值。最小值算法同oracle的min函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率全省最小值。</div><div style='text-indent:2em;'>{全省最小值(u:财务_毛利率)}</div>"},
        {name: '样本最小值', arrDm: ['{SMIX(',')}'], arrMc: ['{样本最小值(',')}'], ywms: "<div>调用规范：{样本最小值(obj)}</div><div>函数说明：返回某指标（元）的样本最小值，样本最小值以当前筛选项目的目标企业为样本范围。最小值算法同oracle的min函数。</div><div>返回值类型：数值</div><div>参数说明：</div><div style='text-indent:2em;'>obj对象引用，数值类指标或指标元。</div><div>示例1：取毛利率样本最小值。</div><div style='text-indent:2em;'>{样本最小值(u:财务_毛利率)}</div>"},
      ]}
    ],
    zbList: [],
    type: '',
    cursorIndex: '',
    zbYwms: '',
    funcYwms: '',
    activeFuncRow: '',
    activeZbRow: '',
    limitArr: [false],
    onInit: function (e) {
      components.gzbjq = e.vmodel;
    },
    onReady: function(){
      this.getYsflxx();
    },
    selectZb: function(row){
      var dm = '['+this.type+':'+row.zbDm+']'
      var mc = '['+this.type+':'+row.zbMc+']'
      if (this.cursorIndex === '') {
        this.expressionDmList.push(dm)
        this.expressionMcList.push(mc)
        this.cursorIndex = this.expressionDmList.length
      } else {
        this.expressionDmList.splice(this.cursorIndex,0,dm)
        this.expressionMcList.splice(this.cursorIndex,0,mc)
        this.cursorIndex ++ 
      }
      this.expressionMc = this.expressionMcList.join('')
      this.resetPosition($('#txt')[0])
    },
    selectFunc: function(item){
      if (this.cursorIndex === '') {
        this.cursorIndex = this.expressionDmList.length + 1
        this.expressionDmList = this.expressionDmList.concat(item.arrDm)
        this.expressionMcList = this.expressionMcList.concat(item.arrMc)
      } else {
        this.expressionDmList.splice.apply(this.expressionDmList,[this.cursorIndex,0].concat(item.arrDm))
        this.expressionMcList.splice.apply(this.expressionMcList,[this.cursorIndex,0].concat(item.arrMc))
        this.cursorIndex ++
      }
      this.expressionMc = this.expressionMcList.join('')
      this.resetPosition($('#txt')[0])
    },
    selectExpression: function(item){
      if (this.cursorIndex === '') {
        this.cursorIndex = this.expressionDmList.length + 1
        this.expressionDmList = this.expressionDmList.concat(item.value)
        this.expressionMcList = this.expressionMcList.concat(item.name)
      } else {
        this.expressionDmList.splice.apply(this.expressionDmList,[this.cursorIndex,0].concat(item.value))
        this.expressionMcList.splice.apply(this.expressionMcList,[this.cursorIndex,0].concat(item.name))
        this.cursorIndex ++ 
      }
      this.expressionMc = this.expressionMcList.join('')
      this.resetPosition($('#txt')[0])
    },
    keydown: function(e){
      var el = e.srcElement
      if (e.keyCode == 8 && this.cursorIndex > 0) {  // backspace
        this.enterTextHandle();
        this.expressionDmList.splice(this.cursorIndex-1, 1)
        this.expressionMcList.splice(this.cursorIndex-1, 1)
        this.cursorIndex --;
        this.expressionMc = this.expressionMcList.join('')
        this.resetPosition(el)
        e.preventDefault();
      } else if (e.keyCode == 46){ // del
        this.expressionDmList.splice(this.cursorIndex, 1)
        this.expressionMcList.splice(this.cursorIndex, 1)
        this.expressionMc = this.expressionMcList.join('')
        this.resetPosition(el)
        e.preventDefault();
      } else if (e.keyCode == 13 || e.keyCode == 32) { // enter、空格
        e.preventDefault();
      } else if (e.keyCode == 37 && this.cursorIndex >0) { // <-
        this.enterTextHandle();
        this.cursorIndex --;
        // this.addControl();
        this.resetPosition(el);
        e.preventDefault();
      } else if (e.keyCode == 39) { // ->
        if (this.cursorIndex < this.expressionMcList.length) {
          this.enterTextHandle();
          this.cursorIndex ++;
          // this.addControl();
          this.resetPosition(el);
          e.preventDefault();
        }
      } else if (e.ctrlKey && e.keyCode == 86) { // Ctrl+V
        e.preventDefault();
      } 
    },
    keyup: function(e){
      this.expressionMc = this.expressionMc.replace(/，/g,',')
    },
    resetPosition: function(el){
      var pos = 0
      for (var i=0;i<this.cursorIndex;i++) {
        pos += this.expressionMcList[i].length
      }
      this.setCaretPosition(el,pos)
    },
    //获取光标位置函数 
    getCursortPosition: function (el) {
      var CaretPos = 0; 
      // IE Support
      if (document.selection){ 
        // el.focus (); // 获取焦点
        var sTextRange= document.selection.createRange();  
        var oTextRange = document.body.createTextRange();
        oTextRange.moveToElementText(el);  
        for (CaretPos=0; oTextRange.compareEndPoints("StartToStart", sTextRange) < 0; CaretPos++){   
          oTextRange.moveStart('character', 1);   
        }
      } 
      // Firefox support (非ie)
      else if (el.selectionStart || el.selectionStart == '0'){
        CaretPos =el.selectionStart; // 获取选定区的开始点 
      }
      return CaretPos; 
    }, 
    //设置光标位置函数 
    setCaretPosition(ctrl, pos){
      if(ctrl.setSelectionRange)   //非ie
      {
        ctrl.focus();  // 获取焦点
        ctrl.setSelectionRange(pos,pos);  // 设置选定区的开始和结束点
      } 
      else if (ctrl.createTextRange)
      { 
        var range = ctrl.createTextRange();  // 创建选定区
        range.collapse(true);                // 设置为折叠,即光标起点和结束点重叠在一起
        range.moveEnd('character', pos);     // 移动结束点
        range.moveStart('character', pos);   // 移动开始点
        range.select();                      // 选定当前区域
      } 
    },
    mousemove: function(e){
      e.preventDefault()
    },
    // 设置光标位置
    mouseup: function(e){
      var el = e.srcElement;
      var CaretPos = this.getCursortPosition(el);
      if (CaretPos == 0) {
        this.cursorIndex = 0
        this.setCaretPosition(el,0)
      } else {
        var len = 0
        for (var i=0;i<this.expressionMcList.length;i++) {
          len += this.expressionMcList[i].length
          if (CaretPos <= len) {
            this.cursorIndex = i+1
            this.setCaretPosition(el,len)
            break;
          }
        }
      }
      // this.addControl()
    },
    // 处理键盘输入的文本
    enterTextHandle: function(e){
      var tmpMc = this.expressionMc
      if (this.expressionMcList.length == 0 && tmpMc !== '') {
        this.expressionMcList.push(tmpMc)
        this.expressionDmList.push(tmpMc)
        this.cursorIndex ++
      } else {
        for(var i=0;i<this.expressionMcList.length;i++) {
          var mcItem = this.expressionMcList[i]
          var index = tmpMc.indexOf(mcItem)
          if (index == 0) {
            tmpMc = tmpMc.substr(mcItem.length, tmpMc.length - mcItem.length)
          } else {
            var mcList = tools.clone(this.expressionMcList)
            mcList.splice(0,i)
            var mcListStr = mcList.join('')
            index = tmpMc.lastIndexOf(mcListStr)
            var addContent = tmpMc.substr(0,index)
            this.expressionMcList.splice(i,0,addContent)
            this.expressionDmList.splice(i,0,addContent)
            this.expressionMc =this.expressionMcList.join('')
            this.cursorIndex ++
            break;
          }
          if (i == this.expressionMcList.length -1 && tmpMc != '') {
            this.expressionMcList.push(tmpMc)
            this.expressionDmList.push(tmpMc)
            this.expressionMc =this.expressionMcList.join('')
            this.cursorIndex ++
          }
        }
      }
      
    },
    // 光标在函数内部时添加控制
    // addControl: function(){
    //   for (var j=0;j<this.limitArr.length;j++) {
    //     if (j==this.cursorIndex && this.limitArr[j]) {
    //       // console.log('限制！')
    //       return false;
    //     }
    //   }
    //   return true;
    // },
    getYsflxx: function(){
      var self = this
      var typeMap = {
        1: 'z',
        2: 'u',
        3: 'f'
      }
      var setting = {
				callback:{
          beforeClick: function(id,node){
            return !!node.ysDm
          },
          beforeDblClick: function(id,node){
            return !!node.ysDm
          },
					onClick:function(e,id,node){
            if (!node.ysDm) return;
            var params = {
              type: node.type,
              ysDm: node.ysDm,
              zid: self.zid 
            }
            self.type = typeMap[node.type]
            self.getZbList(params)
            self.isShowZb = true
            self.zbYwms = ''
            self.activeZbRow = ''
						return;
					},
					onDblClick:function(e,id,node){
            if (!node.ysDm) return;
            var params = {
              type: node.type,
              ysDm: node.ysDm,
              zid: self.zid 
            }
            self.type = typeMap[node.type]
            self.getZbList(params)
            self.isShowZb = true
            self.zbYwms = ''
            self.activeZbRow = ''
						return;
					}
				},
				data:{
          simpleData:{
            enable: true,
            idKey: "ysDm",
          },
          key:{children:"item",name:"ysMc"}
        }
			};
      ajax("POST","/sszj/sxgn/ysflxx",{}).done(function(res){
        if(res.code=='0'){
          $.fn.zTree.init($("#gzbjqTree"), setting,res.data.item);
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    getZbList: function(params){
      var self = this
      ajax("POST","/sszj/sxgn/getZbList",params).done(function(res){
        if(res.code=='0'){
					self.zbList = res.data
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    hideModel: function(){
      this.expressionDmList = []
      this.expressionMcList = []
      this.expressionMc = ''
      this.cursorIndex = ''
      this.activeZbRow = ''
      this.activeFuncRow = ''
      this.zbYwms = ''
      this.funcYwms = ''
      this.isShowZb = true
    },
    saveModel: function(){
      var self = this
      var expression = this.expressionDmList.length <= 0 ? '' : JSON.stringify(this.expressionDmList)
      var params = {
        zid: this.zid,
        expression: expression
      }
      ajax("POST","/sszj/sxgn/checkRule",params).done(function(res){
        if(res.code=='0'){
          components.ssxmEdit.ruleData.expression = tools.clone(self.expressionDmList)
          components.ssxmEdit.ruleData.expressionCname = tools.clone(self.expressionMcList)
          components.ssxmEdit.hideGzbjq();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
      
    },
    cancel: function(){
      if (components.ssxmEdit.isOnlyEditRules) { // 只有保存规则弹框时
        $('.model').hide();
        components.ssxmEdit.isOnlyEditRules = false;
      }
      components.ssxmEdit.hideGzbjq();
    },
    getFuncYwms: function(ywms,activeFuncRow){
      this.funcYwms = ywms
      this.activeFuncRow = activeFuncRow
    },
    getZbYwms: function(ywms,activeZbRow){
      this.zbYwms = ywms
      this.activeZbRow = activeZbRow
    },
    
  }
})