package com.tl.bjts.sw.model.vo;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
public class MenuVo {

    List<Menu> menuList;

    public List<Menu> getMenuList() {
        return menuList;
    }

    public void setMenuList(List<Menu> menuList) {
        this.menuList = menuList;
    }

    public class Menu{

        private String bbdm;

        private String bbmc;

        private List<Menu> sublist;

        public String getBbdm() {
            return bbdm;
        }

        public void setBbdm(String bbdm) {
            this.bbdm = bbdm;
        }

        public String getBbmc() {
            return bbmc;
        }

        public void setBbmc(String bbmc) {
            this.bbmc = bbmc;
        }

        public List<Menu> getSublist() {
            return sublist;
        }

        public void setSublist(List<Menu> sublist) {
            this.sublist = sublist;
        }
    }
}
