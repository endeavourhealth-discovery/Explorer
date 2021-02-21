import {Component, Inject, Injectable, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {STEPPER_GLOBAL_OPTIONS} from "@angular/cdk/stepper";
import {takeUntil} from "rxjs/operators";
import {BehaviorSubject, ReplaySubject, Subject} from "rxjs";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {Router} from "@angular/router";
import {MatTreeFlatDataSource, MatTreeFlattener} from "@angular/material/tree";
import {FlatTreeControl} from "@angular/cdk/tree";
import {SelectionModel} from "@angular/cdk/collections";

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
  registrationStatus: string;
  ageFrom: string;
  ageTo: string;
  ageFrom1: string;
  ageTo1: string;
  ageFrom2: string;
  ageTo2: string;
  ageFrom3: string;
  ageTo3: string;
  ageFrom4: string;
  ageTo4: string;
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
  withWithout1e: string;
  includedValueSet1e: string;
  includedDateFrom1e: string;
  includedDateTo1e: string;
  includedPeriodOperator1e: string;
  includedPeriodValue1e: string;
  includedPeriodType1e: string;
  includedAnyAll1e: string;
  withWithout1f: string;
  includedValueSet1f: string;
  includedDateFrom1f: string;
  includedDateTo1f: string;
  includedPeriodOperator1f: string;
  includedPeriodValue1f: string;
  includedPeriodType1f: string;
  includedAnyAll1f: string;
  withWithout1g: string;
  includedValueSet1g: string;
  includedDateFrom1g: string;
  includedDateTo1g: string;
  includedPeriodOperator1g: string;
  includedPeriodValue1g: string;
  includedPeriodType1g: string;
  includedAnyAll1g: string;
  withWithout1h: string;
  includedValueSet1h: string;
  includedDateFrom1h: string;
  includedDateTo1h: string;
  includedPeriodOperator1h: string;
  includedPeriodValue1h: string;
  includedPeriodType1h: string;
  includedAnyAll1h: string;
  withWithout1i: string;
  includedValueSet1i: string;
  includedDateFrom1i: string;
  includedDateTo1i: string;
  includedPeriodOperator1i: string;
  includedPeriodValue1i: string;
  includedPeriodType1i: string;
  includedAnyAll1i: string;
  withWithout1j: string;
  includedValueSet1j: string;
  includedDateFrom1j: string;
  includedDateTo1j: string;
  includedPeriodOperator1j: string;
  includedPeriodValue1j: string;
  includedPeriodType1j: string;
  includedAnyAll1j: string;
  withWithout1k: string;
  includedValueSet1k: string;
  includedDateFrom1k: string;
  includedDateTo1k: string;
  includedPeriodOperator1k: string;
  includedPeriodValue1k: string;
  includedPeriodType1k: string;
  includedAnyAll1k: string;
  withWithout1l: string;
  includedValueSet1l: string;
  includedDateFrom1l: string;
  includedDateTo1l: string;
  includedPeriodOperator1l: string;
  includedPeriodValue1l: string;
  includedPeriodType1l: string;
  includedAnyAll1l: string;
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
  withWithout2b: string;
  includedValueSet2b: string;
  includedEarliestLatest2b: string;
  includedOperator2b: string;
  includedEntryValue2b: string;
  includedAnyAll2b: string;
  includedDateFrom2b: string;
  includedDateTo2b: string;
  includedPeriodOperator2b: string;
  includedPeriodValue2b: string;
  includedPeriodType2b: string;
  withWithout2c: string;
  includedValueSet2c: string;
  includedEarliestLatest2c: string;
  includedOperator2c: string;
  includedEntryValue2c: string;
  includedAnyAll2c: string;
  includedDateFrom2c: string;
  includedDateTo2c: string;
  includedPeriodOperator2c: string;
  includedPeriodValue2c: string;
  includedPeriodType2c: string;
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
  includedDob3: string;
  includedDiagnosisAnyAll3: string;
  includedDiagnosisValueSet3: string;
  includedDiagnosisAgeFrom3: string;
  includedDiagnosisAgeTo3: string;
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
  includedDob3a: string;
  includedDiagnosisAnyAll3a: string;
  includedDiagnosisValueSet3a: string;
  includedDiagnosisAgeFrom3a: string;
  includedDiagnosisAgeTo3a: string;
  withWithout3b: string;
  includedValueSet3b: string;
  includedEarliestLatest3b: string;
  includedTestedValueSet3b: string;
  includedAnyAll3b: string;
  includedAnyAllTested3b: string;
  includedDateFrom3b: string;
  includedDateTo3b: string;
  includedPeriodOperator3b: string;
  includedPeriodValue3b: string;
  includedPeriodType3b: string;
  includedDob3b: string;
  includedDiagnosisAnyAll3b: string;
  includedDiagnosisValueSet3b: string;
  includedDiagnosisAgeFrom3b: string;
  includedDiagnosisAgeTo3b: string;
  withWithout3c: string;
  includedValueSet3c: string;
  includedEarliestLatest3c: string;
  includedTestedValueSet3c: string;
  includedAnyAll3c: string;
  includedAnyAllTested3c: string;
  includedDateFrom3c: string;
  includedDateTo3c: string;
  includedPeriodOperator3c: string;
  includedPeriodValue3c: string;
  includedPeriodType3c: string;
  includedDob3c: string;
  includedDiagnosisAnyAll3c: string;
  includedDiagnosisValueSet3c: string;
  includedDiagnosisAgeFrom3c: string;
  includedDiagnosisAgeTo3c: string;
  withWithout3d: string;
  includedValueSet3d: string;
  includedEarliestLatest3d: string;
  includedTestedValueSet3d: string;
  includedAnyAll3d: string;
  includedAnyAllTested3d: string;
  includedDateFrom3d: string;
  includedDateTo3d: string;
  includedPeriodOperator3d: string;
  includedPeriodValue3d: string;
  includedPeriodType3d: string;
  includedDob3d: string;
  includedDiagnosisAnyAll3d: string;
  includedDiagnosisValueSet3d: string;
  includedDiagnosisAgeFrom3d: string;
  includedDiagnosisAgeTo3d: string;
  withWithout3e: string;
  includedValueSet3e: string;
  includedEarliestLatest3e: string;
  includedTestedValueSet3e: string;
  includedAnyAll3e: string;
  includedAnyAllTested3e: string;
  includedDateFrom3e: string;
  includedDateTo3e: string;
  includedPeriodOperator3e: string;
  includedPeriodValue3e: string;
  includedPeriodType3e: string;
  includedDob3e: string;
  includedDiagnosisAnyAll3e: string;
  includedDiagnosisValueSet3e: string;
  includedDiagnosisAgeFrom3e: string;
  includedDiagnosisAgeTo3e: string;
  withWithout3f: string;
  includedValueSet3f: string;
  includedEarliestLatest3f: string;
  includedTestedValueSet3f: string;
  includedAnyAll3f: string;
  includedAnyAllTested3f: string;
  includedDateFrom3f: string;
  includedDateTo3f: string;
  includedPeriodOperator3f: string;
  includedPeriodValue3f: string;
  includedPeriodType3f: string;
  includedDob3f: string;
  includedDiagnosisAnyAll3f: string;
  includedDiagnosisValueSet3f: string;
  includedDiagnosisAgeFrom3f: string;
  includedDiagnosisAgeTo3f: string;

  withWithout4: string;
  includedValueSet4: string;
  includedFollowedByValueSet4: string;
  includedPeriodOperator4: string;
  includedPeriodValue4: string;
  includedPeriodType4: string;
  includedAnyAll4: string;
  includedAnyAllFollowedBy4: string;
  includedAreNot4: string;
  withWithout4a: string;
  includedValueSet4a: string;
  includedFollowedByValueSet4a: string;
  includedPeriodOperator4a: string;
  includedPeriodValue4a: string;
  includedPeriodType4a: string;
  includedAnyAll4a: string;
  includedAnyAllFollowedBy4a: string;
  includedAreNot4a: string;
  withWithout4b: string;
  includedValueSet4b: string;
  includedFollowedByValueSet4b: string;
  includedPeriodOperator4b: string;
  includedPeriodValue4b: string;
  includedPeriodType4b: string;
  includedAnyAll4b: string;
  includedAnyAllFollowedBy4b: string;
  includedAreNot4b: string;
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

export class OrgItemNode {
  children: OrgItemNode[];
  item: string;
}

export class OrgItemFlatNode {
  item: string;
  level: number;
  expandable: boolean;
}

@Injectable()
export class ChecklistDatabase {
  dataChange = new BehaviorSubject<OrgItemNode[]>([]);

  get data(): OrgItemNode[] { return this.dataChange.value; }

  constructor(private explorerService: ExplorerService,
              private log: LoggerService) {

    this.initialize();
  }

  initialize() {
    this.explorerService.getOrganisationTree()
      .subscribe(
        (result) => this.loadOrgTree(result),
        (error) => this.log.error(error)
      );

  }

  loadOrgTree(orgs: any) {
    const data = this.buildFileTree(orgs, 0);

    this.dataChange.next(data);
  }

  buildFileTree(obj: {[key: string]: any}, level: number): OrgItemNode[] {
    return Object.keys(obj).reduce<OrgItemNode[]>((accumulator, key) => {
      const value = obj[key];
      const node = new OrgItemNode();
      node.item = key;

      if (value != null) {
        if (typeof value === 'object') {
          node.children = this.buildFileTree(value, level + 1);
        } else {
          node.item = value;
        }
      }

      return accumulator.concat(node);
    }, []);
  }

}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './advancedqueryeditor.component.html',
  styleUrls: ['./advancedqueryeditor.component.scss'],
  providers: [ChecklistDatabase, {
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
  selectedRegistration: string = '';
  registrationExclude: string = '';
  registrationDateFrom: string = '';
  registrationDateTo: string = '';
  registrationPeriodValue: string= '';
  registrationPeriodType: string= '';
  ageFrom: string = '';
  ageTo: string = '';
  ageFrom1: string = '';
  ageTo1: string = '';
  ageFrom2: string = '';
  ageTo2: string = '';
  ageFrom3: string = '';
  ageTo3: string = '';
  ageFrom4: string = '';
  ageTo4: string = '';
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
  withWithout1e: string = '';
  includedValueSet1e: string = '';
  includedDateFrom1e: string = '';
  includedDateTo1e: string = '';
  includedPeriodOperator1e: string = '';
  includedPeriodValue1e: string = '';
  includedPeriodType1e: string = '';
  includedAnyAll1e: string = '';
  withWithout1f: string = '';
  includedValueSet1f: string = '';
  includedDateFrom1f: string = '';
  includedDateTo1f: string = '';
  includedPeriodOperator1f: string = '';
  includedPeriodValue1f: string = '';
  includedPeriodType1f: string = '';
  includedAnyAll1f: string = '';
  withWithout1g: string = '';
  includedValueSet1g: string = '';
  includedDateFrom1g: string = '';
  includedDateTo1g: string = '';
  includedPeriodOperator1g: string = '';
  includedPeriodValue1g: string = '';
  includedPeriodType1g: string = '';
  includedAnyAll1g: string = '';
  withWithout1h: string = '';
  includedValueSet1h: string = '';
  includedDateFrom1h: string = '';
  includedDateTo1h: string = '';
  includedPeriodOperator1h: string = '';
  includedPeriodValue1h: string = '';
  includedPeriodType1h: string = '';
  includedAnyAll1h: string = '';
  withWithout1i: string = '';
  includedValueSet1i: string = '';
  includedDateFrom1i: string = '';
  includedDateTo1i: string = '';
  includedPeriodOperator1i: string = '';
  includedPeriodValue1i: string = '';
  includedPeriodType1i: string = '';
  includedAnyAll1i: string = '';
  withWithout1j: string = '';
  includedValueSet1j: string = '';
  includedDateFrom1j: string = '';
  includedDateTo1j: string = '';
  includedPeriodOperator1j: string = '';
  includedPeriodValue1j: string = '';
  includedPeriodType1j: string = '';
  includedAnyAll1j: string = '';
  withWithout1k: string = '';
  includedValueSet1k: string = '';
  includedDateFrom1k: string = '';
  includedDateTo1k: string = '';
  includedPeriodOperator1k: string = '';
  includedPeriodValue1k: string = '';
  includedPeriodType1k: string = '';
  includedAnyAll1k: string = '';
  withWithout1l: string = '';
  includedValueSet1l: string = '';
  includedDateFrom1l: string = '';
  includedDateTo1l: string = '';
  includedPeriodOperator1l: string = '';
  includedPeriodValue1l: string = '';
  includedPeriodType1l: string = '';
  includedAnyAll1l: string = '';
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
  withWithout2b: string = '';
  includedValueSet2b: string = '';
  includedEarliestLatest2b: string = '';
  includedOperator2b: string = '';
  includedEntryValue2b: string = '';
  includedAnyAll2b: string = '';
  includedDateFrom2b: string = '';
  includedDateTo2b: string = '';
  includedPeriodOperator2b: string = '';
  includedPeriodValue2b: string = '';
  includedPeriodType2b: string = '';
  withWithout2c: string = '';
  includedValueSet2c: string = '';
  includedEarliestLatest2c: string = '';
  includedOperator2c: string = '';
  includedEntryValue2c: string = '';
  includedAnyAll2c: string = '';
  includedDateFrom2c: string = '';
  includedDateTo2c: string = '';
  includedPeriodOperator2c: string = '';
  includedPeriodValue2c: string = '';
  includedPeriodType2c: string = '';
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
  includedDob3: string = '';
  includedDiagnosisAnyAll3: string = '';
  includedDiagnosisValueSet3: string = '';
  includedDiagnosisAgeFrom3: string = '';
  includedDiagnosisAgeTo3: string = '';
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
  includedDob3a: string = '';
  includedDiagnosisAnyAll3a: string = '';
  includedDiagnosisValueSet3a: string = '';
  includedDiagnosisAgeFrom3a: string = '';
  includedDiagnosisAgeTo3a: string = '';
  withWithout3b: string = '';
  includedValueSet3b: string = '';
  includedEarliestLatest3b: string = '';
  includedTestedValueSet3b: string = '';
  includedAnyAll3b: string = '';
  includedAnyAllTested3b: string = '';
  includedDateFrom3b: string = '';
  includedDateTo3b: string = '';
  includedPeriodOperator3b: string = '';
  includedPeriodValue3b: string = '';
  includedPeriodType3b: string = '';
  includedDob3b: string = '';
  includedDiagnosisAnyAll3b: string = '';
  includedDiagnosisValueSet3b: string = '';
  includedDiagnosisAgeFrom3b: string = '';
  includedDiagnosisAgeTo3b: string = '';
  withWithout3c: string = '';
  includedValueSet3c: string = '';
  includedEarliestLatest3c: string = '';
  includedTestedValueSet3c: string = '';
  includedAnyAll3c: string = '';
  includedAnyAllTested3c: string = '';
  includedDateFrom3c: string = '';
  includedDateTo3c: string = '';
  includedPeriodOperator3c: string = '';
  includedPeriodValue3c: string = '';
  includedPeriodType3c: string = '';
  includedDob3c: string = '';
  includedDiagnosisAnyAll3c: string = '';
  includedDiagnosisValueSet3c: string = '';
  includedDiagnosisAgeFrom3c: string = '';
  includedDiagnosisAgeTo3c: string = '';
  withWithout3d: string = '';
  includedValueSet3d: string = '';
  includedEarliestLatest3d: string = '';
  includedTestedValueSet3d: string = '';
  includedAnyAll3d: string = '';
  includedAnyAllTested3d: string = '';
  includedDateFrom3d: string = '';
  includedDateTo3d: string = '';
  includedPeriodOperator3d: string = '';
  includedPeriodValue3d: string = '';
  includedPeriodType3d: string = '';
  includedDob3d: string = '';
  includedDiagnosisAnyAll3d: string = '';
  includedDiagnosisValueSet3d: string = '';
  includedDiagnosisAgeFrom3d: string = '';
  includedDiagnosisAgeTo3d: string = '';
  withWithout3e: string = '';
  includedValueSet3e: string = '';
  includedEarliestLatest3e: string = '';
  includedTestedValueSet3e: string = '';
  includedAnyAll3e: string = '';
  includedAnyAllTested3e: string = '';
  includedDateFrom3e: string = '';
  includedDateTo3e: string = '';
  includedPeriodOperator3e: string = '';
  includedPeriodValue3e: string = '';
  includedPeriodType3e: string = '';
  includedDob3e: string = '';
  includedDiagnosisAnyAll3e: string = '';
  includedDiagnosisValueSet3e: string = '';
  includedDiagnosisAgeFrom3e: string = '';
  includedDiagnosisAgeTo3e: string = '';
  withWithout3f: string = '';
  includedValueSet3f: string = '';
  includedEarliestLatest3f: string = '';
  includedTestedValueSet3f: string = '';
  includedAnyAll3f: string = '';
  includedAnyAllTested3f: string = '';
  includedDateFrom3f: string = '';
  includedDateTo3f: string = '';
  includedPeriodOperator3f: string = '';
  includedPeriodValue3f: string = '';
  includedPeriodType3f: string = '';
  includedDob3f: string = '';
  includedDiagnosisAnyAll3f: string = '';
  includedDiagnosisValueSet3f: string = '';
  includedDiagnosisAgeFrom3f: string = '';
  includedDiagnosisAgeTo3f: string = '';
  withWithout4: string = '';
  includedValueSet4: string = '';
  includedFollowedByValueSet4: string = '';
  includedPeriodOperator4: string = '';
  includedPeriodValue4: string = '';
  includedPeriodType4: string = '';
  includedAnyAll4: string = '';
  includedAnyAllFollowedBy4: string = '';
  includedAreNot4: string = '';
  withWithout4a: string = '';
  includedValueSet4a: string = '';
  includedFollowedByValueSet4a: string = '';
  includedPeriodOperator4a: string = '';
  includedPeriodValue4a: string = '';
  includedPeriodType4a: string = '';
  includedAnyAll4a: string = '';
  includedAnyAllFollowedBy4a: string = '';
  includedAreNot4a: string = '';
  withWithout4b: string = '';
  includedValueSet4b: string = '';
  includedFollowedByValueSet4b: string = '';
  includedPeriodOperator4b: string = '';
  includedPeriodValue4b: string = '';
  includedPeriodType4b: string = '';
  includedAnyAll4b: string = '';
  includedAnyAllFollowedBy4b: string = '';
  includedAreNot4b: string = '';
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
  select1e: boolean = false;
  addQuery1e: boolean = true;
  select1f: boolean = false;
  addQuery1f: boolean = true;
  select1g: boolean = false;
  addQuery1g: boolean = true;
  select1h: boolean = false;
  addQuery1h: boolean = true;
  select1i: boolean = false;
  addQuery1i: boolean = true;
  select1j: boolean = false;
  addQuery1j: boolean = true;
  select1k: boolean = false;
  addQuery1k: boolean = true;
  select1l: boolean = false;
  addQuery1l: boolean = true;
  select2a: boolean = false;
  addQuery2: boolean = true;
  select2b: boolean = false;
  addQuery2b: boolean = true;
  select2c: boolean = false;
  addQuery2c: boolean = true;
  select3a: boolean = false;
  addQuery3: boolean = true;
  select3b: boolean = false;
  addQuery3b: boolean = true;
  select3c: boolean = false;
  addQuery3c: boolean = true;
  select3d: boolean = false;
  addQuery3d: boolean = true;
  select3e: boolean = false;
  addQuery3e: boolean = true;
  select3f: boolean = false;
  addQuery3f: boolean = true;
  select4a: boolean = false;
  addQuery4: boolean = true;
  select4b: boolean = false;
  addQuery4b: boolean = true;
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
    private _database: ChecklistDatabase,
    @Inject(MAT_DIALOG_DATA) public data: DialogData,
    private dialog: MatDialog) {

    this.treeFlattener = new MatTreeFlattener(this.transformer, this.getLevel,
      this.isExpandable, this.getChildren);
    this.treeControl = new FlatTreeControl<OrgItemFlatNode>(this.getLevel, this.isExpandable);
    this.dataSource = new MatTreeFlatDataSource(this.treeControl, this.treeFlattener);

    _database.dataChange.subscribe(data => {
      this.dataSource.data = data;
    });

    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.registryName = data.registryName;
    this.denominatorQuery = data.denominatorQuery;
    this.type = data.type;

    if (data.query!='') { // edit mode
      let query: savedQuery = JSON.parse(data.query);

      this.targetPercentage = query.targetPercentage;
      this.selectedRegistration = query.registrationStatus;
      this.ageFrom = query.ageFrom;
      this.ageTo = query.ageTo;
      this.ageFrom1 = query.ageFrom1;
      this.ageTo1 = query.ageTo1;
      this.ageFrom2 = query.ageFrom2;
      this.ageTo2 = query.ageTo2;
      this.ageFrom3 = query.ageFrom3;
      this.ageTo3 = query.ageTo3;
      this.ageFrom4 = query.ageFrom4;
      this.ageTo4 = query.ageTo4;
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
      this.withWithout1e = query.withWithout1e;
      this.includedValueSet1e = query.includedValueSet1e;
      this.includedDateFrom1e = query.includedDateFrom1e;
      this.includedDateTo1e = query.includedDateTo1e;
      this.includedPeriodOperator1e = query.includedPeriodOperator1e;
      this.includedPeriodValue1e = query.includedPeriodValue1e;
      this.includedPeriodType1e = query.includedPeriodType1e;
      this.includedAnyAll1e = query.includedAnyAll1e;
      this.withWithout1f = query.withWithout1f;
      this.includedValueSet1f = query.includedValueSet1f;
      this.includedDateFrom1f = query.includedDateFrom1f;
      this.includedDateTo1f = query.includedDateTo1f;
      this.includedPeriodOperator1f = query.includedPeriodOperator1f;
      this.includedPeriodValue1f = query.includedPeriodValue1f;
      this.includedPeriodType1f = query.includedPeriodType1f;
      this.includedAnyAll1f = query.includedAnyAll1f;
      this.withWithout1g = query.withWithout1g;
      this.includedValueSet1g = query.includedValueSet1g;
      this.includedDateFrom1g = query.includedDateFrom1g;
      this.includedDateTo1g = query.includedDateTo1g;
      this.includedPeriodOperator1g = query.includedPeriodOperator1g;
      this.includedPeriodValue1g = query.includedPeriodValue1g;
      this.includedPeriodType1g = query.includedPeriodType1g;
      this.includedAnyAll1g = query.includedAnyAll1g;
      this.withWithout1h = query.withWithout1h;
      this.includedValueSet1h = query.includedValueSet1h;
      this.includedDateFrom1h = query.includedDateFrom1h;
      this.includedDateTo1h = query.includedDateTo1h;
      this.includedPeriodOperator1h = query.includedPeriodOperator1h;
      this.includedPeriodValue1h = query.includedPeriodValue1h;
      this.includedPeriodType1h = query.includedPeriodType1h;
      this.includedAnyAll1h = query.includedAnyAll1h;
      this.withWithout1i = query.withWithout1i;
      this.includedValueSet1i = query.includedValueSet1i;
      this.includedDateFrom1i = query.includedDateFrom1i;
      this.includedDateTo1i = query.includedDateTo1i;
      this.includedPeriodOperator1i = query.includedPeriodOperator1i;
      this.includedPeriodValue1i = query.includedPeriodValue1i;
      this.includedPeriodType1i = query.includedPeriodType1i;
      this.includedAnyAll1i = query.includedAnyAll1i;
      this.withWithout1j = query.withWithout1j;
      this.includedValueSet1j = query.includedValueSet1j;
      this.includedDateFrom1j = query.includedDateFrom1j;
      this.includedDateTo1j = query.includedDateTo1j;
      this.includedPeriodOperator1j = query.includedPeriodOperator1j;
      this.includedPeriodValue1j = query.includedPeriodValue1j;
      this.includedPeriodType1j = query.includedPeriodType1j;
      this.includedAnyAll1j = query.includedAnyAll1j;
      this.withWithout1k = query.withWithout1k;
      this.includedValueSet1k = query.includedValueSet1k;
      this.includedDateFrom1k = query.includedDateFrom1k;
      this.includedDateTo1k = query.includedDateTo1k;
      this.includedPeriodOperator1k = query.includedPeriodOperator1k;
      this.includedPeriodValue1k = query.includedPeriodValue1k;
      this.includedPeriodType1k = query.includedPeriodType1k;
      this.includedAnyAll1k = query.includedAnyAll1k;
      this.withWithout1l = query.withWithout1l;
      this.includedValueSet1l = query.includedValueSet1l;
      this.includedDateFrom1l = query.includedDateFrom1l;
      this.includedDateTo1l = query.includedDateTo1l;
      this.includedPeriodOperator1l = query.includedPeriodOperator1l;
      this.includedPeriodValue1l = query.includedPeriodValue1l;
      this.includedPeriodType1l = query.includedPeriodType1l;
      this.includedAnyAll1l = query.includedAnyAll1l;
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
      this.withWithout2b = query.withWithout2b;
      this.includedValueSet2b = query.includedValueSet2b;
      this.includedEarliestLatest2b = query.includedEarliestLatest2b;
      this.includedOperator2b = query.includedOperator2b;
      this.includedEntryValue2b = query.includedEntryValue2b;
      this.includedAnyAll2b = query.includedAnyAll2b;
      this.includedDateFrom2b = query.includedDateFrom2b;
      this.includedDateTo2b = query.includedDateTo2b;
      this.includedPeriodOperator2b = query.includedPeriodOperator2b;
      this.includedPeriodValue2b = query.includedPeriodValue2b;
      this.includedPeriodType2b = query.includedPeriodType2b;
      this.withWithout2c = query.withWithout2c;
      this.includedValueSet2c = query.includedValueSet2c;
      this.includedEarliestLatest2c = query.includedEarliestLatest2c;
      this.includedOperator2c = query.includedOperator2c;
      this.includedEntryValue2c = query.includedEntryValue2c;
      this.includedAnyAll2c = query.includedAnyAll2c;
      this.includedDateFrom2c = query.includedDateFrom2c;
      this.includedDateTo2c = query.includedDateTo2c;
      this.includedPeriodOperator2c = query.includedPeriodOperator2c;
      this.includedPeriodValue2c = query.includedPeriodValue2c;
      this.includedPeriodType2c = query.includedPeriodType2c;
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
      this.includedDob3 = query.includedDob3;
      this.includedDiagnosisAnyAll3 = query.includedDiagnosisAnyAll3;
      this.includedDiagnosisValueSet3 = query.includedDiagnosisValueSet3;
      this.includedDiagnosisAgeFrom3 = query.includedDiagnosisAgeFrom3;
      this.includedDiagnosisAgeTo3 = query.includedDiagnosisAgeTo3;
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
      this.includedDob3a = query.includedDob3a;
      this.includedDiagnosisAnyAll3a = query.includedDiagnosisAnyAll3a;
      this.includedDiagnosisValueSet3a = query.includedDiagnosisValueSet3a;
      this.includedDiagnosisAgeFrom3a = query.includedDiagnosisAgeFrom3a;
      this.includedDiagnosisAgeTo3a = query.includedDiagnosisAgeTo3a;
      this.withWithout3b = query.withWithout3b;
      this.includedValueSet3b = query.includedValueSet3b;
      this.includedEarliestLatest3b = query.includedEarliestLatest3b;
      this.includedTestedValueSet3b = query.includedTestedValueSet3b;
      this.includedAnyAll3b = query.includedAnyAll3b;
      this.includedAnyAllTested3b = query.includedAnyAllTested3b;
      this.includedDateFrom3b = query.includedDateFrom3b;
      this.includedDateTo3b = query.includedDateTo3b;
      this.includedPeriodOperator3b = query.includedPeriodOperator3b;
      this.includedPeriodValue3b = query.includedPeriodValue3b;
      this.includedPeriodType3b = query.includedPeriodType3b;
      this.includedDob3b = query.includedDob3b;
      this.includedDiagnosisAnyAll3b = query.includedDiagnosisAnyAll3b;
      this.includedDiagnosisValueSet3b = query.includedDiagnosisValueSet3b;
      this.includedDiagnosisAgeFrom3b = query.includedDiagnosisAgeFrom3b;
      this.includedDiagnosisAgeTo3b = query.includedDiagnosisAgeTo3b;
      this.withWithout3c = query.withWithout3c;
      this.includedValueSet3c = query.includedValueSet3c;
      this.includedEarliestLatest3c = query.includedEarliestLatest3c;
      this.includedTestedValueSet3c = query.includedTestedValueSet3c;
      this.includedAnyAll3c = query.includedAnyAll3c;
      this.includedAnyAllTested3c = query.includedAnyAllTested3c;
      this.includedDateFrom3c = query.includedDateFrom3c;
      this.includedDateTo3c = query.includedDateTo3c;
      this.includedPeriodOperator3c = query.includedPeriodOperator3c;
      this.includedPeriodValue3c = query.includedPeriodValue3c;
      this.includedPeriodType3c = query.includedPeriodType3c;
      this.includedDob3c = query.includedDob3c;
      this.includedDiagnosisAnyAll3c = query.includedDiagnosisAnyAll3c;
      this.includedDiagnosisValueSet3c = query.includedDiagnosisValueSet3c;
      this.includedDiagnosisAgeFrom3c = query.includedDiagnosisAgeFrom3c;
      this.includedDiagnosisAgeTo3c = query.includedDiagnosisAgeTo3c;
      this.withWithout3d = query.withWithout3d;
      this.includedValueSet3d = query.includedValueSet3d;
      this.includedEarliestLatest3d = query.includedEarliestLatest3d;
      this.includedTestedValueSet3d = query.includedTestedValueSet3d;
      this.includedAnyAll3d = query.includedAnyAll3d;
      this.includedAnyAllTested3d = query.includedAnyAllTested3d;
      this.includedDateFrom3d = query.includedDateFrom3d;
      this.includedDateTo3d = query.includedDateTo3d;
      this.includedPeriodOperator3d = query.includedPeriodOperator3d;
      this.includedPeriodValue3d = query.includedPeriodValue3d;
      this.includedPeriodType3d = query.includedPeriodType3d;
      this.includedDob3d = query.includedDob3d;
      this.includedDiagnosisAnyAll3d = query.includedDiagnosisAnyAll3d;
      this.includedDiagnosisValueSet3d = query.includedDiagnosisValueSet3d;
      this.includedDiagnosisAgeFrom3d = query.includedDiagnosisAgeFrom3d;
      this.includedDiagnosisAgeTo3d = query.includedDiagnosisAgeTo3d;
      this.withWithout3e = query.withWithout3e;
      this.includedValueSet3e = query.includedValueSet3e;
      this.includedEarliestLatest3e = query.includedEarliestLatest3e;
      this.includedTestedValueSet3e = query.includedTestedValueSet3e;
      this.includedAnyAll3e = query.includedAnyAll3e;
      this.includedAnyAllTested3e = query.includedAnyAllTested3e;
      this.includedDateFrom3e = query.includedDateFrom3e;
      this.includedDateTo3e = query.includedDateTo3e;
      this.includedPeriodOperator3e = query.includedPeriodOperator3e;
      this.includedPeriodValue3e = query.includedPeriodValue3e;
      this.includedPeriodType3e = query.includedPeriodType3e;
      this.includedDob3e = query.includedDob3e;
      this.includedDiagnosisAnyAll3e = query.includedDiagnosisAnyAll3e;
      this.includedDiagnosisValueSet3e = query.includedDiagnosisValueSet3e;
      this.includedDiagnosisAgeFrom3e = query.includedDiagnosisAgeFrom3e;
      this.includedDiagnosisAgeTo3e = query.includedDiagnosisAgeTo3e;
      this.withWithout3f = query.withWithout3f;
      this.includedValueSet3f = query.includedValueSet3f;
      this.includedEarliestLatest3f = query.includedEarliestLatest3f;
      this.includedTestedValueSet3f = query.includedTestedValueSet3f;
      this.includedAnyAll3f = query.includedAnyAll3f;
      this.includedAnyAllTested3f = query.includedAnyAllTested3f;
      this.includedDateFrom3f = query.includedDateFrom3f;
      this.includedDateTo3f = query.includedDateTo3f;
      this.includedPeriodOperator3f = query.includedPeriodOperator3f;
      this.includedPeriodValue3f = query.includedPeriodValue3f;
      this.includedPeriodType3f = query.includedPeriodType3f;
      this.includedDob3f = query.includedDob3f;
      this.includedDiagnosisAnyAll3f = query.includedDiagnosisAnyAll3f;
      this.includedDiagnosisValueSet3f = query.includedDiagnosisValueSet3f;
      this.includedDiagnosisAgeFrom3f = query.includedDiagnosisAgeFrom3f;
      this.includedDiagnosisAgeTo3f = query.includedDiagnosisAgeTo3f;
      this.withWithout4 = query.withWithout4;
      this.includedValueSet4 = query.includedValueSet4;
      this.includedFollowedByValueSet4 = query.includedFollowedByValueSet4;
      this.includedPeriodOperator4 = query.includedPeriodOperator4;
      this.includedPeriodValue4 = query.includedPeriodValue4;
      this.includedPeriodType4 = query.includedPeriodType4;
      this.includedAnyAll4 = query.includedAnyAll4;
      this.includedAnyAllFollowedBy4 = query.includedAnyAllFollowedBy4;
      this.includedAreNot4 = query.includedAreNot4;
      this.withWithout4a = query.withWithout4a;
      this.includedValueSet4a = query.includedValueSet4a;
      this.includedFollowedByValueSet4a = query.includedFollowedByValueSet4a;
      this.includedPeriodOperator4a = query.includedPeriodOperator4a;
      this.includedPeriodValue4a = query.includedPeriodValue4a;
      this.includedPeriodType4a = query.includedPeriodType4a;
      this.includedAnyAll4a = query.includedAnyAll4a;
      this.includedAnyAllFollowedBy4a = query.includedAnyAllFollowedBy4a;
      this.includedAreNot4a = query.includedAreNot4a;
      this.withWithout4b = query.withWithout4b;
      this.includedValueSet4b = query.includedValueSet4b;
      this.includedFollowedByValueSet4b = query.includedFollowedByValueSet4b;
      this.includedPeriodOperator4b = query.includedPeriodOperator4b;
      this.includedPeriodValue4b = query.includedPeriodValue4b;
      this.includedPeriodType4b = query.includedPeriodType4b;
      this.includedAnyAll4b = query.includedAnyAll4b;
      this.includedAnyAllFollowedBy4b = query.includedAnyAllFollowedBy4b;
      this.includedAreNot4b = query.includedAreNot4b;
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

      if (this.withWithout1e != "" && this.withWithout1e!=undefined) {
        this.select1e = true;
        this.addQuery1e = false;
      }

      if (this.withWithout1f != "" && this.withWithout1f!=undefined) {
        this.select1f = true;
        this.addQuery1f = false;
      }

      if (this.withWithout1g != "" && this.withWithout1g!=undefined) {
        this.select1g = true;
        this.addQuery1g = false;
      }

      if (this.withWithout1h != "" && this.withWithout1h!=undefined) {
        this.select1h = true;
        this.addQuery1h = false;
      }

      if (this.withWithout1i != "" && this.withWithout1i!=undefined) {
        this.select1i = true;
        this.addQuery1i = false;
      }

      if (this.withWithout1j != "" && this.withWithout1j!=undefined) {
        this.select1j = true;
        this.addQuery1j = false;
      }

      if (this.withWithout1k != "" && this.withWithout1k!=undefined) {
        this.select1k = true;
        this.addQuery1k = false;
      }

      if (this.withWithout1l != "" && this.withWithout1l!=undefined) {
        this.select1l = true;
        this.addQuery1l = false;
      }

      if (this.withWithout2a != "" && this.withWithout2a!=undefined) {
        this.select2a = true;
        this.addQuery2 = false;
      }
      if (this.withWithout2b != "" && this.withWithout2b!=undefined) {
        this.select2b = true;
        this.addQuery2b = false;
      }
      if (this.withWithout2c != "" && this.withWithout2c!=undefined) {
        this.select2c = true;
        this.addQuery2c = false;
      }
      if (this.withWithout3a != "" && this.withWithout3a!=undefined) {
        this.select3a = true;
        this.addQuery3 = false;
      }
      if (this.withWithout3b != "" && this.withWithout3b!=undefined) {
        this.select3b = true;
        this.addQuery3b = false;
      }
      if (this.withWithout3c != "" && this.withWithout3c!=undefined) {
        this.select3c = true;
        this.addQuery3c = false;
      }
      if (this.withWithout3d != "" && this.withWithout3d!=undefined) {
        this.select3d = true;
        this.addQuery3d = false;
      }
      if (this.withWithout3e != "" && this.withWithout3e!=undefined) {
        this.select3e = true;
        this.addQuery3e = false;
      }
      if (this.withWithout3f != "" && this.withWithout3f!=undefined) {
        this.select3f = true;
        this.addQuery3f = false;
      }
      if (this.withWithout4a != "" && this.withWithout4a!=undefined) {
        this.select4a = true;
        this.addQuery4 = false;
      }

      if (this.withWithout4b != "" && this.withWithout4b!=undefined) {
        this.select4b = true;
        this.addQuery4b = false;
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
      control4: ['', Validators.required], control8: [''], control9: ['']
    });

    this.thirdFormGroup = this._formBuilder.group({
      control6: [''], control7: [''],
      control6a: [''], control7a: [''],
      control6b: [''], control7b: [''],
      control6c: [''], control7c: [''],
      control6d: [''], control7d: [''],
      control5: [''], control5a: [''], control5b: [''], control20: [''], control21: [''],
      control22: [''], control23: [''], control24: [''], control25: [''],
      control22a: [''], control23a: [''], control24a: [''], control25a: [''],
      control46a: [''], control47a: [''], control48a: [''],
      control22b: [''], control23b: [''], control24b: [''], control25b: [''],
      control46b: [''], control47b: [''], control48b: [''],
      control22c: [''], control23c: [''], control24c: [''], control25c: [''],
      control46c: [''], control47c: [''], control48c: [''],
      control147: [''],control148: [''],control149: [''],control150: [''],control151: [''],

      control22d: [''], control23d: [''], control24d: [''], control25d: [''],
      control46d: [''], control47d: [''], control48d: [''],
      control147d: [''],control148d: [''],control149d: [''],control150d: [''],control151d: [''],

      control22e: [''], control23e: [''], control24e: [''], control25e: [''],
      control46e: [''], control47e: [''], control48e: [''],
      control147e: [''],control148e: [''],control149e: [''],control150e: [''],control151e: [''],

      control22f: [''], control23f: [''], control24f: [''], control25f: [''],
      control46f: [''], control47f: [''], control48f: [''],
      control147f: [''],control148f: [''],control149f: [''],control150f: [''],control151f: [''],

      control22g: [''], control23g: [''], control24g: [''], control25g: [''],
      control46g: [''], control47g: [''], control48g: [''],
      control147g: [''],control148g: [''],control149g: [''],control150g: [''],control151g: [''],

      control22h: [''], control23h: [''], control24h: [''], control25h: [''],
      control46h: [''], control47h: [''], control48h: [''],
      control147h: [''],control148h: [''],control149h: [''],control150h: [''],control151h: [''],

      control22i: [''], control23i: [''], control24i: [''], control25i: [''],
      control46i: [''], control47i: [''], control48i: [''],
      control147i: [''],control148i: [''],control149i: [''],control150i: [''],control151i: [''],

      control22j: [''], control23j: [''], control24j: [''], control25j: [''],
      control46j: [''], control47j: [''], control48j: [''],
      control147j: [''],control148j: [''],control149j: [''],control150j: [''],control151j: [''],

      control22k: [''], control23k: [''], control24k: [''], control25k: [''],
      control46k: [''], control47k: [''], control48k: [''],
      control147k: [''],control148k: [''],control149k: [''],control150k: [''],control151k: [''],

      control22l: [''], control23l: [''], control24l: [''], control25l: [''],
      control46l: [''], control47l: [''], control48l: [''],
      control147l: [''],control148l: [''],control149l: [''],control150l: [''],control151l: [''],

      withWithout2: [''], includedAnyAll2: [''], includedValueSet2: [''], includedEarliestLatest2: [''], includedOperator2: [''],
      includedEntryValue2: [''], includedDateFrom2: [''], includedDateTo2: [''],
      includedPeriodOperator2: [''], includedPeriodValue2: [''], includedPeriodType2: [''],

      withWithout2a: [''], includedAnyAll2a: [''], includedValueSet2a: [''], includedEarliestLatest2a: [''], includedOperator2a: [''],
      includedEntryValue2a: [''], includedDateFrom2a: [''], includedDateTo2a: [''],
      includedPeriodOperator2a: [''], includedPeriodValue2a: [''], includedPeriodType2a: [''],

      withWithout2b: [''], includedAnyAll2b: [''], includedValueSet2b: [''], includedEarliestLatest2b: [''], includedOperator2b: [''],
      includedEntryValue2b: [''], includedDateFrom2b: [''], includedDateTo2b: [''],
      includedPeriodOperator2b: [''], includedPeriodValue2b: [''], includedPeriodType2b: [''],

      withWithout2c: [''], includedAnyAll2c: [''], includedValueSet2c: [''], includedEarliestLatest2c: [''], includedOperator2c: [''],
      includedEntryValue2c: [''], includedDateFrom2c: [''], includedDateTo2c: [''],
      includedPeriodOperator2c: [''], includedPeriodValue2c: [''], includedPeriodType2c: [''],

      withWithout4: [''], includedValueSet4: [''], includedFollowedByValueSet4: [''],includedPeriodOperator4: [''],
      includedPeriodValue4: [''], includedPeriodType4: [''], includedAnyAll4: [''], includedAreNot4: [''], includedAnyAllFollowedBy4: [''],
      withWithout4a: [''], includedValueSet4a: [''], includedFollowedByValueSet4a: [''],includedPeriodOperator4a: [''],
      includedPeriodValue4a: [''], includedPeriodType4a: [''], includedAnyAll4a: [''], includedAreNot4a: [''], includedAnyAllFollowedBy4a: [''],
      withWithout4b: [''], includedValueSet4b: [''], includedFollowedByValueSet4b: [''],includedPeriodOperator4b: [''],
      includedPeriodValue4b: [''], includedPeriodType4b: [''], includedAnyAll4b: [''], includedAreNot4b: [''], includedAnyAllFollowedBy4b: [''],

      control40: [''], control41: [''],
      control42: [''], control43: [''], control44: [''], control45: [''],
      control155: [''],control156: [''],
      control46: [''], control47: [''], control48: [''],
      control56: [''],
      control57: [''], control58: [''], control59: [''], control60: [''],
      control40a: [''],control56a: [''],control41a: [''],control42a: [''],
      control43a: [''],control44a: [''],control45a: [''],control57a: [''],control58a: [''],

      withWithout3: [''],
      includedAnyAll3: [''],
      includedValueSet3: [''],
      includedEarliestLatest3: [''],
      includedAnyAllTested3: [''],
      includedDateFrom3: [''],
      includedDateTo3: [''],
      includedPeriodOperator3: [''],
      includedPeriodValue3: [''],
      includedPeriodType3: [''],
      includedTestedValueSet3: [''],
      includedDob3: [''],
      includedDiagnosisAnyAll3: [''],
      includedDiagnosisValueSet3: [''],
      includedDiagnosisAgeFrom3: [''],
      includedDiagnosisAgeTo3: [''],
      withWithout3a: [''],
      includedAnyAll3a: [''],
      includedValueSet3a: [''],
      includedEarliestLatest3a: [''],
      includedAnyAllTested3a: [''],
      includedDateFrom3a: [''],
      includedDateTo3a: [''],
      includedPeriodOperator3a: [''],
      includedPeriodValue3a: [''],
      includedPeriodType3a: [''],
      includedTestedValueSet3a: [''],
      includedDob3a: [''],
      includedDiagnosisAnyAll3a: [''],
      includedDiagnosisValueSet3a: [''],
      includedDiagnosisAgeFrom3a: [''],
      includedDiagnosisAgeTo3a: [''],
      withWithout3b: [''],
      includedAnyAll3b: [''],
      includedValueSet3b: [''],
      includedEarliestLatest3b: [''],
      includedAnyAllTested3b: [''],
      includedDateFrom3b: [''],
      includedDateTo3b: [''],
      includedPeriodOperator3b: [''],
      includedPeriodValue3b: [''],
      includedPeriodType3b: [''],
      includedTestedValueSet3b: [''],
      includedDob3b: [''],
      includedDiagnosisAnyAll3b: [''],
      includedDiagnosisValueSet3b: [''],
      includedDiagnosisAgeFrom3b: [''],
      includedDiagnosisAgeTo3b: [''],
      withWithout3c: [''],
      includedAnyAll3c: [''],
      includedValueSet3c: [''],
      includedEarliestLatest3c: [''],
      includedAnyAllTested3c: [''],
      includedDateFrom3c: [''],
      includedDateTo3c: [''],
      includedPeriodOperator3c: [''],
      includedPeriodValue3c: [''],
      includedPeriodType3c: [''],
      includedTestedValueSet3c: [''],
      includedDob3c: [''],
      includedDiagnosisAnyAll3c: [''],
      includedDiagnosisValueSet3c: [''],
      includedDiagnosisAgeFrom3c: [''],
      includedDiagnosisAgeTo3c: [''],
      withWithout3d: [''],
      includedAnyAll3d: [''],
      includedValueSet3d: [''],
      includedEarliestLatest3d: [''],
      includedAnyAllTested3d: [''],
      includedDateFrom3d: [''],
      includedDateTo3d: [''],
      includedPeriodOperator3d: [''],
      includedPeriodValue3d: [''],
      includedPeriodType3d: [''],
      includedTestedValueSet3d: [''],
      includedDob3d: [''],
      includedDiagnosisAnyAll3d: [''],
      includedDiagnosisValueSet3d: [''],
      includedDiagnosisAgeFrom3d: [''],
      includedDiagnosisAgeTo3d: [''],
      withWithout3e: [''],
      includedAnyAll3e: [''],
      includedValueSet3e: [''],
      includedEarliestLatest3e: [''],
      includedAnyAllTested3e: [''],
      includedDateFrom3e: [''],
      includedDateTo3e: [''],
      includedPeriodOperator3e: [''],
      includedPeriodValue3e: [''],
      includedPeriodType3e: [''],
      includedTestedValueSet3e: [''],
      includedDob3e: [''],
      includedDiagnosisAnyAll3e: [''],
      includedDiagnosisValueSet3e: [''],
      includedDiagnosisAgeFrom3e: [''],
      includedDiagnosisAgeTo3e: [''],
      withWithout3f: [''],
      includedAnyAll3f: [''],
      includedValueSet3f: [''],
      includedEarliestLatest3f: [''],
      includedAnyAllTested3f: [''],
      includedDateFrom3f: [''],
      includedDateTo3f: [''],
      includedPeriodOperator3f: [''],
      includedPeriodValue3f: [''],
      includedPeriodType3f: [''],
      includedTestedValueSet3f: [''],
      includedDob3f: [''],
      includedDiagnosisAnyAll3f: [''],
      includedDiagnosisValueSet3f: [''],
      includedDiagnosisAgeFrom3f: [''],
      includedDiagnosisAgeTo3f: ['']

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
    this.loadLists();
  }

  loadLists() {
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

  saveQuery(close: boolean) {

    let practice = "";

    this.checklistSelection.selected.map(
      e => {
        if (e.level==3)
          practice += ','+e.item.split('|')[1].trim();
      }
    )

    practice = practice.replace(',', '');

    let query = {
      targetPercentage: this.targetPercentage,
      providerOrganisation: practice,
      registrationStatus: this.selectedRegistration,
      registrationExclude: this.registrationExclude,
      registrationDateFrom: this.formatDate(this.registrationDateFrom),
      registrationDateTo: this.formatDate(this.registrationDateTo),
      registrationPeriodValue: this.registrationPeriodValue,
      registrationPeriodType: this.registrationPeriodType,
      ageFrom: this.ageFrom,
      ageTo: this.ageTo,
      ageFrom1: this.ageFrom1,
      ageTo1: this.ageTo1,
      ageFrom2: this.ageFrom2,
      ageTo2: this.ageTo2,
      ageFrom3: this.ageFrom3,
      ageTo3: this.ageTo3,
      ageFrom4: this.ageFrom4,
      ageTo4: this.ageTo4,
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
      withWithout1e: this.withWithout1e,
      includedAnyAll1e: this.includedAnyAll1e,
      includedValueSet1e: this.includedValueSet1e,
      includedDateFrom1e: this.formatDate(this.includedDateFrom1e),
      includedDateTo1e: this.formatDate(this.includedDateTo1e),
      includedPeriodOperator1e: this.includedPeriodOperator1e,
      includedPeriodValue1e: this.includedPeriodValue1e,
      includedPeriodType1e: this.includedPeriodType1e,
      withWithout1f: this.withWithout1f,
      includedAnyAll1f: this.includedAnyAll1f,
      includedValueSet1f: this.includedValueSet1f,
      includedDateFrom1f: this.formatDate(this.includedDateFrom1f),
      includedDateTo1f: this.formatDate(this.includedDateTo1f),
      includedPeriodOperator1f: this.includedPeriodOperator1f,
      includedPeriodValue1f: this.includedPeriodValue1f,
      includedPeriodType1f: this.includedPeriodType1f,
      withWithout1g: this.withWithout1g,
      includedAnyAll1g: this.includedAnyAll1g,
      includedValueSet1g: this.includedValueSet1g,
      includedDateFrom1g: this.formatDate(this.includedDateFrom1g),
      includedDateTo1g: this.formatDate(this.includedDateTo1g),
      includedPeriodOperator1g: this.includedPeriodOperator1g,
      includedPeriodValue1g: this.includedPeriodValue1g,
      includedPeriodType1g: this.includedPeriodType1g,
      withWithout1h: this.withWithout1h,
      includedAnyAll1h: this.includedAnyAll1h,
      includedValueSet1h: this.includedValueSet1h,
      includedDateFrom1h: this.formatDate(this.includedDateFrom1h),
      includedDateTo1h: this.formatDate(this.includedDateTo1h),
      includedPeriodOperator1h: this.includedPeriodOperator1h,
      includedPeriodValue1h: this.includedPeriodValue1h,
      includedPeriodType1h: this.includedPeriodType1h,
      withWithout1i: this.withWithout1i,
      includedAnyAll1i: this.includedAnyAll1i,
      includedValueSet1i: this.includedValueSet1i,
      includedDateFrom1i: this.formatDate(this.includedDateFrom1i),
      includedDateTo1i: this.formatDate(this.includedDateTo1i),
      includedPeriodOperator1i: this.includedPeriodOperator1i,
      includedPeriodValue1i: this.includedPeriodValue1i,
      includedPeriodType1i: this.includedPeriodType1i,
      withWithout1j: this.withWithout1j,
      includedAnyAll1j: this.includedAnyAll1j,
      includedValueSet1j: this.includedValueSet1j,
      includedDateFrom1j: this.formatDate(this.includedDateFrom1j),
      includedDateTo1j: this.formatDate(this.includedDateTo1j),
      includedPeriodOperator1j: this.includedPeriodOperator1j,
      includedPeriodValue1j: this.includedPeriodValue1j,
      includedPeriodType1j: this.includedPeriodType1j,
      withWithout1k: this.withWithout1k,
      includedAnyAll1k: this.includedAnyAll1k,
      includedValueSet1k: this.includedValueSet1k,
      includedDateFrom1k: this.formatDate(this.includedDateFrom1k),
      includedDateTo1k: this.formatDate(this.includedDateTo1k),
      includedPeriodOperator1k: this.includedPeriodOperator1k,
      includedPeriodValue1k: this.includedPeriodValue1k,
      includedPeriodType1k: this.includedPeriodType1k,
      withWithout1l: this.withWithout1l,
      includedAnyAll1l: this.includedAnyAll1l,
      includedValueSet1l: this.includedValueSet1l,
      includedDateFrom1l: this.formatDate(this.includedDateFrom1l),
      includedDateTo1l: this.formatDate(this.includedDateTo1l),
      includedPeriodOperator1l: this.includedPeriodOperator1l,
      includedPeriodValue1l: this.includedPeriodValue1l,
      includedPeriodType1l: this.includedPeriodType1l,
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
      withWithout2b: this.withWithout2b,
      includedAnyAll2b: this.includedAnyAll2b,
      includedValueSet2b: this.includedValueSet2b,
      includedEarliestLatest2b: this.includedEarliestLatest2b,
      includedOperator2b: this.includedOperator2b,
      includedEntryValue2b: this.includedEntryValue2b,
      includedDateFrom2b: this.formatDate(this.includedDateFrom2b),
      includedDateTo2b: this.formatDate(this.includedDateTo2b),
      includedPeriodOperator2b: this.includedPeriodOperator2b,
      includedPeriodValue2b: this.includedPeriodValue2b,
      includedPeriodType2b: this.includedPeriodType2b,
      withWithout2c: this.withWithout2c,
      includedAnyAll2c: this.includedAnyAll2c,
      includedValueSet2c: this.includedValueSet2c,
      includedEarliestLatest2c: this.includedEarliestLatest2c,
      includedOperator2c: this.includedOperator2c,
      includedEntryValue2c: this.includedEntryValue2c,
      includedDateFrom2c: this.formatDate(this.includedDateFrom2c),
      includedDateTo2c: this.formatDate(this.includedDateTo2c),
      includedPeriodOperator2c: this.includedPeriodOperator2c,
      includedPeriodValue2c: this.includedPeriodValue2c,
      includedPeriodType2c: this.includedPeriodType2c,
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
      includedDob3 : this.includedDob3,
      includedDiagnosisAnyAll3 : this.includedDiagnosisAnyAll3,
      includedDiagnosisValueSet3 : this.includedDiagnosisValueSet3,
      includedDiagnosisAgeFrom3 : this.includedDiagnosisAgeFrom3,
      includedDiagnosisAgeTo3 : this.includedDiagnosisAgeTo3,
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
      includedDob3a : this.includedDob3a,
      includedDiagnosisAnyAll3a : this.includedDiagnosisAnyAll3a,
      includedDiagnosisValueSet3a : this.includedDiagnosisValueSet3a,
      includedDiagnosisAgeFrom3a : this.includedDiagnosisAgeFrom3a,
      includedDiagnosisAgeTo3a : this.includedDiagnosisAgeTo3a,
      withWithout3b: this.withWithout3b,
      includedAnyAll3b: this.includedAnyAll3b,
      includedValueSet3b: this.includedValueSet3b,
      includedEarliestLatest3b: this.includedEarliestLatest3b,
      includedAnyAllTested3b: this.includedAnyAllTested3b,
      includedDateFrom3b: this.formatDate(this.includedDateFrom3b),
      includedDateTo3b: this.formatDate(this.includedDateTo3b),
      includedPeriodOperator3b: this.includedPeriodOperator3b,
      includedPeriodValue3b: this.includedPeriodValue3b,
      includedPeriodType3b: this.includedPeriodType3b,
      includedTestedValueSet3b: this.includedTestedValueSet3b,
      includedDob3b : this.includedDob3b,
      includedDiagnosisAnyAll3b : this.includedDiagnosisAnyAll3b,
      includedDiagnosisValueSet3b : this.includedDiagnosisValueSet3b,
      includedDiagnosisAgeFrom3b : this.includedDiagnosisAgeFrom3b,
      includedDiagnosisAgeTo3b : this.includedDiagnosisAgeTo3b,
      withWithout3c: this.withWithout3c,
      includedAnyAll3c: this.includedAnyAll3c,
      includedValueSet3c: this.includedValueSet3c,
      includedEarliestLatest3c: this.includedEarliestLatest3c,
      includedAnyAllTested3c: this.includedAnyAllTested3c,
      includedDateFrom3c: this.formatDate(this.includedDateFrom3c),
      includedDateTo3c: this.formatDate(this.includedDateTo3c),
      includedPeriodOperator3c: this.includedPeriodOperator3c,
      includedPeriodValue3c: this.includedPeriodValue3c,
      includedPeriodType3c: this.includedPeriodType3c,
      includedTestedValueSet3c: this.includedTestedValueSet3c,
      includedDob3c : this.includedDob3c,
      includedDiagnosisAnyAll3c : this.includedDiagnosisAnyAll3c,
      includedDiagnosisValueSet3c : this.includedDiagnosisValueSet3c,
      includedDiagnosisAgeFrom3c : this.includedDiagnosisAgeFrom3c,
      includedDiagnosisAgeTo3c : this.includedDiagnosisAgeTo3c,
      withWithout3d: this.withWithout3d,
      includedAnyAll3d: this.includedAnyAll3d,
      includedValueSet3d: this.includedValueSet3d,
      includedEarliestLatest3d: this.includedEarliestLatest3d,
      includedAnyAllTested3d: this.includedAnyAllTested3d,
      includedDateFrom3d: this.formatDate(this.includedDateFrom3d),
      includedDateTo3d: this.formatDate(this.includedDateTo3d),
      includedPeriodOperator3d: this.includedPeriodOperator3d,
      includedPeriodValue3d: this.includedPeriodValue3d,
      includedPeriodType3d: this.includedPeriodType3d,
      includedTestedValueSet3d: this.includedTestedValueSet3d,
      includedDob3d : this.includedDob3d,
      includedDiagnosisAnyAll3d : this.includedDiagnosisAnyAll3d,
      includedDiagnosisValueSet3d : this.includedDiagnosisValueSet3d,
      includedDiagnosisAgeFrom3d : this.includedDiagnosisAgeFrom3d,
      includedDiagnosisAgeTo3d : this.includedDiagnosisAgeTo3d,
      withWithout3e: this.withWithout3e,
      includedAnyAll3e: this.includedAnyAll3e,
      includedValueSet3e: this.includedValueSet3e,
      includedEarliestLatest3e: this.includedEarliestLatest3e,
      includedAnyAllTested3e: this.includedAnyAllTested3e,
      includedDateFrom3e: this.formatDate(this.includedDateFrom3e),
      includedDateTo3e: this.formatDate(this.includedDateTo3e),
      includedPeriodOperator3e: this.includedPeriodOperator3e,
      includedPeriodValue3e: this.includedPeriodValue3e,
      includedPeriodType3e: this.includedPeriodType3e,
      includedTestedValueSet3e: this.includedTestedValueSet3e,
      includedDob3e : this.includedDob3e,
      includedDiagnosisAnyAll3e : this.includedDiagnosisAnyAll3e,
      includedDiagnosisValueSet3e : this.includedDiagnosisValueSet3e,
      includedDiagnosisAgeFrom3e : this.includedDiagnosisAgeFrom3e,
      includedDiagnosisAgeTo3e : this.includedDiagnosisAgeTo3e,
      withWithout3f: this.withWithout3f,
      includedAnyAll3f: this.includedAnyAll3f,
      includedValueSet3f: this.includedValueSet3f,
      includedEarliestLatest3f: this.includedEarliestLatest3f,
      includedAnyAllTested3f: this.includedAnyAllTested3f,
      includedDateFrom3f: this.formatDate(this.includedDateFrom3f),
      includedDateTo3f: this.formatDate(this.includedDateTo3f),
      includedPeriodOperator3f: this.includedPeriodOperator3f,
      includedPeriodValue3f: this.includedPeriodValue3f,
      includedPeriodType3f: this.includedPeriodType3f,
      includedTestedValueSet3f: this.includedTestedValueSet3f,
      includedDob3f : this.includedDob3f,
      includedDiagnosisAnyAll3f : this.includedDiagnosisAnyAll3f,
      includedDiagnosisValueSet3f : this.includedDiagnosisValueSet3f,
      includedDiagnosisAgeFrom3f : this.includedDiagnosisAgeFrom3f,
      includedDiagnosisAgeTo3f : this.includedDiagnosisAgeTo3f,
      withWithout4: this.withWithout4,
      includedAnyAll4: this.includedAnyAll4,
      includedValueSet4: this.includedValueSet4,
      includedAreNot4: this.includedAreNot4,
      includedAnyAllFollowedBy4: this. includedAnyAllFollowedBy4,
      includedFollowedByValueSet4: this.includedFollowedByValueSet4,
      includedPeriodOperator4: this.includedPeriodOperator4,
      includedPeriodValue4: this.includedPeriodValue4,
      includedPeriodType4: this.includedPeriodType4,
      withWithout4a: this.withWithout4a,
      includedAnyAll4a: this.includedAnyAll4a,
      includedValueSet4a: this.includedValueSet4a,
      includedAreNot4a: this.includedAreNot4a,
      includedAnyAllFollowedBy4a: this. includedAnyAllFollowedBy4a,
      includedFollowedByValueSet4a: this.includedFollowedByValueSet4a,
      includedPeriodOperator4a: this.includedPeriodOperator4a,
      includedPeriodValue4a: this.includedPeriodValue4a,
      includedPeriodType4a: this.includedPeriodType4a,
      withWithout4b: this.withWithout4b,
      includedAnyAll4b: this.includedAnyAll4b,
      includedValueSet4b: this.includedValueSet4b,
      includedAreNot4b: this.includedAreNot4b,
      includedAnyAllFollowedBy4b: this. includedAnyAllFollowedBy4b,
      includedFollowedByValueSet4b: this.includedFollowedByValueSet4b,
      includedPeriodOperator4b: this.includedPeriodOperator4b,
      includedPeriodValue4b: this.includedPeriodValue4b,
      includedPeriodType4b: this.includedPeriodType4b,
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
                  if (close)
                    this.dialogRef.close(true);
                  this.log.success('Query saved.');
                },
                error => this.log.error('This query could not be saved.')
              );
          }
        });
    } else {
      this.explorerService.saveQuery(this.type.trim(), this.name.trim(), this.registryName.trim(), this.denominatorQuery.trim(), this.id, this.jsonQuery)
        .subscribe(saved => {
            if (close)
              this.dialogRef.close(true);
            this.log.success('Query saved.');
          },
          error => this.log.error('This query could not be saved.')
        );
    }
  }

  onCancelClick(): void {
      MessageBoxDialogComponent.open(this.dialog, 'Cancel edit', 'Are you sure you want to cancel this query edit?', 'Yes', 'No')
        .subscribe(result => {
          if (result) {
            this.dialogRef.close();
          }
        });

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

  addSameQuery1e() {
    this.select1e = true;
  }

  addSameQuery1f() {
    this.select1f = true;
  }

  addSameQuery1g() {
    this.select1g = true;
  }

  addSameQuery1h() {
    this.select1h = true;
  }

  addSameQuery1i() {
    this.select1i = true;
  }

  addSameQuery1j() {
    this.select1j = true;
  }

  addSameQuery1k() {
    this.select1k = true;
  }

  addSameQuery1l() {
    this.select1l = true;
  }

  addSameQuery2() {
    this.select2a = true;
  }

  addSameQuery2b() {
    this.select2b = true;
  }

  addSameQuery2c() {
    this.select2c = true;
  }

  addSameQuery3() {
    this.select3a = true;
  }
  addSameQuery3b() {
    this.select3b = true;
  }
  addSameQuery3c() {
    this.select3c = true;
  }
  addSameQuery3d() {
    this.select3d = true;
  }
  addSameQuery3e() {
    this.select3e = true;
  }
  addSameQuery3f() {
    this.select3f = true;
  }

  addSameQuery4() {
    this.select4a = true;
  }

  addSameQuery4b() {
    this.select4b = true;
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

  flatNodeMap = new Map<OrgItemFlatNode, OrgItemNode>();

  nestedNodeMap = new Map<OrgItemNode, OrgItemFlatNode>();

  selectedParent: OrgItemFlatNode | null = null;

  treeControl: FlatTreeControl<OrgItemFlatNode>;

  treeFlattener: MatTreeFlattener<OrgItemNode, OrgItemFlatNode>;

  dataSource: MatTreeFlatDataSource<OrgItemNode, OrgItemFlatNode>;

  checklistSelection = new SelectionModel<OrgItemFlatNode>(true /* multiple */);

  getLevel = (node: OrgItemFlatNode) => node.level;

  isExpandable = (node: OrgItemFlatNode) => node.expandable;

  getChildren = (node: OrgItemNode): OrgItemNode[] => node.children;

  hasChild = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.expandable;

  hasNoContent = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.item === '';

  transformer = (node: OrgItemNode, level: number) => {
    const existingNode = this.nestedNodeMap.get(node);
    const flatNode = existingNode && existingNode.item === node.item
      ? existingNode
      : new OrgItemFlatNode();
    flatNode.item = node.item;
    flatNode.level = level;
    if (node.children!=undefined)
      flatNode.expandable = node.children.length>0;
    this.flatNodeMap.set(flatNode, node);
    this.nestedNodeMap.set(node, flatNode);
    return flatNode;
  }

  descendantsAllSelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    return descAllSelected;
  }

  descendantsPartiallySelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const result = descendants.some(child => this.checklistSelection.isSelected(child));
    return result && !this.descendantsAllSelected(node);
  }

  OrgItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    const descendants = this.treeControl.getDescendants(node);
    this.checklistSelection.isSelected(node)
      ? this.checklistSelection.select(...descendants)
      : this.checklistSelection.deselect(...descendants);

    descendants.forEach(child => this.checklistSelection.isSelected(child));
    this.checkAllParentsSelection(node);

  }

  OrgLeafItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    this.checkAllParentsSelection(node);

  }

  checkAllParentsSelection(node: OrgItemFlatNode): void {
    let parent: OrgItemFlatNode | null = this.getParentNode(node);
    while (parent) {
      this.checkRootNodeSelection(parent);
      parent = this.getParentNode(parent);
    }
  }

  checkRootNodeSelection(node: OrgItemFlatNode): void {
    const nodeSelected = this.checklistSelection.isSelected(node);
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    if (nodeSelected && !descAllSelected) {
      this.checklistSelection.deselect(node);
    } else if (!nodeSelected && descAllSelected) {
      //this.checklistSelection.select(node);
    }
  }

  getParentNode(node: OrgItemFlatNode): OrgItemFlatNode | null {
    const currentLevel = this.getLevel(node);

    if (currentLevel < 1) {
      return null;
    }

    const startIndex = this.treeControl.dataNodes.indexOf(node) - 1;

    for (let i = startIndex; i >= 0; i--) {
      const currentNode = this.treeControl.dataNodes[i];

      if (this.getLevel(currentNode) < currentLevel) {
        return currentNode;
      }
    }
    return null;
  }

}
