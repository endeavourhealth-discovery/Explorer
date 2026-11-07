package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class AuditLog {
    private static final Logger LOG = LoggerFactory.getLogger(AuditLog.class);
    private String user;
    private String roleName;
    private String organisation;
    private String roleLevel;
    private String pid;
    private String auditType;
    private String auditDate;
    private String queryName;
    private String queryJson;
    private String records;
    private String data;

    public String getUser() {
        return user;
    }

    public AuditLog setUser(String user) {
        this.user = user;
        return this;
    }

    public String getRoleName() {
        return roleName;
    }

    public AuditLog setRoleName(String roleName) {
        this.roleName = roleName;
        return this;
    }

    public String getOrganisation() {
        return organisation;
    }

    public AuditLog setOrganisation(String organisation) {
        this.organisation = organisation;
        return this;
    }

    public String getRoleLevel() {
        return roleLevel;
    }

    public AuditLog setRoleLevel(String roleLevel) {
        this.roleLevel = roleLevel;
        return this;
    }

    public String getPid() {
        return pid;
    }

    public AuditLog setPid(String pid) {
        this.pid = pid;
        return this;
    }

    public String getAuditType() {
        return auditType;
    }

    public AuditLog setAuditType(String auditType) {
        this.auditType = auditType;
        return this;
    }

    public String getAuditDate() {
        return auditDate;
    }

    public AuditLog setAuditDate(Date auditDate) {
        try {
            String pattern = "yyyy-MM-dd HH:mm:ss";
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);

            this.auditDate = simpleDateFormat.format(auditDate);
        }
        catch (Exception e) {
            LOG.error(e.getMessage());
        }
        return this;
    }

    public String getQueryName() {
        return queryName;
    }

    public AuditLog setQueryName(String queryName) {
        this.queryName = queryName;
        return this;
    }

    public String getQueryJson() {
        return queryJson;
    }

    public AuditLog setQueryJson(String queryJson) {
        this.queryJson = queryJson;
        return this;
    }

    public String getRecords() {
        return records;
    }

    public AuditLog setRecords(String records) {
        this.records = records;
        return this;
    }

    public String getData() {
        return data;
    }

    public AuditLog setData(String data) {
        this.data = data;
        return this;
    }


}
