import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";

export interface DialogData {
  type: string;
  code: string;
  term: string;
  snomed: string;
  id: string;
  value: string;
}

@Component({
  selector: 'app-valueseteditor',
  templateUrl: './valueeditor.component.html',
  styleUrls: ['./valueeditor.component.scss']
})

export class ValueEditorComponent {
  type: string;
  code: string;
  term: string;
  snomed: string;
  disableForm: boolean;
  id: string;
  value: string;

  constructor(
    public dialogRef: MatDialogRef<ValueEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.type = data.type;
    this.code = data.code;
    this.term = data.term;
    this.snomed = data.snomed;
    this.id = data.id;
    this.value = data.value;
  }

  saveValue() {
    this.explorerService.saveValue(this.type, this.code, this.term, this.snomed, this.value, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set could not be saved.')
      );
  }

  valueEntered(event) {

    if (event.key === "Enter") {
      this.saveValue();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.code=='' || this.code==undefined || this.term=='' || this.term==undefined || this.snomed=='' || this.snomed==undefined;
  }

}
