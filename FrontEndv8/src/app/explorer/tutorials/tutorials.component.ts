import {Component, OnInit} from '@angular/core';
import {MatTableDataSource} from '@angular/material';
import {ExplorerService} from '../explorer.service';
import {LoggerService, UserManagerService} from 'dds-angular8';
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
    private explorerService: ExplorerService, private userManagerService: UserManagerService,
    private log: LoggerService
    ) { }

  ngOnInit() {
  }

  showVideo(video) {
    let link = "";

    switch(video) {
      case 1:
        link = "https://youtu.be/4yv0i5W36_o";
        break;
      case 2:
        link = "https://youtu.be/HPk6d_cV6uw";
        break;
      case 3:
        link = "https://youtu.be/uqWROH6UiSY";
        break;
      case 4:
        link = "https://youtu.be/9MBqcwBsQxQ";
        break;
      case 5:
        link = "https://youtu.be/i2cpVCd0AY0";
        break;
      case 6:
        link = "https://youtu.be/echEph4_BPk";
        break;
      case 7:
        link = "https://youtu.be/7h4d2n7LGyc";
        break;
      case 8:
        link = "https://youtu.be/i6eQk3mJpnU";
        break;
      case 9:
        link = "https://youtu.be/rOqc8H2-52s";
        break;
      case 10:
        link = "https://youtu.be/tMFBjhGN0As";
        break;
      default:

    }

    window.open(
      link,
      '_blank'
    );
  }
}
