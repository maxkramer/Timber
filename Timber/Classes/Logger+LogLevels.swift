//
//  Logger+LogLevels.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension Logger {
    /**
     See [https://logging.apache.org/log4j/2.0/manual/architecture.html](Apache Log4j architecture) for more info
     
     - ALL:	All levels including custom levels.
     - DEBUG: Designates fine-grained informational events that are most useful to debug an application.
     - ERROR: Designates error events that might still allow the application to continue running.
     - FATAL: Designates very severe error events that will presumably lead the application to abort.
     - INFO: Designates informational messages that highlight the progress of the application at coarse-grained level.
     - OFF: The highest possible rank and is intended to turn off logging.
     - TRACE: Designates finer-grained informational events than the DEBUG.
     - WARN: Designates potentially harmful situations.
     
     ALL < DEBUG < TRACE < INFO < WARN < ERROR < FATAL < OFF.
     
     A log request of level p in a logger with level q is enabled if p >= q
     */
    
    public enum LogLevel: Int, CustomStringConvertible {
        case All = 0
        case Debug
        case Trace
        case Info
        case Warn
        case Error
        case Fatal
        case Off
        
        /**
         Converts the LogLevel into a string
         - Returns: The name of the log level as a string
         */
        
        public var description: String {
            switch self {
            case .All:
                return "All"
            case .Debug:
                return "Debug"
            case .Trace:
                return "Trace"
            case .Info:
                return "Info"
            case .Warn:
                return "Warn"
            case .Error:
                return "Error"
            case .Fatal:
                return "Fatal"
            case .Off:
                return "Off"
            }
        }
    }
}

extension Logger.LogLevel: Comparable {}

/**
 Compares the left hand side to the right hand side
 - Returns: TRUE if equal, FALSE if not
 */

public func ==(lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

/**
 Compares the left hand side to the right hand side
 - Returns: TRUE if lhs < rhs, FALSE if not
 */

public func <(lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

/**
 Compares the left hand side to the right hand side
 - Returns: TRUE if lhs > rhs, FALSE if not
 */

public func >(lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
    return lhs.rawValue > rhs.rawValue
}

/**
 Compares the left hand side to the right hand side
 - Returns: TRUE if lhs >= rhs, FALSE if not
 */

public func >=(lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}

/**
 Compares the left hand side to the right hand side
 - Returns: TRUE if lhs <= rhs, FALSE if not
 */

public func <=(lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
    return lhs.rawValue <= rhs.rawValue
}
