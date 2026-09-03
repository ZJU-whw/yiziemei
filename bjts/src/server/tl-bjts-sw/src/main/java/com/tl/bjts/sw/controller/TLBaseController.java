package com.tl.bjts.sw.controller;

import com.github.pagehelper.Page;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.exception.BusinessMsgCons;
import com.tl.bjts.sw.model.PageInfoIncludeSum;
import com.tl.bjts.sw.utils.JxlExcelUtil;
import com.tl.bjts.sw.utils.PoiExcelUtil;
import com.tl.common.ext.model.PageInfo;
import com.tl.common.ext.utils.BaseController;
import com.tl.common.ext.utils.PoiUtils;
import org.springframework.aop.framework.AopContext;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;


/*
 * @Description: 控制器常用工具
 * @Author Neo Lin
 * @Date  2018/4/11 14:30
 */
public class TLBaseController extends BaseController {

    public PageInfo dealPageInfo(List list) {
        Page page = (Page)list;
        PageInfo<List> pageInfo = new PageInfo();
        if(list != null && !list.isEmpty()) {
            com.github.pagehelper.PageInfo pi = page.toPageInfo();
            pageInfo.setPage(Integer.valueOf(pi.getPageNum()));
            pageInfo.setRecords((int)pi.getTotal()); //前端记录总数用的是records接收，覆盖BaseController中的数据
            pageInfo.setCount(Long.valueOf(pi.getTotal()));
            pageInfo.setTotal(Integer.valueOf(pi.getPages()));
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


    protected   <T> List<T>  checkAndGetExcel(MultipartFile file, Class<T> clazz) throws Exception {
        String fileName = file.getOriginalFilename();
        if (!(fileName.endsWith(".xls")|| fileName.endsWith(".xlsx"))) {
            throw new BusinessException(BusinessMsgCons.ONLY_XLS);
        }
        //得到所有数据
       // List<T> allData= JxlExcelUtil.getDataFromExcel(file.getInputStream());
        List<T> allData= PoiExcelUtil.readExcel(file.getInputStream(),file.getOriginalFilename(),clazz,true);
        if(allData.size()<1){
            throw new BusinessException("请在excel中填写数据");
        }
        return  allData;
    }

    protected List transferDictCode(List list){
        BaseController proxy=(BaseController) AopContext.currentProxy();
        return proxy.transferDictCode2Name(list);
    }

    protected <T> T transferDictCode(T obj){
        BaseController proxy=(BaseController) AopContext.currentProxy();
        return proxy.transferDictCode2Name(obj);
    }


}
