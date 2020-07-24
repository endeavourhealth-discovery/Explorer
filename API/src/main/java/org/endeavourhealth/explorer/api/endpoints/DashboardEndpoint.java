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

@Path("events")
public class DashboardEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardEndpoint.class);

    @GET
    @Path("/lookuplists")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getLookupLists(@Context SecurityContext sc,
                                        @QueryParam("list") String list) throws Exception {
        LOG.debug("getLookupLists");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            LookupListResult result = viewerDAL.getLookupLists(list);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboardlibrary")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboardLibrary(@Context SecurityContext sc,
                                        @QueryParam("page") Integer page,
                                        @QueryParam("size") Integer size,
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getDashboardLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            DashboardLibraryResult result = viewerDAL.getDashboardLibrary(page, size, selectedTypeString);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboard")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboard(@Context SecurityContext sc,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("cumulative") String cumulative,
                                 @QueryParam("grouping") String grouping,
                                 @QueryParam("weekly") String weekly) throws Exception {
        LOG.debug("getDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ChartResult result = viewerDAL.getDashboard(chartName,dateFrom,dateTo, cumulative, grouping,weekly);

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
                                 @QueryParam("ignoreDateRange") Integer ignoreDateRange,
                                 @QueryParam("grouping") String grouping) throws Exception {
        LOG.debug("getDashboardSingle");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            Chart result = null;
            if (ignoreDateRange==0)
                result = viewerDAL.getDashboardSingle(chartName,dateFrom,dateTo, grouping);
            else if (ignoreDateRange==1)
                result = viewerDAL.getDashboardSingle(chartName, grouping);

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
                                @QueryParam("name") String name,
                                @QueryParam("chartName") String chartName,
                                @QueryParam("seriesName") String seriesName,
                                @QueryParam("grouping") String grouping) throws Exception {
        LOG.debug("getPatients");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            PatientResult result = viewerDAL.getPatientResult(page, size, name, chartName, seriesName, grouping);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/valuesetlibrary")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getValueSetLibrary(@Context SecurityContext sc,
                                        @QueryParam("page") Integer page,
                                        @QueryParam("size") Integer size,
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getValueSetLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ValueSetLibraryResult result = viewerDAL.getValueSetLibrary(page, size, selectedTypeString);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/valuesetcode")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getValueSetCodes(@Context SecurityContext sc,
                                       @QueryParam("page") Integer page,
                                       @QueryParam("size") Integer size,
                                       @QueryParam("value_set_id") String value_set_id) throws Exception {
        LOG.debug("getValueSetCodes");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ValueSetCodeResult result = viewerDAL.getValueSetCodes(page, size, value_set_id);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/querylibrary")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getQueryLibrary(@Context SecurityContext sc,
                                       @QueryParam("page") Integer page,
                                       @QueryParam("size") Integer size,
                                       @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getQueryLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            QueryLibraryResult result = viewerDAL.getQueryLibrary(page, size, selectedTypeString);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/valueseteditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveValueSet(@Context SecurityContext sc,
                                       @QueryParam("type") String type,
                                       @QueryParam("name") String name,
                                       @QueryParam("id") String id) throws Exception {
        LOG.debug("saveValueSet");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveValueSet(type, name, id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/valuesetdelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteValueSet(@Context SecurityContext sc,
                                 @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteValueSet");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteValueSet(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/queryeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveQuery(@Context SecurityContext sc,
                                 @QueryParam("type") String type,
                                 @QueryParam("name") String name,
                                 @QueryParam("id") String id) throws Exception {
        LOG.debug("saveQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveQuery(type, name, id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/querydelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteQuery(@Context SecurityContext sc,
                                   @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteQuery(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/dashboardeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveDashboard(@Context SecurityContext sc,
                              @QueryParam("type") String type,
                              @QueryParam("name") String name,
                              @QueryParam("dashboardId") String dashboardId) throws Exception {
        LOG.debug("saveDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveDashboard(type, name, dashboardId);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/dashboarddelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteDashboard(@Context SecurityContext sc,
                                @QueryParam("dashboardId") String dashboardId) throws Exception {
        LOG.debug("deleteDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteDashboard(dashboardId);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/valuesetduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateValueSet(@Context SecurityContext sc,
                                    @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateValueSet");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateValueSet(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/valuesetcodeeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveValueSetCode(@Context SecurityContext sc,
                                  @QueryParam("type") String type,
                                  @QueryParam("code") String code,
                                  @QueryParam("term") String term,
                                  @QueryParam("snomed") String snomed,
                                  @QueryParam("value_set_id") String value_set_id,
                                  @QueryParam("id") String id) throws Exception {
        LOG.debug("saveValueSetCode");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveValueSetCode(type, code, term, snomed, value_set_id, id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/valuesetcodedelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteValueSetCode(@Context SecurityContext sc,
                                    @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteValueSetCode");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteValueSetCode(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/registries")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRegistry(@Context SecurityContext sc,
                                    @QueryParam("page") Integer page,
                                    @QueryParam("size") Integer size,
                                    @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getRegistry");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            RegistryResult result = viewerDAL.getRegistry(page, size, selectedTypeString);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }






}
