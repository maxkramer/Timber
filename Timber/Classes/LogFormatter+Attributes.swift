//
//  LogFormatter+Attributes.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension LogFormatter {
    /**
     LogFormat construction attributes.
     
     - Level: The log level of the message
     - FileName: The file name of the file that triggered the log. `fullPath`: Should the full path of the file be logged? `fileExtension`: Should the file extension be logged?
     - Line: The line in the source code of the caller.
     - Column: The column in the source code of the caller.
     - Function: The function that triggered the call.
     - Message: The log message as a string
     - Date: The date & time that the log was triggered at. Format: the format of the date. See http://waracle.net/iphone-nsdateformatter-date-formatting-table/ for more info.
     */
    public enum Attributes{
        case Level
        case FileName(fullPath: Bool, fileExtension: Bool)
        case Line
        case Column
        case Function
        case Message
        case Date(format: String)
    }
}

extension LogFormatter.Attributes: Equatable {}

public func ==(lhs: LogFormatter.Attributes, rhs: LogFormatter.Attributes) -> Bool {
    switch (lhs, rhs) {
    case (.Level, .Level), (.Line, .Line), (.Column, .Column), (.Function, .Function), (.Message, .Message):
        return true
    case (let .FileName(fullPath: fp1, fileExtension: fe1), let .FileName(fullPath: fp2, fileExtension: fe2)):
        return fp1 == fp2 && fe1 == fe2
    case (let .Date(format: fmt1), let .Date(format: fm2)):
        return fmt1 == fm2
    default:
        return false
    }
}