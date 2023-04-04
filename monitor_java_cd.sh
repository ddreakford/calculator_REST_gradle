#!/bin/sh

# Scan and monitor the app on deployment
java -jar $LIBS_DIR/rest-calculator-0.2.0-SNAPSHOT.jar com.slsamples.gradle.java.springboot.Application
