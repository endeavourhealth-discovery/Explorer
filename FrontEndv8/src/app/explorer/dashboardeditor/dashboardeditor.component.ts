import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormControl, FormGroup, Validators} from "@angular/forms";
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";
import {CdkDragDrop, transferArrayItem} from "@angular/cdk/drag-drop";
import {ReplaySubject, Subject} from "rxjs";
import {takeUntil} from "rxjs/operators";

export interface DialogData {
  dashboardId: string;
  name: string;
  type: string;
  query: string;
}

interface widget {
  icon: string;
  name: string;
}

interface query {
  outputType: string;
  schedule: string;
}

interface savedDashboard {
  selectedVisualisation1: string;
  selectedSeries1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;

  selectedVisualisation2: string;
  selectedSeries2: string;
  xAxisLabel2: string;
  yAxisLabel2: string;

  selectedVisualisation3: string;
  selectedSeries3: string;
  xAxisLabel3: string;
  yAxisLabel3: string;

  selectedVisualisation4: string;
  selectedSeries4: string;
  xAxisLabel4: string;
  yAxisLabel4: string;

  visualType: widget[];
}

interface seriesList {
  value: string;
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
  filterCtrl: FormControl = new FormControl();

  type: string;
  name: string;
  seriesList = [];
  filteredQueryList: ReplaySubject<seriesList[]> = new ReplaySubject<seriesList[]>(1);

  selectedVisualisation1: string = '';
  selectedSeries1: string = '';
  xAxisLabel1: string = '';
  yAxisLabel1: string = '';

  selectedVisualisation2: string = '';
  selectedSeries2: string = '';
  xAxisLabel2: string = '';
  yAxisLabel2: string = '';

  selectedVisualisation3: string = '';
  selectedSeries3: string = '';
  xAxisLabel3: string = '';
  yAxisLabel3: string = '';

  selectedVisualisation4: string = '';
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

      this.selectedVisualisation1 = query.selectedVisualisation1;
      this.selectedSeries1 = query.selectedSeries1;
      this.xAxisLabel1 = query.xAxisLabel1;
      this.yAxisLabel1 = query.yAxisLabel1;

      this.selectedVisualisation2 = query.selectedVisualisation2;
      this.selectedSeries2 = query.selectedSeries2;
      this.xAxisLabel2 = query.xAxisLabel2;
      this.yAxisLabel2 = query.yAxisLabel2;

      this.selectedVisualisation3 = query.selectedVisualisation3;
      this.selectedSeries3 = query.selectedSeries3;
      this.xAxisLabel3 = query.xAxisLabel3;
      this.yAxisLabel3 = query.yAxisLabel3;

      this.selectedVisualisation4 = query.selectedVisualisation4;
      this.selectedSeries4 = query.selectedSeries4;
      this.xAxisLabel4 = query.xAxisLabel4;
      this.yAxisLabel4 = query.yAxisLabel4;

      this.selectedWidgets = query.visualType;
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control3a: ['', Validators.required], control4a: [''], control7a: [''], control8a: [''], control9a: [''],
      control3b: [''], control4b: [''], control7b: [''], control8b: [''], control9b: [''],
      control3c: [''], control4c: [''], control7c: [''], control8c: [''], control9c: [''],
      control3d: [''], control4d: [''], control7d: [''], control8d: [''], control9d: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({

    });
  }

  saveDashboard() {
    let query = {
      selectedVisualisation1: this.selectedVisualisation1,
      selectedSeries1: this.selectedSeries1,
      xAxisLabel1: this.xAxisLabel1,
      yAxisLabel1: this.yAxisLabel1,

      selectedVisualisation2: this.selectedVisualisation2,
      selectedSeries2: this.selectedSeries2,
      xAxisLabel2: this.xAxisLabel2,
      yAxisLabel2: this.yAxisLabel2,

      selectedVisualisation3: this.selectedVisualisation3,
      selectedSeries3: this.selectedSeries3,
      xAxisLabel3: this.xAxisLabel3,
      yAxisLabel3: this.yAxisLabel3,

      selectedVisualisation4: this.selectedVisualisation4,
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
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined || this.selectedVisualisation1=='' || this.selectedVisualisation1==undefined;
  }

  private _onDestroy = new Subject<void>();

  ngOnInit() {
    this.explorerService.getLookupLists('12','')
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

    this.filteredQueryList.next(this.seriesList.slice());

    this.filterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterQueryList();
      });
  }

  filterQueryList() {
    let search = this.filterCtrl.value;

    if (!search) {
      this.filteredQueryList.next(this.seriesList.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredQueryList.next(
      this.seriesList.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  getSelectedVisualisation(i) {
    if (i==0)
      return this.selectedVisualisation1;
    else if (i==1)
      return this.selectedVisualisation2;
    else if (i==2)
      return this.selectedVisualisation3;
    else if (i==3)
      return this.selectedVisualisation4;
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
