package com.tl.web.bjts.shzs.annotation;

import java.lang.annotation.*;

@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ConvertCode {
    String dtype() default "";
}
