import {Component, Inject, OnInit, ViewChild} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator, PageEvent} from "@angular/material/paginator";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {SelectionModel} from "@angular/cdk/collections";
import {ValueSetCodeEditorComponent} from "../valuesetcodeeditor/valuesetcodeeditor.component";
import {MatSort} from "@angular/material/sort";

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
  value_set_id: string = "";
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['select', 'type', 'code', 'term', 'snomed', 'updated'];

  constructor(
    public dialogRef: MatDialogRef<ValueSetCodeComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.value_set_id = data.value_set_id;
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getValueSetCodes(this.value_set_id)
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
      height: '500px',
      width: '600px',
      data: {type: "", code: "", term: "", snomed: "", id: "", value_set_id: this.value_set_id}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
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
                this.loadEvents();
              },
              error => this.log.error('This value set code could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(ValueSetCodeEditorComponent, {
      height: '500px',
      width: '600px',
      data: {type:this.selection.selected[0].type, code: this.selection.selected[0].code, term: this.selection.selected[0].term, snomed: this.selection.selected[0].snomed, id: this.selection.selected[0].id, value_set_id: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}
