//
//  CardManageVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/27.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardManageVC: UIViewController {
    
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    
    private var cards: [Card] = []
    private var prevCard: Card?
    private var prevCell: CardCell?
    private var prevIndex: Int?
    private var prevOrderByButton: UIButton?
    private var keyword: String = ""
    private var cardService = CardService()

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var bottomBar: UIStackView!
    
    @IBOutlet private weak var bottomBarBottomAnchor: NSLayoutConstraint!
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    @IBOutlet private weak var orderByDefaultButton: UIButton!
    @IBOutlet private weak var orderByFrequencyButton: UIButton!
    @IBOutlet private weak var orderByNameButton: UIButton!
    @IBOutlet private weak var orderByStackView: UIStackView!
    @IBOutlet private weak var shadowView: UIView!
    
    private let indicatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        view.setCornerRadius(cornerRadius: nil)
        view.backgroundColor = UIColor.mainpink
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator()
        setCornerRadius()
        setButtonState()
        setShadow()
        setXib()
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardService.allCards() { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards = response.data!
                
                self.orderByTag(tag: self.prevOrderByButton?.tag ?? 0)
                self.cardCollectionView.reloadData()
            } else {
                // TODO: 조회 실패, 에러 핸들링
            }
        }
    }
    
    // MARK: IBAction
    @IBAction func orderByDidTap(_ sender: UIButton) {
        hideBottomBar()
        
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
    
    @IBAction func bottomBarDidTap(_ sender: UIButton) {
        
        if sender.tag == 0 { // 삭제 - 잘됨
            guard let card = prevCard else { return }
            cardService.deleteCard(cardIdx: card.cardIdx) { response, error in
                guard let response = response else { return }
                
                if response.success {
                    
                } else {
                    // TODO: 삭제 실패 시 로직
                }
            }
            cardService.allCards() { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.cards = response.data!
                } else {
                    // TODO: 조회 실패, 에러 핸들링
                }
            }
        } else if sender.tag == 1 { // 숨기기 아직 구현 못함
            guard let prevIndex = prevIndex else { return }

            cards[prevIndex].visiblity = false
            
            cardService.updateCards(cards: cards) { response, error in
                guard let response = response else { return }

                print(self.cards)
                print(response)
                
                if response.success {
                } else {
                    // TODO: 업데이트 실패 시 로직
                }
            }
            cardService.allCards() { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.cards = response.data!
                } else {
                    // TODO: 조회 실패, 에러 핸들링
                }
            }
        } else if sender.tag == 2 { // 수정
            guard let card = prevCard else { return }
            let dvc = UIStoryboard(name: "CardDetail", bundle: nil).instantiateViewController(withIdentifier: "CardDetailVC") as! CardDetailVC
            dvc.card = card
            dvc.modalPresentationStyle = .fullScreen
            present(dvc, animated: true)
        } else if sender.tag == 3 {}
        
        hideBottomBar()
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension for UICollectionViewDelegate
extension CardManageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 불필요한 코드 정리, On, Off 버튼에 따른 액션 정의
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.clear, borderWidth: 0) }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 1)
        prevCard = cards[indexPath.row]
        prevIndex = indexPath.row
        
        showBottomBar()
        
        prevCell = collectionView.cellForItem(at: indexPath) as? CardCell
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
        
        let imageURL = URL(string: card.imageURL)
        cell.view.backgroundColor = UIColor.white
        cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        cell.visibleButton.isSelected = card.visiblity
        cell.visibleButton.isHidden = false
        
        return cell
    }
}

// MARK: extension for UISearchBar
extension CardManageVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cardService.allCards() { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards = response.data!
            } else {
                // TODO: 조회 실패, 에러 핸들링
            }
        }
        
        cardCollectionView.reloadData()
        
        hideBottomBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        cards = cards.filter { ($0.contents.range(of: keyword, options: .caseInsensitive) != nil) || $0.contents.range(of: keyword, options: .caseInsensitive) != nil }
        
        if keyword.count == 0 {
            cardService.allCards() { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.cards = response.data!
                } else {
                    // TODO: 조회 실패, 에러 핸들링
                }
            }
        }
        
        cardCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension CardManageVC {
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
    
    private func setCornerRadius() {
        doneButton.setCornerRadius(cornerRadius: nil)
        topView.setSpatialCornerRadius(rect: UIRectCorner([.bottomLeft, .bottomRight]), radius: 10)
        shadowView.setCornerRadius(cornerRadius: 10)
    }
    
    private func setShadow() {
        shadowView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 3), opacity: 0.05, radius: 3)
    }
    
    private func setButtonState() {
        orderByDefaultButton.isSelected = true
        prevOrderByButton = orderByDefaultButton
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
    
    private func setXib() {
        let emptyNibName = UINib(nibName: emptyCellId, bundle: nil)
        cardCollectionView.register(emptyNibName, forCellWithReuseIdentifier: emptyCellId)
        
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
    }
    
    private func orderByTag(tag: Int) {
        if tag == 0 { // 보이는 순
            cardService.allCards() { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                if response.success {
                    self.cards = response.data!
                } else {
                    // TODO: 조회 실패, 에러 핸들링
                }
            }
        } else if tag == 1 { // 빈도 순
            cards = cards.sorted { $0.useCount > $1.useCount }
        } else if tag == 2 { // 이름 순
            cards = cards.sorted { $0.title < $1.title }
        }
        cardCollectionView.reloadData()
    }
    
    private func showBottomBar() {
        (tabBarController as! HomeHelperTabBarController).tabBar.isHidden = true
        (tabBarController as! HomeHelperTabBarController).menuButton.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            
            let gap = 83-(self.tabBarController?.tabBar.bounds.height)!
            self.bottomBarBottomAnchor.constant = -gap
            
        }, completion: nil)
        
        view.layoutIfNeeded()
    }
    
    private func hideBottomBar() {
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.clear, borderWidth: 0) }
        prevCell = nil
        
        (tabBarController as! HomeHelperTabBarController).tabBar.isHidden = false
        (tabBarController as! HomeHelperTabBarController).menuButton.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.bottomBarBottomAnchor.constant = -83
        }, completion: nil)
        
        view.layoutIfNeeded()
    }
}
