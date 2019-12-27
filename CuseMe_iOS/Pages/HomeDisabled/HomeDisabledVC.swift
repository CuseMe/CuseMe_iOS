//
//  HomeDisabledVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomeDisabledVC: UIViewController {

    let cellId = "CardCell"
    
    let cards: [Card] = [
        Card(imageURL: "test", title: "test", contents: "test1", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test2", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test3", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test4", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test5", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test6", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test7", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "test", title: "test", contents: "test8", record: "test", visible: true, useCount: 0, serialNum: "1234"),
    ]
    
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        // Do any additional setup after loading the view.
        
        /* pinch zoom
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(HomeDisabledVC.doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        */
       //let str = "HI"
        //contentLabel.text = str
        
        
    }
    /* pinch
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer){
        cardCollectionView.transform = cardCollectionView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1 */
    }
    
    


    extension HomeDisabledVC: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
           //  let card = cards[indexPath.row]
            cell.view.setBorder(borderColor: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0), borderWidth: 1)
            //contentsTextView.text = card.contents
            
            let card = cards[indexPath.row]  //card
            contentLabel.text = card.contents
            
            
        }
        
    }

    extension HomeDisabledVC: UICollectionViewDelegateFlowLayout {
        
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

    extension HomeDisabledVC: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return cards.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
            
            let card = cards[indexPath.row]
            
            let imageURL = URL(string: card.imageURL)
            cell.view.backgroundColor = UIColor.black
            // cell.cardImageView.kf.setImage(with: imageURL)
            cell.titleLabel.text = card.title
            
            return cell
        }
    
    
    

}
