import {AfterViewInit, Component, Injectable, OnInit, Output, ViewEncapsulation} from '@angular/core';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from '@angular/forms';
import {MatDialog} from "@angular/material/dialog";
import {PatientComponent} from "../patient/patient.component";
import {Globals} from '../globals'
import {ngxCsv} from "ngx-csv";
import {BehaviorSubject, Observable} from "rxjs";
import {MatTreeFlatDataSource, MatTreeFlattener} from "@angular/material/tree";
import {FlatTreeControl} from "@angular/cdk/tree";
import {SelectionModel} from "@angular/cdk/collections";

interface widget {
  icon: string;
  name: string;
}

interface dashboardQuery {
  selectedVisualisation1: string;
  xAxisLabel1: string;
  yAxisLabel1: string;
  visualType: widget[];
}

export class OrgItemNode {
  children: OrgItemNode[];
  item: string;
}

export class OrgItemFlatNode {
  item: string;
  level: number;
  expandable: boolean;
}

@Injectable()
export class ChecklistDatabase {
  dataChange = new BehaviorSubject<OrgItemNode[]>([]);

  get data(): OrgItemNode[] { return this.dataChange.value; }

  constructor(private explorerService: ExplorerService,
    private log: LoggerService) {

    this.initialize();
  }

  initialize() {
    this.explorerService.getOrganisationTree()
      .subscribe(
        (result) => this.loadOrgTree(result),
        (error) => this.log.error(error)
      );

  }

  loadOrgTree(orgs: any) {
    const data = this.buildFileTree(orgs, 0);

    this.dataChange.next(data);
  }

  buildFileTree(obj: {[key: string]: any}, level: number): OrgItemNode[] {
    return Object.keys(obj).reduce<OrgItemNode[]>((accumulator, key) => {
      const value = obj[key];
      const node = new OrgItemNode();
      node.item = key;

      if (value != null) {
        if (typeof value === 'object') {
          node.children = this.buildFileTree(value, level + 1);
        } else {
          node.item = value;
        }
      }

      return accumulator.concat(node);
    }, []);
  }

}

@Component({
  selector: 'app-covidviewer',
  templateUrl: './covidviewer.component.html',
  styleUrls: ['./covidviewer.component.scss'],
  providers: [ChecklistDatabase],
  encapsulation: ViewEncapsulation.None
})

export class CovidViewerComponent implements OnInit {
  globals: Globals;
  name: string = "";
  combineSeries1: boolean = false;
  combineEthnic1: boolean = true;
  combineAge1: boolean = true;
  combineSex1: boolean = true;
  combineOrgs: boolean = false;
  selectAllEthnic1: boolean = true;
  selectAllSeries1: boolean = true;
  selectAllAge1: boolean = true;
  selectAllSex1: boolean = true;
  view1: any[] = [1250, 620];
  chartResults1: any[];
  chartResultsSingle1: any[];
  dateFrom1: string = '2020-01-01';
  dateTo1: string = this.formatDate(new Date());
  dashboardId: string;
  seriesValues1 = new FormControl();
  seriesList1: string = '';
  selectedethnic1: any = [];
  selectedage1: any = [];
  selectedsex1: any = [];
  chartName: string = "";
  showWait: boolean = false;
  showCharts: boolean = false;

  // options
  legend: boolean = true;
  legendPosition: string = 'right';
  animations: boolean = true;
  xAxis: boolean = true;
  yAxis: boolean = true;
  showYAxisLabel: boolean = true;
  showXAxisLabel: boolean = true;
  chartTitle1: string = "Chart Title";
  xAxisLabel1: string = 'Date';
  yAxisLabel1: string = 'People with indicator';
  yAxisLabel: string;
  chartSelections1: string = '';
  chartSelections2: string = '';
  chartSelections3: string = '';
  chartSelections4: string = '';
  timeline: boolean = true;
  showAreaChart1: boolean = false;
  gradient1: boolean = false;
  showRefLines1: boolean = false;
  logarithmic1: boolean = false;
  cumulative1: boolean = false;
  weekly1: boolean = false;
  rate1: boolean = false;
  refLines1 = [{value: 1, name: 'Minimum'}, {value: 2, name: 'Average'}, {value: 3, name: 'Maximum'}];
  ethnicList1 = [];
  ethnicValues1 = new FormControl(this.ethnicList1);
  ageList1 = [];
  ageValues1 = new FormControl(this.ageList1);
  sexList1 = [];
  sexValues1 = new FormControl(this.sexList1);
  colorScheme = {
    domain: ["#3366cc","#dc3912","#ff9900","#109618","#990099","#0099c6","#dd4477","#66aa00","#b82e2e","#316395","#3366cc",
      "#994499","#22aa99","#aaaa11","#6633cc","#e67300","#8b0707","#651067","#329262",
      "#5574a6","#3b3eac","#b77322","#16d620","#b91383","#f4359e","#9c5935","#a9c413","#2a778d","#668d1c","#bea413","#0c5922","#743411"]
  };

  selectedSeries1: any = [];
  selectedWidgets : widget[] = [
  ];

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog,
    private _database: ChecklistDatabase,
    globals: Globals) {

    this.globals = globals;

    this.treeFlattener = new MatTreeFlattener(this.transformer, this.getLevel,
      this.isExpandable, this.getChildren);
    this.treeControl = new FlatTreeControl<OrgItemFlatNode>(this.getLevel, this.isExpandable);
    this.dataSource = new MatTreeFlatDataSource(this.treeControl, this.treeFlattener);

    _database.dataChange.subscribe(data => {
      this.dataSource.data = data;
    });
  }

  ngOnInit() {
    this.ethnicValues1 = new FormControl(this.ethnicList1);
    this.selectedethnic1 = this.ethnicList1;

    this.explorerService.getLookupLists('19','')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleEthnicSelection1(event) {
    if (event.checked) {
      this.ethnicValues1 = new FormControl(this.ethnicList1);
      this.selectedethnic1 = this.ethnicList1;
    } else {
      this.ethnicValues1 = new FormControl([]);
      this.selectedethnic1 = "";
    }

  }

  toggleAgeSelection1(event) {
    if (event.checked) {
      this.ageValues1 = new FormControl(this.ageList1);
      this.selectedage1 = this.ageList1;
    } else {
      this.ageValues1 = new FormControl([]);
      this.selectedage1 = "";
    }

  }

  toggleSexSelection1(event) {
    if (event.checked) {
      this.sexValues1 = new FormControl(this.sexList1);
      this.selectedsex1 = this.sexList1;
    } else {
      this.sexValues1 = new FormControl([]);
      this.selectedsex1 = "";
    }

  }

  toggleSeriesSelection1(event) {
    if (event.checked) {
      this.seriesValues1 = new FormControl(this.seriesList1);
      this.selectedSeries1 = this.seriesList1;
    } else {
      this.seriesValues1 = new FormControl([]);
      this.selectedSeries1 = "";
    }

  }

  refreshDashboard() {
    let series = this.selectedSeries1.toString();

    let stp = "";
    let ccg = "";
    let pcn = "";
    let practice = "";

    this.checklistSelection.selected.map(
      e => {
        if (e.level==0)
          stp += ','+e.item;
        else if (e.level==1)
          ccg += ','+e.item;
        else if (e.level==2)
          pcn += ','+e.item;
        else if (e.level==3)
          practice += ','+e.item;
      }
    )

    stp = stp.replace(',', '');
    ccg = ccg.replace(',', '');
    pcn = pcn.replace(',', '');
    practice = practice.replace(',', '');

    if (stp!="") {
      ccg = "";
      pcn = "";
      practice = "";
    }
    if (ccg!="") {
      pcn = "";
      practice = "";
    }
    if (pcn!="") {
      practice = "";
    }

    if (series==''||(stp==''&&ccg==''&&pcn==''&&practice==''))
      return;

    let ethnic = this.selectedethnic1.toString();
    let age = this.selectedage1.toString();
    let sex = this.selectedsex1.toString();

    if (this.selectAllEthnic1)
      ethnic = 'All';
    if (this.selectAllAge1)
      age = 'All';
    if (this.selectAllSex1)
      sex = 'All';

    let cumulative = "0";
    if (this.cumulative1) {
      cumulative = "1";
    }
    let weekly = "0";
    if (this.weekly1) {
      weekly = "1";
    }

    let rate = "0";
    if (this.rate1) {
      rate = "1";
    }

    this.showWait = true;
    this.showCharts = false;

    let cumulativeText = '';
    if (cumulative=="1")
      cumulativeText+='cumulative ';

    if (weekly=="1") {
      this.chartSelections1='Weekly '+cumulativeText+'trend'
    }
    else {
      this.chartSelections1='Daily '+cumulativeText+'trend'
    }

    if (rate == '1') {
      this.yAxisLabel1 = 'Rate per 100,000 patients';
    } else
      this.yAxisLabel1 = this.yAxisLabel;

    this.xAxisLabel1 = this.chartSelections1;
    this.chartSelections2 = ' of '+series;
    this.chartSelections3 = ' in '+stp+ccg+pcn+practice;
    this.chartSelections4 = '';

    if (ethnic!='All')
      this.chartSelections4 += ' filtered by '+ethnic+' ethnic groups';
    if (age!='All')
      this.chartSelections4 += ' filtered by '+age+' age groups';
    if (sex!='All')
      this.chartSelections4 += ' filtered by '+sex+' genders';

    let re = /\,/gi;

    this.chartSelections2 = this.chartSelections2.replace(re, ", ");
    this.chartSelections3 = this.chartSelections3.replace(re, ", ");
    this.chartSelections4 = this.chartSelections4.replace(re, ", ");

    this.explorerService.getDashboardCovid(this.dashboardId, series, this.formatDate(this.dateFrom1), this.formatDate(this.dateTo1), stp, ccg, pcn, practice, ethnic, age, sex, cumulative, weekly, rate, this.combineSeries1, this.combineEthnic1, this.combineAge1, this.combineSex1, this.combineOrgs)
      .subscribe(result => {

        this.showWait = false;
        this.showCharts = true;

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

  loadList(lists: any) {
    lists.results.map(
      e => {
        this.ethnicList1.push(e.type);
      }
    )
    this.ethnicValues1 = new FormControl(this.ethnicList1);

    this.ageValues1 = new FormControl(this.ageList1);
    this.selectedage1 = this.ageList1;

    this.explorerService.getLookupLists('20','')
      .subscribe(
        (result) => this.loadList2(result),
        (error) => this.log.error(error)
      );

  }

  loadList2(lists: any) {
    lists.results.map(
      e => {
        this.ageList1.push(e.type);
      }
    )
    this.ageValues1 = new FormControl(this.ageList1);

    this.sexValues1 = new FormControl(this.sexList1);
    this.selectedsex1 = this.sexList1;

    this.explorerService.getLookupLists('21','')
      .subscribe(
        (result) => this.loadList3(result),
        (error) => this.log.error(error)
      );
  }

  loadList3(lists: any) {
    lists.results.map(
      e => {
        this.sexList1.push(e.type);
      }
    )
    this.sexValues1 = new FormControl(this.sexList1);

   this.getDashboardData();
  }

  getDashboardData() {
    this.route.queryParams
      .subscribe(params => {
        this.dashboardId = params['dashboardNumber'];

        this.explorerService.getCovidView(this.dashboardId)
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

        this.chartTitle1 = query.selectedVisualisation1;
        this.xAxisLabel1 = query.xAxisLabel1;
        this.yAxisLabel = query.yAxisLabel1;
        this.selectedWidgets = query.visualType;

        this.loadSeries();
      }
    )

  }

  loadSeries() {
     this.explorerService.getSeriesFromDashboardId(this.dashboardId)
        .subscribe(
          (result) => this.loadSeriesFilter(result),
          (error) => this.log.error(error)
        );
  }

  loadSeriesFilter(result: any) {
    let seriesMap = [];
    result.results.map(
      e => {
        seriesMap.push(e.name);
      }
    )

    this.selectedSeries1 = seriesMap;
    this.seriesList1 = this.selectedSeries1;
    this.seriesValues1 = new FormControl(this.seriesList1);

  }

  formatTooltipYAxis1(val: number) {
    if (this.logarithmic1 == true) {
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

  formatXAxis(date) {
    var d = new Date(date),
      month = '' + (d.getMonth()),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (day.length < 2)
      day = '0' + day;

    let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var monthName = months[(Number(month))];

    return [day, monthName, year].join('-');
  }

  onSelectLine1(data): void {
    // this.patientDialog(data.series, data.name, this.selectOrg);
  }

  onSelectBar1(data): void {
    // this.patientDialog(this.selectedSeries1, data.name, this.selectOrg);
  }

  patientDialog(chartName: any, seriesName: any, ccgs: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      disableClose: true,
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
    csvData = this.ConvertToCSVMulti(this.chartResults1);

    let exportData = this.csvJSON(csvData);

    if (exportData) {
      let options = {
        fieldSeparator: ',',
        quoteStrings: '"',
        decimalseparator: '.',
        showLabels: true,
        headers: ['key','point','count'],
        showTitle: false,
        title: '`````dashboard`````',
        useTextFile: false,
        useBom: false,
      };
      new ngxCsv(exportData, 'dashboard', options);
    }
  }

  csvJSON(csv){
    var lines=csv.split("\n");

    var result = [];

    var headers=lines[0].split(",");

    headers = ["key","point","count"];

    for(var i=0;i<lines.length-1;i++){

      var obj = {};
      var currentline=lines[i].split(",");

      for(var j=0;j<headers.length;j++){
        obj[headers[j]] = currentline[j];
      }

      result.push(obj);

    }
    return result;
  }

  ConvertToCSVMulti(objArray) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let csv = '';
    for (let key in array) {
      if (array.hasOwnProperty(key)) {
        for (let key2 in array[key].series) {
          if (array[key].series.hasOwnProperty(key2)) {
            let point = array[key].series[key2].name;
            if (point.toString().indexOf("GMT") > -1) { // date type of series
              point = this.formatDate(point);
            }
            csv += array[key].name+ ',' + point + ',' + array[key].series[key2].value + '\n';
          }
        }
      }
    }
    return csv;
  }

  flatNodeMap = new Map<OrgItemFlatNode, OrgItemNode>();

  nestedNodeMap = new Map<OrgItemNode, OrgItemFlatNode>();

  selectedParent: OrgItemFlatNode | null = null;

  treeControl: FlatTreeControl<OrgItemFlatNode>;

  treeFlattener: MatTreeFlattener<OrgItemNode, OrgItemFlatNode>;

  dataSource: MatTreeFlatDataSource<OrgItemNode, OrgItemFlatNode>;

  checklistSelection = new SelectionModel<OrgItemFlatNode>(true /* multiple */);

  getLevel = (node: OrgItemFlatNode) => node.level;

  isExpandable = (node: OrgItemFlatNode) => node.expandable;

  getChildren = (node: OrgItemNode): OrgItemNode[] => node.children;

  hasChild = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.expandable;

  hasNoContent = (_: number, _nodeData: OrgItemFlatNode) => _nodeData.item === '';

  transformer = (node: OrgItemNode, level: number) => {
    const existingNode = this.nestedNodeMap.get(node);
    const flatNode = existingNode && existingNode.item === node.item
      ? existingNode
      : new OrgItemFlatNode();
    flatNode.item = node.item;
    flatNode.level = level;
    if (node.children!=undefined)
      flatNode.expandable = node.children.length>0;
    this.flatNodeMap.set(flatNode, node);
    this.nestedNodeMap.set(node, flatNode);
    return flatNode;
  }

  descendantsAllSelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    return descAllSelected;
  }

  descendantsPartiallySelected(node: OrgItemFlatNode): boolean {
    const descendants = this.treeControl.getDescendants(node);
    const result = descendants.some(child => this.checklistSelection.isSelected(child));
    return result && !this.descendantsAllSelected(node);
  }

  OrgItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    const descendants = this.treeControl.getDescendants(node);
    this.checklistSelection.isSelected(node)
      ? this.checklistSelection.select(...descendants)
      : this.checklistSelection.deselect(...descendants);

    descendants.forEach(child => this.checklistSelection.isSelected(child));
    this.checkAllParentsSelection(node);

  }

  OrgLeafItemSelectionToggle(node: OrgItemFlatNode): void {
    this.checklistSelection.toggle(node);
    this.checkAllParentsSelection(node);

  }

  checkAllParentsSelection(node: OrgItemFlatNode): void {
    let parent: OrgItemFlatNode | null = this.getParentNode(node);
    while (parent) {
      this.checkRootNodeSelection(parent);
      parent = this.getParentNode(parent);
    }
  }

  checkRootNodeSelection(node: OrgItemFlatNode): void {
    const nodeSelected = this.checklistSelection.isSelected(node);
    const descendants = this.treeControl.getDescendants(node);
    const descAllSelected = descendants.length > 0 && descendants.every(child => {
      return this.checklistSelection.isSelected(child);
    });
    if (nodeSelected && !descAllSelected) {
      this.checklistSelection.deselect(node);
    } else if (!nodeSelected && descAllSelected) {
      //this.checklistSelection.select(node);
    }
  }

  getParentNode(node: OrgItemFlatNode): OrgItemFlatNode | null {
    const currentLevel = this.getLevel(node);

    if (currentLevel < 1) {
      return null;
    }

    const startIndex = this.treeControl.dataNodes.indexOf(node) - 1;

    for (let i = startIndex; i >= 0; i--) {
      const currentNode = this.treeControl.dataNodes[i];

      if (this.getLevel(currentNode) < currentLevel) {
        return currentNode;
      }
    }
    return null;
  }
}
