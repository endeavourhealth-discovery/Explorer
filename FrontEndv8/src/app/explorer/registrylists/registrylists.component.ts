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

  displayedColumns: string[] = ['ccg', 'practiceName', 'registry', 'listSize', 'registries', 'target', 'updated', 'parentQuery', 'select'];

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
    let name = '';

    if (this.filter != '') {
      name = this.filter;
    } else {
      name = 'registry_lists';
    }

    let values:any = this.dataSource.filteredData;
    //remove id from the data to be saved to csv
    let exportData = values.map(({ccg, practiceName, registry, listSize, registrySize, target, updated, parentQuery}) => ({ccg, practiceName, registry, listSize, registrySize, target, updated, parentQuery}));
    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['CCG', 'Practice Name', 'Query name', 'Denominator count', 'Numerator count', 'Target %', 'Run', 'Denominator'],
        showTitle: true,
        title: 'Registry lists',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, name, options);
    }
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;

    this.wait = false;

    this.route.queryParams
      .subscribe(params => {
        let param = params['param'];
        this.filter = param;
      });

    /*this.dataSource.filterPredicate = (data:{practiceName: string, registry: string}, filterValue: string) => {
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
    }*/


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

  patientList(query:any, parent:any, met: any, queryName: any, odsCode: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      disableClose: true,
      height: '830px',
      width: '1600px',

      data: {queryId: query, parentQueryId: parent, met: met, queryName: queryName, odsCode: odsCode}
    });

    dialogRef.afterClosed().subscribe(result => {
      let nhsNumber = "";
      if (result) {
        nhsNumber = result;
        //window.location.href = "https://gateway.discoverydataservice.net/record-viewer/#/summary?nhsNumber="+nhsNumber;
      }
    });
  }

  graphicalComparison () {
    this.router.navigate(['/graphicalcomparison'])
  }

  columnView () {
    this.router.navigate(['/registries'])
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

  delete() {
    let queryId = "";
    this.selection.selected.map(
      e => {
        queryId+=","+e.queryId;
      }
    )
    queryId = queryId.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete query results', "Are you sure you want to delete all the results for this query? (Note that a query's results cannot be deleted if the query is used by other queries as a denominator)", 'Delete all results for this query', 'Cancel')
      .subscribe(result => {
        if (result) {
          this.explorerService.deleteQuery(queryId.toString(), false)
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('These query results could not be deleted.')
            );
        }
      });
  }

}


