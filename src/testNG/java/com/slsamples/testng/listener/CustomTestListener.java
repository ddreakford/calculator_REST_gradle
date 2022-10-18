package com.slsamples.testng.listener;

import java.io.PrintWriter;

import org.testng.TestListenerAdapter;
import org.testng.ITestContext;

public class CustomTestListener extends TestListenerAdapter {

    public void onFinish(ITestContext testContext) {
        super.onFinish(testContext);
        // PrintWriter writer = null;
        // try {
        //     writer = new PrintWriter("custom_listener_output.txt");
        //     writer.println("onFinish called");
        // }
        // catch (Exception e) {
        //     e.printStackTrace(System.err);
        // }
        // finally {
        //     writer.close();
        // }
    }
}