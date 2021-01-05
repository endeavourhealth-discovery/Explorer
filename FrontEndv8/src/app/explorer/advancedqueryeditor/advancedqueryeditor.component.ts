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
  withWithout1: string;
  includedValueSet1: string;
  includedDateFrom1: string;
  includedDateTo1: string;
  includedPeriodOperator1: string;
  includedPeriodValue1: string;
  includedPeriodType1: string;
  includedAnyAll1: string;
  withWithout1a: string;
  includedValueSet1a: string;
  includedDateFrom1a: string;
  includedDateTo1a: string;
  includedPeriodOperator1a: string;
  includedPeriodValue1a: string;
  includedPeriodType1a: string;
  includedAnyAll1a: string;
  withWithout1b: string;
  includedValueSet1b: string;
  includedDateFrom1b: string;
  includedDateTo1b: string;
  includedPeriodOperator1b: string;
  includedPeriodValue1b: string;
  includedPeriodType1b: string;
  includedAnyAll1b: string;
  withWithout1c: string;
  includedValueSet1c: string;
  includedDateFrom1c: string;
  includedDateTo1c: string;
  includedPeriodOperator1c: string;
  includedPeriodValue1c: string;
  includedPeriodType1c: string;
  includedAnyAll1c: string;
  withWithout1d: string;
  includedValueSet1d: string;
  includedDateFrom1d: string;
  includedDateTo1d: string;
  includedPeriodOperator1d: string;
  includedPeriodValue1d: string;
  includedPeriodType1d: string;
  includedAnyAll1d: string;
  withWithout2: string;
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
  withWithout2a: string;
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
  withWithout3: string;
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
  withWithout3a: string;
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
  withWithout4: string;
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
  withWithout5: string;
  includedValueSet5: string;
  includedOperator5: string;
  includedEntryValue5: string;
  includedDateFrom5: string;
  includedDateTo5: string;
  includedPeriodOperator5: string;
  includedPeriodValue5: string;
  includedPeriodType5: string;
  includedAnyAll5: string;
  withWithout5a: string;
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

  matching1: string;
  queryExpression1: string;
  selectReject2: string;
  matching2: string;
  queryExpression2: string;
  ruleNumber2: string;
  selectReject3: string;
  matching3: string;
  queryExpression3: string;
  ruleNumber3: string;
  selectReject4: string;
  matching4: string;
  queryExpression4: string;
  ruleNumber4: string;
  selectReject5: string;
  matching5: string;
  queryExpression5: string;
  ruleNumber5: string;
  selectReject6: string;
  matching6: string;
  queryExpression6: string;
  ruleNumber6: string;
  selectReject7: string;
  matching7: string;
  queryExpression7: string;
  ruleNumber7: string;
  selectReject8: string;
  matching8: string;
  queryExpression8: string;
  ruleNumber8: string;
  selectReject9: string;
  matching9: string;
  queryExpression9: string;
  ruleNumber9: string;
  selectReject10: string;
  matching10: string;
  queryExpression10: string;
  ruleNumber10: string;
  selectReject11: string;
  matching11: string;
  queryExpression11: string;
  ruleNumber11: string;
  selectReject12: string;
  matching12: string;
  queryExpression12: string;
  ruleNumber12: string;
  selectReject13: string;
  matching13: string;
  queryExpression13: string;
  ruleNumber13: string;
  selectReject14: string;
  matching14: string;
  queryExpression14: string;
  ruleNumber14: string;
  selectReject15: string;
  matching15: string;
  queryExpression15: string;
  ruleNumber15: string;
  selectReject16: string;
  matching16: string;
  queryExpression16: string;
  ruleNumber16: string;

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

interface without {
  without: string;
}

interface matching {
  matching: string;
}

interface selectreject {
  selectreject: string;
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
  registrationDateFrom: string = '';
  registrationDateTo: string = '';
  registrationPeriodValue: string= '';
  registrationPeriodType: string= '';
  ageFrom: string = '';
  ageTo: string = '';
  selectedGender: string = '';
  postcode: string = '';

  withWithout1: string = '';
  includedValueSet1: string = '';
  includedDateFrom1: string = '';
  includedDateTo1: string = '';
  includedPeriodOperator1: string = '';
  includedPeriodValue1: string = '';
  includedPeriodType1: string = '';
  includedAnyAll1: string = '';
  withWithout1a: string = '';
  includedValueSet1a: string = '';
  includedDateFrom1a: string = '';
  includedDateTo1a: string = '';
  includedPeriodOperator1a: string = '';
  includedPeriodValue1a: string = '';
  includedPeriodType1a: string = '';
  includedAnyAll1a: string = '';
  withWithout1b: string = '';
  includedValueSet1b: string = '';
  includedDateFrom1b: string = '';
  includedDateTo1b: string = '';
  includedPeriodOperator1b: string = '';
  includedPeriodValue1b: string = '';
  includedPeriodType1b: string = '';
  includedAnyAll1b: string = '';
  withWithout1c: string = '';
  includedValueSet1c: string = '';
  includedDateFrom1c: string = '';
  includedDateTo1c: string = '';
  includedPeriodOperator1c: string = '';
  includedPeriodValue1c: string = '';
  includedPeriodType1c: string = '';
  includedAnyAll1c: string = '';
  withWithout1d: string = '';
  includedValueSet1d: string = '';
  includedDateFrom1d: string = '';
  includedDateTo1d: string = '';
  includedPeriodOperator1d: string = '';
  includedPeriodValue1d: string = '';
  includedPeriodType1d: string = '';
  includedAnyAll1d: string = '';
  withWithout2: string = '';
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
  withWithout2a: string = '';
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
  withWithout3: string = '';
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
  withWithout3a: string = '';
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
  withWithout4: string = '';
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
  withWithout5: string = '';
  includedValueSet5: string = '';
  includedOperator5: string = '';
  includedEntryValue5: string = '';
  includedDateFrom5: string = '';
  includedDateTo5: string = '';
  includedPeriodOperator5: string = '';
  includedPeriodValue5: string = '';
  includedPeriodType5: string = '';
  includedAnyAll5: string = '';
  withWithout5a: string = '';
  includedValueSet5a: string = '';
  includedOperator5a: string = '';
  includedEntryValue5a: string = '';
  includedDateFrom5a: string = '';
  includedDateTo5a: string = '';
  includedPeriodOperator5a: string = '';
  includedPeriodValue5a: string = '';
  includedPeriodType5a: string = '';
  includedAnyAll5a: string = '';

  matching1: string = '';
  queryExpression1: string = '';
  selectReject2: string = '';
  matching2: string = '';
  queryExpression2: string = '';
  ruleNumber2: string = '';
  selectReject3: string = '';
  matching3: string = '';
  queryExpression3: string = '';
  ruleNumber3: string = '';
  selectReject4: string = '';
  matching4: string = '';
  queryExpression4: string = '';
  ruleNumber4: string = '';
  selectReject5: string = '';
  matching5: string = '';
  queryExpression5: string = '';
  ruleNumber5: string = '';
  selectReject6: string = '';
  matching6: string = '';
  queryExpression6: string = '';
  ruleNumber6: string = '';
  selectReject7: string = '';
  matching7: string = '';
  queryExpression7: string = '';
  ruleNumber7: string = '';
  selectReject8: string = '';
  matching8: string = '';
  queryExpression8: string = '';
  ruleNumber8: string = '';
  selectReject9: string = '';
  matching9: string = '';
  queryExpression9: string = '';
  ruleNumber9: string = '';
  selectReject10: string = '';
  matching10: string = '';
  queryExpression10: string = '';
  ruleNumber10: string = '';
  selectReject11: string = '';
  matching11: string = '';
  queryExpression11: string = '';
  ruleNumber11: string = '';
  selectReject12: string = '';
  matching12: string = '';
  queryExpression12: string = '';
  ruleNumber12: string = '';
  selectReject13: string = '';
  matching13: string = '';
  queryExpression13: string = '';
  ruleNumber13: string = '';
  selectReject14: string = '';
  matching14: string = '';
  queryExpression14: string = '';
  ruleNumber14: string = '';
  selectReject15: string = '';
  matching15: string = '';
  queryExpression15: string = '';
  ruleNumber15: string = '';
  selectReject16: string = '';
  matching16: string = '';
  queryExpression16: string = '';
  ruleNumber16: string = '';

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

  dateFromEncounters: string = '';
  dateToEncounters: string = '';
  dateFromMedication: string = '';
  dateToMedication: string = '';
  dateFromClinicalEvents: string = '';
  dateToClinicalEvents: string = '';
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
  sixthFormGroup: FormGroup;

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

  rule1: boolean = false;
  addRule1: boolean = true;
  rule2: boolean = false;
  addRule2: boolean = true;
  rule3: boolean = false;
  addRule3: boolean = true;
  rule4: boolean = false;
  addRule4: boolean = true;
  rule5: boolean = false;
  addRule5: boolean = true;
  rule6: boolean = false;
  addRule6: boolean = true;
  rule7: boolean = false;
  addRule7: boolean = true;
  rule8: boolean = false;
  addRule8: boolean = true;
  rule9: boolean = false;
  addRule9: boolean = true;
  rule10: boolean = false;
  addRule10: boolean = true;
  rule11: boolean = false;
  addRule11: boolean = true;
  rule12: boolean = false;
  addRule12: boolean = true;
  rule13: boolean = false;
  addRule13: boolean = true;
  rule14: boolean = false;
  addRule14: boolean = true;
  rule15: boolean = false;
  addRule15: boolean = true;

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
  without: without[] = [
    {without: ''},
    {without: 'with'},
    {without: 'without'}
  ];
  matching: matching[] = [
    {matching: ''},
    {matching: 'matching'},
    {matching: 'not matching'}
  ];
  selectreject: selectreject[] = [
    {selectreject: ''},
    {selectreject: 'Select'},
    {selectreject: 'Reject'}
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
      this.withWithout1 = query.withWithout1;
      this.includedValueSet1 = query.includedValueSet1;
      this.includedDateFrom1 = query.includedDateFrom1;
      this.includedDateTo1 = query.includedDateTo1;
      this.includedPeriodOperator1 = query.includedPeriodOperator1;
      this.includedPeriodValue1 = query.includedPeriodValue1;
      this.includedPeriodType1 = query.includedPeriodType1;
      this.includedAnyAll1 = query.includedAnyAll1;
      this.withWithout1a = query.withWithout1a;
      this.includedValueSet1a = query.includedValueSet1a;
      this.includedDateFrom1a = query.includedDateFrom1a;
      this.includedDateTo1a = query.includedDateTo1a;
      this.includedPeriodOperator1a = query.includedPeriodOperator1a;
      this.includedPeriodValue1a = query.includedPeriodValue1a;
      this.includedPeriodType1a = query.includedPeriodType1a;
      this.includedAnyAll1a = query.includedAnyAll1a;
      this.withWithout1b = query.withWithout1b;
      this.includedValueSet1b = query.includedValueSet1b;
      this.includedDateFrom1b = query.includedDateFrom1b;
      this.includedDateTo1b = query.includedDateTo1b;
      this.includedPeriodOperator1b = query.includedPeriodOperator1b;
      this.includedPeriodValue1b = query.includedPeriodValue1b;
      this.includedPeriodType1b = query.includedPeriodType1b;
      this.includedAnyAll1b = query.includedAnyAll1b;
      this.withWithout1c = query.withWithout1c;
      this.includedValueSet1c = query.includedValueSet1c;
      this.includedDateFrom1c = query.includedDateFrom1c;
      this.includedDateTo1c = query.includedDateTo1c;
      this.includedPeriodOperator1c = query.includedPeriodOperator1c;
      this.includedPeriodValue1c = query.includedPeriodValue1c;
      this.includedPeriodType1c = query.includedPeriodType1c;
      this.includedAnyAll1c = query.includedAnyAll1c;
      this.withWithout1d = query.withWithout1d;
      this.includedValueSet1d = query.includedValueSet1d;
      this.includedDateFrom1d = query.includedDateFrom1d;
      this.includedDateTo1d = query.includedDateTo1d;
      this.includedPeriodOperator1d = query.includedPeriodOperator1d;
      this.includedPeriodValue1d = query.includedPeriodValue1d;
      this.includedPeriodType1d = query.includedPeriodType1d;
      this.includedAnyAll1d = query.includedAnyAll1d;
      this.withWithout2 = query.withWithout2;
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
      this.withWithout2a = query.withWithout2a;
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
      this.withWithout3 = query.withWithout3;
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
      this.withWithout3a = query.withWithout3a;
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
      this.withWithout4 = query.withWithout4;
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
      this.withWithout5 = query.withWithout5;
      this.includedValueSet5 = query.includedValueSet5;
      this.includedOperator5 = query.includedOperator5;
      this.includedEntryValue5 = query.includedEntryValue5;
      this.includedDateFrom5 = query.includedDateFrom5;
      this.includedDateTo5 = query.includedDateTo5;
      this.includedPeriodOperator5 = query.includedPeriodOperator5;
      this.includedPeriodValue5 = query.includedPeriodValue5;
      this.includedPeriodType5 = query.includedPeriodType5;
      this.includedAnyAll5 = query.includedAnyAll5;
      this.withWithout5a = query.withWithout5a;
      this.includedValueSet5a = query.includedValueSet5a;
      this.includedOperator5a = query.includedOperator5a;
      this.includedEntryValue5a = query.includedEntryValue5a;
      this.includedDateFrom5a = query.includedDateFrom5a;
      this.includedDateTo5a = query.includedDateTo5a;
      this.includedPeriodOperator5a = query.includedPeriodOperator5a;
      this.includedPeriodValue5a = query.includedPeriodValue5a;
      this.includedPeriodType5a = query.includedPeriodType5a;
      this.includedAnyAll5a = query.includedAnyAll5a;

      this.matching1 = query.matching1;
      this.queryExpression1 = query.queryExpression1;
      this.selectReject2 = query.selectReject2;
      this.matching2 = query.matching2;
      this.queryExpression2 = query.queryExpression2;
      this.ruleNumber2 = query.ruleNumber2;
      this.selectReject3 = query.selectReject3;
      this.matching3 = query.matching3;
      this.queryExpression3 = query.queryExpression3;
      this.ruleNumber3 = query.ruleNumber3;
      this.selectReject4 = query.selectReject4;
      this.matching4 = query.matching4;
      this.queryExpression4 = query.queryExpression4;
      this.ruleNumber4 = query.ruleNumber4;
      this.selectReject5 = query.selectReject5;
      this.matching5 = query.matching5;
      this.queryExpression5 = query.queryExpression5;
      this.ruleNumber5 = query.ruleNumber5;
      this.selectReject6 = query.selectReject6;
      this.matching6 = query.matching6;
      this.queryExpression6 = query.queryExpression6;
      this.ruleNumber6 = query.ruleNumber6;
      this.selectReject7 = query.selectReject7;
      this.matching7 = query.matching7;
      this.queryExpression7 = query.queryExpression7;
      this.ruleNumber7 = query.ruleNumber7;
      this.selectReject8 = query.selectReject8;
      this.matching8 = query.matching8;
      this.queryExpression8 = query.queryExpression8;
      this.ruleNumber8 = query.ruleNumber8;
      this.selectReject9 = query.selectReject9;
      this.matching9 = query.matching9;
      this.queryExpression9 = query.queryExpression9;
      this.ruleNumber9 = query.ruleNumber9;
      this.selectReject10 = query.selectReject10;
      this.matching10 = query.matching10;
      this.queryExpression10 = query.queryExpression10;
      this.ruleNumber10 = query.ruleNumber10;
      this.selectReject11 = query.selectReject11;
      this.matching11 = query.matching11;
      this.queryExpression11 = query.queryExpression11;
      this.ruleNumber11 = query.ruleNumber11;
      this.selectReject12 = query.selectReject12;
      this.matching12 = query.matching12;
      this.queryExpression12 = query.queryExpression12;
      this.ruleNumber12 = query.ruleNumber12;
      this.selectReject13 = query.selectReject13;
      this.matching13 = query.matching13;
      this.queryExpression13 = query.queryExpression13;
      this.ruleNumber13 = query.ruleNumber13;
      this.selectReject14 = query.selectReject14;
      this.matching14 = query.matching14;
      this.queryExpression14 = query.queryExpression14;
      this.ruleNumber14 = query.ruleNumber14;
      this.selectReject15 = query.selectReject15;
      this.matching15 = query.matching15;
      this.queryExpression15 = query.queryExpression15;
      this.ruleNumber15 = query.ruleNumber15;
      this.selectReject16 = query.selectReject16;
      this.matching16 = query.matching16;
      this.queryExpression16 = query.queryExpression16;
      this.ruleNumber16 = query.ruleNumber16;

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

      if (this.withWithout1a != "" && this.withWithout1a!=undefined) {
        this.select1a = true;
        this.addQuery1 = false;
      }

      if (this.withWithout1b != "" && this.withWithout1b!=undefined) {
        this.select1b = true;
        this.addQuery1b = false;
      }

      if (this.withWithout1c != "" && this.withWithout1c!=undefined) {
        this.select1c = true;
        this.addQuery1c = false;
      }

      if (this.withWithout1d != "" && this.withWithout1d!=undefined) {
        this.select1d = true;
        this.addQuery1d = false;
      }

      if (this.withWithout2a != "" && this.withWithout2a!=undefined) {
        this.select2a = true;
        this.addQuery2 = false;
      }
      if (this.withWithout3a != "" && this.withWithout3a!=undefined) {
        this.select3a = true;
        this.addQuery3 = false;
      }
      if (this.withWithout5a != "" && this.withWithout5a!=undefined) {
        this.select5a = true;
        this.addQuery5 = false;
      }

      if (this.selectReject2 != "" && this.selectReject2!=undefined) {
        this.rule1 = true;
        this.addRule1 = false;
      }
      if (this.selectReject3 != ""  && this.selectReject3!=undefined) {
        this.rule2 = true;
        this.addRule2 = false;
      }
      if (this.selectReject4 != ""  && this.selectReject4!=undefined) {
        this.rule3 = true;
        this.addRule3 = false;
      }
      if (this.selectReject5 != ""  && this.selectReject5!=undefined) {
        this.rule4 = true;
        this.addRule4 = false;
      }
      if (this.selectReject6 != ""  && this.selectReject6!=undefined) {
        this.rule5 = true;
        this.addRule5 = false;
      }
      if (this.selectReject7 != ""  && this.selectReject7!=undefined) {
        this.rule6 = true;
        this.addRule6 = false;
      }
      if (this.selectReject8 != ""  && this.selectReject8!=undefined) {
        this.rule7 = true;
        this.addRule7 = false;
      }
      if (this.selectReject9 != ""  && this.selectReject9!=undefined) {
        this.rule8 = true;
        this.addRule8 = false;
      }
      if (this.selectReject10 != ""  && this.selectReject10!=undefined) {
        this.rule9 = true;
        this.addRule9 = false;
      }
      if (this.selectReject11 != ""  && this.selectReject11!=undefined) {
        this.rule10 = true;
        this.addRule10 = false;
      }
      if (this.selectReject12 != ""  && this.selectReject12!=undefined) {
        this.rule11 = true;
        this.addRule11 = false;
      }
      if (this.selectReject13 != ""  && this.selectReject13!=undefined) {
        this.rule12 = true;
        this.addRule12 = false;
      }
      if (this.selectReject14 != ""  && this.selectReject14!=undefined) {
        this.rule13 = true;
        this.addRule13 = false;
      }
      if (this.selectReject15 != ""  && this.selectReject15!=undefined) {
        this.rule14 = true;
        this.addRule14 = false;
      }
      if (this.selectReject16 != ""  && this.selectReject16!=undefined) {
        this.rule15 = true;
        this.addRule15 = false;
      }
    }

    this.firstFormGroup = this._formBuilder.group({
      control1: ['', Validators.required], control2: ['', Validators.required], control157: [''], control158: [''], control159: ['']
    });
    this.secondFormGroup = this._formBuilder.group({
      control17: [''], control3: ['', Validators.required], control4: ['', Validators.required], control6: [''], control7: [''], control8: [''], control9: ['']
    });
    this.thirdFormGroup = this._formBuilder.group({
      control5: [''], control5a: [''], control5b: [''], control20: [''], control21: [''],
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
      control170: [''], control171: [''],
        control172: [''], control173: [''],control174: [''],control175: [''],
        control172a: [''], control173a: [''],control174a: [''],control175a: [''],
      control172b: [''], control173b: [''],control174b: [''],control175b: [''],
      control172c: [''], control173c: [''],control174c: [''],control175c: [''],
      control172d: [''], control173d: [''],control174d: [''],control175d: [''],
      control172e: [''], control173e: [''],control174e: [''],control175e: [''],
      control172f: [''], control173f: [''],control174f: [''],control175f: [''],
      control172g: [''], control173g: [''],control174g: [''],control175g: [''],
      control172h: [''], control173h: [''],control174h: [''],control175h: [''],
      control172i: [''], control173i: [''],control174i: [''],control175i: [''],
      control172j: [''], control173j: [''],control174j: [''],control175j: [''],
      control172k: [''], control173k: [''],control174k: [''],control175k: [''],
      control172l: [''], control173l: [''],control174l: [''],control175l: [''],
      control172m: [''], control173m: [''],control174m: [''],control175m: [''],
      control172n: [''], control173n: [''],control174n: [''],control175n: ['']
    });
    this.fifthFormGroup = this._formBuilder.group({
      control165a: [''],  control165e: [''], control166a: [''], control166c: [''], control166d: [''], control166e: [''], control166g: [''], control167a: [''],
      control167b: [''], control167c: [''], control167d: [''], control167e: [''], control167g: [''], control168a: [''], control168b: [''], control168c: [''], control168d: [''],
      control168e: [''], control168f: [''], control168g: [''], control70: [''], control71: [''], control72: [''], control73: [''], control74: [''], control75: [''], control76: [''],
      control77: [''], control78: [''], control79: [''], control80: ['']
    });
    this.sixthFormGroup = this._formBuilder.group({
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
      withWithout1: this.withWithout1,
      includedAnyAll1: this.includedAnyAll1,
      includedValueSet1: this.includedValueSet1,
      includedDateFrom1: this.formatDate(this.includedDateFrom1),
      includedDateTo1: this.formatDate(this.includedDateTo1),
      includedPeriodOperator1: this.includedPeriodOperator1,
      includedPeriodValue1: this.includedPeriodValue1,
      includedPeriodType1: this.includedPeriodType1,
      withWithout1a: this.withWithout1a,
      includedAnyAll1a: this.includedAnyAll1a,
      includedValueSet1a: this.includedValueSet1a,
      includedDateFrom1a: this.formatDate(this.includedDateFrom1a),
      includedDateTo1a: this.formatDate(this.includedDateTo1a),
      includedPeriodOperator1a: this.includedPeriodOperator1a,
      includedPeriodValue1a: this.includedPeriodValue1a,
      includedPeriodType1a: this.includedPeriodType1a,
      withWithout1b: this.withWithout1b,
      includedAnyAll1b: this.includedAnyAll1b,
      includedValueSet1b: this.includedValueSet1b,
      includedDateFrom1b: this.formatDate(this.includedDateFrom1b),
      includedDateTo1b: this.formatDate(this.includedDateTo1b),
      includedPeriodOperator1b: this.includedPeriodOperator1b,
      includedPeriodValue1b: this.includedPeriodValue1b,
      includedPeriodType1b: this.includedPeriodType1b,
      withWithout1c: this.withWithout1c,
      includedAnyAll1c: this.includedAnyAll1c,
      includedValueSet1c: this.includedValueSet1c,
      includedDateFrom1c: this.formatDate(this.includedDateFrom1c),
      includedDateTo1c: this.formatDate(this.includedDateTo1c),
      includedPeriodOperator1c: this.includedPeriodOperator1c,
      includedPeriodValue1c: this.includedPeriodValue1c,
      includedPeriodType1c: this.includedPeriodType1c,
      withWithout1d: this.withWithout1d,
      includedAnyAll1d: this.includedAnyAll1d,
      includedValueSet1d: this.includedValueSet1d,
      includedDateFrom1d: this.formatDate(this.includedDateFrom1d),
      includedDateTo1d: this.formatDate(this.includedDateTo1d),
      includedPeriodOperator1d: this.includedPeriodOperator1d,
      includedPeriodValue1d: this.includedPeriodValue1d,
      includedPeriodType1d: this.includedPeriodType1d,
      withWithout2: this.withWithout2,
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
      withWithout2a: this.withWithout2a,
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
      withWithout3: this.withWithout3,
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
      withWithout3a: this.withWithout3a,
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
      withWithout4: this.withWithout4,
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
      withWithout5: this.withWithout5,
      includedAnyAll5: this.includedAnyAll5,
      includedValueSet5: this.includedValueSet5,
      includedOperator5: this.includedOperator5,
      includedEntryValue5: this.includedEntryValue5,
      includedDateFrom5: this.formatDate(this.includedDateFrom5),
      includedDateTo5: this.formatDate(this.includedDateTo5),
      includedPeriodOperator5: this.includedPeriodOperator5,
      includedPeriodValue5: this.includedPeriodValue5,
      includedPeriodType5: this.includedPeriodType5,
      withWithout5a: this.withWithout5a,
      includedAnyAll5a: this.includedAnyAll5a,
      includedValueSet5a: this.includedValueSet5a,
      includedOperator5a: this.includedOperator5a,
      includedEntryValue5a: this.includedEntryValue5a,
      includedDateFrom5a: this.formatDate(this.includedDateFrom5a),
      includedDateTo5a: this.formatDate(this.includedDateTo5a),
      includedPeriodOperator5a: this.includedPeriodOperator5a,
      includedPeriodValue5a: this.includedPeriodValue5a,
      includedPeriodType5a: this.includedPeriodType5a,
      matching1 : this.matching1,
      queryExpression1 : this.queryExpression1,
      selectReject2 : this.selectReject2,
      matching2 : this.matching2,
      queryExpression2 : this.queryExpression2,
      ruleNumber2 : this.ruleNumber2,
      selectReject3 : this.selectReject3,
      matching3 : this.matching3,
      queryExpression3 : this.queryExpression3,
      ruleNumber3 : this.ruleNumber3,
      selectReject4 : this.selectReject4,
      matching4 : this.matching4,
      queryExpression4 : this.queryExpression4,
      ruleNumber4 : this.ruleNumber4,
      selectReject5 : this.selectReject5,
      matching5 : this.matching5,
      queryExpression5 : this.queryExpression5,
      ruleNumber5 : this.ruleNumber5,
      selectReject6 : this.selectReject6,
      matching6 : this.matching6,
      queryExpression6 : this.queryExpression6,
      ruleNumber6 : this.ruleNumber6,
      selectReject7 : this.selectReject7,
      matching7 : this.matching7,
      queryExpression7 : this.queryExpression7,
      ruleNumber7 : this.ruleNumber7,
      selectReject8 : this.selectReject8,
      matching8 : this.matching8,
      queryExpression8 : this.queryExpression8,
      ruleNumber8 : this.ruleNumber8,
      selectReject9 : this.selectReject9,
      matching9 : this.matching9,
      queryExpression9 : this.queryExpression9,
      ruleNumber9 : this.ruleNumber9,
      selectReject10 : this.selectReject10,
      matching10 : this.matching10,
      queryExpression10 : this.queryExpression10,
      ruleNumber10 : this.ruleNumber10,
      selectReject11 : this.selectReject11,
      matching11 : this.matching11,
      queryExpression11 : this.queryExpression11,
      ruleNumber11 : this.ruleNumber11,
      selectReject12 : this.selectReject12,
      matching12 : this.matching12,
      queryExpression12 : this.queryExpression12,
      ruleNumber12 : this.ruleNumber12,
      selectReject13 : this.selectReject13,
      matching13 : this.matching13,
      queryExpression13 : this.queryExpression13,
      ruleNumber13 : this.ruleNumber13,
      selectReject14 : this.selectReject14,
      matching14 : this.matching14,
      queryExpression14 : this.queryExpression14,
      ruleNumber14 : this.ruleNumber14,
      selectReject15 : this.selectReject15,
      matching15 : this.matching15,
      queryExpression15 : this.queryExpression15,
      ruleNumber15 : this.ruleNumber15,
      selectReject16 : this.selectReject16,
      matching16 : this.matching16,
      queryExpression16 : this.queryExpression16,
      ruleNumber16 : this.ruleNumber16,
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

    this.jsonQuery = this.jsonQuery.replace(/\:"NaN-NaN-NaN"/gi, "\:\"\"");

    if (this.denominatorQuery==undefined)
      this.denominatorQuery = '';

    if (this.withWithout1 == '' && this.withWithout2 == '' && this.withWithout3 == '' && this.withWithout4 == '' && this.withWithout5 == '') {
      MessageBoxDialogComponent.open(this.dialog, 'Save query', 'Are you sure you want to save this query without any query criteria. It may result in a very large data set?', 'Yes', 'No')
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
      this.selectedOrganisation=='' || this.selectedOrganisation==undefined ||
      this.selectedRegistration=='' || this.selectedRegistration==undefined ||
      this.selectedDelivery=='' || this.selectedDelivery==undefined ||
      this.selectedSchedule=='' || this.selectedSchedule==undefined;
  }

  addSameQuery1() {
    this.select1a = true;
  }

  addSameQuery1b() {
    this.select1b = true;
  }

  addSameQuery1c() {
    this.select1c = true;
  }

  addSameQuery1d() {
    this.select1d = true;
  }

  addSameQuery2() {
    this.select2a = true;
  }

  addSameQuery3() {
    this.select3a = true;
  }

  addSameQuery5() {
    this.select5a = true;
  }

  addSameRule1() {
    this.rule1 = true;
  }

  addSameRule2() {
    this.rule2 = true;
  }

  addSameRule3() {
    this.rule3 = true;
  }

  addSameRule4() {
    this.rule4 = true;
  }

  addSameRule5() {
    this.rule5 = true;
  }

  addSameRule6() {
    this.rule6 = true;
  }

  addSameRule7() {
    this.rule7 = true;
  }

  addSameRule8() {
    this.rule8 = true;
  }

  addSameRule9() {
    this.rule9 = true;
  }

  addSameRule10() {
    this.rule10 = true;
  }

  addSameRule11() {
    this.rule11 = true;
  }

  addSameRule12() {
    this.rule12 = true;
  }

  addSameRule13() {
    this.rule13 = true;
  }

  addSameRule14() {
    this.rule14 = true;
  }

  addSameRule15() {
    this.rule15 = true;
  }

}
