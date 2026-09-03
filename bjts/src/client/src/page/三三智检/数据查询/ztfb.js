var ztfb=require("./ztfb.html");
avalon.component('ztfb', {
	template:ztfb,
	defaults: {
        params: {},
        // 首页正态曲线的计算公式
        mathJax: '`f(x) = (1 / (\sqrt {2\pi} \sigma)) e^(-(x-\mu)^2/(2\sigma^2))`',
        // 数据源（从隔壁的 js 文件中引入）
        json: {},
        // 页面中输入的数据。初始默认为 json 文件
        input: '', // 数组的 watch 监听不太方便处理
        // 是否为样本数据
        isSample: true,
        data: [],
        onReady: function(){
            this.data = this.params.data
            this.initChartsData($('#ztfb-chart')[0])
        },
        // 有序数据源（方便操作）
        dataOrderBy: function() {
            const data = this.data.concat([]); // 为防止 sort 方法修改原数组，对原数组进行拷贝，操作副本。
            return data.sort((a, b) => a - b)
        },
        // 数据整理。原数据整理为：{数据值 : 数据频率}
        dataAfterClean: function() {
            let res = {}
            const data = this.dataOrderBy
            for (let i = 0; i < this.data.length; i++) {
                let key = parseFloat(this.data[i]).toFixed(1) // 这里保留 1 位小数
                if (key !== "NaN" && parseFloat(key) === 0)
                    key = "0.0" //这个判断用来处理保留小数位后 -0.0 和 0.0 判定为不同 key 的 bug
                if (res[key])
                    res[key] += 1
                else
                    res[key] = 1
            }
            return res
        },
        // 数据整理。返回源数据所有值（排序后）
        dataAfterCleanX: function() {
            return Object.keys(this.dataAfterClean()).sort((a, b) => a - b).map(t => parseFloat(t).toFixed(1)) // 保留 1 位小数
            // return Object.keys(this.dataAfterClean) // 不保证顺序一致
        },
        // 数据整理。返回源数据所有值对应的频率（排序后） -- 与 dataAfterCleanX 顺序一致
        dataAfterCleanY: function() {
            let r = []
            for (let i = 0; i < this.dataAfterCleanX().length; i++) {
                r.push(this.dataAfterClean()[this.dataAfterCleanX()[i]])
            }
            return r
        },
        // 数据整理。返回源数据所有值对应的频率，刻度更细致（保留 2 位小数） -- 与 dataAfterCleanX 顺序一致
        dataAfterCleanXSub: function() {
            let r = []
            for (let i = parseFloat(this.min.toFixed(1)); i <= parseFloat(this.max.toFixed(1)); i +=
                0.01)
                r.push(i.toFixed(2))
            console.log(r)
            return r
        },

        //  计算平均数。这里的平均数指的是数学期望、算术平均数
        sum: function() {
            if (this.data.length === 0) return 0
            return this.data.reduce((prev, curr) => prev + curr)
        },
        // 计算平均数。这里的平均数指的是数学期望、算术平均数
        average: function() {
            return this.sum() / this.data.length
        },
        // 计算众数
        mode: function() {
            return 0
        },
        // 计算中位数
        median: function() {
            const data = this.dataOrderBy
            return (data[(data.length - 1) >> 1] + data[data.length >> 1]) / 2
        },
        // 计算偏差
        deviation: function() {
            // 1、求平均数
            const avg = this.average()
            // 2、返回偏差。 f(x) = x - avg
            return this.data.map(x => x - avg)
        },
        // 计算总体/样本方差
        variance: function() {
            if (this.data.length === 0) return 0
            // 1、求偏差
            const dev = this.deviation()
            // 2、求偏差平方和
            const sumOfSquOfDev = dev.map(x => x * x).reduce((x, y) => x + y)
            // 3、返回方差
            return sumOfSquOfDev / (this.isSample ? (this.data.length - 1) : this.data.length)
        },
        // 计算总体/样本标准差
        standardDeviation: function() {
            return Math.sqrt(this.variance())
        },
        // 计算一倍标准差范围
        standarDevRangeOfOne: function() {
            return {
                low: this.average() - 1 * this.standardDeviation(),
                up: this.average() + 1 * this.standardDeviation()
            }
        },
        // 计算二倍标准差范围
        standarDevRangeOfTwo: function() {
            return {
                low: this.average() - 2 * this.standardDeviation(),
                up: this.average() + 2 * this.standardDeviation()
            }
        },
        // 计算三倍标准差范围
        standarDevRangeOfThree: function() {
            return {
                low: this.average() - 3 * this.standardDeviation(),
                up: this.average() + 3 * this.standardDeviation()
            }
        },
        // 计算最小值
        min: function() {
            return Math.min.apply(null, this.data)
        },
        // 计算最大值
        max: function() {
            return Math.max.apply(null, this.data)
        },
        // 正态分布(高斯分布)计算公式
        normalDistribution: function() {
            // 计算公式： `f(x) = (1 / (\sqrt {2\pi} \sigma)) e^(-(x-\mu)^2/(2\sigma^2))`
            // return (1 / Math.sqrt(2 * Math.PI) * a) * (Math.exp(-1 * ((x - u) * (x - u)) / (2 * a * a)))
            let res = []
            for (let i = 0; i < this.dataAfterCleanX().length; i++) {
                const x = this.dataAfterCleanX()[i]
                const a = this.standardDeviation()
                const u = this.average()
                const y = (1 / (Math.sqrt(2 * Math.PI) * a)) * (Math.exp(-1 * ((x - u) * (x - u)) / (2 *
                    a * a)))
                res.push(y)
                if (x == 11.8)
                console.log(y) // 正态分布峰值，用于验证
            }
            return res
        },
        initChartsData: function(chart) {
            if (!chart) return
            chart = echarts.init(chart)
            // Echarts 图的配置
            let options = {
                // Echarts 图 -- 标题
                title: {
                    text: '正态分布曲线'
                },
                // Echarts 图 -- 工具
                tooltip: {},
                // Echarts 图 -- 图例
                legend: {
                    data: ['f(x)']
                },
                // Echarts 图 -- x 坐标轴刻度 -- 正态分布数值
                xAxis: [{
                    // name : "标准刻度(0.1)",
                    data: this.dataAfterCleanX(),
                    // min: this.min,
                    // max: this.max
                }],
                // Echarts 图 -- y 坐标轴刻度
                yAxis: [{
                        type: 'value',
                        name: '频数',
                        position: 'left',
                        // 网格线
                        splitLine: {
                            show: false
                        },
                        axisLine: {
                            lineStyle: {
                                // color: 'orange'
                                // color: '#409eff'
                                color: '#000'
                            }
                        },
                        axisLabel: {
                            formatter: '{value}'
                        }
                    },
                    {
                        type: 'value',
                        name: '概率',
                        position: 'right',
                        // 网格线
                        splitLine: {
                            show: false
                        },
                        axisLine: {
                            lineStyle: {
                                color: 'black'
                            }
                        },
                        axisLabel: {
                            formatter: '{value}'
                        }
                    },
                ],
                // Echarts 图 -- y 轴数据
                series: [{
                    name: '源数据', // y 轴名称
                    type: 'bar', // y 轴类型
                    yAxisIndex: 0,
                    barGap: 0,
                    barWidth: 14,
                    itemStyle: {
                        normal: {
                            show: true,
                            // color: 'rgba(255, 204, 0,.3)', //柱子颜色
                            color: '#409eff', //柱子颜色
                            // borderColor: '#FF7F50' //边框颜色
                            // borderColor: '#ccc' //边框颜色
                            borderColor: '#409eff' //边框颜色
                        }
                    },
                    data: this.dataAfterCleanY(), // y 轴数据 -- 源数据
                }, {
                    name: '正态分布', // y 轴名称
                    type: 'line', // y 轴类型
                    symbol: 'none', //去掉折线图中的节点
                    smooth: true, //true 为平滑曲线
                    yAxisIndex: 1,
                    data: this.normalDistribution(), // y 轴数据 -- 正态分布
                    // 警示线
                    // markLine: {
                    //     symbol: ['none'], // 箭头方向
                    //     lineStyle: {
                    //         type: "silent",
                    //         color: "green",
                    //     },
                    //     itemStyle: {
                    //         normal: {
                    //             show: true,
                    //             color: 'black'
                    //         }
                    //     },
                    //     label: {
                    //         show: true,
                    //         position: "middle"
                    //     },
                    //     data: [{
                    //         name: '一倍标准差',
                    //         xAxis: this.standarDevRangeOfOne().low.toFixed(1),
                    //         // 当 n 倍标准差在坐标轴外时，将其隐藏，否则它会默认显示在最小值部分，容易引起混淆
                    //         lineStyle: {
                    //             opacity: (this.min() > this.standarDevRangeOfOne().low) ? 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.min() > this.standarDevRangeOfOne().low)
                    //         }
                    //     }, {
                    //         name: '一倍标准差',
                    //         xAxis: this.standarDevRangeOfOne().up.toFixed(1),
                    //         lineStyle: {
                    //             opacity: (this.max() < this.standarDevRangeOfOne().up) ?
                    //                 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.max() < this.standarDevRangeOfOne().up)
                    //         }
                    //     }, {
                    //         name: '二倍标准差',
                    //         xAxis: this.standarDevRangeOfTwo().low.toFixed(1),
                    //         lineStyle: {
                    //             opacity: (this.min() > this.standarDevRangeOfTwo().low) ? 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.min() > this.standarDevRangeOfTwo().low)
                    //         }
                    //     }, {
                    //         name: '二倍标准差',
                    //         xAxis: this.standarDevRangeOfTwo().up.toFixed(1),
                    //         lineStyle: {
                    //             opacity: (this.max() < this.standarDevRangeOfTwo().up) ? 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.max() < this.standarDevRangeOfTwo().up)
                    //         }
                    //     }, {
                    //         name: '三倍标准差',
                    //         xAxis: this.standarDevRangeOfThree().low.toFixed(1),
                    //         lineStyle: {
                    //             opacity: (this.min() > this.standarDevRangeOfThree().low) ? 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.min() > this.standarDevRangeOfThree().low)
                    //         }
                    //     }, {
                    //         name: '三倍标准差',
                    //         xAxis: this.standarDevRangeOfThree().up.toFixed(1),
                    //         lineStyle: {
                    //             opacity: (this.max() < this.standarDevRangeOfThree().up) ? 0 : 1
                    //         },
                    //         label: {
                    //             show: !(this.max() < this.standarDevRangeOfThree().up)
                    //         }
                    //     }, {
                    //         name: '平均值',
                    //         // type: 'average',
                    //         xAxis: this.average().toFixed(1),
                    //         lineStyle: {
                    //             color: 'red'
                    //         }
                    //     }]
                    // }
                }],

            }
            chart.setOption(options)
            window.addEventListener("resize", () => {
                chart.resize()
            })
        },
    }
})