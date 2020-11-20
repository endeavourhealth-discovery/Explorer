import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";
import {takeUntil} from "rxjs/operators";
import {ReplaySubject, Subject} from "rxjs";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {Router} from "@angular/router";

export interface DialogData {
  id: string;
  name: string;
  type: string;
  registryName: string;
  denominatorQuery: string;
  query: string;
}

interface savedQuery {
  denominatorQuery: string;
  targetPercentage: string;
  registryName: string;
  providerOrganisation: string;
  includedOrganisation: string;
  registrationStatus: string;
  ageFrom: string;
  ageTo: string;
  gender: string;
  postcode: string;
  registrationExclude: string;
  registrationDateFrom: string;
  registrationDateTo: string;
  registrationPeriodValue: string;
  registrationPeriodType: string;
  schedule: string;
  delivery: string;
  includedExclude1: string;
  includedValueSet1: string;
  includedDateFrom1: string;
  includedDateTo1: string;
  includedPeriodOperator1: string;
  includedPeriodValue1: string;
  includedPeriodType1: string;
  includedAnyAll1: string;
  includedExclude1a: string;
  includedValueSet1a: string;
  includedDateFrom1a: string;
  includedDateTo1a: string;
  includedPeriodOperator1a: string;
  includedPeriodValue1a: string;
  includedPeriodType1a: string;
  includedAnyAll1a: string;
  includedExclude1b: string;
  includedValueSet1b: string;
  includedDateFrom1b: string;
  includedDateTo1b: string;
  includedPeriodOperator1b: string;
  includedPeriodValue1b: string;
  includedPeriodType1b: string;
  includedAnyAll1b: string;
  includedExclude1c: string;
  includedValueSet1c: string;
  includedDateFrom1c: string;
  includedDateTo1c: string;
  includedPeriodOperator1c: string;
  includedPeriodValue1c: string;
  includedPeriodType1c: string;
  includedAnyAll1c: string;
  includedExclude1d: string;
  includedValueSet1d: string;
  includedDateFrom1d: string;
  includedDateTo1d: string;
  includedPeriodOperator1d: string;
  includedPeriodValue1d: string;
  includedPeriodType1d: string;
  includedAnyAll1d: string;
  includedExclude2: string;
  includedValueSet2: string;
  includedEarliestLatest2: string;
  includedOperator2: string;
  includedEntryValue2: string;
  includedAnyAll2: string;
  includedDateFrom2: string;
  includedDateTo2: string;
  includedPeriodOperator2: string;
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
  includedPeriodOperator2a: string;
  includedPeriodValue2a: string;
  includedPeriodType2a: string;
  includedExclude3: string;
  includedValueSet3: string;
  includedEarliestLatest3: string;
  includedTestedValueSet3: string;
  includedAnyAll3: string;
  includedAnyAllTested3: string;
  includedDateFrom3: string;
  includedDateTo3: string;
  includedPeriodOperator3: string;
  includedPeriodValue3: string;
  includedPeriodType3: string;
  includedExclude3a: string;
  includedValueSet3a: string;
  includedEarliestLatest3a: string;
  includedTestedValueSet3a: string;
  includedAnyAll3a: string;
  includedAnyAllTested3a: string;
  includedDateFrom3a: string;
  includedDateTo3a: string;
  includedPeriodOperator3a: string;
  includedPeriodValue3a: string;
  includedPeriodType3a: string;
  includedExclude4: string;
  includedValueSet4: string;
  includedFollowedByValueSet4: string;
  includedDateFrom4: string;
  includedDateTo4: string;
  includedPeriodOperator4: string;
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
  includedPeriodOperator5: string;
  includedPeriodValue5: string;
  includedPeriodType5: string;
  includedAnyAll5: string;
  includedExclude5a: string;
  includedValueSet5a: string;
  includedOperator5a: string;
  includedEntryValue5a: string;
  includedDateFrom5a: string;
  includedDateTo5a: string;
  includedPeriodOperator5a: string;
  includedPeriodValue5a: string;
  includedPeriodType5a: string;
  includedAnyAll5a: string;
  demographics: boolean;
  encounters: boolean;
  medication: boolean;
  currentMedication: boolean;
  clinicalEvents: boolean;
  activeProblems: boolean;
  dateFromEncounters: string;
  dateToEncounters: string;
  dateFromMedication: string;
  dateToMedication: string;
  dateFromClinicalEvents: string;
  dateToClinicalEvents: string;
  selectedDemographicFields: string;
  selectedEncounterFields: string;
  selectedMedicationFields: string;
  selectedClinicalEventFields: string;
  selectedClinicalTypes: string;
  selectedEncounterValueSet: string;
  selectedMedicationValueSet: string;
  selectedClinicalEventValueSet: string;
  seriesEncounterValueSet: string;
  seriesMedicationValueSet: string;
  seriesClinicalEventValueSet: string;
  seriesDateFrom: string;
  seriesDateTo: string;
  seriesPeriodOperator: string;
  seriesPeriodValue: string;
  seriesPeriodType: string;
  timeSeries: boolean;
  seriesTable: string;
  seriesField: string;
}

interface table {
  table: string;
}

interface field {
  field: string;
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

interface clinicalType {
  clinicalType: string;
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

interface withinBefore {
  withinBefore: string;
}

interface areNot {
  areNot: string;
}

interface valueSet {
  value: string;
}

interface querySet {
  value: string;
}

interface valueSetObservation {
  value: string;
}
interface valueSetMedication {
  value: string;
}
interface valueSetEncounter {
  value: string;
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
  filterQueryCtrl: FormControl = new FormControl();
  filterCtrl: FormControl = new FormControl();
  filterCtrlObservation: FormControl = new FormControl();
  filterCtrlMedication: FormControl = new FormControl();
  filterCtrlEncounter: FormControl = new FormControl();

  queryList = [];

  type: string = '';
  name: string = '';
  denominatorQuery: string = '';
  targetPercentage: string = '';
  registryName: string = '';
  selectedOrganisation: string = '';
  selectedIncludedOrganisation: string = '';
  selectedRegistration: string = '';
  registrationExclude: string = '';
  registrationDateFrom: string = this.formatDate(new Date());
  registrationDateTo: string = this.formatDate(new Date());
  registrationPeriodValue: string= '';
  registrationPeriodType: string= '';
  ageFrom: string = '';
  ageTo: string = '';
  selectedGender: string = '';
  postcode: string = '';

  includedExclude1: string = '';
  includedValueSet1: string = '';
  includedDateFrom1: string = '';
  includedDateTo1: string = '';
  includedPeriodOperator1: string = '';
  includedPeriodValue1: string = '';
  includedPeriodType1: string = '';
  includedAnyAll1: string = '';
  includedExclude1a: string = '';
  includedValueSet1a: string = '';
  includedDateFrom1a: string = '';
  includedDateTo1a: string = '';
  includedPeriodOperator1a: string = '';
  includedPeriodValue1a: string = '';
  includedPeriodType1a: string = '';
  includedAnyAll1a: string = '';
  includedExclude1b: string = '';
  includedValueSet1b: string = '';
  includedDateFrom1b: string = '';
  includedDateTo1b: string = '';
  includedPeriodOperator1b: string = '';
  includedPeriodValue1b: string = '';
  includedPeriodType1b: string = '';
  includedAnyAll1b: string = '';
  includedExclude1c: string = '';
  includedValueSet1c: string = '';
  includedDateFrom1c: string = '';
  includedDateTo1c: string = '';
  includedPeriodOperator1c: string = '';
  includedPeriodValue1c: string = '';
  includedPeriodType1c: string = '';
  includedAnyAll1c: string = '';
  includedExclude1d: string = '';
  includedValueSet1d: string = '';
  includedDateFrom1d: string = '';
  includedDateTo1d: string = '';
  includedPeriodOperator1d: string = '';
  includedPeriodValue1d: string = '';
  includedPeriodType1d: string = '';
  includedAnyAll1d: string = '';
  includedExclude2: string = '';
  includedValueSet2: string = '';
  includedEarliestLatest2: string = '';
  includedOperator2: string = '';
  includedEntryValue2: string = '';
  includedAnyAll2: string = '';
  includedDateFrom2: string = '';
  includedDateTo2: string = '';
  includedPeriodOperator2: string = '';
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
  includedPeriodOperator2a: string = '';
  includedPeriodValue2a: string = '';
  includedPeriodType2a: string = '';
  includedExclude3: string = '';
  includedValueSet3: string = '';
  includedEarliestLatest3: string = '';
  includedTestedValueSet3: string = '';
  includedAnyAll3: string = '';
  includedAnyAllTested3: string = '';
  includedDateFrom3: string = '';
  includedDateTo3: string = '';
  includedPeriodOperator3: string = '';
  includedPeriodValue3: string = '';
  includedPeriodType3: string = '';
  includedExclude3a: string = '';
  includedValueSet3a: string = '';
  includedEarliestLatest3a: string = '';
  includedTestedValueSet3a: string = '';
  includedAnyAll3a: string = '';
  includedAnyAllTested3a: string = '';
  includedDateFrom3a: string = '';
  includedDateTo3a: string = '';
  includedPeriodOperator3a: string = '';
  includedPeriodValue3a: string = '';
  includedPeriodType3a: string = '';
  includedExclude4: string = '';
  includedValueSet4: string = '';
  includedFollowedByValueSet4: string = '';
  includedDateFrom4: string = '';
  includedDateTo4: string = '';
  includedPeriodOperator4: string = '';
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
  includedPeriodOperator5: string = '';
  includedPeriodValue5: string = '';
  includedPeriodType5: string = '';
  includedAnyAll5: string = '';
  includedExclude5a: string = '';
  includedValueSet5a: string = '';
  includedOperator5a: string = '';
  includedEntryValue5a: string = '';
  includedDateFrom5a: string = '';
  includedDateTo5a: string = '';
  includedPeriodOperator5a: string = '';
  includedPeriodValue5a: string = '';
  includedPeriodType5a: string = '';
  includedAnyAll5a: string = '';

  demographics: boolean = false;
  encounters: boolean = false;
  medication: boolean = false;
  currentMedication: boolean = false;
  clinicalEvents: boolean = false;
  activeProblems: boolean = false;
  timeSeries: boolean = false;
  seriesTable: string = '';
  seriesField: string = 'Concept term';
  seriesTableEncounter: boolean = false;
  seriesTableMedication: boolean = false;
  seriesTableObservation: boolean = false;

  dateFromEncounters: string = this.formatDate(new Date());
  dateToEncounters: string = this.formatDate(new Date());
  dateFromMedication: string = this.formatDate(new Date());
  dateToMedication: string = this.formatDate(new Date());
  dateFromClinicalEvents: string = this.formatDate(new Date());
  dateToClinicalEvents: string = this.formatDate(new Date());
  demographicsFieldList = [];
  clinicalEventFieldList = [];
  encounterFieldList = [];
  medicationFieldList = [];
  selectedDemographicFields: string = '';
  selectedEncounterFields: string = '';
  selectedMedicationFields: string = '';
  selectedClinicalEventFields: string = '';
  selectedClinicalTypes: string = '';
  clinicalTypeList: clinicalType[] = [
    {clinicalType: 'Conditions/diseases'},
    {clinicalType: 'Allergies'},
    {clinicalType: 'Warnings'},
    {clinicalType: 'Observations'},
    {clinicalType: 'Diagnostic orders'},
    {clinicalType: 'Diagnostic results'},
    {clinicalType: 'Procedure requests'},
    {clinicalType: 'Procedures'},
    {clinicalType: 'Referral requests'},
    {clinicalType: 'Family history'},
    {clinicalType: 'Immunisations'},
    {clinicalType: 'Biochemistry'},
    {clinicalType: 'Biological values'},
    {clinicalType: 'Cytology/histology'},
    {clinicalType: 'Haematology'},
    {clinicalType: 'Immunology'},
    {clinicalType: 'Microbiology'},
    {clinicalType: 'Obstetrics/birth'},
    {clinicalType: 'Pathology'},
    {clinicalType: 'Personal health/social'},
    {clinicalType: 'Radiology'}
  ];
  selectedEncounterValueSet: string = '';
  selectedMedicationValueSet: string = '';
  selectedClinicalEventValueSet: string = '';

  seriesEncounterValueSet: string = '';
  seriesMedicationValueSet: string = '';
  seriesClinicalEventValueSet: string = '';
  seriesDateFrom: string = '';
  seriesDateTo: string = '';
  seriesPeriodOperator: string = '';
  seriesPeriodValue: string = '';
  seriesPeriodType: string = '';

  selectedDelivery: string = '';
  selectedSchedule: string = '';

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
  valueSetObservation = [];
  valueSetMedication = [];
  valueSetEncounter = [];

  filteredQueryList: ReplaySubject<querySet[]> = new ReplaySubject<querySet[]>(1);
  filteredValueset: ReplaySubject<valueSet[]> = new ReplaySubject<valueSet[]>(1);
  filteredValuesetObservation: ReplaySubject<valueSetObservation[]> = new ReplaySubject<valueSetObservation[]>(1);
  filteredValuesetMedication: ReplaySubject<valueSetMedication[]> = new ReplaySubject<valueSetMedication[]>(1);
  filteredValuesetEncounter: ReplaySubject<valueSetEncounter[]> = new ReplaySubject<valueSetEncounter[]>(1);

  jsonQuery: string;

  select1a: boolean = false;
  addQuery1: boolean = true;
  select1b: boolean = false;
  addQuery1b: boolean = true;
  select1c: boolean = false;
  addQuery1c: boolean = true;
  select1d: boolean = false;
  addQuery1d: boolean = true;
  select2a: boolean = false;
  addQuery2: boolean = true;
  select3a: boolean = false;
  addQuery3: boolean = true;
  select5a: boolean = false;
  addQuery5: boolean = true;

  tables: table[] = [
    {table: ''},
    {table: 'Clinical events'},
    {table: 'Medication'},
    {table: 'Encounter'}
  ];
  seriesFields: field[] = [
    {field: ''},
    {field: 'Concept term'}
  ];
  registrations: registration[] = [
    {regValue: ''},
    {regValue: 'Currently registered patients'},
    {regValue: 'All patients included left and deads'}
  ];
  genders: gender[] = [
    {genValue: ''},
    {genValue: 'All'},
    {genValue: 'Male'},
    {genValue: 'Female'},
    {genValue: 'Other'}
  ];
  deliveries: delivery[] = [
    {deliveryValue: ''},
    {deliveryValue: 'Dashboard'},
    {deliveryValue: 'CSV files'}
  ];
  schedules: schedule[] = [
    {scheduleValue: ''},
    {scheduleValue: 'Daily'},
    {scheduleValue: 'Weekly'},
    {scheduleValue: 'Monthly'},
    {scheduleValue: 'Quarterly'},
    {scheduleValue: 'One-off'}
  ];
  exclude: exclude[] = [
    {exclude: ''},
    {exclude: 'Include'},
    {exclude: 'Exclude'}
  ];
  earliestLatest: earliestLatest[] = [
    {earliestLatest: ''},
    {earliestLatest: 'Earliest'},
    {earliestLatest: 'Latest'}
  ];
  operator: operator[] = [
    {operator: ''},
    {operator: 'Less than'},
    {operator: 'Greater than'}
  ];
  period: period[] = [
    {period: ''},
    {period: 'Days'},
    {period: 'Weeks'},
    {period: 'Months'}
  ];
  anyAll: anyAll[] = [
    {anyAll: ''},
    {anyAll: 'Any'},
    {anyAll: 'All'}
  ];
  areNot: areNot[] = [
    {areNot: ''},
    {areNot: 'Are'},
    {areNot: 'Are not'}
  ];
  withinBefore: withinBefore[] = [
    {withinBefore: ''},
    {withinBefore: 'within'},
    {withinBefore: 'before'}
  ];

  constructor(
    public dialogRef: MatDialogRef<AdvancedQueryEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private _formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: DialogData,
    private dialog: MatDialog) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.registryName = data.registryName;
    this.denominatorQuery = data.denominatorQuery;
    this.type = data.type;

    if (data.query!='') { // edit mode
      let query: savedQuery = JSON.parse(data.query);

      this.targetPercentage = query.targetPercentage;
      this.selectedOrganisation = query.providerOrganisation;
      this.selectedIncludedOrganisation = query.includedOrganisation;
      this.selectedRegistration = query.registrationStatus;
      this.ageFrom = query.ageFrom;
      this.ageTo = query.ageTo;
      this.selectedGender = query.gender;
      this.postcode = query.postcode;
      this.registrationExclude = query.registrationExclude;
      this.registrationDateFrom = query.registrationDateFrom;
      this.registrationDateTo = query.registrationDateTo;
      this.registrationPeriodValue = query.registrationPeriodValue;
      this.registrationPeriodType = query.registrationPeriodType;
      this.selectedSchedule = query.schedule;
      this.selectedDelivery = query.delivery;
      this.includedExclude1 = query.includedExclude1;
      this.includedValueSet1 = query.includedValueSet1;
      this.includedDateFrom1 = query.includedDateFrom1;
      this.includedDateTo1 = query.includedDateTo1;
      this.includedPeriodOperator1 = query.includedPeriodOperator1;
      this.includedPeriodValue1 = query.includedPeriodValue1;
      this.includedPeriodType1 = query.includedPeriodType1;
      this.includedAnyAll1 = query.includedAnyAll1;
      this.includedExclude1a = query.includedExclude1a;
      this.includedValueSet1a = query.includedValueSet1a;
      this.includedDateFrom1a = query.includedDateFrom1a;
      this.includedDateTo1a = query.includedDateTo1a;
      this.includedPeriodOperator1a = query.includedPeriodOperator1a;
      this.includedPeriodValue1a = query.includedPeriodValue1a;
      this.includedPeriodType1a = query.includedPeriodType1a;
      this.includedAnyAll1a = query.includedAnyAll1a;
      this.includedExclude1b = query.includedExclude1b;
      this.includedValueSet1b = query.includedValueSet1b;
      this.includedDateFrom1b = query.includedDateFrom1b;
      this.includedDateTo1b = query.includedDateTo1b;
      this.includedPeriodOperator1b = query.includedPeriodOperator1b;
      this.includedPeriodValue1b = query.includedPeriodValue1b;
      this.includedPeriodType1b = query.includedPeriodType1b;
      this.includedAnyAll1b = query.includedAnyAll1b;
      this.includedExclude1c = query.includedExclude1c;
      this.includedValueSet1c = query.includedValueSet1c;
      this.includedDateFrom1c = query.includedDateFrom1c;
      this.includedDateTo1c = query.includedDateTo1c;
      this.includedPeriodOperator1c = query.includedPeriodOperator1c;
      this.includedPeriodValue1c = query.includedPeriodValue1c;
      this.includedPeriodType1c = query.includedPeriodType1c;
      this.includedAnyAll1c = query.includedAnyAll1c;
      this.includedExclude1d = query.includedExclude1d;
      this.includedValueSet1d = query.includedValueSet1d;
      this.includedDateFrom1d = query.includedDateFrom1d;
      this.includedDateTo1d = query.includedDateTo1d;
      this.includedPeriodOperator1d = query.includedPeriodOperator1d;
      this.includedPeriodValue1d = query.includedPeriodValue1d;
      this.includedPeriodType1d = query.includedPeriodType1d;
      this.includedAnyAll1d = query.includedAnyAll1d;
      this.includedExclude2 = query.includedExclude2;
      this.includedValueSet2 = query.includedValueSet2;
      this.includedEarliestLatest2 = query.includedEarliestLatest2;
      this.includedOperator2 = query.includedOperator2;
      this.includedEntryValue2 = query.includedEntryValue2;
      this.includedAnyAll2 = query.includedAnyAll2;
      this.includedDateFrom2 = query.includedDateFrom2;
      this.includedDateTo2 = query.includedDateTo2;
      this.includedPeriodOperator2 = query.includedPeriodOperator2;
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
      this.includedPeriodOperator2a = query.includedPeriodOperator2a;
      this.includedPeriodValue2a = query.includedPeriodValue2a;
      this.includedPeriodType2a = query.includedPeriodType2a;
      this.includedExclude3 = query.includedExclude3;
      this.includedValueSet3 = query.includedValueSet3;
      this.includedEarliestLatest3 = query.includedEarliestLatest3;
      this.includedTestedValueSet3 = query.includedTestedValueSet3;
      this.includedAnyAll3 = query.includedAnyAll3;
      this.includedAnyAllTested3 = query.includedAnyAllTested3;
      this.includedDateFrom3 = query.includedDateFrom3;
      this.includedDateTo3 = query.includedDateTo3;
      this.includedPeriodOperator3 = query.includedPeriodOperator3;
      this.includedPeriodValue3 = query.includedPeriodValue3;
      this.includedPeriodType3 = query.includedPeriodType3;
      this.includedExclude3a = query.includedExclude3a;
      this.includedValueSet3a = query.includedValueSet3a;
      this.includedEarliestLatest3a = query.includedEarliestLatest3a;
      this.includedTestedValueSet3a = query.includedTestedValueSet3a;
      this.includedAnyAll3a = query.includedAnyAll3a;
      this.includedAnyAllTested3a = query.includedAnyAllTested3a;
      this.includedDateFrom3a = query.includedDateFrom3a;
      this.includedDateTo3a = query.includedDateTo3a;
      this.includedPeriodOperator3a = query.includedPeriodOperator3a;
      this.includedPeriodValue3a = query.includedPeriodValue3a;
      this.includedPeriodType3a = query.includedPeriodType3a;
      this.includedExclude4 = query.includedExclude4;
      this.includedValueSet4 = query.includedValueSet4;
      this.includedFollowedByValueSet4 = query.includedFollowedByValueSet4;
      this.includedDateFrom4 = query.includedDateFrom4;
      this.includedDateTo4 = query.includedDateTo4;
      this.includedPeriodOperator4 = query.includedPeriodOperator4;
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
      this.includedPeriodOperator5 = query.includedPeriodOperator5;
      this.includedPeriodValue5 = query.includedPeriodValue5;
      this.includedPeriodType5 = query.includedPeriodType5;
      this.includedAnyAll5 = query.includedAnyAll5;
      this.includedExclude5a = query.includedExclude5a;
      this.includedValueSet5a = query.includedValueSet5a;
      this.includedOperator5a = query.includedOperator5a;
      this.includedEntryValue5a = query.includedEntryValue5a;
      this.includedDateFrom5a = query.includedDateFrom5a;
      this.includedDateTo5a = query.includedDateTo5a;
      this.includedPeriodOperator5a = query.includedPeriodOperator5a;
      this.includedPeriodValue5a = query.includedPeriodValue5a;
      this.includedPeriodType5a = query.includedPeriodType5a;
      this.includedAnyAll5a = query.includedAnyAll5a;

      this.demographics = query.demographics;
      this.encounters = query.encounters;
      this.medication = query.medication;
      this.currentMedication = query.currentMedication;
      this.clinicalEvents = query.clinicalEvents;
      this.activeProblems = query.activeProblems;
      this.dateFromEncounters = query.dateFromEncounters;
      this.dateToEncounters = query.dateToEncounters;
      this.dateFromMedication = query.dateFromMedication;
      this.dateToMedication = query.dateToMedication;
      this.dateFromClinicalEvents = query.dateFromClinicalEvents;
      this.dateToClinicalEvents = query.dateToClinicalEvents;
      this.selectedDemographicFields = query.selectedDemographicFields;
      this.selectedEncounterFields = query.selectedEncounterFields;
      this.selectedMedicationFields = query.selectedMedicationFields;
      this.selectedClinicalEventFields = query.selectedClinicalEventFields;
      this.selectedClinicalTypes = query.selectedClinicalTypes;
      this.selectedEncounterValueSet = query.selectedEncounterValueSet;
      this.selectedMedicationValueSet = query.selectedMedicationValueSet;
      this.selectedClinicalEventValueSet = query.selectedClinicalEventValueSet;
      this.timeSeries = query.timeSeries;
      this.seriesTable = query.seriesTable;
      this.seriesField = query.seriesField;
      this.seriesEncounterValueSet = query.seriesEncounterValueSet;
      this.seriesMedicationValueSet = query.seriesMedicationValueSet;
      this.seriesClinicalEventValueSet = query.seriesClinicalEventValueSet;
      this.seriesDateFrom = query.seriesDateFrom;
      this.seriesDateTo = query.seriesDateTo;
      this.seriesPeriodOperator = query.seriesPeriodOperator;
      this.seriesPeriodValue = query.seriesPeriodValue;
      this.seriesPeriodType = query.seriesPeriodType;

      if (this.includedExclude1a != "") {
        this.select1a = true;
        this.addQuery1 = false;
      }

      if (this.includedExclude1b != "") {
        this.select1b = true;
        this.addQuery1b = false;
      }

      if (this.includedExclude1c != "") {
        this.select1c = true;
        this.addQuery1c = false;
      }

      if (this.includedExclude1d != "") {
        this.select1d = true;
        this.addQuery1d = false;
      }

      if (this.includedExclude2a != "") {
        this.select2a = true;
        this.addQuery2 = false;
      }
      if (this.includedExclude3a != "") {
        this.select3a = true;
        this.addQuery3 = false;
      }
      if (this.includedExclude5a != "") {
        this.select5a = true;
        this.addQuery5 = false;
      }
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required], control157: [''], control158: [''], control159: ['']
    });
    this.secondFormGroup = this._formBuilder.group({
      control17: [''], control3: ['', Validators.required], control4: ['', Validators.required], control5: [''], control5a: [''], control5b: [''], control20: [''], control21: [''], control6: [''], control7: [''], control8: [''], control9: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({
      control22: [''], control23: [''], control24: [''], control25: [''],
      control22a: [''], control23a: [''], control24a: [''], control25a: [''],
      control46a: [''], control47a: [''], control48a: [''],
      control22b: [''], control23b: [''], control24b: [''], control25b: [''],
      control46b: [''], control47b: [''], control48b: [''],
      control22c: [''], control23c: [''], control24c: [''], control25c: [''],
      control46c: [''], control47c: [''], control48c: [''],
      control22d: [''], control23d: [''], control24d: [''], control25d: [''],
      control46d: [''], control47d: [''], control48d: [''],
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
      control61a: [''], control62a: [''], control63a: [''], control64a: [''],
      control65: [''], control66: [''], control67: [''], control68: [''], control69: [''],
      control31a: [''],control51a: [''],control32a: [''],control33a: [''],control52a: [''],control34a: [''],control65a: [''],control66a: [''],control69a: [''],control67a: [''], control68a: [''],
      control40a: [''],control56a: [''],control41a: [''],control42a: [''],control43a: [''],control44a: [''],control45a: [''],control57a: [''],control58a: [''],control147: [''],control148: [''],
      control149: [''],control150: [''],control151: [''],control152: [''],control153: [''],control154: [''],control155: [''],control156: ['']
    });
    this.fourthFormGroup = this._formBuilder.group({
      control165a: [''],  control165e: [''], control166a: [''], control166c: [''], control166d: [''], control166e: [''], control166g: [''], control167a: [''],
      control167b: [''], control167c: [''], control167d: [''], control167e: [''], control167g: [''], control168a: [''], control168b: [''], control168c: [''], control168d: [''],
      control168e: [''], control168f: [''], control168g: [''], control70: [''], control71: [''], control72: [''], control73: [''], control74: [''], control75: [''], control76: [''],
      control77: [''], control78: [''], control79: [''], control80: ['']
    });
    this.fifthFormGroup = this._formBuilder.group({
      control15: [''], control18: ['', Validators.required], control19: ['', Validators.required]
    });
  }

  private _onDestroy = new Subject<void>();

  ngOnInit() {
    this.explorerService.getLookupLists('10','')
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

    this.explorerService.getLookupLists('12','')
      .subscribe(
        (result) => this.loadQueryList(result),
        (error) => this.log.error(error)
      );

    this.explorerService.getLookupLists('8','')
      .subscribe(
        (result) => this.loadValueSet1(result),
        (error) => this.log.error(error)
      );

    this.explorerService.getLookupLists('8','Observation')
      .subscribe(
        (result) => this.loadValueSet2(result),
        (error) => this.log.error(error)
      );

    this.explorerService.getLookupLists('8','Medication')
      .subscribe(
        (result) => this.loadValueSet3(result),
        (error) => this.log.error(error)
      );

    this.explorerService.getLookupLists('8','Encounter')
      .subscribe(
        (result) => this.loadValueSet4(result),
        (error) => this.log.error(error)
      );
  }

  loadQueryList(lists: any) {
    lists.results.map(
      e => {
        this.queryList.push(e.type);
      }
    )

    this.filteredQueryList.next(this.queryList.slice());

    this.filterQueryCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterQueryList();
      });
  }

  filterQueryList() {
    let search = this.filterQueryCtrl.value;

    if (!search) {
      this.filteredQueryList.next(this.queryList.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredQueryList.next(
      this.queryList.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  loadValueSet1(lists: any) {
    lists.results.map(
      e => {
        this.valueSet.push(e.type);
      }
    )

    this.filteredValueset.next(this.valueSet.slice());

    this.filterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterValueset1();
      });

    this.explorerService.getLookupLists('13','')
      .subscribe(
        (result) => this.loadDemographicSet(result),
        (error) => this.log.error(error)
      );
  }

  loadValueSet2(lists: any) {
    lists.results.map(
      e => {
        this.valueSetObservation.push(e.type);
      }
    )

    this.filteredValuesetObservation.next(this.valueSetObservation.slice());

    this.filterCtrlObservation.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterValueset2();
      });
  }

  loadValueSet3(lists: any) {
    lists.results.map(
      e => {
        this.valueSetMedication.push(e.type);
      }
    )

    this.filteredValuesetMedication.next(this.valueSetMedication.slice());

    this.filterCtrlMedication.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterValueset3();
      });
  }

  loadValueSet4(lists: any) {
    lists.results.map(
      e => {
        this.valueSetEncounter.push(e.type);
      }
    )

    this.filteredValuesetEncounter.next(this.valueSetEncounter.slice());

    this.filterCtrlEncounter.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterValueset4();
      });
  }

  loadDemographicSet(lists: any) {
    lists.results.map(
      e => {
        this.demographicsFieldList.push(e.type);
      }
    )

    this.explorerService.getLookupLists('14','')
      .subscribe(
        (result) => this.loadClinicalEventSet(result),
        (error) => this.log.error(error)
      );

  }

  loadClinicalEventSet(lists: any) {
    lists.results.map(
      e => {
        this.clinicalEventFieldList.push(e.type);
      }
    )

    this.explorerService.getLookupLists('15','')
      .subscribe(
        (result) => this.loadMedicationSet(result),
        (error) => this.log.error(error)
      );

  }

  loadMedicationSet(lists: any) {
    lists.results.map(
      e => {
        this.medicationFieldList.push(e.type);
      }
    )

    this.explorerService.getLookupLists('16','')
      .subscribe(
        (result) => this.loadEncounterSet(result),
        (error) => this.log.error(error)
      );

  }

  loadEncounterSet(lists: any) {
    lists.results.map(
      e => {
        this.encounterFieldList.push(e.type);
      }
    )

  }

  filterValueset1() {
    let search = this.filterCtrl.value;

    if (!search) {
      this.filteredValueset.next(this.valueSet.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValueset.next(
      this.valueSet.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  filterValueset2() {
    let search = this.filterCtrlObservation.value;

    if (!search) {
      this.filteredValuesetObservation.next(this.valueSetObservation.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValuesetObservation.next(
      this.valueSetObservation.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  filterValueset3() {
    let search = this.filterCtrlMedication.value;

    if (!search) {
      this.filteredValuesetMedication.next(this.valueSetMedication.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValuesetMedication.next(
      this.valueSetMedication.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  filterValueset4() {
    let search = this.filterCtrlEncounter.value;

    if (!search) {
      this.filteredValuesetEncounter.next(this.valueSetEncounter.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValuesetEncounter.next(
      this.valueSetEncounter.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  saveQuery() {

    let query = {
      targetPercentage: this.targetPercentage,
      providerOrganisation: this.selectedOrganisation,
      includedOrganisation: this.selectedIncludedOrganisation,
      registrationStatus: this.selectedRegistration,
      registrationExclude: this.registrationExclude,
      registrationDateFrom: this.formatDate(this.registrationDateFrom),
      registrationDateTo: this.formatDate(this.registrationDateTo),
      registrationPeriodValue: this.registrationPeriodValue,
      registrationPeriodType: this.registrationPeriodType,
      ageFrom: this.ageFrom,
      ageTo: this.ageTo,
      gender: this.selectedGender,
      postcode: this.postcode,
      includedExclude1: this.includedExclude1,
      includedAnyAll1: this.includedAnyAll1,
      includedValueSet1: this.includedValueSet1,
      includedDateFrom1: this.formatDate(this.includedDateFrom1),
      includedDateTo1: this.formatDate(this.includedDateTo1),
      includedPeriodOperator1: this.includedPeriodOperator1,
      includedPeriodValue1: this.includedPeriodValue1,
      includedPeriodType1: this.includedPeriodType1,
      includedExclude1a: this.includedExclude1a,
      includedAnyAll1a: this.includedAnyAll1a,
      includedValueSet1a: this.includedValueSet1a,
      includedDateFrom1a: this.formatDate(this.includedDateFrom1a),
      includedDateTo1a: this.formatDate(this.includedDateTo1a),
      includedPeriodOperator1a: this.includedPeriodOperator1a,
      includedPeriodValue1a: this.includedPeriodValue1a,
      includedPeriodType1a: this.includedPeriodType1a,
      includedExclude1b: this.includedExclude1b,
      includedAnyAll1b: this.includedAnyAll1b,
      includedValueSet1b: this.includedValueSet1b,
      includedDateFrom1b: this.formatDate(this.includedDateFrom1b),
      includedDateTo1b: this.formatDate(this.includedDateTo1b),
      includedPeriodOperator1b: this.includedPeriodOperator1b,
      includedPeriodValue1b: this.includedPeriodValue1b,
      includedPeriodType1b: this.includedPeriodType1b,
      includedExclude1c: this.includedExclude1c,
      includedAnyAll1c: this.includedAnyAll1c,
      includedValueSet1c: this.includedValueSet1c,
      includedDateFrom1c: this.formatDate(this.includedDateFrom1c),
      includedDateTo1c: this.formatDate(this.includedDateTo1c),
      includedPeriodOperator1c: this.includedPeriodOperator1c,
      includedPeriodValue1c: this.includedPeriodValue1c,
      includedPeriodType1c: this.includedPeriodType1c,
      includedExclude1d: this.includedExclude1d,
      includedAnyAll1d: this.includedAnyAll1d,
      includedValueSet1d: this.includedValueSet1d,
      includedDateFrom1d: this.formatDate(this.includedDateFrom1d),
      includedDateTo1d: this.formatDate(this.includedDateTo1d),
      includedPeriodOperator1d: this.includedPeriodOperator1d,
      includedPeriodValue1d: this.includedPeriodValue1d,
      includedPeriodType1d: this.includedPeriodType1d,
      includedExclude2: this.includedExclude2,
      includedAnyAll2: this.includedAnyAll2,
      includedValueSet2: this.includedValueSet2,
      includedEarliestLatest2: this.includedEarliestLatest2,
      includedOperator2: this.includedOperator2,
      includedEntryValue2: this.includedEntryValue2,
      includedDateFrom2: this.formatDate(this.includedDateFrom2),
      includedDateTo2: this.formatDate(this.includedDateTo2),
      includedPeriodOperator2: this.includedPeriodOperator2,
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
      includedPeriodOperator2a: this.includedPeriodOperator2a,
      includedPeriodValue2a: this.includedPeriodValue2a,
      includedPeriodType2a: this.includedPeriodType2a,
      includedExclude3: this.includedExclude3,
      includedAnyAll3: this.includedAnyAll3,
      includedValueSet3: this.includedValueSet3,
      includedEarliestLatest3: this.includedEarliestLatest3,
      includedAnyAllTested3: this.includedAnyAllTested3,
      includedDateFrom3: this.formatDate(this.includedDateFrom3),
      includedDateTo3: this.formatDate(this.includedDateTo3),
      includedPeriodOperator3: this.includedPeriodOperator3,
      includedPeriodValue3: this.includedPeriodValue3,
      includedPeriodType3: this.includedPeriodType3,
      includedTestedValueSet3: this.includedTestedValueSet3,
      includedExclude3a: this.includedExclude3a,
      includedAnyAll3a: this.includedAnyAll3a,
      includedValueSet3a: this.includedValueSet3a,
      includedEarliestLatest3a: this.includedEarliestLatest3a,
      includedAnyAllTested3a: this.includedAnyAllTested3a,
      includedDateFrom3a: this.formatDate(this.includedDateFrom3a),
      includedDateTo3a: this.formatDate(this.includedDateTo3a),
      includedPeriodOperator3a: this.includedPeriodOperator3a,
      includedPeriodValue3a: this.includedPeriodValue3a,
      includedPeriodType3a: this.includedPeriodType3a,
      includedTestedValueSet3a: this.includedTestedValueSet3a,
      includedExclude4: this.includedExclude4,
      includedAnyAll4: this.includedAnyAll4,
      includedValueSet4: this.includedValueSet4,
      includedAreNot4: this.includedAreNot4,
      includedAnyAllFollowedBy4: this. includedAnyAllFollowedBy4,
      includedFollowedByValueSet4: this.includedFollowedByValueSet4,
      includedDateFrom4: this.formatDate(this.includedDateFrom4),
      includedDateTo4: this.formatDate(this.includedDateTo4),
      includedPeriodOperator4: this.includedPeriodOperator4,
      includedPeriodValue4: this.includedPeriodValue4,
      includedPeriodType4: this.includedPeriodType4,
      includedExclude5: this.includedExclude5,
      includedAnyAll5: this.includedAnyAll5,
      includedValueSet5: this.includedValueSet5,
      includedOperator5: this.includedOperator5,
      includedEntryValue5: this.includedEntryValue5,
      includedDateFrom5: this.formatDate(this.includedDateFrom5),
      includedDateTo5: this.formatDate(this.includedDateTo5),
      includedPeriodOperator5: this.includedPeriodOperator5,
      includedPeriodValue5: this.includedPeriodValue5,
      includedPeriodType5: this.includedPeriodType5,
      includedExclude5a: this.includedExclude5a,
      includedAnyAll5a: this.includedAnyAll5a,
      includedValueSet5a: this.includedValueSet5a,
      includedOperator5a: this.includedOperator5a,
      includedEntryValue5a: this.includedEntryValue5a,
      includedDateFrom5a: this.formatDate(this.includedDateFrom5a),
      includedDateTo5a: this.formatDate(this.includedDateTo5a),
      includedPeriodOperator5a: this.includedPeriodOperator5a,
      includedPeriodValue5a: this.includedPeriodValue5a,
      includedPeriodType5a: this.includedPeriodType5a,
      demographics: this.demographics,
      encounters: this.encounters,
      medication: this.medication,
      currentMedication: this.currentMedication,
      clinicalEvents: this.clinicalEvents,
      activeProblems: this.activeProblems,
      dateFromEncounters: this.dateFromEncounters,
      dateToEncounters: this.dateToEncounters,
      dateFromMedication: this.dateFromMedication,
      dateToMedication: this.dateToMedication,
      dateFromClinicalEvents: this.dateFromClinicalEvents,
      dateToClinicalEvents: this.dateToClinicalEvents,
      selectedDemographicFields: this.selectedDemographicFields,
      selectedEncounterFields: this.selectedEncounterFields,
      selectedMedicationFields: this.selectedMedicationFields,
      selectedClinicalEventFields: this.selectedClinicalEventFields,
      selectedClinicalTypes: this.selectedClinicalTypes,
      selectedEncounterValueSet: this.selectedEncounterValueSet,
      selectedMedicationValueSet: this.selectedMedicationValueSet,
      selectedClinicalEventValueSet: this.selectedClinicalEventValueSet,
      timeSeries: this.timeSeries,
      seriesTable: this.seriesTable,
      seriesField: this.seriesField,
      seriesEncounterValueSet: this.seriesEncounterValueSet,
      seriesMedicationValueSet: this.seriesMedicationValueSet,
      seriesClinicalEventValueSet: this.seriesClinicalEventValueSet,
      seriesDateFrom: this.seriesDateFrom,
      seriesDateTo: this.seriesDateTo,
      seriesPeriodOperator: this.seriesPeriodOperator,
      seriesPeriodValue: this.seriesPeriodValue,
      seriesPeriodType: this.seriesPeriodType,
      schedule: this.selectedSchedule,
      delivery: this.selectedDelivery
    };
    this.jsonQuery = JSON.stringify(query);

    if (this.denominatorQuery==undefined)
      this.denominatorQuery = '';

    if (this.includedExclude1 == '' && this.includedExclude2 == '' && this.includedExclude3 == '' && this.includedExclude4 == '' && this.includedExclude5 == '') {
      MessageBoxDialogComponent.open(this.dialog, 'Save query', 'Are you sure you want to save this query without any Advanced cohort criteria. It may result in a very large data set?', 'Yes', 'No')
        .subscribe(result => {
          if (result) {
            this.explorerService.saveQuery(this.type.trim(), this.name.trim(), this.registryName.trim(), this.denominatorQuery.trim(), this.id, this.jsonQuery)
              .subscribe(saved => {
                  this.dialogRef.close(true);
                },
                error => this.log.error('This query could not be saved.')
              );
          }
        });
    } else {
      this.explorerService.saveQuery(this.type.trim(), this.name.trim(), this.registryName.trim(), this.denominatorQuery.trim(), this.id, this.jsonQuery)
        .subscribe(saved => {
            this.dialogRef.close(true);
          },
          error => this.log.error('This query could not be saved.')
        );
    }
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
    this.seriesTableEncounter = false;
    this.seriesTableMedication = false;
    this.seriesTableObservation = false;

    if (this.seriesTable=='Encounter') {
      this.seriesMedicationValueSet = '';
      this.seriesClinicalEventValueSet = '';
      this.seriesTableEncounter = true;
    }

    else  if (this.seriesTable=='Medication') {
      this.seriesEncounterValueSet = '';
      this.seriesClinicalEventValueSet = '';
      this.seriesTableMedication = true;
    }

    else if (this.seriesTable=='Clinical events') {
      this.seriesEncounterValueSet = '';
      this.seriesMedicationValueSet = '';
      this.seriesTableObservation = true;
    }

    this.disableForm = this.type=='' || this.type==undefined ||
      this.name=='' || this.name==undefined ||
      this.registryName=='' || this.registryName==undefined ||
      this.selectedOrganisation=='' || this.selectedOrganisation==undefined ||
      this.selectedRegistration=='' || this.selectedRegistration==undefined ||
      this.selectedDelivery=='' || this.selectedDelivery==undefined ||
      this.selectedSchedule=='' || this.selectedSchedule==undefined;
  }

  addSameRule1() {
    this.select1a = true;
  }

  addSameRule1b() {
    this.select1b = true;
  }

  addSameRule1c() {
    this.select1c = true;
  }

  addSameRule1d() {
    this.select1d = true;
  }

  addSameRule2() {
    this.select2a = true;
  }

  addSameRule3() {
    this.select3a = true;
  }

  addSameRule5() {
    this.select5a = true;
  }


}
