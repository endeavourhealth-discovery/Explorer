package org.endeavourhealth.explorer.common.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MapResult {

    private ArrayList<String> ids = new ArrayList();
    private HashMap<String, List<MapLayer>> layers = new HashMap<>();
    private ArrayList<String> lowerLimits = new ArrayList();
    private ArrayList<String> upperLimits = new ArrayList();
    private ArrayList<String> colors = new ArrayList();
    private ArrayList<String> descriptions = new ArrayList();


    public ArrayList<String> getIds() { return ids; }

    public void setIds(ArrayList<String> ids) {
        this.ids = ids;
    }

    public HashMap<String, List<MapLayer>> getLayers() {
        return layers;
    }

    public void setLayers(HashMap<String, List<MapLayer>> layers) {
        this.layers = layers;
    }

    public ArrayList<String> getLowerLimits() { return lowerLimits; }

    public void setLowerLimits(ArrayList<String> lowerLimits) { this.lowerLimits = lowerLimits; }

    public ArrayList<String> getUpperLimits() { return upperLimits; }

    public void setUpperLimits(ArrayList<String> upperLimits) { this.upperLimits = upperLimits; }

    public ArrayList<String> getColors() { return colors; }

    public void setColors(ArrayList<String> colors) { this.colors = colors;
    }

    public ArrayList<String> getDescriptions() { return descriptions; }

    public void setDescriptions(ArrayList<String> descriptions) { this.descriptions = descriptions; }
}
