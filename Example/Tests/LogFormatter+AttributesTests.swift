//
//  LogFormatter+AttributesTests.swift
//  Demo
//
//  Created by Max Kramer on 23/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogFormatter_AttributesTests: XCTestCase {
    func testEquatable() {
        XCTAssertEqual(LogFormatter.Attributes.Level, LogFormatter.Attributes.Level)
        XCTAssertEqual(LogFormatter.Attributes.FileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.FileName(fullPath: true, fileExtension: true))
        XCTAssertEqual(LogFormatter.Attributes.Date(format: "HH:mm:ss"), LogFormatter.Attributes.Date(format: "HH:mm:ss"))
        
        XCTAssertNotEqual(LogFormatter.Attributes.Level, LogFormatter.Attributes.Message)
        XCTAssertNotEqual(LogFormatter.Attributes.FileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.FileName(fullPath: false, fileExtension: true))
        XCTAssertNotEqual(LogFormatter.Attributes.Date(format: "HH:mm:ss"), LogFormatter.Attributes.Date(format: "hH:mm:ss"))
        XCTAssertNotEqual(LogFormatter.Attributes.FileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.Function)
    }
}
