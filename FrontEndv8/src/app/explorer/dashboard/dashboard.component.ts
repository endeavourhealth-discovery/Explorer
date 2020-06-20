import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  view: any[] = [1400, 600];
  chartResults: any[];
  chartResultsSingle: any[];
  dateFrom: string = '2020-01-01';
  dateTo: string = this.formatDate(new Date());
  chartType: string;
  showLineCharts: boolean = false;
  showBarCharts: boolean = false;

  // options
  legend: boolean = true;
  legendTitle: string = "Legend";
  legendPosition: string = 'right';
  animations: boolean = true;
  xAxis: boolean = true;
  yAxis: boolean = true;
  showYAxisLabel: boolean = true;
  showXAxisLabel: boolean = true;
  chartTitle: string = "Chart Title";
  xAxisLabel: string = 'Date';
  yAxisLabel: string = 'Count';
  timeline: boolean = true;
  showGridLines: boolean = true;
  showAreaChart: boolean = true;
  gradient: boolean = true;

  colorScheme = {
    domain: ['#5AA454', '#E44D25', '#7aa3e5', '#a8385d', '#aae3f5','#CFC0BB']
  };

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService
  ) { }

  ngOnInit() {
    this.route.data.subscribe(
      (data) => this.chartType = data.chartType
    );

    this.refresh();
  }

  refresh() {
    let values = "";
    let multiChart = true;

    if (this.chartType=="nhs111") {
      values = '[D]Fever NOS,[D]Cough';
      this.chartTitle = 'NEL LONDON AMBULANCE SERVICE NHS TRUST - NHS111 CALL TREND - COUGH AND FEVER';
      this.showLineCharts = true;
      this.showBarCharts = false;
    }
    else if (this.chartType=="consultations") {
      values = 'All consultations,Suspected coronavirus infection';
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
    }
    else if (this.chartType=="hospital") {
      values = 'Hospital inpatient admission,Hospital day case discharge,A&E discharge/end visit,A&E transfer,A&E attendance,Hospital discharge';
      this.chartTitle = 'Barts NHS Trust - Daily Trend of Admissions and Discharges';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
    }
    else if (this.chartType=="covid") {
      values = 'Suspected coronavirus infection,Confirmed Covid 19,Tested for coronavirus infection';
      this.chartTitle = 'NEL/NWL Day trend of Confirmed, Suspected and Tested for Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
    }
    else if (this.chartType=="covid_deceased_age") {
      values = 'covid_death_age';
      this.chartTitle = 'NEL/NWL Age breakdown of deceased patients with Confirmed or Suspected Covid 19';
      multiChart = false;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'Age Decile Band';
    }
    else if (this.chartType=="covid_deceased_daily") {
      values = 'covid_death_daily';
      this.chartTitle = 'NEL/NWL Daily trend of deceased patients with Confirmed or Suspected Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = true;
    }
    else if (this.chartType=="covid_deceased_ccg") {
      values = 'covid_death_ccg';
      this.chartTitle = 'NEL/NWL CCG breakdown of deceased patients with Confirmed or Suspected Covid 19';
      multiChart = false;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'CCG';
    }

    if (multiChart) {
      this.explorerService.getDashboard(values, this.formatDate(this.dateFrom), this.formatDate(this.dateTo))
        .subscribe(result => {
          this.chartResults = result.results;

          // apply log10 to values in series
          this.chartResults = this.chartResults.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: new Date(v.name),
                      value: Math.log10(v.value)
                    }
                  }
                )
              }
            }
          )
        });

    } else {
      this.explorerService.getDashboardSingle(values, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1)
        .subscribe(result => {
          console.log(result);

          this.chartResultsSingle = result.series;
        });
    }

  }

  // apply pow10 to yAxis tick values and tooltip value
  getMathPower(val: number) {
    return Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100
  }

  getYMathPower(val: number) {
    return Math.round(Math.pow(10, val));
  }

  dateTickFormatting(val: any): String {
    return new Date(val).toLocaleDateString();
  }

  onSelect(data): void {
    console.log('Item clicked', JSON.parse(JSON.stringify(data)));
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
}
