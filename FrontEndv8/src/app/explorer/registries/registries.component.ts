import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";

@Component({
  selector: 'app-querylibrary',
  templateUrl: './registries.component.html',
  styleUrls: ['./registries.component.scss']
})

export class RegistriesComponent implements OnInit {


  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;

  displayedColumns: string[] = ['name', 'code', 'list', 'registry', 'percentage', 'updated'];

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;

  typeList = [];
  typeValues = new FormControl(this.typeList);

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  ngOnInit() {
    this.explorerService.getLookupLists('2')
      .subscribe(
        (result) => this.loadList(result),
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

  loadEvents() {
    this.events = null;
    this.explorerService.getRegistry(this.page, this.size, this.selectedTypeString)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
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
