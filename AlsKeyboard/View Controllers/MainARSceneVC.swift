//
//  MainARSceneVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 22.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit
import ARKit

class MainARSceneVC: UIViewController, ARSessionDelegate, KeyboardDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var facialMovesLabel: UILabel!
    @IBOutlet var charactersLabel: UILabel!
    
    private var engine: ALSEngine?
    
    var moveDetector: MoveDetector {
        get {
            return (self.engine?.moveDetector)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.engine = ALSEngine(withKeyboardDelegate: self)
        
        self.sceneView.scene = SCNScene()
        self.sceneView.rendersContinuously = true
        self.sceneView.session.delegate = self
        self.sceneView.automaticallyUpdatesLighting = true
        
        let faceTrackingConfiguration = ARFaceTrackingConfiguration()
        faceTrackingConfiguration.isLightEstimationEnabled = true
        self.sceneView.session.run(faceTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - ARSessionDelegate methods
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {}
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {}

    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        
        let mostLikelyMoves = faceAnchor.blendShapes.filter({$0.1.floatValue >= 0.7}).map({ "\($0.0.rawValue) - \($0.1.floatValue)" })
        
        if let mostLikelyMove = mostLikelyMoves.first {
            print("\(Date().timeIntervalSince1970) - \(mostLikelyMove)")
        }
        
        let convertedInput = Dictionary(uniqueKeysWithValues: faceAnchor.blendShapes.map({ ($0.0.rawValue, $0.1.floatValue) }))
        let facialMoves = self.moveDetector.detectMoves(fromInput: FaceInputData(faceAnchors: convertedInput))
        self.engine?.keyboardEngine.process(facialMove: facialMoves.first!)
    }

    public func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {}
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            print("The AR session failed: \(errorMessage)")
        }
    }
    
    func displayTextUpdated(value: String) {
        DispatchQueue.main.async {}
    }
    
    func displayReceivedCommand(value: String) {
        DispatchQueue.main.async {}
    }
    
    func clearCommandBuffer() { }
    
    func deleteFirstCommandFromBuffer() {}
    
    func addLabelToView(value: String) {
        DispatchQueue.main.async {}
    }

}
