//
//  Logger+SingletonTests.swift
//  Demo
//
//  Created by Max Kramer on 02/07/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class Logger_SingletonTests: XCTestCase {

    func testSetFormat() {
        let format = LogFormat(template: "%@ %@", attributes: [LogFormatter.Attributes.Level, LogFormatter.Attributes.Level])
        Logger.setFormat(format)
        
        XCTAssertEqual(Logger.shared.logFormat, format)
    }
    
    func testSetEnabled() {
        Logger.setEnabled(true)
        XCTAssertEqual(Logger.shared.enabled, true)
        
        Logger.setEnabled(false)
        XCTAssertEqual(Logger.shared.enabled, false)
    }
    
    func testSetMinLevel() {
        Logger.setMinLevel(.All)
        XCTAssertEqual(Logger.shared.minLevel, Logger.LogLevel.All)
        
        Logger.setMinLevel(.Warn)
        XCTAssertEqual(Logger.shared.minLevel, Logger.LogLevel.Warn)
    }
    
    func testSetTerminator() {
        let terminator = "\n"
        Logger.setTerminator(terminator)
        
        XCTAssertEqual(Logger.shared.terminator, terminator)
    }
    
    func testSetSeparator() {
        let separator = "\n"
        Logger.setSeparator(separator)
        
        XCTAssertEqual(Logger.shared.separator, separator)
    }
    
    func performTestWithExpectedLogLevel(expectedLogLevel: Logger.LogLevel) {
        let expectation = expectationWithDescription(NSUUID().UUIDString + ": \(expectedLogLevel)")
        
        let logMessage = NSUUID().UUIDString
        
        let localLogger = StubbedLogger(loggedBlock: { level, message, _, _, _, _ in
            XCTAssertEqual(level, expectedLogLevel)
            XCTAssertEqual(message.first as? String, logMessage)
            expectation.fulfill()
        })
        
        Logger.shared = localLogger
        
        switch expectedLogLevel {
        case .Debug:
            Logger.debug(logMessage)
            break
        case .Error:
            Logger.error(logMessage)
            break
        case .Fatal:
            Logger.fatal(logMessage)
            break
        case .Info:
            Logger.info(logMessage)
            break
        case .Trace:
            Logger.trace(logMessage)
            break
        case .Warn:
            Logger.warn(logMessage)
            break
        default:
            expectation.fulfill()
            break
        }
        
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testAllLogLevel() {
        performTestWithExpectedLogLevel(.All)
    }
    
    func testDebugLogLevel() {
        performTestWithExpectedLogLevel(.Debug)
    }
    
    func testTraceLogLevel() {
        performTestWithExpectedLogLevel(.Trace)
    }
    
    func testInfoLogLevel() {
        performTestWithExpectedLogLevel(.Info)
    }
    
    func testWarnLogLevel() {
        performTestWithExpectedLogLevel(.Warn)
    }
    
    func testErrorLogLevel() {
        performTestWithExpectedLogLevel(.Error)
    }
    
    func testFatalLogLevel() {
        performTestWithExpectedLogLevel(.Fatal)
    }
}
