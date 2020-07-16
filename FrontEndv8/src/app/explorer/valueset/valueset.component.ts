import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {PageEvent} from "@angular/material/paginator";

export interface DialogData {
  id: string;
}

@Component({
  selector: 'app-valueset',
  templateUrl: './valueset.component.html',
  styleUrls: ['./valueset.component.scss']
})

export class ValueSetComponent {
  events: any[] = [];
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;
  id: string = "";

  displayedColumns: string[] = ['type', 'code', 'term', 'snomed', 'updated'];

  constructor(
    public dialogRef: MatDialogRef<ValueSetComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
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

}
