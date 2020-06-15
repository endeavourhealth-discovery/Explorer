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
  logarithmic: boolean = false;

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

    if (this.chartType=="nhs111") {
      this.chartTitle = 'NEL LONDON AMBULANCE SERVICE NHS TRUST - NHS111 ENCOUNTER TREND BY CALL REASON';
      this.showLineCharts = true;
      this.showBarCharts = false;
    }
    else if (this.chartType=="consultations") {
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.logarithmic = true;
    }

    this.refresh();
  }

  refresh() {
    if (this.chartType=="nhs111") {
      this.explorerService.getDashboard('[D]Fever NOS,[D]Cough', this.formatDate(this.dateFrom), this.formatDate(this.dateTo))
        .subscribe(result => {
          console.log(result);

          this.chartResults = result.results;
        });
    }
    else if (this.chartType=="consultations") {
      this.explorerService.getDashboard('All consultations,Suspected coronavirus infection', this.formatDate(this.dateFrom), this.formatDate(this.dateTo))
        .subscribe(result => {
          console.log(result);

          this.chartResults = result.results;
          // apply log10 to values in series
          this.chartResults = this.chartResults.map(
            e => {
              return {
                name: e.name,
                series: e.series.map(
                  v => {
                    return {
                      name: v.name,
                      value: Math.log10(v.value)
                    }
                  }
                )
              }
            }
          )
        });
    }
    else if (this.chartType=="consultations_bar") {
      this.explorerService.getDashboardSingle('covid_age_groups', this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1)
        .subscribe(result => {
          console.log(result);

          this.chartResultsSingle = result.series;
        });
    }
  }

  // apply pow10 to yAxis tick values and tootip value
  getMathPower(val: number){
    if (this.logarithmic)
      return Math.round(Math.pow(10,val));
    else
      return val;
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
