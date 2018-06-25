//
//  Expression.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 22.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

class FacialMove: Equatable, Hashable {
    
    let expression: FacialExpression
    let timestamp: Date
 
    init(_ type:FacialExpression) {
        self.expression = type
        self.timestamp = Date()
    }
    
    func secondsSince1970() -> TimeInterval {
        return self.timestamp.timeIntervalSince1970
    }
    
    // MARK: Hashable Protocol
    
    var hashValue: Int {
        return self.expression.hashValue ^ self.timestamp.hashValue &* 16777619
    }
    
    static func == (lhs: FacialMove, rhs: FacialMove) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
