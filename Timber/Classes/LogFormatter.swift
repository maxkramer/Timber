//
//  LogFormatter.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

/// Generates a log message formatted in accordance with the specified LogFormat
public class LogFormatter {
    
    /// The log format to be used
    public let logFormat: LogFormat
    
    /// The current log level
    public let logLevel: Logger.LogLevel
    
    /// The filePath of the initial log caller
    public let filePath: String
    
    /// Determines the line in the source code of the caller.
    public let line: Int
    
    /// Determines the column in the source code of the caller.
    public let column: Int
    
    /// Determines the function that triggered the call.
    public let function: String
    
    /// The log message as a string
    public let message: String
    
    /// Sets the terminator of a log line in the console.
    public let terminator: String
    
    /// The date/time of that the log request was made at
    public let date: NSDate = NSDate()
    
    /// The internal date formatter for the Attribute.date
    private let dateFormatter = NSDateFormatter()
    
    /**
     Initialises an instance of LogFormatter
     - Parameter format: The log format to be used
     - Parameter logLevel: The log level of the log message
     - Parameter filePath: The filePath of the initial log caller
     - Parameter line: The line in the source code of the caller.
     - Parameter column: The column in the source code of the caller.
     - Parameter function: The function that triggered the call.
     - Parameter message: The log message as a string
     - Parameter separator: The separator for consecutive statements
     - Parameter terminator: The terminator for each log line
     */
    
    public init(format: LogFormat, logLevel: Logger.LogLevel, filePath: String, line: Int, column: Int, function: String, message: String, terminator: String) {
        self.logFormat = format
        self.logLevel = logLevel
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function
        self.message = message
        self.terminator = terminator
    }
    
    /**
     Concatenates the specified attributes in the LogFormat and generates the final log message
     - Returns: The final log message that will appear in the console/log file
     */
    public func formattedLogMessage() -> String {
        guard let attributes = logFormat.attributes where attributes.count > 0 else {
            return message
        }
        
        let convertedAttributes = attributes.map { attribute -> CVarArgType in
            switch attribute {
            case .Level:
                return readableLogLevel(logLevel)
            case .FileName(let fullPath, let fileExtension):
                return readableFileName(filePath, showFullPath: fullPath, showFileExtension: fileExtension)
            case .Line:
                return readableLine(line)
            case .Column:
                return readableColumn(column)
            case .Function:
                return readableFunction(function)
            case .Message:
                return readableMessage(message)
            case .Date(let format):
                return readableDate(date, format: format)
            }
        }
        return String(format: logFormat.template + terminator, arguments: convertedAttributes)
    }
    
    /**
     Generates the string equivalent of the Log Level that will be used in the log message
     - Parameter logLevel: The log level that's going to be logged
     - Returns: A readable equivalent of the supplied log level
     */
    
    public func readableLogLevel(logLevel: Logger.LogLevel) -> String {
        return logLevel.description.uppercaseString
    }
    
    /**
     Generates the readable file path/name that will be used in the log message
     - Parameter filePath: The full file path
     - Parameter showFullPath: Whether or not the full path should be shown
     - Parameter showFileExtension: Whether or not the file extension should be shown
     - Returns: A formatted version of the file path
     */
    
    public func readableFileName(filePath: String, showFullPath: Bool, showFileExtension: Bool) -> String {
        var fileName = filePath
        if !showFullPath {
            fileName = fileName.lastPathComponent
        }
        if !showFileExtension {
            fileName = fileName.stringByDeletingPathExtension
        }
        return fileName
    }
    
    /**
     Generates the string equivalent of the line that will be used in the log message
     - Parameter line: The line that's going to be logged
     - Returns: A readable equivalent of the supplied line
     */
    
    public func readableLine(line: Int) -> String {
        return String(line)
    }
    
    /**
     Generates the string equivalent of the column that will be used in the log message
     - Parameter column: The column that's going to be logged
     - Returns: A readable equivalent of the supplied column
     */
    
    public func readableColumn(column: Int) -> String {
        return String(column)
    }
    
    /**
     Generates the string equivalent of the function that will be used in the log message
     - Parameter function: The function that's going to be logged
     - Returns: A readable equivalent of the supplied function
     */
    
    public func readableFunction(function: String) -> String {
        return function
    }
    
    /**
     Generates the string equivalent of the message that will be used in the log message
     - Parameter message: The message that's going to be logged
     - Returns: A formatted version of the supplied message
     */
    
    public func readableMessage(message: String) -> String {
        return message
    }
    
    /**
     Generates the formatted equivalent of the date that will be used in the log message
     - Parameter date: The date that's going to be logged
     - Returns: A readable & formatted equivalent of the supplied date
     */
    
    public func readableDate(date: NSDate, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
}