import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {ActivatedRoute, Router} from "@angular/router";
import {FormControl} from "@angular/forms";
import {SelectionModel} from "@angular/cdk/collections";
import {MatDialog} from "@angular/material/dialog";
import {animate, state, style, transition, trigger} from '@angular/animations';
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";

interface widget {
  icon: string;
  name: string;
}

interface query {
  selectedVisualisation1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;
  visualType: widget[];
}

@Component({
  selector: 'app-covidlibrary',
  templateUrl: './covidlibrary.component.html',
  styleUrls: ['./covidlibrary.component.scss'],
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({height: '0px', minHeight: '0'})),
      state('expanded', style({height: '*'})),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
})

export class CovidLibraryComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);
  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['type', 'name', 'updated', 'expandArrow'];
  expandedElement: CovidLibraryComponent | null;

  typeList = [];
  typeValues = new FormControl(this.typeList);
  originalData = [];

  projectId: string = '';

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService,
    private router: Router) { }

  ngOnInit() {
    this.start(this.projectId);

    this.userManagerService.onProjectChange.subscribe(
      (newProject) => this.start(newProject.id),
      (error) => this.log.error(error)
    );

  }

  start(newProject: any) {
    if (newProject!=this.projectId && this.projectId!='')
      this.router.navigate(['/covidlibrary']);

    this.projectId = newProject;

    this.events = null;
    this.explorerService.getCovidLibrary()
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );

    this.selection.clear();
  }

  displayEvents(events: any) {
    this.events = events;

    this.originalData = JSON.parse(JSON.stringify(events.results));

    let typeList = [];

    let prevFolder = '';
    let thisFolder = '';

    events.results.forEach( (item, index) => {
      thisFolder = events.results[index].type;
      if (thisFolder==prevFolder) {
        events.results[index].type = '↳';
      }
      typeList.push(events.results[index]);
      if (events.results[index].type != '↳')
        prevFolder = thisFolder;
    });

    this.dataSource = new MatTableDataSource(typeList);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  formatDetail(jsonQuery, fieldName){

    if (jsonQuery != undefined) {
      let query: query = JSON.parse(jsonQuery);
      let details = '';

      if (fieldName=='selectedVisualisation1') {
        details = query.selectedVisualisation1;
      } else if (fieldName=='visualType1') {
        details = query.visualType[0].name.toString();
      }

      return details;
    }
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}
