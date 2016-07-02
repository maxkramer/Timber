//
//  String+FileExtensionsTests.swift
//  Demo
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class String_FileExtensionsTests: XCTestCase {
    
    let filePath = "/Users/Max/Desktop/Logger/Demo/Demo/ViewController.swift"
    
    func testLastPathComponent() {
        let fileName = filePath.lastPathComponent
        XCTAssertEqual(fileName, "ViewController.swift")
    }
    
    func testRemovePathExtension() {
        let withoutPathExtension = filePath.stringByDeletingPathExtension
        XCTAssertEqual(withoutPathExtension, "/Users/Max/Desktop/Logger/Demo/Demo/ViewController")
    }
}
