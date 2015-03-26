package com.springapp.mvc;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.junit.Test;
import sun.misc.IOUtils;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * @author Yaroslav.Gryniuk
 */
public class Foo {
    @Test
    public void foo() throws IOException {
        String path = "C:\\Users\\wheel\\Dropbox\\4\\java\\lab1\\dno77.json";
        Map<String, Double> dno = new ObjectMapper().readValue(new File(path), new TypeReference<TreeMap<String, Double>>() {
        });
        LakeDno newDonewko = new LakeDno();
        List<Vertex> vertexes = new ArrayList<Vertex>();

        try{
        for (int i = 0; i <= 256; i++) {
            for (int j = 1; j <= 256; j++) {
                System.out.println(i*j);
                Double height = dno.get(String.valueOf(256*i+j));
                Vertex vertex = new Vertex();
                vertex.setX(i);
                vertex.setY(j);
                if ((i==256)&(j==255))
                    System.out.println("12");
                vertex.setTime((height*2)/340d);
                vertexes.add(vertex);
            }
        }
        }catch (Exception e){
            System.out.println();
        }
        newDonewko.setLenght(256d);
        newDonewko.setWidth(256d);
        newDonewko.setVertexList(vertexes);
        new ObjectMapper().writeValue(new File("C:\\Users\\wheel\\Dropbox\\4\\java\\lab1\\new doneshko.json"),newDonewko);
    }
    @Test
    public void bar() throws IOException {
        String path = "C:\\Users\\wheel\\Dropbox\\4\\java\\lab1\\new doneshko.json";
        final LakeDno dno = new ObjectMapper().readValue(new File(path), LakeDno.class);
        LogicEngine engine = new LogicEngine();
        engine.setLakeDnoMap(new HashMap<Integer, LakeDno>(){{put(1,dno);}});
        new ObjectMapper().writeValue(new File("C:\\Users\\wheel\\Dropbox\\4\\java\\lab1\\new doneshko2.json"),engine.compute(new IncomeParams(1,340)));
    }
}
