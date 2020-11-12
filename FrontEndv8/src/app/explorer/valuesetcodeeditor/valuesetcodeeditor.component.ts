import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";

export interface DialogData {
  type: string;
  selectedDataType: string;
  code: string;
  term: string;
  snomed: string;
  id: string;
  value_set_id: string;
}

interface dataType {
  value: string;
}

@Component({
  selector: 'app-valuesetcodeeditor',
  templateUrl: './valuesetcodeeditor.component.html',
  styleUrls: ['./valuesetcodeeditor.component.scss']
})

export class ValueSetCodeEditorComponent {
  type: string;
  selectedDataType: string;
  code: string;
  term: string;
  snomed: string;
  disableForm: boolean;
  id: string;
  value_set_id: string;

  dataTypes: dataType[] = [
    {value: 'Observation'},
    {value: 'Ethnicity'},
    {value: 'Encounter'},
    {value: 'Medication'}
  ];

  constructor(
    public dialogRef: MatDialogRef<ValueSetCodeEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.type = data.type;
    this.selectedDataType = data.selectedDataType;
    this.code = data.code;
    this.term = data.term;
    this.snomed = data.snomed;
    this.id = data.id;
    this.value_set_id = data.value_set_id;
  }

  saveValueSetCode() {
    this.explorerService.saveValueSetCode(this.type, this.selectedDataType, this.code, this.term, this.snomed, this.value_set_id, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This value set code could not be saved.')
      );
  }

  valueSetCodeEntered(event) {

    if (event.key === "Enter") {
      this.saveValueSetCode();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  snomedBrowser(): void {
    let url = 'https://termbrowser.nhs.uk/?perspective=full&conceptId1=404684003&edition=uk-edition&release=v20200930&server=https://termbrowser.nhs.uk/sct-browser-api/snomed&langRefset=999001261000000100,999000691000001104';

    window.open(url);
  }

  formChanged() {
    this.disableForm = this.type=='' || this.type==undefined || this.selectedDataType=='' || this.selectedDataType==undefined || this.code=='' || this.code==undefined || this.term=='' || this.term==undefined || this.snomed=='' || this.snomed==undefined;
  }

}
