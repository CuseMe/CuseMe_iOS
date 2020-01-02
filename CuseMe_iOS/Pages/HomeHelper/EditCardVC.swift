//
//  EditCardVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit

class EditCardVC: UIViewController {
    
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    
    var cards: [Card] = [
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "A", contents: "두 손을 귀에 가져다 대며 수민이는 말했다. 내꺼야?", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "B", contents: "수민아 오늘 왜 이렇게 꾸미고 왔어?", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "C", contents: "수민아 커피 좀 사와 돈은 줄게", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "D", contents: "수민이는 바닐라 라떼가 먹고싶어", record: "test", visible: false, useCount: 0, serialNum: "1234"),
    ]
    
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var hideButton: UIButton!
    @IBOutlet private weak var hideButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var allButton: UIButton!
    
    private var selectedCards = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        constraintForSmallDevice()
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        
        let emptyNibName = UINib(nibName: emptyCellId, bundle: nil)
        cardCollectionView.register(emptyNibName, forCellWithReuseIdentifier: emptyCellId)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cards = cards.filter { $0.visible == true }
    }
    
    private func constraintForSmallDevice() {
        if UIScreen.main.bounds.height < 736 {
            hideButtonBottomConstraint.constant = 16
        }
    }
    
    private func setUI() {
        hideButton.setCornerRadius(cornerRadius: nil)
        hideButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 6)
        allButton.setImage(UIImage(named: "btnEditAllcheckUnselected"), for: .normal)
        allButton.setImage(UIImage(named: "btnEditAllcheckSelected"), for: .selected)
    }
    @IBAction func allButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            for index in 0..<cards.count {
                cards[index].selected = true
                hideButton.isHidden = false
                selectedCards.append(index)
            }
        } else {
            for index in 0..<cards.count {
                cards[index].selected = false
                hideButton.isHidden = true
                selectedCards.removeAll()
            }
        }
        
        cardCollectionView.reloadData()
    }
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
        // TODO: uialertcontroller -> 서버랑 통신 메소드 호출
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideButtonDidTap(_ sender: UIButton) {
        // TODO: hide
        selectedCards.sort()
        
        for index in selectedCards { cards[index].visible = false }
        cards = cards.filter { $0.visible == true }
        selectedCards.removeAll()
        cardCollectionView.reloadData()
        sender.isHidden = true
        allButton.isSelected = false
        
        print(cards)
    }
}

extension EditCardVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        cell.selectButton.isSelected = !cell.selectButton.isSelected
        cards[indexPath.row].selected = cell.selectButton.isSelected
        
        if cell.selectButton.isSelected {
            cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 1)
            selectedCards.append(indexPath.row)
        } else {
            cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 0)
            selectedCards = selectedCards.filter { $0 != indexPath.row }
        }
        
        if selectedCards.count > 0 { hideButton.isHidden = false }
        else { hideButton.isHidden = true }
    }
}

extension EditCardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Dynamic Cell Size
        
        let width: CGFloat = (UIScreen.main.bounds.width-61)/2
        let height: CGFloat = width*1.152866242038217
        
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

extension EditCardVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cards.count % 2 != 0 {
            return cards.count+1
        } else {
            return cards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        if cards.count % 2 != 0 && indexPath.row == cards.count {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath) as! EmptyCell
            return emptyCell
        }
        
        let card = cards[indexPath.row]
        
        //let imageURL = URL(string: card.imageURL)
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 0)
        cell.view.backgroundColor = UIColor.white
        //cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        cell.selectButton.isSelected = card.selected
        cell.selectButton.isHidden = false
        
        return cell
    }
}
