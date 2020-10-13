import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA, MatDialog} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormGroup} from "@angular/forms";
import {RegistryIndicatorEditorComponent} from "../registryindicatoreditor/registryindicatoreditor.component";

export interface DialogData {
  id: string;
  name: string;
  query: string;
  ccg: string;
}

interface query {
  providerOrganisation: string;
}

@Component({
  selector: 'app-registryeditor',
  templateUrl: './registryeditor.component.html',
  styleUrls: ['./registryeditor.component.scss']
})

export class RegistryEditorComponent {
  providerOrganisation: string;
  query: string;
  name: string;
  disableForm: boolean;
  id: string;
  queryList = [];

  constructor(
    public dialogRef: MatDialogRef<RegistryEditorComponent>,
    private explorerService: ExplorerService,
    private dialog: MatDialog,
    private log: LoggerService,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.disableForm = true;
    this.id = data.id;
    this.name = data.name;
    this.query = data.query;
    this.providerOrganisation = data.ccg;
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
    this.explorerService.saveRegistry(this.query, this.name, this.id, this.providerOrganisation)
      .subscribe(saved => {
          this.addIndicator(this.name);
        },
        error => this.log.error('This registry could not be saved.')
      );
  }

  addIndicator(registry) {
    const dialogRef = this.dialog.open(RegistryIndicatorEditorComponent, {
      height: '400px',
      width: '600px',
      data: {id: "", name: registry, query: "", indicator: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.dialogRef.close(true);
    });
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
    this.name = this.query;
    this.formChanged();

    this.explorerService.getQuery(this.query)
      .subscribe(
        (result) => this.loadQuery(result),
        (error) => this.log.error(error)
      );

  }

  loadQuery(result: any) {
    result.results.map(
      e => {
        let query: query = JSON.parse(e.jsonQuery);

        this.providerOrganisation =  query.providerOrganisation;

      }
    )

  }

}
