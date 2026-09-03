package com.tl.bjts.sw.aop;

import com.tl.bjts.sw.exception.BusinessException;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;


@Aspect
@Configuration
public class LogAspect {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());


    @Pointcut("execution(* com.tl.bjts.sw.controller.*Controller.*(..))")
    public void executeService(){

    }

    //@Before("executeService()")
    public void doBefore(JoinPoint joinPoint) {
        String className = joinPoint.getTarget().getClass().getName();
        String methodName = joinPoint.getSignature().getName();
        String msg=className + "的" + methodName + "执行了";
        Object[] args = joinPoint.getArgs();
        StringBuilder log = new StringBuilder(msg+"入参为");
        for (Object arg : args) {
            log.append(arg + " ");
        }
        LOGGER.info(log.toString());
    }

    @Around("executeService()")
    public Object doAfter (ProceedingJoinPoint pjp) throws Throwable {
        Object result = null;
        try {
            result = pjp.proceed();
        }catch (BusinessException e){
            LOGGER.error(e.getMessage(),e);
            throw e;
        }catch (Throwable e){
            LOGGER.error(e.getMessage(),e);
            throw e;
        }
        return result;
    }
}
