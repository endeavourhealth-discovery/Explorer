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

public class ExplorerJDBCDAL extends BaseJDBCDAL {

    private static final Logger LOG = LoggerFactory.getLogger(ExplorerJDBCDAL.class);

    public void deleteValueSetCode(String id) throws Exception {

        id = "WHERE id in ("+id+")";

        String sql = "DELETE FROM dashboards.value_set_codes " +id;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public void saveValueSetCode(String type, String selectedDataType, String code, String term, String snomed, String value_set_id, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.value_set_codes (type, data_type, original_code, original_term, snomed_id, value_set_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }

        String sqlCount = "insert into dashboards.value_set_codes (value_set_id, type, original_code, original_term, snomed_id) " +
                "select (select max(id) as id from dashboards.value_sets), type, original_code, original_term, snomed_id " +
                "from dashboards.value_set_codes " +
                "where value_set_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sqlCount)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteDashboard(String dashboardId) throws Exception {

        dashboardId = "WHERE dashboard_id in ("+dashboardId+")";

        String sql = "DELETE FROM dashboards.dashboard_library " +dashboardId;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public void saveDashboard(String type, String name, String dashboardId, String jsonQuery) throws Exception {

        String sql = "";

        if (dashboardId.equals("")) {
            sql = "INSERT INTO dashboards.dashboard_library (type, name, query) " +
                    "VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, jsonQuery);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.dashboard_library SET type = ?, name = ?, query = ? " +
                    "WHERE dashboard_id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteQuery(String id) throws Exception {

        id = "WHERE id in ("+id+")";

        String sql = "DELETE FROM dashboards.query_library " +id;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public void saveQuery(String type, String name, String id, String jsonQuery) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.query_library (type, name, query) " +
                    "VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, jsonQuery);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.query_library SET type = ?, name = ?, query = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, jsonQuery);
                stmt.setString(4, id);
                stmt.executeUpdate();
            }
        }
    }

    public void duplicateQuery(String id) throws Exception {

        String sql = "insert into dashboards.query_library (type, name, query) " +
                "select type, concat('Copy of ',name), query from dashboards.query_library where id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteValueSet(String id) throws Exception {

        String sql = "DELETE FROM dashboards.value_sets WHERE id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

        sql = "DELETE FROM dashboards.value_set_codes WHERE value_set_id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

    }

    public void saveValueSet(String type, String name, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.value_sets (type, name) " +
                    "VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.value_sets SET type = ?, name = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
            case "3":
                sql = "SELECT distinct(`grouping`) as type " +
                        "FROM dashboards.dashboard_results " +
                        " order by `grouping`";

                sqlCount = "SELECT count(distinct(`grouping`)) " +
                        " FROM dashboards.dashboard_results";
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
            case "6":
                sql = "SELECT distinct(registry) as type " +
                        "FROM dashboards.registries WHERE parent_registry = ''" +
                        " order by registry";

                sqlCount = "SELECT count(distinct(registry)) " +
                        " FROM dashboards.registries WHERE parent_registry = ''";
                break;
            case "7":
                sql = "SELECT distinct(registry) as type " +
                        "FROM dashboards.registries WHERE parent_registry != ''" +
                        " order by registry";

                sqlCount = "SELECT count(distinct(registry)) " +
                        " FROM dashboards.registries WHERE parent_registry != ''";
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
                sql = "SELECT distinct(name) as type " +
                        "FROM dashboards.dashboard_results " +
                        "UNION select distinct(name) as type "+
                        "FROM dashboards.query_library " +
                        " order by type";

                sqlCount = "SELECT count(distinct(name)) " +
                        " FROM dashboards.dashboard_results";
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
            default:
                break;
        }

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            if (!type.isEmpty())
                statement.setString(1, type);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getLookupList(resultSet));
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

    public LookupListResult getLookupListByValueSet(String valueSetId) throws Exception {
        LookupListResult result = new LookupListResult();

        String sql = "SELECT distinct(type) " +
                " FROM dashboards.value_set_codes" +
                " WHERE value_set_id = ? " +
                " order by type";

        String sqlCount = "SELECT count(distinct(type)) " +
                " FROM dashboards.value_set_codes" +
                " WHERE value_set_id = ? ";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, Integer.valueOf(valueSetId));
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getLookupList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
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

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, type, name, updated, query " +
                "FROM dashboards.query_library " +
                 selectedTypeString+
                "order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.query_library " +
                 selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getQueryLibraryList(resultSet));
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
                .setId(resultSet.getInt("id"))
                .setType(resultSet.getString("type"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"))
                .setQuery(resultSet.getString("query"));
        return querylibrary;
    }

    public ValueSetCodeResult getValueSetCodes(String valueSetId, String selectedTypeString) throws Exception {
        ValueSetCodeResult result = new ValueSetCodeResult();

        String sql = "";
        String sqlCount = "";

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "AND type in ("+selectedTypeString+")";

        sql = "SELECT type, data_type, original_code, original_term, snomed_id, updated, id " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? " +
                selectedTypeString +
                " order by type, original_term";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? " +
                selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, valueSetId);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
            statement.setString(1, valueSetId);
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

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, type, name, updated " +
                "FROM dashboards.value_sets " +
                selectedTypeString+
                "order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_sets " +
                selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetLibraryList(resultSet));
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

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT dashboard_id, name, updated, type, query " +
                "FROM dashboards.dashboard_library " +
                 selectedTypeString+
                " order by type,name";

        sqlCount = "SELECT count(1) " +
                " FROM dashboards.dashboard_library "+
                 selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getDashboardList(resultSet));
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

    public ChartResult getDashboard(String chartName, String dateFrom, String dateTo, String cumulative, String grouping, String weekly, String rate) throws Exception {
        String ccg = "";

        List<String> charts = Arrays.asList(chartName.split("\\s*,\\s*"));

        if (!grouping.isEmpty()) {
            grouping = grouping.replaceAll(",","','");
            grouping = "'" + grouping + "'";
            ccg = grouping;
            grouping = " and `grouping` in ("+grouping+")";
        }

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        for (String chart_name : charts) {

            chartItem = new Chart();
            chartItem.setName(chart_name);

            String temp = "";

            if (rate.equals("1")) {
                if (chart_name.contains("(") && !chart_name.contains("CCG")) {
                    temp = chart_name.substring(chart_name.indexOf("("));
                    temp = ccg.replaceAll("CCG", "CCG " + temp);
                } else
                if (chart_name.contains("(") && chart_name.contains("CCG")) {
                    temp = chart_name.substring(chart_name.indexOf("("));
                    temp = temp.replaceFirst("\\(", "\\'");
                    temp = temp.replaceAll("\\)$", "\\'");
                } else
                {
                    temp = ccg;
                }
            }

            if (cumulative.equals("1")) {
                if (rate.equals("1")) {
                    sql = "SELECT t.series_name," +
                            "floor(@running_total:=@running_total + t.series_value) as series_value " +
                            "FROM " +
                            "( SELECT name,series_name,sum(series_value/((select sum(list_size) as list_size from dashboards.ccg_list_sizes where ccg in ("+temp+"))/100000)) as series_value "+
                            "FROM dashboards.dashboard_results r " +
                            "where name = ? "+
                            "and series_name between ? and ? "+grouping+" group by series_name) t " +
                            "JOIN (SELECT @running_total:=0) r " +
                            "ORDER BY t.series_name";
                } else {
                    sql = "SELECT t.series_name," +
                            "@running_total:=@running_total + t.series_value as series_value " +
                            "FROM " +
                            "( SELECT name,series_name,sum(series_value) as series_value "+
                            "FROM dashboards.dashboard_results " +
                            "where name = ? and series_name between ? and ? "+grouping+" group by series_name) t " +
                            "JOIN (SELECT @running_total:=0) r " +
                            "ORDER BY t.series_name";
                }

            } else {
                if (weekly.equals("1")) {
                    if (rate.equals("1")) {
                        sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                                "floor(SUM(series_value/((select sum(list_size) as list_size from dashboards.ccg_list_sizes where ccg in ("+temp+"))/100000))) AS series_value " +
                                "from dashboards.dashboard_results r "+
                                "where name = ? "+
                                "and series_name between ? and ? "+grouping+
                                " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                                "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                    } else {
                        sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                                "SUM(series_value) AS series_value " +
                                "from dashboards.dashboard_results where name = ? " +
                                "and series_name between ? and ? "+grouping+
                                " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                                "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                    }
                } else {
                    if (rate.equals("1")) {
                        sql = "SELECT series_name,floor(sum(series_value/((select sum(list_size) as list_size from dashboards.ccg_list_sizes where ccg in ("+temp+"))/100000))) as series_value from dashboards.dashboard_results r "+
                                "where name = ? "+
                                "and series_name between ? and ? "+grouping+" group by series_name order by series_name";
                    } else {
                        sql = "SELECT series_name,sum(series_value) as series_value from dashboards.dashboard_results where name = ? " +
                                "and series_name between ? and ? " + grouping + " group by series_name order by series_name";
                    }
                }

            }
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chart_name);
                statement.setString(2, dateFrom);
                statement.setString(3, dateTo);
                try (ResultSet resultSet = statement.executeQuery()) {
                    chartItem.setSeries(getSeriesFromResultSet(resultSet));
                }
            }

            chart.add(chartItem);
        }

        result.setResults(chart);

        return result;
    }

    public Chart getDashboardSingle(String chartName, String dateFrom, String dateTo, String grouping) throws Exception {

        grouping = grouping.replaceAll(",","','");
        grouping = "'" + grouping + "'";
        grouping = " and `grouping` in ("+grouping+")";

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "SELECT series_name,sum(series_value) as series_value from dashboards.dashboard_results where name = ? "+
                "and series_name between ? and ? "+grouping+" group by series_name order by series_name";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, chartName);
            statement.setString(2, dateFrom);
            statement.setString(3, dateTo);
            try (ResultSet resultSet = statement.executeQuery()) {
                chartItem.setSeries(getSeriesFromResultSet(resultSet));
            }
        }

        return chartItem;
    }

    public Chart getDashboardSingle(String chartName, String grouping) throws Exception {

        grouping = grouping.replaceAll(",","','");
        grouping = "'" + grouping + "'";
        grouping = " and `grouping` in ("+grouping+")";

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "SELECT series_name,sum(series_value) as series_value from dashboards.dashboard_results where name = ? "+grouping+
                " group by series_name order by series_name";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, chartName);
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

    public PatientResult getPatientResult(Integer page, Integer size, String name, String chartName, String seriesName, String grouping) throws Exception {
        PatientResult result = new PatientResult();

        grouping = grouping.replaceAll(",","','");
        grouping = "'" + grouping + "'";
        grouping = " and `grouping` in ("+grouping+")";

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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+") "+
                    "LIMIT ?,?";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+")";


            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+") "+
                    "and p.last_name like ? LIMIT ?,?";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
                statement.setString(3, names[0]+"%");
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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+") "+
                    "and p.last_name like ?";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
                statement.setString(3, names[0]+"%");
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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+") "+
                    "and (p.first_names like ? and p.last_name like ?) LIMIT ?,?";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
                statement.setString(3, names[0]+"%");
                statement.setString(4, names[1]+"%");
                statement.setInt(5, page * 10);
                statement.setInt(6, size);
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
                    "(SELECT patient_id FROM dashboards.dashboard_patients " +
                    "where name = ? " +
                    "and series_name = ? "+grouping+") "+
                    "and (p.first_names like ? and p.last_name like ?)";

            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, chartName);
                statement.setString(2, seriesName);
                statement.setString(3, names[0]+"%");
                statement.setString(4, names[1]+"%");
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

        String sql = "";

        sql = "call dashboards.getRegistries(?,?)";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, ccg);
            statement.setString(2, registry);
            try (ResultSet resultSet = statement.executeQuery()) {
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

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, type, name, updated " +
                "FROM dashboards.organisation_groups " +
                selectedTypeString+
                "order by type,name";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.organisation_groups " +
                selectedTypeString;

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

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, organisation_group_id);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getOrganisationsList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
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
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.organisation_groups SET type = ?, name = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, name);
                stmt.setString(3, id);
                stmt.executeUpdate();
            }
        }
    }

    public void deleteOrganisationGroup(String id) throws Exception {

        String sql = "DELETE FROM dashboards.organisation_groups WHERE id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

        sql = "DELETE FROM dashboards.organisations WHERE organisation_group_id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

    }

    public void duplicateOrganisationGroup(String id) throws Exception {

        String sql = "insert into dashboards.organisation_groups (type, name) " +
                "select type, concat('Copy of ',name) from dashboards.organisation_groups where id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }

        String sqlCount = "insert into dashboards.organisations (organisation_group_id, name, type, ods_code) " +
                "select (select max(id) as id from dashboards.organisation_groups), name, type, ods_code " +
                "from dashboards.organisations " +
                "where organisation_group_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sqlCount)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void saveOrganisation(String name, String type, String code, String organisation_group_id, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.organisations (name, type, ods_code, organisation_group_id) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, type);
                stmt.setString(3, code);
                stmt.setString(4, id);
                stmt.executeUpdate();
            }
        }
    }

    public void deleteOrganisation(String id) throws Exception {

        id = "WHERE id in ("+id+")";

        String sql = "DELETE FROM dashboards.organisations " +id;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public QueryResult getQuery(String selectedQuery) throws Exception {
        QueryResult result = new QueryResult();

        String sql = "";

        sql = "SELECT query " +
                "FROM dashboards.query_library " +
                "WHERE name = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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

        query
                .setQuery(resultSet.getString("query"));
        return query;
    }

    public DashboardViewResult getDashboardView(String dashboardNumber) throws Exception {
        DashboardViewResult result = new DashboardViewResult();

        String sql = "";

        sql = "SELECT type, name, query " +
                "FROM dashboards.dashboard_library " +
                "WHERE dashboard_id = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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

    public void saveRegistry(String query, String name, String id, String orgs) throws Exception {

        String sql = "";

        if (id.equals("")) {
            orgs = orgs.replaceAll(",","','");
            orgs = "'" + orgs + "'";
            orgs = "SELECT g.name as grp, o.name as org, o.ods_code FROM dashboards.organisation_groups g " +
                    "join dashboards.organisations o on o.organisation_group_id = g.id " +
                    "where g.name in ("+orgs+")";

            try (PreparedStatement statement = conn.prepareStatement(orgs)) {
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        String group = resultSet.getString("grp");
                        String org = resultSet.getString("org");
                        String ods_code = resultSet.getString("ods_code");

                        sql = "INSERT INTO dashboards.registries (registry, query, ccg, practice_name, ods_code) " +
                                "SELECT * FROM (SELECT ? as '1', ? as '2', ? as '3', ? as '4', ? as '5') AS tmp "+
                                "WHERE NOT EXISTS (SELECT * FROM dashboards.registries " +
                                "WHERE registry = ? and ods_code = ?)  LIMIT 1";

                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setString(1, name);
                            stmt.setString(2, query);
                            stmt.setString(3, group);
                            stmt.setString(4, org);
                            stmt.setString(5, ods_code);
                            stmt.setString(6, name);
                            stmt.setString(7, ods_code);
                            stmt.executeUpdate();
                        }
                    }
                }
            }

        } else // edit
        {
            sql = "UPDATE dashboards.registries SET parent_registry = ? " +
                    "WHERE "+
                    "parent_registry in (select registry from (select registry from dashboards.registries where id = ? limit 1) as t) "+
                    "and ods_code in (select ods_code from (select ods_code from dashboards.registries where id = ? limit 1) as t2) ";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, id);
                stmt.setString(3, id);
                stmt.executeUpdate();
            }

            sql = "UPDATE dashboards.registries SET registry = ?, query = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, query);
                stmt.setString(3, id);
                stmt.executeUpdate();
            }
        }

        // create fake registry results for now
        sql = "CALL dashboards.dummy_registries()";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public void deleteRegistry(String id, String name, String odscode) throws Exception {

        name = name.replaceAll(",","','");
        name = "'" + name + "'";

        odscode = odscode.replaceAll(",","','");
        odscode = "'" + odscode + "'";

        String sql = "DELETE FROM dashboards.registries WHERE id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

        sql = "DELETE FROM dashboards.registries WHERE parent_registry in ("+name+") and ods_code in ("+odscode+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

    }

    public void duplicateRegistry(String id, String registry) throws Exception {

        String sql = "insert into dashboards.registries (registry, query, ccg, practice_name, ods_code) " +
                "select concat('Copy of ',registry), query, ccg, practice_name, ods_code from dashboards.registries where id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }

        String sqlCount = "insert into dashboards.registries (registry, query, ccg, practice_name, ods_code, parent_registry) " +
                "select registry, query, ccg, practice_name, ods_code, concat('Copy of ',parent_registry) " +
                "from dashboards.registries " +
                "WHERE "+
                "parent_registry in (select registry from (select registry from dashboards.registries where id = ? limit 1) as t) "+
                "and ods_code in (select ods_code from (select ods_code from dashboards.registries where id = ? limit 1) as t2) ";


        try (PreparedStatement stmt = conn.prepareStatement(sqlCount)) {
            stmt.setString(1, id);
            stmt.setString(2, id);
            stmt.executeUpdate();
        }
    }

    public void saveRegistryIndicator(String query, String name, String indicator) throws Exception {

        String sql = "";
        sql = "INSERT INTO dashboards.registries (registry, query, parent_registry) " +
                "VALUES (?, ?, ?)";

        sql = "INSERT INTO dashboards.registries " +
                "(registry,query,ccg,practice_name,ods_code,parent_registry) " +
                "SELECT distinct ?,?,ccg,practice_name,ods_code,? " +
                "FROM dashboards.registries " +
                "where registry = ? "+
                "and NOT EXISTS (SELECT * FROM dashboards.registries WHERE registry = ? and parent_registry = ? LIMIT 1);";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, indicator);
            stmt.setString(2, query);
            stmt.setString(3, name);
            stmt.setString(4, name);
            stmt.setString(5, indicator);
            stmt.setString(6, name);
            stmt.executeUpdate();
        }

        // create fake registry results for now
        sql = "CALL dashboards.dummy_registries()";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public void deleteRegistryIndicator(String id) throws Exception {

        String sql = "DELETE FROM dashboards.registries WHERE id in ("+id+")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }

    }

    public void duplicateRegistryIndicator(String id) throws Exception {

        String sql = "insert into dashboards.registries (registry, query, ccg, practice_name, ods_code, parent_registry) " +
                "select registry, query, ccg, practice_name, ods_code, parent_registry from dashboards.registries where id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public ArrayList<String> getMapDates(String query) throws Exception {

        String sql = "";
        if ("Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query)) {
            sql = "select distinct date_format(covid_date, '%Y-%m-%d') as date " +
                    "from dashboards.lsoa_covid order by covid_date";
        } else {
            sql = "select id from dashboards.query_library where name = ? ";
            String queryId = null;
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        if (!"Suspected and confirmed Covid-19 cases".equalsIgnoreCase(query)) {
            String sql = "select id from dashboards.query_library where name = ? ";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
            sql = "select min(date_format(covid_date, '%Y-%m-%d')) as min_date from dashboards.lsoa_covid";
        } else {
            sql = "select min(date_format(`Effective date`, '%Y-%m-%d')) as min_date from dashboards.observation_output_" + queryId;
        }
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
            sql = "SELECT COUNT(covid.lsoa_code) AS patients, " +
                    "regs.reg_count AS reg_patients, " +
                    "ROUND(((COUNT(covid.lsoa_code) * 1000) / regs.reg_count),1) AS ratio, " +
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
                    "AND covid.covid_date >= '" + minDate + "' " +
                    "AND covid.covid_date <= ? " +
                    "GROUP BY covid.lsoa_code " +
                    "ORDER BY covid.lsoa_code ";
        } else {
            sql = "SELECT COUNT(PERSON.`LSOA code`) as patients, " +
                    "REGS.reg_count as reg_patients, " +
                    "ROUND(((COUNT(PERSON.`LSOA code`) * 1000) / REGS.reg_count),1) AS ratio, " +
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            if(queryId == null) {
                statement.setString(1, date);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    MapLayer layer = new MapLayer();
                    BigDecimal ratio = resultSet.getBigDecimal("ratio");
                    float ratioFloat = ratio.floatValue();
                    String description = "";

                    layer.setAreaCode(resultSet.getString("lsoa_code"));
                    description = layer.getAreaCode() + ": " +
                            resultSet.getInt("patients") + " of " +
                            resultSet.getInt("reg_patients");
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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

        if (StringUtils.isNullOrEmpty(orderColumn)){
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

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
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

        HashMap<Integer,String> queryLibrary = new HashMap<>();
        String sql = "select id, name from dashboards.query_library";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    queryLibrary.put(resultSet.getInt("id"), resultSet.getString("name"));
                }
            }
        }

        for (Integer id : queryLibrary.keySet()) {
            sql = "select table_name from information_schema.columns where table_name = 'person_output_" + id + "' and column_name = 'LSOA code';";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
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

    public TableData searchOrganisations(String searchData, Integer pageNumber, Integer pageSize,
                                         String orderColumn, boolean descending) throws Exception {

        TableData data = new TableData();

        TableHeader header = new TableHeader();
        header.setLabel("Name");
        header.setProperty("ccg");
        data.getHeaders().add(header);

        header = new TableHeader();
        header.setLabel("List size");
        header.setProperty("list_size");
        data.getHeaders().add(header);

        JSONObject row = null;
        String order = " asc ";
        if (descending) {
            order = " desc ";
        }
        String sql = null;
        if (StringUtils.isNullOrEmpty(searchData)) {
            sql = "select *  from dashboards.ccg_list_sizes " +
                    " order by " + orderColumn + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        } else {
            sql = "select *  from dashboards.ccg_list_sizes " +
                    " where ccg like ? " +
                    " order by " + orderColumn + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        }
        DecimalFormat formatter = new DecimalFormat("#,###");
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            if (!StringUtils.isNullOrEmpty(searchData)) {
                statement.setString(1, "%" + searchData + "%");
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    row = new JSONObject();
                    row.put("ccg", resultSet.getString("ccg"));
                    row.put("list_size", formatter.format(resultSet.getBigDecimal("list_size")));
                    data.getRows().add(row);
                }
            }
        }
        return data;
    }

    public long getOrganisationsTotalCount(String searchData) throws Exception {
        int count = 0;
        String sql = null;
        if (StringUtils.isNullOrEmpty(searchData)) {
            sql = "select count(*) as count from dashboards.ccg_list_sizes ";
        } else {
            sql = "select count(*) as count from dashboards.ccg_list_sizes " +
                    " where ccg like ? ";
        }
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            if (!StringUtils.isNullOrEmpty(searchData)) {
                statement.setString(1, "%" + searchData + "%");
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    count = resultSet.getInt("count");
                }
            }
        }
        return count;
    }

    public TableData searchPractices(String ccg, String searchData, Integer pageNumber, Integer pageSize,
                                                     String orderColumn, boolean descending) throws Exception {

        TableData data = new TableData();

        TableHeader header = new TableHeader();
        header.setLabel("Practice");
        header.setProperty("practice");
        data.getHeaders().add(header);

        header = new TableHeader();
        header.setLabel("ODS code");
        header.setProperty("ods_code");
        data.getHeaders().add(header);

        header = new TableHeader();
        header.setLabel("List size");
        header.setProperty("list_size");
        data.getHeaders().add(header);

        JSONObject row = null;
        String order = " asc ";
        if (descending) {
            order = " desc ";
        }
        String like = "";
        if (!StringUtils.isNullOrEmpty(searchData)) {
            like = " and (practice like ? or ods_code like ?) ";
        }
        String sql = null;
        if (StringUtils.isNullOrEmpty(searchData)) {
            sql = "select *  from dashboards.practice_list_sizes " +
                    " where ccg = ? " +
                    " order by " + orderColumn + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        } else {
            sql = "select *  from dashboards.practice_list_sizes " +
                    " where ccg = ? " +
                    like +
                    " order by " + orderColumn + order +
                    " limit " + ((pageNumber - 1)*pageSize) + "," + pageSize;
        }
        DecimalFormat formatter = new DecimalFormat("#,###");
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, ccg);
            if (!StringUtils.isNullOrEmpty(searchData)) {
                statement.setString(2, "%" + searchData + "%");
                statement.setString(3, "%" + searchData + "%");
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    row = new JSONObject();
                    row.put("practice", resultSet.getString("practice"));
                    row.put("ods_code", resultSet.getString("ods_code"));
                    row.put("list_size", formatter.format(resultSet.getBigDecimal("list_size")));
                    data.getRows().add(row);
                }
            }
        }
        return data;
    }

    public long getPracticesTotalCount(String ccg, String searchData) throws Exception {
        int count = 0;
        String like = "";
        if (!StringUtils.isNullOrEmpty(searchData)) {
            like = " and (practice like ? or ods_code like ?) ";
        }
        String sql = null;
        if (StringUtils.isNullOrEmpty(searchData)) {
            sql = "select count(*) as count from dashboards.practice_list_sizes " +
                    " where ccg = ? ";
        } else {
            sql = "select count(*) as count from dashboards.practice_list_sizes " +
                    " where ccg = ? " + like;
        }
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, ccg);
            if (!StringUtils.isNullOrEmpty(searchData)) {
                statement.setString(2, "%" + searchData + "%");
                statement.setString(3, "%" + searchData + "%");
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    count = resultSet.getInt("count");
                }
            }
        }
        return count;
    }
}
