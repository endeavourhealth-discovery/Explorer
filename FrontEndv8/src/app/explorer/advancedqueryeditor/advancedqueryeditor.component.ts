import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
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
  valueDateFrom: string;
  valueDateTo: string;
  datasetValue: string;
  eventType: string;
  active: boolean;
  dateFrom: string;
  dateTo: string;
  aggregateOutput: string;
  eventOutput: string;
  schedule: string;
  delivery: string;

  includedExclude1: string;
  includedValueSet1: string;
  includedDateFrom1: string;
  includedDateTo1: string;
  includedPeriodValue1: string;
  includedPeriodType1: string;
  includedAnyAll1: string;
  includedExclude1a: string;
  includedValueSet1a: string;
  includedDateFrom1a: string;
  includedDateTo1a: string;
  includedPeriodValue1a: string;
  includedPeriodType1a: string;
  includedAnyAll1a: string;
  includedExclude1b: string;
  includedValueSet1b: string;
  includedDateFrom1b: string;
  includedDateTo1b: string;
  includedPeriodValue1b: string;
  includedPeriodType1b: string;
  includedAnyAll1b: string;
  includedExclude2: string;
  includedValueSet2: string;
  includedEarliestLatest2: string;
  includedOperator2: string;
  includedEntryValue2: string;
  includedAnyAll2: string;
  includedDateFrom2: string;
  includedDateTo2: string;
  includedPeriodValue2: string;
  includedPeriodType2: string;
  includedExclude2a: string;
  includedValueSet2a: string;
  includedEarliestLatest2a: string;
  includedOperator2a: string;
  includedEntryValue2a: string;
  includedAnyAll2a: string;
  includedDateFrom2a: string;
  includedDateTo2a: string;
  includedPeriodValue2a: string;
  includedPeriodType2a: string;
  includedExclude3: string;
  includedValueSet3: string;
  includedEarliestLatest3: string;
  includedTestedValueSet3: string;
  includedAnyAll3: string;
  includedAnyAllTested3: string;
  includedExclude4: string;
  includedValueSet4: string;
  includedFollowedByValueSet4: string;
  includedDateFrom4: string;
  includedDateTo4: string;
  includedPeriodValue4: string;
  includedPeriodType4: string;
  includedAnyAll4: string;
  includedAnyAllFollowedBy4: string;
  includedAreNot4: string;
  includedExclude5: string;
  includedValueSet5: string;
  includedOperator5: string;
  includedEntryValue5: string;
  includedDateFrom5: string;
  includedDateTo5: string;
  includedPeriodValue5: string;
  includedPeriodType5: string;
  includedAnyAll5: string;
}

interface eventType {
  value: string;
}

interface valueSet {
  valueSet: string;
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

interface exclude {
  exclude: string;
}

interface earliestLatest {
  earliestLatest: string;
}

interface operator {
  operator: string;
}

interface period {
  period: string;
}

interface anyAll {
  anyAll: string;
}

interface areNot {
  areNot: string;
}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './advancedqueryeditor.component.html',
  styleUrls: ['./advancedqueryeditor.component.scss'],
  providers: [{
    provide: STEPPER_GLOBAL_OPTIONS, useValue: {showError: true}
  }]
})

export class AdvancedQueryEditorComponent implements OnInit {
  type: string = '';
  name: string = '';
  selectedEventType: string = '';
  active: boolean = true;
  selectedCohortValueSet: string = '';
  valueDateFrom: string = this.formatDate(new Date());
  valueDateTo: string = this.formatDate(new Date());
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

  includedExclude1: string = '';
  includedValueSet1: string = '';
  includedDateFrom1: string = '';
  includedDateTo1: string = '';
  includedPeriodValue1: string = '';
  includedPeriodType1: string = '';
  includedAnyAll1: string = '';
  includedExclude1a: string = '';
  includedValueSet1a: string = '';
  includedDateFrom1a: string = '';
  includedDateTo1a: string = '';
  includedPeriodValue1a: string = '';
  includedPeriodType1a: string = '';
  includedAnyAll1a: string = '';
  includedExclude1b: string = '';
  includedValueSet1b: string = '';
  includedDateFrom1b: string = '';
  includedDateTo1b: string = '';
  includedPeriodValue1b: string = '';
  includedPeriodType1b: string = '';
  includedAnyAll1b: string = '';
  includedExclude2: string = '';
  includedValueSet2: string = '';
  includedEarliestLatest2: string = '';
  includedOperator2: string = '';
  includedEntryValue2: string = '';
  includedAnyAll2: string = '';
  includedDateFrom2: string = '';
  includedDateTo2: string = '';
  includedPeriodValue2: string = '';
  includedPeriodType2: string = '';
  includedExclude2a: string = '';
  includedValueSet2a: string = '';
  includedEarliestLatest2a: string = '';
  includedOperator2a: string = '';
  includedEntryValue2a: string = '';
  includedAnyAll2a: string = '';
  includedDateFrom2a: string = '';
  includedDateTo2a: string = '';
  includedPeriodValue2a: string = '';
  includedPeriodType2a: string = '';
  includedExclude3: string = '';
  includedValueSet3: string = '';
  includedEarliestLatest3: string = '';
  includedTestedValueSet3: string = '';
  includedAnyAll3: string = '';
  includedAnyAllTested3: string = '';
  includedExclude4: string = '';
  includedValueSet4: string = '';
  includedFollowedByValueSet4: string = '';
  includedDateFrom4: string = '';
  includedDateTo4: string = '';
  includedPeriodValue4: string = '';
  includedPeriodType4: string = '';
  includedAnyAll4: string = '';
  includedAnyAllFollowedBy4: string = '';
  includedAreNot4: string = '';
  includedExclude5: string = '';
  includedValueSet5: string = '';
  includedOperator5: string = '';
  includedEntryValue5: string = '';
  includedDateFrom5: string = '';
  includedDateTo5: string = '';
  includedPeriodValue5: string = '';
  includedPeriodType5: string = '';
  includedAnyAll5: string = '';

  disableForm: boolean;
  id: string;
  firstFormGroup: FormGroup;
  secondFormGroup: FormGroup;
  thirdFormGroup: FormGroup;
  fourthFormGroup: FormGroup;
  fifthFormGroup: FormGroup;

  orgList = [];
  orgIncList = [];
  valueSet = [];

  jsonQuery: string;

  select1a: boolean = false;
  addQuery1: boolean = true;
  select1b: boolean = false;
  addQuery1b: boolean = true;
  select2a: boolean = false;
  addQuery2: boolean = true;

  eventTypes: eventType[] = [
    {value: 'Person'},
    {value: 'Clinical events'},
    {value: 'Medication'},
    {value: 'Encounters'}
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
    {aggValue: 'Timeline'},
    {aggValue: 'Geospatial grouping'},
    {aggValue: 'Age bands'},
    {aggValue: 'Ethnic grouping'}
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
  exclude: exclude[] = [
    {exclude: 'Include'},
    {exclude: 'Exclude'}
  ];
  earliestLatest: earliestLatest[] = [
    {earliestLatest: 'Earliest'},
    {earliestLatest: 'Latest'}
  ];
  operator: operator[] = [
    {operator: 'Less than'},
    {operator: 'Greater than'}
  ];
  period: period[] = [
    {period: 'Days'},
    {period: 'Weeks'},
    {period: 'Months'}
  ];
  anyAll: anyAll[] = [
    {anyAll: 'Any'},
    {anyAll: 'All'}
  ];
  areNot: areNot[] = [
    {areNot: 'Are'},
    {areNot: 'Are not'}
  ];

  constructor(
    public dialogRef: MatDialogRef<AdvancedQueryEditorComponent>,
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
      this.valueDateFrom = query.valueDateFrom;
      this.valueDateTo = query.valueDateTo;
      this.selectedDatasetValueSet = query.datasetValue;
      this.selectedEventType = query.eventType;
      this.active = query.active;
      this.dateFrom = query.dateFrom;
      this.dateTo = query.dateTo;
      this.selectedAggregate = query.aggregateOutput;
      this.selectedEvent = query.eventOutput;
      this.selectedSchedule = query.schedule;
      this.selectedDelivery = query.delivery;
      this.includedExclude1 = query.includedExclude1;
      this.includedValueSet1 = query.includedValueSet1;
      this.includedDateFrom1 = query.includedDateFrom1;
      this.includedDateTo1 = query.includedDateTo1;
      this.includedPeriodValue1 = query.includedPeriodValue1;
      this.includedPeriodType1 = query.includedPeriodType1;
      this.includedAnyAll1 = query.includedAnyAll1;
      this.includedExclude1a = query.includedExclude1a;
      this.includedValueSet1a = query.includedValueSet1a;
      this.includedDateFrom1a = query.includedDateFrom1a;
      this.includedDateTo1a = query.includedDateTo1a;
      this.includedPeriodValue1a = query.includedPeriodValue1a;
      this.includedPeriodType1a = query.includedPeriodType1a;
      this.includedAnyAll1a = query.includedAnyAll1a;
      this.includedExclude1b = query.includedExclude1b;
      this.includedValueSet1b = query.includedValueSet1b;
      this.includedDateFrom1b = query.includedDateFrom1b;
      this.includedDateTo1b = query.includedDateTo1b;
      this.includedPeriodValue1b = query.includedPeriodValue1b;
      this.includedPeriodType1b = query.includedPeriodType1b;
      this.includedAnyAll1b = query.includedAnyAll1b;
      this.includedExclude2 = query.includedExclude2;
      this.includedValueSet2 = query.includedValueSet2;
      this.includedEarliestLatest2 = query.includedEarliestLatest2;
      this.includedOperator2 = query.includedOperator2;
      this.includedEntryValue2 = query.includedEntryValue2;
      this.includedAnyAll2 = query.includedAnyAll2;
      this.includedDateFrom2 = query.includedDateFrom2;
      this.includedDateTo2 = query.includedDateTo2;
      this.includedPeriodValue2 = query.includedPeriodValue2;
      this.includedPeriodType2 = query.includedPeriodType2;
      this.includedExclude2a = query.includedExclude2a;
      this.includedValueSet2a = query.includedValueSet2a;
      this.includedEarliestLatest2a = query.includedEarliestLatest2a;
      this.includedOperator2a = query.includedOperator2a;
      this.includedEntryValue2a = query.includedEntryValue2a;
      this.includedAnyAll2a = query.includedAnyAll2a;
      this.includedDateFrom2a = query.includedDateFrom2a;
      this.includedDateTo2a = query.includedDateTo2a;
      this.includedPeriodValue2a = query.includedPeriodValue2a;
      this.includedPeriodType2a = query.includedPeriodType2a;
      this.includedExclude3 = query.includedExclude3;
      this.includedValueSet3 = query.includedValueSet3;
      this.includedEarliestLatest3 = query.includedEarliestLatest3;
      this.includedTestedValueSet3 = query.includedTestedValueSet3;
      this.includedAnyAll3 = query.includedAnyAll3;
      this.includedAnyAllTested3 = query.includedAnyAllTested3;
      this.includedExclude4 = query.includedExclude4;
      this.includedValueSet4 = query.includedValueSet4;
      this.includedFollowedByValueSet4 = query.includedFollowedByValueSet4;
      this.includedDateFrom4 = query.includedDateFrom4;
      this.includedDateTo4 = query.includedDateTo4;
      this.includedPeriodValue4 = query.includedPeriodValue4;
      this.includedPeriodType4 = query.includedPeriodType4;
      this.includedAnyAll4 = query.includedAnyAll4;
      this.includedAnyAllFollowedBy4 = query.includedAnyAllFollowedBy4;
      this.includedAreNot4 = query.includedAreNot4;
      this.includedExclude5 = query.includedExclude5;
      this.includedValueSet5 = query.includedValueSet5;
      this.includedOperator5 = query.includedOperator5;
      this.includedEntryValue5 = query.includedEntryValue5;
      this.includedDateFrom5 = query.includedDateFrom5;
      this.includedDateTo5 = query.includedDateTo5;
      this.includedPeriodValue5 = query.includedPeriodValue5;
      this.includedPeriodType5 = query.includedPeriodType5;
      this.includedAnyAll5 = query.includedAnyAll5;

      console.log(this.includedExclude1a);

      if (this.includedExclude1a != "") {
        this.select1a = true;
        this.addQuery1 = false;
      }

      if (this.includedExclude1b != "") {
        this.select1b = true;
        this.addQuery1b = false;
      }

      if (this.includedExclude2a != "") {
        this.select2a = true;
        this.addQuery2 = false;
      }
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required]
    });
    this.secondFormGroup = this._formBuilder.group({
      control17: [''], control3: ['', Validators.required], control4: ['', Validators.required], control5: [''], control20: [''], control21: [''], control6: [''], control7: [''], control8: [''], control9: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({
      control22: [''], control23: [''], control24: [''], control25: [''],
      control22a: [''], control23a: [''], control24a: [''], control25a: [''],
      control46a: [''], control47a: [''], control48a: [''],
      control22b: [''], control23b: [''], control24b: [''], control25b: [''],
      control46b: [''], control47b: [''], control48b: [''],
      control26: [''], control27: [''], control28: [''], control29: [''],
      control30: [''], control31: [''], control32: [''], control33: [''],
      control34: [''], control35: [''], control36: [''], control37: [''],
      control38: [''], control39: [''], control40: [''], control41: [''],
      control42: [''], control43: [''], control44: [''], control45: [''],
      control26a: [''], control27a: [''], control28a: [''], control29a: [''],
      control30a: [''], control46: [''], control47: [''], control48: [''],
      control49: [''], control50: [''], control51: [''], control52: [''],
      control53: [''], control54: [''], control55: [''], control56: [''],
      control57: [''], control58: [''], control59: [''], control60: [''],
      control61: [''], control62: [''], control63: [''], control64: [''],
      control61a: [''], control62a: [''], control63a: [''], control64a: ['']
    });
    this.fourthFormGroup = this._formBuilder.group({
      control10: ['', Validators.required], control11: [''], control12: [''], control13: [''], control16: ['']
    });
    this.fifthFormGroup = this._formBuilder.group({
      control14: [''], control15: [''], control18: ['', Validators.required], control19: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.explorerService.getLookupLists('10')
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

    this.explorerService.getLookupLists('8')
      .subscribe(
        (result) => this.loadValueSet(result),
        (error) => this.log.error(error)
      );
  }

  loadValueSet(lists: any) {
    lists.results.map(
      e => {
        this.valueSet.push(e.type);
      }
    )
  }

  saveQuery() {

    let query = {
      providerOrganisation: this.selectedOrganisation,
      includedOrganisation: this.selectedIncludedOrganisation,
      registrationStatus: this.selectedRegistration,
      cohortValue: this.selectedCohortValueSet,
      valueDateFrom: this.formatDate(this.valueDateFrom),
      valueDateTo: this.formatDate(this.valueDateTo),
      ageFrom: this.ageFrom,
      ageTo: this.ageTo,
      gender: this.selectedGender,
      postcode: this.postcode,
      includedExclude1: this.includedExclude1,
      includedAnyAll1: this.includedAnyAll1,
      includedValueSet1: this.includedValueSet1,
      includedDateFrom1: this.formatDate(this.includedDateFrom1),
      includedDateTo1: this.formatDate(this.includedDateTo1),
      includedPeriodValue1: this.includedPeriodValue1,
      includedPeriodType1: this.includedPeriodType1,
      includedExclude1a: this.includedExclude1a,
      includedAnyAll1a: this.includedAnyAll1a,
      includedValueSet1a: this.includedValueSet1a,
      includedDateFrom1a: this.formatDate(this.includedDateFrom1a),
      includedDateTo1a: this.formatDate(this.includedDateTo1a),
      includedPeriodValue1a: this.includedPeriodValue1a,
      includedPeriodType1a: this.includedPeriodType1a,
      includedExclude1b: this.includedExclude1b,
      includedAnyAll1b: this.includedAnyAll1b,
      includedValueSet1b: this.includedValueSet1b,
      includedDateFrom1b: this.formatDate(this.includedDateFrom1b),
      includedDateTo1b: this.formatDate(this.includedDateTo1b),
      includedPeriodValue1b: this.includedPeriodValue1b,
      includedPeriodType1b: this.includedPeriodType1b,
      includedExclude2: this.includedExclude2,
      includedAnyAll2: this.includedAnyAll2,
      includedValueSet2: this.includedValueSet2,
      includedEarliestLatest2: this.includedEarliestLatest2,
      includedOperator2: this.includedOperator2,
      includedEntryValue2: this.includedEntryValue2,
      includedDateFrom2: this.formatDate(this.includedDateFrom2),
      includedDateTo2: this.formatDate(this.includedDateTo2),
      includedPeriodValue2: this.includedPeriodValue2,
      includedPeriodType2: this.includedPeriodType2,
      includedExclude2a: this.includedExclude2a,
      includedAnyAll2a: this.includedAnyAll2a,
      includedValueSet2a: this.includedValueSet2a,
      includedEarliestLatest2a: this.includedEarliestLatest2a,
      includedOperator2a: this.includedOperator2a,
      includedEntryValue2a: this.includedEntryValue2a,
      includedDateFrom2a: this.formatDate(this.includedDateFrom2a),
      includedDateTo2a: this.formatDate(this.includedDateTo2a),
      includedPeriodValue2a: this.includedPeriodValue2a,
      includedPeriodType2a: this.includedPeriodType2a,
      includedExclude3: this.includedExclude3,
      includedAnyAll3: this.includedAnyAll3,
      includedValueSet3: this.includedValueSet3,
      includedEarliestLatest3: this.includedEarliestLatest3,
      includedAnyAllTested3: this.includedAnyAllTested3,
      includedTestedValueSet3: this.includedTestedValueSet3,
      includedExclude4: this.includedExclude4,
      includedAnyAll4: this.includedAnyAll4,
      includedValueSet4: this.includedValueSet4,
      includedAreNot4: this.includedAreNot4,
      includedAnyAllFollowedBy4: this. includedAnyAllFollowedBy4,
      includedFollowedByValueSet4: this.includedFollowedByValueSet4,
      includedDateFrom4: this.formatDate(this.includedDateFrom4),
      includedDateTo4: this.formatDate(this.includedDateTo4),
      includedPeriodValue4: this.includedPeriodValue4,
      includedPeriodType4: this.includedPeriodType4,
      includedExclude5: this.includedExclude5,
      includedAnyAll5: this.includedAnyAll5,
      includedValueSet5: this.includedValueSet5,
      includedOperator5: this.includedOperator5,
      includedEntryValue5: this.includedEntryValue5,
      includedDateFrom5: this.formatDate(this.includedDateFrom5),
      includedDateTo5: this.formatDate(this.includedDateTo5),
      includedPeriodValue5: this.includedPeriodValue5,
      includedPeriodType5: this.includedPeriodType5,
      eventType: this.selectedEventType,
      active: this.active,
      datasetValue: this.selectedDatasetValueSet,
      dateFrom: this.formatDate(this.dateFrom),
      dateTo: this.formatDate(this.dateTo),
      eventOutput: this.selectedEvent,
      aggregateOutput: this.selectedAggregate,
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

  addSameRule1() {
    this.select1a = true;
  }

  addSameRule1b() {
    this.select1b = true;
  }

  addSameRule2() {
    this.select2a = true;
  }

}
