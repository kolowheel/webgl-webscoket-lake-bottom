package com.springapp.mvc;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Yaroslav.Gryniuk
 */
@Component
public class LogicEngine {
    private Map<Integer, LakeDno> lakeDnoMap;

    @PostConstruct
    public void loadDnos() throws IOException {
        lakeDnoMap = new HashMap<>();
        lakeDnoMap.put(1,new ObjectMapper().readValue(new File("C:\\Users\\yaroslav\\Dropbox\\4\\java\\lab1+\\new doneshko.json"),LakeDno.class));
    }

    public OutputParamsContainer compute(IncomeParams incomeParams) throws IOException {
        LakeDno dno = lakeDnoMap.get(incomeParams.getId());
        OutputParamsContainer container = new OutputParamsContainer();
        container.setLength(dno.getLenght());
        container.setWidth(dno.getWidth());
        container.setData(dno.getVertexList().stream().map(vertex ->
                (double) Math.round(vertex.getTime() * incomeParams.getSoundSpeed() / 2)).collect(Collectors.toList()));
        return container;
    }

    public Map<Integer, LakeDno> getLakeDnoMap() {
        return lakeDnoMap;
    }

    public void setLakeDnoMap(Map<Integer, LakeDno> lakeDnoMap) {
        this.lakeDnoMap = lakeDnoMap;
    }
}
