var jdglinfo = {}
jdglinfo.tslv = [
  { code: '17', name: '17%' },
  { code: '16', name: '16%' },
  { code: '15', name: '15%' },
  { code: '13', name: '13%' },
  { code: '11', name: '11%' },
  { code: '10', name: '10%' },
  { code: '9', name: '9%' },
  { code: '6', name: '6%' },
  { code: '5', name: '5%' },
  { code: '3', name: '3%' },
  { code: '1', name: '1%' },
  { code: '0', name: '0' }
]

jdglinfo.ckspList = [
  { name: '大类', value: 'cksp.01', key: '出口商品（大类）'},
  { name: '章（2位）', value: 'cksp.02', key: '出口商品（章）'},
  { name: '节（4位）', value: 'cksp.04', key: '出口商品（节）'},
  { name: '8位代码', value: 'cksp.08', key: '出口商品（8位代码）'},
  { name: '10位代码', value: 'cksp.10', key: '出口商品（10位代码）'},
]

// 企业规模
jdglinfo.qygmList = [
  {
    val: 'A',
    label: '大(年出口1亿美元及以上)',
  },
  {
    val: 'B',
    label: '中+(年出口5千万美元及以上)',
  },
  {
    val: 'C',
    label: '中-(年出口1千万美元及以上)',
  },
  {
    val: 'D',
    label: '小(年出口1百万美元及以上)',
  },
  {
    val: 'E',
    label: '微(年出口1百万美元以下)',
  },
]

module.exports = jdglinfo;