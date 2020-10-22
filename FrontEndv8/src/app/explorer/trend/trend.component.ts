import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {LoggerService} from 'dds-angular8';
import {FormControl} from '@angular/forms';
import {ExplorerService} from "../explorer.service";

export interface DialogData {
  orgs: string;
}

@Component({
  selector: 'app-trend',
  templateUrl: './trend.component.html',
  styleUrls: ['./trend.component.scss']
})

export class TrendComponent {
  view: any[] = [850, 400];
  view2: any[] = [400, 200];
  chartResults: any[];
  chartResultsSingle1: any[];
  chartResultsSingle2: any[];
  dateFrom: string = '2020-01-01';
  dateTo: string = this.formatDate(new Date());
  showLineCharts: boolean = true;
  showBarCharts: boolean = true;
  organisations = new FormControl();
  orgList: string[] = [''];
  selectedOrganisation: string = '';
  months: string[] = [''];
  weekly: boolean = false;
  indicatorList: string[] = [''];
  indicators = new FormControl(this.indicatorList);
  selectedIndicator: string = '';

  // options
  legend: boolean = true;
  legendPosition: string = 'bottom';
  animations: boolean = true;
  xAxis: boolean = true;
  yAxis: boolean = true;
  showYAxisLabel: boolean = true;
  showXAxisLabel: boolean = false;
  xAxisLabel: string = 'Date';
  yAxisLabel: string = 'Percentage';
  timeline: boolean = false;
  showGridLines: boolean = true;
  showAreaChart: boolean = false;
  gradient: boolean = true;
  logarithmic: boolean = false;

  orgs: string;

  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };

  constructor(
    public dialogRef: MatDialogRef<TrendComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.orgs = data.orgs;

  }

  ngOnInit() {
    this.showLineCharts = true;

    this.explorerService.getLookupLists('7')
        .subscribe(
            (result) => this.loadList(result),
            (error) => this.log.error(error)
        );
  }

  refresh() {
    this.orgList = this.orgs.split(',');
    let weekly = "0";
    let cumulative = "0";
    let values: string;
    let indicators: string;

    if (this.weekly) {
      weekly = "1";
    }

    if (this.selectedOrganisation == "") {
      values = this.orgList.toString();
    } else {
      values = this.selectedOrganisation;
    }

    if (this.selectedIndicator == "") {
      indicators = this.indicatorList.toString();
    } else {
      indicators = this.selectedIndicator;
    }

    let orgs = values.split(',');
    let ind = indicators.split(',');
    let names = '';
    for(var i = 0; i < orgs.length; i++)
    {
      for(var j = 0; j < ind.length; j++)
      {
        names += ',' + orgs[i] + ' - '+ind[j];
      }
    }
    names = names.substr(1);

    this.explorerService.getDashboard(names, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), cumulative, 'Registries', weekly)
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

    if (this.showBarCharts) {
      this.explorerService.getDashboardSingle('Diabetes - BP 140/80 or less', this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1, 'Registries')
        .subscribe(result => {
          this.chartResultsSingle1 = result.series;
        });
    }

    if (this.showBarCharts) {
      this.explorerService.getDashboardSingle('Diabetes - Foot examination', this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1, 'Registries')
        .subscribe(result => {
          this.chartResultsSingle2 = result.series;
        });
    }
  }

  loadList(lists: any) {
    lists.results.map(
        e => {
          this.indicatorList.push(e.type);
        }
    )
    this.indicators = new FormControl(this.indicatorList);

    this.refresh();
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

  onSelect(data): void {
    console.log('Item clicked', JSON.parse(JSON.stringify(data)));
  }

  onSelectBar(data): void {
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

  onCancelClick(): void {
    this.dialogRef.close();
  }
}
