//
//  HomeHelperVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/25.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomeHelperVC: UIViewController {
    
    let cellId = "CardCell"
    
    let cards: [Card] = [
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
        Card(thumbnail: UIImage(named: "btTest01")!, title: "안녕하세요."),
    ]
    
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.layer.zPosition = -1
        middleButton.layer.zPosition = 1
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
    }
    
    func updateUI() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
    }
}

extension HomeHelperVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (UIScreen.main.bounds.width-61)/2
        let height: CGFloat = width * 1.152866242038217
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
}

extension HomeHelperVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        
        cell.thumbnailImageView.image = card.thumbnail
        cell.titleLabel.text = card.title
        
        return cell
    }
}
