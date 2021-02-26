import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";
import {MatDialog} from "@angular/material/dialog";
import {SelectionModel} from "@angular/cdk/collections";
import {Router} from "@angular/router";

import {TrendComponent} from "../trend/trend.component";

interface queryList {
  registry: string,
  query: string
}

@Component({
  selector: 'app-registries',
  templateUrl: './registries.component.html',
  styleUrls: ['./registries.component.scss']
})

export class RegistriesComponent implements OnInit {
  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  currentCCG: string = '';
  currentRegistry: string = '';
  queryList: queryList[];
  filter: string;

  wait: boolean = true;

  displayedColumns: string[] = ['select', 'org', 'listSize', 'registrySize', 'allColumns'];

  projectId: string = '';
  init: any = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private explorerService: ExplorerService,
    private userManagerService: UserManagerService,
    private dialog: MatDialog,
    private log: LoggerService) {
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

    this.loadEvents('', '');

    this.explorerService.getRegistryQueries()
      .subscribe(
        (result) => this.loadQueries(result),
        (error) => this.log.error(error)
      );
  }

  loadQueries(lists: any) {
    this.queryList = lists.results;
  }

  loadEvents(org: any, registry: any) {
    this.wait = true;

    this.events = null;
    this.explorerService.getRegistries(org, registry)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) =>  this.wait = false
      );
  }

  displayEvents(events: any) {
    this.events = events;

    if (events.results[0].registrySize=='')
      this.displayedColumns = ['select', 'org', 'listSize', 'allColumns'];
    else
      this.displayedColumns = ['select', 'org', 'listSize', 'registrySize', 'allColumns'];

    this.dataSource = new MatTableDataSource(events.results);

    this.wait = false;

    this.dataSource.filterPredicate = (data:{org: string}, filterValue: string) => {
      const filterArray = filterValue.split(' ');
      const matchFilter = [];
      filterArray.forEach(filter => {
        const customFilter = [];
        customFilter.push(data.org.trim().toLowerCase().indexOf(filter) !== -1 || data.org.trim().toLowerCase().indexOf('go to denominator registry') !== -1);
        matchFilter.push(customFilter.some(Boolean));
      })
      return matchFilter.some(Boolean);
    }

    this.applyFilter();

  }

  getSize(index, registrySize) {
    if (index==0)
      return "";

    if (index>0) {
      return (index*1).toLocaleString();
    } else {
      return index
    }
  }

  getQuery(registryLookup: any) {
    let query = this.queryList.find( record => record.registry === registryLookup);

    if (query!=undefined)
      return query.query
    else
      return '';

  }

  getOrgs(ccg: any,registry: any) {

    if (this.selection.selected.length > 0)
      return;

    if (ccg=='Go to denominator registry') {
      ccg = this.currentCCG;
      registry = this.currentRegistry;

    }

    if (this.currentRegistry=='')
      this.currentRegistry = registry;

    if (registry=='' && this.currentRegistry!= '')
      registry = this.currentRegistry;

    if (this.currentCCG=='')
      this.currentCCG = ccg;

    if (ccg=='' && this.currentCCG!= '')
      ccg = this.currentCCG;

    this.loadEvents(ccg, registry);

  }

  restart() {
    this.currentRegistry = '';
    this.currentCCG = '';
    this.filter = '';
    this.loadEvents('', '');
  }

  toPercent(registrysize: any, listsize: any) {
    let val: any = (registrysize/listsize*100).toFixed(1);
    if (listsize==0)
      val = 0;
    return val;
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

  showTrend(org: string) {
    var orgs = "";

    for (let s of this.selection.selected) {
      orgs = orgs + s.org + ",";
    }

    if (orgs != "")
    {
      orgs = orgs.replace(/,\s*$/, "");
    }

    orgs = orgs;

    const dialogRef = this.dialog.open(TrendComponent, {
      disableClose: true,
      height: '900px',
      width: '1300px',
      data: {orgs: orgs}
    });

    dialogRef.afterClosed().subscribe(result => {

    });
  }

  gaugeLabel(value: number) {
    return value+" %";
  }

  valueDialClass(percentage, target) {
    if (percentage>=target)
      return "good";
    else if (percentage<target)
      return "poor";
  }

  valueClass(percentage, target) {
    if (percentage>=target)
      return "goodValue";
    else if (percentage<target)
      return "poorValue";
  }

  applyFilter() {
    const filterValue = this.filter;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  graphicalComparison () {
    this.router.navigate(['/graphicalcomparison'])
  }

  registryLists () {
    this.router.navigate(['/registrylists'])
  }

}
