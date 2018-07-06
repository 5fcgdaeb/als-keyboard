//
//  MappingGenerator.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 6.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

struct MappingGenerator {
    
    private var a: Int = 0
    
    func generateMapping(fromEasyToHardExpressions expressions: [FacialExpression]) -> [[FacialExpression]: String] {
        
        guard expressions.count > 1 else { return [:] }
        
        return [:]
    }
    
}
