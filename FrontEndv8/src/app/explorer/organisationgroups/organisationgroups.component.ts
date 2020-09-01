import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";
import {ValueSetEditorComponent} from "../valueseteditor/valueseteditor.component";
import {SelectionModel} from '@angular/cdk/collections';
import {MessageBoxDialogComponent} from "../message-box-dialog/message-box-dialog.component";
import {FormControl} from "@angular/forms";
import {ValueSetCodeComponent} from "../valuesetcode/valuesetcode.component";

@Component({
  selector: 'app-organisationgroups',
  templateUrl: './organisationgroups.component.html',
  styleUrls: ['./organisationgroups.component.scss']
})

export class OrganisationGroupsComponent implements OnInit {

  selection = new SelectionModel<any>(true, []);

  events: any;
  dataSource: MatTableDataSource<any>;
  page: number = 0;
  size: number = 12;

  displayedColumns: string[] = ['select', 'type', 'name', 'updated'];

  selectedType: string = '';
  selectedTypeString: string = '';
  selectAll: boolean = true;

  typeList = [];
  typeValues = new FormControl(this.typeList);

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService,
    private dialog: MatDialog) { }

  ngOnInit() {
    this.explorerService.getLookupLists('9')
      .subscribe(
        (result) => this.loadList(result),
        (error) => this.log.error(error)
      );
  }

  toggleSelection(event) {
    if (event.checked) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    } else {
      this.typeValues = new FormControl([]);
      this.selectedTypeString = "";
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedType=="" && this.selectAll) {
      this.typeValues = new FormControl(this.typeList);
      this.selectedTypeString = this.typeList.toString();
    }

    if (override) {
      this.selectAll = false;
      this.selectedTypeString = this.selectedType.toString();
    }
    this.loadEvents();
  }

  loadEvents() {
    this.events = null;
    this.explorerService.getOrganisationGroups(this.page, this.size, this.selectedTypeString)
      .subscribe(
        (result) => this.displayEvents(result),
        (error) => this.log.error(error)
      );

    this.selection.clear();
  }

  loadList(lists: any) {
    this.typeList = [];

    lists.results.map(
      e => {
        this.typeList.push(e.type);
      }
    )
    this.typeValues = new FormControl(this.typeList);
    this.refresh(false);

  }

  displayEvents(events: any) {
    this.events = events;
    this.dataSource = new MatTableDataSource(events.results);
  }

  onPage(event: PageEvent) {
    this.page = event.pageIndex;
    this.size = event.pageSize;
    this.loadEvents();
  }

  isAllSelected() {
    if (this.dataSource==undefined)
      return false;
    const numSelected = this.selection.selected.length;
    const numRows = this.dataSource.data.length;
    return numSelected === numRows;
  }

  masterToggle() {
    this.isAllSelected() ?
      this.selection.clear() :
      this.dataSource.data.forEach(row => this.selection.select(row));
  }

  checkboxLabel(row?: any): string {
    if (!row) {
      return `${this.isAllSelected() ? 'select' : 'deselect'} all`;
    }
    return `${this.selection.isSelected(row) ? 'deselect' : 'select'} row ${row.position + 1}`;
  }

  valueSetCodeDialog(value_set_id: any) {
    const dialogRef = this.dialog.open(ValueSetCodeComponent, {
      height: '780px',
      width: '1600px',
      data: {value_set_id: value_set_id}
    });
  }

  add() {
    const dialogRef = this.dialog.open(ValueSetEditorComponent, {
      height: '320px',
      width: '600px',
      data: {id: "", name: "", type: ""}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });
  }

  delete() {
    let id = "";
    this.selection.selected.map(
      e => {
        id+=","+e.id;
      }
    )
    id = id.substr(1);

    MessageBoxDialogComponent.open(this.dialog, 'Delete value set', 'Are you sure you want to delete this value set?', 'Delete', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.deleteValueSet(id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This value set could not be deleted.')
            );
        }
      });
  }

  edit() {
    const dialogRef = this.dialog.open(ValueSetEditorComponent, {
      height: '320px',
      width: '600px',
      data: {id: this.selection.selected[0].id, name: this.selection.selected[0].name, type:this.selection.selected[0].type}
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result)
        this.ngOnInit();
    });
  }

  duplicate() {
    MessageBoxDialogComponent.open(this.dialog, 'Duplicate value set', 'Are you sure you want to duplicate this value set?', 'Duplicate', 'Cancel')
      .subscribe(result => {
        if (result) {

          this.explorerService.duplicateValueSet(this.selection.selected[0].id.toString())
            .subscribe(saved => {
                this.ngOnInit();
              },
              error => this.log.error('This value set could not be duplicated.')
            );
        }
      });
  }

}
