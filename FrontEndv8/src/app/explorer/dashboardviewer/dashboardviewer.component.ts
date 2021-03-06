import {AfterViewInit, Component, OnInit, Output} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute, Router} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatDialog} from "@angular/material/dialog";
import {Globals} from '../globals'
import {TableData} from "./model/TableData";
import {ngxCsv} from "ngx-csv";

interface widget {
  icon: string;
  name: string;
}

interface dashboardQuery {
  selectedVisualisation1: string;
  selectedSeries1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedVisualisation2: string;
  selectedSeries2: string;
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedVisualisation3: string;
  selectedSeries3: string;
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedVisualisation4: string;
  selectedSeries4: string;
  xAxisLabel4: string;
  yAxisLabel4: string;
  visualType: widget[];
}

interface query {
  timeSeries: string;
}

@Component({
  selector: 'app-dashboardviewer',
  templateUrl: './dashboardviewer.component.html',
  styleUrls: ['./dashboardviewer.component.scss']
})

export class DashboardViewerComponent implements OnInit {
  globals: Globals;
  name: string = "";
  selectAll1: boolean = true;
  selectAll2: boolean = true;
  selectAll3: boolean = true;
  selectAll4: boolean = true;
  selectAllSeries1: boolean = true;
  selectAllSeries2: boolean = true;
  selectAllSeries3: boolean = true;
  selectAllSeries4: boolean = true;
  view1: any[] = [770, 250];
  view2: any[] = [770, 250];
  view3: any[] = [770, 250];
  view4: any[] = [770, 250];
  chartResults1: any[];
  chartResultsSingle1: any[];
  chartResults2: any[];
  chartResultsSingle2: any[];
  chartResults3: any[];
  chartResultsSingle3: any[];
  chartResults4: any[];
  chartResultsSingle4: any[];
  dateFrom1: string = '2020-01-01';
  dateTo1: string = this.formatDate(new Date());
  dateFrom2: string = '2020-01-01';
  dateTo2: string = this.formatDate(new Date());
  dateFrom3: string = '2020-01-01';
  dateTo3: string = this.formatDate(new Date());
  dateFrom4: string = '2020-01-01';
  dateTo4: string = this.formatDate(new Date());
  dashboardNumber: string;
  showLineCharts1: boolean = false;
  showLineCharts2: boolean = false;
  showLineCharts3: boolean = false;
  showLineCharts4: boolean = false;
  showBarCharts1: boolean = false;
  showBarCharts2: boolean = false;
  showBarCharts3: boolean = false;
  showBarCharts4: boolean = false;
  showTables1: boolean = false;
  showTables2: boolean = false;
  showTables3: boolean = false;
  showTables4: boolean = false;
  seriesValues1 = new FormControl();
  seriesValues2 = new FormControl();
  seriesValues3 = new FormControl();
  seriesValues4 = new FormControl();
  seriesList1: string = '';
  seriesList2: string = '';
  seriesList3: string = '';
  seriesList4: string = '';
  selectedOrg1: any = [];
  selectedOrg2: any = [];
  selectedOrg3: any = [];
  selectedOrg4: any = [];
  months: string[] = [];
  chartName: string = "";
  widget1: boolean = false;
  widget2: boolean = false;
  widget3: boolean = false;
  widget4: boolean = false;

  // options
  legend: boolean = true;
  legendTitle: string = "Legend";
  legendPosition: string = 'right';
  animations: boolean = true;
  xAxis: boolean = true;
  yAxis: boolean = true;
  showYAxisLabel: boolean = true;
  showXAxisLabel: boolean = true;
  chartTitle1: string = "Chart Title";
  chartTitle2: string = "Chart Title";
  chartTitle3: string = "Chart Title";
  chartTitle4: string = "Chart Title";
  xAxisLab1: string = 'Date';
  yAxisLab1: string = 'People with indicator';
  xAxisLab2: string = 'Date';
  yAxisLab2: string = 'People with indicator';
  xAxisLab3: string = 'Date';
  yAxisLab3: string = 'People with indicator';
  xAxisLab4: string = 'Date';
  yAxisLab4: string = 'People with indicator';
  showGridLines1: boolean = true;
  showAreaChart1: boolean = false;
  gradient1: boolean = false;
  showRefLines1: boolean = false;
  logarithmic1: boolean = false;
  cumulative1: boolean = false;
  weekly1: boolean = false;

  refLines1 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  OrgList1 = [];
  OrgValues1 = new FormControl(this.OrgList1);
  showGridLines2: boolean = true;
  showAreaChart2: boolean = false;
  gradient2: boolean = false;
  showRefLines2: boolean = false;
  logarithmic2: boolean = false;
  cumulative2: boolean = false;
  weekly2: boolean = false;

  refLines2 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  OrgList2 = [];
  OrgValues2 = new FormControl(this.OrgList2);
  showGridLines3: boolean = true;
  showAreaChart3: boolean = false;
  gradient3: boolean = false;
  showRefLines3: boolean = false;
  logarithmic3: boolean = false;
  cumulative3: boolean = false;
  weekly3: boolean = false;

  refLines3 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  OrgList3 = [];
  OrgValues3 = new FormControl(this.OrgList3);
  showGridLines4: boolean = true;
  showAreaChart4: boolean = false;
  gradient4: boolean = false;
  showRefLines4: boolean = false;
  logarithmic4: boolean = false;
  cumulative4: boolean = false;
  weekly4: boolean = false;

  refLines4 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  OrgList4 = [];
  OrgValues4 = new FormControl(this.OrgList4);
  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };
  cols = "2";
  rowHeight = "49%";

  selectedQuery1: string;
  selectedQuery2: string;
  selectedQuery3: string;
  selectedQuery4: string;
  selectedVisualisation1: string;
  selectedSeries1: any = [];
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedVisualisation2: string;
  selectedSeries2: any = [];
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedVisualisation3: string;
  selectedSeries3: any = [];
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedVisualisation4: string;
  selectedSeries4: any = [];
  xAxisLabel4: string;
  yAxisLabel4: string;
  selectedWidgets : widget[] = [
  ];

  tableData1: TableData = null;
  tableData2: TableData = null;
  tableData3: TableData = null;
  tableData4: TableData = null;

  tableQuery1: string = "";
  tableQuery2: string = "";
  tableQuery3: string = "";
  tableQuery4: string = "";

  tableOutput1: string = "";
  tableOutput2: string = "";
  tableOutput3: string = "";
  tableOutput4: string = "";

  searchData1: string = null;
  searchData2: string = null;
  searchData3: string = null;
  searchData4: string = null;

  totalItems1: number = 0;
  totalItems2: number = 0;
  totalItems3: number = 0;
  totalItems4: number = 0;

  pageNumber1: number = 1;
  pageNumber2: number = 1;
  pageNumber3: number = 1;
  pageNumber4: number = 1;

  pageSize1: number = 3;
  pageSize2: number = 3;
  pageSize3: number = 3;
  pageSize4: number = 3;

  orderColumn1: string = null;
  orderColumn2: string = null;
  orderColumn3: string = null;
  orderColumn4: string = null;

  descending1: boolean;
  descending2: boolean;
  descending3: boolean;
  descending4: boolean;

  tableStyle1 = '';
  tableStyle2 = '';
  tableStyle3 = '';
  tableStyle4 = '';

  projectId: string = '';
  init: any = 0;

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService,
    private dialog: MatDialog,
    private router: Router,
    globals: Globals) {
    this.globals = globals;
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
      this.router.navigate(['/dashboardlibrary']);
      return;
    }

    this.projectId = newProject;

    this.OrgValues1 = new FormControl(this.OrgList1);
    this.selectedOrg1 = this.OrgList1;
    this.OrgValues2 = new FormControl(this.OrgList2);
    this.selectedOrg2 = this.OrgList2;
    this.OrgValues3 = new FormControl(this.OrgList3);
    this.selectedOrg3 = this.OrgList3;
    this.OrgValues4 = new FormControl(this.OrgList4);
    this.selectedOrg4 = this.OrgList4;

    this.route.queryParams
      .subscribe(params => {
        this.dashboardNumber = params['dashboardNumber'];

        this.explorerService.getDashboardView(this.dashboardNumber)
          .subscribe(
            (result) => this.parseDashboard(result),
            (error) => this.log.error(error)
          );
      });
  }

  toggleSelection1(event) {
    if (event.checked) {
      this.OrgValues1 = new FormControl(this.OrgList1);
      this.selectedOrg1 = this.OrgList1;
    } else {
      this.OrgValues1 = new FormControl([]);
      this.selectedOrg1 = "";
    }

  }

  toggleSelection2(event) {
    if (event.checked) {
      this.OrgValues2 = new FormControl(this.OrgList2);
      this.selectedOrg2 = this.OrgList2;
    } else {
      this.OrgValues2 = new FormControl([]);
      this.selectedOrg2 = "";
    }

  }

  toggleSelection3(event) {
    if (event.checked) {
      this.OrgValues3 = new FormControl(this.OrgList3);
      this.selectedOrg3 = this.OrgList3;
    } else {
      this.OrgValues3 = new FormControl([]);
      this.selectedOrg3 = "";
    }

  }

  toggleSelection4(event) {
    if (event.checked) {
      this.OrgValues4 = new FormControl(this.OrgList4);
      this.selectedOrg4 = this.OrgList4;
    } else {
      this.OrgValues4 = new FormControl([]);
      this.selectedOrg4 = "";
    }

  }

  toggleSelectionSeries1(event) {
    if (event.checked) {
      this.seriesValues1 = new FormControl(this.seriesList1);
      this.selectedSeries1 = this.seriesList1;
    } else {
      this.seriesValues1 = new FormControl([]);
      this.selectedSeries1 = "";
    }

  }

  toggleSelectionSeries2(event) {
    if (event.checked) {
      this.seriesValues2 = new FormControl(this.seriesList2);
      this.selectedSeries2 = this.seriesList2;
    } else {
      this.seriesValues2 = new FormControl([]);
      this.selectedSeries2 = "";
    }

  }

  toggleSelectionSeries3(event) {
    if (event.checked) {
      this.seriesValues3 = new FormControl(this.seriesList3);
      this.selectedSeries3 = this.seriesList3;
    } else {
      this.seriesValues3 = new FormControl([]);
      this.selectedSeries3 = "";
    }

  }

  toggleSelectionSeries4(event) {
    if (event.checked) {
      this.seriesValues4 = new FormControl(this.seriesList4);
      this.selectedSeries4 = this.seriesList4;
    } else {
      this.seriesValues4 = new FormControl([]);
      this.selectedSeries4 = "";
    }

  }

  refreshDashboard1() {
    let values1 = this.selectedSeries1.toString();

    if (this.showLineCharts1) {
      let cumulative = "0";
      if (this.cumulative1) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly1) {
        weekly = "1";
      }

      this.yAxisLabel1 = this.yAxisLab1;

      this.explorerService.getDashboard(this.selectedQuery1, values1, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), cumulative, this.selectedOrg1.toString(), weekly)
        .subscribe(result => {
          this.chartResults1 = result.results;

          // apply log10 to values in series
          this.chartResults1 = this.chartResults1.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: this.applyLogarithm1(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }

    if (this.showBarCharts1) {
      this.explorerService.getDashboardSingle(this.selectedQuery1, values1, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), 0, this.selectedOrg1.toString())
        .subscribe(result => {
          this.chartResultsSingle1 = result.series;
        });
    }

    if (this.showTables1) {
      this.tableQuery1 = this.selectedQuery1;
      this.searchData1 = null;
      this.orderColumn1 = null;
      this.search1();
    }
  }

  refreshDashboard2() {
    let values2 = this.selectedSeries2.toString();

    if (this.showLineCharts2) {
      let cumulative = "0";
      if (this.cumulative2) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly2) {
        weekly = "1";
      }

      this.yAxisLabel2 = this.yAxisLab2;

      this.explorerService.getDashboard(this.selectedQuery2, values2, this.formatDate(this.dateFrom2), this.formatDate(this.dateTo2), cumulative, this.selectedOrg2.toString(), weekly)
        .subscribe(result => {
          this.chartResults2 = result.results;

          // apply log10 to values in series
          this.chartResults2 = this.chartResults2.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: this.applyLogarithm2(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }

    if (this.showBarCharts2) {
      this.explorerService.getDashboardSingle(this.selectedQuery2, values2, this.formatDate(this.dateFrom2), this.formatDate(this.dateTo2), 0, this.selectedOrg2.toString())
        .subscribe(result => {
          this.chartResultsSingle2 = result.series;
        });
    }

    if (this.showTables2) {
      this.tableQuery2 = this.selectedQuery2;
      this.searchData2 = null;
      this.orderColumn2 = null;
      this.search2();
    }
  }

  refreshDashboard3() {
    let values3 = this.selectedSeries3.toString();

    if (this.showLineCharts3) {
      let cumulative = "0";
      if (this.cumulative3) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly3) {
        weekly = "1";
      }

      this.yAxisLabel3 = this.yAxisLab3;

      this.explorerService.getDashboard(this.selectedQuery3, values3, this.formatDate(this.dateFrom3), this.formatDate(this.dateTo3), cumulative, this.selectedOrg3.toString(), weekly)
        .subscribe(result => {
          this.chartResults3 = result.results;

          // apply log10 to values in series
          this.chartResults3 = this.chartResults3.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: this.applyLogarithm3(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }

    if (this.showBarCharts3) {
      this.explorerService.getDashboardSingle(this.selectedQuery3, values3, this.formatDate(this.dateFrom3), this.formatDate(this.dateTo3), 0, this.selectedOrg3.toString())
        .subscribe(result => {
          this.chartResultsSingle3 = result.series;
        });
    }

    if (this.showTables3) {
      this.tableQuery3 = this.selectedQuery3;
      this.searchData3 = null;
      this.orderColumn3 = null;
      this.search3();
    }
  }

  refreshDashboard4() {
    let values4 = this.selectedSeries4.toString();

    if (this.showLineCharts4) {
      let cumulative = "0";
      if (this.cumulative4) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly4) {
        weekly = "1";
      }

      this.yAxisLabel4 = this.yAxisLab4;

      this.explorerService.getDashboard(this.selectedQuery4, values4, this.formatDate(this.dateFrom4), this.formatDate(this.dateTo4), cumulative, this.selectedOrg4.toString(), weekly)
        .subscribe(result => {
          this.chartResults4 = result.results;

          // apply log10 to values in series
          this.chartResults4 = this.chartResults4.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: this.applyLogarithm4(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }

    if (this.showBarCharts4) {
      this.explorerService.getDashboardSingle(this.selectedQuery4, values4, this.formatDate(this.dateFrom4), this.formatDate(this.dateTo4), 0, this.selectedOrg4.toString())
        .subscribe(result => {
          this.chartResultsSingle4 = result.series;
        });
    }

    if (this.showTables4) {
      this.tableQuery4 = this.selectedQuery4;
      this.searchData4 = null;
      this.orderColumn4 = null;
      this.search4();
    }
  }

  parseDashboard (result: any) {
    result.results.map(
      e => {
        let query: dashboardQuery = JSON.parse(e.jsonQuery);

        this.selectedWidgets = query.visualType;

        if (this.selectedWidgets.length==1) {
          this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
          this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';
          this.showTables1 = this.selectedWidgets[0].name=='Table';
        }

        if (this.selectedWidgets.length==2) {
          this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
          this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';
          this.showTables1 = this.selectedWidgets[0].name=='Table';
          this.showLineCharts2 = this.selectedWidgets[1].name=='Line chart';
          this.showBarCharts2 = this.selectedWidgets[1].name=='Bar chart';
          this.showTables2 = this.selectedWidgets[1].name=='Table';
        }

        if (this.selectedWidgets.length==3) {
          this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
          this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';
          this.showTables1 = this.selectedWidgets[0].name=='Table';
          this.showLineCharts2 = this.selectedWidgets[1].name=='Line chart';
          this.showBarCharts2 = this.selectedWidgets[1].name=='Bar chart';
          this.showTables2 = this.selectedWidgets[1].name=='Table';
          this.showLineCharts3 = this.selectedWidgets[2].name=='Line chart';
          this.showBarCharts3 = this.selectedWidgets[2].name=='Bar chart';
          this.showTables3 = this.selectedWidgets[2].name=='Table';
        }

        if (this.selectedWidgets.length==4) {
          this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
          this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';
          this.showTables1 = this.selectedWidgets[0].name=='Table';
          this.showLineCharts2 = this.selectedWidgets[1].name=='Line chart';
          this.showBarCharts2 = this.selectedWidgets[1].name=='Bar chart';
          this.showTables2 = this.selectedWidgets[1].name=='Table';
          this.showLineCharts3 = this.selectedWidgets[2].name=='Line chart';
          this.showBarCharts3 = this.selectedWidgets[2].name=='Bar chart';
          this.showTables3 = this.selectedWidgets[2].name=='Table';
          this.showLineCharts4 = this.selectedWidgets[3].name=='Line chart';
          this.showBarCharts4 = this.selectedWidgets[3].name=='Bar chart';
          this.showTables4 = this.selectedWidgets[3].name=='Table';
        }

        this.selectedVisualisation1 = query.selectedVisualisation1;

        this.selectedQuery1 = query.selectedSeries1;

        this.explorerService.getQuery(query.selectedSeries1)
          .subscribe(
            (result) => this.loadQuery1(result, query.selectedSeries1),
            (error) => this.log.error(error)
          );

        this.xAxisLabel1 = query.xAxisLabel1;
        this.yAxisLabel1 = query.yAxisLabel1;

        this.selectedVisualisation2 = query.selectedVisualisation2;

        this.selectedQuery2 = query.selectedSeries2;

        this.explorerService.getQuery(query.selectedSeries2)
          .subscribe(
            (result) => this.loadQuery2(result, query.selectedSeries2),
            (error) => this.log.error(error)
          );

        this.xAxisLabel2 = query.xAxisLabel2;
        this.yAxisLabel2 = query.yAxisLabel2;

        this.selectedVisualisation3 = query.selectedVisualisation3;

        this.selectedQuery3 = query.selectedSeries3;

        this.explorerService.getQuery(query.selectedSeries3)
          .subscribe(
            (result) => this.loadQuery3(result, query.selectedSeries3),
            (error) => this.log.error(error)
          );

        this.xAxisLabel3 = query.xAxisLabel3;
        this.yAxisLabel3 = query.yAxisLabel3;

        this.selectedVisualisation4 = query.selectedVisualisation4;

        this.selectedQuery4 = query.selectedSeries4;

        this.explorerService.getQuery(query.selectedSeries4)
          .subscribe(
            (result) => this.loadQuery4(result, query.selectedSeries4),
            (error) => this.log.error(error)
          );

        this.xAxisLabel4 = query.xAxisLabel4;
        this.yAxisLabel4 = query.yAxisLabel4;


      }
    )

    this.xAxisLab1 = this.xAxisLabel1;
    this.yAxisLab1 = this.yAxisLabel1;
    this.xAxisLab2 = this.xAxisLabel2;
    this.yAxisLab2 = this.yAxisLabel2;
    this.xAxisLab3 = this.xAxisLabel3;
    this.yAxisLab3 = this.yAxisLabel3;
    this.xAxisLab4 = this.xAxisLabel4;
    this.yAxisLab4 = this.yAxisLabel4;

    this.chartTitle1 = this.selectedVisualisation1;
    this.chartTitle2 = this.selectedVisualisation2;
    this.chartTitle3 = this.selectedVisualisation3;
    this.chartTitle4 = this.selectedVisualisation4;

    if (this.selectedWidgets.length == 1) {
      this.pageSize1 = 10;
      this.pageSize2 = 10;
      this.pageSize3 = 10;
      this.pageSize4 = 10;
      this.tableStyle1 = 'table-scroll-full';
      this.tableStyle2 = 'table-scroll-full';
      this.tableStyle3 = 'table-scroll-full';
      this.tableStyle4 = 'table-scroll-full';
    } else if (this.selectedWidgets.length == 2) {
      this.pageSize1 = 10;
      this.pageSize2 = 10;
      this.pageSize3 = 10;
      this.pageSize4 = 10;
      this.tableStyle1 = 'table-scroll-half';
      this.tableStyle2 = 'table-scroll-half';
      this.tableStyle3 = 'table-scroll-half';
      this.tableStyle4 = 'table-scroll-half';
    } else {
      this.pageSize1 = 3;
      this.pageSize2 = 3;
      this.pageSize3 = 3;
      this.pageSize4 = 3;
      this.tableStyle1 = 'table-scroll-quarter';
      this.tableStyle2 = 'table-scroll-quarter';
      this.tableStyle3 = 'table-scroll-quarter';
      this.tableStyle4 = 'table-scroll-quarter';
    }

    if (this.selectedWidgets.length==1) {
      this.cols = "1";
      this.rowHeight = "99%";
      this.view1 = [1300, 700];
      this.widget1 = true;


    }
    if (this.selectedWidgets.length==2) {
      this.cols = "2";
      this.rowHeight = "99%";
      this.view1 = [770, 700];
      this.view2 = [770, 700];
      this.widget1 = true;

      this.widget2 = true;

    }
    if (this.selectedWidgets.length==3) {
      this.cols = "2";
      this.rowHeight = "49%";
      this.view1 = [770, 270];
      this.view2 = [770, 270];
      this.view3 = [770, 270];
      this.widget1 = true;

      this.widget2 = true;

      this.widget3 = true;

    }
    if (this.selectedWidgets.length==4) {
      this.cols = "2";
      this.rowHeight = "49%";
      this.view1 = [770, 270];
      this.view2 = [770, 270];
      this.view3 = [770, 270];
      this.view4 = [770, 270];
      this.widget1 = true;

      this.widget2 = true;

      this.widget3 = true;

      this.widget4 = true;

    }

    if (this.showTables1)
      this.refreshDashboard1();
    if (this.showTables2)
      this.refreshDashboard2();
    if (this.showTables3)
      this.refreshDashboard3();
    if (this.showTables4)
      this.refreshDashboard4();

  }

  loadQuery1(result: any, queryName: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);
        if (query.timeSeries) {
          this.explorerService.getSeriesFromQuery(queryName)
            .subscribe(
              (result) => this.loadQuery1Series(result, queryName),
              (error) => this.log.error(error)
            );
        }
      }
    )
  }

  loadQuery1Grouping(result: any) {
    result.results.map(
      e => {
        this.OrgList1.push(e.grouping);
      }
    )

    this.OrgValues1 = new FormControl(this.OrgList1);


  }

  loadQuery1Series(result: any, queryName: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries1 = seriesMap;
    this.seriesList1 = this.selectedSeries1;
    this.seriesValues1 = new FormControl(this.seriesList1);

    this.explorerService.getGroupingFromQuery(queryName)
      .subscribe(
        (result) => this.loadQuery1Grouping(result),
        (error) => this.log.error(error)
      );
  }

  loadQuery2(result: any, queryName: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);
        if (query.timeSeries) {
          this.explorerService.getSeriesFromQuery(queryName)
            .subscribe(
              (result) => this.loadQuery2Series(result, queryName),
              (error) => this.log.error(error)
            );


        }
      }
    )
  }

  loadQuery2Grouping(result: any) {
    result.results.map(
      e => {
        this.OrgList2.push(e.grouping);
      }
    )

    this.OrgValues2 = new FormControl(this.OrgList2);


  }

  loadQuery2Series(result: any, queryName: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries2 = seriesMap;
    this.seriesList2 = this.selectedSeries2;
    this.seriesValues2 = new FormControl(this.seriesList2);

    this.explorerService.getGroupingFromQuery(queryName)
      .subscribe(
        (result) => this.loadQuery2Grouping(result),
        (error) => this.log.error(error)
      );
  }

  loadQuery3(result: any, queryName: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);
        if (query.timeSeries) {
          this.explorerService.getSeriesFromQuery(queryName)
            .subscribe(
              (result) => this.loadQuery3Series(result, queryName),
              (error) => this.log.error(error)
            );


        }
      }
    )
  }

  loadQuery3Grouping(result: any) {
    result.results.map(
      e => {
        this.OrgList3.push(e.grouping);
      }
    )

    this.OrgValues3 = new FormControl(this.OrgList3);


  }

  loadQuery3Series(result: any, queryName: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries3 = seriesMap;
    this.seriesList3 = this.selectedSeries3;
    this.seriesValues3 = new FormControl(this.seriesList3);

    this.explorerService.getGroupingFromQuery(queryName)
      .subscribe(
        (result) => this.loadQuery3Grouping(result),
        (error) => this.log.error(error)
      );
  }

  loadQuery4(result: any, queryName: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);
        if (query.timeSeries) {
          this.explorerService.getSeriesFromQuery(queryName)
            .subscribe(
              (result) => this.loadQuery4Series(result, queryName),
              (error) => this.log.error(error)
            );


        }
      }
    )
  }

  loadQuery4Grouping(result: any) {
    result.results.map(
      e => {
        this.OrgList4.push(e.grouping);
      }
    )

    this.OrgValues4 = new FormControl(this.OrgList4);


  }

  loadQuery4Series(result: any, queryName: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries4 = seriesMap;
    this.seriesList4 = this.selectedSeries4;
    this.seriesValues4 = new FormControl(this.seriesList4);

    this.explorerService.getGroupingFromQuery(queryName)
      .subscribe(
        (result) => this.loadQuery4Grouping(result),
        (error) => this.log.error(error)
      );
  }

  formatTooltipYAxis1(val: number) {
    if (this.logarithmic1 == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  formatTooltipYAxis2(val: number) {
    if (this.logarithmic2 == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  formatTooltipYAxis3(val: number) {
    if (this.logarithmic3 == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  formatTooltipYAxis4(val: number) {
    if (this.logarithmic4 == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  formatYAxis(val: number) {
    if (val < 5) {
      val = Math.round(Math.pow(10, val));
      return val.toLocaleString()
    } else {
      return Number(val).toLocaleString()
    }
  }

  applyLogarithm1(value: number) {
    if (this.logarithmic1 == true) {
      return Math.log10(value)
    } else {
      return value
    }
  }
  applyLogarithm2(value: number) {
    if (this.logarithmic2 == true) {
      return Math.log10(value)
    } else {
      return value
    }
  }
  applyLogarithm3(value: number) {
    if (this.logarithmic3 == true) {
      return Math.log10(value)
    } else {
      return value
    }
  }
  applyLogarithm4(value: number) {
    if (this.logarithmic4 == true) {
      return Math.log10(value)
    } else {
      return value
    }
  }

  formatXAxis(date) {
    var d = new Date(date),
      month = '' + (d.getMonth()),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (day.length < 2)
      day = '0' + day;

    let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var monthName = months[(Number(month))];

    return [day, monthName, year].join('-');
  }

  onSelectLine1(data): void {
  }

  onSelectBar1(data): void {
  }

  onSelectLine2(data): void {
  }

  onSelectBar2(data): void {
  }

  onSelectLine3(data): void {
  }

  onSelectBar3(data): void {
  }

  onSelectLine4(data): void {
  }

  onSelectBar4(data): void {
  }

  tablePatientSelect($event) {
    let nhsNumber = $event["NHS number"];
    if (nhsNumber!=undefined)
      window.location.href = "https://gateway.discoverydataservice.net/record-viewer/#/summary?nhsNumber="+nhsNumber;
  }

  formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2)
      month = '0' + month;
    if (day.length < 2)
      day = '0' + day;

    return [year, month, day].join('-');
  }

  download1() {
    var csvData = '';
    if (this.showLineCharts1)
      csvData = this.ConvertToCSVMulti(this.chartResults1,this.selectedOrg1.toString());
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle1,this.selectedOrg1.toString(),this.selectedSeries1.toString());

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['group','key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  csvJSON(csv){
    var lines=csv.split("\n");

    var result = [];

    var headers=lines[0].split(",");

    headers = ["group","key","point","count"];

    for(var i=0;i<lines.length-1;i++){

      var obj = {};
      var currentline=lines[i].split(",");

      for(var j=0;j<headers.length;j++){
        obj[headers[j]] = currentline[j];
      }

      result.push(obj);

    }
    return result;
  }

  download2() {
    var csvData = '';
    if (this.showLineCharts2)
      csvData = this.ConvertToCSVMulti(this.chartResults2,this.selectedOrg2.toString());
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle2,this.selectedOrg2.toString(),this.selectedSeries2.toString());

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['group','key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  download3() {
    var csvData = '';
    if (this.showLineCharts3)
      csvData = this.ConvertToCSVMulti(this.chartResults3,this.selectedOrg3.toString());
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle3,this.selectedOrg3.toString(),this.selectedSeries3.toString());

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['group','key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  download4() {
    var csvData = '';
    if (this.showLineCharts4)
      csvData = this.ConvertToCSVMulti(this.chartResults4,this.selectedOrg4.toString());
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle4,this.selectedOrg4.toString(),this.selectedSeries4.toString());

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['group','key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  ConvertToCSVMulti(objArray, group) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = '';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        for (let key2 in array[key].series) {
          if (array[key].series.hasOwnProperty(key2)) {
            let point = array[key].series[key2].name;
            if (point.toString().indexOf("GMT") > -1) { // date type of series
              point = this.formatDate(point);
            }
            csv += group.replaceAll(',','|')+ ',' + array[key].name+ ',' + point + ',' + array[key].series[key2].value + '\n';
          }
        }
      }
    }
    return csv;
  }

  ConvertToCSVSingle(objArray, group, series) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = 'group,key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        let point = array[key].name;
        if (point.toString().indexOf("GMT") > -1) { // date type of series
          point = this.formatDate(point);
        }
        csv += group.replaceAll(',','|')+ ',' +series+ ',' + point + ',' + array[key].value + '\n';
      }
    }
    return csv;
  }

  onSearch1($event) {
    this.searchData1 = $event;
    this.pageNumber1 = 1;
    this.search1();
  }

  getTotalTableData1() {
    this.explorerService.getTotalCount(this.tableQuery1, this.tableOutput1, this.searchData1)
      .subscribe(
        (result) => {
          this.totalItems1 = result;
        },
        (error) => console.log(error)
      );
  }

  private search1() {
    this.explorerService.tableSearch(this.tableQuery1, this.tableOutput1, this.searchData1, this.pageNumber1,
      this.pageSize1, this.orderColumn1, this.descending1)
      .subscribe(result => {
          this.tableData1 = result;
          this.tableOutput1 = result.outputType;
          if (this.orderColumn1 == null) {
            this.orderColumn1 = result.headers[0].property;
          }
          this.getTotalTableData1();
        },
        error => {
          this.log.error('Table data could not be loaded. Please try again.');
        }
      );
  }

  pageChange1($event) {
    console.log($event);
    this.pageNumber1 = $event.pageIndex + 1;
    this.pageSize1 = $event.pageSize;
    this.search1();
  }

  onOrderChange1($event) {
    this.orderColumn1 = $event.active;
    this.descending1 = $event.direction == 'desc' ? true : false;
    this.search1();
  }

  onSearch2($event) {
    this.searchData2 = $event;
    this.pageNumber2 = 1;
    this.search2();
  }

  getTotalTableData2() {
    this.explorerService.getTotalCount(this.tableQuery2, this.tableOutput2, this.searchData2)
      .subscribe(
        (result) => {
          this.totalItems2 = result;
        },
        (error) => console.log(error)
      );
  }

  private search2() {
    this.explorerService.tableSearch(this.tableQuery2, this.tableOutput2, this.searchData2, this.pageNumber2,
      this.pageSize2, this.orderColumn2, this.descending2)
      .subscribe(result => {
          this.tableData2 = result;
          this.tableOutput2 = result.outputType;
          if (this.orderColumn2 == null) {
            this.orderColumn2 = result.headers[0].property;
          }
          this.getTotalTableData2();
        },
        error => {
          console.log(error);
          this.log.error('Table data could not be loaded. Please try again.');
        }
      );
  }

  pageChange2($event) {
    this.pageNumber2 = $event.pageIndex + 1;
    this.pageSize2 = $event.pageSize;
    this.search2();
  }

  onOrderChange2($event) {
    this.orderColumn2 = $event.active;
    this.descending2 = $event.direction == 'desc' ? true : false;
    this.search2();
  }

  onSearch3($event) {
    this.searchData3 = $event;
    this.pageNumber3 = 1;
    this.search3();
  }

  getTotalTableData3() {
    this.explorerService.getTotalCount(this.tableQuery3, this.tableOutput3, this.searchData3)
      .subscribe(
        (result) => {
          this.totalItems3 = result;
        },
        (error) => console.log(error)
      );
  }

  private search3() {
    this.explorerService.tableSearch(this.tableQuery3, this.tableOutput3, this.searchData3, this.pageNumber3,
      this.pageSize3, this.orderColumn3, this.descending3)
      .subscribe(result => {
          this.tableData3 = result;
          this.tableOutput3 = result.outputType;
          if (this.orderColumn3 == null) {
            this.orderColumn3 = result.headers[0].property;
          }
          this.getTotalTableData3();
        },
        error => {
          this.log.error('Table data could not be loaded. Please try again.');
        }
      );
  }

  pageChange3($event) {
    this.pageNumber3 = $event.pageIndex + 1;
    this.pageSize3 = $event.pageSize;
    this.search3();
  }

  onOrderChange3($event) {
    this.orderColumn3 = $event.active;
    this.descending3 = $event.direction == 'desc' ? true : false;
    this.search3();
  }

  onSearch4($event) {
    this.searchData4 = $event;
    this.pageNumber4 = 1;
    this.search4();
  }

  getTotalTableData4() {
    this.explorerService.getTotalCount(this.tableQuery4, this.tableOutput4, this.searchData4)
      .subscribe(
        (result) => {
          this.totalItems4 = result;
        },
        (error) => console.log(error)
      );
  }

  private search4() {
    this.explorerService.tableSearch(this.tableQuery4, this.tableOutput4, this.searchData4, this.pageNumber4,
      this.pageSize4, this.orderColumn4, this.descending4)
      .subscribe(result => {
          this.tableData4 = result;
          this.tableOutput4 = result.outputType;
          if (this.orderColumn4 == null) {
            this.orderColumn4 = result.headers[0].property;
          }
          this.getTotalTableData4();
        },
        error => {
          this.log.error('Table data could not be loaded. Please try again.');
        }
      );
  }

  pageChange4($event) {
    this.pageNumber4 = $event.pageIndex + 1;
    this.pageSize4 = $event.pageSize;
    this.search4();
  }

  onOrderChange4($event) {
    this.orderColumn4 = $event.active;
    this.descending4 = $event.direction == 'desc' ? true : false;
    this.search4();
  }


}
