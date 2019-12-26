//
//  HomeDisabledVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomeDisabledVC: UIViewController {
    let cellId = "CardCell2"
    
    let colors = [UIColor.red,
                  UIColor.black,
                  UIColor.green
    ]

    @IBOutlet weak var collectionView: CardCell2!
    
   override func viewDidLoad() {
       super.viewDidLoad()
       
       collectionView.delegate = self
       collectionView.dataSource = self
       
   }
  
   
  
}


extension HomeDisabledVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
extension HomeDisabledVC: UICollectionViewDelegateFlowLayout {

}


extension HomeDisabledVC: UICollectionViewDelegate {

}
