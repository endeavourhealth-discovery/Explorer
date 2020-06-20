import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardComponent} from "./explorer/dashboard/dashboard.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/nhs111', pathMatch: 'full'},
      {path: 'nhs111', component: DashboardComponent, data: {role: 'explorer', chartType: 'nhs111'}},
      {path: 'consultations', component: DashboardComponent, data: {role: 'explorer', chartType: 'consultations'}},
      {path: 'hospital', component: DashboardComponent, data: {role: 'explorer', chartType: 'hospital'}},
      {path: 'covid', component: DashboardComponent, data: {role: 'explorer', chartType: 'covid'}},
      {path: 'covid_deceased_age', component: DashboardComponent, data: {role: 'explorer', chartType: 'covid_deceased_age'}},
      {path: 'covid_deceased_daily', component: DashboardComponent, data: {role: 'explorer', chartType: 'covid_deceased_daily'}},
      {path: 'covid_deceased_ccg', component: DashboardComponent, data: {role: 'explorer', chartType: 'covid_deceased_ccg'}}
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
      {icon: 'fas fa-analytics', caption: 'Covid Trend Dashboard', state: 'covid'},
      {icon: 'fas fa-user-friends', caption: 'Covid Age Deceased Dashboard', state: 'covid_deceased_age'},
      {icon: 'fas fa-calendar-alt', caption: 'Covid Daily Deceased Dashboard', state: 'covid_deceased_daily'},
      {icon: 'fas fa-home-alt', caption: 'Covid CCG Deceased Dashboard', state: 'covid_deceased_ccg'},
      {icon: 'fas fa-analytics', caption: 'NHS111 Dashboard', state: 'nhs111'},
      {icon: 'fas fa-users-medical', caption: 'Consultations Dashboard', state: 'consultations'},
      {icon: 'fas fa-hospital-user', caption: 'Hospital Encounter Dashboard', state: 'hospital'}

    ];
  }
}
