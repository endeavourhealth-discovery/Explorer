import {Component, Inject, OnInit, ViewChild} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator, PageEvent} from "@angular/material/paginator";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {SelectionModel} from "@angular/cdk/collections";
import {ValueSetCodeEditorComponent} from "../valuesetcodeeditor/valuesetcodeeditor.component";
import {MatSort} from "@angular/material/sort";
import {FormControl} from "@angular/forms";
import {ngxCsv} from "ngx-csv";

export interface DialogData {
  value_set_id: string;
}

@Component({
  selector: 'app-valuesetcode',
  templateUrl: './valuesetcode.component.html',
  styleUrls: ['./valuesetcode.component.scss']
})

export class ValueSetCodeComponent {

  selection = new SelectionModel<any>(true, []);

  events: any[] = [];
  dataSource: MatTableDataSource<any>;
  valueSetId: string = "";
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['type', 'dataType', 'code', 'term', 'snomed', 'updated','select'];

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;

  typeList = [];
  typeValues = new FormControl(this.typeList);

  constructor(
    public dialogRef: MatDialogRef<ValueSetCodeComponent>,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService,
    private dialog: MatDialog,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.valueSetId = data.value_set_id;
    this.init();
  }

  init() {
    this.start();
  }

  start() {
    this.explorerService.getLookupListValueSet(this.valueSetId)
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
    this.loadEvents();
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
    this.explorerService.getValueSetCodes(this.valueSetId, this.selectedTypeString)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
    this.selection.clear();
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  onDownloadClick() {
    let values:any = this.dataSource.filteredData;
    //remove id from the data to be saved to csv
    let exportData = values.map(({type, code, term, snomed, updated}) => ({type, code, term, snomed, updated}));
    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['Type', 'Original Code', 'Original Term', 'Snomed ID', 'Last Updated'],
        showTitle: false,
        title: 'Value Set Codes',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'value_set_codes', options);
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
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
    const dialogRef = this.dialog.open(ValueSetCodeEditorComponent, {
      disableClose: true,
      height: '550px',
      width: '600px',
      data: {type: "", code: "", term: "", snomed: "", id: "", value_set_id: this.valueSetId}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.init();
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

    MessageBoxDialogComponent.open(this.dialog, 'Delete value set code', 'Are you sure you want to delete this value set code?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.deleteValueSetCode(id.toString())
            .subscribe(saved => {
                this.init();
              },
              error => this.log.error('This value set code could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(ValueSetCodeEditorComponent, {
      disableClose: true,
      height: '550px',
      width: '600px',
      data: {type:this.selection.selected[0].type, selectedDataType:this.selection.selected[0].dataType, code: this.selection.selected[0].code, term: this.selection.selected[0].term, snomed: this.selection.selected[0].snomed, id: this.selection.selected[0].id, value_set_id: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.init();
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  showSnomed(code) {
    let url = 'https://termbrowser.nhs.uk/?perspective=full&conceptId1='+code+'&edition=uk-edition&release=v20201001&server=https://termbrowser.nhs.uk/sct-browser-api/snomed&langRefset=999001261000000100,999000691000001104';

    window.open(url);

  }
}
