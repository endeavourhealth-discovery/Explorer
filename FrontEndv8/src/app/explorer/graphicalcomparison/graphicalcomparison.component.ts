import {Component, OnInit} from '@angular/core';
import {LoggerService} from 'dds-angular8';
import {FormControl} from '@angular/forms';
import {ExplorerService} from "../explorer.service";
import {ReplaySubject, Subject} from "rxjs";
import {takeUntil} from "rxjs/operators";
import {ActivatedRoute} from "@angular/router";

interface orgList {
  value: string;
}

@Component({
  selector: 'app-graphicalcomparison',
  templateUrl: './graphicalcomparison.component.html',
  styleUrls: ['./graphicalcomparison.component.scss']
})

export class GraphicalComparisonComponent implements OnInit {
  filterCtrl: FormControl = new FormControl();
  filteredValueset: ReplaySubject<orgList[]> = new ReplaySubject<orgList[]>(1);

  view: any[] = [1800, 330];
  chartResults: any[];
  practices = new FormControl();
  practiceList: string[] = [];
  selectedPractices: any = [];
  ccgList: string[] = [];
  ccgValues = new FormControl(this.ccgList);
  selectedCCG: any = [];
  registryList = [];
  registries = new FormControl(this.registryList);
  selectedRegistries: string = '';

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
  showGridLines: boolean = true;
  gradient: boolean = false;
  orgs: string;

  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  private _onDestroy = new Subject<void>();

  ngOnInit() {
    this.explorerService.getLookupLists('17','')
        .subscribe(
            (result) => this.loadRegistryList(result),
            (error) => this.log.error(error)
        );
  }

  refresh() {
    let organisations = '';

    if (this.selectedPractices == '') {
      organisations = this.selectedCCG.toString();
    } else if (this.selectedCCG == '') {
      organisations = this.selectedPractices.toString();
    }

    console.log("refresh");
    this.explorerService.getDashboardRegistries(organisations, this.selectedRegistries.toString())
      .subscribe(result => {
        this.chartResults = result.results;
      });
  }

  loadRegistryList(lists: any) {
    lists.results.map(
        e => {
          this.registryList.push(e.type);
        }
    )

    this.filteredValueset.next(this.registryList.slice());

    this.filterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterRegistries();
      });

    this.registries = new FormControl(this.registryList);

    this.registries.reset(false);

    this.explorerService.getLookupLists('5','')
      .subscribe(
        (result) => this.loadCCGList(result),
        (error) => this.log.error(error)
      );
  }

  filterRegistries () {
    let search = this.filterCtrl.value;

    if (!search) {
      this.filteredValueset.next(this.registryList.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValueset.next(
      this.registryList.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  loadCCGList(lists: any) {
    lists.results.map(
      e => {
        this.ccgList.push(e.type);
      }
    )

    this.ccgValues = new FormControl(this.ccgList);

    this.ccgValues.reset(false);

    this.explorerService.getLookupLists('18','')
      .subscribe(
        (result) => this.loadPracticeList(result),
        (error) => this.log.error(error)
      );
  }

  loadPracticeList(lists: any) {
    lists.results.map(
      e => {
        this.practiceList.push(e.type);
      }
    )

    this.practices = new FormControl(this.practiceList);

    this.practices.reset(false);

    this.refresh();
  }

  onSelect(data): void {
    console.log('Item clicked', JSON.parse(JSON.stringify(data)));
  }
}
