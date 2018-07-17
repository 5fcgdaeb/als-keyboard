//
//  DetectedExpressionView.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 17.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class DetectedExpressionView: UIView {
    
    var expressionLabel: UILabel!
    var descriptiveLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
        
        self.createAndAddExpressionLabel()
        self.createAndAddDescriptiveLabel()
    }
    
    public func update(withDetectedMove move:FacialMove) {
        self.expressionLabel.text = move.expression.coolDescription()
        self.descriptiveLabel.text = move.expression.shortDescription()
    }
    
    public func containsMove() -> Bool {
        return self.expressionLabel.text != "-"
    }
    
    public func reset() {
        self.expressionLabel.text = "-"
        self.descriptiveLabel.text = ""
    }
    
    private func createAndAddExpressionLabel() {
        
        self.expressionLabel = UILabel()
        self.expressionLabel.textAlignment = .center
        self.expressionLabel.text = "-"
        self.expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.expressionLabel)
        
        NSLayoutConstraint.activate(
            [self.expressionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.expressionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             self.expressionLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
             self.expressionLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
    }
    
    private func createAndAddDescriptiveLabel() {
        
        self.descriptiveLabel = UILabel()
        self.descriptiveLabel.textAlignment = .center
        self.descriptiveLabel.text = ""
        self.descriptiveLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.descriptiveLabel)
        
        NSLayoutConstraint.activate(
            [self.descriptiveLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.descriptiveLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
            ])
    }
}
