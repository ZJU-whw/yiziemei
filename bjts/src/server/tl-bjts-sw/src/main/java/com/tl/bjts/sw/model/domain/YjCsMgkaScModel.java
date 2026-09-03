package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_MGKA_SC")
public class YjCsMgkaScModel implements Serializable {
    @Id
    @Column(name = "KACODE")
    private String kacode;

    @Column(name = "KANAME")
    private String kaname;

    @Column(name = "SHENG")
    private String sheng;

    @Column(name = "YXBZ")
    private String yxbz;

    private static final long serialVersionUID = 1L;

    /**
     * @return KACODE
     */
    public String getKacode() {
        return kacode;
    }

    /**
     * @param kacode
     */
    public void setKacode(String kacode) {
        this.kacode = kacode == null ? null : kacode.trim();
    }

    /**
     * @return KANAME
     */
    public String getKaname() {
        return kaname;
    }

    /**
     * @param kaname
     */
    public void setKaname(String kaname) {
        this.kaname = kaname == null ? null : kaname.trim();
    }

    /**
     * @return SHENG
     */
    public String getSheng() {
        return sheng;
    }

    /**
     * @param sheng
     */
    public void setSheng(String sheng) {
        this.sheng = sheng == null ? null : sheng.trim();
    }

    /**
     * @return YXBZ
     */
    public String getYxbz() {
        return yxbz;
    }

    /**
     * @param yxbz
     */
    public void setYxbz(String yxbz) {
        this.yxbz = yxbz == null ? null : yxbz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", kacode=").append(kacode);
        sb.append(", kaname=").append(kaname);
        sb.append(", sheng=").append(sheng);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}