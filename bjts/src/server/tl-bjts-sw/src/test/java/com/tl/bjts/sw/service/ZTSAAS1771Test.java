package com.tl.bjts.sw.service;

import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.TlYjMapper;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.bo.CkllfxQrDataBO;
import com.tl.bjts.sw.model.dto.CkllfxEditDTO;
import com.tl.bjts.sw.model.dto.CkllfxQrDTO;
import com.tl.bjts.sw.model.vo.CkllfxQrVO;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.math.BigDecimal;
import java.util.Date;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

/**
 * ZTSAAS-1771 出口业务物流链路综合管理 单元测试
 * 覆盖 /yj/ckll/edit 和 /yj/ckll/qr 两个接口调用的 service 方法
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest
public class ZTSAAS1771Test {

    @Mock
    private TlYjMapper tlYjMapper;

    @Mock
    private AppProperties appProperties;

    @InjectMocks
    private YjService yjService;

    // ==================== /yj/ckll/edit → editCkllfx 测试 ====================

    /**
     * 测试 editCkllfx 成功场景：记录存在，应正常调用 updateCkllfxData
     */
    @Test
    public void testEditCkllfx_Success() {
        /* 准备测试数据 */
        CkllfxEditDTO dto = new CkllfxEditDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");
        dto.setCph("浙A12345");
        dto.setCpysCode("2");
        dto.setCpysName("黄色");
        dto.setQyrq(new Date());
        dto.setQyd("杭州");

        String qxSwjgDm = "13300000000";

        /* Mock: 校验记录存在 */
        when(tlYjMapper.countCkllfxRecord(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(1);

        /* 执行 */
        yjService.editCkllfx(dto, qxSwjgDm);

        /* 验证: updateCkllfxData 被正确调用 */
        verify(tlYjMapper).updateCkllfxData(dto);
    }

    /**
     * 测试 editCkllfx 记录不存在场景：count 返回 0，应抛出 BusinessException
     */
    @Test(expected = BusinessException.class)
    public void testEditCkllfx_RecordNotFound() {
        /* 准备测试数据 */
        CkllfxEditDTO dto = new CkllfxEditDTO();
        dto.setDjxh("999999");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* Mock: 校验记录不存在 */
        when(tlYjMapper.countCkllfxRecord(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(0);

        /* 执行，期望抛出 BusinessException */
        yjService.editCkllfx(dto, qxSwjgDm);
    }

    /**
     * 测试 editCkllfx update 失败场景：updateCkllfxData 抛出异常，应传递异常
     */
    @Test(expected = RuntimeException.class)
    public void testEditCkllfx_UpdateFailed() {
        /* 准备测试数据 */
        CkllfxEditDTO dto = new CkllfxEditDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* Mock: 校验记录存在 */
        when(tlYjMapper.countCkllfxRecord(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(1);
        /* Mock: 更新抛出运行时异常 */
        doThrow(new RuntimeException("更新数据库异常"))
                .when(tlYjMapper).updateCkllfxData(dto);

        /* 执行，期望抛出 RuntimeException */
        yjService.editCkllfx(dto, qxSwjgDm);
    }

    // ==================== /yj/ckll/qr → generateCkllQrCode 测试 ====================

    /**
     * 测试 generateCkllQrCode 成功场景：数据完整，应返回包含二维码图片的 VO
     */
    @Test
    public void testGenerateCkllQrCode_Success() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* 构造完整的二维码数据 BO */
        CkllfxQrDataBO mockQrData = new CkllfxQrDataBO();
        mockQrData.setBgdhgbh("123456789012345678");
        mockQrData.setCph("浙A12345");
        mockQrData.setCpysCode("2");
        mockQrData.setQyrq(new Date());
        mockQrData.setQydAddr("杭州");
        mockQrData.setNsrsbh("913301000000000000");
        mockQrData.setNsrmc("测试企业");
        mockQrData.setSwjgdm("13300000000");
        mockQrData.setCkrq(new Date());
        mockQrData.setMylaj(new BigDecimal("10000.00"));
        mockQrData.setSpDm("12345678");
        mockQrData.setSpMc("测试商品");
        mockQrData.setYsfsDm("1");
        mockQrData.setFhmsDm("1");

        /* Mock: Mapper 返回完整数据 */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(mockQrData);

        /* Mock: 配置属性 */
        when(appProperties.getQrYsyBaseUrl()).thenReturn("http://app.hzztsoft.net/qrYsy/");
        when(appProperties.getQrCodeSize()).thenReturn(300);

        /* 执行 */
        CkllfxQrVO vo = yjService.generateCkllQrCode(dto, qxSwjgDm);

        /* 验证: 返回结果不为空 */
        assertNotNull("二维码 VO 不能为 null", vo);
        assertNotNull("二维码 base64 数据不能为 null", vo.getQrBase());
        assertTrue("二维码 base64 数据长度应大于 0", vo.getQrBase().length() > 0);
        assertEquals("格式应为 png", "png", vo.getFormat());
    }

    /**
     * 测试 generateCkllQrCode 数据不存在场景：queryCkllfxQrData 返回 null，应抛出 BusinessException
     */
    @Test(expected = BusinessException.class)
    public void testGenerateCkllQrCode_DataNotFound() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("999999");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* Mock: 查询返回 null */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(null);

        /* 执行，期望抛出 BusinessException */
        yjService.generateCkllQrCode(dto, qxSwjgDm);
    }

    /**
     * 测试 generateCkllQrCode 校验失败场景：车牌号为空，应抛出 BusinessException
     */
    @Test(expected = BusinessException.class)
    public void testGenerateCkllQrCode_ValidationFailed_CphEmpty() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* 构造缺少车牌号的二维码数据 */
        CkllfxQrDataBO mockQrData = new CkllfxQrDataBO();
        mockQrData.setBgdhgbh("123456789012345678");
        mockQrData.setCph(null);      // 车牌号为空
        mockQrData.setCpysCode("2");
        mockQrData.setQyrq(new Date());
        mockQrData.setQydAddr("杭州");

        /* Mock: Mapper 返回带缺失字段的数据 */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(mockQrData);

        /* 执行，期望抛出 BusinessException */
        yjService.generateCkllQrCode(dto, qxSwjgDm);
    }

    /**
     * 测试 generateCkllQrCode 校验失败场景：起运日为空，应抛出 BusinessException
     */
    @Test(expected = BusinessException.class)
    public void testGenerateCkllQrCode_ValidationFailed_QyrqNull() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* 构造缺少起运日的二维码数据 */
        CkllfxQrDataBO mockQrData = new CkllfxQrDataBO();
        mockQrData.setBgdhgbh("123456789012345678");
        mockQrData.setCph("浙A12345");
        mockQrData.setCpysCode("2");
        mockQrData.setQyrq(null);      // 起运日为空
        mockQrData.setQydAddr("杭州");

        /* Mock: Mapper 返回带缺失字段的数据 */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(mockQrData);

        /* 执行，期望抛出 BusinessException */
        yjService.generateCkllQrCode(dto, qxSwjgDm);
    }

    /**
     * 测试 generateCkllQrCode 校验失败场景：启运地为空，应抛出 BusinessException
     */
    @Test(expected = BusinessException.class)
    public void testGenerateCkllQrCode_ValidationFailed_QydAddrEmpty() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* 构造缺少启运地的二维码数据 */
        CkllfxQrDataBO mockQrData = new CkllfxQrDataBO();
        mockQrData.setBgdhgbh("123456789012345678");
        mockQrData.setCph("浙A12345");
        mockQrData.setCpysCode("2");
        mockQrData.setQyrq(new Date());
        mockQrData.setQydAddr(null);   // 启运地为空

        /* Mock: Mapper 返回带缺失字段的数据 */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(mockQrData);

        /* 执行，期望抛出 BusinessException */
        yjService.generateCkllQrCode(dto, qxSwjgDm);
    }

    /**
     * 测试 generateCkllQrCode 车牌颜色为空场景：应自动赋值为黄色（2）
     */
    @Test
    public void testGenerateCkllQrCode_CpysCodeEmpty_DefaultYellow() {
        /* 准备测试数据 */
        CkllfxQrDTO dto = new CkllfxQrDTO();
        dto.setDjxh("123456");
        dto.setBgdhgbh("123456789012345678");

        String qxSwjgDm = "13300000000";

        /* 构造车牌颜色为空的二维码数据 */
        CkllfxQrDataBO mockQrData = new CkllfxQrDataBO();
        mockQrData.setBgdhgbh("123456789012345678");
        mockQrData.setCph("浙A12345");
        mockQrData.setCpysCode(null);  // 车牌颜色为空，默认应赋黄色
        mockQrData.setQyrq(new Date());
        mockQrData.setQydAddr("杭州");
        mockQrData.setNsrsbh("913301000000000000");
        mockQrData.setNsrmc("测试企业");
        mockQrData.setSwjgdm("13300000000");

        /* Mock: Mapper 返回数据 */
        when(tlYjMapper.queryCkllfxQrData(any(BigDecimal.class), anyString(), anyString()))
                .thenReturn(mockQrData);
        when(appProperties.getQrYsyBaseUrl()).thenReturn("http://app.hzztsoft.net/qrYsy/");
        when(appProperties.getQrCodeSize()).thenReturn(300);

        /* 执行 */
        CkllfxQrVO vo = yjService.generateCkllQrCode(dto, qxSwjgDm);

        /* 验证: 正常返回，不因 cpysCode 为空而失败 */
        assertNotNull("二维码 VO 不能为 null", vo);
        assertNotNull("二维码 base64 数据不能为 null", vo.getQrBase());
    }
}
