import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {MatPaginator} from '@angular/material/paginator';
import {ActivatedRoute, Router} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {MatSort} from "@angular/material/sort";
import {FormControl} from "@angular/forms";
import {animate, state, style, transition, trigger} from "@angular/animations";

@Component({
  selector: 'app-auditlog',
  templateUrl: './auditlog.component.html',
  styleUrls: ['./auditlog.component.scss'],
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({height: '0px', minHeight: '0'})),
      state('expanded', style({height: '*'})),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})

export class AuditLogComponent implements OnInit {

  filterText: string;

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['user', 'roleName', 'organisation', 'roleLevel', 'pid', 'auditType', 'auditDate', 'queryName','data', 'expandArrow'];
  expandedElement: AuditLogComponent | null;

  projectId: string = '';
  init: any = 0;

  selectedUser: string = '';
  userList = [];
  userValues = new FormControl(this.userList);

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

    this.explorerService.getLookupLists('24','')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  loadList(lists: any) {
    this.userList = [];

    lists.results.map(
      e => {
        this.userList.push(e.type);
      }
    )
    this.userValues = new FormControl(this.userList);

    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getAuditLog(this.selectedUser)
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

  formatJson(element) {
    return element.replaceAll('included','').replaceAll('"','').replaceAll('{','').replaceAll('}','').replaceAll(':',' : ').replaceAll(',',' , ');
  }

}
