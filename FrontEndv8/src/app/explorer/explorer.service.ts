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

  getDashboard(charts: string, dateFrom: string, dateTo: string, cumulative: string, grouping: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', charts);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('cumulative', cumulative);
    params = params.append('grouping', grouping);

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
    console.log("page: "+page+", size: "+size);
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
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('selectedTypeString', selectedTypeString);

    return this.http.get('api/events/dashboardlibrary', {params});
  }

  getValueSetLibrary(page?: number, size?: number): Observable<any> {
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());

    return this.http.get('api/events/valuesetlibrary', {params});
  }

  getValueSet(page?: number, size?: number, id?: string): Observable<any> {
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('id', id);

    return this.http.get('api/events/valueset', {params});
  }

  getQueryLibrary(page?: number, size?: number, selectedTypeString?: string): Observable<any> {
    console.log("page: "+page+", size: "+size);
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

}
