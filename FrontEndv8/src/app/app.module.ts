import { NgModule, DoBootstrap, ApplicationRef } from '@angular/core';
import { KeycloakAngularModule, KeycloakService } from 'keycloak-angular';
import { AppMenuService } from './app-menu.service';
import { RouterModule } from '@angular/router';
import { ExplorerModule } from './explorer/explorer.module';
import { HttpClientModule } from '@angular/common/http';
import { AbstractMenuProvider, LayoutComponent, LayoutModule, LoggerModule, SecurityModule, UserManagerModule, GenericTableModule } from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MAT_DATE_LOCALE } from "@angular/material/core";
import { GaugeModule } from 'angular-gauge';
import { CookieService } from "ngx-cookie-service";

const keycloakService = new KeycloakService();

@NgModule({
  imports: [
    KeycloakAngularModule,
    HttpClientModule,
    LayoutModule,
    SecurityModule,
    LoggerModule,
    UserManagerModule,
    GenericTableModule,
    ExplorerModule,
    NgxChartsModule,
    GaugeModule.forRoot(),
    RouterModule.forRoot(AppMenuService.getRoutes(), {useHash: true}),
  ],
  providers: [
    { provide: AbstractMenuProvider, useClass : AppMenuService },
    { provide: KeycloakService, useValue: keycloakService },
    { provide: MAT_DATE_LOCALE, useValue: 'en-GB' },
    CookieService
  ]
})
export class AppModule implements DoBootstrap {
  ngDoBootstrap(appRef: ApplicationRef) {
    keycloakService
      .init({config: 'public/wellknown/authconfigraw', initOptions: {onLoad: 'login-required', 'checkLoginIframe': false}})
      .then((authenticated) => {
        if (authenticated)
          appRef.bootstrap(LayoutComponent);
      })
      .catch(error => console.error('[ngDoBootstrap] init Keycloak failed', error));
  }
}
