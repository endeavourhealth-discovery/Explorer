import {Component, Inject, OnInit, ViewChild} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator, PageEvent} from "@angular/material/paginator";
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {SelectionModel} from "@angular/cdk/collections";
import {OrganisationsEditorComponent} from "../organisationseditor/organisationseditor.component";
import {MatSort} from "@angular/material/sort";

export interface DialogData {
  organisation_group_id: string;
}

@Component({
  selector: 'app-organisations',
  templateUrl: './organisations.component.html',
  styleUrls: ['./organisations.component.scss']
})

export class OrganisationsComponent {

  selection = new SelectionModel<any>(true, []);

  events: any[] = [];
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  organisation_group_id: string = "";

  displayedColumns: string[] = ['type', 'name', 'code', 'updated','select'];

  constructor(
    public dialogRef: MatDialogRef<OrganisationsComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.organisation_group_id = data.organisation_group_id;
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getOrganisations(this.organisation_group_id)
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
    const dialogRef = this.dialog.open(OrganisationsEditorComponent, {
      height: '500px',
      width: '600px',
      data: {name: "", type: "", code: "", id: "", organisation_group_id: this.organisation_group_id}
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

    MessageBoxDialogComponent.open(this.dialog, 'Delete organisation', 'Are you sure you want to delete this organisation?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.deleteOrganisation(id.toString())
            .subscribe(saved => {
                this.loadEvents();
              },
              error => this.log.error('This organisation could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(OrganisationsEditorComponent, {
      height: '500px',
      width: '600px',
      data: {name:this.selection.selected[0].name, type:this.selection.selected[0].type, code: this.selection.selected[0].code, id: this.selection.selected[0].id, organisation_group_id: ""}
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
