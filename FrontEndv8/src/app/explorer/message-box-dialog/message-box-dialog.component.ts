import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialog, MatDialogRef} from '@angular/material/dialog';

@Component({
  selector: 'app-message-box-dialog',
  templateUrl: './message-box-dialog.component.html',
  styleUrls: ['./message-box-dialog.component.scss']
})
export class MessageBoxDialogComponent implements OnInit {
  static open(dialog: MatDialog, title: string, prompt: string, ok: string, cancel?: string, emphasis?: boolean) {
    let dialogRef = dialog.open(MessageBoxDialogComponent, {disableClose: true});
    dialogRef.componentInstance.title = title;
    dialogRef.componentInstance.prompt = prompt;
    dialogRef.componentInstance.ok = ok;
    dialogRef.componentInstance.cancel = cancel;
    dialogRef.componentInstance.emphasis = emphasis;
    return dialogRef.afterClosed();
  }

  title: string;
  prompt: string;
  ok: string;
  cancel: string;
  emphasis: boolean;

  constructor(
    public dialogRef: MatDialogRef<MessageBoxDialogComponent>
  ) {
  }

  ngOnInit() {
  }

  closeOk() {
    this.dialogRef.close(true);
  }

  closeCancel() {
    this.dialogRef.close(false);
  }
}
