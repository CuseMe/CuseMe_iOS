//
//  EditCardVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit
// TODO: 서버 로직에 맞춰서 새로운 로직 작성
// TODO: 클래스 이름 변경
class EditCardVC: UIViewController {
    
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    private var cardService = CardService()
    
    var cards: [Card] = []
    
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var hideButton: UIButton!
    @IBOutlet private weak var hideButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var allButton: UIButton!
    
    private var selectedCards = [Int]()
    private var updateCards = [Card]()
    private var sendData = [Card]()
    
    
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
                selectedCards.append(index)
            }
            hideButton.isHidden = false
        } else {
            for index in 0..<cards.count {
                cards[index].selected = false
            }
            selectedCards.removeAll()
            hideButton.isHidden = true
        }
        
        cardCollectionView.reloadData()
    }
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
        // TODO: uialertcontroller -> 서버랑 통신 메소드 호출
        for index in selectedCards {
            updateCards.append(cards[index])
        }
        
        print(sendData)
        
        let alert = UIAlertController(title: "", message: "변경 내용을 저장하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "저장", style: .destructive) { [weak self] action in
            guard let self = self else { return }
        }
        let cancel = UIAlertAction(title: "저장 안함", style: .cancel) { [weak self] action in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    @IBAction func hideButtonDidTap(_ sender: UIButton) {
        // TODO: hide
        for index in selectedCards { cards[index].visiblity = false }
        cards = cards.filter { $0.visiblity == true }
        selectedCards.removeAll()
        cardCollectionView.reloadData()
        sender.isHidden = true
        allButton.isSelected = false
        
        print(cards)
    }
    @IBAction func longPressGesture(_ sender: UIGestureRecognizer) {
        switch (sender.state) {
        case .began:
            guard let selectedIndexPath = cardCollectionView.indexPathForItem(at: sender.location(in: cardCollectionView)) else { return }
            cardCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            cardCollectionView.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
        case .ended:
            cardCollectionView.endInteractiveMovement()
            cardCollectionView.reloadData()
        default:
            cardCollectionView.cancelInteractiveMovement()
        }
    }
}

extension EditCardVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let source = cards[sourceIndexPath.item]
        cards.remove(at: sourceIndexPath.item)
        cards.insert(source, at: destinationIndexPath.item)
        
        collectionView.reloadData()
    }
    
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
        
        let imageURL = URL(string: card.imageURL)
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 0)
        cell.view.backgroundColor = UIColor.white
        cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        cell.selectButton.isSelected = card.selected
        cell.selectButton.isHidden = false
        
        return cell
    }
}
