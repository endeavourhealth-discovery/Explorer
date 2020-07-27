import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";

@Component({
  selector: 'app-registries',
  templateUrl: './registries.component.html',
  styleUrls: ['./registries.component.scss']
})

export class RegistriesComponent implements OnInit {
  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;

  displayedColumns: string[] = ['ccg', 'practice', 'code', 'listSize', 'registry', 'registrySize', 'percentage', 'updated'];

  selectedCCG: string = '';
  selectedCCGString: string = '';
  selectAllCCG: boolean = true;
  ccgList = [];
  ccgValues = new FormControl(this.ccgList);

  selectedRegistry: string = '';
  selectedRegistryString: string = '';
  selectAllRegistry: boolean = true;
  registryList = [];
  registryValues = new FormControl(this.registryList);

  practice: string = '';

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  ngOnInit() {
    this.explorerService.getLookupLists('5')
      .subscribe(
        (result) => this.loadListCCG(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelectionCCG(event) {
    if (event.checked) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    } else {
      this.ccgValues = new FormControl([]);
      this.selectedCCGString = "";
    }
    this.refresh(false);
  }

  toggleSelectionRegistry(event) {
    if (event.checked) {
      this.registryValues = new FormControl(this.registryList);
      this.selectedRegistryString = this.registryList.toString();
    } else {
      this.registryValues = new FormControl([]);
      this.selectedRegistryString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedCCG=="" && this.selectAllCCG) {
      this.ccgValues = new FormControl(this.ccgList);
      this.selectedCCGString = this.ccgList.toString();
    }

    if (override) {
      this.selectAllCCG = false;
      this.selectedCCGString = this.selectedCCG.toString();
    }

    if (this.selectedRegistry=="" && this.selectAllRegistry) {
      this.registryValues = new FormControl(this.registryList);
      this.selectedRegistryString = this.registryList.toString();
    }

    if (override) {
      this.selectAllRegistry = false;
      this.selectedRegistryString = this.selectedRegistry.toString();
    }

    this.loadEvents();
  }

  refreshCCG() {
    this.selectAllCCG = false;
    this.selectedCCGString = this.selectedCCG.toString();

    this.explorerService.getLookupLists('6')
      .subscribe(
        (result) => this.loadListRegistry(result),
        (error) => this.log.error(error)
      );
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getRegistries(this.page, this.size, this.selectedCCGString, this.selectedRegistryString, '', '', this.practice)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  loadListCCG(lists: any) {
    this.ccgList = [];

    lists.results.map(
      e => {
        this.ccgList.push(e.type);
      }
    )
    this.ccgValues = new FormControl(this.ccgList);

    this.explorerService.getLookupLists('6')
      .subscribe(
        (result) => this.loadListRegistry(result),
        (error) => this.log.error(error)
      );
  }

  loadListRegistry(lists: any) {
    this.registryList = [];

    lists.results.map(
      e => {
        this.registryList.push(e.type);
      }
    )
    this.registryValues = new FormControl(this.registryList);

    this.refresh(false);
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
  }

  toPercent(registrysize: any, listsize: any) {
    return (registrysize/listsize*100).toFixed(1);
  }

  practiceEntered(event) {
    if (event.key === "Enter") {
      this.loadEvents();
    }
  }
}
