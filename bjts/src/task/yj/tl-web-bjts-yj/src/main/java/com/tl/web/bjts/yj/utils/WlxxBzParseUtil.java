package com.tl.web.bjts.yj.utils;

import org.apache.commons.lang3.StringUtils;

import java.util.Map;

/**
 * @description 物流车牌信息解析类
 * @author: Mamf
 * @date: 2026/6/1 18:15
 */
public class WlxxBzParseUtil {

    public static Map<String, String> parseWlxxFromBz(String bz) {
        Map<String, String> result = new java.util.HashMap<>();
        if (StringUtils.isEmpty(bz)) {
            return result;
        }
        try {
            // 所有可能的关键字作为结束信号
            String allKeywords = "起运地|启运地|车牌号|起运日|启运日";

            // ---------- 第一步：带冒号分隔的匹配 ----------
            boolean hasCph = false;
            java.util.regex.Pattern cphPattern = java.util.regex.Pattern.compile(
                    "车牌号[：:]\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" + // 第一段
                            "(?:\\s*[/、]\\s*(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+)?" + // 可选第二段
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher cphMatcher = cphPattern.matcher(bz);
            if (cphMatcher.find()) {
                result.put("cph", cphMatcher.group(1).trim());
                hasCph = true;
            }

            boolean hasDate = false;
            java.util.regex.Pattern datePattern = java.util.regex.Pattern.compile(
                    "[起启]运日[：:]\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher dateMatcher = datePattern.matcher(bz);
            if (dateMatcher.find()) {
                String dateValue = dateMatcher.group(1).trim();
                String formattedDate = formatDateToStandard(dateValue);
                if (formattedDate != null) {
                    result.put("yqrq", formattedDate);
                    hasDate = true;
                }
            }

            boolean hasAddr = false;
            java.util.regex.Pattern addrPattern = java.util.regex.Pattern.compile(
                    "[起启]运地[：:]\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[\\u4e00-\\u9fa5a-zA-Z0-9（）()])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher addrMatcher = addrPattern.matcher(bz);
            if (addrMatcher.find()) {
                result.put("qyd", addrMatcher.group(1).trim());
                hasAddr = true;
            }

            // ---------- 第二步：无分隔符解析 ----------
            if (!hasCph || !hasDate || !hasAddr) {
                parseWithoutDelimiter(bz, result, hasCph, hasDate, hasAddr, allKeywords);
            }

            // ---------- 第三步：按顺序解析 ----------
            if (!hasCph || !hasDate || !hasAddr) {
                parseBySequence(bz, result, hasCph, hasDate, hasAddr, allKeywords);
            }

            // ---------- 第四步：通用兜底匹配 ----------
            if (result.isEmpty()) {
                tryGenericMatch(bz, result, allKeywords);
            }

        } catch (Exception e) {
            // logger.warn("解析物流信息备注失败：{}", e.getMessage());
        }
        return result;
    }

    // ----------------------------------------------------------------------
    // 无分隔符解析
    // ----------------------------------------------------------------------
    private static void parseWithoutDelimiter(String bz, Map<String, String> result,
                                              boolean hasCph, boolean hasDate, boolean hasAddr,
                                              String allKeywords) {
        if (!hasCph) {
            java.util.regex.Pattern cphPattern = java.util.regex.Pattern.compile(
                    "车牌号?" +
                            "\\s*[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" +
                            "(?:\\s*[/、]\\s*(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+)?" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = cphPattern.matcher(bz);
            if (m.find()) {
                result.put("cph", m.group(1).trim());
                hasCph = true;
            }
        }
        if (!hasDate) {
            java.util.regex.Pattern datePattern = java.util.regex.Pattern.compile(
                    "[起启]运日" +
                            "\\s*[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = datePattern.matcher(bz);
            if (m.find()) {
                String dv = m.group(1).trim();
                String formatted = formatDateToStandard(dv);
                if (formatted != null) {
                    result.put("yqrq", formatted);
                    hasDate = true;
                }
            }
        }
        if (!hasAddr) {
            java.util.regex.Pattern addrPattern = java.util.regex.Pattern.compile(
                    "[起启]运地" +
                            "\\s*[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[\\u4e00-\\u9fa5a-zA-Z0-9（）()])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = addrPattern.matcher(bz);
            if (m.find()) {
                result.put("qyd", m.group(1).trim());
                hasAddr = true;
            }
        }
        if (!hasCph || !hasDate || !hasAddr) {
            parseRelaxed(bz, result, hasCph, hasDate, hasAddr, allKeywords);
        }
    }

    // ----------------------------------------------------------------------
    // 按顺序解析（利用关键词位置）
    // ----------------------------------------------------------------------
    private static void parseBySequence(String bz, Map<String, String> result,
                                        boolean hasCph, boolean hasDate, boolean hasAddr,
                                        String allKeywords) {
        String[] allKeywordArr = {"起运地", "启运地", "车牌号", "起运日", "启运日"};
        java.util.List<java.util.AbstractMap.SimpleEntry<Integer, String[]>> positions = new java.util.ArrayList<>();
        if (!hasCph) {
            int idx = bz.indexOf("车牌号");
            if (idx >= 0) positions.add(new java.util.AbstractMap.SimpleEntry<>(idx, new String[]{"车牌号", "cph"}));
        }
        if (!hasDate) {
            for (String kw : new String[]{"起运日", "启运日"}) {
                int idx = bz.indexOf(kw);
                if (idx >= 0) { positions.add(new java.util.AbstractMap.SimpleEntry<>(idx, new String[]{kw, "yqrq"})); break; }
            }
        }
        if (!hasAddr) {
            for (String kw : new String[]{"起运地", "启运地"}) {
                int idx = bz.indexOf(kw);
                if (idx >= 0) { positions.add(new java.util.AbstractMap.SimpleEntry<>(idx, new String[]{kw, "qyd"})); break; }
            }
        }
        positions.sort(java.util.Map.Entry.comparingByKey());

        for (int i = 0; i < positions.size(); i++) {
            java.util.AbstractMap.SimpleEntry<Integer, String[]> entry = positions.get(i);
            String kw = entry.getValue()[0];
            String field = entry.getValue()[1];
            int valueStart = entry.getKey() + kw.length();
            while (valueStart < bz.length() && "：: ".indexOf(bz.charAt(valueStart)) >= 0) {
                valueStart++;
            }
            int valueEnd = bz.length();
            // 截止到下一个关键词位置
            for (int j = i + 1; j < positions.size(); j++) {
                int nxt = positions.get(j).getKey();
                if (nxt > valueStart) { valueEnd = Math.min(valueEnd, nxt); }
            }
            // 也检查所有其他关键词（防止非顺序出现）
            for (String otherKw : allKeywordArr) {
                if (otherKw.equals(kw)) continue;
                int pos = bz.indexOf(otherKw, valueStart);
                if (pos > valueStart && pos < valueEnd) {
                    valueEnd = pos;
                }
            }
            // 查找第一个分隔符（空格、逗号等）
            for (int pos = valueStart; pos < valueEnd; pos++) {
                char c = bz.charAt(pos);
                if (c == ' ' || c == '\t' || c == '，' || c == ',' || c == '、' || c == '：' || c == ':' || c == '；' || c == ';') {
                    valueEnd = pos;
                    break;
                }
            }
            String value = bz.substring(valueStart, valueEnd).replaceAll("[\\s，,、:：;；]+$", "").trim();
            if (!value.isEmpty()) {
                value = removeTrailingKeywords(value, allKeywords);
                if ("yqrq".equals(field)) {
                    String fmt = formatDateToStandard(value);
                    if (fmt != null) result.put(field, fmt);
                } else {
                    result.put(field, value);
                }
            }
        }
    }

    // ----------------------------------------------------------------------
    // 宽松匹配（车牌、日期模式直接提取）
    // ----------------------------------------------------------------------
    private static void parseRelaxed(String bz, Map<String, String> result,
                                     boolean hasCph, boolean hasDate, boolean hasAddr,
                                     String allKeywords) {
        if (!hasCph) {
            java.util.regex.Pattern cphPattern = java.util.regex.Pattern.compile(
                    "([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤川青藏琼宁使领][A-Z][A-Z0-9]{4,6}[警学挂港澳领]?" +
                            "(?:\\s*[/、]\\s*[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤川青藏琼宁使领][A-Z][A-Z0-9]{4,6}[警学挂港澳领]?)?)"
            );
            java.util.regex.Matcher m = cphPattern.matcher(bz);
            if (m.find()) {
                String value = m.group(1).trim();
                value = removeTrailingKeywords(value, allKeywords);
                result.put("cph", value);
            }
        }
        if (!hasDate) {
            java.util.regex.Pattern datePattern = java.util.regex.Pattern.compile(
                    "(\\d{4}[-/年.]\\d{1,2}[-/月.]\\d{1,2}[日号]?)"
            );
            java.util.regex.Matcher m = datePattern.matcher(bz);
            if (m.find()) {
                String dv = m.group(1).trim();
                dv = removeTrailingKeywords(dv, allKeywords);
                String formatted = formatDateToStandard(dv);
                if (formatted != null) result.put("yqrq", formatted);
            }
        }
    }

    // ----------------------------------------------------------------------
    // 通用兜底匹配
    // ----------------------------------------------------------------------
    private static void tryGenericMatch(String bz, Map<String, String> result, String allKeywords) {
        if (!result.containsKey("cph")) {
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(
                    "车牌[号]?[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" +
                            "(?:\\s*[/、]\\s*(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+)?" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = p.matcher(bz);
            if (m.find()) {
                String value = m.group(1);
                if (StringUtils.isNotEmpty(value)) {
                    value = removeTrailingKeywords(value, allKeywords);
                    result.put("cph", value.trim());
                }
            }
        }
        if (!result.containsKey("yqrq")) {
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(
                    "[起启]运日[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[^\\s，,、:：;；])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = p.matcher(bz);
            if (m.find()) {
                String dv = m.group(1).trim();
                dv = removeTrailingKeywords(dv, allKeywords);
                String formatted = formatDateToStandard(dv);
                if (formatted != null) result.put("yqrq", formatted);
            }
        }
        if (!result.containsKey("qyd")) {
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(
                    "[起启]运地[：:]?\\s*" +
                            "(" +
                            "(?:(?!" + allKeywords + ")[\\u4e00-\\u9fa5a-zA-Z0-9（）()])+" +
                            ")" +
                            "(?=\\s|[，,、:：;；]|" + allKeywords + "|$)"
            );
            java.util.regex.Matcher m = p.matcher(bz);
            if (m.find()) {
                String value = m.group(1).trim();
                if (StringUtils.isNotEmpty(value)) {
                    result.put("qyd", value);
                }
            }
        }
    }

    // ----------------------------------------------------------------------
    // 辅助方法
    // ----------------------------------------------------------------------
    private static String removeTrailingKeywords(String value, String allKeywords) {
        if (value == null || value.isEmpty()) return value;
        java.util.regex.Pattern p = java.util.regex.Pattern.compile("^(.*?)(" + allKeywords + ")?$");
        java.util.regex.Matcher m = p.matcher(value);
        if (m.find() && m.group(1) != null) {
            return m.group(1).trim();
        }
        return value;
    }

    private static String formatDateToStandard(String dateStr) {
        if (StringUtils.isEmpty(dateStr)) return null;
        dateStr = dateStr.trim();
        if (dateStr.matches("\\d{4}-\\d{2}-\\d{2}")) return dateStr;
        try {
            String[][] formats = {
                    {"\\d{4}-\\d{1,2}-\\d{1,2}", "yyyy-M-d"},
                    {"\\d{4}年\\d{1,2}月\\d{1,2}日", "yyyy年M月d日"},
                    {"\\d{4}/\\d{1,2}/\\d{1,2}", "yyyy/M/d"},
                    {"\\d{4}\\.\\d{1,2}\\.\\d{1,2}", "yyyy.M.d"},
                    {"\\d{8}", "yyyyMMdd"},
                    {"\\d{4}年\\d{1,2}月\\d{1,2}号", "yyyy年M月d号"}
            };
            for (String[] fmt : formats) {
                if (dateStr.matches(fmt[0])) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(fmt[1]);
                    java.util.Date d = sdf.parse(dateStr);
                    return new java.text.SimpleDateFormat("yyyy-MM-dd").format(d);
                }
            }
        } catch (Exception ignored) {}
        // 正则兜底
        java.util.regex.Pattern p = java.util.regex.Pattern.compile("(\\d{4})\\D*(\\d{1,2})\\D*(\\d{1,2})");
        java.util.regex.Matcher m = p.matcher(dateStr);
        if (m.find()) {
            try {
                int y = Integer.parseInt(m.group(1));
                int mo = Integer.parseInt(m.group(2));
                int d = Integer.parseInt(m.group(3));
                if (mo >= 1 && mo <= 12 && d >= 1 && d <= 31) {
                    return String.format("%04d-%02d-%02d", y, mo, d);
                }
            } catch (Exception ignored) {}
        }
        return null;
    }


//    public static void main(String[] args) {
////        Map<String, String> stringStringMap = WlxxBzParseUtil.parseWlxxFromBz("车牌号：皖KZ2817浙B073K挂起运地绍兴柯桥,起运日2023年10月10日");
////        System.out.println(stringStringMap);
//    }
}
