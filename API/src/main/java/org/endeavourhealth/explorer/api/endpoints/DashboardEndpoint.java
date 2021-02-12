package org.endeavourhealth.explorer.api.endpoints;

import org.endeavourhealth.core.database.dal.usermanager.caching.ProjectCache;
import org.endeavourhealth.core.database.dal.usermanager.caching.UserCache;
import org.endeavourhealth.core.database.rdbms.datasharingmanager.models.ProjectEntity;
import org.endeavourhealth.core.database.rdbms.usermanager.models.UserProjectEntity;
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

import static org.endeavourhealth.core.database.dal.usermanager.caching.UserCache.getUserProject;

@Path("events")
public class DashboardEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(DashboardEndpoint.class);

    List<String> validOrgs = new ArrayList<>();
    String configName = null;

    private void checkUserAccessToOrganisations(String userProjectId) throws Exception {

        UserProjectEntity up = UserCache.getUserProject(userProjectId);

        List<String> orgList = ProjectCache.getAllPublishersForValidProject(up.getProjectId(), true);

        ProjectEntity project = ProjectCache.getProjectDetails(up.getProjectId());

        if (project != null) {
            configName = project.getConfigName();
        }

        validOrgs = orgList;
    }

    @GET
    @Path("/covidlibrary")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCovidLibrary(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId) throws Exception {
        LOG.debug("getCovidLibrary");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            CovidLibraryResult result = viewerDAL.getCovidLibrary();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }


    @GET
    @Path("/lookuplists")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getLookupLists(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                        @QueryParam("list") String list,
                                        @QueryParam("type") String type) throws Exception {
        LOG.debug("getLookupLists");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getLookupListByValueSet(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                   @QueryParam("selectedValueSet") String valueSetId) throws Exception {
        LOG.debug("getLookupListByValueSet");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getDashboardLibrary(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getDashboardLibrary");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getDashboard(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                 @QueryParam("query") String query,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("cumulative") String cumulative,
                                 @QueryParam("grouping") String grouping,
                                 @QueryParam("weekly") String weekly
                                 ) throws Exception {
        LOG.debug("getDashboard");
        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            ChartResult result = null;

            result = viewerDAL.getDashboard(query, chartName, dateFrom, dateTo, cumulative, grouping, weekly);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/dashboardcovid")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDashboardCovid(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                            @QueryParam("dashboardId") String dashboardId,
                            @QueryParam("series") String series,
                            @QueryParam("dateFrom") String dateFrom,
                            @QueryParam("dateTo") String dateTo,
                            @QueryParam("stp")String stp,
                            @QueryParam("ccg")String ccg,
                            @QueryParam("pcn")String pcn,
                            @QueryParam("practice")String practice,
                            @QueryParam("ethnic")String ethnic,
                            @QueryParam("age")String age,
                            @QueryParam("sex")String sex,
                            @QueryParam("cumulative") String cumulative,
                            @QueryParam("weekly") String weekly,
                            @QueryParam("rate") String rate,
                            @QueryParam("combineSeries") String combineSeries,
                            @QueryParam("combineEthnic") String combineEthnic,
                            @QueryParam("combineAge") String combineAge,
                            @QueryParam("combineSex") String combineSex,
                            @QueryParam("combineOrgs") String combineOrgs) throws Exception {
        LOG.debug("getDashboardCovid");
        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            ChartResult result = null;

            result = viewerDAL.getDashboardCovid(dashboardId, series, dateFrom, dateTo, stp, ccg, pcn, practice, ethnic, age, sex, cumulative, weekly, rate, combineSeries, combineEthnic, combineAge, combineSex, combineOrgs);

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
    public Response getDashboardSingle(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                 @QueryParam("query") String query,
                                 @QueryParam("chartName") String chartName,
                                 @QueryParam("dateFrom") String dateFrom,
                                 @QueryParam("dateTo") String dateTo,
                                 @QueryParam("ignoreDateRange") Integer ignoreDateRange,
                                 @QueryParam("grouping") String grouping) throws Exception {
        LOG.debug("getDashboardSingle");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getDashboardRegistries(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("organisations") String organisations,
                                       @QueryParam("registries") String registries
                                       ) throws Exception {
        LOG.debug("getDashboardRegistries");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getPatients(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                @QueryParam("page") Integer page,
                                @QueryParam("size") Integer size,
                                @QueryParam("name") String name,
                                @QueryParam("queryId") String queryId) throws Exception {
        LOG.debug("getPatients");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getValueSetLibrary(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                        @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getValueSetLibrary");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getValueSetCodes(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                     @QueryParam("valueSetId") String valueSetId,
                                     @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {

        LOG.debug("getValueSetCodes");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getQueryLibrary(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getQueryLibrary");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveValueSet(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("type") String type,
                                       @QueryParam("name") String name,
                                       @QueryParam("id") String id) throws Exception {
        LOG.debug("saveValueSet");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteValueSet(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                 @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteValueSet");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                              QueryLibrary params) throws Exception {
        LOG.debug("saveQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                   @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveDashboard(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                              @QueryParam("type") String type,
                              @QueryParam("name") String name,
                              @QueryParam("dashboardId") String dashboardId,
                              @QueryParam("jsonQuery") String jsonQuery) throws Exception {
        LOG.debug("saveDashboard");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteDashboard(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                @QueryParam("dashboardId") String dashboardId) throws Exception {
        LOG.debug("deleteDashboard");
        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response duplicateValueSet(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                    @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateValueSet");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveValueSetCode(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                  @QueryParam("type") String type,
                                  @QueryParam("selectedDataType") String selectedDataType,
                                  @QueryParam("code") String code,
                                  @QueryParam("term") String term,
                                  @QueryParam("snomed") String snomed,
                                  @QueryParam("value_set_id") String value_set_id,
                                  @QueryParam("id") String id) throws Exception {
        LOG.debug("saveValueSetCode");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteValueSetCode(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                    @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteValueSetCode");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getRegistries(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                    @QueryParam("org") String org,
                                    @QueryParam("registry") String registry) throws Exception {
        LOG.debug("getRegistries");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getOrganisationGroups(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("selectedTypeString") String selectedTypeString) throws Exception {
        LOG.debug("getOrganisationGroups");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getOrganisations(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                     @QueryParam("organisation_group_id") String organisation_group_id) throws Exception {
        LOG.debug("getOrganisations");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveOrganisationGroup(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                 @QueryParam("type") String type,
                                 @QueryParam("name") String name,
                                 @QueryParam("id") String id) throws Exception {
        LOG.debug("saveOrganisationGroup");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteOrganisationGroup(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                   @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteOrganisationGroup");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response saveOrganisation(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                     @QueryParam("name") String name,
                                     @QueryParam("type") String type,
                                     @QueryParam("code") String code,
                                     @QueryParam("organisation_group_id") String organisation_group_id,
                                     @QueryParam("id") String id) throws Exception {
        LOG.debug("saveOrganisation");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response deleteOrganisation(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("id") String id) throws Exception {
        LOG.debug("deleteOrganisation");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response duplicateOrganisationGroup(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                      @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateOrganisationGroup");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response duplicateDashboard(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                               @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateDashboard");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response duplicateQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                               @QueryParam("id") String id) throws Exception {
        LOG.debug("duplicateQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                          @QueryParam("selectedQuery") String selectedQuery) throws Exception {
        LOG.debug("getQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getSeriesFromQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                             @QueryParam("query") String query) throws Exception {
        LOG.debug("getSeriesFromQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            SeriesResult result = viewerDAL.getSeriesFromQuery(query);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/groupingFromQuery")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getGroupingFromQuery(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("query") String query) throws Exception {
        LOG.debug("getGroupingFromQuery");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            SeriesResult result = viewerDAL.getGroupingFromQuery(query);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/seriesFromDashboardId")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSeriesFromDashboardId(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("dashboardId") String dashboardId) throws Exception {
        LOG.debug("getSeriesFromDashboardId");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            SeriesResult result = viewerDAL.getSeriesFromDashboardId(dashboardId);

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
    public Response getDashboardView(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                             @QueryParam("dashboardNumber") String dashboardNumber) throws Exception {
        LOG.debug("getDashboardView");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            DashboardViewResult result = viewerDAL.getDashboardView(dashboardNumber);

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/covidview")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getCovidDashboardView(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                     @QueryParam("dashboardNumber") String dashboardNumber) throws Exception {
        LOG.debug("getCovidDashboardView");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            DashboardViewResult result = viewerDAL.getCovidDashboardView(dashboardNumber);

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
    public Response getMapDates(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                  @QueryParam("query") String query) throws Exception {

        LOG.debug("getMapDates");

        query = URLDecoder.decode(query, StandardCharsets.UTF_8.toString());

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getMaps(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                            @QueryParam("query") String query,
                            @QueryParam("date") String date,
                            @QueryParam("lower_limits") List<String> lowerLimits,
                            @QueryParam("upper_limits") List<String> upperLimits,
                            @QueryParam("colors") List<String> colors,
                            @QueryParam("descriptions") List<String> descriptions) throws Exception {

        LOG.debug("getMaps");

        query = URLDecoder.decode(query, StandardCharsets.UTF_8.toString());

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getTableData(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                 @QueryParam("query_name") String queryName,
                                 @QueryParam("output_type") String outputType,
                                 @QueryParam("search_data") String searchData,
                                 @QueryParam("page_number") Integer pageNumber,
                                 @QueryParam("page_size") Integer pageSize,
                                 @QueryParam("order_column") String orderColumn,
                                 @QueryParam("descending") boolean descending) throws Exception {

        LOG.debug("getTableData");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getTableTotalCount(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId,
                                       @QueryParam("query_name") String queryName,
                                       @QueryParam("output_type") String outputType,
                                       @QueryParam("search_data") String searchData) throws Exception {

        LOG.debug("getTableTotalCount");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

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
    public Response getMapQueries(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId) throws Exception {

        LOG.debug("getMapQueries");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            ArrayList<String> result = viewerDAL.getMapQueries();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/registryQueries")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRegistryQueries(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId) throws Exception {
        LOG.debug("getRegistryQueries");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            RegistryQueryResult result = viewerDAL.getRegistryQueries();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/population")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPopulation(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId) throws Exception {
        LOG.debug("getPopulation");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            PopulationResult result = viewerDAL.getPopulation();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }

    @GET
    @Path("/registrylists")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRegistryLists(@Context SecurityContext sc, @HeaderParam("userProjectId") String userProjectId) throws Exception {
        LOG.debug("getRegistryLists");

        checkUserAccessToOrganisations(userProjectId);

        try (ExplorerJDBCDAL viewerDAL = new ExplorerJDBCDAL()) {

            viewerDAL.setValidOrgs(validOrgs);
            viewerDAL.setSubscriberConnection(configName);

            RegistryListsResult result = viewerDAL.getRegistryLists();

            return Response
                    .ok()
                    .entity(result)
                    .build();
        }
    }
}
