package com.slsamples.gradle.java.springboot;

import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class CalculatorControllerIT {

	@Autowired
	private TestRestTemplate template;

    // CalculatorController @GetMapping("/calculator/{op}/{num1}/{num2}/")

    @Test
    public void getAdd() throws Exception {
        ResponseEntity<String> response = template.getForEntity("/calculator/+/14/8/", String.class);
        assertThat(response.getBody()).isEqualTo("14.000 + 8.000 = 22.000");
    }
}
