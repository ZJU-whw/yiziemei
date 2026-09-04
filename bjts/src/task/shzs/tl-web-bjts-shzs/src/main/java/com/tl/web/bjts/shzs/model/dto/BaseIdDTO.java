package com.tl.web.bjts.shzs.model.dto;

import com.tl.common.ext.annotation.NotNull;

/**
 * @描述: id通用dto
 * @作者: likun
 * @时间: 2022/4/24 10:35
 */
public class BaseIdDTO {
    @NotNull(msg = "参数id不能为空")
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
