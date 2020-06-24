package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class PatientSummary {
    private static final Logger LOG = LoggerFactory.getLogger(org.endeavourhealth.explorer.common.models.PatientSummary.class);
    private String id;
    private String name;
    private String dob;
    private String dod;
    private String nhsNumber;
    private String address;
    private String gender;
    private String age;
    private String usual_gp;
    private String organisation;
    private String registration;
    private String start_date;
    private String mobile;

    public String getId() {
        return id;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setId(String id) {
        this.id = id;
        return this;
    }

    public String getName() {
        return name;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setName(String name) {
        this.name = name;
        return this;
    }

    public String getDob() {
        return dob;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setDob(Date dob) {
        try {
            String pattern = "dd-MMM-yyyy";
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

            this.dob = simpleDateFormat.format(dob);
        }
        catch (Exception e) {
            LOG.error(e.getMessage());
        }
        return this;
    }

    public String getDod() {
        return dod;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setDod(Date dod) {
        try {
            String pattern = "dd-MMM-yyyy";
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

            this.dod = simpleDateFormat.format(dod);
        }
        catch (Exception e) {
            LOG.error(e.getMessage());
        }
        return this;
    }

    public String getNhsNumber() {
        return nhsNumber;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setNhsNumber(String nhsNumber) {
        this.nhsNumber = nhsNumber;
        return this;
    }

    public String getAddress() {
        return address;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setAddress(String address) {
        this.address = address;
        return this;
    }

    public String getGender() {
        return gender;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setGender(String gender) {
        this.gender = gender;
        return this;
    }

    public String getAge() {
        return age;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setAge(String age) {
        this.age = age;
        return this;
    }

    public String getUsual_gp() {
        return usual_gp;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setUsual_gp(String usual_gp) {
        this.usual_gp = usual_gp;
        return this;
    }

    public String getOrganisation() {
        return organisation;
    }

    public org.endeavourhealth.explorer.common.models.PatientSummary setOrganisation(String organisation) {
        this.organisation = organisation;
        return this;
    }

    public String getRegistration() { return registration; }

    public org.endeavourhealth.explorer.common.models.PatientSummary setRegistration(String registration) {
        this.registration = registration;
        return this;
    }

    public String getStart_date() { return start_date; }

    public org.endeavourhealth.explorer.common.models.PatientSummary setStart_date(String start_date) {
        this.start_date = start_date;
        return this;
    }

    public String getMobile() { return mobile; }

    public org.endeavourhealth.explorer.common.models.PatientSummary setMobile(String mobile) {
        this.mobile = mobile;
        return this;
    }


    public String toTitleCase(String input) {
        StringBuilder titleCase = new StringBuilder(input.length());
        boolean nextTitleCase = true;

        for (char c : input.toCharArray()) {
            if (Character.isSpaceChar(c)) {
                nextTitleCase = true;
            } else if (nextTitleCase) {
                c = Character.toTitleCase(c);
                nextTitleCase = false;
            }

            titleCase.append(c);
        }

        return titleCase.toString();
    }
}
