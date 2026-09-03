package com.tl.bjts.sw.interceptor;

import com.tl.bjts.sw.model.domain.SysCfgTableColumn;
import com.tl.bjts.sw.service.BasisService;
import com.tl.bjts.sw.service.CommonServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.*;

@Component
public class RecordInterceptor extends HandlerInterceptorAdapter {

    private static final Logger LOGGER = LoggerFactory.getLogger
            (RecordInterceptor.class);

    public static final ThreadLocal<List<String>> exualThreadLocal = new ThreadLocal<>();

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    BasisService basisService;

    //插入请求的记录
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        String methodName = method.getName();

        String czryDm = commonService.getCurrentUser().getCzryDm();


        List<String> exualList=new ArrayList<>();

        String select = basisService.getUserTableSelect(czryDm, methodName);
        if(select==null){
            select="";
        }
        String[] split = select.split(",");

        if(split==null||split.length==0){
            exualThreadLocal.set(exualList);
        }else{
            Map selectColsMap=new HashMap<>();
            List<String> list = Arrays.asList(split);
            for(String str:list){
                selectColsMap.put(str,str);
            }

            List<SysCfgTableColumn> userTableColumn = basisService.getUserTableColumn(methodName);
            for(SysCfgTableColumn tableColumn:userTableColumn){
                if("0".equals(tableColumn.getIs_fixed())
                        && !selectColsMap.containsKey(tableColumn.getT_c_code())){
                    exualList.add(tableColumn.getT_c_code());
                }
            }

            exualThreadLocal.set(exualList);
        }

        return super.preHandle(request, response, handler);
    }
}
