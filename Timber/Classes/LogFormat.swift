//
//  LogFormat.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

/// Specifies the format to be used in the log message
public struct LogFormat {
    /// The template string that contains how the log message should be formatted
    public let template: String
    
    /// The attributes to be used in the log message
    public let attributes: [LogFormatter.Attributes]?
    
    /**
     Initialises an instance of LogFormat
     - Parameter template: The template string that contains how the log message should be formatted
     - Parameter attributes: The attributes to be used in the log message
     */
    
    public init(template: String, attributes: [LogFormatter.Attributes]?) {
        self.template = template
        self.attributes = attributes
    }
    
    /**
     The default log format
     Logs will appear in the following format, in accordance with the specified template:
     `i.e. [FATAL 16:12:24 ViewController.swift:21] ["TIFU by force unwrapping a nil optional"]`
     */
    
    public static var defaultLogFormat = LogFormat(template: "[%@ %@ %@:%@] %@", attributes: [
        LogFormatter.Attributes.Level,
        LogFormatter.Attributes.Date(format: "HH:mm:ss"),
        LogFormatter.Attributes.FileName(fullPath: false, fileExtension: true),
        LogFormatter.Attributes.Line,
        LogFormatter.Attributes.Message
        ])
}

extension LogFormat: Equatable {}

public func ==(lhs: LogFormat, rhs: LogFormat) -> Bool {
    guard lhs.template == rhs.template else {
        return false
    }
    
    guard let lhsAttr = lhs.attributes, rhsAttr = rhs.attributes where lhsAttr.count == rhsAttr.count else {
        return false
    }
    
    var equalFlag = true
    for (idx, attr) in lhsAttr.enumerate() {
        if attr != rhsAttr[idx] {
            equalFlag = false
            break
        }
    }
    
    return equalFlag
}