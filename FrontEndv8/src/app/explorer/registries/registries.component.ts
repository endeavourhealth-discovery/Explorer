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

  selectAll: boolean = true;

  selectedType: string = '';
  selectedTypeString: string = '';
  typeList = [];
  typeValues = new FormControl(this.typeList);

  selectedPractice: string = '';
  selectedPracticeString: string = '';
  practiceList = [];
  practiceValues = new FormControl(this.practiceList);

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  ngOnInit() {
    this.explorerService.getLookupLists('5')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );

    this.explorerService.getLookupLists('6')
      .subscribe(
        (result) => this.loadListPractice(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelection(event) {
    if (event.checked) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    } else {
      this.typeValues = new FormControl([]);
      this.selectedTypeString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedType=="" && this.selectAll) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    }

    if (override) {
      this.selectAll = false;
      this.selectedTypeString = this.selectedType.toString();
    }
    this.loadEvents();
  }

  loadList(lists: any) {
    this.typeList = [];
    this.typeValues = new FormControl(this.typeList);
    lists.results.map(
      e => {
        this.typeList.push(e.type);
      }
    )
    this.typeValues = new FormControl(this.typeList);
    this.refresh(false);
  }


  toggleSelectionPractice(event) {
    if (event.checked) {
      this.practiceValues = new FormControl(this.practiceList);
      this.selectedPracticeString = this.practiceList.toString();
    } else {
      this.practiceValues = new FormControl([]);
      this.selectedPracticeString = "";
    }
    this.refresh(false);
  }

  refreshPractice(override) {
    if (this.selectedPractice=="" && this.selectAll) {
      this.practiceValues = new FormControl(this.practiceList);
      this.selectedPracticeString = this.practiceList.toString();
    }

    if (override) {
      this.selectAll = false;
      this.selectedPracticeString = this.selectedPractice.toString();
    }
    this.loadEvents();
  }

  loadListPractice(lists: any) {
    this.practiceList = [];
    this.practiceValues = new FormControl(this.practiceList);
    lists.results.map(
      e => {
        this.practiceList.push(e.type);
      }
    )
    this.practiceValues = new FormControl(this.practiceList);
    this.refresh(false);
  }


  loadEvents() {
    this.events = null;
    this.explorerService.getRegistries(this.page, this.size, this.selectedTypeString, this.selectedPracticeString)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
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

}
