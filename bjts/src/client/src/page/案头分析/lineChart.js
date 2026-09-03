var lineChart = require("./lineChart.html");
avalon.component('lineChart', {
  template: lineChart,
  defaults: {
    fxqq: '',
    fxqz: '',
    hzwd: '',
    uuid: '',
    endDate: '',
    startDate: '',
    hw: '',
    searchData: {
      hzwd: '',
    },
    ctype: '',
    componentName: '',
    onInit: function (e) {
      console.log(this.componentName)

      components[this.componentName] = e.vmodel;
    },
    // onReady: function (e) {
    //  this.search()
    // },
    // 图表数据
    chartData: {
      months: [],
      series: {}
    },
    selectChange() {
      console.log(this.searchData)
      this.search()
    },
    search() {
      var self = this;
      let params = {
        fxqq: self.fxqq + '-01',
        fxqz: self.fxqz + '-' + self.getLastDayOfMonth(self.fxqz),
        uuid: self.uuid
      };
      if (!self.searchData.hzwd) {
        self.searchData.hzwd = self.hzwd
      }
      params.hzwd = self.searchData.hzwd
      ajax("POST", "/cxfw/atfx/jyqk/gyxx", params).done(function (res) {
        if (res.code == '0') {
          self.setChartData(res.data, params);
          self.chartInit()
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    chartInit() {
      // 延迟初始化图表，确保DOM已经渲染
      var self = this;
      setTimeout(function () {
        self.initChart();
        // 确保图表正确调整大小
        setTimeout(function () {
          if (self.businessChart && typeof self.businessChart.resize === 'function') {
            try {
              self.businessChart.resize();
            } catch (e) {
              console.warn('图表调整大小出错:', e);
            }
          }
        }, 100);
      }, 200);
    },
    linkMore() {
      components.atfxCharts.showList({ type: 'lineChart' })
    },
    // 初始化图表
    initChart: function () {
      if (typeof echarts !== 'undefined') {
        var chartDom = document.getElementById(this.componentName)
        if (!chartDom) {
          console.warn('图表容器未找到');
          return;
        }

        // 安全地销毁已存在的图表
        this.disposeChart();

        try {
          var myChart = echarts.init(chartDom);
          this.businessChart = myChart;
          // 构建图例数据和初始选中状态
          var legendData = [];
          var selected = {};
          var series = [];

          // 定义固定颜色
          var seriesColors = {
            '进货(货物)': '#5470c6',
            '进货(服务)': '#91cc75',
            '出口': '#fac858',
            '销售(内销)': '#ee6666',
            '销售(外销)': '#73c0de',
            '退税': '#3ba272',
            '收汇': '#fc8452'
          };


          // 构建系列数据，只包含可见的系列，并应用时间偏移
          // 根据chartType确定图表类型(line: 折线图, bar: 柱状图)
          var chartType = 'line'
          if (this.ctype === 'jh') {
            if (this.hw == 1) {
              var seriesName1 = this.getSeriesNameByKey('jh-hw');
              legendData.push(seriesName1);
              selected[seriesName1] = true;
              series.push({
                name: '进货(货物)',
                type: chartType,
                data: this.chartData.series['jh-hw'],
                itemStyle: { color: seriesColors['进货(货物)'] }
              });
            } else {
              var seriesName2 = this.getSeriesNameByKey('jh-fw');
              legendData.push(seriesName2);
              selected[seriesName2] = true;

              series.push({
                name: '进货(服务)',
                type: chartType,
                data: this.chartData.series['jh-fw'],
                itemStyle: { color: seriesColors['进货(服务)'] }
              });

            }

          } else if (this.ctype === 'xs') {
            var seriesName1 = this.getSeriesNameByKey('xs-nx');
            legendData.push(seriesName1);
            selected[seriesName1] = true;
            var seriesName2 = this.getSeriesNameByKey('xs-wx');
            legendData.push(seriesName2);
            selected[seriesName2] = true;
            series.push({
              name: '销售(内销)',
              type: chartType,
              data: this.chartData.series['xs-nx'],
              itemStyle: { color: seriesColors['销售(内销)'] }
            });
            series.push({
              name: '销售(外销)',
              type: chartType,
              data: this.chartData.series['xs-wx'],
              itemStyle: { color: seriesColors['销售(外销)'] }
            });
          } else {
            let key = this.ctype
            var seriesName = this.getSeriesNameByKey(key);
            legendData.push(seriesName);
            selected[seriesName] = true;
            series.push({
              name: seriesName,
              type: chartType,
              data: this.chartData.series[key],
              itemStyle: { color: seriesColors[seriesName] }
            });
          }

          var option = {
            title: {
              show: false
            },
            tooltip: {
              trigger: 'axis',
              show: true,
              showContent: true,
              alwaysShowContent: false,
              triggerOn: 'mousemove|click',
              confine: true,
              backgroundColor: 'rgba(50,50,50,0.7)',
              textStyle: {
                color: '#fff',
                fontSize: 12
              }
            },
            legend: {
              show: false
            },
            grid: {
              top: '30',
              left: '3%',
              right: '4%',
              bottom: '3%',
              containLabel: true
            },
            xAxis: {
              type: 'category',
              boundaryGap: false,
              data: this.chartData.months
            },
            yAxis: {
              type: 'value',
              name: '元',
              nameLocation: 'end',
              nameGap: 15
            },
            series: series
          };

          myChart.setOption(option);
        } catch (e) {
          console.error('图表初始化出错:', e);
          this.businessChart = null;
        }
      }
    },
    getTitle() {
      if (this.ctype === 'jh') {
        if (this.hw == 1) {
          return '供货金额趋势图'
        } else {
          return '服务费用趋势图'
        }
      } else if (this.ctype === 'xs') {
        return '销售金额趋势图'
      } else if (this.ctype === 'ck') {
        return '报关单出口金额趋势图'
      } else if (this.ctype === 'ts') {
        return '退税申报趋势图'
      } else {
        return '收汇金额趋势图'
      }
    },
    setChartData(data, searchData) {
      this.chartData = {
        months: [],
        series: {}
      }
      let m = this.getMonthsBetween(searchData.fxqq, searchData.fxqz, searchData.hzwd)
      for (let i in data) {
        let arr = []
        for (let j in data[i].qssjMetaList) {
          arr.push(data[i].qssjMetaList[j].tjjg)
        }
        this.chartData.series[data[i].type] = arr
      }
      this.chartData.months = m

    },
    getLastDayOfMonth(dateString) {
      // 分割字符串获取年和月
      const [year, month] = dateString.split('-').map(Number);
      // 注意：month - 1 是因为 JavaScript 中月份是从 0 开始计算的
      return new Date(year, month, 0).getDate();
    },
    getMonthsBetween(startDate, endDate, mode = 'y') {
      const result = [];

      // 确保输入是 yyyy-mm 格式
      const formatStartDate = this.getYearMonth(startDate);
      const formatEndDate = this.getYearMonth(endDate);

      if (!formatStartDate || !formatEndDate) {
        return result;
      }

      // 解析开始和结束日期
      const [startYear, startMonth] = formatStartDate.split('-').map(Number);
      const [endYear, endMonth] = formatEndDate.split('-').map(Number);

      // 创建当前日期对象
      let currentYear = startYear;
      let currentMonth = startMonth;

      // 循环直到超出结束日期
      while (currentYear < endYear || (currentYear === endYear && currentMonth <= endMonth)) {
        let periodStr = '';

        switch (mode) {
          case 'n':
            // 按年分割，只返回年份
            periodStr = `${currentYear}`;
            // 跳到下一年
            currentYear++;
            currentMonth = startMonth;
            // 避免重复添加同一年份
            if (result.includes(periodStr)) {
              continue;
            }
            break;

          case 'j':
            // 按季度分割
            const quarter = Math.ceil(currentMonth / 3);
            periodStr = `${currentYear}-Q${quarter}`;
            // 跳到下一季度
            currentMonth = quarter * 3 + 1;
            if (currentMonth > 12) {
              currentMonth = 1;
              currentYear++;
            }
            // 避免重复添加同一季度
            if (result.includes(periodStr)) {
              continue;
            }
            break;

          case 'y':
          default:
            // 按月分割（默认行为）
            periodStr = `${currentYear}-${currentMonth.toString().padStart(2, '0')}`;
            // 移动到下一个月
            currentMonth++;
            if (currentMonth > 12) {
              currentMonth = 1;
              currentYear++;
            }
            break;
        }

        result.push(periodStr);
      }

      return result;
    },
    // 获取 yyyy-mm 格式的日期
    getYearMonth: function (dateString) {
      if (!dateString) return '';

      // 如果已经是 yyyy-mm 格式，直接返回
      if (/^\d{4}-\d{2}$/.test(dateString)) {
        return dateString;
      }

      // 如果是 yyyy-mm-dd 格式，提取前7位
      if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        return dateString.substring(0, 7);
      }

      // 其他情况返回空字符串
      return '';
    },
    // 安全地销毁图表
    disposeChart: function () {
      if (this.businessChart) {
        try {
          // 检查 dispose 方法是否存在且是函数
          if (this.businessChart.dispose && typeof this.businessChart.dispose === 'function') {
            // 先尝试不带参数调用
            this.businessChart.dispose();
          }
        } catch (e) {
          console.warn('图表销毁出错:', e);
          // 如果出错，尝试其他方式清理
          try {
            // 清理事件监听器
            if (this.businessChart.off && typeof this.businessChart.off === 'function') {
              this.businessChart.off();
            }
          } catch (e2) {
            console.warn('图表事件清理出错:', e2);
          }
        } finally {
          this.businessChart = null;
        }
      }
    },
    getSeriesNameByKey: function (key) {
      var nameMap = {
        'jh-hw': '进货(货物)',
        'jh-fw': '进货(服务)',
        'ck': '出口',
        'xs-nx': '销售(内销)',
        'xs-wx': '销售(外销)',
        'ts': '退税',
        'sh': '收汇'
      };
      return nameMap[key] || '';
    },
  }
});