//
//  FacialExpression.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 24.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

public enum FacialExpression: String {
    
    case eyebrowMove
    case lookLeft
    case lookRight
    case blink
    case longBlink
    case jawMove
    case smile
    
    func coolDescription() -> String {
        switch self {
        case .eyebrowMove:
            return "😟"
        case .lookLeft:
            return "👀"
        case .lookRight:
            return "😜"
        case .blink:
            return "☺️"
        case .longBlink:
            return "😑"
        case .jawMove:
            return "😮"
        case .smile:
            return "😁"
        }
    }
}

extension Array: Hashable where Element == FacialExpression {
    
    func expressionListDescription () -> String {
        return self.reduce("", { $0 + $1.rawValue })
    }
    
    public var hashValue: Int {
        return self.expressionListDescription().hashValue
    }
}

