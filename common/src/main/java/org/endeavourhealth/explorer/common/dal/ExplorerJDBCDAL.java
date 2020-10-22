package org.endeavourhealth.explorer.common.dal;

import com.amazonaws.util.StringUtils;
import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.rmi.registry.Registry;
import java.sql.*;
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

    public void saveValueSetCode(String type, String code, String term, String snomed, String value_set_id, String id) throws Exception {

        String sql = "";

        if (id.equals("")) {
            sql = "INSERT INTO dashboards.value_set_codes (type, original_code, original_term, snomed_id, value_set_id) " +
                    "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, code);
                stmt.setString(3, term);
                stmt.setString(4, snomed);
                stmt.setString(5, value_set_id);
                stmt.executeUpdate();
            }
        } else // edit
        {
            sql = "UPDATE dashboards.value_set_codes SET type = ?, original_code = ?, original_term = ?, snomed_id = ? " +
                    "WHERE id = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, type);
                stmt.setString(2, code);
                stmt.setString(3, term);
                stmt.setString(4, snomed);
                stmt.setString(5, id);
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

    public LookupListResult getLookupLists(String list) throws Exception {
        LookupListResult result = new LookupListResult();

        String sql = "";
        String sqlCount = "";

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
                        "FROM dashboards.value_set_codes" +
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

    public ValueSetCodeResult getValueSetCodes(String value_set_id) throws Exception {
        ValueSetCodeResult result = new ValueSetCodeResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT type, original_code, original_term, snomed_id, updated, id " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? " +
                "order by type, original_term";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, value_set_id);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
            statement.setString(1, value_set_id);
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

    public ChartResult getDashboard(String chartName, String dateFrom, String dateTo, String cumulative, String grouping, String weekly) throws Exception {

        List<String> charts = Arrays.asList(chartName.split("\\s*,\\s*"));

        if (!grouping.isEmpty()) {
            grouping = grouping.replaceAll(",","','");
            grouping = "'" + grouping + "'";
            grouping = " and `grouping` in ("+grouping+")";
        }

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        for (String chart_name : charts) {

            chartItem = new Chart();
            chartItem.setName(chart_name);

            if (cumulative.equals("1")) {
                sql = "SELECT t.series_name," +
                        "@running_total:=@running_total + t.series_value as series_value " +
                        "FROM " +
                        "( SELECT name,series_name,sum(series_value) as series_value "+
                        "FROM dashboards.dashboard_results " +
                        "where name = ? and series_name between ? and ? "+grouping+" group by series_name) t " +
                        "JOIN (SELECT @running_total:=0) r " +
                        "ORDER BY t.series_name";
            } else {
                if (weekly.equals("1")) {
                    sql = "SELECT FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) AS series_name, " +
                            "SUM(series_value) AS series_value " +
                            "from dashboards.dashboard_results where name = ? " +
                            "and series_name between ? and ? "+grouping+
                            " GROUP BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7)) " +
                            "ORDER BY FROM_DAYS(TO_DAYS(series_name) -MOD(TO_DAYS(series_name) -1, 7))";
                } else {
                    sql = "SELECT series_name,sum(series_value) as series_value from dashboards.dashboard_results where name = ? "+
                            "and series_name between ? and ? "+grouping+" group by series_name order by series_name";
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
        grouping = " and grouping in ("+grouping+")";

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

    public ArrayList<String> getCovidDates() throws Exception {

        ArrayList<String> list = new ArrayList();
        String sql = "select distinct date_format(covid_date, '%Y-%m-%d') as covid_date " +
                "from dashboards.lsoa_covid order by covid_date";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String date = resultSet.getString("covid_date");
                    list.add(date);
                }
            }
        }
        return list;
    }

    public MapResult getCovidMaps(String date,
                                  List<String> lowerLimits,
                                  List<String> upperLimits,
                                  List<String> colors,
                                  List<String> descriptions) throws Exception {

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
        sql = "select min(date_format(covid_date, '%Y-%m-%d')) as min_date from dashboards.lsoa_covid";
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

        sql = "SELECT COUNT(covid.lsoa_code) AS covid_patients, " +
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
                "AND covid.covid_date <= '" + date + "' " +
                "GROUP BY covid.lsoa_code " +
                "ORDER BY covid.lsoa_code ";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    MapLayer layer = new MapLayer();
                    BigDecimal ratio = resultSet.getBigDecimal("ratio");
                    float ratioFloat = ratio.floatValue();
                    String description = "";

                    layer.setAreaCode(resultSet.getString("lsoa_code"));
                    description = layer.getAreaCode() + ": " +
                            resultSet.getInt("covid_patients") + " of " +
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
}
