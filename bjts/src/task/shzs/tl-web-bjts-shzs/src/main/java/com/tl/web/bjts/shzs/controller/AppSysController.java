package com.tl.web.bjts.shzs.controller;

import com.tl.web.bjts.shzs.model.SimpleResult;
import com.tl.web.bjts.shzs.model.vo.VersionVo;
import com.tl.web.bjts.shzs.utils.VersionUtil;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("sys")
public class AppSysController {

    @RequestMapping("version")
    public SimpleResult<VersionVo> getVersion(){
        String version = VersionUtil.getHSCVersion();
        VersionVo vo = new VersionVo();
        vo.setVersion(version);
        SimpleResult<VersionVo> rtn = new SimpleResult<>();
        rtn.setData(vo);
        return rtn;
    }
}
