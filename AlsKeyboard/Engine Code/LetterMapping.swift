//
//  LetterMapping.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 16.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

struct LetterMapping {
    
    var allLetters: [String]
    var mapping: [[FacialExpression] : String]
    
    subscript(expressions: [FacialExpression]) -> String? {
        get {
            return self.mapping[expressions]
        }
    }
    
    var letterCount: Int {
        get {
            return self.allLetters.count
        }
    }
    
    var mappingCount: Int {
        get {
            return self.mapping.count
        }
    }
    
    var hasMappingForEachLetter: Bool {
        get {
            return !self.isEmptyMapping && self.mappingCount == self.letterCount
        }
    }
    
    var sortedLetters: [String] {
        get {
            return self.allLetters.sorted()
        }
    }
    
    
    var isEmptyMapping: Bool {
        get {
            return min(self.letterCount, self.mappingCount) == 0
        }
    }
    
    var minimumExpressionCount: Int {
        get {
            if self.isEmptyMapping {
                return 0
            }
            else {
                return self.mapping.keys.first!.count
            }
        }
    }
    
    func expressionsRequired(forLetter letterToLookFor:String) -> [FacialExpression] {
        
        for (expressions, letter) in self.mapping {
            if letter == letterToLookFor {
                return expressions
            }
        }
        
        return []
    }
    
    static func emptyMapping() -> LetterMapping {
        return LetterMapping(allLetters: [], mapping: [:])
    }
    
}
