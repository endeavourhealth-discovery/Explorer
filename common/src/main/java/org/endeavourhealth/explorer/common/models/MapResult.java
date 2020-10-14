package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MapResult {

    private ArrayList<String> ids = new ArrayList();
    private HashMap<String, List<MapLayer>> layers = new HashMap<>();

    public ArrayList<String> getIds() {
        return ids;
    }

    public void setIds(ArrayList<String> ids) {
        this.ids = ids;
    }

    public HashMap<String, List<MapLayer>> getLayers() {
        return layers;
    }

    public void setLayers(HashMap<String, List<MapLayer>> layers) {
        this.layers = layers;
    }
}
