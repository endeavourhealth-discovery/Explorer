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
  selector: 'app-valuesetlibrary',
  templateUrl: './populations.component.html',
  styleUrls: ['./populations.component.scss']
})

export class PopulationsComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  filterText: string;
  wait: boolean = true;

  events: any;
  dataSource: MatTableDataSource<any>;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  @ViewChild(MatSort, {static: false}) sort: MatSort;

  displayedColumns: string[] = ['stp', 'ccg', 'pcn', 'practice', 'ethnic', 'age', 'sex', 'listSize'];

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
    this.explorerService.getPopulation()
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  onDownloadClick() {
    let values:any = this.dataSource.filteredData;
    //remove id from the data to be saved to csv
    let exportData = values.map(({stp, ccg, pcn, practice, ethnic, age, sex, listSize}) => ({stp, ccg, pcn, practice, ethnic, age, sex, listSize}));
    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['stp', 'ccg', 'pcn', 'practice', 'ethnic','age', 'sex', 'listSize'],
        showTitle: false,
        title: 'Population counts',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'population_counts', options);
    }
  }

  displayEvents(events: any) {
    this.events = events;

    events.results.forEach( (item, index) => {
      if (events.results[index].ccg == undefined)
        events.results[index].ccg = '(STP Total)';
      else if (events.results[index].pcn == undefined)
        events.results[index].pcn = '(CCG Total)';
      else if (events.results[index].practice == undefined)
        events.results[index].practice = '(PCN Total)';
      else if (events.results[index].ethnic == undefined)
        events.results[index].ethnic = '(Practice Total)';
      else if (events.results[index].age == undefined)
        events.results[index].age = '(Ethnic Total)';
      else if (events.results[index].sex == undefined)
        events.results[index].sex = '(Age Total)';
    });

    this.dataSource = new MatTableDataSource(events.results);

    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;

    this.wait = false;
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  formatList (list: number) {
    return Number(list).toLocaleString();
  }

  showTotals (level: any) {
    this.dataSource.filter = level;
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

}
