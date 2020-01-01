//
//  CardManageVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/27.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardManageVC: UIViewController {
    
    let cards: [Card] = [
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "자현이의 사랑", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "승언이는 배가 고파요.", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "너와 결혼까지 생각했어", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "한순간 물거품이 된 꿈", record: "test", visible: true, useCount: 0, serialNum: "1234"),
    ]

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    @IBOutlet weak var orderByDefaultButton: UIButton!
    @IBOutlet weak var orderByFrequencyButton: UIButton!
    @IBOutlet weak var orderByNameButton: UIButton!
    @IBOutlet weak var orderByStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    
    private var prevOrderByButton: UIButton?
    private let cellId = "CardCell"
    
    let indicatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        view.setCornerRadius(cornerRadius: nil)
        view.backgroundColor = UIColor.mainpink
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setOrderByButtonTitleColor()
        setIndicator()
        
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardsEmptyCheck()
    }
    
    private func cardsEmptyCheck() {
        if cards.count > 0 {
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
        } else {
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
        }
    }
    
    private func setIndicator() {
        topView.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.bottomAnchor.constraint(equalTo: orderByStackView.topAnchor, constant: -6),
            indicatorView.centerXAnchor.constraint(equalTo: orderByDefaultButton.centerXAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 6),
            indicatorView.heightAnchor.constraint(equalToConstant: 6),
        ])
    }
    
    private func setUI() {
        doneButton.setCornerRadius(cornerRadius: nil)
        topView.setSpatialCornerRadius(rect: UIRectCorner([.bottomLeft, .bottomRight]), radius: 10)
        shadowView.setCornerRadius(cornerRadius: 10)
        shadowView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 3), opacity: 0.05, radius: 3)
        orderByDefaultButton.isSelected = true
        prevOrderByButton = orderByDefaultButton
    }
    
    private func setOrderByButtonTitleColor() {
        orderByDefaultButton.setTitleColor(UIColor.mainpink, for: .selected)
        orderByDefaultButton.setTitleColor(UIColor.brownGrey, for: .normal)
        orderByDefaultButton.tintColor = UIColor.clear
        orderByFrequencyButton.setTitleColor(UIColor.mainpink, for: .selected)
        orderByFrequencyButton.setTitleColor(UIColor.brownGrey, for: .normal)
        orderByFrequencyButton.tintColor = UIColor.clear
        orderByNameButton.setTitleColor(UIColor.mainpink, for: .selected)
        orderByNameButton.setTitleColor(UIColor.brownGrey, for: .normal)
        orderByNameButton.tintColor = UIColor.clear
    }
    
    @IBAction func orderByDidTap(_ sender: UIButton) {
        if prevOrderByButton != nil {
            prevOrderByButton?.isSelected = false
            prevOrderByButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 0 { // 보이는 순
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.indicatorView.transform = CGAffineTransform.identity
            }, completion: nil)
        } else if sender.tag == 1 { // 빈도 순
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.indicatorView.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width/3, y: 0)
            }, completion: nil)
        } else if sender.tag == 2 { // 이름 순
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.indicatorView.transform = CGAffineTransform.init(translationX: 2*UIScreen.main.bounds.width/3, y: 0)
            }, completion: nil)
        }
        prevOrderByButton = sender
    }
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        // TODO: present(settingVC)
    }
}

extension CardManageVC: UICollectionViewDelegateFlowLayout {
    
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

extension CardManageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        
        let imageURL = URL(string: card.imageURL)
        cell.view.backgroundColor = UIColor.white
        cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        
        return cell
    }
}
