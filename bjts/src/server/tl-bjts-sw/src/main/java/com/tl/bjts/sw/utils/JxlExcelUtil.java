package com.tl.bjts.sw.utils;

import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.domain.TjbbHeaderModel;
import com.tl.bjts.sw.model.domain.TjbbReportModel;
import com.tl.bjts.sw.model.domain.TjbbTbxx;
import com.tl.bjts.sw.model.dto.SuitExcelDTO;
import com.tl.bjts.sw.model.dto.TbxxExtDTO;
import com.tl.bjts.sw.model.dto.TjbbColModelDTO;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.common.ext.utils.StringUtils;
import jxl.*;
import jxl.Cell;
import jxl.CellType;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.VerticalAlignment;
import jxl.read.biff.BiffException;
import jxl.write.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jxl.write.Number;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


/**
 * @Author：Mamf
 * @Date: 2017/6/30.
 * @Description:
 */
@Service
public class JxlExcelUtil {

    @Autowired
    private TjbbBasisService basisService;

    @Autowired
    private CommonServiceImpl commonService;

    private Logger logger = LoggerFactory.getLogger(this.getClass());
    /**
     * @param response
     * @param sheetName
     * @param keyMap
     * @param mapContent key为sheetName,value为数据内容
     * @return int
     * @Description: 导出excel
     */
    public static void getExcelStream4MapData(HttpServletResponse response, OutputStream os, String[] sheetName,String fileName,
                              LinkedHashMap<String, String> keyMap, Map<String,List<LinkedHashMap>> mapContent) throws Exception {
        // 声明工作簿

        WritableWorkbook workbook;
        // 根据传进来的file对象创建可写入的Excel工作薄
        workbook = Workbook.createWorkbook(os);
        // 创建一个工作表
        int sheetNum = sheetName.length;
        for(int st=0;st<sheetNum;st++){
            WritableSheet ws = workbook.createSheet(sheetName[st], st);
            List<LinkedHashMap> listContent=mapContent.get(sheetName[st]);
            //Integer[] columns_widths=widths[st];


            SheetSettings ss = ws.getSettings();
            ss.setVerticalFreeze(1);// 冻结表头

            // 设置字体
            WritableFont NormalFont = new WritableFont(WritableFont.ARIAL, 12);
            WritableFont ContentFont = new WritableFont(WritableFont.ARIAL, 10);
            WritableFont BoldFont = new WritableFont(WritableFont.ARIAL, 12,
                    WritableFont.BOLD);

            // 标题居中
            WritableCellFormat titleFormat = new WritableCellFormat(BoldFont,NumberFormats.TEXT);
            titleFormat.setBorder(Border.ALL, BorderLineStyle.THIN); // 线条
            titleFormat.setVerticalAlignment(VerticalAlignment.CENTRE); // 文字垂直对齐
            titleFormat.setAlignment(Alignment.CENTRE); // 文字水平对齐
            titleFormat.setWrap(false); // 文字是否换行

            // 正文居中
            WritableCellFormat contentCenterFormat = new WritableCellFormat(
                    ContentFont,NumberFormats.TEXT);
            contentCenterFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
            contentCenterFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
            contentCenterFormat.setAlignment(Alignment.CENTRE);
            contentCenterFormat.setWrap(false);

            // 正文左对齐
            WritableCellFormat contentLeftFormat = new WritableCellFormat(
                    ContentFont,NumberFormats.TEXT);
            contentLeftFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
            contentLeftFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
            contentLeftFormat.setAlignment(Alignment.LEFT);
            contentLeftFormat.setWrap(false);

            WritableCellFormat contentRightFormat = new WritableCellFormat(
                    ContentFont,NumberFormats.TEXT);
            contentRightFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
            contentRightFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
            contentRightFormat.setAlignment(Alignment.RIGHT);
            contentRightFormat.setWrap(false);

            // 设置标题,标题内容为keyMap中的value值,标题居中粗体显示
            Iterator<?> titleIter = keyMap.entrySet().iterator();
            int titleIndex = 0;
            while (titleIter.hasNext()) {
                Map.Entry<String, String> entry = (Map.Entry<String, String>) titleIter
                        .next();
                //设置列宽
               // ws.setColumnView(titleIndex, columns_widths[titleIndex]);


                String text = entry.getValue().split("_")[0].split("#")[0];

                if(text.contains("同比-")){
                    text = "同比（%）";
                }

                ws.addCell(new Label(titleIndex++, 0, text,
                        titleFormat));

            }

            // 设置正文内容
            for (int i = 0; i < listContent.size(); i++) {
                Iterator<?> contentIter = keyMap.entrySet().iterator();
                int colIndex = 0;
                while (contentIter.hasNext()) {
                    Map.Entry<String, String> entry = (Map.Entry<String, String>) contentIter
                            .next();
                    String key = entry.getKey().toString();
                    Object content = listContent.get(i).get(key);
                    String value = "";
                    if (null != content) {
                        value = content.toString();
                        if(key.contains("#千")){
                            value = TlCalculateUtils.fmtMicrometer(value);
                        }
                    }

                    if(key.contains("_左")){
                        ws.addCell(new Label(colIndex++, i + 1, value,
                                contentLeftFormat));
                    }else if(key.contains("_右")){
                        ws.addCell(new Label(colIndex++, i + 1, value,
                                contentRightFormat));
                    }else {
                        ws.addCell(new Label(colIndex++, i + 1, value,
                                contentCenterFormat));
                    }


                }

            }

            // 宽度自适应。能够根据内容增加宽度，但对中文的支持不好，如果内容中包含中文，会有部分内容被遮盖
//            for (int i = 0; i < keyMap.size(); i++) {
//                CellView cell = ws.getColumnView(i);
//                cell.setAutosize(true); //自动宽度
//                cell.setSize(30);//最小宽度
//            }
            int[] colBestWidth = colBestWidth(keyMap);

            for (int j = 0; j < colBestWidth.length; j++) {
                ws.setColumnView(j, colBestWidth[j]);
            }
        }

        closeAndFlusH(response,os,fileName,workbook);

    }


    private static int[] colBestWidth(LinkedHashMap<String, String> keyMap){

        int[] colBestWidth = new int[keyMap.size()];
        Iterator<?> contentIter = keyMap.entrySet().iterator();
        int colIndex = 0;
        while (contentIter.hasNext()) {
            Map.Entry<String, String> entry = (Map.Entry<String, String>) contentIter
                    .next();
            String title = entry.getKey().toString();

            if(title.contains("同比-")){
                title = "同比（%）";
            }

            int widthRow = 0;
            if (!StringUtils.isEmpty(title)) {
                widthRow = title.length() + getChineseNum(title);
            }

            colBestWidth[colIndex++] = widthRow+2;

        }

        return colBestWidth;
    }

    public static int getChineseNum(String context){    ///统计context中是汉字的个数
        int lenOfChinese=0;
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");    //汉字的Unicode编码范围
        Matcher m = p.matcher(context);
        while(m.find()){
            lenOfChinese++;
        }
        return lenOfChinese;
    }


    public static void closeAndFlusH(HttpServletResponse response, OutputStream out,String fileName,WritableWorkbook workbook) throws Exception{

        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        // 写入Exel工作表
        workbook.write();
        // 关闭Excel工作薄对象
        workbook.close();
        // 关闭流
        out.flush();
        out.close();
    }

    /**
     * 支持当前对象及直接父类属性查询
     * @param propName
     * @return
     */
    private Field getField(Object obj,String propName) throws NoSuchFieldException {
        Field field;
        try {
            field = obj.getClass().getDeclaredField(propName);
        } catch (NoSuchFieldException e) {
            field = obj.getClass().getSuperclass().getDeclaredField(propName);
        }
        return field;
    }


    public static List getDataFromExcel(InputStream in) throws IOException, BiffException {
        List list = new ArrayList();
        //获取Excel文件对象
        Workbook rwb = Workbook.getWorkbook(in);
        //获取文件的指定工作表 默认的第一个
        Sheet sheet = rwb.getSheet(0);
        //行数(表头的目录不需要，从1开始)
        for (int i = 0; i < sheet.getRows(); i++) {
            //创建一个数组 用来存储每一列的值
            String[] str = new String[sheet.getColumns()];
            Cell cell = null;
            //列数
            for (int j = 0; j < sheet.getColumns(); j++) {
                //获取第i行，第j列的值
                cell = sheet.getCell(j, i);
                if (cell.getType() == CellType.DATE) {
                    DateCell dc = (DateCell) cell;
                    str[j] = TlDateUtils.format(dc.getDate(), "yyyy-MM-dd");
                } else {
                    str[j] = excludeIllegalCode(cell.getContents());
                }

            }
            //把刚获取的列存入list
            list.add(str);
        }
        return list;
    }

    private static final String IllegalCodeRegex = "[\\u007f-\\u009f]|\\u00ad|[\\u0483-\\u0489]|[\\u0559-\\u055a]|\\u058a|[\\u0591-\\u05bd]|\\u05bf|[\\u05c1-\\u05c2]|[\\u05c4-\\u05c7]|[\\u0606-\\u060a]|[\\u063b-\\u063f]|\\u0674|[\\u06e5-\\u06e6]|\\u070f|[\\u076e-\\u077f]|\\u0a51|\\u0a75|\\u0b44|[\\u0b62-\\u0b63]|[\\u0c62-\\u0c63]|[\\u0ce2-\\u0ce3]|[\\u0d62-\\u0d63]|\\u135f|[\\u200b-\\u200f]|[\\u2028-\\u202e]|\\u2044|\\u2071|[\\uf701-\\uf70e]|[\\uf710-\\uf71a]|\\ufb1e|[\\ufc5e-\\ufc62]|\\ufeff|\\ufffc";

    //排除非法字符
    public static String excludeIllegalCode(String src){
        if( null == src || "".equals(src)){
            return "";
        }
        Pattern pattern = Pattern.compile(IllegalCodeRegex);
        Matcher matcher = pattern.matcher(src);
        return matcher.replaceAll("");
    }

    /**
     *
     * @param in 模板输入文件流
     * @param reportModel 模板配置信息
     * @param endLine 模板结束行
     * @param isAddColumn 是否生成映射关系
     * @return
     * @throws IOException
     * @throws BiffException
     */
    public  List<TjbbHeaderModel> getReportHeaderList(InputStream in,TjbbReportModel reportModel,
                                                      int endLine,boolean isAddColumn) throws IOException, BiffException {
        List<TjbbHeaderModel> list = new ArrayList();
        //获取Excel文件对象
        Workbook rwb = Workbook.getWorkbook(in);
        //获取文件的指定工作表 默认的第一个
        Sheet sheet = null;
        //行数(表头的目录不需要，从1开始)

        sheet = rwb.getSheet(0);
        if(sheet==null){
            throw new BusinessException("模板格式不对");
        }

        int headcol = reportModel.getHeadcol().intValue();
        int headrow = reportModel.getHeadrow().intValue();

        int excelcol = reportModel.getExcelcol().intValue();
        int excelrow = reportModel.getExcelrow().intValue();

        Map<String,Range> rangeMap=new HashMap();

        Range[] rangeCell = sheet.getMergedCells();
        for (Range r : rangeCell){

            //表头区域外的跳过
            if(r.getTopLeft().getColumn()<headcol-1
                    ||r.getTopLeft().getRow()<headrow-1){
                continue;
            }

            String key=r.getTopLeft().getRow()+":"+r.getTopLeft().getColumn();
            rangeMap.put(key,r);

        }

        List<TjbbColModelDTO> models=new ArrayList<>();

        for (int i = headrow-1; i < endLine; i++) {
            Cell cell = null;
            //列数
            for (int j = headcol-1; j < sheet.getColumns(); j++) {
                //获取第i行，第j列的值
                cell = sheet.getCell(j, i);

                /*自动生成字段列名*/
                boolean isNumber=false;
                String contents = cell.getContents();
                if(i==excelrow-1-1 && j+1>=excelcol && isAddColumn){
                    try {
                        new BigDecimal(contents);
                        isNumber=true;
                    } catch (Exception e) {
                    }

                    String tempStr=contents==null?"":contents;
                    TjbbColModelDTO modelDto=new TjbbColModelDTO();
                    if(tempStr.contains("＝")){
                        tempStr=tempStr.replace("＝","=");
                    }
                    if(isNumber||tempStr.contains("=")){
                        tempStr=sheet.getCell(j, i-1).getContents();
                        if("".equals(tempStr)){
                            for(int k=i-1;k>=0;k--){
                                if(rangeMap.containsKey(k+":"+j)){
                                    tempStr=sheet.getCell(j, k).getContents();
                                    break;
                                }
                            }
                        }
                        modelDto.setCname(tempStr.trim());
                    }else{
                        if("".equals(tempStr)){
                            boolean isExistHeader=false; //避免模板中表格题外出现隐形列，因而会生成多余列
                            for(int k=i-1;k>=0;k--){
                                if(rangeMap.containsKey(k+":"+j)){
                                    tempStr=sheet.getCell(j, k).getContents();
                                    isExistHeader=true;
                                    break;
                                }
                            }

                            if(!isExistHeader){
                                continue;
                            }
                        }
                        modelDto.setCname(tempStr.trim());
                    }
                    modelDto.setBbdm(reportModel.getBbdm());


                    modelDto.setFname("col_"+(j+1-excelcol+1));
                    modelDto.setFtype("NUMBER");
                    modelDto.setMaxlen(new BigDecimal(16));


                    modelDto.setShoworder(new BigDecimal(j+1));
                    modelDto.setXlscol((j+1-excelcol+1)+"");
                    modelDto.setAllowupdate("Y");
                    modelDto.setAllowformula("Y");
                    modelDto.setQybj("Y");
                    modelDto.setAllowsum("Y");
                    modelDto.setHztype("1");
                    modelDto.setAlign("2");


                    models.add(modelDto);

                }
                /*自动生成字段列名--结束*/


                if(!"".equals(cell.getContents()) || (!isMergeCell(rangeCell,i,j) && i>=excelrow-1)){
                    TjbbHeaderModel model=new TjbbHeaderModel();
                    model.setBbdm(reportModel.getBbdm());


                    if(i>=excelrow-1 && j>=excelcol-1){
                        continue;
                    }
                    int x=i+1;
                    int y=j+1;
                    model.setShowname(cell.getContents()==null?"":cell.getContents().replace("＝","="));
                    model.setHorder(new BigDecimal(x));
                    model.setVorder(new BigDecimal(y));
                    model.setBh(x+"."+y);
                    model.setIsmerg("0");
                    model.setH("1");
                    model.setW("1");
                    if(i>=excelrow-1){
                        model.setType("2");
                        model.setHorder(new BigDecimal(x-excelrow+1));
                        model.setBh((x-excelrow+1)+"."+(y-headcol+1));
                    }else {
                        model.setType("1");
                        model.setDispwidth("80");
                    }
                    model.setQybj("Y");


                    String serK=i+":"+j;
                    if(rangeMap.containsKey(serK)){
                        model.setIsmerg("1");
                        Range range = rangeMap.get(serK);
                        int h=range.getBottomRight().getRow()-range.getTopLeft().getRow()+1;
                        int w=range.getBottomRight().getColumn()-range.getTopLeft().getColumn()+1;
                        model.setH(h+"");
                        model.setW(w+"");
                        //model.setDispwidth(80*w+"");
                    }


                    list.add(model);
                }
            }

        }

        //将自动生成的列映射插入数据库表
        basisService.saveTjbbColumnModel4Excel(models);

        return list;
    }

    private boolean isMergeCell(Range[] rangeCell,int row,int col){

        for(Range r : rangeCell){
            int s_row = r.getTopLeft().getRow();
            int s_col=  r.getTopLeft().getColumn();
            int e_row = r.getBottomRight().getRow();
            int e_col=  r.getBottomRight().getColumn();

            boolean a = row>=s_row && row<=e_row;
            boolean b = col>=s_col && col<=e_col;

            if(a&&b){
                return true;
            }
        }

        return false;
    }

    public int exportTemplateExcelStream(HttpServletResponse response, OutputStream os, InputStream  fileInputStream , String exportFileName, List<SuitExcelDTO> suitExcelDTOS) throws Exception {
        int flag = 0;
        // 声明工作簿

        WritableWorkbook workbook;
        // 根据传进来的file对象创建可写入的Excel工作薄
        Workbook wb = Workbook.getWorkbook(fileInputStream);

        WorkbookSettings wbSettings = new WorkbookSettings ();
        wbSettings.setWriteAccess(null);
        workbook = Workbook.createWorkbook(os, wb,wbSettings);

        int kk=0;
        for(SuitExcelDTO suitDTO :suitExcelDTOS){

            List<String> fnameCols=suitDTO.getFnameCols();
            List<Map> listContent=suitDTO.getListContent();

            int startCol=suitDTO.getStartCol();
            int startRow=suitDTO.getStartRow();
            int headCol=suitDTO.getHeadCol();
            int headRow=suitDTO.getHeadRow();
            int endRow=suitDTO.getEndRow();
            TjbbTbxx zbxx = suitDTO.getZbxx();


            WritableSheet ws = workbook.getSheet(kk++);

            // 设置字体
            WritableFont NormalFont = new WritableFont(WritableFont.ARIAL, 9);

            WritableCellFormat contentLeftFormat = new WritableCellFormat(
                    NormalFont);
            contentLeftFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
            contentLeftFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
            contentLeftFormat.setAlignment(Alignment.LEFT);
            contentLeftFormat.setWrap(false);


            boolean isMxStype=endRow<startRow;

            boolean isSjBb=false;
            if(kk==1 || !suitDTO.getBbdm().startsWith("B01")){
                isSjBb=zbxx.getBbdm().startsWith("B03");
            }
            int offsetLine=0;
            // 设置正文内容
            for (int i = 0; i < listContent.size(); i++) {
                int colIndex = startCol-1;
                int rowIndex = startRow-1;
                Cell cell;
                for (String fname:fnameCols) {
                    if(isMxStype){
                        cell = ws.getCell(colIndex, rowIndex);
                        if(isSjBb){
                            offsetLine=1;
                        }
                    }else {
                        cell = ws.getCell(colIndex, rowIndex+i);
                    }

                    String value="";

                    if(!listContent.get(i).containsKey(fname) && fname.endsWith("_HZ")){
                        fname=fname.replace("_HZ","");
                    }

                    Object cotent = listContent.get(i).get(fname);
                    if(cotent!=null){
                        value=cotent.toString();
                    }
//                if (methodMap != null) {
//                    String methodName = methodMap.get(fname);
//                    if (methodName != null) {
//                        Method convertMethod = this
//                                .getClass()
//                                .getDeclaredMethod(methodName, String.class);
//                        value = (String) convertMethod.invoke(this, value);
//                    }
//                }

                    logger.info("----"+fname+":"+cell.getContents()+":"+cell.getType());
                    if(cell.getContents()!=null && cell.getContents().contains("[-]")){
                        value="";
                    }

                    if(CellType.EMPTY.equals(cell.getType()) || CellType.NUMBER.equals(cell.getType())){
                        boolean b = TlCalculateUtils.isNumeric(value);
                        if(b){
                            Number number = new Number(colIndex, rowIndex + i +offsetLine, Double.parseDouble(value));

                            if(cell.getCellFormat()!=null){
                                number.setCellFormat(cell.getCellFormat());
                            }
                            ws.addCell(number);
                        }else{
                            Label label;
                            if(cell.getCellFormat()==null){
                                label = new Label(colIndex, rowIndex + i+offsetLine, value);
                            }else {
                                label = new Label(colIndex, rowIndex + i+offsetLine, value,cell.getCellFormat());
                            }
                            ws.addCell(label);
                        }
                    }else if(CellType.LABEL.equals(cell.getType()) || CellType.DATE.equals(cell.getType())){
                        Label label = new Label(colIndex, rowIndex + i+offsetLine, value,cell.getCellFormat());
                        ws.addCell(label);
                    }

                    colIndex++;

                }

                //在执行到最后一行之前有数据就新增一行
                if(i!=listContent.size()-1 && isMxStype && !isSjBb){
                    ws.insertRow(rowIndex+i+1+offsetLine);
                }

                // logger.info("换行 ");

            }

            if(kk==1 || !suitDTO.getBbdm().startsWith("B01")) {

                if (zbxx != null) {

                    for (int j = headCol - 1; j < ws.getColumns(); j++) {
                        Cell cell = ws.getCell(j, headRow - 2);
                        String contents = cell.getContents();
                        if (!StringUtils.isEmpty(contents)) {
                            if (contents.contains("[填报单位]")) {
                                contents = contents.replace("[填报单位]", zbxx.getSwjgmc());
                            }
                            if (contents.contains("[填报期别]")) {
                                contents = contents.replace("[填报期别]", zbxx.getSsny());
                            }
                            if (contents.contains("[单位]")) {
                                contents = contents.replace("[单位]", zbxx.getUnit());
                            }

                            if (contents.contains("[填报人]")) {
                                contents = contents.replace("[填报人]", zbxx.getZbr());
                            }

                            if (contents.contains("[其他]")) {
                                contents = contents.replace("[其他]", zbxx.getQt());
                            }

                            if (contents.contains("[填报日期]")) {
                                contents = contents.replace("[填报日期]", zbxx.getZbdate() != null ? TlDateUtils.format(zbxx.getZbdate(), "yyyy-MM-dd") : "");
                            }

                            Label label = new Label(j, headRow - 2, contents, cell.getCellFormat());
                            ws.addCell(label);
                        }


                    }

                    for (int j = headCol - 1; j < ws.getColumns(); j++) {
                        Cell cell = ws.getCell(j, endRow);
                        String contents = cell.getContents();
                        if (!StringUtils.isEmpty(contents)) {
                            if (contents.contains("[填报单位]")) {
                                contents = contents.replace("[填报单位]", zbxx.getSwjgmc());
                            }
                            if (contents.contains("[填报期别]")) {
                                contents = contents.replace("[填报期别]", zbxx.getSsny());
                            }
                            if (contents.contains("[单位]")) {
                                contents = contents.replace("[单位]", zbxx.getUnit());
                            }

                            if (contents.contains("[填报人]")) {
                                contents = contents.replace("[填报人]", zbxx.getZbr());
                            }

                            if (contents.contains("[其他]")) {
                                contents = contents.replace("[其他]", zbxx.getQt());
                            }

                            if (contents.contains("[填报日期]")) {
                                contents = contents.replace("[填报日期]", zbxx.getZbdate() != null ? TlDateUtils.format(zbxx.getZbdate(), "yyyy-MM-dd") : "");
                            }


                            Label label = new Label(j, endRow, contents, cell.getCellFormat());
                            ws.addCell(label);
                        }


                    }

                }

            }
        }

        // 宽度自适应。能够根据内容增加宽度，但对中文的支持不好，如果内容中包含中文，会有部分内容被遮盖
        /*for (int i = 0; i < keyMap.size(); i++) {
            CellView cell = ws.getColumnView(i);
            cell.setAutosize(true); //自动宽度
            cell.setSize(30);//最小宽度
        }*/
        // 写入Exel工作表
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(exportFileName, "UTF-8") + ".xls");
        workbook.write();

        // 关闭Excel工作薄对象
        workbook.close();
        wb.close();

        // 关闭流
        os.flush();
        os.close();
        os = null;
        workbook = null;
        flag = 1;


        return flag;
    }


    public int exportTemplateExcelStream(HttpServletResponse response, OutputStream os, InputStream  fileInputStream ,String exportFileName,String sheetName,
                                         List<String> fnameCols, List<Map> listContent, Map<String, String> methodMap,int startCol,int startRow,int headCol,int headRow, int endRow, TbxxExtDTO zbxx) throws Exception {
        int flag = 0;
        // 声明工作簿

        WritableWorkbook workbook;
        // 根据传进来的file对象创建可写入的Excel工作薄
        Workbook wb = Workbook.getWorkbook(fileInputStream);

        WorkbookSettings wbSettings = new WorkbookSettings ();
        wbSettings.setWriteAccess(null);
        workbook = Workbook.createWorkbook(os, wb,wbSettings);
        // 创建一个工作表
        WritableSheet ws = workbook.getSheet(0);

        // 设置字体
        WritableFont NormalFont = new WritableFont(WritableFont.ARIAL, 9);

        WritableCellFormat contentLeftFormat = new WritableCellFormat(
                NormalFont);
        contentLeftFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
        contentLeftFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
        contentLeftFormat.setAlignment(Alignment.LEFT);
        contentLeftFormat.setWrap(false);


        boolean isMxStype=endRow<startRow;

        boolean isSjBb=zbxx.getBbdm().startsWith("B03") || zbxx.getBbdm().startsWith("D");
        // 设置正文内容
        int kk=0;
        for (int i = 0; i < listContent.size(); i++) {
            int colIndex = startCol-1;
            int rowIndex = startRow-1;
            Cell cell;
            for (String fname:fnameCols) {
                if(isMxStype){
                    cell = ws.getCell(colIndex, rowIndex);
                    //if(isSjBb){
                        kk=1;
                    //}

                }else {
                    cell = ws.getCell(colIndex, rowIndex+i);
                }

                String value="";

                //导出原始数据时，遇上没有_HZ值时，取最新实际值
                if(!listContent.get(i).containsKey(fname) && fname.endsWith("_HZ")){
                    fname=fname.replace("_HZ","");
                }

                Object cotent = listContent.get(i).get(fname);
                if(cotent!=null){
                    value=cotent.toString();
                }
//                if (methodMap != null) {
//                    String methodName = methodMap.get(fname);
//                    if (methodName != null) {
//                        Method convertMethod = this
//                                .getClass()
//                                .getDeclaredMethod(methodName, String.class);
//                        value = (String) convertMethod.invoke(this, value);
//                    }
//                }

                logger.info("----"+fname+":"+cell.getContents()+":"+cell.getType());
                if(cell.getContents()!=null && cell.getContents().contains("[-]")){
                    value="";
                }

                if(CellType.EMPTY.equals(cell.getType()) || CellType.NUMBER.equals(cell.getType())){
                    boolean b = TlCalculateUtils.isNumeric(value);
                    if(b){
                        Number number = new Number(colIndex, rowIndex + i+kk, Double.parseDouble(value));

                        if(cell.getCellFormat()!=null){
                            number.setCellFormat(cell.getCellFormat());
                        }
                        ws.addCell(number);
                    }else{
                        Label label;
                        if(cell.getCellFormat()==null){
                            label = new Label(colIndex, rowIndex + i+kk, value);
                        }else {
                            label = new Label(colIndex, rowIndex + i+kk, value,cell.getCellFormat());
                        }
                        ws.addCell(label);
                    }
                }else if(CellType.LABEL.equals(cell.getType()) || CellType.DATE.equals(cell.getType())){
                    Label label = new Label(colIndex, rowIndex + i+kk, value,cell.getCellFormat());
                    ws.addCell(label);
                }else if(isMxStype && CellType.NUMBER_FORMULA.equals(cell.getType())){
                    String formula = ((NumberFormulaCell) cell).getFormula();
                    formula=formula.replace(startRow+"",rowIndex + i+kk+1+"");
                    ws.addCell(new Formula(colIndex, rowIndex + i+kk,formula,cell.getCellFormat()));
                }

                colIndex++;

            }

            //在执行到最后一行之前有数据就新增一行,省局报表不往下新插入行
            if(i!=listContent.size()-1 && isMxStype){
                ws.insertRow(rowIndex+i+1+kk);
            }
            // logger.info("换行 ");

        }

        if(zbxx!=null){
            zbxx.setSwjgmc(org.apache.commons.lang3.StringUtils.trimToEmpty(zbxx.getSwjgmc()));
            zbxx.setSsny(org.apache.commons.lang3.StringUtils.trimToEmpty(zbxx.getSsny()));
            zbxx.setUnit(org.apache.commons.lang3.StringUtils.trimToEmpty(zbxx.getUnit()));
            zbxx.setZbr(org.apache.commons.lang3.StringUtils.trimToEmpty(zbxx.getZbr()));
            zbxx.setQt(org.apache.commons.lang3.StringUtils.trimToEmpty(zbxx.getQt()));


            for(int y=1;y<=headRow-2;y++){
                for(int j=headCol-1;j<ws.getColumns();j++){
                    Cell cell = ws.getCell(j, y);
                    String contents = cell.getContents();
                    if(!StringUtils.isEmpty(contents)){
                        if(contents.contains("[填报单位]")){
                            contents=contents.replace("[填报单位]",zbxx.getSwjgmc());
                        }
                        if(contents.contains("[填报期别]")){
                            contents=contents.replace("[填报期别]",zbxx.getSsny());
                        }
                        if(contents.contains("[单位]")){
                            contents=contents.replace("[单位]",zbxx.getUnit());
                        }

                        if(contents.contains("[填报人]")){
                            contents=contents.replace("[填报人]",zbxx.getZbr());
                        }

                        if(contents.contains("[其他]")){
                            contents=contents.replace("[其他]",zbxx.getQt());
                        }

                        if(contents.contains("[填报日期]")){
                            contents=contents.replace("[填报日期]",zbxx.getZbdate()!=null?TlDateUtils.format(zbxx.getZbdate(),"yyyy-MM-dd"):"");
                        }

                        if(contents.contains("[企业类型]")){
                            contents=contents.replace("[企业类型]",zbxx.getQylx());
                        }

                        if(contents.contains("[贸易国]")){
                            contents=contents.replace("[贸易国]",zbxx.getMyg());
                        }

                        if(contents.contains("[排名条件]")){
                            contents=contents.replace("[排名条件]",zbxx.getPmtj());
                        }


                        Label label = new Label(j, y, contents,cell.getCellFormat());
                        ws.addCell(label);
                    }
                }
            }

            if(isMxStype){
                endRow=endRow+listContent.size()+1;
            }
            for(int j=headCol-1;j<ws.getColumns();j++){
                Cell cell = ws.getCell(j, endRow);
                String contents = cell.getContents();
                if(!StringUtils.isEmpty(contents)){
                    if(contents.contains("[填报单位]")){
                        contents=contents.replace("[填报单位]",zbxx.getSwjgmc());
                    }
                    if(contents.contains("[填报期别]")){
                        contents=contents.replace("[填报期别]",zbxx.getSsny());
                    }
                    if(contents.contains("[单位]")){
                        contents=contents.replace("[单位]",zbxx.getUnit());
                    }

                    if(contents.contains("[填报人]")){
                        contents=contents.replace("[填报人]",zbxx.getZbr());
                    }

                    if(contents.contains("[其他]")){
                        contents=contents.replace("[其他]",zbxx.getQt());
                    }

                    if(contents.contains("[填报日期]")){
                        contents=contents.replace("[填报日期]",zbxx.getZbdate()!=null?TlDateUtils.format(zbxx.getZbdate(),"yyyy-MM-dd"):"");
                    }


                    Label label = new Label(j, endRow, contents,cell.getCellFormat());
                    ws.addCell(label);
                }

            }
        }


        // 宽度自适应。能够根据内容增加宽度，但对中文的支持不好，如果内容中包含中文，会有部分内容被遮盖
        /*for (int i = 0; i < keyMap.size(); i++) {
            CellView cell = ws.getColumnView(i);
            cell.setAutosize(true); //自动宽度
            cell.setSize(30);//最小宽度
        }*/
        // 写入Exel工作表
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(exportFileName, "UTF-8") + ".xls");
        workbook.write();

        // 关闭Excel工作薄对象
        workbook.close();
        wb.close();

        // 关闭流
        os.flush();
        os.close();
        os = null;
        workbook = null;
        flag = 1;


        return flag;
    }

}
