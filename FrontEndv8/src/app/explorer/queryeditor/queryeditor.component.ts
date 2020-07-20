import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";

export interface DialogData {
  id: string;
  name: string;
  type: string;
}

@Component({
  selector: 'app-queryeditor',
  templateUrl: './queryeditor.component.html',
  styleUrls: ['./queryeditor.component.scss']
})

export class QueryEditorComponent {
  type: string;
  name: string;
  disableForm: boolean;
  id: string;

  constructor(
    public dialogRef: MatDialogRef<QueryEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.type = data.type;
  }

  saveQuery() {
    this.explorerService.saveQuery(this.type, this.name, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This query could not be saved.')
      );
  }

  queryEntered(event) {

    if (event.key === "Enter") {
      this.saveQuery();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined;
  }

}
