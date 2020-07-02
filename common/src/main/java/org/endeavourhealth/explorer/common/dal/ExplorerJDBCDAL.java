package org.endeavourhealth.explorer.common.dal;

import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.*;

public class ExplorerJDBCDAL extends BaseJDBCDAL {

    private static final Logger LOG = LoggerFactory.getLogger(ExplorerJDBCDAL.class);

    public ChartResult getDashboard(String chartName, String dateFrom, String dateTo) throws Exception {

        List<String> charts = Arrays.asList(chartName.split("\\s*,\\s*"));

        ChartResult result = new ChartResult();
        String sql = "";

        List<Chart> chart = new ArrayList<>();
        Chart chartItem = null;

        for (String chart_name : charts) {
            chartItem = new Chart();
            chartItem.setName(chart_name);

            sql = "SELECT series_name,series_value,id from dashboards.dashboard_results where name = ? "+
                    "and series_name between ? and ? order by series_name";

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

    public Chart getDashboardSingle(String chartName, String dateFrom, String dateTo) throws Exception {

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "SELECT series_name,series_value,id from dashboards.dashboard_results where name = ? "+
                    "and series_name between ? and ? order by series_name";

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

    public Chart getDashboardSingle(String chartName) throws Exception {

        Chart chartItem = new Chart();
        chartItem.setName(chartName);

        String sql = "SELECT series_name,series_value,id from dashboards.dashboard_results where name = ? "+
                "order by series_name";

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
        series.setId(resultSet.getString("id"));
        return series;
    }

    public PatientResult getPatientResult(Integer page, Integer size, String dashboardId) throws Exception {
        PatientResult result = new PatientResult();

        String sql = "";

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
                "join dashboards.dashboard_patients dp on dp.patient_id = p.id " +
                "where dp.dashboard_id = ? order by p.last_name, p.first_names LIMIT ?,?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, dashboardId);
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
                "join dashboards.dashboard_patients dp on dp.patient_id = p.id " +
                "where dp.dashboard_id = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, dashboardId);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                result.setLength(resultSet.getInt(1));
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
