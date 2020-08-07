import { NgModule } from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {
  MatCardModule,
  MatFormFieldModule,
  MatIconModule,
  MatInputModule,
  MatPaginatorModule, MatProgressSpinnerModule,
  MatSortModule,
  MatTableModule
} from '@angular/material';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {RouterModule} from '@angular/router';
import {FlexModule} from '@angular/flex-layout';
import {MatSelectModule} from '@angular/material/select';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatCheckboxModule} from '@angular/material/checkbox';
import {MatMenuModule} from '@angular/material/menu';
import {CoreModule} from 'dds-angular8';
import {MatDialogModule} from '@angular/material/dialog';
import {MatButtonModule} from '@angular/material/button';
import {MatTreeModule} from '@angular/material/tree';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatGridListModule} from "@angular/material/grid-list";
import {MatDatepickerModule} from "@angular/material/datepicker";
import {MatNativeDateModule} from "@angular/material/core";
import {BarChartModule, LineChartModule, AreaChartModule} from "@swimlane/ngx-charts";
import {Globals} from "./globals";
import {DashboardComponent} from "./dashboard/dashboard.component";
import {PatientComponent} from "./patient/patient.component";
import {DashboardLibraryComponent} from "./dashboardlibrary/dashboardlibrary.component";
import {QueryLibraryComponent} from "./querylibrary/querylibrary.component";
import {ValueSetLibraryComponent} from "./valuesetlibrary/valuesetlibrary.component";
import {ValueSetCodeComponent} from "./valuesetcode/valuesetcode.component";
import {TutorialsComponent} from "./tutorials/tutorials.component";
import {ValueSetEditorComponent} from "./valueseteditor/valueseteditor.component";
import {MessageBoxDialogComponent} from "./message-box-dialog/message-box-dialog.component";
import {QueryEditorComponent} from "./queryeditor/queryeditor.component";
import {DashboardEditorComponent} from "./dashboardeditor/dashboardeditor.component";
import {ValueSetCodeEditorComponent} from "./valuesetcodeeditor/valuesetcodeeditor.component";
import {RegistriesComponent} from "./registries/registries.component";
import {RegistryIndicatorsComponent} from "./registryindicators/registryindicators.component";
import {RegistryDashboardComponent} from "./registrydashboard/registrydashboard.component";
import {GaugeModule} from "angular-gauge";
import {MatStepperModule} from "@angular/material/stepper";
import {AdvancedQueryEditorComponent} from "./advancedqueryeditor/advancedqueryeditor.component";

@NgModule({
  declarations: [
    DashboardComponent,
    PatientComponent,
    DashboardLibraryComponent,
    QueryLibraryComponent,
    ValueSetLibraryComponent,
    ValueSetCodeComponent,
    TutorialsComponent,
    ValueSetEditorComponent,
    MessageBoxDialogComponent,
    QueryEditorComponent,
    DashboardEditorComponent,
    ValueSetCodeEditorComponent,
    RegistriesComponent,
    RegistryIndicatorsComponent,
    RegistryDashboardComponent,
    AdvancedQueryEditorComponent
  ],
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        MatCardModule,
        MatTableModule,
        MatSortModule,
        MatFormFieldModule,
        MatInputModule,
        MatIconModule,
        FormsModule,
        MatPaginatorModule,
        MatProgressSpinnerModule,
        RouterModule,
        FlexModule,
        MatSelectModule,
        MatSnackBarModule,
        MatCheckboxModule,
        MatMenuModule,
        MatDialogModule,
        CoreModule,
        MatButtonModule,
        MatTreeModule,
        MatProgressBarModule,
        MatGridListModule,
        MatNativeDateModule,
        MatDatepickerModule,
        BarChartModule,
        LineChartModule,
        AreaChartModule,
        ReactiveFormsModule,
        GaugeModule,
        MatStepperModule
    ],

  entryComponents: [
    PatientComponent,
    ValueSetCodeComponent,
    ValueSetEditorComponent,
    MessageBoxDialogComponent,
    QueryEditorComponent,
    DashboardEditorComponent,
    ValueSetCodeEditorComponent,
    AdvancedQueryEditorComponent
  ],
  providers: [ Globals ]
})
export class ExplorerModule { }
