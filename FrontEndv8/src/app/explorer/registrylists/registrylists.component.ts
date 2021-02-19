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
  selector: 'app-registrylists',
  templateUrl: './registrylists.component.html',
  styleUrls: ['./registrylists.component.scss']
})

export class RegistryListsComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['ccg', 'practiceName', 'registry', 'listSize', 'registries', 'target'];

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
        headers: ['ccg', 'practiceName', 'registry', 'listSize', 'registrySize', 'target'],
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

}
