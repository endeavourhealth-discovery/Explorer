import {Component, Inject} from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {FormControl} from "@angular/forms";
import {ReplaySubject, Subject} from "rxjs";
import {takeUntil} from "rxjs/operators";

export interface DialogData {
  id: string;
  name: string;
  query: string;
  indicator: string;
}

interface queryList {
  value: string;
}

@Component({
  selector: 'app-registryindicatoreditor',
  templateUrl: './registryindicatoreditor.component.html',
  styleUrls: ['./registryindicatoreditor.component.scss']
})

export class RegistryIndicatorEditorComponent {
  filterCtrl: FormControl = new FormControl();

  query: string;
  name: string;
  indicator: string;
  disableForm: boolean;
  id: string;
  queryList = [];
  filteredValueset: ReplaySubject<queryList[]> = new ReplaySubject<queryList[]>(1);
  saveCaption = 'Save';

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
  }

  private _onDestroy = new Subject<void>();

  ngOnInit() {
    this.explorerService.getLookupLists('11','')
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
    this.filteredValueset.next(this.queryList.slice());

    this.filterCtrl.valueChanges
      .pipe(takeUntil(this._onDestroy))
      .subscribe(() => {
        this.filterValueset();
      });

  }

  filterValueset() {
    let search = this.filterCtrl.value;

    if (!search) {
      this.filteredValueset.next(this.queryList.slice());
      return;
    } else {
      search = search.toLowerCase();
    }

    this.filteredValueset.next(
      this.queryList.filter(value => value.toLowerCase().indexOf(search) > -1)
    );
  }

  saveRegistry() {
    this.saveCaption = 'Saving, please wait....'
    this.explorerService.saveRegistryIndicator(this.query, this.name, this.indicator)
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
