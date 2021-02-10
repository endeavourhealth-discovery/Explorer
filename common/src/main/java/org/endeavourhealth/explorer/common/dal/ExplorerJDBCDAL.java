package org.endeavourhealth.explorer.common.dal;

import com.amazonaws.util.StringUtils;
import com.facebook.presto.jdbc.internal.google.api.client.json.Json;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.endeavourhealth.explorer.common.models.*;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.rmi.registry.Registry;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;
import org.endeavourhealth.core.database.rdbms.enterprise.EnterpriseConnector;
import java.sql.Connection;

public class ExplorerJDBCDAL implements AutoCloseable {

    private static final Logger LOG = LoggerFactory.getLogger(ExplorerJDBCDAL.class);

    List<String> validOrgs = new ArrayList<>();
    Connection connection = null;

    public void setValidOrgs(List<String> orgs) {
        validOrgs = orgs;
    }

    public void closeSubscriberConnection() throws Exception {
        this.connection.close();
    }

    public void setSubscriberConnection(String configName) throws Exception {
        List<EnterpriseConnector.ConnectionWrapper> connectionWrappers = EnterpriseConnector.openSubscriberConnections(configName);

        for (EnterpriseConnector.ConnectionWrapper wrapper: connectionWrappers) {

            if (wrapper.hasDatabaseConnection()) {

                connection = wrapper.getConnection();
                break;
            }
        }

        if (connection == null) {
            LOG.info("Connection has not been found");
            throw new Exception("Connection has not been found");
        }

    }

    public void deleteValueSetCode(String id) throws Exception {

        String ids[] = id.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "DELETE FROM dashboards.value_set_codes WHERE id in ("+builder.deleteCharAt( builder.length() -1 ).toString()+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }
    }

    public void saveValueSetCode(String type, String selectedDataType, String code, String term, String snomed, String value_set_id, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.value_set_codes (type, data_type, original_code, original_term, snomed_id, value_set_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, selectedDataType);
                stmt.setString(3, code);
                stmt.setString(4, term);
                stmt.setString(5, snomed);
                stmt.setString(6, value_set_id);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.value_set_codes SET type = ?, data_type = ?, original_code = ?, original_term = ?, snomed_id = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, selectedDataType);
                stmt.setString(3, code);
                stmt.setString(4, term);
                stmt.setString(5, snomed);
                stmt.setString(6, id);
                stmt.executeUpdate();
            }
        }
    }

    public void duplicateValueSet(String id) throws Exception {

        String sql = "insert into dashboards.value_sets (type, name) " +
                "select type, concat('Copy of ',name) from dashboards.value_sets where id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }

        String sqlCount = "insert into dashboards.value_set_codes (value_set_id, type, original_code, original_term, snomed_id) " +
                "select (select max(id) as id from dashboards.value_sets), type, original_code, original_term, snomed_id " +
                "from dashboards.value_set_codes " +
                "where value_set_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sqlCount)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteDashboard(String dashboardId) throws Exception {

        String ids[] = dashboardId.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "DELETE FROM dashboards.dashboard_library WHERE dashboard_id in ("+builder.deleteCharAt( builder.length() -1 ).toString()+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

    }

    public void saveDashboard(String type, String name, String dashboardId, String jsonQuery) throws Exception {

        String sql = "";

        if (dashboardId.equals("")) {
            sql = "INSERT INTO dashboards.dashboard_library (type, name, query) " +
                    "VALUES (?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, jsonQuery);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.dashboard_library SET type = ?, name = ?, query = ? " +
                    "WHERE dashboard_id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, jsonQuery);
                stmt.setString(4, dashboardId);
                stmt.executeUpdate();
            }
        }
    }

    public void duplicateDashboard(String id) throws Exception {

        String sql = "insert into dashboards.dashboard_library (type, name, query) " +
                "select type, concat('Copy of ',name), query from dashboards.dashboard_library where dashboard_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteQuery(String id) throws Exception {

        String ids[] = id.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "DELETE FROM dashboards.query_library WHERE id in ("+builder.deleteCharAt( builder.length() -1 ).toString()+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }
    }

    public void saveQuery(String type, String name, String registryName, String denominatorQuery, String id, String jsonQuery) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.query_library (type, name, registry_name, denominator_query, query) " +
                    "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, registryName);
                stmt.setString(4, denominatorQuery);
                stmt.setString(5, jsonQuery);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.query_library SET type = ?, name = ?, registry_name = ?, denominator_query = ?, query = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, registryName);
                stmt.setString(4, denominatorQuery);
                stmt.setString(5, jsonQuery);
                stmt.setString(6, id);
                stmt.executeUpdate();
            }
        }
    }

    public void duplicateQuery(String id) throws Exception {

        String sql = "insert into dashboards.query_library (type, name, registry_name, denominator_query, query) " +
                "select type, concat('Copy of ',name), concat('Copy of ',registry_name), denominator_query, query from dashboards.query_library where id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteValueSet(String id) throws Exception {
        String ids[] = id.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        String sql = "DELETE FROM dashboards.value_sets WHERE id in ("+params+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

        sql = "DELETE FROM dashboards.value_set_codes WHERE value_set_id in ("+params+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

    }

    public void saveValueSet(String type, String name, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.value_sets (type, name) " +
                    "VALUES (?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.value_sets SET type = ?, name = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, id);
                stmt.executeUpdate();
            }
        }
    }

    public LookupListResult getLookupLists(String list, String type) throws Exception {
        LookupListResult result = new LookupListResult();

        String sql = "";
        String sqlCount = "";
        String typeSQL = "";
        if (!type.isEmpty())
            typeSQL = " where data_type = ? ";

        switch (list) {
            case "1":
                sql = "SELECT distinct(type) as type " +
                        "FROM dashboards.dashboard_library " +
                        " order by type";

                sqlCount = "SELECT count(distinct(type)) " +
                        " FROM dashboards.dashboard_library";
                break;
            case "2":
                sql = "SELECT distinct(type) as type " +
                        "FROM dashboards.query_library " +
                        " order by type";

                sqlCount = "SELECT count(distinct(type)) " +
                        " FROM dashboards.query_library";
                break;
            case "4":
                sql = "SELECT distinct(type) as type " +
                        "FROM dashboards.value_sets " +
                        " order by type";

                sqlCount = "SELECT count(distinct(type)) " +
                        " FROM dashboards.value_sets";
                break;
            case "5":
                sql = "SELECT distinct(ccg) as type " +
                        "FROM dashboards.registries " +
                        " order by ccg";

                sqlCount = "SELECT count(distinct(ccg)) " +
                        " FROM dashboards.registries";
                break;
            case "8":
                sql = "SELECT distinct(type) " +
                        "FROM dashboards.value_set_codes " + typeSQL +
                        " order by type";

                sqlCount = "SELECT count(distinct(type)) " +
                        " FROM dashboards.value_set_codes";
                break;
            case "9":
                sql = "SELECT distinct(type) as type " +
                        "FROM dashboards.organisation_groups" +
                        " order by type";

                sqlCount = "SELECT count(distinct(type))" +
                        " FROM dashboards.organisation_groups";
                break;
            case "10":
                sql = "SELECT distinct(name) as type " +
                        "FROM dashboards.organisation_groups" +
                        " order by name";

                sqlCount = "SELECT count(distinct(name))" +
                        " FROM dashboards.organisation_groups";
                break;
            case "11":
                sql = "SELECT distinct(name) as type " +
                        "FROM dashboards.query_library " +
                        " order by name";

                sqlCount = "SELECT count(distinct(name)) " +
                        " FROM dashboards.query_library";
                break;
            case "12":
                sql = "select distinct(name) as type "+
                        "FROM dashboards.query_library " +
                        " order by type";

                sqlCount = "SELECT count(distinct(name)) " +
                        " FROM dashboards.query_library";
                break;
            case "13":
                sql = "SELECT distinct(field_name) as type " +
                        "FROM dashboards.dataset_tables where table_name = 'patient' " +
                        " order by field_name";

                sqlCount = "SELECT count(distinct(field_name)) " +
                        " FROM dashboards.dataset_tables where table_name = 'patient'";
                break;
            case "14":
                sql = "SELECT distinct(field_name) as type " +
                        "FROM dashboards.dataset_tables where table_name = 'observation' " +
                        " order by field_name";

                sqlCount = "SELECT count(distinct(field_name)) " +
                        " FROM dashboards.dataset_tables where table_name = 'observation'";
                break;
            case "15":
                sql = "SELECT distinct(field_name) as type " +
                        "FROM dashboards.dataset_tables where table_name = 'medication_statement' " +
                        " order by field_name";

                sqlCount = "SELECT count(distinct(field_name)) " +
                        " FROM dashboards.dataset_tables where table_name = 'medication_statement'";
                break;
            case "16":
                sql = "SELECT distinct(field_name) as type " +
                        "FROM dashboards.dataset_tables where table_name = 'encounter' " +
                        " order by field_name";

                sqlCount = "SELECT count(distinct(field_name)) " +
                        " FROM dashboards.dataset_tables where table_name = 'encounter'";
                break;
            case "17":
                sql = "SELECT distinct(registry) as type " +
                        "FROM dashboards.registries " +
                        " order by registry";

                sqlCount = "SELECT count(distinct(registry)) " +
                        " FROM dashboards.registries";
                break;
            case "18":
                sql = "SELECT distinct(practice_name) as type " +
                        "FROM dashboards.registries " +
                        " order by practice_name";

                sqlCount = "SELECT count(distinct(practice_name)) " +
                        " FROM dashboards.registries";
                break;
            case "19":
                sql = "SELECT distinct(type) as type " +
                        "FROM dashboards.value_set_codes where value_set_id = 4 " +
                        " order by type";

                sqlCount = "SELECT count(distinct(type)) " +
                        " FROM dashboards.value_set_codes where value_set_id = 4";
                break;
            case "20":
                sql = "SELECT distinct(original_code) as type " +
                        "FROM dashboards.value_set_codes where value_set_id = 95 " +
                        " order by type";

                sqlCount = "SELECT count(distinct(original_code)) " +
                        " FROM dashboards.value_set_codes where value_set_id = 95";
                break;
            case "21":
                sql = "SELECT distinct(original_code) as type " +
                        "FROM dashboards.value_set_codes where value_set_id = 96 " +
                        " order by type";

                sqlCount = "SELECT count(distinct(original_code)) " +
                        " FROM dashboards.value_set_codes where value_set_id = 96";
                break;
            default:
                break;
        }

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            if (!type.isEmpty())
                statement.setString(1, type);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getLookupList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    public LookupListResult getLookupListByValueSet(String valueSetId) throws Exception {
        LookupListResult result = new LookupListResult();

        String sql = "SELECT distinct(type) " +
                " FROM dashboards.value_set_codes" +
                " WHERE value_set_id = ? " +
                " order by type";

        String sqlCount = "SELECT count(distinct(type)) " +
                " FROM dashboards.value_set_codes" +
                " WHERE value_set_id = ? ";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, Integer.valueOf(valueSetId));
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getLookupList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            statement.setInt(1, Integer.valueOf(valueSetId));
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<LookupList> getLookupList(ResultSet resultSet) throws SQLException {
        List<LookupList> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getLookup(resultSet));
        }

        return result;
    }

    public static LookupList getLookup(ResultSet resultSet) throws SQLException {
        LookupList lookupList = new LookupList();

        lookupList
                .setType(resultSet.getString("type"));
        return lookupList;
    }

    public QueryLibraryResult getQueryLibrary(String selectedTypeString) throws Exception {
        QueryLibraryResult result = new QueryLibraryResult();

        String ids[] = selectedTypeString.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "";
        String sqlCount = "";
        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        sql = "SELECT id, type, name, registry_name, denominator_query, updated, query " +
                "FROM dashboards.query_library WHERE type in ("+params+")"+
                " order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.query_library WHERE type in ("+params+")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getQueryLibraryList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<QueryLibrary> getQueryLibraryList(ResultSet resultSet) throws SQLException {
        List<QueryLibrary> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getQueryLibrary(resultSet));
        }

        return result;
    }

    public static QueryLibrary getQueryLibrary(ResultSet resultSet) throws SQLException {
        QueryLibrary querylibrary = new QueryLibrary();

        querylibrary
                .setId(resultSet.getString("id"))
                .setType(resultSet.getString("type"))
                .setName(resultSet.getString("name"))
                .setRegistryName(resultSet.getString("registry_name"))
                .setDenominatorQuery(resultSet.getString("denominator_query"))
                .setUpdated(resultSet.getDate("updated"))
                .setQuery(resultSet.getString("query"));
        return querylibrary;
    }

    public ValueSetCodeResult getValueSetCodes(String valueSetId, String selectedTypeString) throws Exception {
        ValueSetCodeResult result = new ValueSetCodeResult();

        String sql = "";
        String sqlCount = "";

        String ids[] = selectedTypeString.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();


        sql = "SELECT type, data_type, original_code, original_term, snomed_id, updated, id " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? and type in ("+params+")"+
                " order by type, original_term";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? and type in ("+params+")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, valueSetId);
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i+1, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            statement.setString(1, valueSetId);
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i+1, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<ValueSetCode> getValueSetList(ResultSet resultSet) throws SQLException {
        List<ValueSetCode> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getValueSet(resultSet));
        }

        return result;
    }

    public static ValueSetCode getValueSet(ResultSet resultSet) throws SQLException {
        ValueSetCode valueset = new ValueSetCode();

        valueset
                .setType(resultSet.getString("type"))
                .setDataType(resultSet.getString("data_type"))
                .setCode(resultSet.getString("original_code"))
                .setTerm(resultSet.getString("original_term"))
                .setSnomed(resultSet.getString("snomed_id"))
                .setUpdated(resultSet.getDate("updated"))
                .setId(resultSet.getString("id"));
        return valueset;
    }

    public ValueSetLibraryResult getValueSetLibrary(String selectedTypeString) throws Exception {
        ValueSetLibraryResult result = new ValueSetLibraryResult();

        String ids[] = selectedTypeString.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, type, name, updated " +
                "FROM dashboards.value_sets where type in ("+params+")"+
                " order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_sets where type in ("+params+")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetLibraryList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<ValueSetLibrary> getValueSetLibraryList(ResultSet resultSet) throws SQLException {
        List<ValueSetLibrary> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getValueSetLibrary(resultSet));
        }

        return result;
    }

    public static ValueSetLibrary getValueSetLibrary(ResultSet resultSet) throws SQLException {
        ValueSetLibrary valuesetlibrary = new ValueSetLibrary();

        valuesetlibrary
                .setId(resultSet.getInt("id"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"))
                .setType(resultSet.getString("type"));
        return valuesetlibrary;
    }

    public DashboardLibraryResult getDashboardLibrary(String selectedTypeString) throws Exception {
        DashboardLibraryResult result = new DashboardLibraryResult();

        String ids[] = selectedTypeString.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "";
        String sqlCount = "";
        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        sql = "SELECT dashboard_id, name, updated, type, query " +
                "FROM dashboards.dashboard_library WHERE type in ("+params+")"+
                " order by type,name";

        sqlCount = "SELECT count(1) " +
                " FROM dashboards.dashboard_library WHERE type in ("+params+")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getDashboardList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<DashboardLibrary> getDashboardList(ResultSet resultSet) throws SQLException {
        List<DashboardLibrary> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getDashboard(resultSet));
        }

        return result;
    }

    public static DashboardLibrary getDashboard(ResultSet resultSet) throws SQLException {
        DashboardLibrary dashboardLibrary = new DashboardLibrary();

        dashboardLibrary
                .setDashboardId(resultSet.getInt("dashboard_id"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"))
                .setType(resultSet.getString("type"))
                .setJsonQuery(resultSet.getString("query"));
        return dashboardLibrary;
    }

    public CovidLibraryResult getCovidLibrary() throws Exception {
        CovidLibraryResult result = new CovidLibraryResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT dashboard_id, name, updated, type, query " +
                "FROM dashboards.covid_library "+
                " order by type,name";

        sqlCount = "SELECT count(1) " +
                " FROM dashboards.covid_library";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getCovidList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<CovidLibrary> getCovidList(ResultSet resultSet) throws SQLException {
        List<CovidLibrary> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getCovid(resultSet));
        }

        return result;
    }

    public static CovidLibrary getCovid(ResultSet resultSet) throws SQLException {
        CovidLibrary covidLibrary = new CovidLibrary();

        covidLibrary
                .setDashboardId(resultSet.getInt("dashboard_id"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"))
                .setType(resultSet.getString("type"))
                .setJsonQuery(resultSet.getString("query"));
        return covidLibrary;
    }

    public ChartResult getDashboardCovid(String dashboardId, String series, String dateFrom, String dateTo, String stp, String ccg, String pcn, String practice, String ethnic, String age, String sex,
                                         String cumulative, String weekly, String rate,String combineSeries, String combineEthnic, String combineAge, String combineSex, String combineOrgs) throws Exception {

        List<String> orgs = null;
        String orgParams = "";
        String orgArray[] = new String[0];

        if (!stp.equals("")) {
            orgs = Arrays.asList(stp.split("\\s*,\\s*"));
            orgArray = stp.split(",");
        }
        else if (!ccg.equals("")) {
            orgs = Arrays.asList(ccg.split("\\s*,\\s*"));
            orgArray = ccg.split(",");
        }
        else if (!pcn.equals("")) {
            orgs = Arrays.asList(pcn.split("\\s*,\\s*"));
            orgArray = pcn.split(",");
        }
        else if (!practice.equals("")) {
            orgs = Arrays.asList(practice.split("\\s*,\\s*"));
            orgArray = practice.split(",");
        }

        StringBuilder builder = new StringBuilder();
        for( int i = 0 ; i < orgArray.length; i++ ) {
            builder.append("?,");
        }
        orgParams = builder.deleteCharAt( builder.length() -1 ).toString();

        List<String> charts = Arrays.asList(series.split("\\s*,\\s*"));
        List<String> ethnics = Arrays.asList(ethnic.split("\\s*,\\s*"));
        List<String> ages = Arrays.asList(age.split("\\s*,\\s*"));
        List<String> sexes = Arrays.asList(sex.split("\\s*,\\s*"));

        String seriesArray[] = series.split(",");
        builder = new StringBuilder();
        for( int i = 0 ; i < seriesArray.length; i++ ) {
            builder.append("?,");
        }
        String seriesParams = builder.deleteCharAt( builder.length() -1 ).toString();

        String ethnicArray[] = ethnic.split(",");
        builder = new StringBuilder();
        for( int i = 0 ; i < ethnicArray.length; i++ ) {
            builder.append("?,");
        }
        String ethnicParams = builder.deleteCharAt( builder.length() -1 ).toString();

        String ageArray[] = age.split(",");
        builder = new StringBuilder();
        for( int i = 0 ; i < ageArray.length; i++ ) {
            builder.append("?,");
        }
        String ageParams = builder.deleteCharAt( builder.length() -1 ).toString();

        String sexArray[] = sex.split(",");
        builder = new StringBuilder();
        for( int i = 0 ; i < sexArray.length; i++ ) {
            builder.append("?,");
        }
        String sexParams = builder.deleteCharAt( builder.length() -1 ).toString();

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        if (combineOrgs.equals("false")) {
            orgParams = "?";
        } else {
            orgs = Arrays.asList("Combine");
        }

        if (combineSeries.equals("false")) {
            seriesParams = "?";
        } else {
            charts = Arrays.asList("Combine");
        }

        if (combineEthnic.equals("false")) {
            ethnicParams = "?";
        } else {
            ethnics = Arrays.asList("Combine");
        }

        if (combineAge.equals("false")) {
            ageParams = "?";
        } else {
            ages = Arrays.asList("Combine");
        }

        if (combineSex.equals("false")) {
            sexParams = "?";
        } else {
            sexes = Arrays.asList("Combine");
        }

        String seriesSQL = "and name in ("+seriesParams+")";

        String orgSQL = "";

        if (!stp.equals(""))
            orgSQL = " stp in ("+orgParams+")";
        else if (!ccg.equals(""))
            orgSQL = " ccg in ("+orgParams+")";
        else if (!pcn.equals(""))
            orgSQL = " pcn in ("+orgParams+")";
        else if (!practice.equals(""))
            orgSQL = " practice in ("+orgParams+")";

        String ethnicSQL = "and ethnic in ("+ethnicParams+")";
        String ageSQL = "and age in ("+ageParams+")";
        String sexSQL = "and sex in ("+sexParams+")";

        if (series.equals("All")) {
            seriesArray = new String[0];
            seriesSQL = "";
        }

        if (ethnic.equals("All")) {
            ethnicArray = new String[0];
            ethnicSQL = "";
        }

        if (age.equals("All")) {
            ageArray = new String[0];
            ageSQL = "";
        }

        if (sex.equals("All")) {
            sexArray = new String[0];
            sexSQL = "";
        }

        for (String seriesName : charts) {
            for (String orgName : orgs) {
                for (String ethnicName : ethnics) {
                    for (String ageGroup : ages) {
                        for (String sexGroup : sexes) {
                            chartItem = new Chart();
                            String legend = seriesName;
                            if (!orgName.equals("All")&&!orgName.equals("Combine"))
                                legend += " in " +orgName;
                            if (!ageGroup.equals("All")&&!ageGroup.equals("Combine"))
                                legend += " " +ageGroup;
                            if (!ethnicName.equals("All")&&!ethnicName.equals("Combine"))
                                legend += " " +ethnicName;
                            if (!sexGroup.equals("All")&&!sexGroup.equals("Combine"))
                                legend += " " +sexGroup;

                            chartItem.setName(legend);

                            if (cumulative.equals("1")) {
                                if (rate.equals("1")) {
                                    sql = "SELECT t.series_name," +
                                            "floor(@running_total:=@running_total + t.series_value) as series_value " +
                                            "FROM " +
                                            "( SELECT name,series_name,sum(series_value/((select sum(list_size) as list_size from dashboards.population_denominators where " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + ")/100000)) as series_value " +
                                            "FROM dashboards.`covid_results_" + dashboardId + "` r " +
                                            "where series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + " group by series_name) t " +
                                            "JOIN (SELECT @running_total:=0) r " +
                                            "ORDER BY t.series_name";
                                } else {
                                    sql = "SELECT t.series_name," +
                                            "@running_total:=@running_total + t.series_value as series_value " +
                                            "FROM " +
                                            "( SELECT name,series_name,sum(series_value) as series_value " +
                                            "FROM dashboards.`covid_results_" + dashboardId + "` " +
                                            "where series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + " group by series_name) t " +
                                            "JOIN (SELECT @running_total:=0) r " +
                                            "ORDER BY t.series_name";
                                }

                            } else {
                                if (weekly.equals("1")) {
                                    if (rate.equals("1")) {
                                        sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                                                "floor(SUM(series_value/((select sum(list_size) as list_size from dashboards.population_denominators where " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + ")/100000))) AS series_value " +
                                                "FROM dashboards.`covid_results_" + dashboardId + "` r " +
                                                "where series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL + " " +sexSQL + " " +
                                                " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                                                "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                                    } else {
                                        sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                                                "SUM(series_value) AS series_value " +
                                                "from dashboards.`covid_results_" + dashboardId + "` where " +
                                                "series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL + " " +sexSQL + " " +
                                                " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                                                "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                                    }
                                } else {
                                    if (rate.equals("1")) {
                                        sql = "SELECT series_name,floor(sum(series_value/((select sum(list_size) as list_size from dashboards.population_denominators where " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + ")/100000))) as series_value "+
                                                "from dashboards.`covid_results_" + dashboardId + "` r " +
                                                "where series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + " group by series_name order by series_name";
                                    } else {
                                        sql = "SELECT series_name,sum(series_value) as series_value from dashboards.`covid_results_" + dashboardId + "` where " +
                                                "series_name between ? and ? " + seriesSQL + " and " + orgSQL + " " + ethnicSQL + " " + ageSQL+ " " + sexSQL + " group by series_name order by series_name";
                                    }
                                }

                            }

                            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                                int p = 1;
                                if (rate.equals("1")) {
                                    if (combineOrgs.equals("false")) {
                                        statement.setString(p++, orgName);
                                    } else {
                                        for (int i = 1; i <= orgArray.length; i++) {
                                            statement.setString(p++, orgArray[i - 1]);
                                        }
                                    }
                                    if (!ethnic.equals("All")) {
                                        if (combineEthnic.equals("false")) {
                                            statement.setString(p++, ethnicName);
                                        } else {
                                            for (int i = 1; i <= ethnicArray.length; i++) {
                                                statement.setString(p++, ethnicArray[i - 1]);
                                            }
                                        }
                                    }
                                    if (!age.equals("All")) {
                                        if (combineAge.equals("false")) {
                                            statement.setString(p++, ageGroup);
                                        } else {
                                            for (int i = 1; i <= ageArray.length; i++) {
                                                statement.setString(p++, ageArray[i - 1]);
                                            }
                                        }
                                    }
                                    if (!sex.equals("All")) {
                                        if (combineSex.equals("false")) {
                                            statement.setString(p++, sexGroup);
                                        } else {
                                            for (int i = 1; i <= sexArray.length; i++) {
                                                statement.setString(p++, sexArray[i - 1]);
                                            }
                                        }
                                    }
                                }
                                statement.setString(p++, dateFrom);
                                statement.setString(p++, dateTo);
                                if (!series.equals("All")) {
                                    if (combineSeries.equals("false")) {
                                        statement.setString(p++, seriesName);
                                    } else {
                                        for (int i = 1; i <= seriesArray.length; i++) {
                                            statement.setString(p++, seriesArray[i - 1]);
                                        }
                                    }
                                }
                                if (combineOrgs.equals("false")) {
                                    statement.setString(p++, orgName);
                                } else {
                                    for (int i = 1; i <= orgArray.length; i++) {
                                        statement.setString(p++, orgArray[i - 1]);
                                    }
                                }
                                if (!ethnic.equals("All")) {
                                    if (combineEthnic.equals("false")) {
                                        statement.setString(p++, ethnicName);
                                    } else {
                                        for (int i = 1; i <= ethnicArray.length; i++) {
                                            statement.setString(p++, ethnicArray[i - 1]);
                                        }
                                    }
                                }
                                if (!age.equals("All")) {
                                    if (combineAge.equals("false")) {
                                        statement.setString(p++, ageGroup);
                                    } else {
                                        for (int i = 1; i <= ageArray.length; i++) {
                                            statement.setString(p++, ageArray[i - 1]);
                                        }
                                    }
                                }
                                if (!sex.equals("All")) {
                                    if (combineSex.equals("false")) {
                                        statement.setString(p++, sexGroup);
                                    } else {
                                        for (int i = 1; i <= sexArray.length; i++) {
                                            statement.setString(p++, sexArray[i - 1]);
                                        }
                                    }
                                }
                                try (ResultSet resultSet = statement.executeQuery()) {
                                    chartItem.setSeries(getSeriesFromResultSet(resultSet));
                                }
                            }

                            chart.add(chartItem);
                        }
                    }
                }
            }
        }

        result.setResults(chart);

        return result;
    }

    public ChartResult getDashboard(String query, String chartName, String dateFrom, String dateTo, String cumulative, String grouping, String weekly) throws Exception {
        List<String> charts = Arrays.asList(chartName.split("\\s*,\\s*"));

        String ids[] = grouping.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        ChartResult result = new ChartResult();
        String sql = "";

        sql = "select id from dashboards.query_library where name = ? ";
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, query);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                }
            }
        }

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;
        String ids2[] = new String[0];

        for (String chart_name : charts) {

            chartItem = new Chart();
            chartItem.setName(chart_name);

            if (cumulative.equals("1")) {
                sql = "SELECT t.series_name," +
                        "@running_total:=@running_total + t.series_value as series_value " +
                        "FROM " +
                        "( SELECT name,series_name,sum(series_value) as series_value "+
                        "FROM dashboards.`dashboard_results_" + queryId + "` " +
                        "where name = ? and series_name between ? and ? and `grouping` in ("+params+") group by series_name) t " +
                        "JOIN (SELECT @running_total:=0) r " +
                        "ORDER BY t.series_name";
            } else {
                if (weekly.equals("1")) {
                    sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                            "SUM(series_value) AS series_value " +
                            "from dashboards.`dashboard_results_" + queryId + "` where name = ? " +
                            "and series_name between ? and ? and `grouping` in ("+params+")"+
                            " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                            "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                } else {
                    sql = "SELECT series_name,sum(series_value) as series_value from dashboards.`dashboard_results_" + queryId + "` where name = ? " +
                            "and series_name between ? and ? and `grouping` in ("+params+") group by series_name order by series_name";
                }

            }
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                int p = 1;
                for (int i = 1; i <= ids2.length; i++) {
                    statement.setString(p++, ids2[i-1]);
                }
                statement.setString(p++, chart_name);
                statement.setString(p++, dateFrom);
                statement.setString(p++, dateTo);
                for (int i = 1; i <= ids.length; i++) {
                    statement.setString(p++, ids[i-1]);
                }
                try (ResultSet resultSet = statement.executeQuery()) {
                    chartItem.setSeries(getSeriesFromResultSet(resultSet));
                }
            }

            chart.add(chartItem);
        }

        result.setResults(chart);

        return result;
    }


    public Chart getDashboardSingle(String query, String chartName, String dateFrom, String dateTo, String grouping) throws Exception {

        String ids[] = grouping.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "";

        sql = "select id from dashboards.query_library where name = ? ";
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, query);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                }
            }
        }

        sql = "SELECT series_name,sum(series_value) as series_value from dashboards.`dashboard_results_" + queryId + "` where name = ? "+
                "and series_name between ? and ? and `grouping` in ("+params+") group by series_name order by series_name";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, chartName);
            statement.setString(2, dateFrom);
            statement.setString(3, dateTo);
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i+3, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                chartItem.setSeries(getSeriesFromResultSet(resultSet));
            }
        }

        if (chartItem.getSeries().size()==0) {
            sql = "SELECT series_name,sum(series_value) as series_value from dashboards.`dashboard_results_" + queryId + "` where name = ? and `grouping` in ("+params+")"+
                    " group by series_name order by series_name";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, chartName);
                for (int i = 1; i <= ids.length; i++) {
                    statement.setString(i+1, ids[i-1]);
                }
                try (ResultSet resultSet = statement.executeQuery()) {
                    chartItem.setSeries(getSeriesFromResultSet(resultSet));
                }
            }
        }

        return chartItem;
    }

    public Chart getDashboardSingle(String query, String chartName, String grouping) throws Exception {

        String ids[] = grouping.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "";

        sql = "select id from dashboards.query_library where name = ? ";
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, query);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                }
            }
        }

        sql = "SELECT series_name,sum(series_value) as series_value from dashboards.`dashboard_results_" + queryId + "` where name = ? and `grouping` in ("+params+")"+
                " group by series_name order by series_name";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, chartName);
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i+1, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                chartItem.setSeries(getSeriesFromResultSet(resultSet));
            }
        }

        return chartItem;
    }

    private List<Series> getSeriesFromResultSet(ResultSet resultSet) throws SQLException {
        List<Series> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getSeries(resultSet));
        }

        return result;
    }

    public static Series getSeries(ResultSet resultSet) throws SQLException {
        Series series = new Series();
        series.setName(resultSet.getString("series_name"));
        series.setValue(resultSet.getString("series_value"));
        return series;
    }

    public ChartResult getDashboardRegistries(String organisations, String registries) throws Exception {
        String ccg = "";

        List<String> charts = Arrays.asList(organisations.split("\\s*,\\s*"));

        String ids[] = registries.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        for (String chart_name : charts) {
            chartItem = new Chart();
            chartItem.setName(chart_name);

            String temp = "";

            if (organisations.contains("CCG"))
                sql = "SELECT registry as series_name,sum(registry_size) as series_value FROM dashboards.registries where ccg = ? and registry in ("+params+")"+
                    " GROUP BY ccg, registry order by registry_size desc";
            else
                sql = "SELECT registry as series_name,registry_size as series_value FROM dashboards.registries where practice_name = ? and registry in ("+params+")"+
                        " order by registry_size desc";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, chart_name);
                for (int i = 1; i <= ids.length; i++) {
                    statement.setString(i+1, ids[i-1]);
                }
                try (ResultSet resultSet = statement.executeQuery()) {
                    chartItem.setSeries(getSeriesFromResultSet(resultSet));
                }
            }

            chart.add(chartItem);
        }

        result.setResults(chart);

        return result;
    }


    public PatientResult getPatientResult(Integer page, Integer size, String name, String queryId) throws Exception {
        PatientResult result = new PatientResult();

        String sql = "";

        String[] names = name.split(" ", 2);

        if (name.equals("")) { // No name
            sql = "SELECT p.id,coalesce(p.date_of_birth,'') as date_of_birth,coalesce(c.name,'') as gender,FLOOR(DATEDIFF(now(), p.date_of_birth) / 365.25) as age, " +
                    "coalesce(p.nhs_number,'') as nhs_number,CONCAT(UPPER(coalesce(p.last_name,'')),', ',coalesce(p.first_names,''),' (',coalesce(p.title,''),')') as name, " +
                    "CONCAT(coalesce(a.address_line_1,''),', ',coalesce(a.address_line_2,''),', ',coalesce(a.address_line_3,''),', ',coalesce(a.city,''),', ',coalesce(a.postcode,'')) as address, " +
                    "pr.name as usual_gp,o.name as orgname, con.name as reg_type, p.date_of_death, coalesce(e.date_registered,'') as startdate, '' as mobile " +
                    "FROM patient p " +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?) " +
                    "LIMIT ?,?";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                statement.setInt(2, page * 10);
                statement.setInt(3, size);
                try (ResultSet resultSet = statement.executeQuery()) {
                    result.setResults(getPatientSummaryList(resultSet));
                }
            }

            sql = "SELECT count(1) " +
                    "FROM patient p \n" +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?)";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                try (ResultSet resultSet = statement.executeQuery()) {
                    resultSet.next();
                    result.setLength(resultSet.getInt(1));
                }
            }
        }
        else if (names.length == 1) { // Last name
            sql = "SELECT p.id,coalesce(p.date_of_birth,'') as date_of_birth,coalesce(c.name,'') as gender,FLOOR(DATEDIFF(now(), p.date_of_birth) / 365.25) as age, " +
                    "coalesce(p.nhs_number,'') as nhs_number,CONCAT(UPPER(coalesce(p.last_name,'')),', ',coalesce(p.first_names,''),' (',coalesce(p.title,''),')') as name, " +
                    "CONCAT(coalesce(a.address_line_1,''),', ',coalesce(a.address_line_2,''),', ',coalesce(a.address_line_3,''),', ',coalesce(a.city,''),', ',coalesce(a.postcode,'')) as address, " +
                    "pr.name as usual_gp,o.name as orgname, con.name as reg_type, p.date_of_death, coalesce(e.date_registered,'') as startdate, '' as mobile " +
                    "FROM patient p " +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?) " +
                    "and p.last_name like ? LIMIT ?,?";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                statement.setString(2, names[0]+"%");
                statement.setInt(3, page * 10);
                statement.setInt(4, size);
                try (ResultSet resultSet = statement.executeQuery()) {
                    result.setResults(getPatientSummaryList(resultSet));
                }
            }

            sql = "SELECT count(1) " +
                    "FROM patient p \n" +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?) " +
                    "and p.last_name like ?";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                statement.setString(2, names[0]+"%");
                try (ResultSet resultSet = statement.executeQuery()) {
                    resultSet.next();
                    result.setLength(resultSet.getInt(1));
                }
            }
        }
        else if (names.length>1) { // Full name
            sql = "SELECT p.id,coalesce(p.date_of_birth,'') as date_of_birth,coalesce(c.name,'') as gender,FLOOR(DATEDIFF(now(), p.date_of_birth) / 365.25) as age, " +
                    "coalesce(p.nhs_number,'') as nhs_number,CONCAT(UPPER(coalesce(p.last_name,'')),', ',coalesce(p.first_names,''),' (',coalesce(p.title,''),')') as name, " +
                    "CONCAT(coalesce(a.address_line_1,''),', ',coalesce(a.address_line_2,''),', ',coalesce(a.address_line_3,''),', ',coalesce(a.city,''),', ',coalesce(a.postcode,'')) as address, " +
                    "pr.name as usual_gp,o.name as orgname, con.name as reg_type, p.date_of_death, coalesce(e.date_registered,'') as startdate, '' as mobile " +
                    "FROM patient p " +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?) " +
                    "and (p.first_names like ? and p.last_name like ?) LIMIT ?,?";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                statement.setString(2, names[0]+"%");
                statement.setString(3, names[1]+"%");
                statement.setInt(4, page * 10);
                statement.setInt(5, size);
                try (ResultSet resultSet = statement.executeQuery()) {
                    result.setResults(getPatientSummaryList(resultSet));
                }
            }

            sql = "SELECT count(1) " +
                    "FROM patient p \n" +
                    "join patient_address a on a.id = p.current_address_id " +
                    "join concept c on c.dbid = p.gender_concept_id " +
                    "join episode_of_care e on e.patient_id = p.id " +
                    "join practitioner pr on pr.id = e.usual_gp_practitioner_id " +
                    "join organization o on o.id = p.organization_id " +
                    "join concept con on con.dbid = e.registration_type_concept_id " +
                    "where p.id in "+
                    "(SELECT patient_id FROM dashboards.person_dataset " +
                    "where query_id = ?) " +
                    "and (p.first_names like ? and p.last_name like ?)";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, queryId);
                statement.setString(2, names[0]+"%");
                statement.setString(3, names[1]+"%");
                try (ResultSet resultSet = statement.executeQuery()) {
                    resultSet.next();
                    result.setLength(resultSet.getInt(1));
                }
            }
        }

        return result;
    }

    private List<PatientSummary> getPatientSummaryList(ResultSet resultSet) throws SQLException {
        List<PatientSummary> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getPatientSummary(resultSet));
        }

        return result;
    }

    public static PatientSummary getPatientSummary(ResultSet resultSet) throws SQLException {
        PatientSummary patientSummary = new PatientSummary();
        patientSummary
                .setId(resultSet.getString("id"))
                .setName(resultSet.getString("name"))
                .setDob(resultSet.getDate("date_of_birth"))
                .setDod(resultSet.getDate("date_of_death"))
                .setNhsNumber(resultSet.getString("nhs_number"))
                .setGender(resultSet.getString("gender"))
                .setAge(resultSet.getString("age"))
                .setAddress(resultSet.getString("address"))
                .setUsual_gp(resultSet.getString("usual_gp"))
                .setOrganisation(resultSet.getString("orgname"))
                .setStart_date(resultSet.getString("startdate"))
                .setMobile(resultSet.getString("mobile"))
                .setRegistration(resultSet.getString("reg_type"));

        return patientSummary;
    }

    public RegistriesResult getRegistries(String ccg, String registry) throws Exception {
        RegistriesResult result = new RegistriesResult();

        String sql = "{ call dashboards.getRegistries(?,?) }";

        try (CallableStatement cs = connection.prepareCall(sql);) {
            cs.setString(1, ccg);
            cs.setString(2, registry);
            try (ResultSet resultSet = cs.executeQuery()) {
                result.setResults(getRegistriesList(resultSet));
            }
        }

        return result;
    }

    private List<Registries> getRegistriesList(ResultSet resultSet) throws SQLException {
        List<Registries> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getRegistries(resultSet));
        }

        return result;
    }

    public static Registries getRegistries(ResultSet resultSet) throws SQLException {
        Registries registries = new Registries();

        registries
                .setOrg(resultSet.getString("org"))
                .setListSize(resultSet.getInt("list_size"))
                .setAllColumns(resultSet.getString("all_columns"))
                .setRegistrySize(resultSet.getString("registry_size"));
        return registries;
    }

    public OrganisationGroupsResult getOrganisationGroups(String selectedTypeString) throws Exception {
        OrganisationGroupsResult result = new OrganisationGroupsResult();

        String ids[] = selectedTypeString.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String sql = "";
        String sqlCount = "";
        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        sql = "SELECT id, type, name, updated " +
                "FROM dashboards.organisation_groups WHERE type in ("+params+")"+
                "order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.organisation_groups WHERE type in ("+params+")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getOrganisationGroupsList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            for (int i = 1; i <= ids.length; i++) {
                statement.setString(i, ids[i-1]);
            }
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
                .setId(resultSet.getInt("id"))
                .setType(resultSet.getString("type"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"));
        return organisationgroups;
    }

    public OrganisationsResult getOrganisations(String organisation_group_id) throws Exception {
        OrganisationsResult result = new OrganisationsResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT type, name, ods_code, updated, id " +
                "FROM dashboards.organisations " +
                "WHERE organisation_group_id = ? " +
                "order by type, name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.organisations " +
                "WHERE organisation_group_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, organisation_group_id);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getOrganisationsList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            statement.setString(1, organisation_group_id);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<Organisations> getOrganisationsList(ResultSet resultSet) throws SQLException {
        List<Organisations> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getOrganisations(resultSet));
        }

        return result;
    }

    public static Organisations getOrganisations(ResultSet resultSet) throws SQLException {
        Organisations organisations = new Organisations();

        organisations
                .setType(resultSet.getString("type"))
                .setName(resultSet.getString("name"))
                .setCode(resultSet.getString("ods_code"))
                .setUpdated(resultSet.getDate("updated"))
                .setId(resultSet.getString("id"));
        return organisations;
    }

    public void saveOrganisationGroup(String type, String name, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.organisation_groups (type, name) " +
                    "VALUES (?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.organisation_groups SET type = ?, name = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, id);
                stmt.executeUpdate();
            }
        }
    }

    public void deleteOrganisationGroup(String id) throws Exception {

        String ids[] = id.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        String sql = "DELETE FROM dashboards.organisation_groups WHERE id in ("+params+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

        sql = "DELETE FROM dashboards.organisations WHERE organisation_group_id in ("+params+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

    }

    public void duplicateOrganisationGroup(String id) throws Exception {

        String sql = "insert into dashboards.organisation_groups (type, name) " +
                "select type, concat('Copy of ',name) from dashboards.organisation_groups where id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }

        String sqlCount = "insert into dashboards.organisations (organisation_group_id, name, type, ods_code) " +
                "select (select max(id) as id from dashboards.organisation_groups), name, type, ods_code " +
                "from dashboards.organisations " +
                "where organisation_group_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sqlCount)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void saveOrganisation(String name, String type, String code, String organisation_group_id, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.organisations (name, type, ods_code, organisation_group_id) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, type);
                stmt.setString(3, code);
                stmt.setString(4, organisation_group_id);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.organisations SET name = ?, type = ?, ods_code = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, type);
                stmt.setString(3, code);
                stmt.setString(4, id);
                stmt.executeUpdate();
            }
        }
    }

    public void deleteOrganisation(String id) throws Exception {

        String ids[] = id.split(",");

        StringBuilder builder = new StringBuilder();

        for( int i = 0 ; i < ids.length; i++ ) {
            builder.append("?,");
        }

        String params = builder.deleteCharAt( builder.length() -1 ).toString();

        String sql = "DELETE FROM dashboards.organisations WHERE id in ("+params+")";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 1; i <= ids.length; i++) {
                stmt.setInt(i, Integer.parseInt(ids[i-1]));
            }
            stmt.executeUpdate();
        }

    }

    public QueryResult getQuery(String selectedQuery) throws Exception {
        QueryResult result = new QueryResult();

        String sql = "";

        sql = "SELECT query " +
                "FROM dashboards.query_library " +
                "WHERE name = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, selectedQuery);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getQueryList(resultSet));
            }
        }

        return result;
    }

    private List<Query> getQueryList(ResultSet resultSet) throws SQLException {
        List<Query> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getQuery(resultSet));
        }

        return result;
    }

    public static Query getQuery(ResultSet resultSet) throws SQLException {
        Query query = new Query();

        query.setQuery(resultSet.getString("query"));
        return query;
    }

    public DashboardViewResult getDashboardView(String dashboardNumber) throws Exception {
        DashboardViewResult result = new DashboardViewResult();

        String sql = "";

        sql = "SELECT type, name, query " +
                "FROM dashboards.dashboard_library " +
                "WHERE dashboard_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, dashboardNumber);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getDashboardViewList(resultSet));
            }
        }

        return result;
    }

    public DashboardViewResult getCovidDashboardView(String dashboardNumber) throws Exception {
        DashboardViewResult result = new DashboardViewResult();

        String sql = "";

        sql = "SELECT type, name, query " +
                "FROM dashboards.covid_library " +
                "WHERE dashboard_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, dashboardNumber);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getDashboardViewList(resultSet));
            }
        }

        return result;
    }

    private List<DashboardView> getDashboardViewList(ResultSet resultSet) throws SQLException {
        List<DashboardView> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getDashboardView(resultSet));
        }

        return result;
    }

    public static DashboardView getDashboardView(ResultSet resultSet) throws SQLException {
        DashboardView dashboardView = new DashboardView();

        dashboardView
                .setType(resultSet.getString("type"))
                .setName(resultSet.getString("name"))
                .setQuery(resultSet.getString("query"));
        return dashboardView;
    }

    public ArrayList<String> getMapDates(String query) throws Exception {

        String sql = "";
        if ("Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query)) {
            sql = "select distinct date_format(covid_date, '%Y-%m-%d') as date " +
                    "from dashboards.lsoa_covid where covid_date <= now() order by covid_date";
        } else if ("Confirmed Covid-19 cases".equalsIgnoreCase(query)) {
            sql = "select distinct date_format(covid_date, '%Y-%m-%d') as date " +
                    "from dashboards.lsoa_covid where covid_date <= now() and corona_status = 'Confirmed Covid 19' order by covid_date";
        } else if ("Shielded Covid-19 patients".equalsIgnoreCase(query)) {
            sql = "select distinct date_format(covid_date, '%Y-%m-%d') as date " +
                    "from dashboards.lsoa_covid_shielded where covid_date <= now() order by covid_date";
        } else {
            sql = "select id from dashboards.query_library where name = ? ";
            String queryId = null;
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, query);
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        queryId = resultSet.getString("id");
                    }
                }
            }
            sql = "select distinct date_format(`Effective date`, '%Y-%m-%d') as date " +
                    "from dashboards.observation_output_" + queryId + " " +
                    "order by `Effective date`";
        }

        ArrayList<String> list = new ArrayList();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String date = resultSet.getString("date");
                    list.add(date);
                }
            }
        }
        return list;
    }

    public MapResult getMaps(String query, String date,
                             List<String> lowerLimits, List<String> upperLimits,
                             List<String> colors, List<String> descriptions) throws Exception {


        String queryId = null;
        if (!"Confirmed Covid-19 cases".equalsIgnoreCase(query)&&!"Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query)&&!"Shielded Covid-19 patients".equalsIgnoreCase(query)) {
            String sql = "select id from dashboards.query_library where name = ? ";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, query);
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        queryId = resultSet.getString("id");
                    }
                }
            }
        }

        ArrayList<String> ids = new ArrayList<String>();
        HashMap<String, List<MapLayer>> layers = new HashMap();

        String sql = "select * from dashboards.maps WHERE parent_area_code = 'nel_ccg'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                ArrayList<MapLayer> list = new ArrayList();
                while (resultSet.next()) {
                    MapLayer layer = new MapLayer();
                    layer.setAreaCode(resultSet.getString("area_code"));
                    layer.setDescription(resultSet.getString("description"));
                    layer.setGeoJson(resultSet.getString("geo_json"));
                    layer.setColor("BLUE");
                    list.add(layer);
                }
                ids.add("All levels");
                layers.put("All levels", list);
            }
        }

        String minDate = "";
        if (queryId == null) {
            if ("Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query))
                sql = "select min(date_format(covid_date, '%Y-%m-%d')) as min_date from dashboards.lsoa_covid";
            else if ("Confirmed Covid-19 cases".equalsIgnoreCase(query))
                sql = "select min(date_format(covid_date, '%Y-%m-%d')) as min_date from dashboards.lsoa_covid where corona_status = 'Confirmed Covid 19'";
            else if ("Shielded Covid-19 patients".equalsIgnoreCase(query))
                sql = "select min(date_format(covid_date, '%Y-%m-%d')) as min_date from dashboards.lsoa_covid_shielded";
        } else {
            sql = "select min(date_format(`Effective date`, '%Y-%m-%d')) as min_date from dashboards.observation_output_" + queryId;
        }
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    minDate = resultSet.getString("min_date");
                }
            }
        }

        ArrayList<MapLayer> layer1 = new ArrayList();
        ArrayList<MapLayer> layer2 = new ArrayList();
        ArrayList<MapLayer> layer3 = new ArrayList();
        ArrayList<MapLayer> layer4 = new ArrayList();
        ArrayList<MapLayer> layer5 = new ArrayList();

        if (queryId == null) {
            if ("Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query))
                sql = "SELECT COUNT(covid.lsoa_code) AS patients, " +
                        "regs.reg_count AS reg_patients, " +
                        "ROUND(((COUNT(covid.lsoa_code) * 100000) / regs.reg_count),1) AS ratio, " +
                        "covid.lsoa_code AS lsoa_code, " +
                        "map.geo_json " +
                        "FROM dashboards.lsoa_covid covid, " +
                        "( SELECT reg.lsoa_code, sum(reg.count) reg_count " +
                        "  FROM dashboards.lsoa_registrations reg " +
                        "  WHERE reg.lsoa_code IS NOT NULL " +
                        "  GROUP BY reg.lsoa_code " +
                        ") regs, dashboards.maps map " +
                        "WHERE covid.lsoa_code = regs.lsoa_code " +
                        "AND covid.lsoa_code = map.area_code " +
                        "AND covid.covid_date = ? " +
                        "GROUP BY covid.lsoa_code " +
                        "ORDER BY covid.lsoa_code ";
            else if ("Confirmed Covid-19 cases".equalsIgnoreCase(query))
                sql = "SELECT COUNT(covid.lsoa_code) AS patients, " +
                        "regs.reg_count AS reg_patients, " +
                        "ROUND(((COUNT(covid.lsoa_code) * 100000) / regs.reg_count),1) AS ratio, " +
                        "covid.lsoa_code AS lsoa_code, " +
                        "map.geo_json " +
                        "FROM dashboards.lsoa_covid covid, " +
                        "( SELECT reg.lsoa_code, sum(reg.count) reg_count " +
                        "  FROM dashboards.lsoa_registrations reg " +
                        "  WHERE reg.lsoa_code IS NOT NULL " +
                        "  GROUP BY reg.lsoa_code " +
                        ") regs, dashboards.maps map " +
                        "WHERE covid.lsoa_code = regs.lsoa_code " +
                        "AND covid.lsoa_code = map.area_code " +
                        "AND covid.covid_date = ? " +
                        "AND corona_status = 'Confirmed Covid 19' "+
                        "GROUP BY covid.lsoa_code " +
                        "ORDER BY covid.lsoa_code ";
            else if ("Shielded Covid-19 patients".equalsIgnoreCase(query))
                sql = "SELECT COUNT(covid.lsoa_code) AS patients, " +
                        "regs.reg_count AS reg_patients, " +
                        "ROUND(((COUNT(covid.lsoa_code) * 100000) / regs.reg_count),1) AS ratio, " +
                        "covid.lsoa_code AS lsoa_code, " +
                        "map.geo_json " +
                        "FROM dashboards.lsoa_covid_shielded covid, " +
                        "( SELECT reg.lsoa_code, sum(reg.count) reg_count " +
                        "  FROM dashboards.lsoa_registrations reg " +
                        "  WHERE reg.lsoa_code IS NOT NULL " +
                        "  GROUP BY reg.lsoa_code " +
                        ") regs, dashboards.maps map " +
                        "WHERE covid.lsoa_code = regs.lsoa_code " +
                        "AND covid.lsoa_code = map.area_code " +
                        "AND covid.covid_date = ? " +
                        "GROUP BY covid.lsoa_code " +
                        "ORDER BY covid.lsoa_code ";

        } else {
            sql = "SELECT COUNT(PERSON.`LSOA code`) as patients, " +
                    "REGS.reg_count as reg_patients, " +
                    "ROUND(((COUNT(PERSON.`LSOA code`) * 100000) / REGS.reg_count),1) AS ratio, " +
                    "PERSON.`LSOA code` as lsoa_code, " +
                    "MAP.geo_json " +
                    "FROM  dashboards.person_output_" + queryId + " PERSON, " +
                    "dashboards.maps MAP, " +
                    "(SELECT lsoa_code, " +
                    "SUM(count) as reg_count " +
                    "FROM dashboards.lsoa_registrations " +
                    "WHERE lsoa_code IS NOT NULL " +
                    "GROUP BY lsoa_code " +
                    ") REGS " +
                    "WHERE  REGS.lsoa_code = PERSON.`LSOA code` " +
                    "AND MAP.area_code = PERSON.`LSOA code` " +
                    "GROUP BY PERSON.`LSOA code` " +
                    "ORDER BY PERSON.`LSOA code` ";
        }

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            if(queryId == null) {
                statement.setString(1, date);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    MapLayer layer = new MapLayer();
                    BigDecimal ratio = resultSet.getBigDecimal("ratio");
                    float ratioFloat = ratio.floatValue();
                    String description = "";
                    int rate = 0;

                    layer.setAreaCode(resultSet.getString("lsoa_code"));
                    rate = Math.round((resultSet.getFloat("patients") / resultSet.getFloat("reg_patients")) * 100000);
                    description = "LSOA "+layer.getAreaCode() + ": " +
                            resultSet.getInt("patients") + " of " +
                            resultSet.getInt("reg_patients") + " registered cases (" + rate + " per 100,000 per day)";
                    layer.setDescription(description);
                    layer.setGeoJson(resultSet.getString("geo_json"));

                    for (int i=0; i<5; i++) {
                        if (i < 4 && ratioFloat >= Float.valueOf(lowerLimits.get(i)) &&
                                ratioFloat <= Float.valueOf(upperLimits.get(i))) {
                            layer.setColor(colors.get(i));
                            if (i == 0) {
                                layer1.add(layer);
                            } else if (i == 1) {
                                layer2.add(layer);
                            } else if (i == 2) {
                                layer3.add(layer);
                            } else if (i == 3) {
                                layer4.add(layer);
                            }
                        } else {
                            if (i == 4 && ratioFloat >= Float.valueOf(lowerLimits.get(i))) {
                                layer.setColor(colors.get(i));
                                layer5.add(layer);
                            }
                        }
                    }
                }
            }
        }

        ids.add(descriptions.get(0));
        layers.put(descriptions.get(0), layer1);
        ids.add(descriptions.get(1));
        layers.put(descriptions.get(1), layer2);
        ids.add(descriptions.get(2));
        layers.put(descriptions.get(2), layer3);
        ids.add(descriptions.get(3));
        layers.put(descriptions.get(3), layer4);
        ids.add(descriptions.get(4));
        layers.put(descriptions.get(4), layer5);

        MapResult result = new MapResult();
        result.setIds(ids);
        result.setLayers(layers);

        return result;
    }

    public TableData getTableData(String queryName, String outputType, String searchData, Integer pageNumber,
                             Integer pageSize, String orderColumn, boolean descending)  throws Exception {

        TableData data = new TableData();

        String sql = "select * from dashboards.query_library where name = ? ";
        JsonObject query = null;
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, queryName);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                    query = new JsonParser().parse(resultSet.getString("query")).getAsJsonObject();
                }
            }
        }

        if (query == null) {
            LOG.error("Invalid query.");
            throw new Exception("Invalid query.");
        }

        ArrayList<String> outputTypes = new ArrayList<>();
        ArrayList<String> demographicsFields  = new ArrayList<>();
        ArrayList<String> encountersFields  = new ArrayList<>();
        ArrayList<String> medicationFields  = new ArrayList<>();
        ArrayList<String> clinicalEventsFields  = new ArrayList<>();
        Type listType = new TypeToken<List<String>>() {}.getType();

        if (query.get("demographics").getAsBoolean()) {
            outputTypes.add("Demographics");
            demographicsFields = new Gson().fromJson(query.get("selectedDemographicFields"), listType);
        }

        if (query.get("encounters").getAsBoolean()) {
            outputTypes.add("Encounters");
            encountersFields = new Gson().fromJson(query.get("selectedEncounterFields"), listType);
        }

        if (query.get("medication").getAsBoolean()) {
            outputTypes.add("Medication");
            medicationFields = new Gson().fromJson(query.get("selectedMedicationFields"), listType);
        }

        if (query.get("clinicalEvents").getAsBoolean()) {
            outputTypes.add("Clinical Events");
            clinicalEventsFields = new Gson().fromJson(query.get("selectedClinicalEventFields"), listType);
        }

        if (outputTypes.size() == 0) {
            LOG.error("Query has no valid table output types.");
            throw new Exception("Query has no valid table output types.");
        } else {
            data.getOutputTypes().addAll(outputTypes);
        }

        String tableName = "";

        if (StringUtils.isNullOrEmpty(outputType)) {
            outputType = outputTypes.get(0);
        }
        data.setOutputType(outputType);

        if (outputType.equalsIgnoreCase("Demographics")) {
            tableName = "person_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Encounters")) {
            tableName = "encounter_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Medication")) {
            tableName = "medication_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Clinical Events")) {
            tableName = "observation_output_" +queryId;
        } else {
            LOG.error("Unknown output type:" + outputType);
            throw new Exception("Unknown output type:" + outputType);
        }

        ArrayList<String> fieldsList = new ArrayList<>();
        if (outputType.equalsIgnoreCase("Demographics")) {
            fieldsList.addAll(demographicsFields);
        } else if (outputType.equalsIgnoreCase("Encounters")) {
            fieldsList.addAll(encountersFields);
        } else if (outputType.equalsIgnoreCase("Medication")) {
            fieldsList.addAll(medicationFields);
        } else if (outputType.equalsIgnoreCase("Clinical Events")) {
            fieldsList.addAll(clinicalEventsFields);
        }

        sql = "select * from information_schema.tables where table_schema = 'dashboards' and table_name = '" + tableName + "'";
        boolean tableFound = false;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tableFound = true;
                }
            }
        }

        if (!tableFound) {
            LOG.error("Information not yet available.");
            throw new Exception("Information not yet available.");
        }

        String andColumns = "and (";
        for (String field : fieldsList) {
            andColumns += " column_name = '" + field + "' or ";
        }
        andColumns = andColumns.substring(0, andColumns.length() - 3);
        andColumns += ")";


        sql = "select column_name, data_type from information_schema.columns " +
                " where table_schema='dashboards' and table_name = '" + tableName + "'" + andColumns;

        ArrayList<String> columns = new ArrayList();
        ArrayList<String> likeColumns = new ArrayList();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String column = resultSet.getString("column_name");
                    columns.add(column);
                    String type = resultSet.getString("data_type");
                    if (isTypeString(type)) {
                        likeColumns.add(column);
                    }
                }
            }
        }

        String order = "asc";
        if (descending) {
            order = "desc";
        }

        ArrayList<JSONObject> tableRows = new ArrayList();
        JSONObject row = null;
        TableHeader header = null;

        for (String column : columns) {
            header = new TableHeader();
            header.setLabel(column);
            header.setProperty(column);
            data.getHeaders().add(header);
        }

        if (StringUtils.isNullOrEmpty(orderColumn) || !columns.contains(orderColumn)){
            orderColumn = columns.get(0);
        }

        String like = "";
        if (!StringUtils.isNullOrEmpty(searchData)) {
            like = " where ";
            for (String column : likeColumns) {
                like += "`" + column + "`" + " like ? or ";
            }
            like = like.substring(0, like.length() - 3);
        }

        String fields = "";
        for (String field : fieldsList) {
            fields += "`" + field + "`,";
        }
        fields = fields.substring(0, fields.length()-1);


        if (StringUtils.isNullOrEmpty(searchData)) {
            sql = "select " + fields + " from dashboards." + tableName +
                    " order by `" + orderColumn + "` " + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        } else {
            sql = "select " + fields + " from dashboards." + tableName +
                    like +
                    " order by `" + orderColumn + "` " + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        }

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            if (!StringUtils.isNullOrEmpty(searchData)) {
                for (int i = 0; i < likeColumns.size(); i++) {
                    statement.setString(i+1, "%" + searchData + "%");
                }
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    row = new JSONObject();
                    for (String column : columns) {
                        row.put(column, resultSet.getString(column));
                    }
                    tableRows.add(row);
                }
            }
        }
        data.getRows().addAll(tableRows);
        return data;
    }

    public long getTableTotalCount(String queryName, String outputType, String searchData) throws Exception {
        long count = 0;

        String sql = "select * from dashboards.query_library where name = ? ";
        JsonObject query = null;
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, queryName);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                    query = new JsonParser().parse(resultSet.getString("query")).getAsJsonObject();
                }
            }
        }

        if (query == null) {
            LOG.error("Invalid query.");
            throw new Exception("Invalid query.");
        }

        String tableName = "";
        if (outputType.equalsIgnoreCase("Demographics")) {
            tableName = "person_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Encounters")) {
            tableName = "encounter_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Medication")) {
            tableName = "medication_output_" +queryId;
        } else if (outputType.equalsIgnoreCase("Clinical Events")) {
            tableName = "observation_output_" +queryId;
        } else {
            LOG.error("Unknown output type:" + outputType);
            throw new Exception("Unknown output type:" + outputType);
        }

        sql = "select column_name, data_type from information_schema.columns " +
                " where table_schema='dashboards' and table_name = '" + tableName + "'";

        ArrayList<String> likeColumns = new ArrayList();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String column = resultSet.getString("column_name");
                    String type = resultSet.getString("data_type");
                    if (isTypeString(type)) {
                        likeColumns.add(column);
                    }
                }
            }
        }

        sql = "select count(*) as total from dashboards." + tableName;
        if (!StringUtils.isNullOrEmpty(searchData)) {
            String like = like = " where ";
            for (String column : likeColumns) {
                like += "`" + column + "`" + " like ? or ";
            }
            like = like.substring(0, like.length() - 3);
            sql += " " + like;

        }
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            if (!StringUtils.isNullOrEmpty(searchData)) {
                for (int i = 0; i < likeColumns.size(); i++) {
                    statement.setString(i+1, "%" + searchData + "%");
                }
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    count = resultSet.getLong("total");
                }
            }
        }

        return count;
    }

    private boolean isTypeString(String type) {
        if (!StringUtils.isNullOrEmpty(type)) {
            if (type.equalsIgnoreCase("char") ||
                    type.equalsIgnoreCase("varchar") ||
                    type.equalsIgnoreCase("text")) {
                return true;
            }
        }
        return false;
    }

    public ArrayList<String> getMapQueries() throws Exception {

        ArrayList<String> list = new ArrayList<>();
        list.add("Suspected and confirmed Covid-19 cases");
        list.add("Confirmed Covid-19 cases");
        list.add("Shielded Covid-19 patients");

        HashMap<Integer,String> queryLibrary = new HashMap<>();
        String sql = "select id, name from dashboards.query_library";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryLibrary.put(resultSet.getInt("id"), resultSet.getString("name"));
                }
            }
        }

        for (Integer id : queryLibrary.keySet()) {
            sql = "select table_name from information_schema.columns where table_name = 'person_output_" + id + "' and column_name = 'LSOA code';";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        list.add(queryLibrary.get(id));
                    }
                }
            }
        }
        Collections.sort(list);
        return list;
    }

    private static String toTitleCase(String str) {

        if(str == null || str.isEmpty())
            return "";

        if(str.length() == 1)
            return str.toUpperCase();

        //split the string by space
        String[] parts = str.split(" ");

        StringBuilder sb = new StringBuilder( str.length() );

        for(String part : parts){

            if(part.length() > 1 )
                sb.append( part.substring(0, 1).toUpperCase() )
                        .append( part.substring(1).toLowerCase() );
            else
                sb.append(part.toUpperCase());

            sb.append(" ");
        }

        return sb.toString().trim();
    }

    public SeriesResult getGroupingFromQuery(String queryName) throws Exception {
        SeriesResult result = new SeriesResult();

        String sql = "";
        String sqlCount = "";

        sql = "select id from dashboards.query_library where name = ? ";
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, queryName);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                }
            }
        }

        sql = "SELECT distinct `grouping` " +
                "FROM dashboards.`dashboard_results_" + queryId + "`"+
                " order by `grouping`";

        sqlCount = "SELECT 1";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getGroupingList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    public SeriesResult getSeriesFromQuery(String queryName) throws Exception {
        SeriesResult result = new SeriesResult();

        String sql = "";
        String sqlCount = "";

        sql = "select id from dashboards.query_library where name = ? ";
        String queryId = null;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, queryName);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryId = resultSet.getString("id");
                }
            }
        }

        sql = "SELECT distinct name " +
                "FROM dashboards.`dashboard_results_" + queryId + "`"+
                " order by name";

        sqlCount = "SELECT 1";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getSeriesList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    public SeriesResult getSeriesFromDashboardId(String dashboardId) throws Exception {
        SeriesResult result = new SeriesResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT distinct name " +
                "FROM dashboards.`covid_results_" + dashboardId + "`"+
                " order by name";

        sqlCount = "SELECT 1";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getSeriesList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<Series> getSeriesList(ResultSet resultSet) throws SQLException {
        List<Series> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getSeriesValues(resultSet));
        }

        return result;
    }

    public static Series getSeriesValues(ResultSet resultSet) throws SQLException {
        Series series = new Series();

        series.setName(resultSet.getString("name"));

        return series;
    }

    private List<Series> getGroupingList(ResultSet resultSet) throws SQLException {
        List<Series> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getGroupingValues(resultSet));
        }

        return result;
    }

    public static Series getGroupingValues(ResultSet resultSet) throws SQLException {
        Series series = new Series();

        series.setGrouping(resultSet.getString("grouping"));

        return series;
    }

    public RegistryQueryResult getRegistryQueries() throws Exception {
        RegistryQueryResult result = new RegistryQueryResult();

        String sql = "";
        String sqlCount = "";

        sql = "select distinct registry,query from dashboards.registries";

        sqlCount = "SELECT 999";


        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getRegistryQueryList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<RegistryQuery> getRegistryQueryList(ResultSet resultSet) throws SQLException {
        List<RegistryQuery> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getRegistryQuery(resultSet));
        }

        return result;
    }

    public static RegistryQuery getRegistryQuery(ResultSet resultSet) throws SQLException {
        RegistryQuery registryQuery = new RegistryQuery();

        registryQuery.setQuery(resultSet.getString("query"));
        registryQuery.setRegistry(resultSet.getString("registry"));

        return registryQuery;
    }

    public PopulationResult getPopulation() throws Exception {
        PopulationResult result = new PopulationResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT stp,ccg,pcn,practice,ethnic,age,sex,sum(list_size) as list_size " +
        "FROM dashboards.population_denominators " +
        "group by stp,ccg,pcn,practice,ethnic,age,sex " +
        "with rollup";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.population_denominators";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getPopulationList(resultSet));
            }
        }

        try (PreparedStatement statement = connection.prepareStatement(sqlCount)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<Population> getPopulationList(ResultSet resultSet) throws SQLException {
        List<Population> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getPopulation(resultSet));
        }

        return result;
    }

    public static Population getPopulation(ResultSet resultSet) throws SQLException {
        Population population = new Population();

        population
                .setStp(resultSet.getString("stp"))
                .setCcg(resultSet.getString("ccg"))
                .setPcn(resultSet.getString("pcn"))
                .setPractice(resultSet.getString("practice"))
                .setEthnic(resultSet.getString("ethnic"))
                .setAge(resultSet.getString("age"))
                .setSex(resultSet.getString("sex"))
                .setListSize(resultSet.getString("list_size"));
        return population;
    }

    @Override
    public void close() throws Exception {
        if (connection != null) {
            this.connection.close();
        }
    }
}
