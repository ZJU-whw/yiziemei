package com.tl.bjts.sw;

import com.tl.bjts.sw.conf.FileConfig;
import com.tl.common.ext.utils.CommonUtils;
import com.tl.common.utils.SpringContextUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.cloud.client.SpringCloudApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

import javax.servlet.MultipartConfigElement;
import java.io.File;
import java.nio.charset.Charset;
import java.util.List;

@SpringCloudApplication
@ServletComponentScan
@EnableAspectJAutoProxy(exposeProxy = true)
@EnableScheduling //开启定时任务注解
public class MainApplication {

	public static void main(String[] args) {
		SpringApplication.run(MainApplication.class, args);
	}

	@Bean
	@LoadBalanced
	RestTemplate restTemplate() {
		RestTemplate restTemplate = new RestTemplate();
		List<HttpMessageConverter<?>> converters = restTemplate.getMessageConverters();
		for(int i=0;i<converters.size();i++){
			HttpMessageConverter<?> httpMessageConverter = converters.get(i);
			if(httpMessageConverter instanceof StringHttpMessageConverter){
				converters.remove(httpMessageConverter);
				StringHttpMessageConverter converter = new StringHttpMessageConverter(Charset.forName("UTF-8"));
				converters.set(i,converter);
				break;
			}
		}
		return new RestTemplate(converters);
	}

	@Bean
	MultipartConfigElement multipartConfigElement() {
		MultipartConfigFactory factory = new MultipartConfigFactory();
		File dir=new File(FileConfig.tempDir);
		if(!dir.exists()){
			dir.mkdirs();
		}
		factory.setLocation(FileConfig.tempDir);
		return factory.createMultipartConfig();
	}

	@Bean
	SpringContextUtil springContextUtil(){
		return new SpringContextUtil();
	}

	@Bean
	CommonUtils getCommonUtils(){
		return new CommonUtils();
	}


}
