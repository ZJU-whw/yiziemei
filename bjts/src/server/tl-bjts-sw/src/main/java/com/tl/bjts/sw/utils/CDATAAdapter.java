package com.tl.bjts.sw.utils;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2018-03-28
 **/

public class CDATAAdapter  extends XmlAdapter<String, String>
{

    @Override
    public String marshal(String arg0) throws Exception
    {
        return "<![CDATA[" + arg0 + "]]>";
    }

    @Override
    public String unmarshal(String arg0) throws Exception
    {
        return arg0;
    }

}