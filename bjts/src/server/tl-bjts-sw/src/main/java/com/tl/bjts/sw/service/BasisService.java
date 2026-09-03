package com.tl.bjts.sw.service;

import com.tl.bjts.sw.dao.SysCfgTableColumnMapper;
import com.tl.bjts.sw.dao.SysCfgTableUserMapper;
import com.tl.bjts.sw.dao.TlMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ProcParam;
import com.tl.bjts.sw.model.TreeNode;
import com.tl.bjts.sw.model.domain.SysCfgTableColumn;
import com.tl.bjts.sw.model.domain.SysCfgTableUser;
import com.tl.bjts.sw.utils.PoiExcelUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/7/31.
 * @Description:
 */
@Service
public class BasisService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    SysCfgTableUserMapper sysCfgTableUserMapper;

    @Autowired
    SysCfgTableColumnMapper sysCfgTableColumnMapper;

    @Autowired
    TlMapper tlMapper;

    @Autowired
    CommonServiceImpl commonService;

    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public String getUserTableSelect(String czryDm,String tcode) {

        SysCfgTableUser sysCfgTableUser=new SysCfgTableUser();

        sysCfgTableUser.setUser_id(czryDm);
        sysCfgTableUser.setT_code(tcode);
        sysCfgTableUser.setIsvaild("1");

        SysCfgTableUser tableUser = sysCfgTableUserMapper.selectOne(sysCfgTableUser);

        if(tableUser==null){
            return "";
        }else{
            return tableUser.getCs();
        }
    }

    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public List<SysCfgTableColumn> getUserTableColumn(String tcode) {

        Example ep=new Example(SysCfgTableColumn.class);
        Example.Criteria criteria = ep.createCriteria();
        criteria.andEqualTo("t_code",tcode);
        criteria.andEqualTo("isvaild","1");

        ep.setOrderByClause("no");

        return sysCfgTableColumnMapper.selectByExample(ep);
    }

    @TargetDataSource(name= MultipleDataSourceHolder.SHZS)
    public void saveTableUserCs(String czryDm, String tcode,String cs) {

        SysCfgTableUser sysCfgTableUser=new SysCfgTableUser();
        sysCfgTableUser.setUser_id(czryDm);
        sysCfgTableUser.setT_code(tcode);
        sysCfgTableUser.setCs(cs);
        sysCfgTableUser.setUpdate_time(new Date());
        sysCfgTableUser.setIsvaild("1");

        int i = sysCfgTableUserMapper.updateByPrimaryKey(sysCfgTableUser);
        if(i==0){
            sysCfgTableUser.setIsvaild("1");
            sysCfgTableUser.setCreate_time(new Date());
            sysCfgTableUserMapper.insertSelective(sysCfgTableUser);
        }
    }

    public void exportExcel(HttpServletResponse response, List<SysCfgTableColumn> profiles) throws Exception {
        ServletOutputStream outputStream = response.getOutputStream();
        String fileName = "testEport";
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition", "attachment; filename="
                + URLEncoder.encode(fileName, "UTF-8") + ".xls");
        List<String> list=new ArrayList<>();
        PoiExcelUtil.createExcelSingleSheet(outputStream, "sheet", profiles, SysCfgTableColumn.class,list);
        // 关闭流
        outputStream.flush();
        outputStream.close();
    }

    /**
     * 根据类型和代码查找字典表的中文
     * @param dtype  字典类型
     * @param dcode  字典代码
     * @return
     */
    public String getDnameByTypeCode(String dtype,String dcode){
        return  tlMapper.selectDnameByTypeCode(dtype,dcode);
    }

    public List<TreeNode> getSelectTree(String swjgDm) {
        return tlMapper.getSelectTree(swjgDm);
    }

    protected void dealResult(ProcParam param) {
        Integer v_error = param.getV_ERROR();
        if(v_error != null && v_error!=0){
            logger.info("调用存储过程出现错误:年月{}-税务机关{}-存储过程{}-{}={}：",param.getV_SSNY(),param.getV_SWCODE(),param.getProcname(),v_error,param.getV_MSG());
            BusinessException bex=new BusinessException(v_error+":"+param.getV_MSG());
            throw bex;

        }
    }
}
