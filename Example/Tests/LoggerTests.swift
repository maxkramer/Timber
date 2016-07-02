//
//  LoggerTests.swift
//  Demo
//
//  Created by Max Kramer on 23/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class StubbedLogger: Logger {
    
    typealias LoggedBlock = (level: Logger.LogLevel, message: [CVarArgType], filePath: String, line: Int, column: Int, function: String) -> ()
    
    let loggedBlock: LoggedBlock
    init(loggedBlock: LoggedBlock) {
        self.loggedBlock = loggedBlock
    }
    
    override func log(level: Logger.LogLevel, message: [CVarArgType], filePath: String, line: Int, column: Int, function: String) {
        loggedBlock(level: level, message: message, filePath: filePath, line: line, column: column, function: function)
    }
}

class LoggerTests: XCTestCase {
    
    /*
     These tests make the assumption that the logger will indeed trigger print statements if a pipe is not used
     */
    
    func testInitialisers() {
        let logFormat = LogFormat.defaultLogFormat
        let logger1 = Logger(minLevel: .All, logFormat: logFormat)
        
        XCTAssertEqual(logger1.minLevel, Logger.LogLevel.All)
        XCTAssertEqual(logger1.logFormat, logFormat)
        
        let logger2 = Logger(minLevel: .Debug)
        XCTAssertEqual(logger2.minLevel, Logger.LogLevel.Debug)
    }
    
    func fulfillAfter(expectation: XCTestExpectation, time: Int = 4) {
        dispatch_after(UInt64(time) * NSEC_PER_SEC, dispatch_get_main_queue()) {
            expectation.fulfill()
        }
    }
    
    func testDisabledLoggerDoesntLog() {
        let pipe = NSPipe()
        let localLogger = Logger()
        
        localLogger.pipe = pipe
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        // Setup the expectation to wait for the notification
        
        let expectation = expectationForNotification(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading, handler: { notif -> Bool in
            // A notification should not be received
            // Throw an assertion if the notification is received
            XCTAssertTrue(true == false)
            return false
        })
        
        localLogger.enabled = true
        
        // Log some data
        localLogger.debug("This should not be logged")
        
        // Gives 4 seconds for a notification to be received and for the test to fail, and otherwises fulfils it, acknowledging that a notification was not received
        fulfillAfter(expectation)
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testSettingFileLogLevelDoesntReceiveLog() {
        let pipe = NSPipe()
        let localLogger = Logger()
        
        localLogger.pipe = pipe
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        localLogger.registerFile(.Error)
        
        // Setup the expectation to wait for the notification
        
        let expectation = expectationForNotification(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading, handler: { notif -> Bool in
            // A notification should not be received 
            // Throw an assertion if the notification is received
            XCTAssertTrue(true == false)
            return false
        })
        
        // Log some data
        localLogger.debug("This should not be logged")
        
        // Gives 4 seconds for a notification to be received and for the test to fail, and otherwises fulfils it, acknowledging that a notification was not received
        fulfillAfter(expectation)
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testSettingFileLogLevelReceivesLog() {
        let pipe = NSPipe()
        let localLogger = Logger()
        
        localLogger.pipe = pipe
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        expectationForNotification(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading) { notification -> Bool in
            guard let fh = notification.object as? NSFileHandle else {
                return false
            }
            
            let data = fh.availableData
            XCTAssertTrue(data.length > 0)
            XCTAssertTrue(String(data: data, encoding: NSUTF8StringEncoding)!.containsString("This should be logged"))
            
            return true
        }
        
        localLogger.registerFile(.Error)
        
        // Log some data
        localLogger.error("This should be logged")
        
        // Wait for the expectation to be fulfilled
        waitForExpectationsWithTimeout(5) { _ in }
    }
    
    func performTestWithExpectedLogLevel(expectedLogLevel: Logger.LogLevel) {
        let expectation = expectationWithDescription(NSUUID().UUIDString + ": \(expectedLogLevel)")
        
        let logMessage = NSUUID().UUIDString
        
        let localLogger = StubbedLogger(loggedBlock: { level, message, _, _, _, _ in
            XCTAssertEqual(level, expectedLogLevel)
            XCTAssertEqual(message.first as? String, logMessage)
            expectation.fulfill()
        })
        
        switch expectedLogLevel {
        case .Debug:
            localLogger.debug(logMessage)
            break
        case .Error:
            localLogger.error(logMessage)
            break
        case .Fatal:
            localLogger.fatal(logMessage)
            break
        case .Info:
            localLogger.info(logMessage)
            break
        case .Trace:
            localLogger.trace(logMessage)
            break
        case .Warn:
            localLogger.warn(logMessage)
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
