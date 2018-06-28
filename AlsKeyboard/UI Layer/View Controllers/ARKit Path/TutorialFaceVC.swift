//
//  TutorialFaceVC.swift
//  AlsKeyboard
//
//  Created by Guven Bolukbasi on 28.06.2018.
//  Copyright © 2018 DorianLabs. All rights reserved.
//

import UIKit

class TutorialFaceVC: UIViewController {
    
}

extension TutorialFaceVC: UICollectionViewDelegate, UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FacialExpression.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
