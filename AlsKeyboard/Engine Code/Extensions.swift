//
//  Extensions.swift
//  ExpressionRecognition
//
//  Created by MacbookPro on 7.04.2017.
//
//

import Foundation

extension Command: Equatable {}

func ==(lhs: Command, rhs: Command) -> Bool {
    return lhs.commandID == rhs.commandID && lhs.shortCode == rhs.shortCode
}

extension Date {

    func alsFriendlyDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "ss.SSSS"
        return df.string(from: self)
    }
    
    var millisecondsSince1970 : Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
