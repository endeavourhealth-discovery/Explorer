import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardLibraryComponent} from "./explorer/dashboardlibrary/dashboardlibrary.component";
import {QueryLibraryComponent} from "./explorer/querylibrary/querylibrary.component";
import {ValueSetLibraryComponent} from "./explorer/valuesetlibrary/valuesetlibrary.component";
import {TutorialsComponent} from "./explorer/tutorials/tutorials.component";
import {RegistriesComponent} from "./explorer/registries/registries.component";
import {DashboardViewerComponent} from "./explorer/dashboardviewer/dashboardviewer.component";
import {MapComponent} from "./explorer/map/map.component";
import {GraphicalComparisonComponent} from "./explorer/graphicalcomparison/graphicalcomparison.component";
import {CovidLibraryComponent} from "./explorer/covidlibrary/covidlibrary.component";
import {CovidViewerComponent} from "./explorer/covidviewer/covidviewer.component";
import {PopulationsComponent} from "./explorer/populations/populations.component";
import {RegistryListsComponent} from "./explorer/registrylists/registrylists.component";
import {QueryQueueComponent} from "./explorer/queryqueue/queryqueue.component";
import {AuditLogComponent} from "./explorer/auditlog/auditlog.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/covidlibrary', pathMatch: 'full'},
      {path: 'dashboardviewer', component: DashboardViewerComponent, data: {role: 'explorer:dashboards'}},
      {path: 'covidviewer', component: CovidViewerComponent, data: {role: 'explorer:covid'}},
      {path: 'registries', component: RegistriesComponent, data: {role: 'explorer:dashboards'}},
      {path: 'dashboardlibrary', component: DashboardLibraryComponent, data: {role: 'explorer:dashboards'}},
      {path: 'covidlibrary', component: CovidLibraryComponent, data: {role: 'explorer:covid'}},
      {path: 'querylibrary', component: QueryLibraryComponent, data: {role: 'explorer:dashboards'}},
      {path: 'valuesetlibrary', component: ValueSetLibraryComponent, data: {role: 'explorer:dashboards'}},
      {path: 'map', component: MapComponent, data: {role: 'explorer:dashboards'}},
      {path: 'tutorials', component: TutorialsComponent, data: {role: 'explorer:dashboards'}},
      {path: 'graphicalcomparison', component: GraphicalComparisonComponent, data: {role: 'explorer:dashboards'}},
      {path: 'populations', component: PopulationsComponent, data: {role: 'explorer:dashboards'}},
      {path: 'registrylists', component: RegistryListsComponent, data: {role: 'explorer:dashboards'}},
      {path: 'queryqueue', component: QueryQueueComponent, data: {role: 'explorer:dashboards'}},
      {path: 'auditlog', component: AuditLogComponent, data: {role: 'explorer:dashboards'}},
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
      {icon: 'fas fa-virus', caption: 'Covid library', state: 'covidlibrary'},
      {icon: 'fas fa-analytics', caption: 'Dashboard library', state: 'dashboardlibrary'},
      {icon: 'fas fa-map-marked-alt', caption: 'Maps', state: 'map'},
      {icon: 'fas fa-poll-people', caption: 'Query results', state: 'registries'},
      {icon: 'fas fa-file-search', caption: 'Query & data set library', state: 'querylibrary'},
      {icon: 'fas fa-clock', caption: 'Query queue', state: 'queryqueue'},
      {icon: 'fas fa-list-ol', caption: 'Value set library', state: 'valuesetlibrary'},
      {icon: 'fas fa-users', caption: 'Population counts', state: 'populations'},
      {icon: 'fas fa-history', caption: 'Audit log', state: 'auditlog'},
      {icon: 'fas fa-video-plus', caption: 'Tutorials', state: 'tutorials'}
    ];
  }
}
