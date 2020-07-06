import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardComponent} from "./explorer/dashboard/dashboard.component";
import {DashboardLibraryComponent} from "./explorer/dashboardlibrary/dashboardlibrary.component";
import {QueryLibraryComponent} from "./explorer/querylibrary/querylibrary.component";
import {ValueSetLibraryComponent} from "./explorer/valuesetlibrary/valuesetlibrary.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/dashboardlibrary', pathMatch: 'full'},
      {path: 'dashboard', component: DashboardComponent, data: {role: 'explorer', chartType: 'name'}},
      {path: 'dashboardlibrary', component: DashboardLibraryComponent, data: {role: 'explorer'}},
      {path: 'querylibrary', component: QueryLibraryComponent, data: {role: 'explorer'}},
      {path: 'valuesetlibrary', component: ValueSetLibraryComponent, data: {role: 'explorer'}}
    ];
  }

  getClientId(): string {
    return 'explorer';
  }

  getApplicationTitle(): string {
    return 'Explorer';
  }

  getMenuOptions(): MenuOption[] {
    return [
      {icon: 'fas fa-analytics', caption: 'Dashboard Library', state: 'dashboardlibrary'},
      {icon: 'fas fa-analytics', caption: 'Query Library', state: 'querylibrary'},
      {icon: 'fas fa-analytics', caption: 'Value Sets', state: 'valuesetlibrary'}
    ];
  }
}
