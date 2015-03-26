package com.springapp.mvc;

import java.util.List;

/**
 * @author Yaroslav.Gryniuk
 */
public class OutputParamsContainer {
    private Double length;
    private Double width;
    private List<Double> data;

    public OutputParamsContainer() {
    }

    public OutputParamsContainer(Double length, Double width, List<Double> data) {
        this.length = length;
        this.width = width;
        this.data = data;
    }

    public Double getLength() {
        return length;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getWidth() {
        return width;
    }

    public void setWidth(Double width) {
        this.width = width;
    }

    public List<Double> getData() {
        return data;
    }

    public void setData(List<Double> data) {
        this.data = data;
    }
}
