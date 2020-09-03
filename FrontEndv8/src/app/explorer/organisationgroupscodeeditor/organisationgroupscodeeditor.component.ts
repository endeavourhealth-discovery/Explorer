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
  selector: 'app-organisationgroupscodeeditor',
  templateUrl: './organisationgroupscodeeditor.component.html',
  styleUrls: ['./organisationgroupscodeeditor.component.scss']
})

export class OrganisationGroupsCodeEditorComponent {
  name: string;
  type: string;
  code: string;
  disableForm: boolean;
  id: string;
  organisation_group_id: string;

  constructor(
    public dialogRef: MatDialogRef<OrganisationGroupsCodeEditorComponent>,
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

  saveOrganisationGroupCode() {
    this.explorerService.saveOrganisationGroupCode(this.name, this.type, this.code, this.organisation_group_id, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set code could not be saved.')
      );
  }

  organisationGroupCodeEntered(event) {

    if (event.key === "Enter") {
      this.saveOrganisationGroupCode();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.name =='' || this.name==undefined || this.type=='' || this.type==undefined || this.code=='' || this.code==undefined;
  }

}
