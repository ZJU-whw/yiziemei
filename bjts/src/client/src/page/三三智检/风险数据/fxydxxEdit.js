var fxydxxEdit = require("./fxydxxEdit.html");
avalon.component("fxydxxEdit", {
  template: fxydxxEdit,
  defaults: {
    params: {
      lcslid: "",
      shxyno: "",
      sssq: "",
    },
    activeIndex: 0,
    fxlyList: [],
    form: {
      baseinfo: {
        flglcd: "",
        nsrmc: "",
        qyhgdm: "",
        qylx: "",
        sb_pc: "",
        sb_ym: "",
        shxy_no: "",
        swjgmc: "",
      },
      ywsxqk: {},
      shqk: {},
      hzqk: {},
      ttkqk: {},
      jxkh: {},
    },
    formData: {
      // ssny: "",
      ssny: "",
      shxyno: "",
      nsrmc: "",
      fxrwlyDm: "",
      fxydcsJh: "",
      spdm2mc: "",
      qylx: "",
      fxrwpcmc:'',
      rwfxqjMycke: "",
      rwfxqjSbmycke: "",
      rwfxqjBltse: "",
      bytscke: "",
      byts: "",
      yzhts: "",
      yzhtscdfs: "",
      stnxzs: "",
      zhts: "",
      pscke: "",
      pstse: "",
      pszhtse: "",
      sfysjc: "N",
      sfhcywt: "0",
      jcpscke: "",
      jcpstse: "",
      jcqrpstse: "",
      jcrktse: "",
      jczhtse: "",
      sfysga: "N",
      fxydyrkje: "",
      fxydrkje: "",
      rwyqsj: "",
      rwwcsj: "",
      bz: "",
      id: "",
      jxsezc: "",
      ybjzzs: "",
      ybjsds: "",
      ybjsds2:'',
      ybjqtsz: "",
    },
    baseData: {
      tbdw: "",
      tbr: "",
      tbrq: "",
    },
    fxrwlyDm:'',
    sfysjc:'',
    sfhcywt: "",
    sfysga:'',
    values:[],
    isOpenTable: false,
    tableNum: 0,
    curFormHeight: 500,
    activeOption: 0, //记录下拉选的下标 所有下拉选通用 选中后需要重置为0
    qymcList: [],
    isFocus: false,
    timer: null,
    onReady: function () {
      $(".fxydxxEdit .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
      $(".fxydxxEdit .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $('.g-autoselect')
      window.addEventListener('resize', this.handleAutoselect);
      this.handleAutoselect();
      this.getFxly();
      if (this.params.row) {
        this.baseData = {
          tbdw: this.params.row.tsswjgMc,
          tbr: this.params.row.tbr,
          tbrq: this.params.row.tbrq,
        };
        this.formData = {
          // ssny: this.params.row.ssny,
          ssny: this.params.row.ssny,
          shxyno: this.params.row.shxyno,
          nsrmc: this.params.row.nsrmc,
          fxrwlyDm: this.params.row.fxrwlyDm,
          fxydcsJh: this.params.row.fxydcsJh,
          spdm2mc: this.params.row.spdm2mc,
          qylx: this.params.row.qylx,
          fxrwpcmc: this.params.row.fxrwpcmc,
          rwfxqjMycke: this.params.row.rwfxqjMycke,
          rwfxqjSbmycke: this.params.row.rwfxqjSbmycke,
          rwfxqjBltse: this.params.row.rwfxqjBltse,
          bytscke: this.params.row.bytscke,
          byts: this.params.row.byts,
          yzhts: this.params.row.yzhts,
          yzhtscdfs: this.params.row.yzhtscdfs,
          stnxzs: this.params.row.stnxzs,
          zhts: this.params.row.zhts,
          pscke: this.params.row.pscke,
          pstse: this.params.row.pstse,
          pszhtse: this.params.row.pszhtse,
          sfysjc: this.params.row.sfysjc?this.params.row.sfysjc:'N',
          sfhcywt: this.params.row.sfhcywt?this.params.row.sfhcywt:'0',
          jcpscke: this.params.row.jcpscke,
          jcpstse: this.params.row.jcpstse,
          jcqrpstse: this.params.row.jcqrpstse,
          jcrktse: this.params.row.jcrktse,
          jczhtse: this.params.row.jczhtse,
          sfysga: this.params.row.sfysga?this.params.row.sfysga:'N',
          fxydyrkje: this.params.row.fxydyrkje,
          fxydrkje: this.params.row.fxydrkje,
          rwyqsj: this.params.row.rwyqsj,
          rwwcsj: this.params.row.rwwcsj,
          bz: this.params.row.bz,
          id: this.params.row.id,
          jxsezc: this.params.row.jxsezc,
          ybjzzs: this.params.row.ybjzzs,
          ybjsds: this.params.row.ybjsds,
          ybjsds2: this.params.row.ybjsds2,
          ybjqtsz: this.params.row.ybjqtsz,
          tbr:this.params.row.tbr
        };
        this.fxlyList.forEach((item) => {
          if (item.DNAME == this.formData.fxrwlyDm) {
            this.formData.fxrwlyDm = item.DCODE;
          }
        });
        var selectList = [
          {
            value:"Y",
            name:'是'
          },
          {
            value:"N",
            name:'否'
          },
          {
            value:"",
            name:''
          },
        ]
        var selectListN = [
          {
            value:"1",
            name:'是'
          },
          {
            value:"0",
            name:'否'
          },
          {
            value:"",
            name:''
          },
        ]
        selectList.forEach(item=>{
          if(item.name == this.formData.sfysjc){
            this.sfysjc = this.formData.sfysjc
            this.formData.sfysjc = item.value;
          }
          if(item.name == this.formData.sfysga){
            this.sfysga = this.formData.sfysga
            this.formData.sfysga = item.value;
          }
        })
        selectListN.forEach(item=>{
          if(item.name == this.formData.sfhcywt){
            this.sfhcywt = this.formData.sfhcywt
            this.formData.sfhcywt = item.value;
          }
        })
        if (this.formData.fxydcsJh) {
          this.values = [];
          this.initMultiselect(this.formData.fxydcsJh);
        }
      } else {
        this.baseData = {
          tbdw: avalonRoot.user.swjgMc,
          tbr: avalonRoot.user.czrymc,
          tbrq: this.getCurrentDate(),
        };
        this.initMultiselect()
      }
    },
    handleAutoselect(){
      $('.g-autoselect').css({
        width: $('.tyshxydm').width()+10+'px',
        left:$('.tyshxydm').offset().left-72+'px',
        top:'23px'
      });
    },
    filMonth: function (e) {
      var date = e.target.value;
      var res = tools.MonCheup(date);
      if (res === false) {
        tools.info("所属期输入错误");
        res = "";
      }
      e.target.value = res;
      return;
    },
    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = "";
      }
      e.target.value = res;
      return;
    },
    getFxly() {
      let self = this;
      ajax("POST", "/cxfw/fxgl/fxly/list", {})
        .done(function (res) {
          if (res.code == "0") {
            self.fxlyList = res.data;
            if (self.params.row) {
              self.fxlyList.forEach((item) => {
                if (item.DNAME == self.formData.fxrwlyDm) {
                  self.fxrwlyDm = self.formData.fxrwlyDm
                  self.formData.fxrwlyDm = item.DCODE;
                }
              });
            }
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    getCurrentDate: function () {
      const now = new Date(); // 创建一个表示当前时间的Date对象
      const year = now.getFullYear(); // 获取年份
      const month = String(now.getMonth() + 1).padStart(2, "0"); // 获取月份（月份是从0开始的，所以要+1），并使用padStart保证是两位数
      const day = String(now.getDate()).padStart(2, "0"); // 获取日，并使用padStart保证是两位数
      return `${year}-${month}-${day}`; // 返回格式化的日期字符串
    },
    printForm: function (e) {
      $(".fxydxxEdit").print();
    },
    count: function (name) {
      var sum = 0;
      for (var i = 0; i < this.form.rows.length; i++) {
        if (!isNaN(this.form.rows[i][name])) {
          sum += this.form.rows[i][name] - 0;
        }
      }
      return sum;
    },
    goBack() {
      avalonRoot.addTab({
        title: "风险应对结果管理",
        component: "fxdyjggl",
        sameCheck: true,
        params: {},
      });
    },
    save(){
      var self = this;
      var valid = this.checkValid(this.formData);
      if (!valid) return;
      api.updateFxyd(this.formData).done(function (res) {
        if (res.code == "0") {
          tools.info("保存成功！");
          // self.hideModel();
          self.goBack();
        }
      });
    },
    checkValid: function (formData) {
      var rules = [
        // { name: "ssny", message: "所属年月不能为空！" },
        { name: "ssny", message: "所属年月批次不能为空！" },
        { name: "fxrwlyDm", message: "请选择风险企业来源！" },
        { name: "shxyno", message: "统一社会信用代码不能为空！" },
        { name: "nsrmc", message: "企业名称不能为空！" },
        // {
        //   name: "rwfxqjMycke",
        //   message: "下发任务分析期间涉及出口额（万美元）不能为空！",
        // },
        // {
        //   name: "rwfxqjSbmycke",
        //   message: "下发任务分析期间涉及申报退税出口额（万美元）不能为空！",
        // },
        // {
        //   name: "rwfxqjBltse",
        //   message: "任务分析期间内办理退税额（万元）不能为空！",
        // },
        { name: "fxydcsJh", message: "请选择风险应对措施！" },
        { name: "sfysjc", message: "请选择是否移送稽查！" },
        { name: "sfhcywt", message: "请选择是否存在问题！" },
        { name: "sfysga", message: "请选择是否移送公安！" },
        // { name: "spdm2mc", message: "涉及商品代码及名称不能为空！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (formData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
    // 多选下拉框
    initMultiselect: function (item) {
      var self = this;
      let id = "#jczlcjb_select_gllb";
      let options = [];
      options = [
        {
          label: "案头分析",
          title: "案头分析",
          value: "案头分析",
          selected: false,
        },
        {
          label: "自查表核查",
          title: "自查表核查",
          value: "自查表核查",
          selected: false,
        },
        {
          label: "函调核查",
          title: "函调核查",
          value: "函调核查",
          selected: false,
        },
        {
          label: "实地核查",
          title: "实地核查",
          value: "实地核查",
          selected: false,
        },
        {
          label: "约谈核实",
          title: "约谈核实",
          value: "约谈核实",
          selected: false,
        },
        {
          label: "其他核查",
          title: "其他核查",
          value: "其他核查",
          selected: false,
        },
      ];
      if (item) {
        let arr = item.split(",");
        options.forEach((item) => {
          if (arr.indexOf(item.label) != -1) {
            item.selected = true;
            self.values.push(item.label);
          }
        });
        self.formData.fxydcsJh = self.values.join(",");
      }
      $(id).multiselect({
        nonSelectedText: "",
        nSelectedText: "项已选择",
        allSelectedText: "全部选中",
        onChange: function (option, checked, select) {
          let val = $(option).val();
          if (checked) {
            self.values.push(val);
          } else {
            let i = self.values.indexOf(val);
            self.values.splice(i, 1);
          }
          self.formData.fxydcsJh = self.values.join(",");
         $('.btn-default').css({
              height: "24px",
            });
        },
      });
      $(id).multiselect("dataprovider", options);
      $('.btn-default').css({
        height: "24px",
      });
    },
    changeOption(event) {
      if (event.key === "ArrowDown") {
        event.preventDefault();
        if (this.activeOption < this.qymcList.length - 1) {
          this.activeOption += 1;
        }
      }
      if (event.key === "ArrowUp") {
        event.preventDefault();
        if (this.activeOption > 0) {
          this.activeOption -= 1;
        }
      }
      if (event.key === "ArrowDown" || event.key === "ArrowUp") {
        let sHeight = $(".g-autoselect").scrollTop();
        let tHeight = 28 * this.activeOption - sHeight;
        if (tHeight >= 168) {
          $(".g-autoselect").scrollTop(28 * this.activeOption - 168);
        }
        if (tHeight <= 0) {
          $(".g-autoselect").scrollTop(28 * this.activeOption);
        }
      }
      if (event.key === "Enter") {
        this.formData.shxyno = this.qymcList[this.activeOption].shxyno;
        this.formData.nsrmc = this.qymcList[this.activeOption].nsrmc;
        this.formData.qylx = this.qymcList[this.activeOption].qylx;
        this.isFocus = false;
        this.qymcList = []
      }
    },
    chooseOption(k) {
      this.formData.shxyno = this.qymcList[k].shxyno;
      this.formData.nsrmc = this.qymcList[k].nsrmc;
      this.formData.qylx = this.qymcList[this.activeOption].qylx;
      this.isFocus = false;
      this.qymcList = []
    },
    getQymc(event) {
      if (
        event.key === "ArrowDown" ||
        event.key === "ArrowUp" ||
        event.key === "Enter"
      ) {
        return;
      }
      this.isFocus = true;
      var shxyno = event.target.value;
      var self = this;
      if (shxyno.length >= 8) {
        clearTimeout(self.timer);
        self.timer = setTimeout(function () {
          ajax("POST", "/cxfw/fxgl/fxyd/nsr/list", { shxyno: shxyno })
            .done(function (res) {
              if (res.code == "0") {
                self.qymcList = res.data;
              } else {
                tools.info(res.msg);
              }
            })
            .fail(function (err) {
              tools.info(err);
            });
        }, 500);
      }
    },
    selectFocus() {
      this.isFocus = true;
      this.handleAutoselect();
    },
    selectBlur() {
      setTimeout(()=>{
        this.isFocus = false;
      },200)
    },
    setActiveOption(k) {
      this.activeOption = k;
    },
  },
});
