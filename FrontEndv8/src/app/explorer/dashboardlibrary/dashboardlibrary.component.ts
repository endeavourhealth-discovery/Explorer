import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {ActivatedRoute, Router} from "@angular/router";
import {FormControl} from "@angular/forms";
import {SelectionModel} from "@angular/cdk/collections";
import {MatDialog} from "@angular/material/dialog";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {DashboardEditorComponent} from "../dashboardeditor/dashboardeditor.component";
import {animate, state, style, transition, trigger} from '@angular/animations';
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";

interface widget {
  icon: string;
  name: string;
}

interface query {
  selectedVisualisation1: string;
  selectedSeries1: string[];
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedVisualisation2: string;
  selectedSeries2: string[];
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedVisualisation3: string;
  selectedSeries3: string[];
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedVisualisation4: string;
  selectedSeries4: string[];
  xAxisLabel4: string;
  yAxisLabel4: string;
  visualType: widget[];
}

@Component({
  selector: 'app-dashboardlibrary',
  templateUrl: './dashboardlibrary.component.html',
  styleUrls: ['./dashboardlibrary.component.scss'],
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({height: '0px', minHeight: '0'})),
      state('expanded', style({height: '*'})),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})

export class DashboardLibraryComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);
  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;


  displayedColumns: string[] = ['type', 'name', 'updated', 'select', 'expandArrow'];
  expandedElement: DashboardLibraryComponent | null;

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;
  typeList = [];
  typeValues = new FormControl(this.typeList);
  originalData = [];

  widget1: boolean = false;
  widget2: boolean = false;
  widget3: boolean = false;
  widget4: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private router: Router,
    private dialog: MatDialog) { }

  ngOnInit() {
    this.explorerService.getLookupLists('1','')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelection(event) {
    if (event.checked) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    } else {
      this.typeValues = new FormControl([]);
      this.selectedTypeString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedType=="" && this.selectAll) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    }

    if (override) {
      this.selectAll = false;
      this.selectedTypeString = this.selectedType.toString();
    }
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getDashboardLibrary(this.selectedTypeString)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );

    this.selection.clear();
  }

  loadList(lists: any) {
    this.typeList = [];
    lists.results.map(
      e => {
        this.typeList.push(e.type);
      }
    )
    this.typeValues = new FormControl(this.typeList);

    this.refresh(false);
  }

  displayEvents(events: any) {
    this.events = events;

    this.originalData = JSON.parse(JSON.stringify(events.results));

    let typeList = [];

    let prevFolder = '';
    let thisFolder = '';

    events.results.forEach( (item, index) => {
      thisFolder = events.results[index].type;
      if (thisFolder==prevFolder) {
        events.results[index].type = '↳';
      }
      typeList.push(events.results[index]);
      if (events.results[index].type != '↳')
        prevFolder = thisFolder;
    });

    this.dataSource = new MatTableDataSource(typeList);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
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
    const dialogRef = this.dialog.open(DashboardEditorComponent, {
      disableClose: true,
      height: '720px',
      width: '1200px',
      data: {dashboardId: "", name: "", type: "", query: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });

  }

  delete() {
    let dashboardId = "";
    this.selection.selected.map(
      e => {
        dashboardId+=","+e.dashboardId;
      }
    )
    dashboardId = dashboardId.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete dashboard', 'Are you sure you want to delete this dashboard?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.deleteDashboard(dashboardId.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This dashboard could not be deleted.')
            );
        }
      });
  }

  edit() {
    let type = '';

    this.originalData.forEach( (item, index) => {
      if (this.originalData[index].dashboardId == this.selection.selected[0].dashboardId) {
        type = this.originalData[index].type;
      }
    });

    const dialogRef = this.dialog.open(DashboardEditorComponent, {
      disableClose: true,
      height: '720px',
      width: '1200px',
      data: {dashboardId: this.selection.selected[0].dashboardId, name: this.selection.selected[0].name, type:type, query: this.selection.selected[0].jsonQuery}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });

  }

  duplicate() {
    MessageBoxDialogComponent.open(this.dialog, 'Duplicate dashboard?', 'Are you sure you want to duplicate this dashboard?', 'Duplicate', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.duplicateDashboard(this.selection.selected[0].dashboardId.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This dashboard could not be duplicated.')
            );
        }
      });
  }

  widgetsShown (jsonQuery) {
    if (jsonQuery != undefined) {
      let query: query = JSON.parse(jsonQuery);

      if (query.visualType.length == 1) {
        this.widget1 = true;
        this.widget2 = false;
        this.widget3 = false;
        this.widget4 = false;
      } else if (query.visualType.length == 2) {
        this.widget1 = false;
        this.widget2 = true;
        this.widget3 = false;
        this.widget4 = false;
      } else if (query.visualType.length == 3) {
        this.widget1 = false;
        this.widget2 = false;
        this.widget3 = true;
        this.widget4 = false;
      } else if (query.visualType.length == 4) {
        this.widget1 = false;
        this.widget2 = false;
        this.widget3 = false;
        this.widget4 = true;
      }
    }
  }

  formatDetail(jsonQuery, fieldName){

    if (jsonQuery != undefined) {
      let query: query = JSON.parse(jsonQuery);
      let details = '';

      if (query.visualType.length == 1) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        }
      } else if (query.visualType.length == 2) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        }
      } else if (query.visualType.length == 3) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        } else if (fieldName=='selectedVisualisation3') {
          details = query.selectedVisualisation3;
        } else if (fieldName=='selectedSeries3') {
          details = query.selectedSeries3.toString();
        } else if (fieldName=='visualType3') {
          details = query.visualType[2].name.toString();
        }
      } else if (query.visualType.length == 4) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        } else if (fieldName=='selectedVisualisation3') {
          details = query.selectedVisualisation3;
        } else if (fieldName=='selectedSeries3') {
          details = query.selectedSeries3.toString();
        } else if (fieldName=='visualType3') {
          details = query.visualType[2].name.toString();
        } else if (fieldName=='selectedVisualisation4') {
          details = query.selectedVisualisation4;
        } else if (fieldName=='selectedSeries4') {
          details = query.selectedSeries4.toString();
        } else if (fieldName=='visualType4') {
          details = query.visualType[3].name.toString();
        }
      }

      return details;
    }
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}
