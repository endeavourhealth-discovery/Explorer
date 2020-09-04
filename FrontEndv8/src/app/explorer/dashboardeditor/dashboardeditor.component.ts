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

interface savedQuery {
  selectedQuery: string;
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
  disableForm: boolean;
  dashboardId: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
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
      let query: savedQuery = JSON.parse(data.query);

      this.selectedQuery = query.selectedQuery;
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control3: ['', Validators.required]
    });
  }

  saveDashboard() {
    let query = {
      selectedQuery: this.selectedQuery
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

}
