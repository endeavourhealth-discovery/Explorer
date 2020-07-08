import {AfterViewInit, Component, OnInit, Output, ViewChild} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatOption} from "@angular/material/core";
import {strictEqual} from "assert";
import {MatDialog} from "@angular/material/dialog";
import {PatientComponent} from "../patient/patient.component";
import {Globals} from '../globals'

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  //patient find
  globals: Globals;
  name: string = "";

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
  chartName: string = "";

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
  logarithmic: boolean = false;
  accumulative: boolean = false;

  refLines = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];

  colorScheme = {
    domain: ['#5aa454', '#e44d25', '#cfc0bb', '#7aa3e5', '#a8385d', '#aae3f5']
  };

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    globals: Globals) {
    this.globals = globals;
  }


  ngOnInit() {

    this.route.queryParams
      .subscribe(params => {
        console.log(params['chartType']);
        this.chartType = params['chartType'];
      });
    this.refresh();
  }

  refresh() {
    let values = "";
    let multiChart = true;

    if (this.chartType == "NHS111 Dashboard") {
      this.resultList = ['[D]Fever NOS', '[D]Cough'];
      if (this.selected == "") {
        values = this.resultList.toString();
      } else {
        values = this.selected;
      }
      this.chartTitle = 'NEL LONDON AMBULANCE SERVICE NHS TRUST - NHS111 CALL TREND - COUGH AND FEVER';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showResult = true;
    } else if (this.chartType == "Covid Consultations Dashboard") {
      this.resultList = ['All consultations', 'Suspected coronavirus consultation'];
      if (this.selected == "") {
        values = this.resultList.toString();
      } else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showResult = true;
    } else if (this.chartType == "Consultation Types Dashboard") {
      this.resultList = ['Home visit', 'Surgery face to face consultation', 'Telephone consultation', 'Video consultation', 'Email or Text message consultation'];
      if (this.selected == "") {
        values = this.resultList.toString();
      } else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL GP CONSULTATIONS';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
    } else if (this.chartType == "Hospital Encounter Dashboard") {
      this.resultList = ['Hospital inpatient admission', 'Hospital day case discharge', 'A&E discharge/end visit', 'A&E transfer', 'A&E attendance', 'Hospital discharge'];
      if (this.selected == "") {
        values = this.resultList.toString();
      } else {
        values = this.selected;
      }
      this.chartTitle = 'Barts NHS Trust - Daily Trend of Admissions and Discharges';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
    } else if (this.chartType == "Covid Trend Dashboard") {
      this.resultList = ['Suspected coronavirus infection', 'Confirmed Covid 19', 'Tested for coronavirus infection'];
      if (this.selected == "") {
        values = this.resultList.toString();
      } else {
        values = this.selected;
      }
      this.chartTitle = 'NEL/NWL Day trend of Confirmed, Suspected and Tested for Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showResult = true;
    } else if (this.chartType == "Covid Age Deceased Dashboard") {
      values = 'covid_death_age';
      this.chartTitle = 'NEL/NWL Age breakdown of deceased patients with Confirmed or Suspected Covid 19';
      multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'Age Decile Band';
    } else if (this.chartType == "Covid Daily Deceased Dashboard") {
      values = 'covid_death_daily';
      this.chartTitle = 'NEL/NWL Daily trend of deceased patients with Confirmed or Suspected Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = true;
    } else if (this.chartType == "Covid CCG Deceased Dashboard") {
      values = 'covid_death_ccg';
      this.chartTitle = 'NEL/NWL CCG breakdown of deceased patients with Confirmed or Suspected Covid 19';
      multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'CCG';
    }

    if (multiChart) {
      let accumulative = "0";
      if (this.accumulative) {
        accumulative = "1";
      }

      this.explorerService.getDashboard(values, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), accumulative)
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
          this.chartResultsSingle = result.series;
        });
    }
  }

  formatTooltipYAxis(val: number) {
    if (this.logarithmic == true) {
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

  applyLogarithm(value: number) {
    if (this.logarithmic == true) {
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

  onSelectLine(data): void {
    this.patientDialog(data.series, data.name);
  }

  onSelectBar(data): void {
    this.patientDialog(this.chartName, data.name);
  }

  patientDialog(chartName: any, seriesName: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      height: '850px',
      width: '1600px',

      data: {chartName: chartName, seriesName: seriesName}
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

  download() {
    var csvData = this.ConvertToCSV(this.chartResults);
    var blob = new Blob([csvData], { type: 'text/csv' });
    var url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  ConvertToCSV(objArray) {
    console.log(objArray.valueOf());
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';
    var row = "";
    for (var i = 0; i < array.length; i++) {
      if (array[i][4]!=null)
        array[i][4] = array[i][4].replace(',','');
      var line = '';
      for (var index in array[i]) {
        if (line != '') line += ','
        line += array[i][index];
      }
      str += line + '\r\n';
    }
    return str;
  }

}
