package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.SYS_CFG_TABLE_USER")
public class SysCfgTableUser implements Serializable {
    @Id
    private String user_id;

    @Id
    @Column(name = "T_CODE")
    private String t_code;

    private String cs;

    private String isvaild;

    private Date update_time;

    private Date create_time;

    @Column(name = "F1")
    private String f1;

    @Column(name = "F2")
    private String f2;

    @Column(name = "F3")
    private String f3;

    @Column(name = "F4")
    private String f4;

    @Column(name = "F5")
    private String f5;

    private static final long serialVersionUID = 1L;


    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getT_code() {
        return t_code;
    }

    public void setT_code(String t_code) {
        this.t_code = t_code;
    }

    public String getCs() {
        return cs;
    }

    public void setCs(String cs) {
        this.cs = cs;
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