import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService} from 'dds-angular8';
import {PageEvent} from '@angular/material/paginator';
import {ActivatedRoute} from "@angular/router";
import {MatDialog} from "@angular/material/dialog";

@Component({
  selector: 'app-tutorials',
  templateUrl: './tutorials.component.html',
  styleUrls: ['./tutorials.component.scss']
})

export class TutorialsComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private explorerService: ExplorerService,
    private log: LoggerService
    ) { }

  ngOnInit() {
  }

  showVideo(video) {
    let link = "";

    switch(video) {
      case 1:
        link = "https://youtu.be/uWZH7cb4in0";
        break;
      case 2:
        link = "https://youtu.be/ASltpTGSpik";
        break;
      case 3:
        link = "https://youtu.be/tOEARtSdTV0";
        break;
      default:

    }

    window.open(
      link,
      '_blank'
    );
  }
}
