package org.endeavourhealth.explorer.common.dal;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.GenericCache;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class EMISConnectionPool extends GenericCache<Connection> {
    private static final Logger LOG = LoggerFactory.getLogger(EMISConnectionPool.class);
    private static final int VALID_TIMEOUT = 5;
    private static EMISConnectionPool instance = null;

    public static EMISConnectionPool getInstance() {
        if (instance == null)
            instance = new EMISConnectionPool();

        return instance;
    }

    @Override
    protected boolean isValid(Connection connection) {
        try {
            if (connection == null)
                return false;

            if (connection.isValid(VALID_TIMEOUT)) {
                connection.setAutoCommit(true);
                return true;
            }

            decSize();

            if (!connection.isClosed())
                connection.close();

            return false;
        } catch (SQLException e) {
            LOG.error("Error validating/cleaning up connection", e);
            return false;
        }
    }

    @Override
    protected Connection create() {
        try {
            Class.forName("com.facebook.presto.jdbc.PrestoDriver");

            ConfigManager.Initialize("explorer");
            JsonNode json = ConfigManager.getConfigurationAsJson("database");
            String url = json.get("url").asText();
            url = "jdbc:presto://providerplus-test.testemisnightingale.co.uk:443/hive";
            String user = json.get("username").asText();
            user = "darren.sheavills";
            String pass = json.get("password").asText();
            pass = "";
            String driver = json.get("class") == null ? null : json.get("class").asText();

            if (driver != null && !driver.isEmpty())
                Class.forName(driver);

            Properties props = new Properties();

            props.setProperty("user", user);
            props.setProperty("password", pass);
            props.setProperty("SSL", "true");
            props.setProperty("SSLKeyStorePassword", "lhsemis");
            props.setProperty("SSLKeyStorePath", "/Users/darren/darren.sheavills_keystore.jks");

            Connection connection = DriverManager.getConnection(url, props);

            incSize();
            return connection;
        } catch (Exception e) {
            LOG.error(e.getMessage());
            return null;
        }
    }

    @Override
    public Connection pop() {
        Connection conn = super.pop();
        incUse();
        return conn;
    }

    @Override
    public void push(Connection conn) {
        decUse();
        super.push(conn);
    }

    private void incSize() {
        MetricsHelper.recordCounter("ConnectionPool.Size").inc();
    }

    private void decSize() {
        MetricsHelper.recordCounter("ConnectionPool.Size").dec();
    }

    private void incUse() {
        MetricsHelper.recordCounter("ConnectionPool.InUse").inc();
    }

    private void decUse() {
        MetricsHelper.recordCounter("ConnectionPool.InUse").dec();
    }
}
