package com.tl.bjts.sw.model.vo.jcfx;

import java.io.Serializable;
import java.util.*;

/**
 * @author: Mamf
 * @date: 2021/11/9
 * @description
 */
public class SelectItemVo implements Serializable {

    private String code;

    private String name;

    private String level;

    private String pLevel;

    private String parentId;

    private boolean checked;

    private List<SelectItemVo>  item;

    public String getLevel() {
        return this.level;

    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getpLevel() {
        return this.pLevel;

    }

    public void setpLevel(String pLevel) {
        this.pLevel = pLevel;
    }

    public boolean getChecked() {
        return this.checked;

    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public String getParentId() {
        return this.parentId;

    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public List<SelectItemVo> getItem() {
        return this.item;

    }

    public void setItem(List<SelectItemVo> item) {
        this.item = item;
    }

    public String getCode() {
        return this.code;

    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return this.getCode()+" "+this.name;

    }

    public void setName(String name) {
        this.name = name;
    }


    public void sortChildren() {
        if (item==null){
            return;
        }
        Collections.sort(item, new Comparator<SelectItemVo>() {
            @Override
            public int compare(SelectItemVo menu1, SelectItemVo menu2) {
                int result ;

                String code1 = menu1.getCode();
                String code2 = menu2.getCode();

                result = (code1.compareTo(code2)<0 ? -1 : (code1.compareTo(code2)==0 ? 0 : 1));
                return result;
            }

        });
        // 对每个节点的下一层节点进行排序
        for (Iterator<SelectItemVo> it = item.iterator(); it.hasNext();) {
            it.next().sortChildren();
        }
    }
}
