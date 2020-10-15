import {MapLayer} from "./MapLayer";

export class MapResult {
  ids: string[];
  layers: Map<string, MapLayer[]>;
  lowerLimits: string[];
  upperLimits: string[];
  colors: string[];
  descriptions: string[];
}
