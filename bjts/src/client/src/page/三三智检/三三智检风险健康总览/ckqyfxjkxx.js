var ckqyfxjkxx=require("./ckqyfxjkxx.html");
avalon.component('ckqyfxjkxx', {
	template:ckqyfxjkxx,
	defaults: {
    params: {},
    options1: {
      title: {
        text: '出口企业健康码户数占比',
        left: 20,
        top: 10,
        textStyle: {
          fontSize: 13
        }
      },
      tooltip: {
        trigger: 'item'
      },
      legend: {
        orient: 'vertical',
        left: 'right',
        top: 'middle'
      },
      color: ['#7ed321','#f5a623','#d0021b'],
      series: [
        {
          type: 'pie',
          radius: ['30%','60%'],
          center: ['40%', '55%'],
          startAngle: 70,
          label: {
            normal: {
              position: 'inner',
              show: false
            }
          },
          labelLine: {
            show: true
          },
          label: {
            //echarts饼图内部显示百分比设置
            show: true,
            position: "outside", //outside 外部显示  inside 内部显示
            formatter: `{d}%({c}户)`,
            // color: "#ffffff", //颜色
            fontSize: 12 //字体大小
          },
          data: [],
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          }
        }
      ]
    },
    options2: {
      title: {
        text: '生产、外贸红黄码户数占比',
        left: 20,
        top: 10,
        textStyle: {
          fontSize: 13
        }
      },
      tooltip: {
        trigger: 'item'
      },
      legend: {
        orient: 'vertical',
        left: 'right',
        top: 'middle'
      },
      color: ['#f5a623','#fac858','#d0021b','#ee6666'],
      series: [
        {
          type: 'pie',
          radius: ['30%','60%'],
          center: ['40%', '55%'],
          label: {
            normal: {
              position: 'inner',
              show: false
            }
          },
          labelLine: {
            show: true,
          },
          label: {
            //echarts饼图内部显示百分比设置
            show: true,
            position: "outside", //outside 外部显示  inside 内部显示
            formatter: `{d}%({c}户)`,
            // color: "#ffffff", //颜色
            fontSize: 12 //字体大小
          },
          data: [],
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          }
        }
      ]
    },
    options3: {
      title: {
        text: '所属企业综合健康风险示意图',
        left: 20,
        top: 10,
        textStyle: {
          fontSize: 13
        }
      },
      legend: {
        data: ['外贸', '生产'],
        left: 20,
        top: 30
      },
      color: ['#409eff','#fac858'],
      radar: {
        indicator: [
          { name: '信用', max: 100 },
          { name: '其他', max: 100 },
          { name: '财务', max: 100 },
          { name: '发票', max: 100 },
          { name: '出口', max: 100 },
          { name: '退税', max: 100 },
        ],
        radius: '60%',
        center: ['50%','55%'],
        name: {
          color: '#2f59e3'
        }
      },
      series: [
        {
          type: 'radar',
          data: [
            {
              value: [],
              name: '外贸'
            },
            {
              value: [],
              name: '生产'
            }
          ]
        }
      ]
    },
    options4: {
      color: ['#409eff','#fac858'],
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          crossStyle: {
            color: '#999'
          }
        }
      },
      legend: {
        data: ['户数', '出口额']
      },
      grid: {
        bottom: 30
      },
      xAxis: [
        {
          type: 'category',
          data: [],
          axisPointer: {
            type: 'shadow'
          }
        }
      ],
      yAxis: [
        {
          type: 'value',
          name: '户数'
        },
        {
          type: 'value',
          name: '出口额'
        }
      ],
      series: [
        {
          name: '户数',
          type: 'bar',
          data: []
        },
        {
          name: '出口额',
          type: 'line',
          yAxisIndex: 1,
          data: []
        }
      ]
    },
    options5: {
      color: ['#409eff','#fac858'],
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross',
          crossStyle: {
            color: '#999'
          }
        }
      },
      legend: {
        data: ['户数', '金额']
      },
      grid: {
        bottom: 30
      },
      xAxis: [
        {
          type: 'category',
          data: [],
          axisPointer: {
            type: 'shadow'
          }
        }
      ],
      yAxis: [
        {
          type: 'value',
          name: '户数'
        },
        {
          type: 'value',
          name: '金额'
        }
      ],
      series: [
        {
          name: '户数',
          type: 'bar',
          data: []
        },
        {
          name: '金额',
          type: 'line',
          yAxisIndex: 1,
          data: []
        }
      ]
    },
    swjgDm: '',
    swjgmc: '',
    jkmHsTjList: [],
    redYelPd: [],
    zbFxYcTj: [],
    scHyQyHs: '',
    wmHyQyHs: '',
    today: '',
    fxLwYy: {},
    onReady: function(){
      try {
        this.swjgDm=avalonRoot.user.swjgDm;
        this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      if (this.params.swjgDm) this.swjgDm = this.params.swjgDm
      this.initTree();
      this.initData();
      this.today = tools.getToday();
      this.initChartsData($('#ckqyfxjkxx-chart1')[0],this.options1)
      this.initChartsData($('#ckqyfxjkxx-chart2')[0],this.options2)
      this.initChartsData($('#ckqyfxjkxx-chart3')[0],this.options3)
      this.initChartsData($('#ckqyfxjkxx-chart4')[0],this.options4)
      this.initChartsData($('#ckqyfxjkxx-chart5')[0],this.options5)
    },
    initData: function(){
      this.jkmpdGetJkmInfo();
      this.jkmpdGetFxYwInfo();
    },
    initChartsData: function(chart, options) {
      if (!chart) return
      chart = echarts.init(chart)
      chart.setOption(options)
      window.addEventListener("resize", () => {
        chart.resize()
      })
    },
    jkmpdGetJkmInfo: function(){
      var self = this
      api.jkmpdGetJkmInfo({swjgDm:this.swjgDm}).done(function(res){
				if(res.code=='0'){
					var jkmHsZb = res.data.jkmHsZb
					var redYelHsZb = res.data.redYelHsZb
          self.jkmHsTjList = res.data.jkmHsTjList
          self.redYelPd = res.data.redYelPd
          for (var i=0;i<self.jkmHsTjList.length;i++) {
            var item = self.jkmHsTjList[i]
            if (item.tsjsfs == '1') {
              self.scHyQyHs = item.hyQyHs
            } else if (item.tsjsfs == '2') {
              self.wmHyQyHs = item.hyQyHs
            } 
          }
          self.jkmpdGetZbInfo();
          self.options1.series[0].data = [
            { value: jkmHsZb.greenNum, name: '绿码' },
            { value: jkmHsZb.yellowNum, name: '黄码' },
            { value: jkmHsZb.redNum, name: '红码' }
          ]
          self.initChartsData($('#ckqyfxjkxx-chart1')[0],self.options1)
          self.options2.series[0].data = [
            { value: redYelHsZb.scYelHs, name: '生产黄码' },
            { value: redYelHsZb.wmYelHs, name: '外贸黄码' },
            { value: redYelHsZb.scRedHs, name: '生产红码' },
            { value: redYelHsZb.wmRedHs, name: '外贸红码' }
          ]
          self.initChartsData($('#ckqyfxjkxx-chart2')[0],self.options2)
				}
			})
    },
    jkmpdGetZbInfo: function(){
      var self = this
      var params = {
        swjgDm: this.swjgDm,
        scHyQyHs: this.scHyQyHs,
        wmHyQyHs: this.wmHyQyHs
      }
      api.jkmpdGetZbInfo(params).done(function(res){
				if(res.code=='0'){
					var zhJkFxSyt = res.data.zhJkFxSyt
          self.zbFxYcTj = res.data.zbFxYcTj
          var tsjsfsMap = {
            '1': '生产',
            '2': '外贸'
          }
          self.options3.series[0].data = [
            {
              value: [zhJkFxSyt[0].xyScore, zhJkFxSyt[0].qtScore, zhJkFxSyt[0].cwScore, zhJkFxSyt[0].fpScore, zhJkFxSyt[0].ckScore, zhJkFxSyt[0].tsScore],
              name: tsjsfsMap[zhJkFxSyt[0].tsjsfs]
            },
            {
              value: [zhJkFxSyt[1].xyScore, zhJkFxSyt[1].qtScore, zhJkFxSyt[1].cwScore, zhJkFxSyt[1].fpScore, zhJkFxSyt[1].ckScore, zhJkFxSyt[1].tsScore],
              name: tsjsfsMap[zhJkFxSyt[1].tsjsfs]
            }
          ]
          self.initChartsData($('#ckqyfxjkxx-chart3')[0],self.options3)
				}
			})
    },
    jkmpdGetFxYwInfo: function(){
      var self = this
      api.jkmpdGetFxYwInfo({swjgDm:this.swjgDm}).done(function(res){
				if(res.code=='0'){
					var fxCkXx = res.data.fxCkXx
					var fxGhXx = res.data.fxGhXx
          self.fxLwYy= res.data.fxLwYy
          var ck = {
            yearMonth: [],
            hs: [],
            je: [],
          }
          for (var i=0;i<fxCkXx.length;i++) {
            ck.yearMonth.push(fxCkXx[i].yearMonth)
            ck.hs.push(fxCkXx[i].hs)
            ck.je.push(fxCkXx[i].je)
          }
          self.options4.xAxis[0].data = ck.yearMonth
          self.options4.series[0].data = ck.hs
          self.options4.series[1].data = ck.je
          self.initChartsData($('#ckqyfxjkxx-chart4')[0],self.options4)
          var gh = {
            yearMonth: [],
            hs: [],
            je: [],
          }
          for (var i=0;i<fxGhXx.length;i++) {
            gh.yearMonth.push(fxGhXx[i].yearMonth)
            gh.hs.push(fxGhXx[i].hs)
            gh.je.push(fxGhXx[i].je)
          }
          self.options5.xAxis[0].data = gh.yearMonth
          self.options5.series[0].data = gh.hs
          self.options5.series[1].data = gh.je
          self.initChartsData($('#ckqyfxjkxx-chart5')[0],self.options5)
				}
			})
    },
		initTree:function() {
			var self = this;
			var setting = {
				callback:{
					onClick:function(e,id,node){
						self.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
            self.initData();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".ckqyfxjkxx .treeDiv"), setting,data);
        var treeObj = $.fn.zTree.getZTreeObj('ckqyfxjkxxZtree');//ztree树的ID
        var node = treeObj.getNodeByParam("id", self.swjgDm);//根据ID找到该节点
        self.swjgmc = node.text
			}).fail(function (err) {
				tools.info(err);
			});
		},
    showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.ckqyfxjkxx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.ckqyfxjkxx').off('click');
		},
    jumpToTysjcxq: function(dtsId){
      avalonRoot.addTab({
        title: "通用数据查询", component: "tysjcxq", params: {
          dtsId: dtsId,
        }
      })
    },
    jumpToSxxmgl: function(){
      avalonRoot.addTab({
        title: "筛选项目管理", component: "sxxmgl", params: {
          doSearch: true, // 跳转完成后执行一次查询
        }
      })
    },
    jumpToShareFa: function(){
      avalonRoot.addTab({
        title: "共享方案查询", component: "shareFaCx", params: {
          doSearch: true, // 跳转完成后执行一次查询
        }
      })
    },
    jumpToQyhxbg: function(){
      avalonRoot.addTab({
        title: "企业画像报告", component: "qyhxbg", params: {
          doSearch: true, // 跳转完成后执行一次查询
        }
      })
    },
  }
}) 