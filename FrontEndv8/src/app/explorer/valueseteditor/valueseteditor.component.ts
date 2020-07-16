import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';

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


  constructor(
    public dialogRef: MatDialogRef<ValueSetEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
  }

  saveValueSet() {
    console.log("SaveValueSet");
    this.explorerService.saveValueSet(this.type, this.name)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set could not be saved.')
      );
  }

  valuesetEntered(event) {
    if (event.key === "Enter") {
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }


}
