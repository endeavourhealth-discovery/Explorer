import {Component, OnInit} from '@angular/core';
import {LoggerService} from "dds-angular8";
import {ExplorerService} from "../explorer.service";
import {Router} from "@angular/router";
import {TableData} from "../dashboardviewer/model/TableData";

@Component({
  selector: 'app-organisationlistsizes',
  templateUrl: './organisationlistsizes.component.html',
  styleUrls: ['./organisationlistsizes.component.scss']
})
export class OrganisationListSizesComponent implements OnInit {

  tableData: TableData = null;
  totalItems = 0;
  pageNumber = 1;
  pageSize = 10;
  orderColumn = 'ccg';
  descending = false;
  searchData = '';

  constructor(private explorerService: ExplorerService,
              private router: Router,
              private log: LoggerService)
  { }

  ngOnInit() {
    this.search();
    this.getTotalOrganisationCount();
  }

  itemClicked(org: any) {
    this.router.navigate(['/practicelistsizes', org.ccg]);
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
    this.getTotalOrganisationCount();
  }

  getTotalOrganisationCount() {
    this.explorerService.getOrganisationsTotalCount(this.searchData)
      .subscribe(
        (result) => {
          this.totalItems = result;
        },
        (error) => console.log(error)
      );
  }

  private search() {
    this.explorerService.searchOrganisations(this.searchData, this.pageNumber, this.pageSize, this.orderColumn, this.descending)
      .subscribe(result => {
          this.tableData = result;
        },
        error => {
          this.log.error('The organisations could not be loaded. Please try again.');
        }
      );
  }

}
