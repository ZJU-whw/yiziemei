package com.tl.web.bjts.shzs.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.ResultCode;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.web.client.HttpServerErrorException;


/**
 * 
 *  Http请求服务
 * @author likun  2017-05-11
 */
public class HttpClientUtils {
	/**
	 * post请求服务
	 * @param url  请求url
	 * @param json  请求json
	 * @param headers  请求headers
	 * @return  json结果
	 */
	public static String doPost4Str(String url,String json, Map<String, Object> headers) {
		CloseableHttpClient client = HttpClients.createDefault();

		HttpPost post = new HttpPost(url);
		String result = null;
		try {
			StringEntity s = new StringEntity(json,"UTF-8");//转成UTF-8
			s.setContentEncoding("UTF-8");
			s.setContentType("application/json");// 发送json数据需要设置contentType
			post.setEntity(s);
			if (headers != null) {
				for (Iterator localIterator = headers.entrySet().iterator(); localIterator.hasNext(); ) { Map.Entry entry = (Map.Entry)localIterator.next();
					post.setHeader((String)entry.getKey(), (String)entry.getValue());
				}
			}
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				HttpEntity entity = res.getEntity();
				String charset = "UTF-8";
				if (entity != null) {
					charset = getContentCharSet(entity);
				}
				result = EntityUtils.toString(res.getEntity(),charset);// 返回json格式：
			}
		} catch (Exception e) {
			if(e instanceof HttpServerErrorException) {
				String msg=e.getMessage()!=null?e.getMessage():e.getCause().getMessage();
				if(StringUtils.isNotBlank(msg)&&msg.indexOf("504 Gateway Time-out")!=-1) {
					throw new BusinessException(ResultCode.SERVICE_ERROR);
				}
			}else {
				throw new RuntimeException(e);
			}
		}
		return result;
	}

	public static String getContentCharSet(final HttpEntity entity)
			throws Exception {
		if (entity == null) {
			throw new IllegalArgumentException("HTTP entity may not be null");
		}
		String charset = null;
		if (entity.getContentType() != null) {
			HeaderElement values[] = entity.getContentType().getElements();
			if (values.length > 0) {
				NameValuePair param = values[0].getParameterByName("charset" );
				if (param != null) {
					charset = param.getValue();
				}
			}
		}
		if(StringUtils.isEmpty(charset)){
			charset = "UTF-8";
		}
		return charset;
	}
}
