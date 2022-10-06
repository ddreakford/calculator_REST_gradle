package com.slsamples.gradle.java.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;
import java.util.HashSet;

// @TODO Encode/decode the url so the slash can be used

@RestController
public class CalculatorController {

	@GetMapping("/calculator/{op}/{num1}/{num2}/")
    public String calculator(@PathVariable String op, @PathVariable String num1, @PathVariable String num2) {

        String validationMsg = validateArgs(op, num1, num2);
        if ( !validationMsg.isEmpty() ) {
            return validationMsg;
        }

        double operand1 = Double.parseDouble(num1);
        double operand2 = Double.parseDouble(num2);
        double result = 0;
        switch (op) {
            case "+":
                result = add(operand1, operand2);
                break;
            case "-":
                result = subtract(operand1, operand2);
                break;
            case "*":
                result = multiply(operand1, operand2);
                break;
            case "d":
                result = divide(operand1, operand2);
                break;
            default:
                break;
        }

        return String.format("%.3f %s %.3f = %.3f", operand1, op, operand2, result);
   }

    private String validateArgs(String op, String num1, String num2) {

        Set<String> validOps = new HashSet<String>();
        validOps.add("+");
        validOps.add("-");
        validOps.add("*");
        validOps.add("d");

        if ( op.isEmpty() ) {
            return  "Operation is missing";
        }
        if ( !validOps.contains(op) ) {
            return String.format("Operation '%s' must be one of: +,-,*,d", op);
        }
        
        String returnMsg = "";
        try {
            Double.parseDouble(num1);
        }
        catch ( Exception e ) {
            returnMsg = String.format("First operand '%s' is not a number", num1);
        }
        try {
            Double.parseDouble(num2);
        }
        catch ( Exception e ) {
            returnMsg = String.format("Second operand '%s' is not a number", num2);
        }

        return returnMsg;
    }

    private double add(double num1, double num2) {
        // Modified this method
        return num1 + num2;
    }

    private double subtract(double num1, double num2) {
        return num1 - num2;
    }

    private double multiply(double num1, double num2) {
        // Modified this method
        return num1 * num2;
    }

    private double divide(double num1, double num2) {
        return num1 / num2;
    }
}
