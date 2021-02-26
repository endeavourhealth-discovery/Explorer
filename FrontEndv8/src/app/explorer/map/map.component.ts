import { Component, OnInit } from '@angular/core';
import * as L from 'leaflet';
import {ExplorerService} from "../explorer.service";
import {LoggerService, UserManagerService} from "dds-angular8";
import {MapResult} from "./model/MapResult";
import {MapLayer} from "./model/MapLayer";
import {MatSliderChange} from "@angular/material/slider";
import {Level} from "./model/Level";
import {CookieService} from "ngx-cookie-service";
import {UserProfile} from "dds-angular8/user-manager/models/UserProfile";
import {Router} from "@angular/router";

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss']
})

export class MapComponent implements OnInit {

  query: string;
  queries: string[];

  display: string;
  generating: string = "Generating map...";
  sliderValue: number = 0;
  max: number;
  dates: string[];
  selectedDate: string;
  layerIds: string[];
  selectedLayer: string;
  map: L.map = null;
  url: string = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  attribution: string = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

  mapResults: MapResult;
  layers: MapLayer[];
  layersToRemove: MapLayer[];
  buildingLayers: any;

  levels: Level[];
  user: UserProfile;
  covidQuery1: string = "Suspected and confirmed Covid-19 cases";
  covidQuery2: string = "Shielded Covid-19 patients";
  covidQuery3: string = "Confirmed Covid-19 cases";
  isCovidQuery: boolean = true;
  isLevelTransparent: boolean = false;

  projectId: string = '';
  inits: any = 0;

  constructor(private explorerService: ExplorerService, private userManagerService: UserManagerService,
              private log: LoggerService,
              private cookieService: CookieService,
              private router: Router,
              private userService: UserManagerService) {
    this.userManagerService.onProjectChange.subscribe(
      (newProject) => this.start(newProject.id),
      (error) => this.log.error(error)
    );
  }

  ngOnInit() {
    this.start(this.projectId);
  }

  start(newProject: any) {
    this.inits++;

    if (this.inits==1)
      return;

    if (newProject!=this.projectId) {
      this.router.navigate(['/covidlibrary']);
      return;
    }

    this.projectId = newProject;

    this.explorerService.getMapQueries()
      .subscribe(
        (result) => {
          this.queries = result;
          this.query = this.covidQuery1;
          this.userService.getUserProfile(true).then(
            result => {
              this.user = result;
              this.init();
            }
          );
        },
        (error) => this.log.error(error)
      );
  }

  init() {
    let cookieLevel = this.cookieService.get(this.user.uuid + "_custom_levels");
    if (cookieLevel) {
      let values = cookieLevel.split(",",10);
      this.createCookieLevels(values);
    } else {
      this.defaultLevels();
    }

    this.display = this.generating;
    this.layersToRemove = [];
    this.explorerService.getMapDates(this.query)
      .subscribe(
        (result) =>{
          this.dates = result;
          this.selectedDate = this.dates[this.dates.length-1];
          this.max = this.dates.length;
          this.sliderValue = this.max;
          this.explorerService.getMaps(this.query, this.selectedDate, this.levels)
            .subscribe(
              (result) =>{
                this.mapResults = result;
                this.layerIds = this.mapResults.ids;
                this.selectedLayer = this.layerIds[0];
                this.map = L.map('map',{ zoomDelta: 0.5, zoomSnap: 0.9 });
                //this.map = L.map('map');
                this.buildingLayers = new L.FeatureGroup().addTo(this.map);
                let layer = {};
                this.layers  = this.mapResults.layers['All levels'];
                this.layers.forEach( (item, index) => {
                  layer[index] = L.geoJSON([JSON.parse(item.geoJson)], {
                    style: function (feature) {
                      return { color: item.color, fill: false, weight: 0 };
                    }
                  });
                  layer[index].addTo(this.buildingLayers);
                  //this.map.fitBounds(this.buildingLayers.getBounds());
                  this.map.setView([51.465, -0.09], 10.5);
                });
                this.createMap();
              },
              (error) => this.log.error(error)
            );
        },
        (error) => this.log.error(error)
      );
  }

  clearLayers() {
    if (this.layersToRemove && this.layersToRemove.length > 0) {
      for(let i=0;  i<this.layersToRemove.length; i++){
        this.map.removeLayer(this.layersToRemove[i]);
      }
      this.layersToRemove = [];
    }
  }

  createCookieLevels(values) {
    this.levels = [];
    let level = new Level();
    level.lowerLimit = values[0];
    level.upperLimit = values[1];
    level.description = 'Level 1';
    level.color = "#FFFEC3";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = values[2];
    level.upperLimit = values[3];
    level.description = 'Level 2';
    level.color = "#FDDB89";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = values[4];
    level.upperLimit = values[5];
    level.description = 'Level 3';
    level.color = "#FEAD75";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = values[6];
    level.upperLimit = values[7];
    level.description = 'Level 4';
    level.color = "#F4735E";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = values[8];
    level.upperLimit = values[9];
    level.description = 'Level 5';
    level.color = "#CB4B64";
    this.levels.push(level);
  }

  defaultLevels() {

    this.levels = [];

    let level = new Level();
    level.lowerLimit = '0.1';
    level.upperLimit = '0.4';
    level.description = 'Level 1';
    level.color = "#FFFEC3";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = '0.4';
    level.upperLimit = '0.5';
    level.description = 'Level 2';
    level.color = "#FDDB89";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = '0.5';
    level.upperLimit = '0.7';
    level.description = 'Level 3';
    level.color = "#FEAD75";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = '0.7';
    level.upperLimit = '1.1';
    level.description = 'Level 4';
    level.color = "#F4735E";
    this.levels.push(level);

    level = new Level();
    level.lowerLimit = '1.1';
    level.upperLimit = '4';
    level.description = 'Level 5';
    level.color = "#CB4B64";
    this.levels.push(level);
  }

  createMap() {

    //this.map.fitBounds(this.buildingLayers.getBounds());
    this.clearLayers();

    let layer = L.geoJSON();
    let count = 0;
    this.layers  = this.mapResults.layers['Level 1'];

    if (this.isLevelTransparent) {
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 2'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 3'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 4'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 5'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });
    } else {
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 2'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 3'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 4'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });

      this.layers  = this.mapResults.layers['Level 5'];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });
    }

    L.tileLayer(this.url, { maxZoom: 100, attribution: this.attribution, id: 'mapbox/streets-v11', tileSize: 512, zoomOffset: -1 }).addTo(this.map);
    if (this.isCovidQuery) {
      this.display = this.formatDate(this.selectedDate);
    } else {
      this.display = "";
    }
  }

  refreshMap() {this.explorerService.getMaps(this.query, this.selectedDate, this.levels)
      .subscribe(
        (result) =>{
          this.mapResults = result;
          this.layerIds = this.mapResults.ids;
          this.selectedLayer = this.layerIds[0];
          let cookieString =  this.mapResults.lowerLimits[0] + ',' +
            this.mapResults.upperLimits[0] + ',' +
            this.mapResults.lowerLimits[1] + ',' +
            this.mapResults.upperLimits[1] + ',' +
            this.mapResults.lowerLimits[2] + ',' +
            this.mapResults.upperLimits[2] + ',' +
            this.mapResults.lowerLimits[3] + ',' +
            this.mapResults.upperLimits[3] + ',' +
            this.mapResults.lowerLimits[4] + ',' +
            this.mapResults.upperLimits[4];
          this.cookieService.set(this.user.uuid + "_custom_levels", cookieString);
          this.createMap();
        },
        (error) => this.log.error(error)
      );
  }

  refreshLayer(selected) {

    this.selectedLayer = selected;

    //this.map.fitBounds(this.buildingLayers.getBounds());

    if (this.selectedLayer == "All levels") {
      this.createMap();
    } else {
      this.clearLayers();
      let layer = L.geoJSON();
      let count = 0;
      this.layers  = this.mapResults.layers[this.selectedLayer];
      if (this.isLevelTransparent) {
        this.layers.forEach( (item, index) => {
          layer = L.geoJSON([JSON.parse(item.geoJson)], {
            style: function (feature) {
              return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
            }
          }).bindPopup(function (layer) {
            return item.description;
          });
          layer.addTo(this.map);
          this.layersToRemove[count] = layer;
          count++;
        });
      } else {
        this.layers.forEach( (item, index) => {
          layer = L.geoJSON([JSON.parse(item.geoJson)], {
            style: function (feature) {
              return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
            }
          }).bindPopup(function (layer) {
            return item.description;
          });
          layer.addTo(this.map);
          this.layersToRemove[count] = layer;
          count++;
        });
      }
    }
    L.tileLayer(this.url, { maxZoom: 18, attribution: this.attribution, id: 'mapbox/streets-v11', tileSize: 512, zoomOffset: -1 }).addTo(this.map);
  }

  toggleTransparent(selected, checked: boolean) {

    this.isLevelTransparent = checked;
    this.selectedLayer = selected;

    //this.map.fitBounds(this.buildingLayers.getBounds());

    if (this.selectedLayer == "All levels") {
      this.createMap();
    } else {
      this.clearLayers();
      let layer = L.geoJSON();
      let count = 0;
      this.layers  = this.mapResults.layers[this.selectedLayer];
      if (this.isLevelTransparent) {
        this.layers.forEach( (item, index) => {
          layer = L.geoJSON([JSON.parse(item.geoJson)], {
            style: function (feature) {
              return { color: item.color, fillColor: item.color, fillOpacity: .5, weight: 1.5 };
            }
          }).bindPopup(function (layer) {
            return item.description;
          });
          layer.addTo(this.map);
          this.layersToRemove[count] = layer;
          count++;
        });
      } else {
        this.layers.forEach( (item, index) => {
          layer = L.geoJSON([JSON.parse(item.geoJson)], {
            style: function (feature) {
              return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1.5 };
            }
          }).bindPopup(function (layer) {
            return item.description;
          });
          layer.addTo(this.map);
          this.layersToRemove[count] = layer;
          count++;
        });
      }
    }
    L.tileLayer(this.url, { maxZoom: 18, attribution: this.attribution, id: 'mapbox/streets-v11', tileSize: 512, zoomOffset: -1 }).addTo(this.map);
  }

  updateDate(event) {
    this.display = this.generating;
    this.selectedDate = this.dates[event.value];
    this.refreshMap();
  }

  onInputChange(event: MatSliderChange) {
    this.display = this.formatDate(this.dates[event.value]);
  }

  recompute() {
    this.display = this.generating;
    this.refreshMap();
  }

  changeQuery() {
    this.selectedDate = '';
    this.clearLayers();
    this.display = this.generating;
    this.layersToRemove = [];
    if (this.query == this.covidQuery1 || this.query == this.covidQuery2 || this.query == this.covidQuery3) {
      this.isCovidQuery = true;
      this.explorerService.getMapDates(this.query)
        .subscribe(
          (result) =>{
            this.dates = result;
            this.selectedDate = this.dates[this.dates.length-1];
            this.max = this.dates.length;
            this.sliderValue = this.max;
            this.refreshMap();
          },
          (error) => this.log.error(error)
        );
    } else {
      this.isCovidQuery = false;
      this.refreshMap();
    }
  }

  formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth()),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (day.length < 2)
      day = '0' + day;

    let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var monthName = months[(Number(month))];

    return [day, monthName, year].join('-');
  }


}
