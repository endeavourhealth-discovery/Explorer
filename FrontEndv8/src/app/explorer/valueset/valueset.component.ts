import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {PageEvent} from "@angular/material/paginator";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {SelectionModel} from "@angular/cdk/collections";
import {ValueEditorComponent} from "../valueeditor/valueeditor.component";

export interface DialogData {
  id: string;
}

@Component({
  selector: 'app-valueset',
  templateUrl: './valueset.component.html',
  styleUrls: ['./valueset.component.scss']
})

export class ValueSetComponent {

  selection = new SelectionModel<any>(true, []);

  events: any[] = [];
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;
  id: string = "";

  displayedColumns: string[] = ['select', 'type', 'code', 'term', 'snomed', 'updated'];

  constructor(
    public dialogRef: MatDialogRef<ValueSetComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.id = data.id;
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getValueSet(this.page, this.size, this.id)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
    this.selection.clear();
  }

  displayEvents(events: any) {
    console.log(events);
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
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
    const dialogRef = this.dialog.open(ValueEditorComponent, {
      height: '500px',
      width: '600px',
      data: {type: "", code: "", term: "", snomed: "", id: "", value: this.id}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
    });

  }

  delete() {

    console.log("ID: " + this.selection.selected[0].id);

    let id = "";
    this.selection.selected.map(
      e => {
        id+=","+e.id;
      }
    )

    id = id.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete value set', 'Are you sure you want to delete this value set?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.deleteValue(id.toString())
            .subscribe(saved => {
                this.loadEvents();
              },
              error => this.log.error('This value set could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(ValueEditorComponent, {
      height: '500px',
      width: '600px',
      data: {type:this.selection.selected[0].type, code: this.selection.selected[0].code, term: this.selection.selected[0].term, snomed: this.selection.selected[0].snomed, id: this.selection.selected[0].id, value: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
    });
  }

}
