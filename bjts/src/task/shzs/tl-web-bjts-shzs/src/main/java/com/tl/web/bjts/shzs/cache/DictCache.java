package com.tl.web.bjts.shzs.cache;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.model.Dict;
import com.tl.web.bjts.shzs.service.DictCacheService;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

/*
 * @Description: 使用guava cache 实现对字典表的缓存
 * @Author Neo Lin
 * @Date  2018/2/18 20:52
 */
@Component
public class DictCache {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private LoadingCache<String, List<Dict>> loadingCache;

    private final DictCacheService dictCacheService;

    @Autowired
    public DictCache(DictCacheService dictCacheService) {
        this.dictCacheService = dictCacheService;
    }

    @PostConstruct
    public void InitLoadingCache() {
        //指定一个如果数据不存在获取数据的方法
        CacheLoader<String, List<Dict>> cacheLoader = new CacheLoader<String, List<Dict>>() {
            @Override
            public List<Dict> load(String key) throws Exception {
                return getDicts(key);
            }
        };

        loadingCache = CacheBuilder.newBuilder().expireAfterWrite(12L, TimeUnit.HOURS).maximumSize(20).build(cacheLoader);
    }

    //获取数据，如果不存在返回null
    public List<Dict> getIfPresentloadingCache(String key) {
        return loadingCache.getIfPresent(key);
    }

    //获取数据，如果数据不存在则通过cacheLoader获取数据，缓存并返回
    public List<Dict> getCacheKeyloadingCache(String key) {
        try {
            return loadingCache.get(key);
        } catch (ExecutionException e) {
            logger.error("获取字典表缓存失败-{}",e);
        }
        return null;
    }

    //直接向缓存put数据
    public void putloadingCache(String key, List<Dict> value) {
        logger.info("put key :{} value : {}", key, value);
        loadingCache.put(key, value);
    }

    private List<Dict> getDicts(String key) {
        try {
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            List<Dict> dicts;
            switch (key) {
                case ConstUtil.DICT_BICODE:
                    dicts = dictCacheService.getBicodeDict();
                    break;
                case ConstUtil.DICT_DWCODE:
                    dicts = dictCacheService.getDwcodeDict();
                    break;
                case ConstUtil.DICT_GBCODE:
                    dicts = dictCacheService.getGbcodeDict();
                    break;
                case ConstUtil.DICT_HGCODE:
                    dicts = dictCacheService.getHgcodeDict();
                    break;
                case ConstUtil.DICT_KACODE:
                    dicts = dictCacheService.getKacodeDict();
                    break;
                case ConstUtil.DICT_HYDCODE:
                    dicts = dictCacheService.getHydcodeDict();
                    break;
                case ConstUtil.DICT_JHTYPECODE:
                    dicts = dictCacheService.getJhtypeCodeDict();
                    break;
                case ConstUtil.DICT_JSFSCODE:
                    dicts = dictCacheService.getJsfsCodeDict();
                    break;
                case ConstUtil.DICT_TDCODE:
                    dicts = dictCacheService.getTdcodeDict();
                    break;
                case ConstUtil.DICT_TRANSTYPE:
                    dicts = dictCacheService.getTranstypeDict();
                    break;
                case ConstUtil.DICT_ZYGCODE:
                    dicts = dictCacheService.getZygcodeDict();
                    break;
                case ConstUtil.DICT_CJFSCODE:
                    dicts = dictCacheService.getCjfscodeDict();
                    break;
                case ConstUtil.DICT_ZMXZCODE:
                    dicts = dictCacheService.getZmxzCodeDict();
                    break;
                case ConstUtil.DICT_BZZLCODE:
                    dicts = dictCacheService.getBzzlCodeDict();
                    break;
                default:
                    dicts = new ArrayList<>();
            }
            return dicts;
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }
}
