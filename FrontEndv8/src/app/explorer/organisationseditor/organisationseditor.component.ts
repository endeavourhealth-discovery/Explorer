import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';

export interface DialogData {
  name: string;
  type: string;
  code: string;
  id: string;
  organisation_group_id: string;
}

@Component({
  selector: 'app-organisationeditor',
  templateUrl: './organisationseditor.component.html',
  styleUrls: ['./organisationseditor.component.scss']
})

export class OrganisationsEditorComponent {
  name: string;
  type: string;
  code: string;
  disableForm: boolean;
  id: string;
  organisation_group_id: string;

  constructor(
    public dialogRef: MatDialogRef<OrganisationsEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.name = data.name;
    this.type = data.type;
    this.code = data.code;
    this.id = data.id;
    this.organisation_group_id = data.organisation_group_id;
  }

  saveOrganisation() {
    this.explorerService.saveOrganisation(this.name, this.type, this.code, this.organisation_group_id, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This organisation could not be saved.')
      );
  }

  organisationEntered(event) {
    if (event.key === "Enter") {
      this.saveOrganisation();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.name =='' || this.name==undefined || this.type=='' || this.type==undefined || this.code=='' || this.code==undefined;
  }

}
