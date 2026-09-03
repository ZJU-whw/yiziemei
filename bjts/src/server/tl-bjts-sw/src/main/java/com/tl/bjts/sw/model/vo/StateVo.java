package com.tl.bjts.sw.model.vo;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/2/29.
 * @Description:
 */
public class StateVo {

    private List<State> states;

    private List<Continent> contis;

    private List<Continent> areas;

    public List<State> getStates() {
        return states;
    }

    public void setStates(List<State> states) {
        this.states = states;
    }

    public List<Continent> getContis() {
        return contis;
    }

    public void setContis(List<Continent> contis) {
        this.contis = contis;
    }

    public List<Continent> getAreas() {
        return areas;
    }

    public void setAreas(List<Continent> areas) {
        this.areas = areas;
    }

    public static  class State{

        private String code;

        private String name;


        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    public class Continent{

        private String code;

        private String name;

        private List<State> states;


        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public List<State> getStates() {
            return states;
        }

        public void setStates(List<State> states) {
            this.states = states;
        }
    }
}
