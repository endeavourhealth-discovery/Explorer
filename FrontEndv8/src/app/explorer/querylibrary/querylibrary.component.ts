import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatPaginator} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";
import {SelectionModel} from "@angular/cdk/collections";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {MatDialog} from "@angular/material/dialog";
import {AdvancedQueryEditorComponent} from "../advancedqueryeditor/advancedqueryeditor.component";
import {animate, state, style, transition, trigger} from "@angular/animations";
import {MatSort} from "@angular/material/sort";

interface query {
  outputField: string;
  outputType: string;
  schedule: string;
  delivery: string;
  eventType: string;
  datasetValue: string;
  dateFrom: string;
  dateTo: string;
  providerOrganisation: string;
  includedOrganisation: string;
  registrationStatus: string;
  cohortValue: string;
  valueDateFrom: string;
  valueDateTo: string;
  ageFrom: string;
  ageTo: string;
  gender: string;
  postcode: string;
}

@Component({
  selector: 'app-querylibrary',
  templateUrl: './querylibrary.component.html',
  styleUrls: ['./querylibrary.component.scss'],
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({height: '0px', minHeight: '0'})),
      state('expanded', style({height: '*'})),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})

export class QueryLibraryComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);
  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['select', 'type', 'name', 'updated', 'expandArrow'];
  expandedElement: QueryLibraryComponent | null;

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;
  typeList = [];
  typeValues = new FormControl(this.typeList);

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog) {}

  ngOnInit() {
    this.explorerService.getLookupLists('2')
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
    this.explorerService.getQueryLibrary(this.selectedTypeString)
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
      const dialogRef = this.dialog.open(AdvancedQueryEditorComponent, {
        height: '810px',
        width: '1275px',
        data: {id: "", name: "", type: "", query: ""}
      });
      dialogRef.afterClosed().subscribe(result => {
        if (result)
          this.ngOnInit();
      })
  }

  delete() {
    let id = "";
    this.selection.selected.map(
      e => {
        id+=","+e.id;
      }
    )
    id = id.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete query', 'Are you sure you want to delete this query?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {
          this.explorerService.deleteQuery(id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This query could not be deleted.')
            );
        }
      });
  }

  edit() {
      const dialogRef = this.dialog.open(AdvancedQueryEditorComponent, {
        height: '810px',
        width: '1275px',
        data: {
          id: this.selection.selected[0].id,
          name: this.selection.selected[0].name,
          type: this.selection.selected[0].type,
          query: this.selection.selected[0].jsonQuery
        }
      });
      dialogRef.afterClosed().subscribe(result => {
        if (result)
          this.ngOnInit();
      })
  }

  formatDetail(jsonQuery, fieldName) {

    if (jsonQuery != undefined && jsonQuery != "stored_proc_1"&& jsonQuery != "stored_proc_2"&& jsonQuery != "stored_proc_3"&& jsonQuery != "stored_proc_4"&& jsonQuery != "stored_proc_5"&& jsonQuery != "stored_proc_6"&& jsonQuery != "stored_proc_7") {
      let query: query = JSON.parse(jsonQuery);
      let details = '';

      if (fieldName=='providerOrganisation') {
        details = query.providerOrganisation
      } else if (fieldName=='includedOrganisation') {
        details = query.includedOrganisation
      } else if (fieldName=='registrationStatus') {
        details = query.registrationStatus
      }else if (fieldName=='cohortValue') {
        details = query.cohortValue
      }else if (fieldName=='valueDateFrom') {
        details = query.valueDateFrom
      }else if (fieldName=='valueDateTo') {
        details = query.valueDateTo
      }else if (fieldName=='ageFrom') {
        details = query.ageFrom
      }else if (fieldName=='ageTo') {
        details = query.ageTo
      }else if (fieldName=='gender') {
        details = query.gender
      }else if (fieldName=='postcode') {
        details = query.postcode
      }else if (fieldName=='eventType') {
        details = query.eventType
      }else if (fieldName=='datasetValue') {
        details = query.datasetValue
      }else if (fieldName=='dateFrom') {
        details = query.dateFrom
      }else if (fieldName=='dateTo') {
        details = query.dateTo
      }else if (fieldName=='outputField') {
        details = query.outputField
      }else if (fieldName=='outputType') {
        details = query.outputType
      }else if (fieldName=='schedule') {
        details = query.schedule
      }else if (fieldName=='delivery') {
      details = query.delivery
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
