import { NgModule, DoBootstrap, ApplicationRef } from '@angular/core';
import { KeycloakAngularModule, KeycloakService } from 'keycloak-angular';
import {AppMenuService} from './app-menu.service';
import {RouterModule} from '@angular/router';
import {ExplorerModule} from './explorer/explorer.module';
import {HttpClientModule} from '@angular/common/http';
import {
  AbstractMenuProvider,
  LayoutComponent,
  LayoutModule,
  LoggerModule,
  MessageBoxDialogComponent,
  SecurityModule,
  UserManagerModule
} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {MAT_DATE_LOCALE} from "@angular/material/core";

const keycloakService = new KeycloakService();

@NgModule({
  declarations: [
    MessageBoxDialogComponent
  ],
  imports: [
    KeycloakAngularModule,
    HttpClientModule,
    LayoutModule,
    SecurityModule,
    LoggerModule,
    UserManagerModule,
    ExplorerModule,
    NgxChartsModule,
    RouterModule.forRoot(AppMenuService.getRoutes(), {useHash: true}),
  ],
  entryComponents: [
    MessageBoxDialogComponent
  ],
  providers: [
    { provide: AbstractMenuProvider, useClass : AppMenuService },
    { provide: KeycloakService, useValue: keycloakService },
    { provide: MAT_DATE_LOCALE, useValue: 'en-GB' }
  ]
})
export class AppModule implements DoBootstrap {
  ngDoBootstrap(appRef: ApplicationRef) {
    keycloakService
      .init({config: 'public/wellknown/authconfigraw', initOptions: {onLoad: 'login-required'}})
      .then((authenticated) => {
        if (authenticated)
          appRef.bootstrap(LayoutComponent);
      })
      .catch(error => console.error('[ngDoBootstrap] init Keycloak failed', error));
  }
}
