package com.springapp.mvc;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DataMessageHandler extends TextWebSocketHandler {

    @Autowired
    LogicEngine engine;
    ObjectMapper mapper = new ObjectMapper();
    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
        session.sendMessage(new TextMessage(mapper.writeValueAsString(engine.compute(mapper.readValue(message.getPayload(),IncomeParams.class)))));
        //session.sendMessage(new TextMessage(mapper.writeValueAsString(new OutputParamsContainer(256d,256d,new ArrayList<Double>(((Map<String,Double>)mapper.readValue(new File("D:\\dno\\dno76.json"),new TypeReference<Map<String,Double>>(){})).values())))));
    }

    @Override
    public boolean supportsPartialMessages() {
        return true;
    }
}