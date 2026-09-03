package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.SW_TJFX_EXTRA_CKTS")
public class TjfxExtraCkts implements Serializable {
    @Id
    private BigDecimal nd;

    @Id
    private String swcode;

    @Id
    @Column(name = "M_TYPE")
    private String m_type;

    @Column(name = "M1")
    private BigDecimal m1;

    @Column(name = "M2")
    private BigDecimal m2;

    @Column(name = "M3")
    private BigDecimal m3;

    @Column(name = "M4")
    private BigDecimal m4;

    @Column(name = "M5")
    private BigDecimal m5;

    @Column(name = "M6")
    private BigDecimal m6;

    @Column(name = "M7")
    private BigDecimal m7;

    @Column(name = "M8")
    private BigDecimal m8;

    @Column(name = "M9")
    private BigDecimal m9;

    @Column(name = "M10")
    private BigDecimal m10;

    @Column(name = "M11")
    private BigDecimal m11;

    @Column(name = "M12")
    private BigDecimal m12;

    private static final long serialVersionUID = 1L;

    public BigDecimal getNd() {
        return nd;
    }

    public void setNd(BigDecimal nd) {
        this.nd = nd;
    }

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
    }

    public String getM_type() {
        return m_type;
    }

    public void setM_type(String m_type) {
        this.m_type = m_type;
    }

    public BigDecimal getM1() {
        return m1;
    }

    public void setM1(BigDecimal m1) {
        this.m1 = m1;
    }

    public BigDecimal getM2() {
        return m2;
    }

    public void setM2(BigDecimal m2) {
        this.m2 = m2;
    }

    public BigDecimal getM3() {
        return m3;
    }

    public void setM3(BigDecimal m3) {
        this.m3 = m3;
    }

    public BigDecimal getM4() {
        return m4;
    }

    public void setM4(BigDecimal m4) {
        this.m4 = m4;
    }

    public BigDecimal getM5() {
        return m5;
    }

    public void setM5(BigDecimal m5) {
        this.m5 = m5;
    }

    public BigDecimal getM6() {
        return m6;
    }

    public void setM6(BigDecimal m6) {
        this.m6 = m6;
    }

    public BigDecimal getM7() {
        return m7;
    }

    public void setM7(BigDecimal m7) {
        this.m7 = m7;
    }

    public BigDecimal getM8() {
        return m8;
    }

    public void setM8(BigDecimal m8) {
        this.m8 = m8;
    }

    public BigDecimal getM9() {
        return m9;
    }

    public void setM9(BigDecimal m9) {
        this.m9 = m9;
    }

    public BigDecimal getM10() {
        return m10;
    }

    public void setM10(BigDecimal m10) {
        this.m10 = m10;
    }

    public BigDecimal getM11() {
        return m11;
    }

    public void setM11(BigDecimal m11) {
        this.m11 = m11;
    }

    public BigDecimal getM12() {
        return m12;
    }

    public void setM12(BigDecimal m12) {
        this.m12 = m12;
    }
}