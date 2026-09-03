package com.tl.bjts.sw.utils;

import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.conf.FileConfig;
import com.tl.bjts.sw.dao.*;
import com.tl.bjts.sw.model.SwjgModel;
import com.tl.bjts.sw.model.domain.TjbbTaskSubModel;
import com.tl.bjts.sw.model.domain.TjbbTbxx;
import com.tl.bjts.sw.model.dto.SuitExcelDTO;
import com.tl.bjts.sw.model.dto.TbxxExtDTO;
import com.tl.bjts.sw.model.vo.SwjgDispVo;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.exception.TlBusinessException;
import com.tl.common.ext.utils.AnnoUtil;
import com.tl.common.ext.utils.CollectionUtils;
import com.tl.common.ext.utils.PoiUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author：Mamf
 * @Date: 2020/6/1.
 * @Description:
 */
@Service
public class PoiExcelUtil {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    AppProperties appProperties;

    @Autowired
    private TlTjbbMapper tlTjbbMapper;

    @Autowired
    private TjbbBasisService tjbbBasisService;

    @Autowired
    private CommonServiceImpl commonService;


    public int exportTemplateExcelStream4Poi(HttpServletResponse response, OutputStream os, InputStream fileInputStream , String exportFileName, String sheetName,
                                             List<String> fnameCols, List<Map> listContent, Map<String, String> methodMap, int startCol, int startRow, int headCol, int headRow, int endRow, TbxxExtDTO zbxx) throws Exception {
        int flag = 0;
        // 声明工作簿

        HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);
        // 创建一个工作表
        HSSFSheet ws = workbook.getSheetAt(0);
        ws.setForceFormulaRecalculation(true);
        boolean isMxStype=endRow<startRow;

        //boolean isSjBb=zbxx.getBbdm().startsWith("B03") || zbxx.getBbdm().startsWith("D");

        for (int i = 0; i < listContent.size(); i++) {

            int colIndex = startCol-1;
            int rowIndex = startRow-1;

            /**
             * 为了处理明细表复制行，同时保留底部说明文字，且复制行高与正文行高一致，
             * 目前较完美的方案就是在模板中设置2行正文内容格式行，然后在此处最后两行可不插入行
             */
            if(i<listContent.size()-2 && isMxStype){
                ws.shiftRows(rowIndex+i+1,rowIndex+i+2,1,true,false);
            }

            HSSFCell cell;
            for (String fname:fnameCols) {
                if(isMxStype){
                    cell = ws.getRow(rowIndex).getCell(colIndex);
                }else {
                    cell = ws.getRow(rowIndex+i).getCell(colIndex);

                    if (Objects.isNull(cell)) {
                        cell = ws.getRow(rowIndex+i).createCell(colIndex);
                        cell.setCellStyle(getPreferredCellStyle(cell));
                    }
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

                // logger.info("----"+fname+":"+cell.getContents()+":"+cell.getType());
                if(CellType.STRING==cell.getCellType()
                        && cell.getStringCellValue().contains("[-]")){
                    value="";
                }

                if(CellType.BLANK==cell.getCellType()
                        || CellType.NUMERIC==cell.getCellType()){
                    boolean b = TlCalculateUtils.isNumeric(value);
                    if(b){
                        //Number number = new Number(colIndex, rowIndex + i+kk, Double.parseDouble(value));

                        if(cell.getCellStyle()!=null){
                            HSSFRow row = ws.getRow(rowIndex + i);
                            HSSFCell rowCell = row.createCell(colIndex);
                            rowCell.setCellStyle(cell.getCellStyle());
                            rowCell.setCellValue(Double.parseDouble(value));
                        }

                    }else{

                        if(cell.getCellStyle()!=null){
                            HSSFRow row = ws.getRow(rowIndex + i );
                            HSSFCell rowCell = row.createCell(colIndex);
                            rowCell.setCellStyle(cell.getCellStyle());
                            rowCell.setCellValue(value);
                        }else{
                            HSSFRow row = ws.getRow(rowIndex + i );
                            HSSFCell rowCell = row.createCell(colIndex);
                            rowCell.setCellValue(value);
                        }

                    }
                }else if(CellType.STRING==cell.getCellType()){
                    HSSFRow row = ws.getRow(rowIndex + i );
                    HSSFCell rowCell = row.createCell(colIndex);
                    rowCell.setCellStyle(cell.getCellStyle());
                    rowCell.setCellValue(value);
                }else if(isMxStype && CellType.FORMULA==cell.getCellType()){
                    String formula = cell.getCellFormula();
                    formula=formula.replace(startRow+"",rowIndex + i+1+"");

                    HSSFRow row = ws.getRow(rowIndex + i );
                    HSSFCell rowCell = row.createCell(colIndex);
                    if(cell.getCellStyle()!=null){
                        rowCell.setCellStyle(cell.getCellStyle());
                    }
                    rowCell.setCellFormula(formula);


                }

                colIndex++;

            }


        }

        if(zbxx!=null){
            zbxx.setSwjgmc(StringUtils.trimToEmpty(zbxx.getSwjgmc()));
            zbxx.setSsny(StringUtils.trimToEmpty(zbxx.getSsny()));
            zbxx.setUnit(StringUtils.trimToEmpty(zbxx.getUnit()));
            zbxx.setZbr(StringUtils.trimToEmpty(zbxx.getZbr()));
            zbxx.setQt(StringUtils.trimToEmpty(zbxx.getQt()));


            for(int y=1;y<=headRow-2;y++){
                for(int j=headCol-1;j<ws.getRow(headRow-1).getLastCellNum();j++){

                    if(ws.getRow(y)==null){
                        continue;
                    }

                    HSSFCell cell = ws.getRow(y).getCell(j);
                    String contents="";
                    if (!Objects.isNull(cell)) {
                        contents = cell.getStringCellValue();
                    }

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

                        HSSFCell rowCell =ws.getRow(y).getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                        rowCell.setCellValue(contents);
                    }
                }
            }

            if(isMxStype){
                endRow=endRow+listContent.size()+1;
            }
            for(int j=headCol-1;j<ws.getRow(headRow-1).getLastCellNum();j++){
                if(ws.getRow(endRow)==null){
                    continue;
                }
                HSSFCell cell = ws.getRow(endRow).getCell(j);
                if (Objects.isNull(cell)) {
                    cell = ws.getRow(endRow).createCell(j);
                    cell.setCellStyle(getPreferredCellStyle(cell));
                }
                String contents = cell.toString();
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



                    HSSFCell rowCell =ws.getRow(endRow).getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    rowCell.setCellValue(contents);
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

        workbook.write(os);

        // 关闭Excel工作薄对象
        os.flush();
        os.close();

        flag = 1;


        return flag;
    }


    /**
     * 导出套表Excel
     * @param response
     * @param os
     * @param fileInputStream
     * @param exportFileName
     * @param suitExcelDTOS
     * @return
     * @throws Exception
     */
    public int exportTemplateExcelStream4Poi(HttpServletResponse response, OutputStream os, InputStream  fileInputStream , String exportFileName, List<SuitExcelDTO> suitExcelDTOS) throws Exception {
        int flag = 0;
        // 声明工作簿

        HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);


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

            // 创建一个工作表

            HSSFSheet ws = null;
            try {
                ws = workbook.getSheetAt(kk++);
            } catch (Exception e) {
                continue;
            }
            ws.setForceFormulaRecalculation(true);

            boolean isMxStype=endRow<startRow;

            int offsetLine=0;
            // 设置正文内容
            for (int i = 0; i < listContent.size(); i++) {
                int colIndex = startCol-1;
                int rowIndex = startRow-1;

                /**
                 * 为了处理明细表复制行，同时保留底部说明文字，且复制行高与正文行高一致，
                 * 目前较完美的方案就是在模板中设置2行正文内容格式行，然后在此处最后两行可不插入行
                 */
                //2021.9.27  原 if(i<listContent.size()-1 && isMxStype)
                if(i<listContent.size()-2 && isMxStype){
                    ws.shiftRows(rowIndex+i+1,rowIndex+i+2,1,true,false);
                }

                HSSFCell cell;
                for (String fname:fnameCols) {
                    if(isMxStype){
                        cell = ws.getRow(rowIndex).getCell(colIndex);
                        /**
                         * 此处为明细表时偏移一行，留第一行作为格式行进行复制格式，否则存在第一行数据填充后格式以文本方式存储的问题
                         * 待数据填充完毕后，再将数据内容以默认500行选中区域进行往上整体移动一行
                         */
                        offsetLine=0; //2021.9.27  原 offsetLine=1
                    }else {
                        cell = ws.getRow(rowIndex+i).getCell(colIndex);

                        if (Objects.isNull(cell)) {
                            cell = ws.getRow(rowIndex+i).createCell(colIndex);
                            cell.setCellStyle(getPreferredCellStyle(cell));
                        }
                    }

                    String value="";

                    if(!listContent.get(i).containsKey(fname) && fname.endsWith("_HZ")){
                        fname=fname.replace("_HZ","");
                    }

                    Object cotent = listContent.get(i).get(fname);
                    if(cotent!=null){
                        value=cotent.toString();
                    }

                    if(CellType.STRING==cell.getCellType()
                            && cell.getStringCellValue().contains("[-]")){
                        value="";
                    }

                    HSSFRow row = ws.getRow(rowIndex + i + offsetLine);
                    if(row==null){
                        row=ws.createRow(rowIndex + i + offsetLine);

                    }

                    if(CellType.BLANK==cell.getCellType()
                            || CellType.NUMERIC==cell.getCellType()){
                        boolean b = TlCalculateUtils.isNumeric(value);
                        if(b){
                            if(cell.getCellStyle()!=null){
                                HSSFCell rowCell = row.createCell(colIndex);
                                rowCell.setCellStyle(cell.getCellStyle());
                                rowCell.setCellValue(Double.parseDouble(value));
                            }
                        }else{
                            if(cell.getCellStyle()!=null){
                                HSSFCell rowCell = row.createCell(colIndex);
                                rowCell.setCellStyle(cell.getCellStyle());
                                rowCell.setCellValue(value);
                            }else{
                                HSSFCell rowCell = row.createCell(colIndex);
                                rowCell.setCellValue(value);
                            }
                        }
                    }else if(CellType.STRING==cell.getCellType()){
                        HSSFCell rowCell = row.createCell(colIndex);
                        rowCell.setCellStyle(cell.getCellStyle());
                        rowCell.setCellValue(value);
                    }else if(isMxStype && CellType.FORMULA==cell.getCellType()){
                        String formula = cell.getCellFormula();
                        formula=formula.replace(startRow+"",rowIndex + i + offsetLine+1+"");

                        row = ws.getRow(rowIndex + i + offsetLine );
                        HSSFCell rowCell = row.createCell(colIndex);
                        if(cell.getCellStyle()!=null){
                            rowCell.setCellStyle(cell.getCellStyle());
                        }
                        rowCell.setCellFormula(formula);
                    }

                    colIndex++;

                }

            }

            if(kk==1 || !suitDTO.getBbdm().startsWith("B01")) {

                if (zbxx != null) {

                    for (int j = headCol - 1; j < ws.getRow(headRow-1).getLastCellNum(); j++) {

                        if(ws.getRow(headRow - 2)==null){
                            continue;
                        }

                        HSSFCell cell = ws.getRow(headRow - 2).getCell(j);
                        if (Objects.isNull(cell)) {
                            cell = ws.getRow(headRow - 2).createCell(j);
                            cell.setCellStyle(getPreferredCellStyle(cell));
                        }
                        String contents = cell.toString();
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

                            HSSFCell rowCell =ws.getRow(headRow - 2).getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                            rowCell.setCellValue(contents);
                        }


                    }

                    if(isMxStype){
                        endRow=endRow+listContent.size()+1;
                    }
                    for (int j = headCol - 1; j < ws.getRow(headRow-1).getLastCellNum(); j++) {

                        if(ws.getRow(endRow)==null){
                            continue;
                        }

                        HSSFCell cell = ws.getRow(endRow).getCell(j);
                        if (Objects.isNull(cell)) {
                            cell = ws.getRow(endRow).createCell(j);
                            cell.setCellStyle(getPreferredCellStyle(cell));
                        }
                        String contents = cell.toString();
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

                            HSSFCell rowCell =ws.getRow(endRow).getCell(j, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                            rowCell.setCellValue(contents);

                        }

                    }

                }

            }

            //待数据填充完毕后，再将数据内容以默认500行选中区域进行往上整体移动一行
            //2021.9.27  原 未注释掉
//            if(isMxStype){
//                if(listContent.size()>10){
//                    ws.shiftRows(startRow,startRow+listContent.size(),-1);
//                }else {
//                    ws.shiftRows(startRow,startRow+100,-1);
//                }
//
//            }

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


        workbook.write(os);

        // 关闭Excel工作薄对象
        os.flush();
        os.close();

        flag = 1;



        return flag;
    }


    public void exportTemplateExcelStream4Poi4Spec(String swjgdm,HttpServletResponse response, ServletOutputStream out, List<InputStream> streamList, String filename, List<SuitExcelDTO> suitExcelDTOS, String swjgDm) throws Exception {

        HSSFWorkbook workbook = new HSSFWorkbook(streamList.get(0));
        HSSFWorkbook workbook2 = new HSSFWorkbook(streamList.get(1));
        HSSFSheet sheet2 = workbook2.getSheetAt(0);

        HSSFSheet sheet = workbook.createSheet(sheet2.getSheetName());



        copySheet(workbook,sheet2,sheet);
        if(StringUtils.isBlank(swjgdm)){
            swjgdm=swjgDm;
        }

        SuitExcelDTO suitExcelDTO = suitExcelDTOS.get(1);

        List<SwjgDispVo> swjgDispVoList = tlTjbbMapper.selectAllSubArea(swjgdm);
        for (SwjgDispVo swjgDispVo : swjgDispVoList) {

            //复制第二张报表的基本信息
            SuitExcelDTO suitSubExcelDTO = new SuitExcelDTO();
            TlBeanUtils.copyPropertiesIgnoreNull(suitExcelDTO,suitSubExcelDTO);
            suitSubExcelDTO.setListContent(null);

            String subSwjgdm = swjgDispVo.getSwjgdm();
            String dispsx = swjgDispVo.getDispsx();


            TjbbTaskSubModel subModel = tjbbBasisService.getHzDate(suitSubExcelDTO.getBbdm(), subSwjgdm, suitSubExcelDTO.getSsny());
            if(subModel!=null){
                //设置制表信息
                TjbbTbxx tjbbZbxx = getTjbbZbxx(subSwjgdm, suitSubExcelDTO.getBbdm(), subModel.getHztime(), subModel.getHzr(),suitSubExcelDTO.getSsny());
                suitSubExcelDTO.setZbxx(tjbbZbxx);
            }else {
                TjbbTbxx tjbbZbxx = new TjbbTbxx();
                tjbbZbxx.setBbdm(suitSubExcelDTO.getBbdm());
                tjbbZbxx.setSsny(suitSubExcelDTO.getSsny());
                tjbbZbxx.setSwjgmc(swjgDispVo.getSwjgjc());
                suitSubExcelDTO.setZbxx(tjbbZbxx);
            }


            List<Map> dataList;
            dataList = tjbbBasisService.loaddataBySwjgdm(suitSubExcelDTO.getBbdm(),suitSubExcelDTO.getSsny(),subSwjgdm,null);
            suitSubExcelDTO.setListContent(dataList);

            suitExcelDTOS.add(suitSubExcelDTO);

            HSSFSheet sheetNew = workbook.createSheet(dispsx);
            copySheet(workbook,sheet2,sheetNew);
        }


        String allFileName = appProperties.getTemplateTjbbDir()+"_temp"+".xls";
        try (FileOutputStream fileOut = new FileOutputStream(allFileName)) {
            workbook.write(fileOut);
            fileOut.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                workbook.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        File file =new File(allFileName);
        InputStream stream = new FileInputStream(file);

        exportTemplateExcelStream4Poi(response,out,stream,filename,suitExcelDTOS);
    }


    public void exportDynamicExcelStream4Poi4Spec(HttpServletResponse response, ServletOutputStream out, List<InputStream> streamList, String filename, List<SuitExcelDTO> suitExcelDTOS) throws Exception {

        HSSFWorkbook workbook = new HSSFWorkbook(streamList.get(0));

        HSSFSheet sheet;
        HSSFSheet sheetCopy;
        for (int i = 1; i <streamList.size() ; i++) {

            HSSFWorkbook workbook2 = new HSSFWorkbook(streamList.get(i));
            sheetCopy = workbook2.getSheetAt(0);

            sheet = workbook.createSheet(sheetCopy.getSheetName());
            copySheet(workbook,sheetCopy,sheet);
        }


        String allFileName = appProperties.getTemplateTjbbDir()+"_temp"+".xls";
        try (FileOutputStream fileOut = new FileOutputStream(allFileName)) {
            workbook.write(fileOut);
            fileOut.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                workbook.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        File file =new File(allFileName);
        InputStream stream = new FileInputStream(file);

        exportTemplateExcelStream4Poi(response,out,stream,filename,suitExcelDTOS);
    }

    private TjbbTbxx getTjbbZbxx(String swjgdm, String bbdm, Date hzDate, String czryMc, String ssny){
        TjbbTbxx zbxx=new TjbbTbxx();

        SwjgModel swjgModel;

        swjgModel = commonService.getSwjgMc(swjgdm);


        String yyyyMM = new SimpleDateFormat("yyyy年MM月").format(TlDateUtils.parseString2Date(ssny,"yyyyMM"));
        zbxx.setBbdm(bbdm);
        zbxx.setSwjgmc(org.apache.commons.lang3.StringUtils.trimToEmpty(swjgModel.getSwjgjc()));
        zbxx.setSsny(org.apache.commons.lang3.StringUtils.trimToEmpty(yyyyMM));
        zbxx.setUnit("");
        zbxx.setZbr(org.apache.commons.lang3.StringUtils.trimToEmpty(czryMc));
        zbxx.setZbdate(hzDate);
        zbxx.setQt("");

        return zbxx;
    }

    private static void copySheet(HSSFWorkbook wb, HSSFSheet fromSheet, HSSFSheet toSheet) {
        mergeSheetAllRegion(fromSheet, toSheet);
        // 设置列宽
        int length = fromSheet.getRow(fromSheet.getFirstRowNum()).getLastCellNum();
        for (int i = 0; i <= length; i++) {
            toSheet.setColumnWidth(i, fromSheet.getColumnWidth(i));
        }
        for (Iterator rowIt = fromSheet.rowIterator(); rowIt.hasNext(); ) {
            HSSFRow oldRow = (HSSFRow) rowIt.next();
            HSSFRow newRow = toSheet.createRow(oldRow.getRowNum());
            copyRow(wb, oldRow, newRow);
        }
    }

    /**
     * 合并单元格
     *
     * @param fromSheet
     * @param toSheet
     */
    private static void mergeSheetAllRegion(HSSFSheet fromSheet, HSSFSheet toSheet) {
        int num = fromSheet.getNumMergedRegions();
        CellRangeAddress cellR = null;
        for (int i = 0; i < num; i++) {
            cellR = fromSheet.getMergedRegion(i);
            toSheet.addMergedRegion(cellR);
        }
    }

    /**
     * 行复制功能
     *
     * @param wb
     * @param oldRow
     * @param toRow
     */
    private static void copyRow(HSSFWorkbook wb, HSSFRow oldRow, HSSFRow toRow) {
        toRow.setHeight(oldRow.getHeight());
        for (Iterator cellIt = oldRow.cellIterator(); cellIt.hasNext(); ) {
            HSSFCell tmpCell = (HSSFCell) cellIt.next();
            HSSFCell newCell = toRow.createCell(tmpCell.getColumnIndex());
            copyCell(wb, tmpCell, newCell);
        }
    }

    /**
     * 复制单元格
     *
     * @param wb
     * @param fromCell
     * @param toCell
     */
    private static void copyCell(HSSFWorkbook wb, HSSFCell fromCell, HSSFCell toCell) {
        HSSFCellStyle newstyle = wb.createCellStyle();
        // 复制单元格样式
        newstyle.cloneStyleFrom(fromCell.getCellStyle());
        // 样式
        toCell.setCellStyle(newstyle);
        if (fromCell.getCellComment() != null) {
            toCell.setCellComment(fromCell.getCellComment());
        }
        // 不同数据类型处理
        CellType fromCellType = fromCell.getCellType();
        toCell.setCellType(fromCellType);
        if (fromCellType == CellType.NUMERIC) {
            if (DateUtil.isCellDateFormatted(fromCell)) {
                toCell.setCellValue(fromCell.getDateCellValue());
            } else {
                toCell.setCellValue(fromCell.getNumericCellValue());
            }
        } else if (fromCellType == CellType.STRING) {
            toCell.setCellValue(fromCell.getRichStringCellValue());
        } else if (fromCellType == CellType.BLANK) {
            // nothing21
        } else if (fromCellType == CellType.BOOLEAN) {
            toCell.setCellValue(fromCell.getBooleanCellValue());
        } else if (fromCellType == CellType.ERROR) {
            toCell.setCellErrorValue(fromCell.getErrorCellValue());
        } else if (fromCellType == CellType.FORMULA) {
            toCell.setCellFormula(fromCell.getCellFormula());
        } else {
            // nothing29
        }
    }


    public CellStyle getPreferredCellStyle(org.apache.poi.ss.usermodel.Cell cell) {
        CellStyle cellStyle = cell.getCellStyle();
        if (cellStyle.getIndex() == 0) cellStyle = cell.getRow().getRowStyle();
        if (cellStyle == null) cellStyle = cell.getSheet().getColumnStyle(cell.getColumnIndex());
        if (cellStyle == null) cellStyle = cell.getCellStyle();
        return cellStyle;
    }

    public static void createExcelSingleSheet(OutputStream os, String sheetName, List mapContent, Class clazz, List<String> excludeNames) throws Exception {
        createExcelSingleSheet(os, sheetName, mapContent, clazz, excludeNames, true);
    }


    public static void createExcelSingleSheet(OutputStream os, String sheetName, List mapContent, Class clazz, List<String> excludeNames, boolean useOrder) throws Exception {
        List<PoiUtils.SheetModel> sheetModels = new LinkedList();
        PoiUtils.SheetModel s = new PoiUtils.SheetModel();
        s.setSheetName(sheetName);
        Map columnsOrder;
        if(useOrder) {
            columnsOrder = PoiUtils.getColumnsOrder(clazz, excludeNames);
        } else {
            columnsOrder = PoiUtils.getColumnsOrderDirect(clazz, excludeNames);
        }

        s.setTitle(PoiUtils.getKeyMap(columnsOrder));
        s.setContent(mapContent);
        s.setWidths(PoiUtils.getwidths(columnsOrder));
        s.setClazz(clazz);
        sheetModels.add(s);
        createExcel(os, sheetModels);
    }


    public static void createExcel(OutputStream os, List<PoiUtils.SheetModel> sheetModels) throws Exception {
        HSSFWorkbook wb = new HSSFWorkbook();
        int sheetNum = sheetModels.size();

        for(int st = 0; st < sheetNum; ++st) {
            PoiUtils.SheetModel sheetModel = (PoiUtils.SheetModel)sheetModels.get(st);
            HSSFSheet sheet = wb.createSheet(sheetModel.getSheetName());
            sheet.setDefaultRowHeightInPoints(18.0F);
            sheet.setDefaultColumnWidth(20);
            List<?> listContent = sheetModel.getContent();
            Integer[] columns_widths = sheetModel.getWidths();
            LinkedHashMap<String, String> titleMap = sheetModel.getTitle();
            Iterator<Map.Entry<String, String>> titleIter = titleMap.entrySet().iterator();
            HSSFCellStyle cellStyle = wb.createCellStyle();
            cellStyle.setAlignment(HorizontalAlignment.CENTER);
            cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            HSSFFont fontStyle = wb.createFont();
            fontStyle.setFontName("宋体");
            fontStyle.setBold(true);
            cellStyle.setFont(fontStyle);
            Integer childDepth = Integer.valueOf(0);
            Integer childLeafNum = Integer.valueOf(0);
            PoiUtils.TitleTreeNode multiTitle = sheetModel.getMultiTitle();
            Integer titleRowSum = Integer.valueOf(0);
            int i;
            if(multiTitle != null && !CollectionUtils.isEmpty(multiTitle.getChildNodes())) {
                List<PoiUtils.TitleTreeNode> childNodes = multiTitle.getChildNodes();
                childDepth = multiTitle.getChildDepth();
                childLeafNum = multiTitle.getChildLeafNum();
                i = 0;

                while(true) {
                    if(i >= childDepth.intValue()) {
                        setTitleAndMerge(childNodes, sheet);
                        titleRowSum = childDepth;
                        break;
                    }

                    HSSFRow titleRow = sheet.createRow(i);

                    for(int j = 0; j < childLeafNum.intValue(); ++j) {
                        HSSFCell titleCell = titleRow.createCell(j);
                        titleCell.setCellStyle(cellStyle);
                        if(i == 0) {
                            sheet.setColumnWidth(titleCell.getColumnIndex(), 256 * columns_widths[j].intValue());
                        }
                    }

                    ++i;
                }
            } else {
                titleRowSum = Integer.valueOf(1);
                i = 0;

                for(HSSFRow titleRow = sheet.createRow(0); titleIter.hasNext(); ++i) {
                    Map.Entry<String, String> entry = (Map.Entry)titleIter.next();
                    HSSFCell titleCell = titleRow.createCell(i);
                    titleCell.setCellStyle(cellStyle);
                    sheet.setColumnWidth(titleCell.getColumnIndex(), 256 * columns_widths[i].intValue());
                    titleCell.setCellValue((String)entry.getValue());
                }
            }

            for(i = 0; i < listContent.size(); ++i) {
                Iterator<?> contentIter = titleMap.entrySet().iterator();
                int colIndex = 0;

                for(HSSFRow contentRow = sheet.createRow(i + titleRowSum.intValue()); contentIter.hasNext(); ++colIndex) {
                    Map.Entry<String, String> entry = (Map.Entry)contentIter.next();
                    String key = (String)entry.getKey();
                    Field field = getField(listContent.get(i), key);
                    Object obj = listContent.get(i);
                    Object content = com.tl.common.ext.utils.TlBeanUtils.getter(obj, field.getName());
                    String value = "";
                    if(null != content) {
                        if(content instanceof Date) {
                            ExcelSetting excelSetting = (ExcelSetting)field.getAnnotation(ExcelSetting.class);
                            String pattern = "yyyy-MM-dd";
                            if(excelSetting != null) {
                                pattern = excelSetting.datePattern();
                            }

                            value = com.tl.common.ext.utils.TlDateUtils.format((Date)content, pattern);
                        } else {
                            value = content.toString();
                        }
                    }

                    HSSFCell contentCell = contentRow.createCell(colIndex);
                    contentCell.setCellValue(value);
                }
            }
        }

        wb.write(os);
    }


    private static Field getField(Object obj, String propName) throws NoSuchFieldException {
        Field field;
        try {
            field = obj.getClass().getDeclaredField(propName);
        } catch (NoSuchFieldException var4) {
            field = obj.getClass().getSuperclass().getDeclaredField(propName);
        }

        return field;
    }


    private static void setTitleAndMerge(List<PoiUtils.TitleTreeNode> childNodes, HSSFSheet sheet) {
        Iterator var2 = childNodes.iterator();

        while(var2.hasNext()) {
            PoiUtils.TitleTreeNode treeNode = (PoiUtils.TitleTreeNode)var2.next();
            Integer[] indexStartMap = treeNode.getIndexStartMap();
            Integer[] indexEndMap = treeNode.getIndexEndMap();
            Integer colNum = indexStartMap[0];
            Integer rowNum = indexStartMap[1];
            Integer endColNum = indexEndMap[0];
            Integer endRowNum = indexEndMap[1];
            HSSFRow row = sheet.getRow(rowNum.intValue());
            HSSFCell cell = row.getCell(colNum.intValue());
            cell.setCellValue(treeNode.getColName());
            if(colNum != endColNum || rowNum != endRowNum) {
                CellRangeAddress region = new CellRangeAddress(rowNum.intValue(), endRowNum.intValue(), colNum.intValue(), endColNum.intValue());
                sheet.addMergedRegion(region);
            }

            List<PoiUtils.TitleTreeNode> treeNodeChildNodes = treeNode.getChildNodes();
            if(!CollectionUtils.isEmpty(treeNodeChildNodes)) {
                setTitleAndMerge(treeNodeChildNodes, sheet);
            }
        }

    }


    public static <T> List<T> readExcel(InputStream is, String fileName, Class<T> clazz, boolean randomCol) throws Exception {
        Workbook hssfWorkbook = null;
        if(fileName.endsWith("xlsx")) {
            hssfWorkbook = new HSSFWorkbook(is);
        } else if(fileName.endsWith("xls")) {
            hssfWorkbook = new HSSFWorkbook(is);
        }

        Map<Integer, PoiUtils.Dpyz> indexMap = new HashMap();
        Map<String, PoiUtils.Dpyz> titleMap = new HashMap();
        Field[] fields = com.tl.common.ext.utils.TlBeanUtils.getAllFields(clazz);
        Field[] t;
        int numSheet;
        String sheetName;
        if(randomCol) {
            t = fields;
            int var9 = fields.length;

            for(numSheet = 0; numSheet < var9; ++numSheet) {
                Field field = t[numSheet];
                sheetName = field.getName();
                ExcelSetting excelSetting = (ExcelSetting)field.getAnnotation(ExcelSetting.class);
                if(excelSetting != null) {
                    String colName = excelSetting.colTitleName();
                    titleMap.put(colName, new PoiUtils.Dpyz(sheetName, colName, field.getType(), excelSetting));
                }
            }
        } else {
            indexMap = getColumnsOrder(clazz, (List)null);
        }

        t = null;
        List<T> list = new ArrayList();

        for(numSheet = 0; numSheet < ((Workbook)hssfWorkbook).getNumberOfSheets(); ++numSheet) {
            Sheet hssfSheet;
            int rowNum;
            if(randomCol) {
                hssfSheet = ((Workbook)hssfWorkbook).getSheetAt(numSheet);
                Row titleRow = hssfSheet.getRow(0);
                indexMap = new HashMap();

                for(rowNum = 0; rowNum < titleRow.getLastCellNum(); ++rowNum) {
                    Cell titleCell = titleRow.getCell(rowNum);
                    if(titleCell != null) {
                        String titleValue = titleCell.getStringCellValue();
                        PoiUtils.Dpyz dpyz = (PoiUtils.Dpyz)titleMap.get(titleValue);
                        if(dpyz != null) {
                            ((Map)indexMap).put(Integer.valueOf(rowNum), dpyz);
                        }
                    }
                }
            }

            hssfSheet = ((Workbook)hssfWorkbook).getSheetAt(numSheet);
            sheetName = hssfSheet.getSheetName();
            if(hssfSheet != null) {
                for(rowNum = 1; rowNum <= hssfSheet.getLastRowNum(); ++rowNum) {
                    Row hssfRow = hssfSheet.getRow(rowNum);
                    if(hssfRow != null) {
                        Iterator<Map.Entry<Integer, PoiUtils.Dpyz>> iterator = ((Map)indexMap).entrySet().iterator();
                        T obj = clazz.newInstance();

                        while(iterator.hasNext()) {
                            Integer index = Integer.valueOf(0);

                            try {
                                Map.Entry<Integer, PoiUtils.Dpyz> next = (Map.Entry)iterator.next();
                                index = (Integer)next.getKey();
                                PoiUtils.Dpyz value = (PoiUtils.Dpyz)next.getValue();
                                String fieldName = value.getName();
                                Class aClass = value.getClazz();
                                Cell cell = hssfRow.getCell(index.intValue());
                                if(cell != null) {
                                    CellType cellType = cell.getCellType();
                                    String cellStr = "";
                                    if(cellType == CellType.NUMERIC) {
                                        DecimalFormat df = new DecimalFormat("#");
                                        cellStr = df.format(cell.getNumericCellValue());
                                    }

                                    if(cellType == CellType.STRING) {
                                        cellStr = cell.getStringCellValue();
                                    }

                                    Object cellValue = null;
                                    if(aClass == String.class) {
                                        cellValue = cellStr;
                                    } else if(aClass == Date.class) {
                                        cellValue = com.tl.common.ext.utils.TlDateUtils.parseString2Date(cellStr, value.getExcelSetting().datePattern());
                                    } else if(aClass == BigDecimal.class) {
                                        if(cellStr != null && !"".equals(cellStr)) {
                                            cellValue = new BigDecimal(cellStr);
                                        } else {
                                            cellValue = BigDecimal.ZERO;
                                        }
                                    } else if(aClass == Integer.class) {
                                        cellValue = Integer.valueOf(cellStr);
                                    } else if(aClass == Long.class) {
                                        cellValue = Long.valueOf(cellStr);
                                    } else if(aClass == Short.class) {
                                        cellValue = Short.valueOf(cellStr);
                                    } else if(aClass == Double.class) {
                                        cellValue = Double.valueOf(cellStr);
                                    } else if(aClass == Float.class) {
                                        cellValue = Float.valueOf(cellStr);
                                    }

                                    com.tl.common.ext.utils.TlBeanUtils.setter(obj, fieldName, cellValue, aClass);
                                }
                            } catch (Exception var27) {
                                throw new TlBusinessException(501, "EXCEL内容有误", String.format("【%s】页,第%s行,第%s列,数据有误，请检查核对", new Object[]{sheetName, Integer.valueOf(rowNum + 1), PoiUtils.excelColIndexToStr(index.intValue() + 1), var27.getMessage()}));
                            }
                        }

                        try {
                            AnnoUtil.checkParam(obj);
                        } catch (TlBusinessException var26) {
                            throw new TlBusinessException(501, "EXCEL内容有误", String.format("【%s】页,第%s行,%s,请检查核对", new Object[]{sheetName, Integer.valueOf(rowNum + 1), var26.getSubMsg()}));
                        }

                        list.add(obj);
                    }
                }
            }
        }

        return list;
    }


    public static Map<Integer, PoiUtils.Dpyz> getColumnsOrder(Class clazz, List<String> excludeNames) {
        Map<Integer, PoiUtils.Dpyz> indexMap = new LinkedHashMap();
        Field[] fields = com.tl.common.ext.utils.TlBeanUtils.getAllFields(clazz);
        String firstColumn = "";
        Map<String, PoiUtils.Dpyz> itemLinkedMap = new HashMap();
        Field[] var6 = fields;
        int var7 = fields.length;

        int var8;
        for(var8 = 0; var8 < var7; ++var8) {
            Field field = var6[var8];
            String fieldName = field.getName();
            if(excludeNames == null || !excludeNames.contains(fieldName)) {
                ExcelSetting excelSetting = (ExcelSetting)field.getAnnotation(ExcelSetting.class);
                if(excelSetting != null && !excelSetting.isFatherTitle()) {
                    boolean first = excelSetting.isFirst();
                    String colTitleName = excelSetting.colTitleName();
                    String next = excelSetting.nextColName();
                    if(first) {
                        firstColumn = fieldName;
                    }

                    itemLinkedMap.put(fieldName, new PoiUtils.Dpyz(next, colTitleName, field.getType(), excelSetting));
                }
            }
        }

        String next = firstColumn;
        boolean gogogo = true;
        var8 = 0;

        while(gogogo) {
            PoiUtils.Dpyz dpyz = (PoiUtils.Dpyz)itemLinkedMap.get(next);
            if(dpyz == null) {
                gogogo = false;
            } else {
                indexMap.put(Integer.valueOf(var8++), new PoiUtils.Dpyz(next, dpyz.getTitleName(), dpyz.getClazz(), dpyz.getExcelSetting()));
                next = dpyz.getName();
            }
        }

        return indexMap;
    }

}
