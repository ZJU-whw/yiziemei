package com.tl.web.bjts.shzs.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.tl.common.ext.model.BaseListDTO;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.PoiUtils;
import com.tl.common.ext.utils.TlDateUtils;
import com.tl.web.bjts.shzs.model.PageInfoIncludeSum;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/*
 * @Description: 控制器常用工具
 * @Author Neo Lin
 * @Date  2018/4/11 14:30
 */
public class TLBaseController extends BaseController {
    @Override
    public PageInfo dealPageInfo(List list) {
        PageInfo<List> pageInfo = new PageInfo();
        if(list != null && !list.isEmpty()) {
            Page page = (Page)list;
            com.github.pagehelper.PageInfo pi = page.toPageInfo();
            pageInfo.setPage(Integer.valueOf(pi.getPageNum())+1); // 当前页号
            pageInfo.setRecords((int)pi.getTotal()); // 总记录数
            pageInfo.setCount(Long.valueOf(pi.getTotal()));
            pageInfo.setTotal(Integer.valueOf(pi.getPages())); // 总页数
            pageInfo.setRows(pi.getList());

        } else {
            pageInfo.setPage(Integer.valueOf(1));
            pageInfo.setRecords(Integer.valueOf(0));
            pageInfo.setTotal(Integer.valueOf(0));
            pageInfo.setCount(Long.valueOf(0L));
            pageInfo.setRows(new ArrayList());
        }

        return pageInfo;
    }

    /**
     * 包含合计的页面元素
     * @param list
     * @return
     */
    public PageInfoIncludeSum dealPageInfoIncludeSum(List list, Object sum) {
        Page page = (Page)list;
        PageInfoIncludeSum<Object> pageInfo = new PageInfoIncludeSum();
        if(list != null && !list.isEmpty()) {
            com.github.pagehelper.PageInfo pi = page.toPageInfo();
            pageInfo.setPage(Integer.valueOf(pi.getPageNum()));
            pageInfo.setRecords((int)pi.getTotal()); //前端记录总数用的是records接收，覆盖BaseController中的数据
            pageInfo.setCount(Long.valueOf(pi.getTotal()));
            pageInfo.setTotal(Integer.valueOf(pi.getPages()));
            pageInfo.setRows(pi.getList());
            pageInfo.setSumData(sum);
        } else {
            pageInfo.setPage(Integer.valueOf(1));
            pageInfo.setRecords(Integer.valueOf(0));
            pageInfo.setTotal(Integer.valueOf(0));
            pageInfo.setCount(Long.valueOf(0L));
            pageInfo.setRows(new ArrayList());
            pageInfo.setSumData(sum);
        }

        return pageInfo;
    }


    public static  <T extends BaseListDTO> void setPageParam(T t){
        PageHelper.startPage(t.getPageNo()-1,t.getPageSize(),t.getOrderSql());
    }


    private final String callback= "<script>top.tools.info(\"%s\");</script>";

    private String getJsCallback(String message){
        return String.format(callback,message);
    }

    protected void processErrorResponse(HttpServletResponse response, String msg) throws IOException {
        response.setContentType("text/html");
        response.getOutputStream().print(new String(getJsCallback(msg)
                .getBytes("UTF-8"),"iso8859-1"));
        response.getOutputStream().flush();
        response.getOutputStream().close();
    }

    public <T> T exportExcel(String filename, HttpServletResponse response, List<T> retList, Class<T> clazz, List<String> exual) throws Exception {

        ServletOutputStream outputStream = getOutput(response, filename);
        PoiUtils.createExcelSingleSheet(outputStream, "sheet", retList, clazz, exual,false);
        // 关闭流
        outputStream.flush();
        outputStream.close();
        return retList.get(0);
    }

    private ServletOutputStream getOutput(HttpServletResponse response,String filename) throws Exception{
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = filename+ TlDateUtils.format(new Date(), "yyyyMMdd");
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        return outputStream;
    }



}