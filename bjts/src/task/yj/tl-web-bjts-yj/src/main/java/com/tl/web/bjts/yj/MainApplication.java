package com.tl.web.bjts.yj;

import com.tl.common.utils.SpringContextUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.Charset;
import java.util.List;

@SpringBootApplication
@ServletComponentScan
@EnableScheduling
public class MainApplication {

	public static void main(String[] args) {
		ConfigurableApplicationContext context =SpringApplication.run(MainApplication.class, args);
		//new ClassPathXmlApplicationContext("classpath:motan-server.xml");
		//MotanSwitcherUtil.setSwitcherValue(MotanConstants.REGISTRY_HEARTBEAT_SWITCHER, true);

	}

	@Bean
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

	/**
	 * 声明应用容器类实例
	 * @return
	 */
	@Bean
	SpringContextUtil springContextUtil(){
		return new SpringContextUtil();
	}
}
