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
import {FormControl} from "@angular/forms";

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss']
})
export class MapComponent implements OnInit {

  query: string;
  queries: string[];

  display: string;
  generating: string;
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

  selectedConcept: string = '';
  selectedConceptString: string = '';
  selectAll: boolean = true;

  conceptList = null;
  conceptValues = new FormControl(this.conceptList);

  constructor(private explorerService: ExplorerService,
              private log: LoggerService,
              private cookieService: CookieService,
              private userService: UserManagerService) {

  }

  ngOnInit() {
    this.explorerService.getMapQueries()
      .subscribe(
        (result) => {
          this.queries = result;
          this.query = "Suspected and confirmed Covid-19 cases";
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

    this.generating = "Generating map...";
    this.display = this.generating;
    this.layersToRemove = [];
    this.explorerService.getMapDates(this.query)
      .subscribe(
        (result) =>{
          this.dates = result;
          this.selectedDate = this.dates[this.dates.length-1];
          this.max = this.dates.length;
          this.sliderValue = this.max;
          this.explorerService.getMaps(this.query, this.selectedConceptString, this.selectedDate, this.levels)
            .subscribe(
              (result) =>{
                this.mapResults = result;
                this.layerIds = this.mapResults.ids;
                this.selectedLayer = this.layerIds[0];
                this.map = L.map('map',{ zoomDelta: 0.25, zoomSnap: .25 }).setView([51.505, -0.09], 13);
                this.buildingLayers = new L.FeatureGroup().addTo(this.map);
                let layer = {};
                this.layers  = this.mapResults.layers['All levels'];
                this.layers.forEach( (item, index) => {
                  layer[index] = L.geoJSON([JSON.parse(item.geoJson)], {
                    style: function (feature) {
                      return { color: item.color, fill: false, weight: 3 };
                    }
                  });
                  layer[index].addTo(this.buildingLayers);
                  this.map.fitBounds(this.buildingLayers.getBounds());
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

    this.map.fitBounds(this.buildingLayers.getBounds());
    this.clearLayers();

    let layer = L.geoJSON();
    let count = 0;
    this.layers  = this.mapResults.layers['Level 1'];
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

    L.tileLayer(this.url, { maxZoom: 18, attribution: this.attribution, id: 'mapbox/streets-v11', tileSize: 512, zoomOffset: -1 }).addTo(this.map);
    this.display = this.selectedDate;
  }

  refreshMap() {
    this.explorerService.getMaps(this.query, this.selectedConceptString, this.selectedDate, this.levels)
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

    this.map.fitBounds(this.buildingLayers.getBounds());

    if (this.selectedLayer == "All levels") {
      this.createMap();
    } else {
      this.clearLayers();
      let layer = L.geoJSON();
      let count = 0;
      this.layers  = this.mapResults.layers[this.selectedLayer];
      this.layers.forEach( (item, index) => {
        layer = L.geoJSON([JSON.parse(item.geoJson)], {
          style: function (feature) {
            return { color: 'black', fillColor: item.color, fillOpacity: 1, weight: 1 };
          }
        }).bindPopup(function (layer) {
          return item.description;
        });
        layer.addTo(this.map);
        this.layersToRemove[count] = layer;
        count++;
      });
    }
    L.tileLayer(this.url, { maxZoom: 18, attribution: this.attribution, id: 'mapbox/streets-v11', tileSize: 512, zoomOffset: -1 }).addTo(this.map);
  }

  updateDate(event) {
    this.display = this.generating;
    this.selectedDate = this.dates[event.value];
    this.refreshMap();
  }

  onInputChange(event: MatSliderChange) {
    this.display = this.dates[event.value];
  }

  recompute() {
    this.display = this.generating;
    this.refreshMap();
  }

  changeQuery() {
    this.selectedDate = '';
    this.selectAll = true;
    this.selectedConceptString = '';
    this.clearLayers();
    this.generating = "Generating map...";
    this.display = this.generating;
    this.layersToRemove = [];
    this.explorerService.getMapDates(this.query)
      .subscribe(
        (result) =>{
          this.dates = result;
          this.selectedDate = this.dates[this.dates.length-1];
          this.max = this.dates.length;
          this.sliderValue = this.max;
          if (this.query != "Suspected and confirmed Covid-19 cases") {
            this.explorerService.getConceptsFromQuery(this.query)
              .subscribe(
                (result) => {
                  this.loadList(result);
                  this.refreshMap();
                },
                (error) => this.log.error(error)
              );
          } else {
            this.conceptList = null;
            this.refreshMap();
          }
        },
        (error) => this.log.error(error)
      );
  }

  toggleSelection(event) {
    if (event.checked) {
      this.conceptValues = new FormControl(this.conceptList);
      this.selectedConceptString = this.conceptList.toString();
    } else {
      this.conceptValues = new FormControl([]);
      this.selectedConceptString = '';
    }
    this.refresh(false);
  }

  refresh(override) {
    if (this.selectedConcept == "" && this.selectAll) {
      this.conceptValues = new FormControl(this.conceptList);
      this.selectedConceptString = this.conceptList.toString();
    }

    if (override) {
      this.selectAll = false;
      this.selectedConceptString = this.selectedConcept.toString();
    }

    this.clearLayers();
    this.generating = "Generating map...";
    this.display = this.generating;
    this.layersToRemove = [];
    this.refreshMap();
  }

  loadList(lists: any) {
    this.conceptList = [];
    lists.results.map(
      e => {
        this.conceptList.push(e.type);
      }
    )
    this.conceptValues = new FormControl(this.conceptList);
    this.refresh(false);
  }
}
