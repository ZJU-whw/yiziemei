package com.tl.bjts.sw.service;


import com.tl.bjts.sw.utils.PoiExcelUtil;
import com.tl.common.ext.utils.PoiUtils;
import com.tl.common.ext.utils.TlDateUtils;
import org.springframework.stereotype.Service;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

@Service
public class ExportService {

    public <T> T exportExcel(String filename,HttpServletResponse response, List<T> retList,Class<T> clazz,List<String> exual) throws Exception {

        ServletOutputStream outputStream = getOutput(response, filename);
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", retList, clazz, exual,false);
        // 关闭流
        outputStream.flush();
        outputStream.close();
        return retList.get(0);
    }

    public <T> T exportOrderExcel(String filename,HttpServletResponse response, List<T> retList,Class<T> clazz,List<String> exual) throws Exception {

        ServletOutputStream outputStream = getOutput(response, filename);
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", retList, clazz, exual,true);
        // 关闭流
        outputStream.flush();
        outputStream.close();
        return retList.get(0);
    }

    private ServletOutputStream getOutput(HttpServletResponse response,String filename) throws Exception{
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = filename+TlDateUtils.format(new Date(), "yyyyMMdd");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        return outputStream;
    }
}
