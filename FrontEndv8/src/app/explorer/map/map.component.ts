import { Component, OnInit } from '@angular/core';
import * as L from 'leaflet';
import {ExplorerService} from "../explorer.service";
import {LoggerService} from "dds-angular8";
import {MapResult} from "./model/MapResult";
import {MapLayer} from "./model/MapLayer";
import {MatSliderChange} from "@angular/material/slider";

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss']
})
export class MapComponent implements OnInit {

  display: string;
  generating: string;
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

  levels = [
    {
      content: {
        label: '0.1 - 0.4',
        color: '#FFFEC3',
        value: 'Level 1'
      }
    },
    {
      content: {
        label: '0.4 - 0.5',
        color: '#FDDB89',
        value: 'Level 2'
      }
    },
    {
      content: {
        label: '0.5 - 0.7',
        color: '#FEAD75',
        value: 'Level 3'
      }
    },
    {
      content: {
        label: '0.7 - 1.1',
        color: '#F4735E',
        value: 'Level 4'
      }
    },
    {
      content: {
        label: '1.1 - 4',
        color: '#CB4B64',
        value: 'Level 5'
      }
    },
    {
      content: {
        label: 'All',
        color: 'blue',
        value: 'All levels'
      }
    }
  ];

  constructor(private explorerService: ExplorerService,
              private log: LoggerService) { }

  ngOnInit() {
    this.generating = "Generating map...";
    this.display = this.generating;
    this.layersToRemove = [];
    this.explorerService.getCovidDates()
      .subscribe(
        (result) =>{
          this.dates = result;
          this.selectedDate = this.dates[0];
          this.max = this.dates.length;
          this.explorerService.getCovidMaps(this.selectedDate)
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

  createMap() {

    this.map.fitBounds(this.buildingLayers.getBounds());
    if (this.layersToRemove && this.layersToRemove.length > 0) {
      for(let i=0;  i<this.layersToRemove.length; i++){
        this.map.removeLayer(this.layersToRemove[i]);
      }
      this.layersToRemove = [];
    }

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
    this.explorerService.getCovidMaps(this.selectedDate)
      .subscribe(
        (result) =>{
          this.mapResults = result;
          this.layerIds = this.mapResults.ids;
          this.selectedLayer = this.layerIds[0];
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

      if (this.layersToRemove && this.layersToRemove.length > 0) {
        for(let i=0;  i<this.layersToRemove.length; i++){
          this.map.removeLayer(this.layersToRemove[i]);
        }
        this.layersToRemove = [];
      }

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
    this.selectedDate = this.dates[event.value-1];
    this.refreshMap();
  }

  onInputChange(event: MatSliderChange) {
    this.display = this.dates[event.value-1];
  }
}
