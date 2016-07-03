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
    
    func fulfillAfter(expectation: XCTestExpectation, time: Double = 4) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            expectation.fulfill()
        }
    }
    
    func testDisabledLoggerDoesntLog() {
        let logger = Logger()
        let pipe = NSPipe()

        logger.pipe = pipe
        logger.enabled = false
        logger.useCurrentThread = true

        let writtenData = "written data".dataUsingEncoding(NSUTF8StringEncoding)!
        logger.pipe!.fileHandleForWriting.writeData(writtenData)

        logger.debug("Test message")

        XCTAssertEqual(logger.pipe!.fileHandleForReading.availableData.length, writtenData.length)
    }
    
    func testSettingFileLogLevelDoesntReceiveLog() {
        let logger = Logger()
        let pipe = NSPipe()
        
        logger.pipe = pipe
        logger.useCurrentThread = true
        
        logger.registerFile(.Fatal)
        
        let writtenData = "written data".dataUsingEncoding(NSUTF8StringEncoding)!
        logger.pipe!.fileHandleForWriting.writeData(writtenData)
        
        logger.error("This should not be logged")
        
        XCTAssertEqual(logger.pipe!.fileHandleForReading.availableData.length, writtenData.length)
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
