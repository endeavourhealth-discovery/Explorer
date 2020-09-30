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
  selector: 'app-organisationgroupseditor',
  templateUrl: './organisationgroupseditor.component.html',
  styleUrls: ['./organisationgroupseditor.component.scss']
})

export class OrganisationGroupsEditorComponent {
  type: string;
  name: string;
  disableForm: boolean;
  id: string;

  constructor(
    public dialogRef: MatDialogRef<OrganisationGroupsEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.type = data.type;
  }

  saveOrganisationGroup() {
    this.explorerService.saveOrganisationGroup(this.type, this.name, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This organisation group could not be saved.')
      );
  }

  organisationGroupEntered(event) {

    if (event.key === "Enter") {
      this.saveOrganisationGroup();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.name=='' || this.name==undefined;
  }

}
