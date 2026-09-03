package com.tl.bjts.sw.model.domain;

import com.tl.common.ext.annotation.ExcelSetting;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.SYS_CFG_TABLE_COLUMN")
public class SysCfgTableColumn implements Serializable {
    @ExcelSetting(colTitleName = "T_CODE", isFirst = true, nextColName = "t_c_code")
    @Column(name = "T_CODE")
    private String t_code;

    @ExcelSetting(colTitleName = "T_C_CODE",  nextColName = "t_c_name")
    @Column(name = "T_C_CODE")
    private String t_c_code;

    @ExcelSetting(colTitleName = "T_C_NAME",  nextColName = "c_min_size")
    @Column(name = "T_C_NAME")
    private String t_c_name;

    @ExcelSetting(colTitleName = "C_MIN_SIZE",  nextColName = "c_max_size")
    @Column(name = "C_MIN_SIZE")
    private BigDecimal c_min_size;

    @ExcelSetting(colTitleName = "C_MAX_SIZE",  nextColName = "c_std_size")
    @Column(name = "C_MAX_SIZE")
    private BigDecimal c_max_size;

    @ExcelSetting(colTitleName = "C_STD_SIZE",  nextColName = "no")
    @Column(name = "C_STD_SIZE")
    private BigDecimal c_std_size;

    @ExcelSetting(colTitleName = "no",  nextColName = "is_fixed")
    private BigDecimal no;

    @ExcelSetting(colTitleName = "is_fixed",  nextColName = "is_order")
    private String is_fixed;

    @ExcelSetting(colTitleName = "is_order",  nextColName = "align")
    private String is_order;

    @ExcelSetting(colTitleName = "align",  nextColName = "isvaild")
    private String align;

    @ExcelSetting(colTitleName = "isvaild",  nextColName = "update_time")
    private String isvaild;

    @ExcelSetting(colTitleName = "update_time",  nextColName = "create_time")
    private Date update_time;

    @ExcelSetting(colTitleName = "create_time",  nextColName = "f1")
    private Date create_time;

    @ExcelSetting(colTitleName = "F1",  nextColName = "f2")
    @Column(name = "F1")
    private String f1;

    @ExcelSetting(colTitleName = "F2",  nextColName = "f3")
    @Column(name = "F2")
    private String f2;

    @ExcelSetting(colTitleName = "F3",  nextColName = "f4")
    @Column(name = "F3")
    private String f3;

    @ExcelSetting(colTitleName = "F4",  nextColName = "f5")
    @Column(name = "F4")
    private String f4;

    @ExcelSetting(colTitleName = "F5",  isLast = true)
    @Column(name = "F5")
    private String f5;

//    private static final long serialVersionUID = 1L;

    public String getT_code() {
        return t_code;
    }

    public void setT_code(String t_code) {
        this.t_code = t_code;
    }

    public String getT_c_code() {
        return t_c_code;
    }

    public void setT_c_code(String t_c_code) {
        this.t_c_code = t_c_code;
    }

    public String getT_c_name() {
        return t_c_name;
    }

    public void setT_c_name(String t_c_name) {
        this.t_c_name = t_c_name;
    }

    public BigDecimal getC_min_size() {
        return c_min_size;
    }

    public void setC_min_size(BigDecimal c_min_size) {
        this.c_min_size = c_min_size;
    }

    public BigDecimal getC_max_size() {
        return c_max_size;
    }

    public void setC_max_size(BigDecimal c_max_size) {
        this.c_max_size = c_max_size;
    }

    public BigDecimal getC_std_size() {
        return c_std_size;
    }

    public void setC_std_size(BigDecimal c_std_size) {
        this.c_std_size = c_std_size;
    }

    public BigDecimal getNo() {
        return no;
    }

    public void setNo(BigDecimal no) {
        this.no = no;
    }

    public String getIs_fixed() {
        return is_fixed;
    }

    public void setIs_fixed(String is_fixed) {
        this.is_fixed = is_fixed;
    }

    public String getIs_order() {
        return is_order;
    }

    public void setIs_order(String is_order) {
        this.is_order = is_order;
    }

    public String getAlign() {
        return align;
    }

    public void setAlign(String align) {
        this.align = align;
    }

    public String getIsvaild() {
        return isvaild;
    }

    public void setIsvaild(String isvaild) {
        this.isvaild = isvaild;
    }

    public Date getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(Date update_time) {
        this.update_time = update_time;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }

    public String getF1() {
        return f1;
    }

    public void setF1(String f1) {
        this.f1 = f1;
    }

    public String getF2() {
        return f2;
    }

    public void setF2(String f2) {
        this.f2 = f2;
    }

    public String getF3() {
        return f3;
    }

    public void setF3(String f3) {
        this.f3 = f3;
    }

    public String getF4() {
        return f4;
    }

    public void setF4(String f4) {
        this.f4 = f4;
    }

    public String getF5() {
        return f5;
    }

    public void setF5(String f5) {
        this.f5 = f5;
    }
}