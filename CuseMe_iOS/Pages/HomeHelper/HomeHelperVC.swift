//
//  HomeHelperVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/25.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit
import Kingfisher

class HomeHelperVC: UIViewController {
    
    let cellId = "CardCell"
    
    let cards: [Card] = [
        Card(imageURL: "test", title: "test", contents: "test", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test", record: "test", visible: true, useCount: 0, serialNum: "1234"),
    ]

    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    //@IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        tabBarController?.tabBar.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.1, radius: 6)
    }
    
    @IBAction func finishButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func createButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "teset", message: "test", preferredStyle: .alert)
        let action = UIAlertAction(title: "test", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

extension HomeHelperVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        let card = cards[indexPath.row]
        
        cell.view.setBorder(borderColor: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0), borderWidth: 1)
        contentsTextView.text = card.contents
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
        
        //let imageURL = URL(string: card.imageURL)
        cell.view.backgroundColor = UIColor.black
        //cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        
        return cell
    }
}
