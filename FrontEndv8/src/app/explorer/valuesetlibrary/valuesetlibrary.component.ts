import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, MessageBoxDialogComponent} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {ValueSetComponent} from "../valueset/valueset.component";
import {ValueSetEditorComponent} from "../valueseteditor/valueseteditor.component";
import {SelectionModel} from '@angular/cdk/collections';

@Component({
  selector: 'app-valuesetlibrary',
  templateUrl: './valuesetlibrary.component.html',
  styleUrls: ['./valuesetlibrary.component.scss']
})

export class ValueSetLibraryComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;

  displayedColumns: string[] = ['select', 'type', 'name', 'updated'];

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog) { }

  ngOnInit() {
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    console.log("page: "+this.page+", size: "+this.size);
    this.explorerService.getValueSetLibrary(this.page, this.size)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );

    this.selection.clear();
  }

  displayEvents(events: any) {
    console.log("Events: " + events);
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

  valuesDialog(id: any) {
    const dialogRef = this.dialog.open(ValueSetComponent, {
      height: '780px',
      width: '1600px',

      data: {id: id}
    });
  }

  add() {
    const dialogRef = this.dialog.open(ValueSetEditorComponent, {
      height: '320px',
      width: '600px',
      data: {id: "", name: "", type: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
    });

  }

  delete() {
    console.log("Selected: " + this.selection.selected);

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

          this.explorerService.deleteValueSet(id.toString())
            .subscribe(saved => {
                this.loadEvents();
              },
              error => this.log.error('This value set could not be deleted.')
            );
        }
      });
  }

  edit() {

    let id = "";
    this.selection.selected.map(
      e => {
        id+=","+e.id;
      }
    )
    id = id.substr(1);

    const dialogRef = this.dialog.open(ValueSetEditorComponent, {
      height: '320px',
      width: '600px',
      data: {id: id, name: this.selection.selected[0].name, type:this.selection.selected[0].type}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.loadEvents();
    });

  }

}
