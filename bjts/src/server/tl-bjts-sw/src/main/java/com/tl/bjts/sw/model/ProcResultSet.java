package com.tl.bjts.sw.model;

public class ProcResultSet {
    private String retcode;
    private String retmsg;
    private String retpoint;

    public String getRetcode() {
        return retcode;
    }

    public void setRetcode(String retcode) {
        this.retcode = retcode;
    }

    public String getRetmsg() {
        return retmsg;
    }

    public void setRetmsg(String retmsg) {
        this.retmsg = retmsg;
    }

    public String getRetpoint() {
        return retpoint;
    }

    public void setRetpoint(String retpoint) {
        this.retpoint = retpoint;
    }

    @Override
    public String toString() {
        return "YsResultSet{" +
                "retcode='" + retcode + '\'' +
                ", retmsg='" + retmsg + '\'' +
                ", retpoint='" + retpoint + '\'' +
                '}';
    }
}
