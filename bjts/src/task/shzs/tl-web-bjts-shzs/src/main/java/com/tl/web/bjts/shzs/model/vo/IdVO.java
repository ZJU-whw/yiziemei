package com.tl.web.bjts.shzs.model.vo;

/**
 * @描述: 返回id对象
 * @作者: likun
 * @时间: 2022/2/10 15:48
 */
public class IdVO {
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "IdVO{" +
                "id=" + id +
                '}';
    }
}
