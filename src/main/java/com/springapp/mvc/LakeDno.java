package com.springapp.mvc;

import java.util.List;

/**
 * @author Yaroslav.Gryniuk
 */
public class LakeDno {
    private List<Vertex> vertexList;
    private Double lenght;
    private Double width;

    public List<Vertex> getVertexList() {
        return vertexList;
    }

    public void setVertexList(List<Vertex> vertexList) {
        this.vertexList = vertexList;
    }

    public Double getLenght() {
        return lenght;
    }

    public void setLenght(Double lenght) {
        this.lenght = lenght;
    }

    public Double getWidth() {
        return width;
    }

    public void setWidth(Double width) {
        this.width = width;
    }
}
