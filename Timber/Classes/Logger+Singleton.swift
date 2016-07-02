//
//  Logger+Singleton.swift
//  Logger
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension Logger {
    
    /**
     Sets the format of the global logger
     - Parameter format: The specific LogFormat to be used. Defaults to `LogFormat.defaultLogFormat`
     */
    
    public class func setFormat(format: LogFormat = LogFormat.defaultLogFormat) {
        shared.logFormat = format
    }
    
    /**
     Enables/disables the global logger.
     - Parameter enabled: `TRUE` to enable, `FALSE` to disable.
     */
    
    public class func setEnabled(enabled: Bool) {
        shared.enabled = enabled
    }
    
    /**
     Sets the minimum log level of the global logger
     - Parameter minLevel: The min log level to be used.
     */
    
    public class func setMinLevel(minLevel: LogLevel) {
        shared.minLevel = minLevel
    }
    
    /**
     Sets the terminator of a log line in the console. Typically "\n"
     - Parameter terminator: Typically "\n".
     */
    
    public class func setTerminator(terminator: String) {
        shared.terminator = terminator
    }
    
    /**
     Sets the separator of elements in the log message. Typically ", "
     - Parameter terminator: Typically "\n".
     */
    
    public class func setSeparator(separator: String) {
        shared.separator = separator
    }
    
    /**
     Registers the file of the caller to a specific minimum log level
     - Parameter level: the minimum log level to be associated with the file
     - Parameter filePath: **Should not be overwritten**. It's used to determine the filename of the caller
     */
    
    public class func registerFile(level: LogLevel, filePath: String = #file) {
        shared.registerFile(level, filePath: filePath)
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
    
    public class func debug(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Debug, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    public class func trace(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Trace, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    public class func info(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Info, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    public class func warn(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Warn, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    public class func error(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Error, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    public class func fatal(message: CVarArgType..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.Fatal, message: message, filePath: filePath, line: line, column: column, function: function)
    }
}