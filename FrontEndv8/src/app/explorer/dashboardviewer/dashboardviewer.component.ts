import {AfterViewInit, Component, OnInit, Output} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatDialog} from "@angular/material/dialog";
import {PatientComponent} from "../patient/patient.component";
import {Globals} from '../globals'
import {TableData} from "./model/TableData";

interface widget {
  icon: string;
  name: string;
}

interface dashboardQuery {
  selectedVisualisation1: string;
  selectedOutputField1: string;
  selectedSeries1: string[];
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedVisualisation2: string;
  selectedOutputField2: string;
  selectedSeries2: string[];
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedVisualisation3: string;
  selectedOutputField3: string;
  selectedSeries3: string[];
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedVisualisation4: string;
  selectedOutputField4: string;
  selectedSeries4: string[];
  xAxisLabel4: string;
  yAxisLabel4: string;
  visualType: widget[];
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
  seriesList1: string[] = [];
  seriesList2: string[] = [];
  seriesList3: string[] = [];
  seriesList4: string[] = [];
  selectedCCG1: string = '';
  selectedCCGString1: string = '';
  selectedCCG2: string = '';
  selectedCCGString2: string = '';
  selectedCCG3: string = '';
  selectedCCGString3: string = '';
  selectedCCG4: string = '';
  selectedCCGString4: string = '';
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
  timeline: boolean = true;
  showGridLines1: boolean = true;
  showAreaChart1: boolean = false;
  gradient1: boolean = false;
  showRefLines1: boolean = false;
  logarithmic1: boolean = false;
  cumulative1: boolean = false;
  weekly1: boolean = false;
  refLines1 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ccgList1 = [];
  ccgValues1 = new FormControl(this.ccgList1);
  showGridLines2: boolean = true;
  showAreaChart2: boolean = false;
  gradient2: boolean = false;
  showRefLines2: boolean = false;
  logarithmic2: boolean = false;
  cumulative2: boolean = false;
  weekly2: boolean = false;
  refLines2 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ccgList2 = [];
  ccgValues2 = new FormControl(this.ccgList2);
  showGridLines3: boolean = true;
  showAreaChart3: boolean = false;
  gradient3: boolean = false;
  showRefLines3: boolean = false;
  logarithmic3: boolean = false;
  cumulative3: boolean = false;
  weekly3: boolean = false;
  refLines3 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ccgList3 = [];
  ccgValues3 = new FormControl(this.ccgList3);
  showGridLines4: boolean = true;
  showAreaChart4: boolean = false;
  gradient4: boolean = false;
  showRefLines4: boolean = false;
  logarithmic4: boolean = false;
  cumulative4: boolean = false;
  weekly4: boolean = false;
  refLines4 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ccgList4 = [];
  ccgValues4 = new FormControl(this.ccgList4);
  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };
  cols = "2";
  rowHeight = "49%";

  selectedVisualisation1: string;
  selectedOutputField1: string;
  selectedSeries1: string[] = [];
  xAxisLabel1: string;
  yAxisLabel1: string;
  selectedVisualisation2: string;
  selectedOutputField2: string;
  selectedSeries2: string[] = [];
  xAxisLabel2: string;
  yAxisLabel2: string;
  selectedVisualisation3: string;
  selectedOutputField3: string;
  selectedSeries3: string[] = [];
  xAxisLabel3: string;
  yAxisLabel3: string;
  selectedVisualisation4: string;
  selectedOutputField4: string;
  selectedSeries4: string[] = [];
  xAxisLabel4: string;
  yAxisLabel4: string;
  selectedWidgets : widget[] = [
  ];

  tableData1: TableData = null;
  tableData2: TableData = null;
  tableData3: TableData = null;
  tableData4: TableData = null;

  tableSeries1: string = "";
  tableSeries2: string = "";
  tableSeries3: string = "";
  tableSeries4: string = "";

  searchData1: string = "";
  searchData2: string = "";
  searchData3: string = "";
  searchData4: string = "";

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

  orderColumn1 = 'firstnames';
  orderColumn2 = 'firstnames';
  orderColumn3 = 'firstnames';
  orderColumn4 = 'firstnames';

  descending1 = false;
  descending2 = false;
  descending3 = false;
  descending4 = false;

  tableStyle1 = '';
  tableStyle2 = '';
  tableStyle3 = '';
  tableStyle4 = '';

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    globals: Globals) {
    this.globals = globals;
  }

  ngOnInit() {
    this.explorerService.getLookupLists('3')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelection1(event) {
    if (event.checked) {
      this.ccgValues1 = new FormControl(this.ccgList1);
      this.selectedCCGString1 = this.ccgList1.toString();
    } else {
      this.ccgValues1 = new FormControl([]);
      this.selectedCCGString1 = "";
    }
    this.refresh1(false);
  }

  toggleSelection2(event) {
    if (event.checked) {
      this.ccgValues2 = new FormControl(this.ccgList2);
      this.selectedCCGString2 = this.ccgList2.toString();
    } else {
      this.ccgValues2 = new FormControl([]);
      this.selectedCCGString2 = "";
    }
    this.refresh2(false);
  }

  toggleSelection3(event) {
    if (event.checked) {
      this.ccgValues3 = new FormControl(this.ccgList3);
      this.selectedCCGString3 = this.ccgList3.toString();
    } else {
      this.ccgValues3 = new FormControl([]);
      this.selectedCCGString3 = "";
    }
    this.refresh3(false);
  }

  toggleSelection4(event) {
    if (event.checked) {
      this.ccgValues4 = new FormControl(this.ccgList4);
      this.selectedCCGString4 = this.ccgList4.toString();
    } else {
      this.ccgValues4 = new FormControl([]);
      this.selectedCCGString4 = "";
    }
    this.refresh4(false);
  }

  refresh1(override) {
    if (this.selectedCCG1=="" && this.selectAll1) {
      this.ccgValues1 = new FormControl(this.ccgList1);
      this.selectedCCGString1 = this.ccgList1.toString();
    }

    if (override) {
      this.selectAll1 = false;
      this.selectedCCGString1 = this.selectedCCG1.toString();
    }

    let values1 = this.selectedSeries1.toString();

    this.showLineCharts1 = this.selectedWidgets[0].name=='Line chart';
    this.showBarCharts1 = this.selectedWidgets[0].name=='Bar chart';
    this.showTables1 = this.selectedWidgets[0].name=='Table';

    if (this.showLineCharts1) {
      let cumulative = "0";
      if (this.cumulative1) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly1) {
        weekly = "1";
      }

      this.explorerService.getDashboard(values1, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), cumulative, this.selectedCCGString1, weekly)
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
      this.explorerService.getDashboardSingle(values1, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), 1, this.selectedCCGString1)
        .subscribe(result => {
          this.chartResultsSingle1 = result.series;
        });
    }

    if (this.showTables1) {
      this.tableSeries1 = this.selectedSeries1[0];
      this.search1();
      this.getTotalTableData1();
    }
  }

  refresh2(override) {
    if (this.selectedCCG2=="" && this.selectAll2) {
      this.ccgValues2 = new FormControl(this.ccgList2);
      this.selectedCCGString2 = this.ccgList2.toString();
    }

    if (override) {
      this.selectAll2 = false;
      this.selectedCCGString2 = this.selectedCCG2.toString();
    }

    let values2 = this.selectedSeries2.toString();

    this.showLineCharts2 = this.selectedWidgets[1].name=='Line chart';
    this.showBarCharts2 = this.selectedWidgets[1].name=='Bar chart';
    this.showTables2 = this.selectedWidgets[1].name=='Table';

    if (this.showLineCharts2) {
      let cumulative = "0";
      if (this.cumulative2) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly2) {
        weekly = "1";
      }

      this.explorerService.getDashboard(values2, this.formatDate(this.dateFrom2), this.formatDate(this.dateTo2), cumulative, this.selectedCCGString2, weekly)
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
      this.explorerService.getDashboardSingle(values2, this.formatDate(this.dateFrom2), this.formatDate(this.dateTo2), 1, this.selectedCCGString2)
        .subscribe(result => {
          this.chartResultsSingle2 = result.series;
        });
    }

    if (this.showTables2) {
      this.tableSeries2 = this.selectedSeries2[0];
      this.search2();
      this.getTotalTableData2();
    }
  }

  refresh3(override) {
    if (this.selectedCCG3=="" && this.selectAll3) {
      this.ccgValues3 = new FormControl(this.ccgList3);
      this.selectedCCGString3 = this.ccgList3.toString();
    }

    if (override) {
      this.selectAll3 = false;
      this.selectedCCGString3 = this.selectedCCG3.toString();
    }

    let values3 = this.selectedSeries3.toString();

    this.showLineCharts3 = this.selectedWidgets[2].name=='Line chart';
    this.showBarCharts3 = this.selectedWidgets[2].name=='Bar chart';
    this.showTables3 = this.selectedWidgets[2].name=='Table';

    if (this.showLineCharts3) {
      let cumulative = "0";
      if (this.cumulative3) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly3) {
        weekly = "1";
      }

      this.explorerService.getDashboard(values3, this.formatDate(this.dateFrom3), this.formatDate(this.dateTo3), cumulative, this.selectedCCGString3, weekly)
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
      this.explorerService.getDashboardSingle(values3, this.formatDate(this.dateFrom3), this.formatDate(this.dateTo3), 1, this.selectedCCGString3)
        .subscribe(result => {
          this.chartResultsSingle3 = result.series;
        });
    }

    if (this.showTables3) {
      this.tableSeries3 = this.selectedSeries3[0];
      this.search3();
      this.getTotalTableData3();
    }
  }

  refresh4(override) {
    if (this.selectedCCG4=="" && this.selectAll4) {
      this.ccgValues4 = new FormControl(this.ccgList4);
      this.selectedCCGString4 = this.ccgList4.toString();
    }

    if (override) {
      this.selectAll4 = false;
      this.selectedCCGString4 = this.selectedCCG4.toString();
    }

    let values4 = this.selectedSeries4.toString();

    this.showLineCharts4 = this.selectedWidgets[3].name=='Line chart';
    this.showBarCharts4 = this.selectedWidgets[3].name=='Bar chart';
    this.showTables4 = this.selectedWidgets[3].name=='Table';

    if (this.showLineCharts4) {
      let cumulative = "0";
      if (this.cumulative4) {
        cumulative = "1";
      }
      let weekly = "0";
      if (this.weekly4) {
        weekly = "1";
      }

      this.explorerService.getDashboard(values4, this.formatDate(this.dateFrom4), this.formatDate(this.dateTo4), cumulative, this.selectedCCGString4, weekly)
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
      this.explorerService.getDashboardSingle(values4, this.formatDate(this.dateFrom4), this.formatDate(this.dateTo4), 1, this.selectedCCGString4)
        .subscribe(result => {
          this.chartResultsSingle4 = result.series;
        });
    }

    if (this.showTables4) {
      this.tableSeries4 = this.selectedSeries4[0];
      this.search4();
      this.getTotalTableData4();
    }
  }

  loadList(lists: any) {
    lists.results.map(
      e => {
        this.ccgList1.push(e.type);
        this.ccgList2.push(e.type);
        this.ccgList3.push(e.type);
        this.ccgList4.push(e.type);
      }
    )
    this.ccgValues1 = new FormControl(this.ccgList1);
    this.ccgValues2 = new FormControl(this.ccgList2);
    this.ccgValues3 = new FormControl(this.ccgList3);
    this.ccgValues4 = new FormControl(this.ccgList4);

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

  parseDashboard (result: any) {
    result.results.map(
      e => {
        let query: dashboardQuery = JSON.parse(e.jsonQuery);

        this.selectedVisualisation1 = query.selectedVisualisation1;
        this.selectedOutputField1 = query.selectedOutputField1;
        this.selectedSeries1 = query.selectedSeries1;
        this.xAxisLabel1 = query.xAxisLabel1;
        this.yAxisLabel1 = query.yAxisLabel1;

        this.selectedVisualisation2 = query.selectedVisualisation2;
        this.selectedOutputField2 = query.selectedOutputField2;
        this.selectedSeries2 = query.selectedSeries2;
        this.xAxisLabel2 = query.xAxisLabel2;
        this.yAxisLabel2 = query.yAxisLabel2;

        this.selectedVisualisation3 = query.selectedVisualisation3;
        this.selectedOutputField3 = query.selectedOutputField3;
        this.selectedSeries3 = query.selectedSeries3;
        this.xAxisLabel3 = query.xAxisLabel3;
        this.yAxisLabel3 = query.yAxisLabel3;

        this.selectedVisualisation4 = query.selectedVisualisation4;
        this.selectedOutputField4 = query.selectedOutputField4;
        this.selectedSeries4 = query.selectedSeries4;
        this.xAxisLabel4 = query.xAxisLabel4;
        this.yAxisLabel4 = query.yAxisLabel4;

        this.selectedWidgets = query.visualType;

      }
    )

    this.seriesList1 = this.selectedSeries1;
    this.seriesValues1 = new FormControl(this.seriesList1);

    this.seriesList2 = this.selectedSeries2;
    this.seriesValues2 = new FormControl(this.seriesList2);

    this.seriesList3 = this.selectedSeries3;
    this.seriesValues3 = new FormControl(this.seriesList3);

    this.seriesList4 = this.selectedSeries4;
    this.seriesValues4 = new FormControl(this.seriesList4);

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

    console.log(this.selectedWidgets.length);
    if (this.selectedWidgets.length < 3) {
      this.pageSize1 = 10;
      this.pageSize2 = 10;
      this.pageSize3 = 10;
      this.pageSize4 = 10;
      this.tableStyle1 = 'table-scroll-800';
      this.tableStyle2 = 'table-scroll-800';
      this.tableStyle3 = 'table-scroll-800';
      this.tableStyle4 = 'table-scroll-800';
    }  else {
      this.pageSize1 = 5;
      this.pageSize2 = 5;
      this.pageSize3 = 5;
      this.pageSize4 = 5;
      this.tableStyle1 = 'table-scroll-400';
      this.tableStyle2 = 'table-scroll-400';
      this.tableStyle3 = 'table-scroll-400';
      this.tableStyle4 = 'table-scroll-400';
    }

    if (this.selectedWidgets.length==1) {
      this.cols = "1";
      this.rowHeight = "99%";
      this.view1 = [1300, 700];
      this.widget1 = true;

      this.refresh1(false);
    }
    if (this.selectedWidgets.length==2) {
      this.cols = "2";
      this.rowHeight = "99%";
      this.view1 = [770, 700];
      this.view2 = [770, 700];
      this.widget1 = true;
      this.refresh1(false);
      this.widget2 = true;
      this.refresh2(false);
    }
    if (this.selectedWidgets.length==3) {
      this.cols = "2";
      this.rowHeight = "49%";
      this.view1 = [770, 270];
      this.view2 = [770, 270];
      this.view3 = [770, 270];
      this.widget1 = true;
      this.refresh1(false);
      this.widget2 = true;
      this.refresh2(false);
      this.widget3 = true;
      this.refresh3(false);
      this.timeline = false;
    }
    if (this.selectedWidgets.length==4) {
      this.cols = "2";
      this.rowHeight = "49%";
      this.view1 = [770, 270];
      this.view2 = [770, 270];
      this.view3 = [770, 270];
      this.view4 = [770, 270];
      this.widget1 = true;
      this.refresh1(false);
      this.widget2 = true;
      this.refresh2(false);
      this.widget3 = true;
      this.refresh3(false);
      this.widget4 = true;
      this.refresh4(false);
      this.timeline = false;
    }

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

  formatXAxis(val: any): String {
    this.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var month = (val.toLocaleString()).substring(3, 5);
    var monthName = this.months[(Number(month) - 1)];
    var day = (val.toLocaleString()).substring(0, 2);
    var year = (val.toLocaleString()).substring(6, 10);
    val = (day + " " + monthName + " " + year);

    return val.toLocaleString();
  }

  onSelectLine1(data): void {
    this.patientDialog(data.series, data.name, this.selectedCCGString1);
  }

  onSelectBar1(data): void {
    this.patientDialog(this.selectedSeries1, data.name, this.selectedCCGString1);
  }

  onSelectLine2(data): void {
    this.patientDialog(data.series, data.name, this.selectedCCGString2);
  }

  onSelectBar2(data): void {
    this.patientDialog(this.selectedSeries2, data.name, this.selectedCCGString2);
  }

  onSelectLine3(data): void {
    this.patientDialog(data.series, data.name, this.selectedCCGString3);
  }

  onSelectBar3(data): void {
    this.patientDialog(this.selectedSeries3, data.name, this.selectedCCGString3);
  }

  onSelectLine4(data): void {
    this.patientDialog(data.series, data.name, this.selectedCCGString4);
  }

  onSelectBar4(data): void {
    this.patientDialog(this.selectedSeries4, data.name, this.selectedCCGString4);
  }

  patientDialog(chartName: any, seriesName: any, ccgs: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      height: '830px',
      width: '1600px',

      data: {chartName: chartName, seriesName: seriesName, ccgs: ccgs}
    });

    dialogRef.afterClosed().subscribe(result => {
      let patientId = 0;
      if (result) {
        patientId = result;
        window.location.href = "https://devgateway.discoverydataservice.net/record-viewer/#/summary?patient_id="+patientId;
      }
    });
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
      csvData = this.ConvertToCSVMulti(this.chartResults1,this.selectedCCGString1);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle1,this.selectedCCGString1,this.selectedSeries1);

    let blob = new Blob([csvData], { type: 'text/csv' });
    let url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  download2() {
    var csvData = '';
    if (this.showLineCharts2)
      csvData = this.ConvertToCSVMulti(this.chartResults2,this.selectedCCGString2);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle2,this.selectedCCGString2,this.selectedSeries2);

    let blob = new Blob([csvData], { type: 'text/csv' });
    let url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  download3() {
    var csvData = '';
    if (this.showLineCharts3)
      csvData = this.ConvertToCSVMulti(this.chartResults3,this.selectedCCGString3);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle3,this.selectedCCGString3,this.selectedSeries3);

    let blob = new Blob([csvData], { type: 'text/csv' });
    let url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  download4() {
    var csvData = '';
    if (this.showLineCharts4)
      csvData = this.ConvertToCSVMulti(this.chartResults4,this.selectedCCGString4);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle4,this.selectedCCGString4,this.selectedSeries4);

    let blob = new Blob([csvData], { type: 'text/csv' });
    let url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  ConvertToCSVMulti(objArray, group) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = 'group,key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        for (let key2 in array[key].series) {
          if (array[key].series.hasOwnProperty(key2)) {
            let point = array[key].series[key2].name;
            if (point.toString().indexOf("GMT") > -1) { // date type of series
              point = this.formatDate(point);
            }
            csv += group.replaceAll(',','|')+ ',' + array[key].name+ ',' + point + ',' + array[key].series[key2].value + '\r\n';
          }
        }
      }
    }
    return csv;
  }

  ConvertToCSVSingle(objArray, group, series) {
    console.log(objArray);
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = 'group,key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        let point = array[key].name;
        if (point.toString().indexOf("GMT") > -1) { // date type of series
          point = this.formatDate(point);
        }
        csv += group.replaceAll(',','|')+ ',' +series+ ',' + point + ',' + array[key].value + '\r\n';
      }
    }
    return csv;
  }

  onSearch1($event) {
    this.searchData1 = $event;
    this.pageNumber1 = 1;
    this.tableData1 = null;
    this.search1();
    this.getTotalTableData1();
  }

  getTotalTableData1() {
    this.explorerService.getTotalCount(this.tableSeries1, this.searchData1)
      .subscribe(
        (result) => {
          this.totalItems1 = result;
        },
        (error) => console.log(error)
      );
  }

  private search1() {
    this.explorerService.tableSearch(this.tableSeries1, this.searchData1, this.pageNumber1, this.pageSize1, this.orderColumn1, this.descending1)
      .subscribe(result => {
          this.tableData1 = result;
        },
        error => {
          this.log.error('Table data could not be loaded. Please try again.');
        }
      );
  }

  pageChange1($event) {
    this.pageNumber1 = $event.pageIndex + 1;
    this.pageSize1 = $event.pageSize;
    this.search1();
  }

  onOrderChange1($event) {
    this.orderColumn1 = $event.active;
    this.descending1 = $event.direction1 == 'desc' ? true : false;
    this.search1();
  }

  onSearch2($event) {
    this.searchData2 = $event;
    this.pageNumber2 = 1;
    this.tableData2 = null;
    this.search2();
    this.getTotalTableData2();
  }

  getTotalTableData2() {
    this.explorerService.getTotalCount(this.tableSeries2, this.searchData2)
      .subscribe(
        (result) => {
          this.totalItems2 = result;
        },
        (error) => console.log(error)
      );
  }

  private search2() {
    this.explorerService.tableSearch(this.tableSeries2, this.searchData2, this.pageNumber2, this.pageSize2, this.orderColumn2, this.descending2)
      .subscribe(result => {
          this.tableData2 = result;
        },
        error => {
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
    this.descending2 = $event.direction2 == 'desc' ? true : false;
    this.search2();
  }

  onSearch3($event) {
    this.searchData3 = $event;
    this.pageNumber3 = 1;
    this.tableData3 = null;
    this.search3();
    this.getTotalTableData3();
  }

  getTotalTableData3() {
    this.explorerService.getTotalCount(this.tableSeries3, this.searchData3)
      .subscribe(
        (result) => {
          this.totalItems3 = result;
        },
        (error) => console.log(error)
      );
  }

  private search3() {
    this.explorerService.tableSearch(this.tableSeries3, this.searchData3, this.pageNumber3, this.pageSize3, this.orderColumn3, this.descending3)
      .subscribe(result => {
          this.tableData3 = result;
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
    this.descending3 = $event.direction3 == 'desc' ? true : false;
    this.search3();
  }

  onSearch4($event) {
    this.searchData4 = $event;
    this.pageNumber4 = 1;
    this.tableData4 = null;
    this.search4();
    this.getTotalTableData4();
  }

  getTotalTableData4() {
    this.explorerService.getTotalCount(this.tableSeries4, this.searchData4)
      .subscribe(
        (result) => {
          this.totalItems4 = result;
        },
        (error) => console.log(error)
      );
  }

  private search4() {
    this.explorerService.tableSearch(this.tableSeries4, this.searchData4, this.pageNumber4, this.pageSize4, this.orderColumn4, this.descending4)
      .subscribe(result => {
          this.tableData4 = result;
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
    this.descending4 = $event.direction4 == 'desc' ? true : false;
    this.search4();
  }
}
