import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';

export interface DialogData {
  id: string;
  name: string;
  query: string;
  indicator: string;
  ccg: string;
  practice: string;
  code: string;
}

@Component({
  selector: 'app-registryindicatoreditor',
  templateUrl: './registryindicatoreditor.component.html',
  styleUrls: ['./registryindicatoreditor.component.scss']
})

export class RegistryIndicatorEditorComponent {
  query: string;
  name: string;
  indicator: string;
  ccg: string;
  practice: string;
  code: string;
  disableForm: boolean;
  id: string;
  queryList = [];

  constructor(
    public dialogRef: MatDialogRef<RegistryIndicatorEditorComponent>,
    private explorerService: ExplorerService,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.query = data.query;
    this.indicator = data.indicator;
    this.ccg = data.ccg;
    this.practice = data.practice;
    this.code = data.code;
  }

  ngOnInit() {
    this.explorerService.getLookupLists('11')
      .subscribe(
        (result) => this.loadQueryList(result),
        (error) => this.log.error(error)
      );
  }

  loadQueryList(lists: any) {
    lists.results.map(
      e => {
        this.queryList.push(e.type);
      }
    )
  }

  saveRegistry() {
    this.explorerService.saveRegistryIndicator(this.query, this.name, this.indicator, this.ccg, this.practice, this.code, this.id)
      .subscribe(saved => {
          this.dialogRef.close(true);
        },
        error => this.log.error('This registry indicator could not be saved.')
      );
  }

  registryEntered(event) {
    if (event.key === "Enter") {
      this.saveRegistry();
    }
  }

  onCancelClick(): void {
    this.dialogRef.close();
  }

  formChanged() {
    this.disableForm = this.query=='' || this.query==undefined || this.name=='' || this.name==undefined;
  }

  querySelected() {
    this.indicator = this.query;
    this.formChanged();

  }

}
