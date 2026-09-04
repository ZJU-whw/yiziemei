package com.tl.web.bjts.shzs.utils;

import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletResponse;

import jxl.SheetSettings;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

/**
 * @Author：Mamf
 * @Date: 2017/6/30.
 * @Description:
 */
public class JxlExcelUtil {
    /**
     *
     * @Description: 导出excel
     * @param response
     * @param sheetName
     * @param keyMap
     * @param listContent
     * @param os
     * @param methodMap
     * @param columns_widths
     * @return
     * int
     */
    @SuppressWarnings("unchecked")
    public int getExcelStream(HttpServletResponse response,String sheetName,
                              LinkedHashMap<String, String> keyMap, List<?> listContent,
                              OutputStream os, Map<String, String> methodMap,Integer[] columns_widths) throws Exception{
        int flag = 0;
        // 声明工作簿
        WritableWorkbook workbook;

        // 根据传进来的file对象创建可写入的Excel工作薄
        workbook = Workbook.createWorkbook(os);
        // 创建一个工作表
        WritableSheet ws = workbook.createSheet(sheetName, 0);

        SheetSettings ss = ws.getSettings();
        ss.setVerticalFreeze(1);// 冻结表头

        // 设置字体
        WritableFont NormalFont = new WritableFont(WritableFont.ARIAL, 12);
        WritableFont BoldFont = new WritableFont(WritableFont.ARIAL, 12,
                WritableFont.BOLD);

        // 标题居中
        WritableCellFormat titleFormat = new WritableCellFormat(BoldFont);
        titleFormat.setBorder(Border.ALL, BorderLineStyle.THIN); // 线条
        titleFormat.setVerticalAlignment(VerticalAlignment.CENTRE); // 文字垂直对齐
        titleFormat.setAlignment(Alignment.CENTRE); // 文字水平对齐
        titleFormat.setWrap(false); // 文字是否换行

        // 正文居中
        WritableCellFormat contentCenterFormat = new WritableCellFormat(
                NormalFont);
        contentCenterFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
        contentCenterFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
        contentCenterFormat.setAlignment(Alignment.CENTRE);
        contentCenterFormat.setWrap(false);

        // 正文左对齐
        WritableCellFormat contentLeftFormat = new WritableCellFormat(
                NormalFont);
        contentLeftFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
        contentLeftFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
        contentLeftFormat.setAlignment(Alignment.LEFT);
        contentLeftFormat.setWrap(false);

        // 设置标题,标题内容为keyMap中的value值,标题居中粗体显示
        Iterator<?> titleIter = keyMap.entrySet().iterator();
        int titleIndex = 0;
        while (titleIter.hasNext()) {
            Map.Entry<String, String> entry = (Map.Entry<String, String>) titleIter
                    .next();
            //设置列宽
            ws.setColumnView(titleIndex, columns_widths[titleIndex]);

            ws.addCell(new Label(titleIndex++, 0, entry.getValue(),
                    titleFormat));

        }

        Map.Entry<String, String> entry;
        String key;
        Field field;
        Object content;
        // 设置正文内容
        for (int i = 0; i < listContent.size(); i++) {
            Iterator<?> contentIter = keyMap.entrySet().iterator();
            int colIndex = 0;
            while (contentIter.hasNext()) {
                entry = (Map.Entry<String, String>) contentIter
                        .next();
                key = entry.getKey().toString();
                field = listContent.get(i).getClass()
                        .getDeclaredField(key);
                field.setAccessible(true);
                content = field.get(listContent.get(i));
                String value = "";
                if (null != content) {
                    value = content.toString();
                }
                if (methodMap != null&&content!=null) {
                    String methodName = methodMap.get(key);
                    if (methodName != null) {
                        Method convertMethod = this
                                .getClass()
                                .getDeclaredMethod(methodName, content.getClass());

                        value = (String) convertMethod.invoke(this, content);
                    }
                }
                ws.addCell(new Label(colIndex++, i + 1, value,
                        contentLeftFormat));
            }

        }

        // 宽度自适应。能够根据内容增加宽度，但对中文的支持不好，如果内容中包含中文，会有部分内容被遮盖
        /*for (int i = 0; i < keyMap.size(); i++) {
            CellView cell = ws.getColumnView(i);
            cell.setAutosize(true); //自动宽度
            cell.setSize(30);//最小宽度
        }*/
        // 写入Exel工作表
        workbook.write();

        // 关闭Excel工作薄对象
        workbook.close();

        // 关闭流
        os.flush();
        os.close();
        os = null;

        flag=1;
        return flag;
    }

    private String dateConverter(Date date){

        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

}
