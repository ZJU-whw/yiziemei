package com.tl.web.bjts.shzs.model.dto.sbxx;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.model.BaseListDTO;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;

import java.util.List;

/**
 * @描述: 查询申报明细表dto
 * @作者: likun
 * @时间: 2022/4/20 16:12
 */
public class SbMxbBaseDTO extends BaseListDTO {
    @NotNull(msg = "申报ID不能为空")
    private Long sbid; // 申报id
    private String sbxh; // 申报序号
    private String spdm; // 商品代码
    private String ckbgdh; // 报关单号
    private String hgcode; // 出口口岸
    private String glh; // 关联号 (外贸免退税使用)
    private String ghfnsrsbh; //供货方税号(外贸免退税使用)
    private String wtqynsrsbh; // 委托企业识别号(外综服代办退税使用)
    private String jhpzh; // 进货凭证号(购进自用货物使用)

    private String lcslid;
    private YwblxxVO ywblxxVo;
    /**
     * 查询类型 1：申报信息或申报明细页面中点击  2：从疑点页面进入  3：从预警页面进入
     */
    @NotEmpty(msg = "查询类型不能为空")
    private String queryType;
    private List<SbMxbYdxxDTO> ydxx; // 疑点参数信息，当queryType=2时，不可为空
    private List<SbMxbYjxxDTO> yjxx; // 预警参数信息，当queryType=3时，不可为空 (只有生产免抵退和外贸免退税时使用)

    /**
     *  根据疑点或者预警组装参数
     */
    private List<String> sbxhList; // 申报序号列表
    private List<String> glhList; // 关联号列表
    private List<String> sbxhWmckList; // 申报序号列表(外贸免退税出口专用)
    private List<String> sbxhWmjhList; // 申报序号列表(外贸免退税进货专用)

    private String sbywdm; // 申报业务表代码

    /**
     *  疑点类
     */
    public class SbMxbYdxxDTO{
        private String glywb1; // 关联项1(业务关键字)
        private String glb; // 关联表

        public String getGlywb1() {
            return glywb1;
        }

        public void setGlywb1(String glywb1) {
            this.glywb1 = glywb1;
        }

        public String getGlb() {
            return glb;
        }

        public void setGlb(String glb) {
            this.glb = glb;
        }
    }

    /**
     *  预警类
     */
    public class SbMxbYjxxDTO{
        private String yjType;
        private String yjObject;
        private String yjRecord;

        public String getYjType() {
            return yjType;
        }

        public void setYjType(String yjType) {
            this.yjType = yjType;
        }

        public String getYjObject() {
            return yjObject;
        }

        public void setYjObject(String yjObject) {
            this.yjObject = yjObject;
        }

        public String getYjRecord() {
            return yjRecord;
        }

        public void setYjRecord(String yjRecord) {
            this.yjRecord = yjRecord;
        }
    }

    public YwblxxVO getYwblxxVo() {
        return this.ywblxxVo;

    }

    public void setYwblxxVo(YwblxxVO ywblxxVo) {
        this.ywblxxVo = ywblxxVo;
    }

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getSbxh() {
        return sbxh;
    }

    public void setSbxh(String sbxh) {
        this.sbxh = sbxh;
    }

    public String getSpdm() {
        return spdm;
    }

    public void setSpdm(String spdm) {
        this.spdm = spdm;
    }

    public String getCkbgdh() {
        return ckbgdh;
    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
    }

    public String getHgcode() {
        return hgcode;
    }

    public void setHgcode(String hgcode) {
        this.hgcode = hgcode;
    }

    public String getGlh() {
        return glh;
    }

    public void setGlh(String glh) {
        this.glh = glh;
    }

    public String getGhfnsrsbh() {
        return ghfnsrsbh;
    }

    public void setGhfnsrsbh(String ghfnsrsbh) {
        this.ghfnsrsbh = ghfnsrsbh;
    }

    public String getWtqynsrsbh() {
        return wtqynsrsbh;
    }

    public void setWtqynsrsbh(String wtqynsrsbh) {
        this.wtqynsrsbh = wtqynsrsbh;
    }

    public String getJhpzh() {
        return jhpzh;
    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }


    public List<String> getSbxhList() {
        return sbxhList;
    }

    public void setSbxhList(List<String> sbxhList) {
        this.sbxhList = sbxhList;
    }

    public List<String> getGlhList() {
        return glhList;
    }

    public void setGlhList(List<String> glhList) {
        this.glhList = glhList;
    }

    public List<SbMxbYdxxDTO> getYdxx() {
        return ydxx;
    }

    public void setYdxx(List<SbMxbYdxxDTO> ydxx) {
        this.ydxx = ydxx;
    }

    public List<SbMxbYjxxDTO> getYjxx() {
        return yjxx;
    }

    public void setYjxx(List<SbMxbYjxxDTO> yjxx) {
        this.yjxx = yjxx;
    }

    public String getSbywdm() {
        return sbywdm;
    }

    public void setSbywdm(String sbywdm) {
        this.sbywdm = sbywdm;
    }

    public List<String> getSbxhWmckList() {
        return sbxhWmckList;
    }

    public void setSbxhWmckList(List<String> sbxhWmckList) {
        this.sbxhWmckList = sbxhWmckList;
    }

    public List<String> getSbxhWmjhList() {
        return sbxhWmjhList;
    }

    public void setSbxhWmjhList(List<String> sbxhWmjhList) {
        this.sbxhWmjhList = sbxhWmjhList;
    }
}
