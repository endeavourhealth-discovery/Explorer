import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";
import {CdkDragDrop, transferArrayItem} from "@angular/cdk/drag-drop";

export interface DialogData {
  dashboardId: string;
  name: string;
  type: string;
  query: string;
}

interface query {
  query: string;
  outputType: string;
  outputField: string;
  schedule: string;
}

interface widget {
  icon: string;
  name: string;
}

interface savedDashboard {
  selectedQuery1: string;
  selectedOutputField1: string;
  selectedOutputType1: string;
  selectedSchedule1: string;
  selectedSeries1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;

  selectedQuery2: string;
  selectedOutputField2: string;
  selectedOutputType2: string;
  selectedSchedule2: string;
  selectedSeries2: string;
  xAxisLabel2: string;
  yAxisLabel2: string;

  selectedQuery3: string;
  selectedOutputField3: string;
  selectedOutputType3: string;
  selectedSchedule3: string;
  selectedSeries3: string;
  xAxisLabel3: string;
  yAxisLabel3: string;

  selectedQuery4: string;
  selectedOutputField4: string;
  selectedOutputType4: string;
  selectedSchedule4: string;
  selectedSeries4: string;
  xAxisLabel4: string;
  yAxisLabel4: string;

  visualType: widget[];
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
  seriesList = [];

  selectedQuery1: string = '';
  selectedOutputField1: string = '';
  selectedOutputType1: string = '';
  selectedSchedule1: string = '';
  selectedSeries1: string = '';
  xAxisLabel1: string = '';
  yAxisLabel1: string = '';

  selectedQuery2: string = '';
  selectedOutputField2: string = '';
  selectedOutputType2: string = '';
  selectedSchedule2: string = '';
  selectedSeries2: string = '';
  xAxisLabel2: string = '';
  yAxisLabel2: string = '';

  selectedQuery3: string = '';
  selectedOutputField3: string = '';
  selectedOutputType3: string = '';
  selectedSchedule3: string = '';
  selectedSeries3: string = '';
  xAxisLabel3: string = '';
  yAxisLabel3: string = '';

  selectedQuery4: string = '';
  selectedOutputField4: string = '';
  selectedOutputType4: string = '';
  selectedSchedule4: string = '';
  selectedSeries4: string = '';
  xAxisLabel4: string = '';
  yAxisLabel4: string = '';

  selectedWidgets : widget[] = [
  ];
  disableForm: boolean;
  dashboardId: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  thirdFormGroup: FormGroup;
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

      this.selectedQuery1 = query.selectedQuery1;
      this.selectedOutputField1 = query.selectedOutputField1;
      this.selectedOutputType1 = query.selectedOutputType1;
      this.selectedSchedule1 = query.selectedSchedule1;
      this.selectedSeries1 = query.selectedSeries1;
      this.xAxisLabel1 = query.xAxisLabel1;
      this.yAxisLabel1 = query.yAxisLabel1;

      this.selectedQuery2 = query.selectedQuery2;
      this.selectedOutputField2 = query.selectedOutputField2;
      this.selectedOutputType2 = query.selectedOutputType2;
      this.selectedSchedule2 = query.selectedSchedule2;
      this.selectedSeries2 = query.selectedSeries2;
      this.xAxisLabel2 = query.xAxisLabel2;
      this.yAxisLabel2 = query.yAxisLabel2;

      this.selectedQuery3 = query.selectedQuery3;
      this.selectedOutputField3 = query.selectedOutputField3;
      this.selectedOutputType3 = query.selectedOutputType3;
      this.selectedSchedule3 = query.selectedSchedule3;
      this.selectedSeries3 = query.selectedSeries3;
      this.xAxisLabel3 = query.xAxisLabel3;
      this.yAxisLabel3 = query.yAxisLabel3;

      this.selectedQuery4 = query.selectedQuery4;
      this.selectedOutputField4 = query.selectedOutputField4;
      this.selectedOutputType4 = query.selectedOutputType4;
      this.selectedSchedule4 = query.selectedSchedule4;
      this.selectedSeries4 = query.selectedSeries4;
      this.xAxisLabel4 = query.xAxisLabel4;
      this.yAxisLabel4 = query.yAxisLabel4;

      this.selectedWidgets = query.visualType;
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control3a: ['', Validators.required], control4a: [''], control5a: [''], control6a: [''], control7a: [''], control8a: [''], control9a: [''],
      control3b: [''], control4b: [''], control5b: [''], control6b: [''], control7b: [''], control8b: [''], control9b: [''],
      control3c: [''], control4c: [''], control5c: [''], control6c: [''], control7c: [''], control8c: [''], control9c: [''],
      control3d: [''], control4d: [''], control5d: [''], control6d: [''], control7d: [''], control8d: [''], control9d: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({

    });
  }

  saveDashboard() {
    let query = {
      selectedQuery1: this.selectedQuery1,
      selectedOutputField1: this.selectedOutputField1,
      selectedOutputType1: this.selectedOutputType1,
      selectedSchedule1: this.selectedSchedule1,
      selectedSeries1: this.selectedSeries1,
      xAxisLabel1: this.xAxisLabel1,
      yAxisLabel1: this.yAxisLabel1,

      selectedQuery2: this.selectedQuery2,
      selectedOutputField2: this.selectedOutputField2,
      selectedOutputType2: this.selectedOutputType2,
      selectedSchedule2: this.selectedSchedule2,
      selectedSeries2: this.selectedSeries2,
      xAxisLabel2: this.xAxisLabel2,
      yAxisLabel2: this.yAxisLabel2,

      selectedQuery3: this.selectedQuery3,
      selectedOutputField3: this.selectedOutputField3,
      selectedOutputType3: this.selectedOutputType3,
      selectedSchedule3: this.selectedSchedule3,
      selectedSeries3: this.selectedSeries3,
      xAxisLabel3: this.xAxisLabel3,
      yAxisLabel3: this.yAxisLabel3,

      selectedQuery4: this.selectedQuery4,
      selectedOutputField4: this.selectedOutputField4,
      selectedOutputType4: this.selectedOutputType4,
      selectedSchedule4: this.selectedSchedule4,
      selectedSeries4: this.selectedSeries4,
      xAxisLabel4: this.xAxisLabel4,
      yAxisLabel4: this.yAxisLabel4,

      visualType: this.selectedWidgets
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
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined || this.selectedQuery1=='' || this.selectedQuery1==undefined;
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

    this.explorerService.getLookupLists('12')
      .subscribe(
        (result) => this.loadSeriesList(result),
        (error) => this.log.error(error)
      );
  }

  loadSeriesList(lists: any) {
    lists.results.map(
      e => {
        this.seriesList.push(e.type);
      }
    )
  }

  getSelectedQuery(i) {
    if (i==0)
      return this.selectedQuery1;
    else if (i==1)
      return this.selectedQuery2;
    else if (i==2)
      return this.selectedQuery3;
    else if (i==3)
      return this.selectedQuery4;
  }

  querySelected1() {
    this.explorerService.getQuery(this.selectedQuery1)
      .subscribe(
        (result) => this.loadQuery1(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery1(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.selectedOutputField1 =  query.outputField;
        this.selectedOutputType1 = query.outputType;
        this.selectedSchedule1 = query.schedule;
      }
    )
    //this.ngOnInit();
  }

  querySelected2() {
    this.explorerService.getQuery(this.selectedQuery2)
      .subscribe(
        (result) => this.loadQuery2(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery2(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.selectedOutputField2 =  query.outputField;
        this.selectedOutputType2 = query.outputType;
        this.selectedSchedule2 = query.schedule;
      }
    )
    //this.ngOnInit();
  }

  querySelected3() {
    this.explorerService.getQuery(this.selectedQuery3)
      .subscribe(
        (result) => this.loadQuery3(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery3(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.selectedOutputField3 =  query.outputField;
        this.selectedOutputType3 = query.outputType;
        this.selectedSchedule3 = query.schedule;
      }
    )
    //this.ngOnInit();
  }

  querySelected4() {
    this.explorerService.getQuery(this.selectedQuery4)
      .subscribe(
        (result) => this.loadQuery4(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery4(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.selectedOutputField4 =  query.outputField;
        this.selectedOutputType4 = query.outputType;
        this.selectedSchedule4 = query.schedule;
      }
    )
    //this.ngOnInit();
  }

  widgets : widget[] = [
    {icon: "fad fa-chart-bar", name: 'Bar chart'},
    {icon: "fad fa-chart-line", name: 'Line chart'},
    {icon: "fal fa-table", name: 'Table'},
    {icon: "fad fa-spinner-third", name: 'Gauge'},
    {icon: "fad fa-flag", name: 'Indicator'},
    {icon: "fad fa-globe-africa", name: 'Map'}
  ];

  drop(event: CdkDragDrop<widget[]>) {
    transferArrayItem(event.previousContainer.data,
      event.container.data,
      event.previousIndex,
      event.currentIndex);

    this.widgets = [
      {icon: "fad fa-chart-bar", name: 'Bar chart'},
      {icon: "fad fa-chart-line", name: 'Line chart'},
      {icon: "fal fa-table", name: 'Table'},
      {icon: "fad fa-spinner-third", name: 'Gauge'},
      {icon: "fad fa-flag", name: 'Indicator'},
      {icon: "fad fa-globe-africa", name: 'Map'}
    ];
  }

}
