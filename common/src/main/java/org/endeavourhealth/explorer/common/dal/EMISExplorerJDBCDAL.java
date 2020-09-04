package org.endeavourhealth.explorer.common.dal;

import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

public class EMISExplorerJDBCDAL extends EMISBaseJDBCDAL {

    private static final Logger LOG = LoggerFactory.getLogger(EMISExplorerJDBCDAL.class);

    public OrganisationGroupsResult getOrganisationGroups(Integer page, Integer size, String selectedTypeString) throws Exception {
        OrganisationGroupsResult result = new OrganisationGroupsResult();

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "select rubric as name from extract_primary_care.allergy_view LIMIT 100";

        sqlCount = "SELECT 100";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getOrganisationGroupsList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<OrganisationGroups> getOrganisationGroupsList(ResultSet resultSet) throws SQLException {
        List<OrganisationGroups> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getOrganisationGroups(resultSet));
        }

        return result;
    }

    public static OrganisationGroups getOrganisationGroups(ResultSet resultSet) throws SQLException {
        OrganisationGroups organisationgroups = new OrganisationGroups();

        organisationgroups
                .setId(1)
                .setType("EMIS")
                .setName(resultSet.getString("name"))
                .setUpdated(Date.valueOf("2020-03-01"));
        return organisationgroups;
    }



}
