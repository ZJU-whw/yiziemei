package com.tl.web.bjts.shzs.model;

/**
 * Created by Neo Lin on 2017/6/19.
 */
public class PageInfo<T> {
    private Integer total;
    private Integer offset;
    private Integer size;
    private T data;

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getOffset() {
        return offset;
    }

    public void setOffset(Integer offset) {
        this.offset = offset;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
