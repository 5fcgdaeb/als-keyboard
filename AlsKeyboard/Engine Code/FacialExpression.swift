//
//  Expression.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 22.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

enum FacialExpression: String {
    case eyebrowMove = "EE"
    case lookLeft = "LL"
    case lookRight = "LR"
    case blink = "BL"
    case jawMove = "jM"
    
    func coolDescription() -> String {
        switch self {
        case .blink:
            return "☺️"
        case .eyebrowMove:
            return "😟"
        case .lookLeft:
            return "👀"
        case .lookRight:
            return "😜"
        case .jawMove:
            return "😄"
        }
    }
}
