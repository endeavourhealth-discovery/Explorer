import {Component, Inject, OnInit} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {MatTableDataSource} from "@angular/material/table";
import {PageEvent} from "@angular/material/paginator";


export interface DialogData {
  legendName: string;
  seriesName: string;
}

@Component({
  selector: 'app-patient',
  templateUrl: './patient.component.html',
  styleUrls: ['./patient.component.scss']
})

export class PatientComponent {
  events: any[] = [];
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 10;
  name: string = "";
  legendName: string = "";
  seriesName: string = "";

  displayedColumns: string[] = ['name/address', 'dob/nhsNumber', 'age/gender', 'usual_gp/organisation', 'registration'];

  constructor(
    public dialogRef: MatDialogRef<PatientComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {

    this.events = [
      {id: "0", name: "no results"},{id: "0", name: "no results"},
      {id: "0", name: "no results"},{id: "0", name: "no results"},
      {id: "0", name: "no results"},{id: "0", name: "no results"},
      {id: "0", name: "no results"},{id: "0", name: "no results"},
      {id: "0", name: "no results"},{id: "0", name: "no results"}
    ];
    this.dataSource = new MatTableDataSource(this.events);
    this.legendName = data.legendName;
    this.seriesName = data.seriesName;
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getPatients(this.page, this.size, this.name, this.legendName, this.seriesName)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );
  }

  patientEntered(event) {
    if (event.key === "Enter") {
      this.loadEvents();
    }
  }

  displayEvents(events: any) {
    console.log(events);
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }


}
