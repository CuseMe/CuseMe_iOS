//
//  HomeDisabledVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit
import Lottie
import SwiftKeychainWrapper
import AVFoundation

class HomeDisabledVC: UIViewController {

    private var streamingPlayer = AVPlayer()
    private var playerItem: AVPlayerItem?
    
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    private var prevCell: CardCell?
    
    private var ratio: CGFloat = 1.152866242038217
    private var width: CGFloat = (UIScreen.main.bounds.width-61)/2
    private var height: CGFloat = ((UIScreen.main.bounds.width-61)/2)*1.152866242038217
    
    var cards = [Card]()
    
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
    private let cardService = CardService()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(homelockViewDidTap))
        homelockAnimationView.addGestureRecognizer(tapGesture)
    }
    
    @objc func homelockViewDidTap(_ sender: UITapGestureRecognizer) {
        let dvc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UnlockVC") as! UnlockVC
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playAnimationView()
        visibleCards()
    }
    
    private func checkCardsCount() {
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
    }
    
    private func visibleCards() {
        cardService.visibleCards() { [weak self] response, error in
            
            guard let self = self else { return }
            guard let response = response else { return }
            
            print(response)
            
            if response.success {
                // TODO: 세이프 옵셔널 바인딩
                self.cards = response.data!
                self.temp = self.cards
                
                self.cardCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "에러 발생", message: "잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            self.checkCardsCount()
        }
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
    
    // TODO: 정렬 시 하이라이트 카드 버그 수정
    private func orderByCount() {
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.mainpink, borderWidth: 0) }
        nextOrderCount += 1
        nextOrderCount %= 3
        
        if nextOrderCount == 0 {
            cards = temp
        } else if nextOrderCount == 1 {
            cards = cards.sorted { $0.useCount > $1.useCount }
        } else if nextOrderCount == 2 {
            cards = cards.sorted { $0.title < $1.title }
        }
        
        prevCell = nil
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
        guard !synthesizer.isSpeaking && !streamingPlayer.isPlaying else { return }
        
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.clear, borderWidth: 0) }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 1)
        let card = cards[indexPath.row]
        leftQuoteImageView.isHidden = false
        rightQuoteImageView.isHidden = false
        contentsTextView.text = card.contents
        
        cardService.increaseUseCount(cardIdx: card.cardIdx) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.cards[indexPath.row].useCount += 1
            } else {
                // TODO: 카운트 증가 실패 시 로직
            }
        }

        if let recordURL = card.recordURL {
            let streamingURL = URL(string: recordURL)
            playerItem = AVPlayerItem(url: streamingURL!)
            
            streamingPlayer = AVPlayer(playerItem: playerItem)
            streamingPlayer.rate = 1.0
            streamingPlayer.play()
        } else {
            tts.call(card.contents) { [weak self] utterance in
                self?.synthesizer.speak(utterance)
            }
        }
        
        prevCell = cell
    }
}

extension HomeDisabledVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
        
        let imageURL = URL(string: card.imageURL)
        cell.view.backgroundColor = UIColor.white
        cell.cardImageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = card.title
        
        return cell
    }
}
