import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';

export interface DialogData {
  id: string;
  name: string;
  type: string;
  value: string;
  active: boolean;
  valueSet: string;
}

interface source {
  value: string;
}

interface value {
  valueSet: string;
}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './queryeditor.component.html',
  styleUrls: ['./queryeditor.component.scss']
})

export class QueryEditorComponent {
  type: string;
  name: string;
  sources: source[] = [
    {value: 'Patients'},
    {value: 'Clinical events'},
    {value: 'Medication'},
    {value: 'Encounters'},
    {value: 'Appointments'}
  ];
  selectedSource: string;
  active: boolean;
  values: value[] = [
    {valueSet: 'Diabetes'},
    {valueSet: 'Asthma'},
    {valueSet: 'COPD'},
    {valueSet: 'Atrial Fibrillation'},
    {valueSet: 'CKD'}
  ];
  selectedValue: string;
  dateFrom: string = this.formatDate(new Date());
  dateTo: string = this.formatDate(new Date());

  disableForm: boolean;
  id: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  thirdFormGroup: FormGroup;

  constructor(
    public dialogRef: MatDialogRef<QueryEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private _formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.type = data.type;
    this.selectedSource = data.value;
    this.active = data.active;
    this.selectedValue = data.valueSet;

    this.firstFormGroup = this._formBuilder.group({
      firstCtrl: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      secondCtrl: ['', Validators.required]
    });
    this.thirdFormGroup = this._formBuilder.group({
      thirdCtrl: ['', Validators.required]
    });
  }


  saveQuery() {
    this.explorerService.saveQuery(this.type, this.name, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This query could not be saved.')
      );
    console.log("Date from: " + this.formatDate(this.dateFrom));
    console.log("Date to: " + this.formatDate(this.dateTo));
  }

  queryEntered(event) {

    if (event.key === "Enter") {
      this.saveQuery();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2)
      month = '0' + month;
    if (day.length < 2)
      day = '0' + day;

    return [year, month, day].join('-');
  }

}
