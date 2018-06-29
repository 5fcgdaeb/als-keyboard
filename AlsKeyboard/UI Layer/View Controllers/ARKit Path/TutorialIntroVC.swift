//
//  TutorialFaceVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 28.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class TutorialIntroVC: UIViewController {
    
    @IBAction func cancelTapped(_ sender: UIControl) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TutorialIntroVC: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FacialExpression.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FacialExpressionCell", for: indexPath)
        let expression = FacialExpression.allValues[indexPath.row]
        cell.textLabel?.text = expression.coolDescription()
        cell.detailTextLabel?.text = expression.formalDescription()
        return cell
    }
}
