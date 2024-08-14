package com.slsamples.gradle.java.springboot;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@SpringBootTest
@AutoConfigureMockMvc
public class CalculatorControllerTest {

    @Autowired
	private MockMvc mvc;

    // CalculatorController @GetMapping("/calculator/{op}/{num1}/{num2}/")

	@Test
	public void getAdd() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/calculator/+/14/8/").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("{\"operand1\": 14, \"operator\": \"+\", \"operand2\": 8, \"result\": 22}")));
	}

	@Test
	public void getSubtract() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/calculator/-/58/17/").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("{\"operand1\": 58, \"operator\": \"-\", \"operand2\": 17, \"result\": 41}")));
	}

	@Test
	public void getMultiply() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/calculator/*/21/5/").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("{\"operand1\": 21, \"operator\": \"*\", \"operand2\": 5, \"result\": 105}")));
	}

	@Test
	public void getDivide() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/calculator/d/9/3/").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("{\"operand1\": 9, \"operator\": \"d\", \"operand2\": 3, \"result\": 3}")));
	}
}
