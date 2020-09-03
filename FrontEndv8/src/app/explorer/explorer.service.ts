import { Injectable } from '@angular/core';
import {Observable} from 'rxjs/Observable';
import {HttpClient, HttpParams} from '@angular/common/http';
import {of} from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class ExplorerService {
  private _nameCache: any = {};

  constructor(private http: HttpClient) { }

  getLookupLists(list: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('list', list);

    return this.http.get('api/events/lookuplists', {params});
  }

  getDashboard(charts: string, dateFrom: string, dateTo: string, cumulative: string, grouping: string, weekly: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', charts);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('cumulative', cumulative);
    params = params.append('grouping', grouping);
    params = params.append('weekly', weekly);

    return this.http.get('api/events/dashboard', {params});
  }

  getDashboardSingle(chart: string, dateFrom: string, dateTo: string, ignoreDateRange: number, grouping: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', chart);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('ignoreDateRange', ignoreDateRange.toString());
    params = params.append('grouping', grouping);

    return this.http.get('api/events/dashboardsingle', {params});
  }

  getPatients(page?: number, size?: number, name?: string, chartName?: string, seriesName?: string, grouping?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('name', name);
    params = params.append('chartName', chartName);
    params = params.append('seriesName', seriesName);
    params = params.append('grouping', grouping);

    return this.http.get('api/events/patients', {params});
  }

  getDashboardLibrary(page?: number, size?: number, selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/dashboardlibrary', {params});
  }

  getValueSetLibrary(page?: number, size?: number, selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/valuesetlibrary', {params});
  }

  getValueSetCodes(page?: number, size?: number, value_set_id?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('value_set_id', value_set_id);

    return this.http.get('api/events/valuesetcode', {params});
  }

  getQueryLibrary(page?: number, size?: number, selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
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

  saveQuery(type?: string, name?: string, id?: string, jsonQuery?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('name', name);
    params = params.append('id', id);
    params = params.append('jsonQuery', jsonQuery);

    return this.http.get('api/events/queryeditor', {params});
  }

  deleteQuery(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/querydelete', {params});
  }

  saveDashboard(type?: string, name?: string, dashboardId?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('name', name);
    params = params.append('dashboardId', dashboardId);

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

  saveValueSetCode(type?: string, code?: string, term?: string, snomed?: string, value_set_id?: string, id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
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

  getRegistries(page: number, size: number, selectedCCGString: string, selectedRegistryString: string, odsCode: string, parentRegistry: string, practice: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('selectedCCGString', selectedCCGString);
    params = params.append('selectedRegistryString', selectedRegistryString);
    params = params.append('odsCode', odsCode);
    params = params.append('parentRegistry', parentRegistry);
    params = params.append('practice', practice);

    return this.http.get('api/events/registries', {params});
  }

  getOrganisationGroups(page?: number, size?: number, selectedTypeString?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/organisationgroups', {params});
  }

  getOrganisationGroupsCodes(page?: number, size?: number, organisation_group_id?: string): Observable<any> {

    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('organisation_group_id', organisation_group_id);

    return this.http.get('api/events/organisationgroupscodes', {params});
  }

  saveOrganisationGroup(type?: string, name?: string, id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('type', type);
    params = params.append('name', name);
    params = params.append('id', id);

    return this.http.get('api/events/organisationgroupeditor', {params});
  }

  deleteOrganisationGroup(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/organisationgroupdelete', {params});
  }

  saveOrganisationGroupCode(name?: string, type?: string, code?: string, organisation_group_id?: string, id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('name', name);
    params = params.append('type', type);
    params = params.append('code', code);
    params = params.append('organisation_group_id', organisation_group_id);
    params = params.append('id', id);

    return this.http.get('api/events/organisationgroupscodeeditor', {params});
  }

  deleteOrganisationGroupCode(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/organisationgroupscodedelete', {params});
  }

  duplicateOrganisationGroup(id?: string): Observable<any> {
    let params = new HttpParams();
    params = params.append('id', id);

    return this.http.get('api/events/organisationgroupduplicate', {params});
  }

}
