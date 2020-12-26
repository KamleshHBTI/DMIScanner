//
//  StringExtension.swift
//  VisionKitTesting
//
//  Created by Surjeet Rajput on 25/12/20.
//  Copyright © 2020 indiGo. All rights reserved.
//

import Foundation

let numberPlateRegex: String = "[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}"

extension String {
    
    var isValidNumberPlate : Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: numberPlateRegex )
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var removeSpaces : String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
}

//HR 26DR 1738
