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
        case .jawMove:
            return "😮"
        case .smile:
            return "😁"
        }
    }
    
    func shortDescription() -> String {
        switch self {
        case .eyebrowMove:
            return "Eyebrow Move"
        case .lookLeft:
            return "Look Left"
        case .lookRight:
            return "Look Right"
        case .blink:
            return "Blink"
        case .jawMove:
            return "Jaw Move"
        case .smile:
            return "Smile"
        }
    }
    
    func formalDescription() -> String {
        switch self {
        case .eyebrowMove:
            return "Moving the Eyebrow(s)"
        case .lookLeft:
            return "Looking Left"
        case .lookRight:
            return "Looking Right"
        case .blink:
            return "Blink"
        case .jawMove:
            return "Moving the Jaw"
        case .smile:
            return "Smiling"
        }
    }
    
    static let allValues = [FacialExpression.eyebrowMove, FacialExpression.lookLeft, FacialExpression.lookRight, FacialExpression.blink, FacialExpression.jawMove, FacialExpression.smile]
}

extension Array where Element == FacialExpression {
    
    func expressionListDescription () -> String {
        return self.map {$0.shortDescription()}.joined(separator: "-")
    }
    
    public var hashValue: Int {
        return self.expressionListDescription().hashValue
    }
}

