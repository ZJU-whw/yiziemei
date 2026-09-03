package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 最终目的国区域对照表查询DTO
 */
public class YjGbcodeDTO extends BaseListDTO {
    
    /** 国别代码 */
    private String gbCode;
    
    /** 国别名称 */
    private String gbName;
    
    /** 国别英文名 */
    private String gbEname;

    /** 国际地区代码 */
    private String gjqycode;

    /** 国际地区名称 */
    private String gjqyname;


    public String getGjqycode() {
        return this.gjqycode;

    }

    public void setGjqycode(String gjqycode) {
        this.gjqycode = gjqycode;
    }

    public String getGjqyname() {
        return this.gjqyname;

    }

    public void setGjqyname(String gjqyname) {
        this.gjqyname = gjqyname;
    }

    public String getGbCode() {
        return gbCode;
    }

    public void setGbCode(String gbCode) {
        this.gbCode = gbCode;
    }

    public String getGbName() {
        return gbName;
    }

    public void setGbName(String gbName) {
        this.gbName = gbName;
    }

    public String getGbEname() {
        return gbEname;
    }

    public void setGbEname(String gbEname) {
        this.gbEname = gbEname;
    }
}