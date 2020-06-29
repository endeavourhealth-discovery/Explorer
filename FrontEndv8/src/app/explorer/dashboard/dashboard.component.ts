import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatOption} from "@angular/material/core";
import {strictEqual} from "assert";
import {MatDialog} from "@angular/material/dialog";
import {PatientComponent} from "../patient/patient.component";


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
  results = new FormControl();
  resultList: string[] = [''];
  selected: string = '';
  showResult: boolean = false;
  months: string[] = [''];

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
  showRefLines: boolean = false;
  logarithmic: boolean = true;

  refLines = [ { value: 1, name: 'Minimum' }, { value: 2, name: 'Average' }, { value: 3, name: 'Maximum' } ];

  colorScheme = {
    domain: ['#5aa454', '#e44d25', '#cfc0bb', '#7aa3e5', '#a8385d', '#aae3f5']
  };

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog
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
    console.log("Values: " + this.selected);

    if (this.chartType=="nhs111") {
      this.resultList = ['[D]Fever NOS', '[D]Cough'];
      if (this.selected == ""){
        values = this.resultList.toString();
      }
      else {
        values = this.selected;
      }
      this.chartTitle = 'NEL LONDON AMBULANCE SERVICE NHS TRUST - NHS111 CALL TREND - COUGH AND FEVER';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showResult = true;
    }
    else if (this.chartType=="consultations_covid") {
      this.resultList = ['All consultations','Suspected coronavirus consultation'];
      if (this.selected == ""){
        values = this.resultList.toString();
      }
      else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showResult = true;
    }
    else if (this.chartType=="consultations_types") {
      this.resultList = ['Home visit','Surgery face to face consultation','Telephone consultation','Video consultation','Email or Text message consultation'];
      if (this.selected == ""){
        values = this.resultList.toString();
      }
      else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
    }
    else if (this.chartType=="hospital") {
      this.resultList = ['Hospital inpatient admission','Hospital day case discharge','A&E discharge/end visit','A&E transfer','A&E attendance','Hospital discharge'];
      if (this.selected == ""){
        values = this.resultList.toString();
      }
      else {
        values = this.selected;
      }
      this.chartTitle = 'Barts NHS Trust - Daily Trend of Admissions and Discharges';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
    }
    else if (this.chartType=="covid") {
      this.resultList = ['Suspected coronavirus infection','Confirmed Covid 19','Tested for coronavirus infection'];
      if (this.selected == ""){
        values = this.resultList.toString();
      }
      else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL Day trend of Confirmed, Suspected and Tested for Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
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
                      value: this.applyLogarithm(v.value)
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

  formatYAxis(val: number) {
    if (this.logarithmic == true) {
      val = Math.round((Math.pow(10, val) + Number.EPSILON) * 100) / 100;
      return val.toLocaleString()
    }
    else {
      return Number(val).toLocaleString()
    }
  }

  applyLogarithm(value: number) {
    if (this.logarithmic == true) {
      return Math.log10(value)
    }
    else  {
      return value
    }
  }

  formatXAxis(val: any): String {
    this.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var month = (val.toLocaleString()).substring(3,5);
    var monthName = this.months[(Number(month)-1)];
    var day = (val.toLocaleString()).substring(0,2);
    var year = (val.toLocaleString()).substring(6,10);
    val = (day + " " + monthName + " " + year);

    return val.toLocaleString();
  }

  onSelect(data): void {
    console.log('Item clicked', JSON.parse(JSON.stringify(data)));

      const dialogRef = this.dialog.open(PatientComponent, {
        height: '850px',
        width: '1600px',
      });

      dialogRef.afterClosed().subscribe(result => {

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

}
