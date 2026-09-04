package com.tl.web.bjts.yj.service;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.exception.BusinessException;
import com.tl.web.bjts.yj.model.domain.DmGbcodeModel;
import com.tl.web.bjts.yj.model.domain.DmXzqhModel;
import com.tl.web.bjts.yj.model.domain.HgcodeXzqhModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author: Mamf
 * @date: 2026-05-09
 * @description:本地缓存服务（泛型版本）
 */
@Service
public class LocalCache {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private YjMapper yjMapper;

    public static final String DM_XZQH = "DM_XZQH";      // 行政区域代码表
    public static final String DM_HGCODE = "DM_HGCODE";  // 海关地区代码表
    public static final String DM_GBCODE = "DM_GBCODE";  // 代码国别地区表

    /**
     * 行政区域代码表缓存（全量数据）
     */
    private LoadingCache<String, List<DmXzqhModel>> dmXzqhCache = CacheBuilder.newBuilder()
            .expireAfterAccess(10, TimeUnit.MINUTES)
            .maximumSize(1000)
            .build(new CacheLoader<String, List<DmXzqhModel>>() {
                @Override
                public List<DmXzqhModel> load(String key) throws Exception {
                    List<DmXzqhModel> dmXzqhModels;
                    try {
                        dmXzqhModels = yjMapper.selectDmXzqhModels();
                    } catch (Exception e) {
                        LOGGER.error("代码-{}-从缓存获取行政区域数据出错-{}", key, e);
                        throw new BusinessException("100", "代码【" + key + "】获取行政区域数据字典出错。");
                    }
                    if (CollectionUtils.isEmpty(dmXzqhModels)) {
                        throw new BusinessException("101", "代码【" + key + "】行政区域数据字典不存在。");
                    }
                    return dmXzqhModels;
                }
            });

    /**
     * 海关地区代码表缓存（全量数据）
     */
    private LoadingCache<String, List<HgcodeXzqhModel>> hgcodeXzqhCache = CacheBuilder.newBuilder()
            .expireAfterAccess(10, TimeUnit.MINUTES)
            .maximumSize(1000)
            .build(new CacheLoader<String, List<HgcodeXzqhModel>>() {
                @Override
                public List<HgcodeXzqhModel> load(String key) throws Exception {
                    List<HgcodeXzqhModel> hgcodeXzqhModels;
                    try {
                        hgcodeXzqhModels = yjMapper.selectHgcodeXzqhModels();
                    } catch (Exception e) {
                        LOGGER.error("代码-{}-从缓存获取海关地区数据出错-{}", key, e);
                        throw new BusinessException("100", "代码【" + key + "】获取海关地区数据字典出错。");
                    }
                    if (CollectionUtils.isEmpty(hgcodeXzqhModels)) {
                        throw new BusinessException("101", "代码【" + key + "】海关地区数据字典不存在。");
                    }
                    return hgcodeXzqhModels;
                }
            });


    /**
     * 海关地区代码表缓存（全量数据）
     */
    private LoadingCache<String, List<DmGbcodeModel>> gbcodeXzqhCache = CacheBuilder.newBuilder()
            .expireAfterAccess(10, TimeUnit.MINUTES)
            .maximumSize(1000)
            .build(new CacheLoader<String, List<DmGbcodeModel>>() {
                @Override
                public List<DmGbcodeModel> load(String key) throws Exception {
                    List<DmGbcodeModel> gbcodeXzqhModels;
                    try {
                        gbcodeXzqhModels = yjMapper.selectGbcodeXzqhModels();
                    } catch (Exception e) {
                        LOGGER.error("代码-{}-从缓存获取国别代码数据出错-{}", key, e);
                        throw new BusinessException("100", "代码【" + key + "】获取国别代码字典出错。");
                    }
                    if (CollectionUtils.isEmpty(gbcodeXzqhModels)) {
                        throw new BusinessException("101", "代码【" + key + "】海关国别代码字典不存在。");
                    }
                    return gbcodeXzqhModels;
                }
            });

    /**
     * 获取缓存（泛型方法）
     *
     * @param type 缓存类型
     * @param <T>  缓存值类型
     * @return LoadingCache实例
     */
    @SuppressWarnings("unchecked")
    private <T> LoadingCache<String, T> getCache(String type) {
        if (DM_XZQH.equals(type)) {
            return (LoadingCache<String, T>) dmXzqhCache;
        } else if (DM_HGCODE.equals(type)) {
            return (LoadingCache<String, T>) hgcodeXzqhCache;
        } else if (DM_GBCODE.equals(type)) {
            return (LoadingCache<String, T>) gbcodeXzqhCache;
        }else {
            return null;
        }
    }

    /**
     * 获取缓存的全量数据（推荐使用此方法）
     *
     * @param type 缓存类型
     * @param <T>  数据类型
     * @return 数据列表
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> getList(String type) {
        LoadingCache<String, T> cache = getCache(type);
        if (cache == null) {
            LOGGER.error("不支持的缓存类型: {}", type);
            return null;
        }

        try {
            // 使用固定key获取全量数据
            T value = cache.get("ALL_DATA");
            if (value instanceof List) {
                return (List<T>) value;
            }
            return null;
        } catch (Exception e) {
            LOGGER.error("从缓存获取列表数据出错, type: {}", type, e);
            if (e instanceof BusinessException) {
                throw (BusinessException) e;
            }
            return null;
        }
    }

    /**
     * 根据代码获取单个实体（从缓存列表中查找）
     *
     * @param type    缓存类型
     * @param code    代码值
     * @param mapper  代码匹配函数
     * @param <T>     实体类型
     * @return 匹配的实体，未找到返回null
     */
    public <T> T getByCode(String type, String code, Function<T, String> mapper) {
        List<T> list = getList(type);
        if (CollectionUtils.isEmpty(list)) {
            return null;
        }

        return list.stream()
                .filter(item -> code.equals(mapper.apply(item)))
                .findFirst()
                .orElse(null);
    }

    /**
     * 根据代码获取名称（通用方法）
     *
     * @param type        缓存类型
     * @param code        代码值
     * @param codeMapper  获取代码的函数
     * @param nameMapper  获取名称的函数
     * @param <T>         实体类型
     * @return 名称，未找到返回null
     */
    public <T> String getNameByCode(String type, String code,
                                    Function<T, String> codeMapper,
                                    Function<T, String> nameMapper) {
        T entity = getByCode(type, code, codeMapper);
        if (entity != null) {
            return nameMapper.apply(entity);
        }
        return null;
    }

    /**
     * 获取代码到名称的映射Map
     *
     * @param type        缓存类型
     * @param codeMapper  获取代码的函数
     * @param nameMapper  获取名称的函数
     * @param <T>         实体类型
     * @return Map<代码, 名称>
     */
    public <T> Map<String, String> getCodeNameMap(String type,
                                                  Function<T, String> codeMapper,
                                                  Function<T, String> nameMapper) {
        List<T> list = getList(type);
        if (CollectionUtils.isEmpty(list)) {
            return Collections.emptyMap();
        }

        return list.stream()
                .collect(Collectors.toMap(
                        item -> {
                            String code = codeMapper.apply(item);
                            return code != null ? code : "";
                        },
                        item -> {
                            String name = nameMapper.apply(item);
                            return name != null ? name : "";
                        },
                        (v1, v2) -> v1
                ));
    }

    /**
     * 手动刷新缓存
     *
     * @param type 缓存类型
     */
    public void refreshCache(String type) {
        LoadingCache<String, ?> cache = getCache(type);
        if (cache != null) {
            cache.invalidateAll();
            LOGGER.info("刷新缓存成功, type: {}", type);
        }
    }

    /**
     * 手动刷新所有缓存
     */
    public void refreshAllCache() {
        dmXzqhCache.invalidateAll();
        hgcodeXzqhCache.invalidateAll();
        gbcodeXzqhCache.invalidateAll();
        LOGGER.info("刷新所有缓存成功");
    }

}