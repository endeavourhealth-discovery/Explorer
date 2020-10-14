import {MapLayer} from "./MapLayer";

export class MapResult {
  ids: string[];
  layers: Map<string, MapLayer[]>;
}
