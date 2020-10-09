import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {PatientComponent} from "../patient/patient.component";
import {MatDialog} from "@angular/material/dialog";
import {SelectionModel} from "@angular/cdk/collections";
import {RegistryEditorComponent} from "../registryeditor/registryeditor.component";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {RegistryIndicatorEditorComponent} from "../registryindicatoreditor/registryindicatoreditor.component";

@Component({
  selector: 'app-registryindicators',
  templateUrl: './registryindicators.component.html',
  styleUrls: ['./registryindicators.component.scss']
})

export class RegistryIndicatorsComponent implements OnInit {
  selection = new SelectionModel<any>(true, []);

  registry: string = '';
  odscode: string = '';
  ccg: string = '';
  practiceName: string = '';
  registrySize: string = '';
  practice: string = '';
  practiceTitle: string = '';
  tiles: any[];
  showDashboard: boolean = false;

  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 11;

  displayedColumns: string[] = ['select','listSize', 'registry', 'registrySize', 'percentage', 'updated'];

  constructor(
    private route: ActivatedRoute,
    private dialog: MatDialog,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  ngOnInit() {
    this.loadEvents();
  }

  loadEvents() {
    this.route.queryParams
      .subscribe(params => {
        this.registry = params['registry'];
        this.odscode = params['odscode'];
        this.ccg = params['ccg'];
        this.practiceName = params['practice'];
        this.registrySize = params['registrySize'];
        this.practiceTitle = params['practiceTitle'];
      });

    this.events = null;
    this.explorerService.getRegistries(this.page, this.size,'')
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    this.tiles = [];
    events.results.map(
      e => {
        let tile = {
          "registry": e.registry,
          "text": "% patients meeting target",
          "registrySize": e.registrySize,
          "listSize": e.listSize,
          "percentage": this.toPercent(e.registrySize,e.listSize)
        }
        this.tiles.push(tile);
      }
    )
  }

  valueDialClass(percentage) {
    if (percentage>89)
      return "good";
    else if (percentage>79&&percentage<90)
      return "ok";
    else if (percentage<80)
      return "poor";
  }

  valueClass(percentage) {
    if (percentage>89)
      return "goodValue";
    else if (percentage>79&&percentage<90)
      return "okValue";
    else if (percentage<80)
      return "poorValue";
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
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
      height: '780px',
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

  gaugeLabel(value: number) {
    return value+" %";
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
    const dialogRef = this.dialog.open(RegistryIndicatorEditorComponent, {
      height: '400px',
      width: '600px',
      data: {id: "", name: this.registry, query: "", indicator: "", ccg: this.ccg, practice: this.practiceName, code: this.odscode}
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

    MessageBoxDialogComponent.open(this.dialog, 'Delete registry indicator', 'Are you sure you want to delete this registry indicator?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {
          this.explorerService.deleteRegistryIndicator(id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This registry indicator could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(RegistryIndicatorEditorComponent, {
      height: '400px',
      width: '600px',
      data: {id: this.selection.selected[0].id, name: this.selection.selected[0].parentRegistry,
      query:this.selection.selected[0].query, indicator:this.selection.selected[0].registry,
      ccg: "", practice: "", code: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });
  }

  duplicate() {
    MessageBoxDialogComponent.open(this.dialog, 'Duplicate registry indicator', 'Are you sure you want to duplicate this registry indicator?', 'Duplicate', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.duplicateRegistryIndicator(this.selection.selected[0].id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This registry indicator could not be duplicated.')
            );
        }
      });
  }

}
