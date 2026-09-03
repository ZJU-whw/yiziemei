package com.tl.bjts.sw.model.enu;

/**
 * @Description: 车牌颜色枚举
 * @Author: sxf
 * @Date: 2026-07-21
 */
public enum CpysEnum {

    BLUE("1", "蓝色"),
    YELLOW("2", "黄色"),
    YELLOW_GREEN("3", "黄绿色");

    private final String code;
    private final String name;

    CpysEnum(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    /**
     * 根据代码获取枚举
     * @param code 颜色代码
     * @return 对应的枚举，未匹配返回null
     */
    public static CpysEnum getByCode(String code) {
        if (code == null) {
            return null;
        }
        for (CpysEnum e : values()) {
            if (e.code.equals(code)) {
                return e;
            }
        }
        return null;
    }

    /**
     * 根据代码获取名称
     * @param code 颜色代码
     * @return 对应的中文名称，未匹配返回null
     */
    public static String getNameByCode(String code) {
        CpysEnum e = getByCode(code);
        return e != null ? e.name : null;
    }
}
