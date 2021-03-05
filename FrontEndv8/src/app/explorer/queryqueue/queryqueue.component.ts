import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {MatPaginator} from '@angular/material/paginator';
import {ActivatedRoute, Router} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {SelectionModel} from '@angular/cdk/collections';
import {MatSort} from "@angular/material/sort";

@Component({
  selector: 'app-queryqueue',
  templateUrl: './queryqueue.component.html',
  styleUrls: ['./queryqueue.component.scss']
})

export class QueryQueueComponent implements OnInit {

  selection = new SelectionModel<any>(false, []);

  filterText: string;

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['type', 'registry', 'date', 'status', 'timeSubmit', 'timeFinish', 'timeExecute', 'error', 'select'];

  projectId: string = '';
  init: any = 0;

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private userManagerService: UserManagerService,
    private router: Router,
    private log: LoggerService,
    private dialog: MatDialog) {
    this.userManagerService.onProjectChange.subscribe(
      (newProject) => this.start(newProject.id),
      (error) => this.log.error(error)
    );
  }

  ngOnInit() {
    this.start(this.projectId);
  }

  start(newProject: any) {
    this.init++;

    if (this.init==1)
      return;

    if (newProject!=this.projectId) {
      this.router.navigate(['/covidlibrary']);
      return;
    }

    this.projectId = newProject;

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
    if (status == 'A') {
      return 'Yes';
    }
    else if (status == 'N')
    {
      return 'No';
    }
  }

  refresh() {
    this.ngOnInit();
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

  resetQuery (query: any) {
    this.explorerService.resetQueue(query)
      .subscribe(saved => {
        this.log.success('Query reset.')
        },
        error => this.log.error('This query could not be reset.')
      );
    this.ngOnInit();
  }

}
