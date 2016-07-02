//
//  LogLevelTests.swift
//  Demo
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogLevelTests: XCTestCase {
    func testEquality() {
        
        let all = Logger.LogLevel.All
        let off = Logger.LogLevel.Off
        
        XCTAssertNotEqual(all, off)
        XCTAssertFalse(all == off)
        
        XCTAssertTrue(all == Logger.LogLevel.All)
        XCTAssertTrue(all == all)
        XCTAssertTrue(off == Logger.LogLevel.Off)
        XCTAssertTrue(off == off)
        XCTAssertTrue(all != off)
    }
    
    func testLessThan() {
        let all = Logger.LogLevel.All
        let off = Logger.LogLevel.Off
        
        XCTAssertTrue(all < off)
        XCTAssertFalse(off < all)
        XCTAssertTrue(all <= off)
    }
    
    func testMoreThan() {
        let all = Logger.LogLevel.All
        let off = Logger.LogLevel.Off
        
        XCTAssertTrue(off > all)
        XCTAssertTrue(off >= all)
        XCTAssertFalse(all >= off)
    }
    
    func testStringConvertible() {
        let values = ["All", "Debug", "Trace", "Info", "Warn", "Error", "Fatal", "Off"]
        
        for i in 0..<values.count {
            XCTAssertEqual(Logger.LogLevel(rawValue: i)?.description, values[i])
        }
    }
    
    func testLogPriorities() {
        //        ALL < DEBUG < TRACE < INFO < WARN < ERROR < FATAL < OFF.
        XCTAssertTrue(
            Logger.LogLevel.All < Logger.LogLevel.Debug &&
                Logger.LogLevel.Debug < Logger.LogLevel.Trace &&
                Logger.LogLevel.Trace < Logger.LogLevel.Info &&
                Logger.LogLevel.Info < Logger.LogLevel.Warn &&
                Logger.LogLevel.Warn < Logger.LogLevel.Error &&
                Logger.LogLevel.Error < Logger.LogLevel.Fatal &&
                Logger.LogLevel.Fatal < Logger.LogLevel.Off)
    }
    
}
