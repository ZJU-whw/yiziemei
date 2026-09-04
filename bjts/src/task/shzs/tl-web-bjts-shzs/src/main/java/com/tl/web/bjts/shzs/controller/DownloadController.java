package com.tl.web.bjts.shzs.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tl.web.bjts.shzs.model.SbfileVo;
import com.tl.web.bjts.shzs.service.ISbfileService;
import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *  下载审核系统读入的压缩文件服务
 * @author likun  2021-06-08
 *
 */
@Controller
public class DownloadController {
	private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@Autowired
	ISbfileService sbfileService;

	@RequestMapping("/download/sbfile")
    public void shzsAction(HttpServletRequest req, HttpServletResponse res) throws IOException, JSONException {
		
		req.setCharacterEncoding("utf-8");
		String sbidStr = req.getParameter("sbid");
		Long sbid = Long.valueOf(sbidStr);
		LOGGER.info("sbid={}-下载申报文件");
		SbfileVo sbfileVo = sbfileService.downloadSbsj(sbid);
		File file = sbfileVo.getSbFile();

		//输出
		ServletOutputStream out = null;
		try {
			res.addHeader("Content-Disposition", "attachment;filename=" + sbfileVo.getFileName());
			res.addHeader("Content-Length", "" + file.length());
			out = res.getOutputStream();
			res.setContentType("application/octet-stream");
			out.write(readFile(file));
			out.flush();
		}
		catch(Throwable t) {
			LOGGER.error("sbid={}-下载申报文件出错-{}",sbid,t);
		}
		finally {
			if(out != null)out.close();
		}
	}
	
	/**
	 * * 获取文件流
	 * @param file
	 * @return
	 */
    public static byte[] readFile(File file){
    	byte [] ins = null;
    	
    	 if(!file.exists()) return null;
         FileInputStream in = null;
         try{
             in = new FileInputStream(file);    
             ins= new byte[in.available()];    
             in.read(ins);   

         }catch (Exception e){
             e.printStackTrace();
         }finally {
             if(in != null){
                try{
                    in.close();
                }catch (IOException e){
                     e.printStackTrace();
                }
             }
         }
        return ins;
    }

}
