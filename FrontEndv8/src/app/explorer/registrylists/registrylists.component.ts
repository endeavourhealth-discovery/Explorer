import {Component, OnInit, ViewChild} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import {MatPaginator, PageEvent} from '@angular/material/paginator';
import {ActivatedRoute, Router} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {ValueSetEditorComponent} from "../valueseteditor/valueseteditor.component";
import {SelectionModel} from '@angular/cdk/collections';
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {FormControl} from "@angular/forms";
import {ValueSetCodeComponent} from "../valuesetcode/valuesetcode.component";
import {MatSort} from "@angular/material/sort";
import {ngxCsv} from "ngx-csv";
import {PatientComponent} from "../patient/patient.component";

@Component({
  selector: 'app-registrylists',
  templateUrl: './registrylists.component.html',
  styleUrls: ['./registrylists.component.scss']
})

export class RegistryListsComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  wait: boolean = true;
  filter: string;

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['ccg', 'practiceName', 'registry', 'listSize', 'registries', 'target'];

  projectId: string = '';
  init: any = 0;

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
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
    this.explorerService.getRegistryLists()
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  onDownloadClick() {
    let values:any = this.dataSource.filteredData;
    //remove id from the data to be saved to csv
    let exportData = values.map(({ccg, practiceName, registry, listSize, registrySize, target}) => ({ccg, practiceName, registry, listSize, registrySize, target}));
    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['CCG', 'Practice Name', 'Query name', 'Denominator count', 'Numerator count', 'Target %'],
        showTitle: false,
        title: 'Registry lists',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'registry_lists', options);
    }
  }

  displayEvents(events: any) {
    this.events = events;
    console.log(this.events);
    this.dataSource = new MatTableDataSource(events.results);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;

    this.wait = false;

    this.dataSource.filterPredicate = (data:{practiceName: string, registry: string}, filterValue: string) => {
      const filterArray = filterValue.split(' ');
      const matchFilter = [];
      const customFilter = [];
      if (filterArray.length<2)
        customFilter.push(data.practiceName.trim().toLowerCase().indexOf(filterArray[0]) !== -1 || data.registry.trim().toLowerCase().indexOf(filterArray[0]) !== -1);
      else if (filterArray.length>1)
        customFilter.push((data.practiceName.trim().toLowerCase().indexOf(filterArray[0]) !== -1 && data.registry.trim().toLowerCase().indexOf(filterArray[1]) !== -1)||
                          (data.practiceName.trim().toLowerCase().indexOf(filterArray[1]) !== -1 && data.registry.trim().toLowerCase().indexOf(filterArray[0]) !== -1));
      matchFilter.push(customFilter.some(Boolean));
      return matchFilter.some(Boolean);
    }


    this.applyFilter();
  }

  applyFilter() {
    const filterValue = this.filter;
    this.dataSource.filter = filterValue.trim().toLowerCase();
  }

  formatNumber (list: number) {
    return Number(list).toLocaleString();
  }

  toPercent(registrysize: any, listsize: any) {
    let val: any = (listsize/registrysize*100).toFixed(1);
    if (registrysize==0)
      val = 0;
    return val;
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

  getSize(listSize, registrySize) {
    if (registrySize==0)
      return "";

    if (registrySize>0) {
      return (registrySize*1).toLocaleString();
    } else {
      return registrySize;
    }
  }

  patientList(query:any, parent:any) {
    console.log(parent);
    const dialogRef = this.dialog.open(PatientComponent, {
      disableClose: true,
      height: '830px',
      width: '1600px',

      data: {queryId: query, parentQueryId: parent}
    });

    dialogRef.afterClosed().subscribe(result => {
      let nhsNumber = "";
      if (result) {
        nhsNumber = result;
        window.location.href = "https://devgateway.discoverydataservice.net/record-viewer/#/summary?nhsNumber="+nhsNumber;
      }
    });
  }

  graphicalComparison () {
    this.router.navigate(['/graphicalcomparison'])
  }

  columnView () {
    this.router.navigate(['/registries'])
  }

}
