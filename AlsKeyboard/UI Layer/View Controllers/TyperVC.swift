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
    
    @IBOutlet var charactersLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    private var engine: ALSEngine?
    
    private var moveDetector: MoveDetector {
        get {
            return (self.engine?.moveDetector)!
        }
    }
    
    private var keyboard: FacialMoveKeyboard {
        get {
            return (self.engine?.keyboardEngine)!
        }
    }
    
    private var moveReceived: (FacialMove) -> () = { facialMove in }
    private var keyboardEventReceived: (String) -> () = { character in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLabels()
        self.activateCamera()
    }
    
    @IBAction func resetTapped(_ sender: UIControl) {
        self.initializeLabels()
    }
    
    @IBAction func startTapped(_ sender: UIControl) {
        self.integrateToALSEngine()
        self.statusLabel.text = NSLocalizedString("tracking_status", tableName: "UI_Texts", comment: "")
        
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
    
    
    private func integrateToALSEngine() {
        
        self.engine = ALSEngine.shared()
        
        self.moveReceived = { [unowned self] facialMove in
            DispatchQueue.main.async {
                
                print("VC received move")
                
                if !self.move1View.containsMove() {
                    self.move1View.update(withDetectedMove: facialMove)
                }
                else {
                    self.move2View.update(withDetectedMove: facialMove)
                }
            }
        }
        self.moveDetector.listenForMoves(withHandler: self.moveReceived)
        
        self.keyboardEventReceived = { [unowned self] character in
            DispatchQueue.main.async {
                
                print("VC received keyboard")
                self.charactersLabel.text = self.charactersLabel.text! + character
                
                UIView.animate(withDuration: 0.6, animations: {
                    self.move1View.reset()
                    self.move2View.reset()
                })
            }
        }
        self.keyboard.listenForKeyboardEvents(withHandler: self.keyboardEventReceived)
    }
    
    private func initializeLabels() {
        
        self.move1View.reset()
        self.move2View.reset()
        
        self.charactersLabel.text = ""
        self.statusLabel.text = NSLocalizedString("initial_status", tableName: "UI_Texts", comment: "")
    }
 

}
