//
//  MainARSceneVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 22.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit
import ARKit

class MainARSceneVC: UIViewController, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var facialMovesLabel: UILabel!
    @IBOutlet var charactersLabel: UILabel!
    
    private var engine: ALSEngine?
    
    private var moveDetector: MoveDetector {
        get {
            return (self.engine?.moveDetector)!
        }
    }
    
    private var moveReceived: (FacialMove) -> () = { facialMove in }
    private var keyboardEventReceived: (String) -> () = { character in }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.integrateToALSEngine()
        self.startUpSceneKit()
    }
    
    // MARK: - UI Outlets
    
    @IBAction func settingsTapped(_ sender: UIControl) {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        viewController?.modalPresentationStyle = .overCurrentContext
        self.present(viewController!, animated: true, completion: nil)
    }
    
    // MARK: - ARSessionDelegate methods
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {}
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {}

    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        
        let convertedInput = Dictionary(uniqueKeysWithValues: faceAnchor.blendShapes.map({ ($0.0.rawValue, $0.1.floatValue) }))
        let faceInput = FaceInputData(faceAnchors: convertedInput)
        self.moveDetector.feed(faceData: faceInput)
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
    
    // MARK: - Private methods
    private func integrateToALSEngine() {
        
        self.engine = ALSEngine.shared()
        self.moveReceived = { [unowned self] facialMove  in
            DispatchQueue.main.async {
                self.facialMovesLabel.text = self.facialMovesLabel.text! + facialMove.expression.coolDescription()
            }
        }
        self.moveDetector.listenForMoves(withHandler: self.moveReceived)
    }
    
    private func startUpSceneKit() {
        
        self.sceneView.scene = SCNScene()
        self.sceneView.rendersContinuously = true
        self.sceneView.session.delegate = self
        self.sceneView.automaticallyUpdatesLighting = true
        
        let faceTrackingConfiguration = ARFaceTrackingConfiguration()
        faceTrackingConfiguration.isLightEstimationEnabled = true
        self.sceneView.session.run(faceTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        
    }

}
