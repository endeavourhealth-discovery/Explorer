package org.endeavourhealth.explorer.common.models;

import org.json.simple.JSONObject;

import java.util.ArrayList;

public class TableData {

    private ArrayList<TableHeader> headers = new ArrayList();
    private ArrayList<JSONObject> rows = new ArrayList();
    private ArrayList<String> outputTypes = new ArrayList<>();
    private String outputType = "";

    public ArrayList<TableHeader> getHeaders() {
        return headers;
    }

    public void setHeaders(ArrayList<TableHeader> headers) {
        this.headers = headers;
    }

    public ArrayList<JSONObject> getRows() { return rows; }

    public void setRows(ArrayList<JSONObject> rows) {
        this.rows = rows;
    }

    public ArrayList<String> getOutputTypes() { return outputTypes; }

    public void setOutputTypes(ArrayList<String> outputTypes) { this.outputTypes = outputTypes; }

    public String getOutputType() { return outputType; }

    public void setOutputType(String outputType) { this.outputType = outputType; }
}
