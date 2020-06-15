import {Injectable} from '@angular/core';
import {Routes} from '@angular/router';
import {AbstractMenuProvider, MenuOption} from 'dds-angular8';
import {DashboardComponent} from "./explorer/dashboard/dashboard.component";

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      {path: '', redirectTo: '/dashboard', pathMatch: 'full'},
      {path: 'nhs111', component: DashboardComponent, data: {role: 'explorer', chartType: 'nhs111'}},
      {path: 'consultations', component: DashboardComponent, data: {role: 'explorer', chartType: 'consultations'}}
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
      {icon: 'fas fa-analytics', caption: 'NHS111 Dashboard', state: 'nhs111'},
      {icon: 'fas fa-analytics', caption: 'Consultations Dashboard', state: 'consultations'}
    ];
  }
}
