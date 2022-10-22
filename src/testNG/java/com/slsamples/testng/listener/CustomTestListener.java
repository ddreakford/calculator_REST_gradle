package com.slsamples.testng.listener;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.testng.TestListenerAdapter;
import org.testng.ITestContext;
import org.testng.IResultMap;
import org.testng.ITestResult;

import com.google.gson.Gson;

/**
 * This listener reports the test events for a completed test run,
 * as required by the SeaLights Test Events API.
 */
public class CustomTestListener extends TestListenerAdapter {

    // Test Event key
    static final String NAME_KEY = "name";
    static final String START_KEY = "start";
    static final String END_KEY = "end";
    static final String STATUS_KEY = "status";

    // Test Event status
    static final String STATUS_PASSED = "passed";
    static final String STATUS_FAILED = "failed";
    static final String STATUS_SKIPPED = "skipped";

    public void onFinish(ITestContext testContext) {
        super.onFinish(testContext);

        // Build a list of Test Event objects for passed, failed 
        // and skipped tests.
        ArrayList<Map> testEvents = new ArrayList<Map>();
        // passed
        buildResultsList(testContext.getPassedTests(), testEvents, STATUS_PASSED);
        // failed
        buildResultsList(testContext.getFailedTests(), testEvents, STATUS_FAILED);
        // skipped
        buildResultsList(testContext.getSkippedTests(), testEvents, STATUS_SKIPPED);
        
        Gson gson = new Gson();
        PrintWriter writer = null;
        try {
            writer = new PrintWriter("test_results.json");
            writer.println(gson.toJson(testEvents));
        }
        catch (Exception e) {
            e.printStackTrace(System.err);
        }
        finally {
            writer.close();
        }
    }

    private void buildResultsList(IResultMap resultMap, ArrayList<Map> testEvents, String statusStr) {

        Iterator resultIter = resultMap.getAllResults().iterator();
        while ( resultIter.hasNext() ) {
            ITestResult result = (ITestResult) resultIter.next();
            HashMap testEvent = new HashMap<String, Object>();
            testEvent.put(NAME_KEY, result.getName());
            testEvent.put(START_KEY, new Long(result.getStartMillis()));
            testEvent.put(END_KEY, new Long(result.getEndMillis()));
            testEvent.put(STATUS_KEY, statusStr);
            testEvents.add(testEvent);
        }
    }
}