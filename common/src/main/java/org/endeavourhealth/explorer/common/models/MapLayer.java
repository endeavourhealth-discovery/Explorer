package org.endeavourhealth.explorer.common.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({
        "areaCode",
        "description",
        "geoJson",
        "color"
})
public class MapLayer {

    @JsonProperty("areaCode")
    private String areaCode;

    @JsonProperty("description")
    private String description;

    @JsonProperty("geoJson")
    private String geoJson;

    @JsonProperty("color")
    private String color;

    @JsonProperty("areaCode")
    public String getAreaCode() {
        return areaCode;
    }

    @JsonProperty("areaCode")
    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode;
    }

    @JsonProperty("description")
    public String getDescription() {
        return description;
    }

    @JsonProperty("description")
    public void setDescription(String description) { this.description = description; }

    @JsonProperty("geoJson")
    public String getGeoJson() {
        return geoJson;
    }

    @JsonProperty("geoJson")
    public void setGeoJson(String geoJson) {
        this.geoJson = geoJson;
    }

    public String getColor() { return color; }

    public void setColor(String color) { this.color = color; }

}
