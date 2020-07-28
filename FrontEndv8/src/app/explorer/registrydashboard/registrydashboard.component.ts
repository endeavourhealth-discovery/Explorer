import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";

@Component({
  selector: 'app-registrydashboard',
  templateUrl: './registrydashboard.component.html',
  styleUrls: ['./registrydashboard.component.scss']
})

export class RegistryDashboardComponent implements OnInit {

  registry: string = '';
  odscode: string = '';
  practice: string = '';
  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;
  displayedColumns: string[] = ['ccg', 'practice', 'code', 'parentRegistry', 'listSize', 'registry', 'registrySize', 'percentage', 'updated'];
  tiles: any[];

  constructor(
    private route: ActivatedRoute,
    private dialog: MatDialog,
    private explorerService: ExplorerService,
    private log: LoggerService) { }

  ngOnInit() {
    this.loadEvents();
  }

  loadEvents() {
    this.route.queryParams
      .subscribe(params => {
        this.registry = params['registry'];
        this.odscode = params['odscode'];
      });
    this.events = null;
    this.explorerService.getRegistries(this.page, this.size, "", "", this.odscode, this.registry, this.practice)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
    let registryCount = 0;
    this.tiles = [];
    events.results.map(
      e => {
        let tile = {
          "color": 'white',
          "border": '1px solid gainsboro',
          "cols": 1,
          "rows": 2,
          "text": e.registry
        }
        this.tiles.push(tile);
        registryCount = e.listSize;
      }
    )
      let tile = {
        "color": 'white',
        "border": '1px solid gainsboro',
        "cols": 1,
        "rows": 2,
        "text": "Patients with Diabetes" + registryCount
      }
      this.tiles.push(tile);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
  }

  gaugeLabel(value: number) {
    return value+" %";
  }

}
