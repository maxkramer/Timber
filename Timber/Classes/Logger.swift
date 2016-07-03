//
//  Logger.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

/// Logger; a small logging framework to help you debug your app and filter your logs

public class Logger {
    
    /// Determines whether or not the logger is enabled
    public var enabled: Bool = true
    
    /// Sets the minimum log level of the logger.
    public var minLevel: LogLevel
    
    /// Sets the terminator of a log line in the console.
    public var terminator: String = "\n"
    
    /// Sets the separator of elements in the log message.
    public var separator: String = ", "
    
    /// Sets how the log message should be formatted.
    /// See the class for more info.
    public var logFormat: LogFormat
    
    /// More useful for testing purposes; will perform the log to a pipe or console on the current thread
    public var useCurrentThread: Bool = false
    
    /// Sets the pipe used for output. Default (nil) refers to the console
    public var pipe: NSPipe?
    
    /// Keeps track of the minimum log level for each file
    private var logLevels = [String: LogLevel]()
    
    /** The queue that the logs will take place on
     Log formatting could be an quite expensive feature and should not block the main thread
     Logging itself has no need to be done on the main thread either.
     The queue is serial as that's the way in which your logs should appear
     
     debug(a), debug(b), debug(c) should show as:
     
     a
     b
     c
     
     Which may certainly not be the case in a concurrent queue as the blocks are run asynchronously.
     */
    
    private let logQueue = dispatch_queue_create("logger.queue", DISPATCH_QUEUE_SERIAL)
    
    /// The shared instance of the Logger preventing the user from needing to create
    /// a new instance of `Logger` everytime that a message should be logged
    public static var shared = Logger()
    
    // MARK: Custom initialiser
    
    /**
     Creates an instance of the `Logger` class
     - Parameter minLevel: The minimum log level of the logger. See `Logger+LogLevels` for more info
     - Parameter logFormat: The format in which the log message should be generated
     */
    
    public init(minLevel: LogLevel = .Debug, logFormat: LogFormat = LogFormat.defaultLogFormat) {
        self.minLevel = minLevel
        self.logFormat = logFormat
    }
    
    // MARK: Register a specific log level for a file
    
    /**
     Registers the file of the caller to a specific minimum log level
     - Parameter level: the minimum log level to be associated with the file
     - Parameter filePath: **Should not be overwritten**. It's used to determine the filename of the caller
     */
    
    public func registerFile(level: LogLevel, filePath: String = #file) {
        let fileName = filePath.lastPathComponent.stringByDeletingPathExtension
        logLevels[fileName] = level
    }
    
    // MARK: Log functions
    
    /**
     Logs a message with a specific log level
     - Parameter level: The minimum log level to be associated with the message
     - Parameter message: A series of objects to be logged
     - Parameter filePath: Determines the file path of the caller
     - Parameter line: Determines the line in the source code of the caller
     - Parameter column: Determines the column in the source code of the caller
     - Parameter function: Determines the function that triggered the call
     */
    
    public func log(level: LogLevel, message: [CVarArgType], filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        guard enabled == true else {
            return
        }
        
        let logAllowed = level >= minLevel
        
        let fileName = filePath.lastPathComponent.stringByDeletingPathExtension
        let fileLevelLog = logLevels[fileName]
        
        guard (fileLevelLog != nil && level >= fileLevelLog!) || (fileLevelLog == nil && logAllowed == true) else {
            return
        }
        
        let formatBlock = {
            let logFormatter = LogFormatter(format: self.logFormat, logLevel: level, filePath: filePath, line: line, column: column, function: function, message: message.reduce("", combine: { (combinator, obj) in
                if combinator.characters.count == 0 {
                    return String(obj)
                }
                return combinator + self.separator + String(obj)
            }), terminator: self.terminator)
            
            let logMessage = logFormatter.formattedLogMessage()
            
            if let pipe = self.pipe {
                self.logTo(pipe, message: logMessage)
            }
            else {
                // The separator and terminator are automatically set with the log formatter
                print(logMessage, separator: "", terminator: "")
            }
        }
        
        if useCurrentThread {
            formatBlock()
        }
        else {
            dispatch_async(logQueue, formatBlock)
        }
    }
    
    /**
     Logs the message to the supplied pipe
     - Parameter pipe: An NSPipe that the data will be written to
     - Parameter message: The formatted message to be logged
     */
    
    internal func logTo(pipe: NSPipe, message: String) {
        let fh = pipe.fileHandleForWriting
        guard let data = message.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        fh.writeData(data)
    }
    
    /**
     Triggers a log with under the debug log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func debug(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Debug, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the trace log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func trace(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Trace, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the info log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func info(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Info, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the warn log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func warn(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Warn, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the error log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func error(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Error, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the fatal log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public func fatal(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.Fatal, message: message, filePath: filePath, line: line, column: column, function: function)
    }
}
