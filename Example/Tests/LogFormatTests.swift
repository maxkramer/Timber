//
//  DemoTests.swift
//  DemoTests
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogFormatTests: XCTestCase {
    
    func testLogFormat() {
        let attributes: [LogFormatter.Attributes] = [ // same as defaultLogFormat
            LogFormatter.Attributes.Level,
            LogFormatter.Attributes.Date(format: "HH:mm:ss"),
            LogFormatter.Attributes.FileName(fullPath: false, fileExtension: true),
            LogFormatter.Attributes.Line,
            LogFormatter.Attributes.Message
        ]
        
        let template = "[%@ %@ %@:%@] %@"
        
        let logFormat = LogFormat(template: template, attributes: attributes)
        
        XCTAssertEqual(template, logFormat.template)
        XCTAssertNotNil(logFormat.template)
        XCTAssertNotNil(logFormat.attributes)
        
        XCTAssertEqual(attributes.count, logFormat.attributes!.count)
    }
    
    func testEquatable() {
        let attributes: [LogFormatter.Attributes] = [ // same as defaultLogFormat
            LogFormatter.Attributes.Level,
            LogFormatter.Attributes.Date(format: "HH:mm:ss"),
            LogFormatter.Attributes.FileName(fullPath: false, fileExtension: true),
            LogFormatter.Attributes.Line,
            LogFormatter.Attributes.Message
        ]
        
        let template = "[%@ %@ %@:%@] %@"
        XCTAssertEqual(LogFormat(template: template, attributes: attributes), LogFormat(template: template, attributes: attributes))
        XCTAssertNotEqual(LogFormat(template: template, attributes: nil), LogFormat(template: template, attributes: attributes))
        
        let otherTemplate = "ARNOLD SCHWARTZERNEGGER"
        XCTAssertNotEqual(LogFormat(template: otherTemplate, attributes: attributes), LogFormat(template: template, attributes: attributes))
        
        let otherAttributes: [LogFormatter.Attributes] = [ // same as defaultLogFormat
            LogFormatter.Attributes.Level,
            LogFormatter.Attributes.Date(format: "HH:mm:ss"),
            LogFormatter.Attributes.FileName(fullPath: true, fileExtension: true),
            LogFormatter.Attributes.Line,
            LogFormatter.Attributes.Message
        ]
        
        XCTAssertNotEqual(LogFormat(template: template, attributes: otherAttributes), LogFormat(template: template, attributes: attributes))
    }
}
