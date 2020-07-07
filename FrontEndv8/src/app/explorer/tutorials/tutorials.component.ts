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
        link = "https://www.youtube.com/watch?v=7nVboVulFYA";
        break;
      case 2:
        break;
      default:

    }

    window.open(
      link,
      '_blank'
    );
  }
}
