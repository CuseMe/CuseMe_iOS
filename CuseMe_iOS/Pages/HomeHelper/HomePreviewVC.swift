//
//  HomePreviewVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/29.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomePreviewVC: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        setWaveAnimation()
    }
    
    func updateUI() {
        doneButton.setCornerRadius(cornerRadius: nil)
        cardCollectionView.setCornerRadius(cornerRadius: 20)
    }
}
