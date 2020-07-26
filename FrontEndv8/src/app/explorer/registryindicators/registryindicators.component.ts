import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {FormControl} from "@angular/forms";
import {PatientComponent} from "../patient/patient.component";
import {MatDialog} from "@angular/material/dialog";

@Component({
  selector: 'app-registryindicators',
  templateUrl: './registryindicators.component.html',
  styleUrls: ['./registryindicators.component.scss']
})

export class RegistryIndicatorsComponent implements OnInit {
  registry: string = '';
  odscode: string = '';

  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;

  displayedColumns: string[] = ['ccg', 'practice', 'code', 'parentRegistry', 'listSize', 'registry', 'registrySize', 'percentage', 'updated'];

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
    this.explorerService.getRegistries(this.page, this.size, "", "", this.odscode, this.registry)
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

  toPercent(registrysize: any, listsize: any) {
    return (registrysize/listsize*100).toFixed(1);
  }

  back() {
    window.history.back();
  }

  showPatientDialog() {
    this.patientDialog("", "");
  }

  patientDialog(chartName: any, seriesName: any) {
    const dialogRef = this.dialog.open(PatientComponent, {
      height: '780px',
      width: '1600px',

      data: {chartName: "covid_shielding_ccg", seriesName: "high/moderate risk (50-59)", ccgs: "NHS Tower Hamlets CCG"}
    });

    dialogRef.afterClosed().subscribe(result => {
      let patientId = 0;
      if (result) {
        patientId = result;
        window.location.href = "https://devgateway.discoverydataservice.net/record-viewer/#/summary?patient_id="+patientId;
      }
    });
  }
}
