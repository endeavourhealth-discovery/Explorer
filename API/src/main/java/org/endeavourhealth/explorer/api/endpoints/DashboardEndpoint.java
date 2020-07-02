package org.endeavourhealth.explorer.api.endpoints;

import org.endeavourhealth.explorer.common.dal.ExplorerJDBCDAL;
import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("events")
public class DashboardEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardEndpoint.class);

    @GET
    @Path("/dashboard")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboard(@Context SecurityContext sc,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo) throws Exception {
        LOG.debug("getDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ChartResult result = viewerDAL.getDashboard(chartName,dateFrom,dateTo);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboardsingle")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboardSingle(@Context SecurityContext sc,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("ignoreDateRange") Integer ignoreDateRange) throws Exception {
        LOG.debug("getDashboardSingle");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            Chart result = null;
            if (ignoreDateRange==0)
                result = viewerDAL.getDashboardSingle(chartName,dateFrom,dateTo);
            else if (ignoreDateRange==1)
                result = viewerDAL.getDashboardSingle(chartName);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/patients")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPatients(@Context SecurityContext sc,
                                @QueryParam("page") Integer page,
                                @QueryParam("size") Integer size,
                                @QueryParam("dashboardId") String dashboardId) throws Exception {
        LOG.debug("getPatients");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            PatientResult result = viewerDAL.getPatientResult(page, size, dashboardId);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }


}
