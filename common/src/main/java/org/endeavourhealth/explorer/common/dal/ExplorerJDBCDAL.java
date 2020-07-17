package org.endeavourhealth.explorer.common.dal;

import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.*;

public class ExplorerJDBCDAL extends BaseJDBCDAL {

    private static final Logger LOG = LoggerFactory.getLogger(ExplorerJDBCDAL.class);

    public void deleteValueSet(String id) throws Exception {

        String sql = "DELETE FROM dashboards.value_sets WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void saveValueSet(String type, String name) throws Exception {
        String sql = "INSERT INTO dashboards.value_sets (type, name) " +
                "VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type);
            stmt.setString(2, name);
            stmt.executeUpdate();
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
                sql = "SELECT distinct(grouping) as type " +
                        "FROM dashboards.dashboard_results " +
                        " order by grouping";

                sqlCount = "SELECT count(distinct(grouping)) " +
                        " FROM dashboards.dashboard_results";
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

    public QueryLibraryResult getQueryLibrary(Integer page, Integer size, String selectedTypeString) throws Exception {
        QueryLibraryResult result = new QueryLibraryResult();

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, type, name, updated " +
                "FROM dashboards.query_library " +
                 selectedTypeString+
                "order by type,name LIMIT ?,?";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.query_library " +
                 selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, page*12);
            statement.setInt(2, size);
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
                .setUpdated(resultSet.getDate("updated"));
        return querylibrary;
    }

    public ValueSetResult getValueSet(Integer page, Integer size, String id) throws Exception {
        ValueSetResult result = new ValueSetResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT type, original_code, original_term, snomed_id, updated " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ? " +
                "order by type, original_term LIMIT ?,?";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_set_codes " +
                "WHERE value_set_id = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, id);
            statement.setInt(2, page*12);
            statement.setInt(3, size);
            try (ResultSet resultSet = statement.executeQuery()) {
                result.setResults(getValueSetList(resultSet));
            }
        }

        try (PreparedStatement statement = conn.prepareStatement(sqlCount)) {
            statement.setString(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
            }
        }

        return result;
    }

    private List<ValueSet> getValueSetList(ResultSet resultSet) throws SQLException {
        List<ValueSet> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getValueSet(resultSet));
        }

        return result;
    }

    public static ValueSet getValueSet(ResultSet resultSet) throws SQLException {
        ValueSet valueset = new ValueSet();

        valueset
                .setType(resultSet.getString("type"))
                .setCode(resultSet.getString("original_code"))
                .setTerm(resultSet.getString("original_term"))
                .setSnomed(resultSet.getString("snomed_id"))
                .setUpdated(resultSet.getDate("updated"));
        return valueset;
    }

    public ValueSetLibraryResult getValueSetLibrary(Integer page, Integer size) throws Exception {
        ValueSetLibraryResult result = new ValueSetLibraryResult();

        String sql = "";
        String sqlCount = "";

        sql = "SELECT id, name, updated, type " +
                "FROM dashboards.value_sets " +
                "order by name LIMIT ?,?";

        sqlCount = "SELECT count(1) " +
                "FROM dashboards.value_sets";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, page*12);
            statement.setInt(2, size);
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

    public DashboardLibraryResult getDashboardLibrary(Integer page, Integer size, String selectedTypeString) throws Exception {
        DashboardLibraryResult result = new DashboardLibraryResult();

        selectedTypeString = selectedTypeString.replaceAll(",","','");
        selectedTypeString = "'" + selectedTypeString + "'";
        selectedTypeString = "WHERE type in ("+selectedTypeString+")";

        String sql = "";
        String sqlCount = "";

        sql = "SELECT dashboard_id, name, updated, type " +
                "FROM dashboards.dashboard_library " +
                 selectedTypeString+
                " order by type LIMIT ?,?";

        sqlCount = "SELECT count(1) " +
                " FROM dashboards.dashboard_library "+
                 selectedTypeString;

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, page*12);
            statement.setInt(2, size);
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

    private List<Dashboard> getDashboardList(ResultSet resultSet) throws SQLException {
        List<Dashboard> result = new ArrayList<>();
        while (resultSet.next()) {
            result.add(getDashboard(resultSet));
        }

        return result;
    }

    public static Dashboard getDashboard(ResultSet resultSet) throws SQLException {
        Dashboard dashboard = new Dashboard();

        dashboard
                .setDashboardId(resultSet.getInt("dashboard_id"))
                .setName(resultSet.getString("name"))
                .setUpdated(resultSet.getDate("updated"))
                .setType(resultSet.getString("type"));
        return dashboard;
    }

    public ChartResult getDashboard(String chartName, String dateFrom, String dateTo, String cumulative, String grouping) throws Exception {

        List<String> charts = Arrays.asList(chartName.split("\\s*,\\s*"));

        grouping = grouping.replaceAll(",","','");
        grouping = "'" + grouping + "'";
        grouping = " and `grouping` in ("+grouping+")";

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        for (String chart_name : charts) {
            chartItem = new Chart();
            chartItem.setName(chart_name);

            if (cumulative.equals("0"))
                sql = "SELECT series_name,sum(series_value) as series_value from dashboards.dashboard_results where name = ? "+
                    "and series_name between ? and ? "+grouping+" group by series_name order by series_name";
            else
                sql = "SELECT t.series_name," +
                        "@running_total:=@running_total + t.series_value as series_value " +
                        "FROM " +
                        "( SELECT name,series_name,sum(series_value) as series_value "+
                        "FROM dashboards.dashboard_results " +
                        "where name = ? and series_name between ? and ? "+grouping+" group by series_name) t " +
                        "JOIN (SELECT @running_total:=0) r " +
                        "ORDER BY t.series_name";

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



}
