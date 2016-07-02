//
//  String+FileExtensions.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     - Returns: A new string with the last path component of a url
     */
    public var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }
    
    /**
     - Returns: A new string with the path extension removed
     */
    public var stringByDeletingPathExtension: String {
        return NSString(string: self).stringByDeletingPathExtension
    }
}