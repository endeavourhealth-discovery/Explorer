import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardComponent} from "./explorer/dashboard/dashboard.component";
import {DashboardLibraryComponent} from "./explorer/dashboardlibrary/dashboardlibrary.component";
import {QueryLibraryComponent} from "./explorer/querylibrary/querylibrary.component";
import {ValueSetLibraryComponent} from "./explorer/valuesetlibrary/valuesetlibrary.component";
import {TutorialsComponent} from "./explorer/tutorials/tutorials.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/dashboardlibrary', pathMatch: 'full'},
      {path: 'dashboard', component: DashboardComponent, data: {role: 'explorer', chartType: 'name'}},
      {path: 'dashboardlibrary', component: DashboardLibraryComponent, data: {role: 'explorer'}},
      {path: 'querylibrary', component: QueryLibraryComponent, data: {role: 'explorer'}},
      {path: 'valuesetlibrary', component: ValueSetLibraryComponent, data: {role: 'explorer'}},
      {path: 'tutorials', component: TutorialsComponent, data: {role: 'explorer'}}
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
      {icon: 'fas fa-analytics', caption: 'Dashboard library', state: 'dashboardlibrary'},
      {icon: 'fas fa-file-search', caption: 'Query library', state: 'querylibrary'},
      {icon: 'fas fa-list-ol', caption: 'Value sets', state: 'valuesetlibrary'},
      {icon: 'fas fa-video-plus', caption: 'Tutorials', state: 'tutorials'}
    ];
  }
}
