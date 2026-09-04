package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.FjxxViewVo;
import com.tl.web.bjts.shzs.model.FjxxVo;
import com.tl.web.bjts.shzs.model.SbfileVo;
import org.springframework.stereotype.Service;

import java.io.FileNotFoundException;
import java.util.Map;

/**附件、申报文件接口
 * Created by likun on 17-6-19.
 */
@Service
public interface DocFileinfoService {
    /**
     * 附件列表
     * @param sbid 申报id
     * @return 附件信息列表Vo对象
     */
    public FjxxViewVo view(Long sbid);

    /**
     * 下载附件
     * @param fileId 文件id
     * @return
     */
    public FjxxVo download(Long fileId);

}
