# Stepy

A step counter app written in Flutter

## How it works

The app uses three main Android components.

First is the hardware based step sensor which counts the steps taken.

Second is a Foreground service which keeps the step sensor registered 
in the SensorManager to hold it awake throughout the day.

Third is a Workmanager which fetches new steps from the sensor and 
updates daily steps taken roughly every 15 minutes.
