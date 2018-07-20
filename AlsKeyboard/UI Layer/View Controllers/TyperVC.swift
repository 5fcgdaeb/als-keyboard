//
//  TyperVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 5.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class TyperVC: UIViewController {
    
    @IBOutlet var move1View: DetectedExpressionView!
    @IBOutlet var move2View: DetectedExpressionView!
    
    @IBOutlet var typedText: UITextView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var startStopButton: UIButton!
    
    private var moveDetector: MoveDetector {
        get {
            return ALSEngine.shared().moveDetector
        }
    }
    
    private var keyboard: FacialMoveKeyboard {
        get {
            return ALSEngine.shared().keyboardEngine
        }
    }
    
    private var moveReceived: (FacialMove) -> () = { facialMove in }
    private var keyboardEventReceived: (String) -> () = { character in }
    
    private var isListeningToEngineEvents: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUIElements()
        self.initializeEngineHandlers()
        self.activateCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.switchToPausingState()
        
    }
    
    @IBAction func resetTapped(_ sender: UIControl) {
        self.clearOutTypedText()
    }
    
    @IBAction func startOrPauseTapped(_ sender: UIControl) {
        
        if self.isListeningToEngineEvents {
            self.switchToPausingState()
        }
        else {
            self.switchToTypingState()
        }
    }
    
    @IBAction func unwindToViewControllerNameHere(segue: UIStoryboardSegue) {}
    
    // MARK: - Private methods
    
    private func activateCamera() {
        
        var storyboard: UIStoryboard? = .none

        if ALSEngine.arkitSupported { // Use ARKit 1.5 FaceTrackingConfiguration + TrueDepth Camera
            storyboard = UIStoryboard(name: "ARSceneKit", bundle: nil)
        }
        else { // Use Vision Framework
            storyboard = UIStoryboard(name: "VisionKit", bundle: nil)
        }
        
        let controller = storyboard?.instantiateInitialViewController()
        self.embed(viewController: controller!)
    }
    
    private func embed(viewController controller: UIViewController) {
        
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    
    // MARK: UI Elements Logic
    
    private func initializeUIElements() {
        
        self.clearOutTypedText()
        self.statusLabel.text = NSLocalizedString("initial_status", tableName: "UI_Texts", comment: "")
    }
    
    private func switchToTypingState() {
        self.isListeningToEngineEvents = true
        self.startListeningToEngineEvents()
        self.statusLabel.text = NSLocalizedString("tracking_status", tableName: "UI_Texts", comment: "")
        self.startStopButton.setTitle("Pause", for: .normal)
    }
    
    private func switchToPausingState() {
        self.isListeningToEngineEvents = false
        self.stopListeningToEngineEvents()
        self.statusLabel.text = NSLocalizedString("paused_status", tableName: "UI_Texts", comment: "")
        self.startStopButton.setTitle("Start", for: .normal)
    }
    
    private func clearOutTypedText() {
        self.typedText.text = ""
    }
    
    // MARK: Engine Interaction Logic
    
    private func initializeEngineHandlers() {
        
        self.moveReceived = { [unowned self] facialMove in
            DispatchQueue.main.async {
                
                print("TyperVC received move")
                
                if !self.move1View.containsMove() {
                    self.move1View.update(withDetectedMove: facialMove)
                }
                else {
                    self.move2View.update(withDetectedMove: facialMove)
                }
            }
        }
        
        self.keyboardEventReceived = { [unowned self] character in
            DispatchQueue.main.async {
                
                print("TyperVC received keyboard")
                self.typedText.text = self.typedText.text + character
                
                self.move1View.moveConsumed()
                self.move2View.moveConsumed()
            }
        }
    }
    
    private func startListeningToEngineEvents() {
        
        self.moveDetector.listenForMoves(withListenerId: "TyperVC", andWithHandler: self.moveReceived)
        self.keyboard.listenForKeyboardEvents(withListenerId: "TyperVC", andWithHandler: self.keyboardEventReceived)
    }
    
    private func stopListeningToEngineEvents() {
        
        self.moveDetector.stopListeningMoves(forListenerId: "TyperVC")
        self.keyboard.stopListeningEvents(forListenerId: "TyperVC")
    }
    
    
    
 

}
