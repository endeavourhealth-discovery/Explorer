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
import {CoreModule, MessageBoxDialogComponent} from 'dds-angular8';
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
import {ValueSetComponent} from "./valueset/valueset.component";
import {TutorialsComponent} from "./tutorials/tutorials.component";
import {ValueSetEditorComponent} from "./valueseteditor/valueseteditor.component";
import {ValueSetDeleteComponent} from "./valuesetdelete/valuesetdelete.component";

@NgModule({
  declarations: [
    DashboardComponent,
    PatientComponent,
    DashboardLibraryComponent,
    QueryLibraryComponent,
    ValueSetLibraryComponent,
    ValueSetComponent,
    TutorialsComponent,
    ValueSetEditorComponent,
    ValueSetDeleteComponent,
    MessageBoxDialogComponent
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
        ReactiveFormsModule
    ],
  entryComponents: [
    PatientComponent,
    ValueSetComponent,
    ValueSetEditorComponent,
    ValueSetDeleteComponent,
    MessageBoxDialogComponent
  ],
  providers: [ Globals ]
})
export class ExplorerModule { }
