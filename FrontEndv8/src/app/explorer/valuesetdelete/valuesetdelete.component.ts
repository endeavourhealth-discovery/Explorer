import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';

export interface DialogData {
  id: string;
}

@Component({
  selector: 'app-valuesetdelete',
  templateUrl: './valuesetdelete.component.html',
  styleUrls: ['./valuesetdelete.component.scss']
})

export class ValueSetDeleteComponent {
  type: string;
  name: string;
  id: string = "";

  constructor(
    public dialogRef: MatDialogRef<ValueSetDeleteComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.id = data.id;
  }

  deleteValueSet() {
    this.explorerService.deleteValueSet(this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set could not be deleted.')
      );
  }

  deleteEntered(event) {
    if (event.key === "Enter") {
      this.deleteValueSet();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

}
