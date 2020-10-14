package org.endeavourhealth.explorer.api.endpoints;

import org.endeavourhealth.explorer.common.dal.EMISExplorerJDBCDAL;
import org.endeavourhealth.explorer.common.dal.ExplorerJDBCDAL;
import org.endeavourhealth.explorer.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.ArrayList;

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
    @Path("/dashboard2")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboard2(@Context SecurityContext sc,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("cumulative") String cumulative,
                                 @QueryParam("grouping") String grouping,
                                 @QueryParam("weekly") String weekly) throws Exception {
        LOG.debug("getDashboard2");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ChartResult result = viewerDAL.getDashboard2(chartName,dateFrom,dateTo, cumulative, grouping,weekly);

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
                                       @QueryParam("value_set_id") String value_set_id) throws Exception {
        LOG.debug("getValueSetCodes");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ValueSetCodeResult result = viewerDAL.getValueSetCodes(value_set_id);

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

    @GET
    @Path("/queryeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveQuery(@Context SecurityContext sc,
                                 @QueryParam("type") String type,
                                 @QueryParam("name") String name,
                                 @QueryParam("id") String id,
                                 @QueryParam("jsonQuery") String jsonQuery) throws Exception {
        LOG.debug("saveQuery");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveQuery(type, name, id, jsonQuery);

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
    @Path("/registryduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateRegistry(@Context SecurityContext sc,
                                               @QueryParam("id") String id,
                                               @QueryParam("name") String name) throws Exception {
        LOG.debug("duplicateRegistry");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateRegistry(id, name);

            return Response
                    .ok()
                    .build();
        }
    }


    @GET
    @Path("/registryeditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveRegistry(@Context SecurityContext sc,
                                          @QueryParam("query") String query,
                                          @QueryParam("name") String name,
                                          @QueryParam("id") String id,
                                        @QueryParam("orgs") String orgs) throws Exception {
        LOG.debug("saveRegistry");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveRegistry(query, name, id, orgs);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/registrydelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteRegistry(@Context SecurityContext sc,
                                    @QueryParam("id") String id,
                                    @QueryParam("name") String name,
                                    @QueryParam("odscode") String odscode) throws Exception {
        LOG.debug("deleteRegistry");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteRegistry(id, name, odscode);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/registryindicatorduplicate")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response duplicateRegistryIndicator(@Context SecurityContext sc,
                                      @QueryParam("id") String id) throws Exception {
        LOG.debug("registryindicatorduplicate");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.duplicateRegistryIndicator(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/registryindicatoreditor")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response saveRegistryIndicator(@Context SecurityContext sc,
                                 @QueryParam("query") String query,
                                 @QueryParam("name") String name,
                                 @QueryParam("indicator") String indicator) throws Exception {
        LOG.debug("saveRegistryIndicator");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.saveRegistryIndicator(query, name, indicator);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/registryindicatordelete")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteRegistryIndicator(@Context SecurityContext sc,
                                   @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteRegistryIndicator");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            viewerDAL.deleteRegistryIndicator(id);

            return Response
                    .ok()
                    .build();
        }
    }

    @GET
    @Path("/covidDates")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCovidDates(@Context SecurityContext sc) throws Exception {

        LOG.debug("getCovidDates");

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            ArrayList<String> result = viewerDAL.getCovidDates();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/covidMaps")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCovidMaps(@Context SecurityContext sc,
                                 @QueryParam("date") String date) throws Exception {
        LOG.debug("getCovidMaps date:" + date);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {
            MapResult result = viewerDAL.getCovidMaps(date);

            LOG.debug("map generated.");

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }
}
