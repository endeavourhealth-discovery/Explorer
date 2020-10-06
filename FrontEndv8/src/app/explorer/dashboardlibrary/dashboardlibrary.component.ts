import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute, Router} from "@angular/router";
import {FormControl} from "@angular/forms";
import {SelectionModel} from "@angular/cdk/collections";
import {MatDialog} from "@angular/material/dialog";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {DashboardEditorComponent} from "../dashboardeditor/dashboardeditor.component";
import {animate, state, style, transition, trigger} from '@angular/animations';

interface widget {
  icon: string;
  name: string;
}

interface query {
  selectedQuery1: string;
  selectedVisualisation1: string;
  selectedOutputField1: string;
  selectedOutputType1: string;
  selectedSchedule1: string;
  selectedSeries1: string[];
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedQuery2: string;
  selectedVisualisation2: string;
  selectedOutputField2: string;
  selectedOutputType2: string;
  selectedSchedule2: string;
  selectedSeries2: string[];
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedQuery3: string;
  selectedVisualisation3: string;
  selectedOutputField3: string;
  selectedOutputType3: string;
  selectedSchedule3: string;
  selectedSeries3: string[];
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedQuery4: string;
  selectedVisualisation4: string;
  selectedOutputField4: string;
  selectedOutputType4: string;
  selectedSchedule4: string;
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
  page: number = 0;
  size: number = 11;

  displayedColumns: string[] = ['select', 'type', 'name', 'updated', 'expandArrow'];
  expandedElement: DashboardLibraryComponent | null;

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;
  typeList = [];
  typeValues = new FormControl(this.typeList);

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
    this.explorerService.getLookupLists('1')
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
    this.explorerService.getDashboardLibrary(this.page, this.size, this.selectedTypeString)
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
    this.dataSource = new MatTableDataSource(events.results);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
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
    const dialogRef = this.dialog.open(DashboardEditorComponent, {
      height: '720px',
      width: '1200px',
      data: {dashboardId: this.selection.selected[0].dashboardId, name: this.selection.selected[0].name, type:this.selection.selected[0].type, query: this.selection.selected[0].jsonQuery}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });

  }

  widgetsShown (jsonQuery) {
    let query: query = JSON.parse(jsonQuery);
    let details = '';

    if (query.visualType.length == 1) {
      this.widget1 = true;
    } else if (query.visualType.length == 2) {
      this.widget2 = true;
    } else if (query.visualType.length == 3) {
      this.widget3 = true;
    } else if (query.visualType.length == 4) {
      this.widget4 = true;
    }
  }

  formatDetail(jsonQuery, fieldName){

    if (jsonQuery != undefined) {
      let query: query = JSON.parse(jsonQuery);
      let details = '';

      if (this.widget1 == true) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedOutputField1') {
          details = query.selectedOutputField1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        }
      } else if (this.widget2 == true) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedOutputField1') {
          details = query.selectedOutputField1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedOutputField2') {
          details = query.selectedOutputField2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        }
      } else if (this.widget3 == true) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedOutputField1') {
          details = query.selectedOutputField1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedOutputField2') {
          details = query.selectedOutputField2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        } else if (fieldName=='selectedVisualisation3') {
          details = query.selectedVisualisation3;
        } else if (fieldName=='selectedOutputField3') {
          details = query.selectedOutputField3;
        } else if (fieldName=='selectedSeries3') {
          details = query.selectedSeries3.toString();
        } else if (fieldName=='visualType3') {
          details = query.visualType[2].name.toString();
        }
      } else if (this.widget4 == true) {
        if (fieldName=='selectedVisualisation1') {
          details = query.selectedVisualisation1;
        } else if (fieldName=='selectedOutputField1') {
          details = query.selectedOutputField1;
        } else if (fieldName=='selectedSeries1') {
          details = query.selectedSeries1.toString();
        } else if (fieldName=='visualType1') {
          details = query.visualType[0].name.toString();
        } else if (fieldName=='selectedVisualisation2') {
          details = query.selectedVisualisation2;
        } else if (fieldName=='selectedOutputField2') {
          details = query.selectedOutputField2;
        } else if (fieldName=='selectedSeries2') {
          details = query.selectedSeries2.toString();
        } else if (fieldName=='visualType2') {
          details = query.visualType[1].name.toString();
        } else if (fieldName=='selectedVisualisation3') {
          details = query.selectedVisualisation3;
        } else if (fieldName=='selectedOutputField3') {
          details = query.selectedOutputField3;
        } else if (fieldName=='selectedSeries3') {
          details = query.selectedSeries3.toString();
        } else if (fieldName=='visualType3') {
          details = query.visualType[2].name.toString();
        } else if (fieldName=='selectedVisualisation4') {
          details = query.selectedVisualisation4;
        } else if (fieldName=='selectedOutputField4') {
          details = query.selectedOutputField4;
        } else if (fieldName=='selectedSeries4') {
          details = query.selectedSeries4.toString();
        } else if (fieldName=='visualType4') {
          details = query.visualType[3].name.toString();
        }
      }

      return details;
    }
  }

}
