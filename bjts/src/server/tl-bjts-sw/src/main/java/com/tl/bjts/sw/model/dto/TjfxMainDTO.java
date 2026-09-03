package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NeedCheck;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/2/29.
 * @Description:
 */
public class TjfxMainDTO extends BaseListDTO{


    @NotEmpty
    private String bbdm;

    private String swjgdm;  //当前登录人税务机关代码（暂用户计算HASH值时区分）

    private String pramHash;

    private boolean haveSc;

    private boolean haveWm;

    private boolean haveWzf;

    private boolean haveGbcode;

    private boolean haveSpmlcode;

    private boolean haveTslcode;

    private boolean haveDqcode;

    private boolean export;


    @NeedCheck
    private DlspDTO cxtjDTO; //分大类商品

    public class DlspDTO{

        @NotEmpty
        private String swjgDm;

        private String swjgMc;

        private String ny;
        private List<String> qylx; //1,生产企业 2,外贸企业

        @NotEmpty(msg = "出口时间起止不能为空")
        private Date cksjStart;

        @NotEmpty(msg = "出口时间起止不能为空")
        private Date cksjEnd;

        private List<String> gbcode;

        private List<String> dqcode;

        private List<String> tslcode;

        private List<String> spmlcode;

        private String tjlx; // 1.按国家，2按大洲 3 按经济体

        private String pmlx; //1.按出口额，2.按退税额

        private String tjkj;  //1.审核通过数，2.报关单收到数

        private String xzqh;

        private String sjxzqh;


        private String qylxMc;
        private String gjmc;

        private String qyhgdm;//企业海关代码
        private String cmcode;//商品代码

        private String refresh;//是否刷新统计

        public String getSwjgMc() {
            return swjgMc;
        }

        public void setSwjgMc(String swjgMc) {
            this.swjgMc = swjgMc;
        }

        public String getQylxMc() {
            return qylxMc;
        }

        public void setQylxMc(String qylxMc) {
            this.qylxMc = qylxMc;
        }

        public String getGjmc() {
            return gjmc;
        }

        public void setGjmc(String gjmc) {
            this.gjmc = gjmc;
        }

        public String getXzqh() {
            return xzqh;
        }

        public void setXzqh(String xzqh) {
            this.xzqh = xzqh;
        }

        public String getSjxzqh() {
            return sjxzqh;
        }

        public void setSjxzqh(String sjxzqh) {
            this.sjxzqh = sjxzqh;
        }

        public String getTjkj() {
            return tjkj;
        }

        public void setTjkj(String tjkj) {
            this.tjkj = tjkj;
        }

        public String getPmlx() {
            return pmlx;
        }

        public void setPmlx(String pmlx) {
            this.pmlx = pmlx;
        }

        public List<String> getTslcode() {
            return tslcode;
        }

        public void setTslcode(List<String> tslcode) {
            this.tslcode = tslcode;
        }

        public List<String> getSpmlcode() {
            return spmlcode;
        }

        public void setSpmlcode(List<String> spmlcode) {
            this.spmlcode = spmlcode;
        }

        public String getTjlx() {
            return tjlx;
        }

        public void setTjlx(String tjlx) {
            this.tjlx = tjlx;
        }




        public String getSwjgDm() {
            return swjgDm;
        }

        public void setSwjgDm(String swjgDm) {
            this.swjgDm = swjgDm;
        }

        public List<String> getQylx() {
            return qylx;
        }

        public void setQylx(List<String> qylx) {
            this.qylx = qylx;
        }

        public Date getCksjStart() {
            return cksjStart;
        }

        public void setCksjStart(Date cksjStart) {
            this.cksjStart = cksjStart;
        }

        public Date getCksjEnd() {
            return cksjEnd;
        }

        public void setCksjEnd(Date cksjEnd) {
            this.cksjEnd = cksjEnd;
        }

        public List<String> getGbcode() {
            return gbcode;
        }

        public void setGbcode(List<String> gbcode) {
            this.gbcode = gbcode;
        }

        public List<String> getDqcode() {
            return dqcode;
        }

        public void setDqcode(List<String> dqcode) {
            this.dqcode = dqcode;
        }

        public String getQyhgdm() {
            return qyhgdm;
        }

        public void setQyhgdm(String qyhgdm) {
            this.qyhgdm = qyhgdm;
        }

        public String getCmcode() {
            return cmcode;
        }

        public void setCmcode(String cmcode) {
            this.cmcode = cmcode;
        }

        public String getRefresh() {
            return refresh;
        }

        public void setRefresh(String refresh) {
            this.refresh = refresh;
        }

        public String getNy() {
            return ny;
        }

        public void setNy(String ny) {
            this.ny = ny;
        }
    }


    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public DlspDTO getCxtjDTO() {
        return cxtjDTO;
    }

    public void setCxtjDTO(DlspDTO cxtjDTO) {
        this.cxtjDTO = cxtjDTO;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getPramHash() {
        return pramHash;
    }

    public void setPramHash(String pramHash) {
        this.pramHash = pramHash;
    }


    public boolean isHaveSc() {
        return haveSc;
    }

    public void setHaveSc(boolean haveSc) {
        this.haveSc = haveSc;
    }

    public boolean isHaveWm() {
        return haveWm;
    }

    public void setHaveWm(boolean haveWm) {
        this.haveWm = haveWm;
    }

    public boolean isHaveWzf() {
        return haveWzf;
    }

    public void setHaveWzf(boolean haveWzf) {
        this.haveWzf = haveWzf;
    }

    public boolean isExport() {
        return export;
    }

    public void setExport(boolean export) {
        this.export = export;
    }


    public boolean isHaveGbcode() {
        return haveGbcode;
    }

    public void setHaveGbcode(boolean haveGbcode) {
        this.haveGbcode = haveGbcode;
    }

    public boolean isHaveSpmlcode() {
        return haveSpmlcode;
    }

    public void setHaveSpmlcode(boolean haveSpmlcode) {
        this.haveSpmlcode = haveSpmlcode;
    }

    public boolean isHaveTslcode() {
        return haveTslcode;
    }

    public void setHaveTslcode(boolean haveTslcode) {
        this.haveTslcode = haveTslcode;
    }

    public boolean isHaveDqcode() {
        return haveDqcode;
    }

    public void setHaveDqcode(boolean haveDqcode) {
        this.haveDqcode = haveDqcode;
    }


}
