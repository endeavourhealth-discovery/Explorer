import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";

export interface DialogData {
  id: string;
  name: string;
  type: string;
  query: string;
}

interface savedQuery {
  providerOrganisation: string;
  includedOrganisation: string;
  registrationStatus: string;
  ageFrom: string;
  ageTo: string;
  gender: string;
  postcode: string;
  cohortValue: string;
  datasetValue: string;
  eventType: string;
  active: boolean;
  dateFrom: string;
  dateTo: string;
  aggregateOutput: string;
  eventOutput: string;
  schedule: string;
  delivery: string;
}

interface eventType {
  value: string;
}

interface cohortValueSet {
  cohortValueSet: string;
}

interface datasetValueSet {
  datasetValueSet: string;
}

interface registration {
  regValue: string;
}

interface gender {
  genValue: string;
}

interface schedule {
  scheduleValue: string;
}

interface delivery {
  deliveryValue: string;
}

interface aggregate {
  aggValue: string;
}

interface event {
  eventValue: string;
}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './queryeditor.component.html',
  styleUrls: ['./queryeditor.component.scss'],
  providers: [{
    provide: STEPPER_GLOBAL_OPTIONS, useValue: {showError: true}
  }]
})

export class QueryEditorComponent implements OnInit {
  type: string = '';
  name: string = '';
  selectedEventType: string = '';
  active: boolean = true;
  selectedCohortValueSet: string = '';
  selectedDatasetValueSet: string = '';
  dateFrom: string = this.formatDate(new Date());
  dateTo: string = this.formatDate(new Date());
  selectedRegistration: string = '';
  ageFrom: string = '';
  ageTo: string = '';
  selectedGender: string = '';
  postcode: string = '';
  selectedAggregate: string = '';
  selectedDelivery: string = '';
  selectedSchedule: string = '';
  selectedEvent: string = '';
  selectedOrganisation: string = '';
  selectedIncludedOrganisation: string = '';

  disableForm: boolean;
  id: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  thirdFormGroup: FormGroup;
  fourthFormGroup: FormGroup;

  orgList = [];
  orgIncList = [];
  jsonQuery: string;

  eventTypes: eventType[] = [
    {value: 'Person'},
    {value: 'Clinical events'},
    {value: 'Medication'},
    {value: 'Encounters'}
  ];
  cohortValueSet: cohortValueSet[] = [
    {cohortValueSet: 'All diseases'},
    {cohortValueSet: 'Diabetes'},
    {cohortValueSet: 'Asthma'},
    {cohortValueSet: 'COPD'},
    {cohortValueSet: 'Atrial Fibrillation'},
    {cohortValueSet: 'Hypertension'},
    {cohortValueSet: 'CKD'}
  ];
  datasetValueSet: datasetValueSet[] = [
    {datasetValueSet: 'All diseases'},
    {datasetValueSet: 'Diabetes'},
    {datasetValueSet: 'Asthma'},
    {datasetValueSet: 'COPD'},
    {datasetValueSet: 'Atrial Fibrillation'},
    {datasetValueSet: 'Hypertension'},
    {datasetValueSet: 'CKD'}
  ];

  registrations: registration[] = [
    {regValue: 'Currently registered patients'},
    {regValue: 'All patients included left and deads'}
  ];
  genders: gender[] = [
    {genValue: 'All'},
    {genValue: 'Male'},
    {genValue: 'Female'},
    {genValue: 'Other'}
  ];
  aggregates: aggregate[] = [
    {aggValue: 'Event level'},
    {aggValue: 'Organisational grouping'},
    {aggValue: 'Date range'},
    {aggValue: 'High level post codes'},
    {aggValue: 'Age'}
  ];
  deliveries: delivery[] = [
    {deliveryValue: 'Dashboard'},
    {deliveryValue: 'NHS email'},
    {deliveryValue: 'Encrypted cloud drive'},
    {deliveryValue: 'Secure ftp'}
  ];
  schedules: schedule[] = [
    {scheduleValue: 'Daily'},
    {scheduleValue: 'Weekly'},
    {scheduleValue: 'Monthly'},
    {scheduleValue: 'Quarterly'},
    {scheduleValue: 'One-off'}
  ];
  events: event[] = [
    {eventValue: 'Patient ID'},
    {eventValue: 'Patient NHS number'},
    {eventValue: 'Pseudo NHS number'},
    {eventValue: 'Effective date'},
    {eventValue: 'Concept name'},
    {eventValue: 'Owning organisation'},
    {eventValue: 'Numeric value'},
    {eventValue: 'Post code'},
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

    if (data.query!='') { // edit mode
      let query: savedQuery = JSON.parse(data.query);

      this.selectedOrganisation = query.providerOrganisation;
      this.selectedIncludedOrganisation = query.includedOrganisation;
      this.selectedRegistration = query.registrationStatus;
      this.ageFrom = query.ageFrom;
      this.ageTo = query.ageTo;
      this.selectedGender = query.gender;
      this.postcode = query.postcode;
      this.selectedCohortValueSet = query.cohortValue;
      this.selectedDatasetValueSet = query.datasetValue;
      this.selectedEventType = query.eventType;
      this.active = query.active;
      this.dateFrom = query.dateFrom;
      this.dateTo = query.dateTo;
      this.selectedAggregate = query.aggregateOutput;
      this.selectedEvent = query.eventOutput;
      this.selectedSchedule = query.schedule;
      this.selectedDelivery = query.delivery;
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control17: [''], control3: ['', Validators.required], control4: ['', Validators.required], control5: [''], control6: [''], control7: [''], control8: [''], control9: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({
      control10: ['', Validators.required], control11: [''], control12: [''], control13: [''], control16: ['']
    });
    this.fourthFormGroup = this._formBuilder.group({
      control14: [''], control15: [''], control18: ['', Validators.required], control19: ['', Validators.required]
    });

  }

  ngOnInit() {
    this.explorerService.getLookupLists('3')
      .subscribe(
        (result) => this.loadOrgList(result),
        (error) => this.log.error(error)
      );
  }

  loadOrgList(lists: any) {
    lists.results.map(
      e => {
        this.orgList.push(e.type);
      }
    )
    lists.results.map(
      e => {
        this.orgIncList.push(e.type);
      }
    )
  }

  saveQuery() {

    let query = {
      providerOrganisation: this.selectedOrganisation,
      includedOrganisation: this.selectedIncludedOrganisation,
      registrationStatus: this.selectedRegistration,
      ageFrom: this.ageFrom,
      ageTo: this.ageTo,
      gender: this.selectedGender,
      postcode: this.postcode,
      cohortValue: this.selectedCohortValueSet,
      datasetValue: this.selectedDatasetValueSet,
      eventType: this.selectedEventType,
      active: this.active,
      dateFrom: this.formatDate(this.dateFrom),
      dateTo: this.formatDate(this.dateTo),
      aggregateOutput: this.selectedAggregate,
      eventOutput: this.selectedEvent,
      schedule: this.selectedSchedule,
      delivery: this.selectedDelivery
    };
    this.jsonQuery = JSON.stringify(query);

    console.log(this.jsonQuery);

    this.explorerService.saveQuery(this.type, this.name, this.id, this.jsonQuery)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This query could not be saved.')
      );

    console.log("Provider organisation: " + this.selectedOrganisation);
    console.log("Included organisation: " + this.selectedIncludedOrganisation);
    console.log("Patient GP registration status: " + this.selectedRegistration);
    console.log("Age from: " + this.ageFrom);
    console.log("Age to: " + this.ageTo);
    console.log("Gender: " + this.selectedGender);
    console.log("Postcode: " + this.postcode);
    console.log("Cohort value set: " + this.selectedCohortValueSet);
    console.log("Dataset value set: " + this.selectedDatasetValueSet);
    console.log("Event type: " + this.selectedEventType);
    console.log("Active: " + this.active);
    console.log("Date from: " + this.formatDate(this.dateFrom));
    console.log("Date to: " + this.formatDate(this.dateTo));
    console.log("Aggregate output: " + this.selectedAggregate);
    console.log("Event level output: " + this.selectedEvent);
    console.log("Schedule: " + this.selectedSchedule);
    console.log("Delivery: " + this.selectedDelivery);

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


  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined || this.selectedOrganisation=='' || this.selectedOrganisation==undefined ||
      this.selectedRegistration=='' || this.selectedRegistration==undefined || this.selectedEventType=='' || this.selectedEventType==undefined
    || this.selectedDelivery=='' || this.selectedDelivery==undefined || this.selectedSchedule=='' || this.selectedSchedule==undefined ||
      ( (this.selectedEvent=='' || this.selectedEvent==undefined) &&  (this.selectedAggregate=='' || this.selectedAggregate==undefined) );
  }


}
