package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class Population {
    private static final Logger LOG = LoggerFactory.getLogger(Population.class);
    private String stp;
    private String ccg;
    private String pcn;
    private String practice;
    private String ethnic;
    private String age;
    private String sex;
    private String listSize;
    private String odsCode;

    public String getStp() {
        return stp;
    }

    public Population setStp(String stp) {
        this.stp = stp;
        return this;
    }

    public String getCcg() {
        return ccg;
    }

    public Population setCcg(String ccg) {
        this.ccg = ccg;
        return this;
    }

    public String getPcn() {
        return pcn;
    }

    public Population setPcn(String pcn) {
        this.pcn = pcn;
        return this;
    }

    public String getPractice() {
        return practice;
    }

    public Population setPractice(String practice) {
        this.practice = practice;
        return this;
    }

    public String getEthnic() {
        return ethnic;
    }

    public Population setEthnic(String ethnic) {
        this.ethnic = ethnic;
        return this;
    }

    public String getAge() {
        return age;
    }

    public Population setAge(String age) {
        this.age = age;
        return this;
    }

    public String getSex() {
        return sex;
    }

    public Population setSex(String sex) {
        this.sex = sex;
        return this;
    }

    public String getListSize() {
        return listSize;
    }

    public Population setListSize(String listSize) {
        this.listSize = listSize;
        return this;
    }

    public String getOdsCode() {
        return odsCode;
    }

    public Population setOdsCode(String odsCode) {
        this.odsCode = odsCode;
        return this;
    }
}
