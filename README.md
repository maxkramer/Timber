# Timber
File-based logging framework written in Swift

[![Build Status](https://travis-ci.org/MaxKramer/Timber.svg?branch=master)](https://travis-ci.org/MaxKramer/Timber)
[![codecov](https://codecov.io/gh/MaxKramer/Timber/branch/master/graph/badge.svg)](https://codecov.io/gh/MaxKramer/Timber)

[![Version](https://img.shields.io/cocoapods/v/Timber.svg?style=flat)](http://cocoapods.org/pods/Timber)
[![License](https://img.shields.io/cocoapods/l/Timber.svg?style=flat)](http://cocoapods.org/pods/Timber)
[![Platform](https://img.shields.io/cocoapods/p/Timber.svg?style=flat)](http://cocoapods.org/pods/Timber)

## Usage

```swift
Logger.registerMinLevel(.Error) // Set the log-level for the current file if needed
    
Logger.debug("I'm trying to debug something") // Log something!
Logger.error("TIFU \(some_error)")
Logger.info("TIFU \(some_error)")
// etc...
```

## TODO:

- Cocoapods, Carthage, and Swift PM integration
- Log to file(s) including log rotation
- Colours!!!
- Clean up

## Log Levels
    
As mentioned in [Logger+LogLevels.swift](https://github.com/MaxKramer/Logger/blob/master/Logger/Logger%2BLogLevels.swift), we uniformly use the same log priorities as Apache's log4j. The is as follows:

    ALL < DEBUG < TRACE < INFO < WARN < ERROR < FATAL < OFF.

Therefore, a log request of level p in a logger with level q is enabled if p >= q.

|Level|Description|
|---|---|
|ALL|All levels including custom levels.|
|DEBUG|Designates fine-grained informational events that are most useful to debug an application.|
|ERROR|Designates error events that might still allow the application to continue running.|
|FATAL|Designates very severe error events that will presumably lead the application to abort.|
|INFO|Designates informational messages that highlight the progress of the application at coarse-grained level.|
|OFF|The highest possible rank and is intended to turn off logging.|
|TRACE|Designates finer-grained informational events than the DEBUG.|
|WARN|Designates potentially harmful situations.|

Visually:

![visual log levels][visual_log_levels]
Stolen from [Log4j's architecture page](https://logging.apache.org/log4j/2.0/manual/architecture.html).

[visual_log_levels]: https://www.dropbox.com/s/hfqqua38rbv2psa/Screenshot%202016-06-09%2023.07.44.png?dl=1
