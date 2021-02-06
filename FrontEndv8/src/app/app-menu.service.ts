import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardLibraryComponent} from "./explorer/dashboardlibrary/dashboardlibrary.component";
import {QueryLibraryComponent} from "./explorer/querylibrary/querylibrary.component";
import {ValueSetLibraryComponent} from "./explorer/valuesetlibrary/valuesetlibrary.component";
import {TutorialsComponent} from "./explorer/tutorials/tutorials.component";
import {RegistriesComponent} from "./explorer/registries/registries.component";
import {OrganisationGroupsComponent} from "./explorer/organisationgroups/organisationgroups.component";
import {DashboardViewerComponent} from "./explorer/dashboardviewer/dashboardviewer.component";
import {MapComponent} from "./explorer/map/map.component";
import {GraphicalComparisonComponent} from "./explorer/graphicalcomparison/graphicalcomparison.component";
import {CovidLibraryComponent} from "./explorer/covidlibrary/covidlibrary.component";
import {CovidViewerComponent} from "./explorer/covidviewer/covidviewer.component";
import {PopulationsComponent} from "./explorer/populations/populations.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/covidlibrary', pathMatch: 'full'},
      {path: 'dashboardviewer', component: DashboardViewerComponent, data: {role: 'explorer'}},
      {path: 'covidviewer', component: CovidViewerComponent, data: {role: 'explorer'}},
      {path: 'registries', component: RegistriesComponent, data: {role: 'explorer'}},
      {path: 'dashboardlibrary', component: DashboardLibraryComponent, data: {role: 'explorer'}},
      {path: 'covidlibrary', component: CovidLibraryComponent, data: {role: 'explorer'}},
      {path: 'querylibrary', component: QueryLibraryComponent, data: {role: 'explorer'}},
      {path: 'valuesetlibrary', component: ValueSetLibraryComponent, data: {role: 'explorer'}},
      {path: 'organisationgroups', component: OrganisationGroupsComponent, data: {role: 'explorer'}},
      {path: 'map', component: MapComponent, data: {role: 'explorer'}},
      {path: 'tutorials', component: TutorialsComponent, data: {role: 'explorer'}},
      {path: 'graphicalcomparison', component: GraphicalComparisonComponent, data: {role: 'explorer'}},
      {path: 'populations', component: PopulationsComponent, data: {role: 'explorer'}}
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
      {icon: 'fas fa-virus', caption: 'Covid library (BETA)', state: 'covidlibrary'},
      {icon: 'fas fa-analytics', caption: 'Dashboard library', state: 'dashboardlibrary'},
      {icon: 'fas fa-map-marked-alt', caption: 'Maps', state: 'map'},
      {icon: 'fas fa-notes-medical', caption: 'Patient registries', state: 'registries'},
      {icon: 'fas fa-file-search', caption: 'Query & data set library', state: 'querylibrary'},
      {icon: 'fas fa-list-ol', caption: 'Value set library', state: 'valuesetlibrary'},
      {icon: 'fas fa-clinic-medical', caption: 'Organisation groups', state: 'organisationgroups'},
      {icon: 'fas fa-users', caption: 'Population counts', state: 'populations'},
      {icon: 'fas fa-video-plus', caption: 'Tutorials', state: 'tutorials'}
    ];
  }
}
