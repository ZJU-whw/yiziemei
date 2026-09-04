package com.tl.web.bjts.shzs;

import com.tl.common.ext.utils.CommonUtils;
import com.tl.common.utils.SpringContextUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.cloud.client.SpringCloudApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.Charset;
import java.util.List;

@SpringCloudApplication
@ServletComponentScan
@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})
@EnableScheduling
@EnableAspectJAutoProxy(exposeProxy = true)
public class MainApplication {

	public static void main(String[] args) {
		SpringApplication.run(MainApplication.class, args);
	}

	/**
	 * 服务调用模版 开启负载
	 * @return
	 */
	RestTemplate restTemplate() {
		/**
		 * 设置超时时间
		 */
		HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
		// 从连接池获取连接的timeout
		httpRequestFactory.setConnectionRequestTimeout(5000);
		// 客户端和服务器建立连接的timeout
		httpRequestFactory.setConnectTimeout(30000);
		// 客户端从服务器读取数据的timeout
		httpRequestFactory.setReadTimeout(90000);
		RestTemplate restTemplate = new RestTemplate(httpRequestFactory);

		/**
		 * 处理编码
		 */
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
		return restTemplate;
	}

	/**
	 * 用于负载，使用注册中心的服务名
	 * @return
	 */
	@Bean(name = "loadRestTemplate")
	@LoadBalanced
	RestTemplate loadRestTemplate() {
		return restTemplate();
	}

	/**
	 * 用于访问使用ip和端口的方式
	 * @return
	 */
	@Bean(name = "nonLoadRestTemplate")
	RestTemplate nonLoadRestTemplate() {
		return restTemplate();
	}

	/**
	 * 声明应用容器类实例
	 * @return
	 */
	@Bean
	SpringContextUtil springContextUtil(){
		return new SpringContextUtil();
	}

	@Bean
	CommonUtils getCommonUtils(){
		return new CommonUtils();
	}


}
