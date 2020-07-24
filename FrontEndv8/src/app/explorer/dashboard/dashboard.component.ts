import {AfterViewInit, Component, OnInit, Output} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
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
  selectAll: boolean = true;

  view: any[] = [1400, 600];
  chartResults: any[];
  chartResultsSingle: any[];
  dateFrom: string = '2020-01-01';
  dateTo: string = this.formatDate(new Date());
  dashboardNumber: string;
  showLineCharts: boolean = false;
  showBarCharts: boolean = false;
  seriesValues = new FormControl();
  seriesList: string[] = [''];
  selectedSeries: string = '';
  selectedCCGs: string = '';
  selectedCCGString: string = '';
  showSeriesFilter: boolean = false;
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
  yAxisLabel: string = 'Number of people with indicator';
  timeline: boolean = true;
  showGridLines: boolean = true;
  showAreaChart: boolean = true;
  gradient: boolean = true;
  showRefLines: boolean = false;
  logarithmic: boolean = false;
  cumulative: boolean = false;
  weekly: boolean = false;
  multiChart: boolean = true;

  refLines = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];

  ccgList = [];
  ccgValues = new FormControl(this.ccgList);

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
    this.explorerService.getLookupLists('3')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelection(event) {
    if (event.checked) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    } else {
      this.ccgValues = new FormControl([]);
      this.selectedCCGString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    let values = "";

    if (this.selectedCCGs=="" && this.selectAll) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    }

    if (this.selectedSeries=="")
      this.selectedSeries = this.seriesList.toString();

    if (override) {
      this.selectAll = false;
      this.selectedCCGString = this.selectedCCGs.toString();
    }

    if (this.dashboardNumber == "5") {
      values = this.selectedSeries;
      this.chartTitle = 'London Ambulance Service NHS Trust - NHS111 call trend - cough and fever';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "6") {
      values = this.selectedSeries;
      this.chartTitle = 'GP consultations for suspected coronavirus';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "7") {
      values = this.selectedSeries;
      this.chartTitle = 'GP consultation types';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "8") {
      values = this.selectedSeries;
      this.chartTitle = 'Barts NHS Trust - Daily Trend of Admissions and Discharges';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "1") {
      values = this.selectedSeries;
      this.chartTitle = 'Day trend of Confirmed, Suspected and Tested for Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "9") {
      values = this.selectedSeries;
      this.chartTitle = 'Day trend of Confirmed, Suspected and Tested for Covid 19 by Ethnic Group';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = false;
      this.showSeriesFilter = true;
    } else if (this.dashboardNumber == "2") {
      values = 'covid_death_age';
      this.chartTitle = 'Age breakdown of deceased patients with Confirmed or Suspected Covid 19';
      this.multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'Age Decile Band';
    } else if (this.dashboardNumber == "3") {
      values = 'covid_death_daily';
      this.chartTitle = 'Daily trend of deceased patients with Confirmed or Suspected Covid 19';
      this.showLineCharts = true;
      this.showBarCharts = false;
      this.showAreaChart = true;
    } else if (this.dashboardNumber == "4") {
      values = 'covid_death_ccg';
      this.chartTitle = 'CCG breakdown of deceased patients with Confirmed or Suspected Covid 19';
      this.multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'CCG';
    } else if (this.dashboardNumber == "10") {
      values = 'covid_shielding_ccg';
      this.chartTitle = 'Shielding groups by Age Bands';
      this.multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'Shielding Group';
    } else if (this.dashboardNumber == "11") {
      values = 'covid_death_ethnic';
      this.chartTitle = 'Ethnic/Age group breakdown of deceased patients with Confirmed or Suspected Covid 19';
      this.multiChart = false;
      this.chartName = values;
      this.gradient = false;
      this.showLineCharts = false;
      this.showBarCharts = true;
      this.xAxisLabel = 'Ethnic Group';
    }

    if (this.multiChart) {
      let cumulative = "0";
      if (this.cumulative) {
        cumulative = "1";
      }

      let weekly = "0";
      if (this.weekly) {
        weekly = "1";
      }

      this.explorerService.getDashboard(values, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), cumulative, this.selectedCCGString, weekly)
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
      this.explorerService.getDashboardSingle(values, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1, this.selectedCCGString)
        .subscribe(result => {
          this.chartResultsSingle = result.series;
        });
    }
  }

  loadList(lists: any) {
    lists.results.map(
      e => {
        this.ccgList.push(e.type);
      }
    )
    this.ccgValues = new FormControl(this.ccgList);

    this.route.queryParams
      .subscribe(params => {
        this.dashboardNumber = params['dashboardNumber'];

        if (this.dashboardNumber == "5") {
          this.seriesList = ['[D]Fever NOS', '[D]Cough'];
        } else if (this.dashboardNumber == "6") {
          this.seriesList = ['All consultations', 'Suspected coronavirus consultation'];
        } else if (this.dashboardNumber == "7") {
          this.seriesList = ['Home visit', 'Surgery face to face consultation', 'Telephone consultation', 'Video consultation', 'Email or Text message consultation'];
        } else if (this.dashboardNumber == "8") {
          this.seriesList = ['Hospital inpatient admission', 'Hospital day case discharge', 'A&E discharge/end visit', 'A&E transfer', 'A&E attendance', 'Hospital discharge'];
        } else if (this.dashboardNumber == "1") {
          this.seriesList = ['Suspected coronavirus infection', 'Confirmed Covid 19', 'Tested for coronavirus infection'];
        } else if (this.dashboardNumber == "9") {
          this.seriesList = ['Suspected coronavirus infection (Black)',
          'Suspected coronavirus infection (Not Stated)',
          'Confirmed Covid 19 (Not Stated)',
          'Suspected coronavirus infection (Other)',
          'Confirmed Covid 19 (White)',
          'Suspected coronavirus infection (White)',
          'Tested for coronavirus infection (White)',
          'Tested for coronavirus infection (Black)',
          'Confirmed Covid 19 (South Asian)',
          'Suspected coronavirus infection (South Asian)',
          'Tested for coronavirus infection (Not Stated)',
          'Confirmed Covid 19 (Other)',
          'Tested for coronavirus infection (Other)',
          'Confirmed Covid 19 (Black)',
          'Tested for coronavirus infection (South Asian)'];
        }

        this.seriesValues = new FormControl(this.seriesList);

      });

    this.refresh(false);

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
      height: '780px',
      width: '1600px',

      data: {chartName: chartName, seriesName: seriesName, ccgs: this.selectedCCGString}
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
    var csvData = '';
    if (this.multiChart)
      csvData = this.ConvertToCSVMulti(this.chartResults);
    else
      csvData = this.ConvertToCSVSingle(this.chartResultsSingle);

    let blob = new Blob([csvData], { type: 'text/csv' });
    let url= window.URL.createObjectURL(blob);
    window.open(url);
  }

  ConvertToCSVMulti(objArray) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = 'key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        for (let key2 in array[key].series) {
          if (array[key].series.hasOwnProperty(key2)) {
            let point = array[key].series[key2].name;
            if (point.toString().indexOf("GMT") > -1) { // date type of series
              point = this.formatDate(point);
            }
            csv += array[key].name+ ',' + point + ',' + array[key].series[key2].value + '\r\n';
          }
        }
      }
    }

    return csv;
  }

  ConvertToCSVSingle(objArray) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    console.log(array);
    let csv = 'key,point,count\r\n';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        let point = array[key].name;
        if (point.toString().indexOf("GMT") > -1) { // date type of series
          point = this.formatDate(point);
        }
        csv += this.chartName+ ',' + point + ',' + array[key].value + '\r\n';
      }
    }

    return csv;
  }

}
