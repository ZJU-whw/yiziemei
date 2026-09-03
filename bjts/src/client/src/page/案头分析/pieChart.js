var pieChart = require("./pieChart.html");
avalon.component('pieChart', {
  template: pieChart,
  defaults: {
    fxqq: '',
    fxqz: '',
    hzwd: '',
    uuid: '',
    endDate: '',
    startDate: '',
    url: '',
    componentName: '',
    chartConfigs: [],
    charts: {},
    typeLabels: {
      'gys': '按供应商分类',
      'sp': '按商品分类',
      'kh': '按客户分类',
      'ghs': '按供货商分类',
      'hyd': '按货源地分类',
      'gb': '按收汇国别分类',
      'bz': '按收汇币种分类',
      'myg': '按贸易国分类',
      'mdg': '按目的国分类',
      'ckka': '按口岸分类',
      'jgfs': '按监管方式分类',
      'cjfs': '按成交方式分类',
      'ysfs': '按运输方式分类',
      'cksp': '按出口商品分类',
      'ckkh': '按出口客户分类',
    },
    onInit: function (e) {
      console.log(this.componentName)
      components[this.componentName] = e.vmodel;
    },
    chartDataMap: {},
    linkMore(e) {
      console.log(e)
      components.atfxCharts.showList(e)
    },
    search() {
      var self = this;
      let params = {
        fxqq: self.fxqq + '-01',
        fxqz: self.fxqz + '-' + self.getLastDayOfMonth(self.fxqz),
        hzwd: self.hzwd,
        uuid: self.uuid
      };
      if (self.componentName == 'ckPieChart') {
        params.typeList = ['myg', 'mdg', 'ckka', 'jgfs', 'cjfs', 'ysfs', 'cksp', 'ckkh', 'hyd']
      }
      ajax("POST", self.url, params).done(function (res) {
        if (res.code == '0') {
          self.setChartData(res.data);
          self.chartInit()
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    chartInit() {
      var self = this;
      setTimeout(function () {
        self.initChart();
        setTimeout(function () {
          Object.keys(self.charts).forEach(key => {
            if (self.charts[key] && typeof self.charts[key].resize === 'function') {
              try {
                self.charts[key].resize();
              } catch (e) {
                console.warn(`${key}图表调整大小出错:`, e);
              }
            }
          });
        }, 100);
      }, 200);
    },
    initChart: function () {
      this.disposeChart();
      if (typeof echarts !== 'undefined') {
        this.chartConfigs.forEach(config => {
          this.initSingleChart(config);
        });
      }
    },
    initSingleChart: function (config) {
      var chartDom = document.getElementById(config.id);
      if (!chartDom) {
        console.warn(`图表容器 ${config.id} 未找到`);
        return;
      }
      try {
        var myChart = echarts.init(chartDom);
        this.charts[config.type] = myChart;
        var colorPalette = [
          '#4e79a7', '#f28e2c', '#e15759', '#76b7b2',
          '#59a14f', '#edc948', '#b07aa1', '#ff9da7',
          '#9c755f', '#bab0ac', '#8cd17d', '#f1ce63'
        ];

        var option = {
          tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
          },
          color: colorPalette,
          series: [
            {
              name: config.title,
              type: 'pie',
              radius: ['25%', '55%'],
              avoidLabelOverlap: true,
              itemStyle: {
                borderRadius: 10,
                borderColor: '#fff',
                borderWidth: 2
              },
              label: {
                show: true,
                position: 'outside',
                alignTo: 'labelLine',
                bleedMargin: 5,
                distanceToLabelLine: 5,
                formatter: '{b} ({d}%)',
                overflow: 'truncate',
                width: 80,
                ellipsis: '...',
                fontSize: 12
              },
              labelLine: {
                show: true,
                length: 7,
                maxSurfaceAngle: 90
              },
              data: config.data
            }
          ]
        };
        myChart.setOption(option);
      } catch (e) {
        console.error(`${config.title}图表初始化出错:`, e);
        this.charts[config.type] = null;
      }
    },
    setChartData(data) {
      this.chartDataMap = {};
      this.chartConfigs = [];
      this.charts = {};
      data.forEach(item => {
        if (item.zbMetaList) {
          this.chartDataMap[item.type] = item.zbMetaList.map(dataItem => ({
            name: dataItem.tjz,
            value: dataItem.tjjg
          }));
          this.chartConfigs.push({
            id: this.componentName + '-' + item.type,
            type: item.type,
            title: this.typeLabels[item.type] || item.type,
            data: this.chartDataMap[item.type],
            type: item.type
          });
          console.log(this.componentName, 99)
        }
      });
    },
    getLastDayOfMonth(dateString) {
      const [year, month] = dateString.split('-').map(Number);
      return new Date(year, month, 0).getDate();
    },
    disposeChart: function () {
      Object.keys(this.charts).forEach(key => {
        const chart = this.charts[key];
        if (chart) {
          try {
            if (chart.dispose && typeof chart.dispose === 'function') {
              chart.dispose();
            }
          } catch (e) {
            console.warn(`${key}图表销毁出错:`, e);
            try {
              if (chart.off && typeof chart.off === 'function') {
                chart.off();
              }
            } catch (e2) {
              console.warn(`${key}图表事件清理出错:`, e2);
            }
          }
        }
      });
      this.charts = {};
    }
  }
});