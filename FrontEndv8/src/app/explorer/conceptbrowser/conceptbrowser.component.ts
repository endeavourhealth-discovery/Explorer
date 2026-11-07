import {Component, Inject, OnInit, ViewChild} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator, PageEvent} from "@angular/material/paginator";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {SelectionModel} from "@angular/cdk/collections";
import {MatSort} from "@angular/material/sort";
import {FormControl} from "@angular/forms";
import {ngxCsv} from "ngx-csv";

export interface DialogData {
}

interface dataType {
  value: string;
}

@Component({
  selector: 'app-conceptbrowser',
  templateUrl: './conceptbrowser.component.html',
  styleUrls: ['./conceptbrowser.component.scss']
})

export class ConceptBrowserComponent {

  selection = new SelectionModel<any>(true, []);
  disableForm: boolean;
  type: string;
  selectedDataType: string;
  page: number = 0;
  size: number = 500;

  wait: boolean = false;

  events: any[] = [];
  dataSource: MatTableDataSource<any>;

  dataTypes: dataType[] = [
    {value: 'Observation'},
    {value: 'Ethnicity'},
    {value: 'Encounter'},
    {value: 'Medication'}
  ];

  displayedColumns: string[] = ['originalCode', 'term', 'useCount','select'];

  term = '';

  constructor(
    public dialogRef: MatDialogRef<ConceptBrowserComponent>,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService,
    private dialog: MatDialog,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {

    this.disableForm = true;

    this.events = [
      {originalCode: "", term: "", useCount: ""}
    ];

    this.dataSource = new MatTableDataSource(this.events);
  }

  searchTerm(event) {
    if (event.key === "Enter") {
      this.wait = true;
      this.loadEvents();
    }
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getConcepts(this.page, this.size, this.term)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
    this.selection.clear();
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);

    this.wait = false;
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  addConcepts(): void {
    let header = {
      originalCode: this.type,
      term: this.selectedDataType,
      useCount: 0
    }
    this.selection.selected.unshift(header);
    this.dialogRef.close(this.selection.selected);
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

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.selectedDataType=='' || this.selectedDataType==undefined;
  }

}
