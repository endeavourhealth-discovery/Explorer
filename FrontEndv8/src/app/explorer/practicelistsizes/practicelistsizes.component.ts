import {Component, OnInit} from '@angular/core';
import {ExplorerService} from "../explorer.service";
import {ActivatedRoute} from "@angular/router";
import {LoggerService} from "dds-angular8";

@Component({
  selector: 'app-practicelistsizes',
  templateUrl: './practicelistsizes.component.html',
  styleUrls: ['./practicelistsizes.component.scss']
})
export class PracticeListSizesComponent implements OnInit {

  ccg: string;
  practices: any[];
  totalItems = 0;
  pageNumber = 1;
  pageSize = 10;
  orderColumn = 'practice';
  descending = false;
  searchData = '';
  headers: any[] = [
    {label: 'Practice', property: 'practice', secondary: false},
    {label: 'ODS code', property: 'ods_code', secondary: false},
    {label: 'List size', property: 'list_size', secondary: false}
  ];

  constructor(private explorerService: ExplorerService,
              private router: ActivatedRoute,
              private log: LoggerService) {
  }

  ngOnInit() {
    this.router.params.subscribe(params => {
      this.ccg = params['ccg'];
      this.search();
      this.getTotalPracticesCount();
    });
  }

  orderChange($event) {
    this.orderColumn = $event.active;
    this.descending = $event.direction == 'desc' ? true : false;
    this.search();
  }

  pageChange($event) {
    this.pageNumber = $event.pageIndex + 1; // pagination index starts at 0, mySQL is 1
    this.pageSize = $event.pageSize;
    this.search();
  }

  searchClicked($event) {
    this.searchData = $event;
    this.pageNumber = 1;
    this.practices = [];
    this.search();
    this.getTotalPracticesCount();
  }

  getTotalPracticesCount() {
    this.explorerService.getPracticesTotalCount(this.ccg, this.searchData)
      .subscribe(result => {
          this.totalItems = result;
        },
        (error) => console.log(error)
      );
  }

  private search() {
    this.explorerService.searchPractices(this.ccg, this.searchData, this.pageNumber,
      this.pageSize, this.orderColumn, this.descending)
      .subscribe(result => {
          this.practices = result;
        },
        error => {
          this.log.error('The practices could not be loaded. Please try again.');
        }
      );
  }
}
