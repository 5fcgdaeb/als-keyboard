//
//  ALSEngine.swift
//  ExpressionRecognition
//
//  Created by Guven Bolukbasi on 20/04/2017.
//
//

class ALSEngine {

    static var arkitSupported: Bool = false
    let moveDetector: MoveDetector
    let keyboardEngine: FacialMoveKeyboard
    
    private init(withARKitEnabled arkitEnabled: Bool=true) {
        
        if arkitEnabled {
            self.moveDetector = ARKitMoveDetector()
        }
        else {
            self.moveDetector = VisionKitMoveDetector()
        }
        
        self.keyboardEngine = SimpleKeyboard(withMoveDetector: self.moveDetector)
    }
    
    static var engine: ALSEngine? = .none
    
    class func shared() -> ALSEngine {
        
        if ALSEngine.engine == nil {
             ALSEngine.engine = ALSEngine(withARKitEnabled: ALSEngine.arkitSupported)
        }
        return ALSEngine.engine!
    }
    
    
}
