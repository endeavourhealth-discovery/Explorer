import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {LoggerService} from 'dds-angular8';
import {FormControl} from '@angular/forms';
import {ExplorerService} from "../explorer.service";
import {ReplaySubject, Subject} from "rxjs";
import {takeUntil} from "rxjs/operators";

export interface DialogData {
  orgs: string;
}

interface orgList {
  value: string;
}

@Component({
  selector: 'app-trend',
  templateUrl: './trend.component.html',
  styleUrls: ['./trend.component.scss']
})

export class TrendComponent {
  filterCtrl: FormControl = new FormControl();
  filteredValueset: ReplaySubject<orgList[]> = new ReplaySubject<orgList[]>(1);

  view: any[] = [650, 330];
  view2: any[] = [650, 330];
  chartResults: any[];
  chartResultsSingle: any[];
  dateFrom: string = '2020-01-01';
  dateTo: string = this.formatDate(new Date());
  showLineCharts: boolean = true;
  showBarCharts: boolean = true;
  organisations = new FormControl();
  orgList: string[] = [];
  selectedOrganisation: string = '';
  months: string[] = [];
  weekly: boolean = false;
  indicatorList = [];
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

  private _onDestroy = new Subject<void>();

  ngOnInit() {
    this.showLineCharts = true;

    this.explorerService.getLookupLists('7','')
        .subscribe(
            (result) => this.loadList(result),
            (error) => this.log.error(error)
        );
  }

  refresh() {
    this.orgList = this.orgs.split(',');
    let weekly = "0";
    let cumulative = "0";
    let organisation: string;
    let indicator: string;

    if (this.weekly) {
      weekly = "1";
    }

    if (this.selectedOrganisation=="" || this.selectedIndicator=="")
      return;

    organisation = this.selectedOrganisation;
    indicator = this.selectedIndicator;

    let orgs = organisation.toString().split(',');
    let ind = indicator.toString().split(',');

    let names = '';
    for(var i = 0; i < orgs.length; i++)
    {
      for(var j = 0; j < ind.length; j++)
      {
        names += ',' + orgs[i] + ' - '+ind[j];
      }
    }
    names = names.substr(1);

    this.explorerService.getDashboard('Registry trends', names, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), cumulative, 'registry_trend', weekly, '0', '0')
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
      this.explorerService.getDashboardSingle('Registry trends', indicator, this.formatDate(this.dateFrom), this.formatDate(this.dateTo), 1, 'registry_latest')
        .subscribe(result => {
          this.chartResultsSingle = result.series;
        });
    }

  }

  loadList(lists: any) {
    lists.results.map(
        e => {
          this.indicatorList.push(e.type);
        }
    )

    this.filteredValueset.next(this.indicatorList.slice());

    this.filterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterIndicatorset();
      });

    this.indicators = new FormControl(this.indicatorList);

    this.indicators.reset(false);

    this.refresh();
  }

  filterIndicatorset() {
    let search = this.filterCtrl.value;

    if (!search) {
      this.filteredValueset.next(this.indicatorList.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValueset.next(
      this.indicatorList.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
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
