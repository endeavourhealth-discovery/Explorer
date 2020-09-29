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

@Component({
  selector: 'app-registries',
  templateUrl: './registries.component.html',
  styleUrls: ['./registries.component.scss']
})

export class RegistriesComponent implements OnInit {
  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 10;

  displayedColumns: string[] = ['select', 'ccg', 'practice', 'code', 'listSize', 'registry', 'registrySize', 'percentage', 'updated'];
  tiles: any[];
  showGridView: boolean = true;

  selectedCCG: string = '';
  selectedCCGString: string = '';
  selectAllCCG: boolean = true;
  ccgList = [];
  ccgValues = new FormControl(this.ccgList);

  selectAll: boolean = true;

  selectedRegistry: string = '';
  selectedRegistryString: string = '';
  selectAllRegistry: boolean = true;
  registryList = [];
  registryValues = new FormControl(this.registryList);

  practice: string = '';

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private dialog: MatDialog,
    private log: LoggerService) { }

  ngOnInit() {
    this.explorerService.getLookupLists('5')
      .subscribe(
        (result) => this.loadListCCG(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelectionCCG(event) {
    if (event.checked) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    } else {
      this.ccgValues = new FormControl([]);
      this.selectedCCGString = "";
    }
    this.refresh(false);
  }

  toggleSelectionRegistry(event) {
    if (event.checked) {
      this.registryValues = new FormControl(this.registryList);
      this.selectedRegistryString = this.registryList.toString();
    } else {
      this.registryValues = new FormControl([]);
      this.selectedRegistryString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedCCG=="" && this.selectAllCCG) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    }

    if (override) {
      this.selectAllCCG = false;
      this.selectedCCGString = this.selectedCCG.toString();
    }

    if (this.selectedRegistry=="" && this.selectAllRegistry) {
      this.registryValues = new FormControl(this.registryList);
      this.selectedRegistryString = this.registryList.toString();
    }

    if (override) {
      this.selectAllRegistry = false;
      this.selectedRegistryString = this.selectedRegistry.toString();
    }

    this.loadEvents();
  }

  refreshCCG() {
    this.selectAllCCG = false;
    this.selectedCCGString = this.selectedCCG.toString();

    this.explorerService.getLookupLists('6')
      .subscribe(
        (result) => this.loadListRegistry(result),
        (error) => this.log.error(error)
      );
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getRegistries(this.page, this.size, this.selectedCCGString, this.selectedRegistryString, '', '', this.practice)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  loadListCCG(lists: any) {
    this.ccgList = [];

    lists.results.map(
      e => {
        this.ccgList.push(e.type);
      }
    )
    this.ccgValues = new FormControl(this.ccgList);

    this.explorerService.getLookupLists('6')
      .subscribe(
        (result) => this.loadListRegistry(result),
        (error) => this.log.error(error)
      );
  }

  loadListRegistry(lists: any) {
    this.registryList = [];

    lists.results.map(
      e => {
        this.registryList.push(e.type);
      }
    )
    this.registryValues = new FormControl(this.registryList);

    this.refresh(false);
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    this.tiles = [];
    events.results.map(
      e => {
        let tile = {
          "practice": e.practice,
          "text": "% patients on registry",
          "registrySize": e.registrySize,
          "listSize": e.listSize,
          "percentage": this.toPercent(e.registrySize,e.listSize),
          "registry": e.registry,
          "code": e.code,
          "ccg": e.ccg
        }
        this.tiles.push(tile);
      }
    )
  }

  valueDialClass(percentage) {
    if (percentage<10)
      return "good";
    else if (percentage>9&&percentage<20)
      return "ok";
    else if (percentage>19)
      return "poor";
  }

  valueClass(percentage) {
    if (percentage<10)
      return "goodValue";
    else if (percentage>9&&percentage<20)
      return "okValue";
    else if (percentage>19)
      return "poorValue";
  }

  gaugeLabel(value: number) {
    return value+" %";
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

  practiceEntered(event) {
    if (event.key === "Enter") {
      this.loadEvents();
    }
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

}
