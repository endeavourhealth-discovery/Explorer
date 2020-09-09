import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";

export interface DialogData {
  dashboardId: string;
  name: string;
  type: string;
  query: string;
}

interface query {
  outputType: string;
  outputField: string;
  schedule: string;
}

interface savedDashboard {
  selectedQuery: string;
  selectedOutputField: string;
  selectedOutputType: string;
  selectedSchedule: string;
  visualType: string;
}

interface outputType {
  outputType: string;
}

interface outputField {
  outputField: string;
}

interface schedule {
  scheduleValue: string;
}

@Component({
  selector: 'app-dashboardeditor',
  templateUrl: './dashboardeditor.component.html',
  styleUrls: ['./dashboardeditor.component.scss'],
  providers: [{
    provide: STEPPER_GLOBAL_OPTIONS, useValue: {showError: true}
  }]
})

export class DashboardEditorComponent {
  type: string;
  name: string;
  queryList = [];
  selectedQuery: string = '';
  selectedOutputField: string = '';
  selectedOutputType: string = '';
  selectedSchedule: string = '';
  visualType: string = '';
  disableForm: boolean;
  dashboardId: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  jsonQuery: string;

  outputTypes: outputType[] = [
    {outputType: 'Rows in tables'},
    {outputType: 'Organisational grouping'},
    {outputType: 'Timeline'},
    {outputType: 'Geospatial grouping'},
    {outputType: 'Age bands'},
    {outputType: 'Ethnic grouping'}
  ];

  outputFields: outputField[] = [
    {outputField: 'Patient ID'},
    {outputField: 'Patient NHS number'},
    {outputField: 'Pseudo NHS number'},
    {outputField: 'Effective date'},
    {outputField: 'Concept name'},
    {outputField: 'Owning organisation'},
    {outputField: 'Numeric value'},
    {outputField: 'Post code'},
    {outputField: 'Age'},
    {outputField: 'Gender'},
    {outputField: 'Registered organisation'},
    {outputField: 'Death status'}
  ];

  schedules: schedule[] = [
    {scheduleValue: 'Daily'},
    {scheduleValue: 'Weekly'},
    {scheduleValue: 'Monthly'},
    {scheduleValue: 'Quarterly'},
    {scheduleValue: 'One-off'}
  ];

  constructor(
    public dialogRef: MatDialogRef<DashboardEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private _formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.dashboardId = data.dashboardId;
    this.name = data.name;
    this.type = data.type;

    if (data.query!='') { // edit mode
      let query: savedDashboard = JSON.parse(data.query);

      this.selectedQuery = query.selectedQuery;
      this.selectedOutputField = query.selectedOutputField;
      this.selectedOutputType = query.selectedOutputType;
      this.selectedSchedule = query.selectedSchedule;
      this.visualType = query.visualType;
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control3: ['', Validators.required], control4: [''], control5: [''], control6: [''], control7: ['']
    });
  }

  saveDashboard() {
    let query = {
      selectedQuery: this.selectedQuery,
      selectedOutputField: this.selectedOutputField,
      selectedOutputType: this.selectedOutputType,
      selectedSchedule: this.selectedSchedule,
      visualType: this.visualType
    };
    this.jsonQuery = JSON.stringify(query);

    this.explorerService.saveDashboard(this.type, this.name, this.dashboardId, this.jsonQuery)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This dashboard could not be saved.')
      );
  }

  dashboardEntered(event) {
    if (event.key === "Enter") {
      this.saveDashboard();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined || this.selectedQuery=='' || this.selectedQuery==undefined;
  }

  ngOnInit() {
    this.explorerService.getLookupLists('11')
      .subscribe(
        (result) => this.loadQueryList(result),
        (error) => this.log.error(error)
      );
  }

  loadQueryList(lists: any) {
    lists.results.map(
      e => {
        this.queryList.push(e.type);
      }
    )
  }

  querySelected() {
    this.explorerService.getQuery(this.selectedQuery)
      .subscribe(
        (result) => this.loadQuery(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.selectedOutputField =  query.outputField;
        this.selectedOutputType = query.outputType;
        this.selectedSchedule = query.schedule;
      }
    )
    this.ngOnInit();
  }

}
