package com.tl.web.bjts.shzs.model.dto.tseyc;


import com.tl.common.ext.annotation.NotEmpty;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;

/**
 * @Author whg
 * @create 2024/5/8 9:28
 * @description：
 */
public class TseYcInfoQueryDTO {

    /**
     * 申报编号
     */

    private Long sbid;

    @NotEmpty(msg = "流程实例ID不能为空")
    private String lcslid;

    /**
     * 税务机关代码
     */
    private String swjgDm;


    private YwblxxVO ywblxxVO;

    public YwblxxVO getYwblxxVO() {
        return this.ywblxxVO;

    }

    public void setYwblxxVO(YwblxxVO ywblxxVO) {
        this.ywblxxVO = ywblxxVO;
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

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }
}
