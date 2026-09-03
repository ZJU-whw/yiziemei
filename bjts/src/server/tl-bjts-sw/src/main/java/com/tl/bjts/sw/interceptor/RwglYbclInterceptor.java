package com.tl.bjts.sw.interceptor;

import com.tl.bjts.sw.annotation.RwclYbclAfter;
import com.tl.bjts.sw.model.SimpleResult;
import com.tl.bjts.sw.model.dto.RwglYbclAfterDTO;
import com.tl.bjts.sw.service.RwglYbclService;
import com.tl.bjts.sw.utils.TlConst;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 说明：任务处理-异步处理拦截器
 * 作用：处理完毕的任务，更新任务状态等
 * 作者：likun
 * 日期：2020-05-11
 **/

@Component
public class RwglYbclInterceptor extends HandlerInterceptorAdapter {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    public static final ThreadLocal<SimpleResult> resultThreadLocal = new ThreadLocal<>();  //记录返回结果的线程变量
    public static final ThreadLocal<RwglYbclAfterDTO> paramThreadLocal = new ThreadLocal<RwglYbclAfterDTO>(); //插入数据库的变量
    private final ThreadLocal<Long> startTime = new ThreadLocal<>();   //记录时间的线程变量

    @Autowired
    private RwglYbclService rwglYbclService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        startTime.set(System.currentTimeMillis());

        return super.preHandle(request, response, handler);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        //获取参数
        RwglYbclAfterDTO rwglYbclDTO = paramThreadLocal.get();
        //获取服务处理结果
        SimpleResult simpleResult = resultThreadLocal.get();
        boolean f = true; //是否需要执行真正的后置服务(修改任务管理信息总表的任务状态等)
        if(simpleResult == null || simpleResult.getCode() != 0 || rwglYbclDTO == null){
            f = false;
        }
        Long starttime = startTime.get();
        Long costMillis = System.currentTimeMillis() - starttime; //用时时间(单位为秒)
        String bz = "";
        try {
            if (handler instanceof HandlerMethod) {
                HandlerMethod handlerMethod = (HandlerMethod) handler;
                RwclYbclAfter annotation = handlerMethod.getMethod().getAnnotation(RwclYbclAfter.class);
                if (annotation != null) {
                    if(f){
                        //备注里记录耗时的时间
                        bz = "用时" + formattime(costMillis) ;
                        rwglYbclDTO.setBz(bz);
                        //执行真正的后置服务(修改任务管理信息总表的任务状态等)
                        rwglYbclService.afterServerExecutor(rwglYbclDTO);
                    }else{ //如果执行过程出错，此时需要删除创建的任务(排除自定义的超时异常)
                        if((simpleResult == null || (simpleResult != null && simpleResult.getCode() != TlConst.TJFX_RWZT_CLWB_REFRESH
                                && simpleResult.getCode() != TlConst.TJFX_RWZT_DCL  && simpleResult.getCode() != TlConst.TJFX_RWZT_CLZ))){
                            rwglYbclService.deleteRwglYbcl(rwglYbclDTO);
                        }
                    }
                }
            }
        }catch (Exception e){
            logger.error("任务管理-异步处理失败：{}",e.toString());
        }

        startTime.remove();
        paramThreadLocal.remove();
        resultThreadLocal.remove();
//        logger.info("任务管理-异步处理-本次请求花费 {} ms", System.currentTimeMillis() - starttime);
        super.afterCompletion(request, response, handler, ex);
    }

    /**
     * 将毫秒转为分和秒
     * @param time
     * @return
     */
     public static String formattime(long time){
         String description = "";
        Long min= (time/(1000*60)); //耗时分钟
        Long second= (time%(1000*60)/1000); //耗时秒
         if(min > 0){
             description = description.concat(min.toString()).concat("分");
         }
         if(second > 0){
             description = description.concat(second.toString()).concat("秒");
         }else{
             description =description.concat("1秒");
         }
        return description;
     }
}
