import {Component, OnInit} from '@angular/core';
import {ExplorerService} from "../explorer.service";
import {ActivatedRoute} from "@angular/router";
import {LoggerService} from "dds-angular8";
import {TableData} from "../dashboardviewer/model/TableData";

@Component({
  selector: 'app-practicelistsizes',
  templateUrl: './practicelistsizes.component.html',
  styleUrls: ['./practicelistsizes.component.scss']
})
export class PracticeListSizesComponent implements OnInit {

  ccg: string;
  tableData: TableData = null;
  totalItems = 0;
  pageNumber = 1;
  pageSize = 10;
  orderColumn = 'practice';
  descending = false;
  searchData = '';

  constructor(private explorerService: ExplorerService,
              private router: ActivatedRoute,
              private log: LoggerService) {
  }

  ngOnInit() {
    this.router.params.subscribe(params => {
      this.ccg = params['ccg'];
      this.search();
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
    this.tableData.rows = [];
    this.search();
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
          this.tableData = result;
            this.getTotalPracticesCount();
        },
        error => {
          this.log.error('The practices could not be loaded. Please try again.');
        }
      );
  }
}
