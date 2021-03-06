import { Injectable } from '@angular/core';
import {Observable} from 'rxjs/Observable';
import {HttpClient, HttpParams} from '@angular/common/http';
import {of} from "rxjs";
import {Level} from "./map/model/Level";

@Injectable({
  providedIn: 'root'
})
export class ExplorerService {
  private _nameCache: any = {};

  constructor(private http: HttpClient) { }

  getLookupLists(list: string, type: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('list', list);
    params = params.append('type', type);

    return this.http.get('api/events/lookuplists', {params});
  }

  getLookupListValueSet(valueSetId: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('selectedValueSet', valueSetId);

    return this.http.get('api/events/lookuplistbyvalueset', {params});
  }

  getDashboard(query: string, charts: string, dateFrom: string, dateTo: string, cumulative: string, grouping: string, weekly: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('query', query);
    params = params.append('chartName', charts);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('cumulative', cumulative);
    params = params.append('grouping', grouping);
    params = params.append('weekly', weekly);

    return this.http.get('api/events/dashboard', {params});
  }

  getDashboardCovid(dashboardId: string, series: string, dateFrom: string, dateTo: string, stp: string, ccg: string, pcn: string, practice: string, ethnic: string,
                    age: string, sex: string, cumulative: string, weekly: string, rate: string,
                    combineSeries: any, combineEthnic: any, combineAge: any, combineSex: any, combineOrgs: any): Observable<any> {
    let params = new HttpParams();

    params = params.append('dashboardId', dashboardId);
    params = params.append('series', series);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('stp', stp);
    params = params.append('ccg', ccg);
    params = params.append('pcn', pcn);
    params = params.append('practice', practice);
    params = params.append('ethnic', ethnic);
    params = params.append('age', age);
    params = params.append('sex', sex);
    params = params.append('cumulative', cumulative);
    params = params.append('weekly', weekly);
    params = params.append('rate', rate);
    params = params.append('combineSeries', combineSeries);
    params = params.append('combineEthnic', combineEthnic);
    params = params.append('combineAge', combineAge);
    params = params.append('combineSex', combineSex);
    params = params.append('combineOrgs', combineOrgs);

    return this.http.get('api/events/dashboardcovid', {params});
  }

  getDashboardSingle(query: string, chart: string, dateFrom: string, dateTo: string, ignoreDateRange: number, grouping: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('query', query);
    params = params.append('chartName', chart);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('ignoreDateRange', ignoreDateRange.toString());
    params = params.append('grouping', grouping);

    return this.http.get('api/events/dashboardsingle', {params});
  }

  getDashboardTrend(charts: string, dateFrom: string, dateTo: string, weekly: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', charts);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('weekly', weekly);

    return this.http.get('api/events/dashboardtrend', {params});
  }

  getPatients(page: number, size: number, name: string, queryId: string, parentQueryId: string, met: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('name', name);
    params = params.append('queryId', queryId);
    params = params.append('parentQueryId', parentQueryId);
    params = params.append('met', met);

    return this.http.get('api/events/patients', {params});
  }

  getDashboardLibrary(selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/dashboardlibrary', {params});
  }

  getCovidLibrary(): Observable<any> {

    return this.http.get('api/events/covidlibrary');
  }

  getValueSetLibrary(selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/valuesetlibrary', {params});
  }

  getValueSetCodes(valueSetId?: string, selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('valueSetId', valueSetId);
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/valuesetcode', {params});
  }

  getQueryLibrary(selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/querylibrary', {params});
  }

  saveValueSet(type?: string, name?: string, id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('name', name);
    params = params.append('id', id);

    return this.http.get('api/events/valueseteditor', {params});
  }

  deleteValueSet(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/valuesetdelete', {params});
  }

  saveQuery(type?: string, name?: string, registryName?: string, denominatorQuery?:string, id?: string, jsonQuery?: string): Observable<any> {
    let body = {
      type: type,
      name: name,
      registryName: registryName,
      denominatorQuery: denominatorQuery,
      id: id,
      jsonQuery: jsonQuery
    }

    return this.http.post<string>('api/events/queryeditor', body);
  }

  deleteQuery(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/querydelete', {params});
  }

  saveDashboard(type?: string, name?: string, dashboardId?: string, jsonQuery?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('name', name);
    params = params.append('dashboardId', dashboardId);
    params = params.append('jsonQuery', jsonQuery);

    return this.http.get('api/events/dashboardeditor', {params});
  }

  deleteDashboard(dashboardId?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('dashboardId', dashboardId);

    return this.http.get('api/events/dashboarddelete', {params});
  }

  duplicateValueSet(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/valuesetduplicate', {params});
  }

  saveValueSetCode(type?: string, selectedDataType?: string, code?: string, term?: string, snomed?: string, value_set_id?: string, id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('selectedDataType', selectedDataType);
    params = params.append('code', code);
    params = params.append('term', term);
    params = params.append('snomed', snomed);
    params = params.append('value_set_id', value_set_id);
    params = params.append('id', id);

    return this.http.get('api/events/valuesetcodeeditor', {params});
  }

  deleteValueSetCode(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/valuesetcodedelete', {params});
  }

  getRegistries(org: string, registry: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('org', org.toString());
    params = params.append('registry', registry.toString());

    return this.http.get('api/events/registries', {params});
  }

  duplicateDashboard(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/dashboardduplicate', {params});
  }

  duplicateQuery(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/queryduplicate', {params});
  }

  duplicateRegistry(id?: string, name?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);
    params = params.append('name', name);

    return this.http.get('api/events/registryduplicate', {params});
  }

  saveRegistry(query?: string, name?: string, id?: string, orgs?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('query', query);
    params = params.append('name', name);
    params = params.append('id', id);
    params = params.append('orgs', orgs);

    return this.http.get('api/events/registryeditor', {params});
  }

  deleteRegistry(id?: string, name?: string, odscode?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);
    params = params.append('name', name);
    params = params.append('odscode', odscode);

    return this.http.get('api/events/registrydelete', {params});
  }

  duplicateRegistryIndicator(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/registryindicatorduplicate', {params});
  }

  saveRegistryIndicator(query?: string, name?: string, indicator?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('query', query);
    params = params.append('name', name);
    params = params.append('indicator', indicator);

    return this.http.get('api/events/registryindicatoreditor', {params});
  }

  deleteRegistryIndicator(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/registryindicatordelete', {params});
  }

  getQuery(selectedQuery?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('selectedQuery', selectedQuery);

    return this.http.get('api/events/query', {params});
  }

  getSeriesFromQuery(query?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('query', query);

    return this.http.get('api/events/seriesFromQuery', {params});
  }

  getGroupingFromQuery(query?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('query', query);

    return this.http.get('api/events/groupingFromQuery', {params});
  }

  getSeriesFromDashboardId(dashboardId?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('dashboardId', dashboardId);

    return this.http.get('api/events/seriesFromDashboardId', {params});
  }

  getDashboardView(dashboardNumber: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('dashboardNumber', dashboardNumber);

    return this.http.get('api/events/dashboardview', {params});
  }

  getCovidView(dashboardNumber: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('dashboardNumber', dashboardNumber);

    return this.http.get('api/events/covidview', {params});
  }

  getMapDates(query: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('query', encodeURIComponent(query));
    return this.http.get('api/events/mapDates', {params});
  }

  getMaps(query: string, date: string, levels: Level[]): Observable<any> {
    let params = new HttpParams();
    params = params.append('query', encodeURIComponent(query));
    params = params.append('date', date);
    for (let level in levels) {
      params = params.append('lower_limits', levels[level].lowerLimit);
      params = params.append('upper_limits', levels[level].upperLimit);
      params = params.append('colors', levels[level].color);
      params = params.append('descriptions', levels[level].description);
    }
    return this.http.get('api/events/getMaps', {params});
  }

  tableSearch(queryName: string, outputType: string, searchData: string, pageNumber: number, pageSize: number,
              orderColumn: string, descending: boolean): Observable<any> {
    let params = new HttpParams();
    if (queryName) params = params.append('query_name', queryName);
    if (outputType) params = params.append('output_type', outputType);
    if (searchData) params = params.append('search_data', searchData);
    if (pageNumber) params = params.append('page_number', pageNumber.toString());
    if (pageSize) params = params.append('page_size', pageSize.toString());
    if (orderColumn) params = params.append('order_column', orderColumn);
    if (descending) params = params.append('descending', descending.toString());
    return this.http.get('api/events/tableData', {params});
  }

  getTotalCount(queryName: string, outputType: string, searchData: string): Observable<any> {
    let params = new HttpParams();
    if (queryName) params = params.append('query_name', queryName);
    if (outputType) params = params.append('output_type', outputType);
    if (searchData) params = params.append('search_data', searchData);
    return this.http.get('api/events/tableTotalCount', {params});
  }

  getMapQueries(): Observable<any> {
    let params = new HttpParams();
    return this.http.get('api/events/mapQueries', {params});
  }

  getRegistryQueries(): Observable<any> {
    let params = new HttpParams();

    return this.http.get('api/events/registryQueries', {params});
  }

  getDashboardRegistries (selectedOrganisations: string, selectedRegistries: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('organisations', selectedOrganisations);
    params = params.append('registries', selectedRegistries);

    return this.http.get('api/events/dashboardRegistries', {params});
  }

  getPopulation(): Observable<any> {
    let params: HttpParams = new HttpParams();

    return this.http.get('api/events/population', {params});
  }

  getOrganisationTree(): Observable<any> {
    let params = new HttpParams();

    return this.http.get('api/events/organisationtree', {params});
  }

  getRegistryLists(): Observable<any> {

    let params = new HttpParams();

    return this.http.get('api/events/registrylists', {params});
  }

  getQueryQueue(): Observable<any> {
    let params: HttpParams = new HttpParams();

    return this.http.get('api/events/queryqueue', {params});
  }

  resetQueue(id: string): Observable<any> {
    let params: HttpParams = new HttpParams();

    params = params.append('id', id);

    return this.http.get('api/events/resetQueue', {params});
  }

}
