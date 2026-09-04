package com.tl.web.bjts.shzs.service;

import com.tl.common.ext.model.PageInfo;
import com.tl.web.bjts.shzs.model.domain.ShzsWpSwryProfile;
import com.tl.web.bjts.shzs.model.domain.ShzsWpTaskProfile;
import com.tl.web.bjts.shzs.model.domain.TlUserProfile;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbrwmxVo;
import com.tl.web.bjts.shzs.model.dto.dbwp.DbwpDTO;
import com.tl.web.bjts.shzs.model.dto.dbwp.LoggeQueryDTO;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpResultVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.DbwpSlVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.LcswsxVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.SwryVo;

import java.util.List;

public interface IDbwpService {


    DbwpSlVo getDbwpTaskNum(ShzsWpSwryProfile swryProfile);

    PageInfo getDbrwmx(DbwpDTO dbwpDTO, ShzsWpSwryProfile swryProfile);

    List<SwryVo> getSwryBySwjg(String swjgDm, String gwxh);

    void fillSwryStatus(List<SwryVo> swryVos);

    void dbswryUpdateStatus(DbwpDTO dbwpDTO, String gwxh);

    List<DbwpResultVo> submitAutoDbwp(List<DbrwmxVo> wpMxs, String swjgDm, TlUserProfile currentUser);

    List<ShzsWpTaskProfile> initTaskProfiles(List<ShzsWpTaskProfile> mxs, TlUserProfile userProfile);

    void writebackWpResult(List<ShzsWpTaskProfile> results, String czryMc);

    ShzsWpSwryProfile getWpswry(String swjgDm, String czryDm);

    List<LcswsxVo> selectLcswsxList(ShzsWpSwryProfile swryProfile);

    List queryLoggerList(LoggeQueryDTO loggeQueryDTO, String swjgDm);

    List<LcswsxVo> selectAllLcswsxList();
}
