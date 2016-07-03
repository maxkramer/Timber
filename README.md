# Timber

[![Build Status](https://travis-ci.org/MaxKramer/Timber.svg?branch=master)](https://travis-ci.org/MaxKramer/Timber)
[![codecov](https://codecov.io/gh/MaxKramer/Timber/branch/master/graph/badge.svg)](https://codecov.io/gh/MaxKramer/Timber)
[![Version](https://img.shields.io/cocoapods/v/TimberSwift.svg?style=flat)](http://cocoapods.org/pods/TimberSwift)
[![License](https://img.shields.io/cocoapods/l/TimberSwift.svg?style=flat)](http://cocoapods.org/pods/TimberSwift)
[![Platform](https://img.shields.io/cocoapods/p/TimberSwift.svg?style=flat)](http://cocoapods.org/pods/TimberSwift)

Timber is a lightweight logging framework written in Swift. It is very performant and runs all logging-based operations away from the main-thread, ensuring that the UI or any other operations remain unaffected.

Timber is also insanely flexible. It provides a `LogFormat` class which allows you to specify how the log messages should look, and includes custom date formats, and various information related to the file that the log message was executed in, such as the file-name, function and line.

Timber even provides the means to move your logs away from the console, by providing your own pipe to store the log messages elsewhere such as in a file or on your own server.

Unlike a number of other available logging frameworks, Timber lets you specify log-levels for any/all of your files. Say, for instance, you wanted to disable the logging of network requests while testing a separate feature, by calling `Logger.registerMinLevel(.None)` in your networking class, you can disable the log messages from being output.


## Installation

### Cocoapods

Simply add the following to your Podfile. Please be aware that the name of the cocoapod is `TimberSwift` and not `Timber`.

    pod 'TimberSwift'
    
### Manually

Clone the repository and add all the files found in /Timber/Classes to your project.

### Running unit tests

It is recommended that you run the unit tests before integrating Timber into your project. This can be done by performing the following in Timber's root directory. Please ensure that you have bundler installed, and if not run `gem install bundler` first.

	$ bundle install
    $ make test

## Basic usage

```swift

Logger.registerMinLevel(.Error) // Set the log-level for the current file if needed
    
Logger.debug("This will not be logged as the debug log level is < error")
Logger.error("Oh dear... An error occurred: \(some_error)")
Logger.info("The network request succeeded with status code \(status code)")
Logger.warn("The network response contains some unexpected data")
// etc...

```
## Custom log formats

In order to override the default log format used by Timber, which is `[Level Date Filename:Line] Message`, you must first instantiate your own `LogFormat` and pass it into either the global `Logger` or your own.

```swift

	let logFormat = LogFormat(template: "[%@ %@ %@:%@] %@", attributes: [
        LogFormatter.Attributes.Level,
        LogFormatter.Attributes.Date(format: "HH:mm:ss"),
        LogFormatter.Attributes.FileName(fullPath: false, fileExtension: true),
        LogFormatter.Attributes.Line,
        LogFormatter.Attributes.Message
     ])
     
     // Attach it to the global Logger
     Logger.setFormat(logFormat)
     
     // Or attach it to your own logger
     someLogger.logFormat = logFormat
     
     // Or pass it in when you instantiate your logger
     let someLogger = Logger(minLevel: .All, logFormat: logFormat)
```


## Documentation

Timber is fully documented, and the documentation can be found at [http://maxkramer.github.io/Timber/](http://maxkramer.github.io/Timber/).

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
Reference: [Log4j's architecture page](https://logging.apache.org/log4j/2.0/manual/architecture.html).

[visual_log_levels]: https://www.dropbox.com/s/hfqqua38rbv2psa/Screenshot%202016-06-09%2023.07.44.png?dl=1

## TODO:

- Swift PM integration
- Higher level functions for logging to file(s) including log rotation
- Colours!!!