import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";

export interface DialogData {
  dashboardId: string;
  name: string;
  type: string;
}

@Component({
  selector: 'app-dashboardeditor',
  templateUrl: './dashboardeditor.component.html',
  styleUrls: ['./dashboardeditor.component.scss']
})

export class DashboardEditorComponent {
  type: string;
  name: string;
  disableForm: boolean;
  dashboardId: string;

  constructor(
    public dialogRef: MatDialogRef<DashboardEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.dashboardId = data.dashboardId;
    this.name = data.name;
    this.type = data.type;
  }

  saveDashboard() {
    this.explorerService.saveDashboard(this.type, this.name, this.dashboardId)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This dashboard could not be saved.')
      );
  }

  dashboardEntered(event) {

    if (event.key === "Enter") {
      this.saveDashboard();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined;
  }

}
