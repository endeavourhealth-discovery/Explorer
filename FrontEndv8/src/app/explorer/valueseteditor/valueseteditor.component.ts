import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";

export interface DialogData {
}

@Component({
  selector: 'app-valueseteditor',
  templateUrl: './valueseteditor.component.html',
  styleUrls: ['./valueseteditor.component.scss']
})

export class ValueSetEditorComponent {
  type: string;
  name: string;
  disableForm: boolean;

  constructor(
    public dialogRef: MatDialogRef<ValueSetEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
  }

  saveValueSet() {
    this.explorerService.saveValueSet(this.type, this.name)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set could not be saved.')
      );
  }

  valuesetEntered(event) {
    if (event.key === "Enter") {
      this.saveValueSet();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined;
  }

}
