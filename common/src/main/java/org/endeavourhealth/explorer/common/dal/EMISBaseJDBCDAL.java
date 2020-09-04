package org.endeavourhealth.explorer.common.dal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

class EMISBaseJDBCDAL implements BaseDAL {
    private static final Logger LOG = LoggerFactory.getLogger(EMISBaseJDBCDAL.class);

    @SuppressWarnings("resource")
    final Connection conn = EMISConnectionPool.getInstance().pop();

    public void beginTransaction() throws SQLException {
        conn.setAutoCommit(false);
    }

    public void commit() throws SQLException {
        conn.commit();
    }

    public void rollback() throws SQLException {
        conn.rollback();
    }

    @Override
    public void close() throws Exception {
        try {
            conn.setAutoCommit(true);
        } finally {
            EMISConnectionPool.getInstance().push(this.conn);
        }
    }
}
