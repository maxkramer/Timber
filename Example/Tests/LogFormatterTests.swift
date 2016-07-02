//
//  LogFormatterTests.swift
//  Demo
//
//  Created by Max Kramer on 23/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogFormatterTests: XCTestCase {
    
    let arbitraryLine = #line
    let arbitraryColumn = #column
    let arbitraryFunction = "someFunction(_:)"
    let arbitraryFile = #file
    let arbitraryLogLevel: Logger.LogLevel = .All
    let arbitraryMessage = "some_message goes here"
    let arbitraryTerminator = ",<arnold schwartzernegger>"
    let arbitraryDateFormat = "dd/MM/YYYYTHH:mm:ss Z"
    
    var arbitraryLogFormat: LogFormat!
    var arbitraryLogFormatter: LogFormatter!
    
    override func setUp() {
        super.setUp()
        arbitraryLogFormat = logFormatForAllAttributes()
        arbitraryLogFormatter = LogFormatter(format: arbitraryLogFormat, logLevel: arbitraryLogLevel, filePath: arbitraryFile, line: arbitraryLine, column: arbitraryColumn, function: arbitraryFunction, message: arbitraryMessage, terminator: arbitraryTerminator)
    }
    
    override func tearDown() {
        arbitraryLogFormat = nil
        arbitraryLogFormatter = nil
        super.tearDown()
    }
    
    func logFormatForAllAttributes() -> LogFormat {
        let template = "[%@],[%@],[%@],[%@],[%@],[%@],[%@]"
        let logFormat = LogFormat(template: template, attributes: [
            LogFormatter.Attributes.Column,
            LogFormatter.Attributes.Date(format: arbitraryDateFormat),
            LogFormatter.Attributes.FileName(fullPath: false, fileExtension: false),
            LogFormatter.Attributes.Function,
            LogFormatter.Attributes.Level,
            LogFormatter.Attributes.Line,
            LogFormatter.Attributes.Message
            ])
        
        return logFormat
    }
    
    func testGeneratesValidObject() {
        let logFormat = logFormatForAllAttributes()
        
        // Ensure that all the properties are set and correctly so
        XCTAssertNotNil(arbitraryLogFormatter)
        XCTAssertEqual(arbitraryLogFormatter.logFormat.template, logFormat.template)
        XCTAssertEqual(arbitraryLogFormatter.logFormat.attributes!.count, logFormat.attributes!.count)
        XCTAssertEqual(arbitraryLogFormatter.logLevel, Logger.LogLevel.All)
        XCTAssertEqual(arbitraryLogFormatter.filePath, arbitraryFile)
        XCTAssertEqual(arbitraryLogFormatter.line, arbitraryLine)
        XCTAssertEqual(arbitraryLogFormatter.column, arbitraryColumn)
        XCTAssertEqual(arbitraryLogFormatter.function, arbitraryFunction)
        XCTAssertEqual(arbitraryLogFormatter.message, arbitraryMessage)
        XCTAssertEqual(arbitraryLogFormatter.terminator, arbitraryTerminator)
        
        // Testing that the date is non-nil should be good enough, as we can't ascertain the correct date
        XCTAssertNotNil(arbitraryLogFormatter.date)
    }
    
    func testReturnsCorrectMessage() {
        let logMessage = arbitraryLogFormatter.formattedLogMessage()
        
        // Separate the attributes out by ,
        var attributes = logMessage.componentsSeparatedByString(",")
        
        // The terminator exists as the last element, as we have purposely left a trailing comma in the log format
        // It needs to be removed in order to do the correct array comparison
        
        attributes.popLast()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = arbitraryDateFormat
        
        // Format the date as per the log format
        let expectedDate = dateFormatter.stringFromDate(arbitraryLogFormatter.date)
        
        // List the values we expect to exist at each index in the array
        let expectedAttributeValues = [
            "[\(arbitraryLogFormatter.column)]",
            "[\(expectedDate)]",
            "[\(arbitraryLogFormatter.filePath.lastPathComponent.stringByDeletingPathExtension)]",
            "[\(arbitraryLogFormatter.function)]",
            "[\(arbitraryLogFormatter.logLevel.description.uppercaseString)]",
            "[\(arbitraryLogFormatter.line)]",
            "[\(arbitraryLogFormatter.message)]"
        ]
        
        // Ensure that the number of items in both arrays are the same 
        // such that the number of elements received is the number of elements we expected to receive
        
        XCTAssertEqual(expectedAttributeValues.count, attributes.count)
        
        // Compare each of the expected attribute values to the attribute value found in the log message
        for (idx, attr) in attributes.enumerate() {
            XCTAssertEqual(attr, expectedAttributeValues[idx])
        }
        
        // Combine the expected attribute values as per the log format
        let expectedMessage = expectedAttributeValues.reduce("", combine: {
            if $0.0.characters.count == 0 {
                return $0.1
            }
            return $0.0 + ",\($0.1)"
        }) + arbitraryLogFormatter.terminator
        
        // Ensure that the generated log message and the one we have created are identical
        
        XCTAssertEqual(expectedMessage, logMessage)
        
        // Test that consecutive calls returns identical output
        XCTAssertEqual(arbitraryLogFormatter.formattedLogMessage(), arbitraryLogFormatter.formattedLogMessage())
    }
    
    func testReturnsMessageWithNilAttributes() {
        let message = "some message"
        
        let emptyFormat = LogFormat(template: "", attributes: nil)
        let logFormatter = LogFormatter(format: emptyFormat, logLevel: .All, filePath: #file, line: #line, column: #column, function: #function, message: message, terminator: "")
        XCTAssertEqual(logFormatter.formattedLogMessage(), message)
    }
    
    func testReturnsMessageWithNoAttributes() {
        let message = "some message"
        
        let emptyFormat = LogFormat(template: "", attributes: [])
        let logFormatter = LogFormatter(format: emptyFormat, logLevel: .All, filePath: #file, line: #line, column: #column, function: #function, message: message, terminator: "")
        XCTAssertEqual(logFormatter.formattedLogMessage(), message)
    }
    
    func testGeneratesCorrectReadableColumn() {
        let expectedOutput = String(arbitraryColumn)
        XCTAssertEqual(expectedOutput, arbitraryLogFormatter.readableColumn(arbitraryColumn))
    }
    
    func testGeneratesCorrectReadableDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = arbitraryDateFormat
        
        // Format the date as per the log format
        let expectedDate = dateFormatter.stringFromDate(arbitraryLogFormatter.date)
        XCTAssertEqual(expectedDate, arbitraryLogFormatter.readableDate(arbitraryLogFormatter.date, format: arbitraryDateFormat))
    }
    
    func testGeneratesCorrectReadableFileName() {
        let filePath = arbitraryFile
        
        // Test with both full path and file extension
        
        XCTAssertEqual(filePath, arbitraryLogFormatter.readableFileName(filePath, showFullPath: true, showFileExtension: true))
        
        // Test with full path and no file extension
        
        XCTAssertEqual(filePath.stringByDeletingPathExtension, arbitraryLogFormatter.readableFileName(filePath, showFullPath: true, showFileExtension: false))
        
        // Test without full path and file extension
        
        let expectedFilename = filePath.lastPathComponent.stringByDeletingPathExtension
        XCTAssertEqual(expectedFilename, arbitraryLogFormatter.readableFileName(filePath, showFullPath: false, showFileExtension: false))
    }
    
    func testGeneratesCorrectReadableFunctionName() {
        XCTAssertEqual(arbitraryFunction, arbitraryLogFormatter.readableFunction(arbitraryFunction))
    }
    
    func testGeneratesCorrectReadableLogLevel() {
        let expectedOutput = arbitraryLogLevel.description.uppercaseString
        XCTAssertEqual(expectedOutput, arbitraryLogFormatter.readableLogLevel(arbitraryLogLevel))
    }
    
    func testGeneratesCorrectLogLine() {
        XCTAssertEqual(String(arbitraryLine), arbitraryLogFormatter.readableLine(arbitraryLine))
    }
    
    func testGeneratesCorrectReadableMessage() {
        XCTAssertEqual(arbitraryMessage, arbitraryLogFormatter.readableMessage(arbitraryMessage))
    }
}
