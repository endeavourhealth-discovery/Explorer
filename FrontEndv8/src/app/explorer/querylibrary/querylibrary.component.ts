import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
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
  demographics: boolean;
  encounters: boolean;
  medication: boolean;
  clinicalEvents: boolean;
  schedule: string;
  delivery: string;
  providerOrganisation: string;
  registrationStatus: string;
  timeSeries: boolean;
  seriesTable: string;
  seriesField: string;
  seriesClinicalEventValueSet: string;
  seriesMedicationValueSet: string;
  seriesEncounterValueSet: string;
  denominatorQuery: string;
  registryName: string;
  targetPercentage: string;
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

  displayedColumns: string[] = ['type', 'name', 'denominatorQuery', 'select', 'expandArrow'];
  expandedElement: QueryLibraryComponent | null;

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;
  typeList = [];
  typeValues = new FormControl(this.typeList);
  originalData = [];

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService,
    private dialog: MatDialog) {}

  ngOnInit() {

    this.userManagerService.onProjectChange.subscribe(
      (newProject) => this.start(),
      (error) => this.log.error(error)
    );

    this.start();
  }

  start() {
    this.explorerService.getLookupLists('2','')
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
      const dialogRef = this.dialog.open(AdvancedQueryEditorComponent, {
        disableClose: true,
        height: '950px',
        width: '1275px',
        data: {id: "", name: "", type: "", registryName: "", denominatorQuery: "", query: ""}
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

  duplicate() {
    MessageBoxDialogComponent.open(this.dialog, 'Duplicate query?', 'Are you sure you want to duplicate this query?', 'Duplicate', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.duplicateQuery(this.selection.selected[0].id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This query could not be duplicated.')
            );
        }
      });
  }

  edit() {
    let type = '';

    this.originalData.forEach( (item, index) => {
      if (this.originalData[index].id == this.selection.selected[0].id) {
        type = this.originalData[index].type;
      }
    });

    const dialogRef = this.dialog.open(AdvancedQueryEditorComponent, {
      disableClose: true,
      height: '950px',
      width: '1275px',
      data: {
        id: this.selection.selected[0].id,
        name: this.selection.selected[0].name,
        registryName: this.selection.selected[0].registryName,
        denominatorQuery: this.selection.selected[0].denominatorQuery,
        type: type,
        query: this.selection.selected[0].jsonQuery
      }
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    })
  }

  formatDetail(jsonQuery, fieldName) {

    if (jsonQuery != undefined) {
      let query: query = JSON.parse(jsonQuery);
      let details = '';

      if (fieldName=='providerOrganisation') {
        details = query.providerOrganisation.toString().replace(/,/g, ', ')
      } else if (fieldName=='registrationStatus') {
        details = query.registrationStatus
      }else if (fieldName=='tables') {
        details = '';
        if (query.demographics)
          details += ' Demographics ';
        if (query.encounters)
          details += ' Encounters ';
        if (query.medication)
          details += ' Medication ';
        if (query.clinicalEvents)
          details += ' Clinical events ';
      }else if (fieldName=='timeSeries') {
        if (query.timeSeries == true) {
          details += ' Yes ';
        }
        if (query.timeSeries == false) {
          details += ' No ';
        }
      }else if (fieldName=='seriesTable') {
        details = query.seriesTable;
      }else if (fieldName=='seriesField') {
        if (query.seriesTable == 'Clinical events') {
          details = query.seriesClinicalEventValueSet;
        }
        else if (query.seriesTable == 'Medication') {
          details = query.seriesMedicationValueSet;
        }
        else if (query.seriesTable == 'Encounter') {
          details = query.seriesEncounterValueSet;
        }
      }else if (fieldName=='schedule') {
        details = query.schedule
      }else if (fieldName=='delivery') {
        details = query.delivery
      }else if (fieldName=='targetPercentage') {
        details = query.targetPercentage
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
