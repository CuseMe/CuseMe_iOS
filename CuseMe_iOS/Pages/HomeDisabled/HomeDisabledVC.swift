//
//  HomeDisabledVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

class HomeDisabledVC: UIViewController {

    let cellId = "CardCell"
    let emptyCellId = "EmptyCell"
    private var prevCell: CardCell?
    
    var cards: [Card] = [
        Card(imageURL: "test1", title: "test1", contents: "test1", record: "test", visible: true, useCount: 1, serialNum: "1234"),
        Card(imageURL: "test2", title: "test2", contents: "test2", record: "test", visible: true, useCount: 2, serialNum: "1234"),
        Card(imageURL: "test3", title: "test3", contents: "test3", record: "test", visible: true, useCount: 3, serialNum: "1234"),
        Card(imageURL: "test4", title: "test4", contents: "test4", record: "test", visible: true, useCount: 4, serialNum: "1234"),
        Card(imageURL: "test5", title: "test5", contents: "test5", record: "test", visible: true, useCount: 5, serialNum: "1234"),
        Card(imageURL: "test6", title: "test6", contents: "test6", record: "test", visible: true, useCount: 6, serialNum: "1234"),
        Card(imageURL: "test7", title: "test7", contents: "test7", record: "test", visible: true, useCount: 7, serialNum: "1234"),
        Card(imageURL: "test8", title: "test8", contents: "test8", record: "test", visible: true, useCount: 8, serialNum: "1234"),
    ]
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var waveAnimationView: AnimationView!
    @IBOutlet weak var homelockAnimationView: AnimationView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var leftQuoteImageView: UIImageView!
    @IBOutlet weak var rightQuoteImageView: UIImageView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyImageViewTopConstraint: NSLayoutConstraint!
    
    private let tts = TTSService()
    private let synthesizer = AVSpeechSynthesizer()
    private var nextOrderCount = 0
    private var temp = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: homelockAnimation Did Tap
        homelockAnimationView.animation = Animation.named("homelock")
        waveAnimationView.animation = Animation.named("wave")

        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
        
        let emptyNibName = UINib(nibName: emptyCellId, bundle: nil)
        cardCollectionView.register(emptyNibName, forCellWithReuseIdentifier: emptyCellId)
        
        setUI()
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        temp = cards
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderByCount()
        
        cards = cards.filter { $0.visible == true }
        
        if cards.count > 0 {
            reloadButton.isHidden = false
            lockButton.isHidden = false
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
            homelockAnimationView.isHidden = true
        } else {
            reloadButton.isHidden = true
            lockButton.isHidden = true
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
            homelockAnimationView.isHidden = false
        }
        playAnimationView()
    }
    
    func setUI() {
        cardCollectionView.setCornerRadius(cornerRadius: 20)
    }
    
    func playAnimationView() {
        homelockAnimationView.play()
        homelockAnimationView.loopMode = .loop
        waveAnimationView.play()
        waveAnimationView.loopMode = .loop
    }
    
    private func orderByCount() {
        if nextOrderCount == 1 {
            cards = cards.sorted { $0.useCount > $1.useCount }
        } else if nextOrderCount == 2 {
            cards = cards.sorted { $0.title < $1.title }
            nextOrderCount = -1
        } else if nextOrderCount == 0 {
            cards = temp
        }
        nextOrderCount += 1
        
        cardCollectionView.reloadData()
    }
    
    @IBAction func lockButtonDidTap(_ sender: Any) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UnlockVC") as! UnlockVC
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true)
    }
    @IBAction func reloadButtonDidTap(_ sender: UIButton) {
        orderByCount()
    }
}

extension HomeDisabledVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !synthesizer.isSpeaking else { return }
        
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.clear, borderWidth: 0) }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 1)
        let card = cards[indexPath.row]
        leftQuoteImageView.isHidden = false
        rightQuoteImageView.isHidden = false
        contentsTextView.text = card.contents

        tts.call(card.contents) { [weak self] utterance in
            self?.synthesizer.speak(utterance)
        }
        
        prevCell = collectionView.cellForItem(at: indexPath) as? CardCell
    }
}

extension HomeDisabledVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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

extension HomeDisabledVC: UICollectionViewDataSource {
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
        
        return cell
    }
}
