//
//  LetterMappingTests.swift
//  AlsKeyboardTests
//
//  Created by Guven Bolukbasi on 16.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import XCTest

class LetterMappingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIsEmptyProperty() {
        
        let map1 = LetterMapping(allLetters: [], mapping: [:])
        XCTAssertTrue(map1.isEmptyMapping)
        
        let map2 = LetterMapping(allLetters: ["a", "c"], mapping: [[.blink]:"a"])
        XCTAssertFalse(map2.isEmptyMapping)
        XCTAssertFalse(map2.hasMappingForEachLetter)
        
        let map3 = LetterMapping(allLetters: ["a", "c"], mapping: [[.blink]:"a", [.jawMove]: "c"])
        XCTAssertFalse(map3.isEmptyMapping)
        XCTAssertTrue(map3.hasMappingForEachLetter)
    }
    
    func testSubscript() {
        
        let map2 = LetterMapping(allLetters: ["a", "c"], mapping: [[.blink]:"a"])
        XCTAssertTrue(map2[[.blink]] == "a")
    }
    
    func testLetterFunctions() {
        
        let map2 = LetterMapping(allLetters: ["b", "a", "c"], mapping: [[.blink]:"a"])
        XCTAssertTrue(map2.letterCount == 3)
        
        let sorted = map2.sortedLetters
        XCTAssertTrue(sorted[0] == "a")
    }
    
    func testMinimumExpressionCount() {
        
        let map2 = LetterMapping(allLetters: ["b", "a", "c"], mapping: [[.blink]: "a", [.jawMove]: "c"])
        XCTAssertTrue(map2.minimumExpressionCount == 1)
    }
    
}
