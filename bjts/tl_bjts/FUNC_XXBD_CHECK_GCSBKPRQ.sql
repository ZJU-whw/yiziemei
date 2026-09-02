CREATE OR REPLACE FUNCTION FUNC_XXBD_CHECK_GCSBKPRQ(V_KPRQ IN DATE)
  RETURN NUMBER
/*
 * 编 制 人: 严国平
 * 编制日期: 20210915
 * 功    能: 检查采购国产设备退税普通发票开票日期是否符合退税政策
 * 返 回 值：1符合，0不符合
 * 退税政策：企业申报国产设备退税的凭证种类是增值税普通发票，申报的开票日期需在下列区间
 *   (1) 2016.1.1-2017.3.14
 *   (2) 2019.1.1-2020.3.1
 *   (3) 2021.1.1-2021.6.22 
 */
AS
BEGIN
  IF V_KPRQ>=DATE'2016-01-01' AND V_KPRQ<=DATE'2017-03-14' THEN
    RETURN 1;
  END IF;
  IF V_KPRQ>=DATE'2019-01-01' AND V_KPRQ<=DATE'2020-03-01' THEN
    RETURN 1;
  END IF;
  IF V_KPRQ>=DATE'2021-01-01' AND V_KPRQ<=DATE'2021-06-22' THEN
    RETURN 1;
  END IF;
  RETURN 0;
END;
/
