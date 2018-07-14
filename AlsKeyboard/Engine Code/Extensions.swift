//
//  Extensions.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 14.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import Foundation

extension String {
    
    public func pad(with padding: Character, toLength length: Int) -> String {
        
        let paddingWidth = length - self.count
        guard 0 < paddingWidth else { return self }
        
        return String(repeating: padding, count: paddingWidth) + self
    }
    
    public func characterAtIndex(index: Int) -> Character? {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur += 1
        }
        return nil
    }
}
