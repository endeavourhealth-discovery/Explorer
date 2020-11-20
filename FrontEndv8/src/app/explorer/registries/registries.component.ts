import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";
import {PatientComponent} from "../patient/patient.component";
import {MatDialog} from "@angular/material/dialog";
import {SelectionModel} from "@angular/cdk/collections";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {RegistryEditorComponent} from "../registryeditor/registryeditor.component";
import {TrendComponent} from "../trend/trend.component";

interface queryList {
  registry: string,
  query: string
}

@Component({
  selector: 'app-registries',
  templateUrl: './registries.component.html',
  styleUrls: ['./registries.component.scss']
})

export class RegistriesComponent implements OnInit {
  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  currentCCG: string = '';
  queryList: queryList[];

  displayedColumns: string[] = ['select', 'org', 'listSize', 'registrySize', 'allColumns'];

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private dialog: MatDialog,
    private log: LoggerService) { }

  ngOnInit() {
    this.loadEvents('', '');

    this.explorerService.getRegistryQueries()
      .subscribe(
        (result) => this.loadQueries(result),
        (error) => this.log.error(error)
      );
  }

  loadQueries(lists: any) {
    this.queryList = lists.results;

  }

  loadEvents(org: any, registry: any) {
    this.events = null;
    this.explorerService.getRegistries(org, registry)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  displayEvents(events: any) {
    this.events = events;

    if (events.results[0].registrySize=='')
      this.displayedColumns = ['select', 'org', 'listSize', 'allColumns'];
    else
      this.displayedColumns = ['select', 'org', 'listSize', 'registrySize', 'allColumns'];

    this.dataSource = new MatTableDataSource(events.results);
  }

  getSize(index, registrySize) {
    if (index==0)
      return "";

    if (index>0) {
      return (index*1).toLocaleString();
    } else {
      return index
    }
  }

  getQuery(registryLookup: any) {
    let query = this.queryList.find( record => record.registry === registryLookup);

    if (query!=undefined)
      return query.query
    else
      return '';

  }

  getOrgs(ccg: any,registry: any) {
   if (this.selection.selected.length > 0)
     return;

   if (ccg=="Indicator")
      ccg = this.currentCCG;
    else if (ccg=='Back to Clinical Commissioning Groups')
      ccg = '';

    this.currentCCG = ccg;

    this.loadEvents(ccg, registry);
  }

  toPercent(registrysize: any, listsize: any) {
    let val: any = (registrysize/listsize*100).toFixed(1);
    if (listsize==0)
      val = 0;
    return val;
  }

  showPatientDialog() {
    this.patientDialog("", "");
  }

  patientDialog(chartName: any, seriesName: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      height: '830px',
      width: '1600px',

      data: {chartName: "covid_shielding_ccg", seriesName: "high/moderate risk (50-59)", ccgs: "NHS Tower Hamlets CCG"}
    });

    dialogRef.afterClosed().subscribe(result => {
      let patientId = 0;
      if (result) {
        patientId = result;
        window.location.href = "https://devgateway.discoverydataservice.net/record-viewer/#/summary?patient_id="+patientId;
      }
    });
  }

  isAllSelected() {
    if (this.dataSource==undefined)
      return false;
    const numSelected = this.selection.selected.length;
    const numRows = this.dataSource.data.length;
    return numSelected === numRows;
  }

  masterToggle() {
    this.isAllSelected() ?
      this.selection.clear() :
      this.dataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabel(row?: any): string {
    if (!row) {
      return `${this.isAllSelected() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.position + 1}`;
  }

  add() {
    const dialogRef = this.dialog.open(RegistryEditorComponent, {
      height: '400px',
      width: '600px',
      data: {id: "", name: "", query: "", ccg: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });
  }

  delete() {
    let id = "";
    this.selection.selected.map(
      e => {
        id+=","+e.id;
      }
    )
    id = id.substr(1);

    let name = "";
    this.selection.selected.map(
      e => {
        name+=","+e.name;
      }
    )
    name = name.substr(1);

    let odscode = "";
    this.selection.selected.map(
      e => {
        odscode+=","+e.code;
      }
    )
    odscode = odscode.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete registry', 'Are you sure you want to delete this registry?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {
          this.explorerService.deleteRegistry(id.toString(), name.toString(), odscode.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This registry could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(RegistryEditorComponent, {
      height: '400px',
      width: '600px',
      data: {id: this.selection.selected[0].id, name: this.selection.selected[0].name, query:this.selection.selected[0].query, ccg:this.selection.selected[0].ccg}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });
  }

  duplicate() {
    MessageBoxDialogComponent.open(this.dialog, 'Duplicate registry', 'Are you sure you want to duplicate this registry?', 'Duplicate', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.duplicateRegistry(this.selection.selected[0].id.toString(),this.selection.selected[0].name.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This registry could not be duplicated.')
            );
        }
      });
  }

  showTrend(org: string) {
    var orgs = "";

    for (let s of this.selection.selected) {
      orgs = orgs + s.org + ",";
    }

    if (orgs != "")
    {
      orgs = orgs.replace(/,\s*$/, "");
    }

    orgs = orgs +",CCG AVERAGE";

    const dialogRef = this.dialog.open(TrendComponent, {
      height: '900px',
      width: '1800px',
      data: {orgs: orgs}
    });

    dialogRef.afterClosed().subscribe(result => {

    });
  }

  gaugeLabel(value: number) {
    return value+" %";
  }

  valueDialClass(percentage) {
    if (percentage>=65)
      return "good";
    else if (percentage<65)
      return "poor";
  }

  valueClass(percentage) {
    if (percentage>=65)
      return "goodValue";
    else if (percentage<65)
      return "poorValue";
  }

}
