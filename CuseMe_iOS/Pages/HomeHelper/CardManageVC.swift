//
//  CardManageVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/27.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardManageVC: UIViewController {
    
    var cards = [
        Card(imageURL: "test", title: "C", contents: "C", record: nil, visible: true, useCount: 2, serialNum: "3"),
        Card(imageURL: "test", title: "B", contents: "B", record: nil, visible: false, useCount: 4, serialNum: "2"),
        Card(imageURL: "test", title: "A", contents: "A", record: nil, visible: true, useCount: 2, serialNum: "1"),
        Card(imageURL: "test", title: "D", contents: "D", record: nil, visible: false, useCount: 7, serialNum: "4"),
        Card(imageURL: "test", title: "Hello", contents: "hihi", record: nil, visible: false, useCount: 6, serialNum: "5"),
        Card(imageURL: "test", title: "화장실", contents: "화장실 가고싶어요.", record: nil, visible: false, useCount: 6, serialNum: "6"),
        Card(imageURL: "test", title: "bed", contents: "I'm so sleepy.", record: nil, visible: false, useCount: 6, serialNum: "7"),
        Card(imageURL: "test", title: "bread", contents: "I'm hungry.", record: nil, visible: false, useCount: 6, serialNum: "8"),
        Card(imageURL: "test", title: "toilet", contents: "I want to go toilet.", record: nil, visible: false, useCount: 6, serialNum: "9"),
        Card(imageURL: "test", title: "bathroom", contents: "I want to go toILet.", record: nil, visible: false, useCount: 6, serialNum: "10"),
        Card(imageURL: "test", title: "화장품", contents: "가나다라.", record: nil, visible: false, useCount: 6, serialNum: "6")
    ]
    
    var temp: [Card] = []

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    @IBOutlet private weak var orderByDefaultButton: UIButton!
    @IBOutlet private weak var orderByFrequencyButton: UIButton!
    @IBOutlet private weak var orderByNameButton: UIButton!
    @IBOutlet private weak var orderByStackView: UIStackView!
    @IBOutlet private weak var shadowView: UIView!
    
    private var prevOrderByButton: UIButton?
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    private var keyword: String = ""
    
    private let indicatorView: UIView = {
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
        temp = cards
        
        let emptyNibName = UINib(nibName: emptyCellId, bundle: nil)
        cardCollectionView.register(emptyNibName, forCellWithReuseIdentifier: emptyCellId)
        
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cards = cards.filter { $0.visible == true } + cards.filter { $0.visible == false }
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
    
    private func orderByTag(tag: Int) {
        if tag == 0 { // 보이는 순
            cards = cards.filter { $0.visible == true } + cards.filter { $0.visible == false }
        } else if tag == 1 { // 빈도 순
            cards = cards.sorted { $0.useCount > $1.useCount }
        } else if tag == 2 { // 이름 순
            cards = cards.sorted { $0.title < $1.title }
        }
        cardCollectionView.reloadData()
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
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        orderByTag(tag: sender.tag)
        prevOrderByButton = sender
    }
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsTableVC") as! UITableViewController
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true)
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CardManageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        cell.visibleButton.isSelected = !cell.visibleButton.isSelected
        cards[indexPath.row].visible  = cell.visibleButton.isSelected
        
        if let button = prevOrderByButton {
            if button.tag == 0 { orderByTag(tag: 0) }
        }
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
        
        if cards.count % 2 != 0 {
            return cards.count+1
        } else {
            return cards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cards.count % 2 != 0 && indexPath.row == cards.count {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath) as! EmptyCell
            return emptyCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        
        //let imageURL = URL(string: card.imageURL)
        cell.view.backgroundColor = UIColor.white
        //cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        cell.visibleButton.isSelected = card.visible
        cell.visibleButton.isHidden = false
        
        return cell
    }
}

// MARK: extension for UISearchBar
extension CardManageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: 한글자 서치
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        cards = cards.filter { ($0.contents.range(of: keyword, options: .caseInsensitive) != nil) || $0.contents.range(of: keyword, options: .caseInsensitive) != nil }
        
        if keyword.count == 0 {
            cards = temp
        }
        
        cardCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}
