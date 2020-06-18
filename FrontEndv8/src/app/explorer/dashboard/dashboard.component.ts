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
  showAreaChart: boolean = false;
  gradient: boolean = false;

  colorScheme = {
    domain: ['#5AA454', '#E44D25', '#CFC0BB', '#7aa3e5', '#a8385d', '#aae3f5']
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
      this.chartTitle = 'NEL LONDON AMBULANCE SERVICE NHS TRUST - NHS111 ENCOUNTER TREND BY CALL REASON';
      this.showLineCharts = true;
      this.showBarCharts = false;
    }
    else if (this.chartType=="consultations") {
      values = 'All consultations,Suspected coronavirus infection';
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
    }
    else if (this.chartType=="consultations_bar") {
      values = 'covid_age_groups';
      multiChart = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
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
