# Stepy

A step counter app written in Flutter

## How it works

The app uses three main Android components.

First is the hardware based step sensor to get the number of steps taken
since device boot.

Second is the Alarm Manager which roughly wakes up every 15 minutes
the sensor reading function to get new steps in background and saves 
data to the database.

Third is an Android foreground service which is necessary for the Alarm Manager
to access the step sensor while running in background
