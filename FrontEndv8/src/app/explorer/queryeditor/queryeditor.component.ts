import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';

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

interface registration {
  regValue: string;
}

interface gender {
  genValue: string;
}

interface aggregate {
  aggValue: string;
}

interface event {
  eventValue: string;
}

interface organisation {
  orgValue: string;
}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './queryeditor.component.html',
  styleUrls: ['./queryeditor.component.scss']
})

export class QueryEditorComponent {
  type: string = '';
  name: string = '';
  selectedSource: string = '';
  active: boolean = true;
  selectedValue: string = '';
  dateFrom: string = this.formatDate(new Date());
  dateTo: string = this.formatDate(new Date());
  selectedRegistration: string = '';
  ageFrom: string = '';
  ageTo: string = '';
  selectedGender: string = '';
  postcode: string = '';
  selectedAggregate: string = '';
  selectedEvent: string = '';

  selectedOrganisation: string = '';
  orgList = new FormControl();
  selectedOrganisationString: string = '';

  disableForm: boolean;
  id: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  thirdFormGroup: FormGroup;
  fourthFormGroup: FormGroup;
  selectAll: boolean = true;

  sources: source[] = [
    {value: 'Clinical events'},
    {value: 'Medication'},
    {value: 'Encounters'},
    {value: 'Appointments'}
  ];
  values: value[] = [
    {valueSet: 'Diabetes'},
    {valueSet: 'Asthma'},
    {valueSet: 'COPD'},
    {valueSet: 'Atrial Fibrillation'},
    {valueSet: 'CKD'}
  ];
  organisations: organisation[] = [
    {orgValue: 'HS Waltham Forest CCG'},
    {orgValue: 'NHS Tower Hamlets CCG'},
    {orgValue: 'NHS Newham CCG'},
    {orgValue: 'NHS City and Hackney CCG'},
    {orgValue: 'NHS Havering CCG'},
    {orgValue: 'NHS BARKING AND DAGENHAM CCG'},
    {orgValue: 'NHS Redbridge CCG'}
  ];
  registrations: registration[] = [
    {regValue: 'Currently registered patients'},
    {regValue: 'All patients included left and deads'}
  ];
  genders: gender[] = [
    {genValue: 'Male'},
    {genValue: 'Female'},
    {genValue: 'Other'}
  ];
  aggregates: aggregate[] = [
    {aggValue: 'Organisational grouping'},
    {aggValue: 'Date range'},
    {aggValue: 'High level postcodes'},
    {aggValue: 'Age'}
  ];
  events: event[] = [
    {eventValue: 'Patient ID'},
    {eventValue: 'Patient NHS number'},
    {eventValue: 'Effective date'},
    {eventValue: 'Concept'},
    {eventValue: 'Owning organisation'},
    {eventValue: 'Numeric value'},
    {eventValue: 'Postcode'},
    {eventValue: 'Age'},
    {eventValue: 'Gender'},
    {eventValue: 'Registered organisation'},
    {eventValue: 'Death status'}
  ];

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
    this.fourthFormGroup = this._formBuilder.group({
      fourthCtrl: ['', Validators.required]
    });
  }

  saveQuery() {
    this.explorerService.saveQuery(this.type, this.name, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This query could not be saved.')
      );

    console.log("Provider organisation: " + this.selectedOrganisation);
    console.log("Patient GP registration status: " + this.selectedRegistration);
    console.log("Age from: " + this.ageFrom);
    console.log("Age to: " + this.ageTo);
    console.log("Gender: " + this.selectedGender);
    console.log("Postcode: " + this.postcode);
    console.log("Value set: " + this.selectedValue);
    console.log("Event type: " + this.selectedSource);
    console.log("Active: " + this.active);
    console.log("Date from: " + this.formatDate(this.dateFrom));
    console.log("Date to: " + this.formatDate(this.dateTo));
    console.log("Aggregate output: " + this.selectedAggregate);
    console.log("Event level output: " + this.selectedEvent);
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

  toggleSelection() {
    if (this.selectedOrganisation == "" && this.selectAll) {
      this.orgList = new FormControl(this.organisations);
      this.selectedOrganisationString = this.organisations.toString();
    } else {
      this.orgList = new FormControl([]);
    }
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined || this.selectedOrganisation=='' || this.selectedOrganisation==undefined || this.selectedRegistration=='' || this.selectedRegistration==undefined || this.selectedValue=='' || this.selectedValue==undefined || this.selectedEvent=='' || this.selectedEvent==undefined || this.selectedSource=='' || this.selectedSource==undefined;
  }

}
