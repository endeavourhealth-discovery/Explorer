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
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Path("events")
public class DashboardEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardEndpoint.class);

    @GET
    @Path("/lookuplists")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getLookupLists(@Context SecurityContext sc,
                                        @QueryParam("list") String list,
                                        @QueryParam("type") String type) throws Exception {
        LOG.debug("getLookupLists");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            LookupListResult result = viewerDAL.getLookupLists(list, type);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/lookuplistbyvalueset")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getLookupListByValueSet(@Context SecurityContext sc,
                                   @QueryParam("selectedValueSet") String valueSetId) throws Exception {
        LOG.debug("getLookupListByValueSet");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            LookupListResult result = viewerDAL.getLookupListByValueSet(valueSetId);

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
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getDashboardLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            DashboardLibraryResult result = viewerDAL.getDashboardLibrary(selectedTypeString);

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
                                 @QueryParam("query") String query,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("cumulative") String cumulative,
                                 @QueryParam("grouping") String grouping,
                                 @QueryParam("weekly") String weekly,
                                 @QueryParam("rate") String rate,
                                 @QueryParam("combineSeries") String combineSeries) throws Exception {
        LOG.debug("getDashboard");
        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ChartResult result = null;

            if (combineSeries.equals("1")) {
                result = viewerDAL.getDashboardCombine(query, chartName, dateFrom, dateTo, cumulative, grouping, weekly, rate);
            } else {
                result = viewerDAL.getDashboard(query, chartName, dateFrom, dateTo, cumulative, grouping, weekly, rate);
            }
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
                                 @QueryParam("query") String query,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("ignoreDateRange") Integer ignoreDateRange,
                                 @QueryParam("grouping") String grouping) throws Exception {
        LOG.debug("getDashboardSingle");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            Chart result = null;
            if (ignoreDateRange==0)
                result = viewerDAL.getDashboardSingle(query, chartName,dateFrom,dateTo, grouping);
            else if (ignoreDateRange==1)
                result = viewerDAL.getDashboardSingle(query, chartName, grouping);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboardRegistries")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboardRegistries(@Context SecurityContext sc,
                                       @QueryParam("organisations") String organisations,
                                       @QueryParam("registries") String registries
                                       ) throws Exception {
        LOG.debug("getDashboardRegistries");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ChartResult result = null;

            result = viewerDAL.getDashboardRegistries(organisations, registries);

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
                                @QueryParam("queryId") String queryId) throws Exception {
        LOG.debug("getPatients");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            PatientResult result = viewerDAL.getPatientResult(page, size, name, queryId);

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
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getValueSetLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ValueSetLibraryResult result = viewerDAL.getValueSetLibrary(selectedTypeString);

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
                                     @QueryParam("valueSetId") String valueSetId,
                                     @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {

        LOG.debug("getValueSetCodes");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ValueSetCodeResult result = viewerDAL.getValueSetCodes(valueSetId, selectedTypeString);

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
                                       @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getQueryLibrary");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            QueryLibraryResult result = viewerDAL.getQueryLibrary(selectedTypeString);

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

    @POST
    @Path("/queryeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveQuery(@Context SecurityContext sc,
                              QueryLibrary params) throws Exception {
        LOG.debug("saveQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveQuery(params.getType(), params.getName(), params.getRegistryName(), params.getDenominatorQuery(), params.getId(), params.getJsonQuery());

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
                              @QueryParam("dashboardId") String dashboardId,
                              @QueryParam("jsonQuery") String jsonQuery) throws Exception {
        LOG.debug("saveDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveDashboard(type, name, dashboardId, jsonQuery);

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
                                  @QueryParam("selectedDataType") String selectedDataType,
                                  @QueryParam("code") String code,
                                  @QueryParam("term") String term,
                                  @QueryParam("snomed") String snomed,
                                  @QueryParam("value_set_id") String value_set_id,
                                  @QueryParam("id") String id) throws Exception {
        LOG.debug("saveValueSetCode");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveValueSetCode(type, selectedDataType, code, term, snomed, value_set_id, id);

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
    public Response getRegistries(@Context SecurityContext sc,
                                    @QueryParam("org") String org,
                                    @QueryParam("registry") String registry) throws Exception {
        LOG.debug("getRegistries");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            RegistriesResult result = viewerDAL.getRegistries(org, registry);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/organisationgroups")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrganisationGroups(@Context SecurityContext sc,
                                       @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getOrganisationGroups");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            OrganisationGroupsResult result = viewerDAL.getOrganisationGroups(selectedTypeString);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/organisations")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getOrganisations(@Context SecurityContext sc,
                                     @QueryParam("organisation_group_id") String organisation_group_id) throws Exception {
        LOG.debug("getOrganisations");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            OrganisationsResult result = viewerDAL.getOrganisations(organisation_group_id);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/organisationgroupeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveOrganisationGroup(@Context SecurityContext sc,
                                 @QueryParam("type") String type,
                                 @QueryParam("name") String name,
                                 @QueryParam("id") String id) throws Exception {
        LOG.debug("saveOrganisationGroup");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveOrganisationGroup(type, name, id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/organisationgroupdelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteOrganisationGroup(@Context SecurityContext sc,
                                   @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteOrganisationGroup");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteOrganisationGroup(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/organisationeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveOrganisation(@Context SecurityContext sc,
                                     @QueryParam("name") String name,
                                     @QueryParam("type") String type,
                                     @QueryParam("code") String code,
                                     @QueryParam("organisation_group_id") String organisation_group_id,
                                     @QueryParam("id") String id) throws Exception {
        LOG.debug("saveOrganisation");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveOrganisation(name, type, code, organisation_group_id, id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/organisationdelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteOrganisation(@Context SecurityContext sc,
                                       @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteOrganisation");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteOrganisation(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/organisationgroupduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateOrganisationGroup(@Context SecurityContext sc,
                                      @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateOrganisationGroup");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateOrganisationGroup(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/dashboardduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateDashboard(@Context SecurityContext sc,
                                               @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateDashboard");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateDashboard(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/queryduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateQuery(@Context SecurityContext sc,
                                               @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateQuery(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/query")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getQuery(@Context SecurityContext sc,
                          @QueryParam("selectedQuery") String selectedQuery) throws Exception {
        LOG.debug("getQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            QueryResult result = viewerDAL.getQuery(selectedQuery);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/seriesFromQuery")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSeriesFromQuery(@Context SecurityContext sc,
                             @QueryParam("query") String query) throws Exception {
        LOG.debug("getSeriesFromQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            SeriesResult result = viewerDAL.getSeriesFromQuery(query);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboardview")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboardView(@Context SecurityContext sc,
                             @QueryParam("dashboardNumber") String dashboardNumber) throws Exception {
        LOG.debug("getDashboardView");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            DashboardViewResult result = viewerDAL.getDashboardView(dashboardNumber);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/mapDates")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMapDates(@Context SecurityContext sc,
                                  @QueryParam("query") String query) throws Exception {

        LOG.debug("getMapDates");

        query = URLDecoder.decode(query, StandardCharsets.UTF_8.toString());

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ArrayList<String> result = viewerDAL.getMapDates(query);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/getMaps")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMaps(@Context SecurityContext sc,
                            @QueryParam("query") String query,
                            @QueryParam("date") String date,
                            @QueryParam("lower_limits") List<String> lowerLimits,
                            @QueryParam("upper_limits") List<String> upperLimits,
                            @QueryParam("colors") List<String> colors,
                            @QueryParam("descriptions") List<String> descriptions) throws Exception {

        LOG.debug("getMaps");

        query = URLDecoder.decode(query, StandardCharsets.UTF_8.toString());

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            MapResult result = viewerDAL.getMaps(query, date, lowerLimits, upperLimits, colors, descriptions);
            result.setLowerLimits(new ArrayList(lowerLimits));
            result.setUpperLimits(new ArrayList(upperLimits));
            result.setColors(new ArrayList(colors));
            result.setDescriptions(new ArrayList(descriptions));

            LOG.debug("map generated.");

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/tableData")
    public Response getTableData(@Context SecurityContext sc,
                                 @QueryParam("query_name") String queryName,
                                 @QueryParam("output_type") String outputType,
                                 @QueryParam("search_data") String searchData,
                                 @QueryParam("page_number") Integer pageNumber,
                                 @QueryParam("page_size") Integer pageSize,
                                 @QueryParam("order_column") String orderColumn,
                                 @QueryParam("descending") boolean descending) throws Exception {

        LOG.debug("getTableData");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            TableData data = viewerDAL.getTableData(queryName, outputType, searchData, pageNumber, pageSize, orderColumn, descending);

            return Response
                    .ok()
                    .entity(data)
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/tableTotalCount")
    public Response getTableTotalCount(@Context SecurityContext sc,
                                       @QueryParam("query_name") String queryName,
                                       @QueryParam("output_type") String outputType,
                                       @QueryParam("search_data") String searchData) throws Exception {

        LOG.debug("getTableTotalCount");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            long count = viewerDAL.getTableTotalCount(queryName, outputType, searchData);

            return Response
                    .ok()
                    .entity(count)
                    .build();
        }
    }

    @GET
    @Path("/mapQueries")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMapQueries(@Context SecurityContext sc) throws Exception {

        LOG.debug("getMapQueries");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ArrayList<String> result = viewerDAL.getMapQueries();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }


    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/searchOrganisations")
    public Response searchOrganisations(@Context SecurityContext sc,
                                        @QueryParam("search_data") String searchData,
                                        @QueryParam("page_number") Integer pageNumber,
                                        @QueryParam("page_size") Integer pageSize,
                                        @QueryParam("order_column") String orderColumn,
                                        @QueryParam("descending") boolean descending) throws Exception {

        LOG.debug("searchOrganisations");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            TableData data = viewerDAL.searchOrganisations(searchData, pageNumber, pageSize,
                    orderColumn, descending);

            return Response
                    .ok()
                    .entity(data)
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/organisationsTotalCount")
    public Response getOrganisationsTotalCount(@Context SecurityContext sc,
                                               @QueryParam("search_data") String searchData) throws Exception {

        LOG.debug("getOrganisationsTotalCount");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            long count = viewerDAL.getOrganisationsTotalCount(searchData);

            return Response
                    .ok()
                    .entity(count)
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/searchPractices")
    public Response searchPractices(@Context SecurityContext sc,
                                    @QueryParam("ccg") String ccg,
                                    @QueryParam("search_data") String searchData,
                                    @QueryParam("page_number") Integer pageNumber,
                                    @QueryParam("page_size") Integer pageSize,
                                    @QueryParam("order_column") String orderColumn,
                                    @QueryParam("descending") boolean descending) throws Exception {

        LOG.debug("searchPractices");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            TableData data = viewerDAL.searchPractices(ccg, searchData, pageNumber, pageSize,
                    orderColumn, descending);

            return Response
                    .ok()
                    .entity(data)
                    .build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/practicesTotalCount")
    public Response getPracticesTotalCount(@Context SecurityContext sc,
                                           @QueryParam("ccg") String ccg,
                                           @QueryParam("search_data") String searchData) throws Exception {

        LOG.debug("getPracticesTotalCount");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            long count = viewerDAL.getPracticesTotalCount(ccg, searchData);

            return Response
                    .ok()
                    .entity(count)
                    .build();
        }
    }

    @GET
    @Path("/registryQueries")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRegistryQueries(@Context SecurityContext sc) throws Exception {
        LOG.debug("getRegistryQueries");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            RegistryQueryResult result = viewerDAL.getRegistryQueries();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }
}
