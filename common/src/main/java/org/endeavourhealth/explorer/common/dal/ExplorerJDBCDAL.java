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

            sql = "SELECT series_name,series_value from dashboards.dashboard_results where name = ? "+
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

        String sql = "SELECT series_name,series_value from dashboards.dashboard_results where name = ? "+
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

        String sql = "SELECT series_name,series_value from dashboards.dashboard_results where name = ? "+
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
        series.setValue(resultSet.getInt("series_value"));
        return series;
    }



}
