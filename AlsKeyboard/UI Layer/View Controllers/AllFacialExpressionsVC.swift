//
//  AllFacialExpressionsVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 17.07.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class AllFacialExpressionsVC: UIViewController {}

extension AllFacialExpressionsVC: UITableViewDelegate, UITableViewDataSource {
    
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
