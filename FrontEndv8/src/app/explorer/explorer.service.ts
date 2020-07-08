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

  getDashboard(charts: string, dateFrom: string, dateTo: string, accumulative: string): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', charts);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('accumulative', accumulative);
    return this.http.get('api/events/dashboard', {params});
  }

  getDashboardSingle(chart: string, dateFrom: string, dateTo: string, ignoreDateRange: number): Observable<any> {
    let params = new HttpParams();

    params = params.append('chartName', chart);
    params = params.append('dateFrom', dateFrom);
    params = params.append('dateTo', dateTo);
    params = params.append('ignoreDateRange', ignoreDateRange.toString());

    return this.http.get('api/events/dashboardsingle', {params});
  }

  getPatients(page?: number, size?: number, name?: string, chartName?: string, seriesName?: string): Observable<any> {
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());
    params = params.append('name', name);
    params = params.append('chartName', chartName);
    params = params.append('seriesName', seriesName);

    return this.http.get('api/events/patients', {params});
  }

  getDashboardLibrary(page?: number, size?: number): Observable<any> {
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());

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

  getQueryLibrary(page?: number, size?: number): Observable<any> {
    console.log("page: "+page+", size: "+size);
    let params = new HttpParams();
    params = params.append('page', page.toString());
    params = params.append('size', size.toString());

    return this.http.get('api/events/querylibrary', {params});
  }

}
