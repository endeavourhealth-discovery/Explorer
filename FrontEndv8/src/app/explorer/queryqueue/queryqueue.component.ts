import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatPaginator, PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {ValueSetEditorComponent} from "../valueseteditor/valueseteditor.component";
import {SelectionModel} from '@angular/cdk/collections';
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {FormControl} from "@angular/forms";
import {ValueSetCodeComponent} from "../valuesetcode/valuesetcode.component";
import {MatSort} from "@angular/material/sort";
import {ngxCsv} from "ngx-csv";

@Component({
  selector: 'app-queryqueue',
  templateUrl: './queryqueue.component.html',
  styleUrls: ['./queryqueue.component.scss']
})

export class QueryQueueComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  filterText: string;

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['type', 'registry', 'date', 'status', 'timeSubmit', 'timeFinish', 'timeExecute'];

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
    this.explorerService.getQueryQueue()
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  formatStatus(status: any) {
    if (status == 'Y') {
      return 'Yes';
    }
    else if (status == 'N')
    {
      return 'No';
    }
  }
}