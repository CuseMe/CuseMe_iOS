//
//  HomePreviewVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/29.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher
import AVFoundation

class HomePreviewVC: UIViewController {
    
    private let cellId = "CardCell"
    private let emptyCellId = "EmptyCell"
    private var prevCell: CardCell?
    
    let cards: [Card] = [
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "두 손을 귀에 가져다 대며 수민이는 말했다. 내꺼야?", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "수민아 오늘 왜 이렇게 꾸미고 왔어?", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "수민이는 미세 먼지가 싫어요", record: "test", visible: true, useCount: 0, serialNum: "1234"),
        Card(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/Wheesung_International_Film_Festival_2018_2.jpg/500px-Wheesung_International_Film_Festival_2018_2.jpg", title: "test", contents: "수민이는 바닐라 라떼가 먹고싶어", record: "test", visible: true, useCount: 0, serialNum: "1234"),
    ]

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var cardCollectionView: UICollectionView!
    @IBOutlet private weak var waveAnimationView: AnimationView!
    @IBOutlet private weak var contentsTextView: UITextView!
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    @IBOutlet private weak var emptyImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emptyLabelTopConstraint: NSLayoutConstraint!
    
    private let tts = TTSService()
    private let synthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        waveAnimationView.animation = Animation.named("wave")
        
        
        
        setUI()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        constraintForSmallDevice()
        
        let emptyNibName = UINib(nibName: emptyCellId, bundle: nil)
        cardCollectionView.register(emptyNibName, forCellWithReuseIdentifier: emptyCellId)
        
        let nibName = UINib(nibName: cellId, bundle: nil)
        cardCollectionView.register(nibName, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playWaveAnimation()
        cardsEmptyCheck()
    }
    
    private func constraintForSmallDevice() {
        if UIScreen.main.bounds.height < 667 {
            emptyImageViewTopConstraint.constant = -212
            emptyLabelTopConstraint.constant = 16
        } else if UIScreen.main.bounds.height < 736 {
            emptyImageViewTopConstraint.constant = -270
            emptyLabelTopConstraint.constant = 23
        }
    }
    
    private func cardsEmptyCheck() {
        if cards.count > 0 {
            editButton.isHidden = false
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
        } else {
            editButton.isHidden = true
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
        }
    }
    
    private func setUI() {
        doneButton.setCornerRadius(cornerRadius: nil)
        cardCollectionView.setCornerRadius(cornerRadius: 20)
    }
    
    private func playWaveAnimation() {
        waveAnimationView.play()
        waveAnimationView.loopMode = .loop
    }
    
    @IBAction private func editButtonDidTap(_ sender: Any) {
        // TODO: 편집 화면 연결, present
    }
    
    @IBAction private func doneButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension HomePreviewVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !synthesizer.isSpeaking else { return }
        
        if prevCell != nil { prevCell?.setBorder(borderColor: UIColor.clear, borderWidth: 0) }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.setBorder(borderColor: UIColor.mainpink, borderWidth: 1)
        let card = cards[indexPath.row]
        contentsTextView.text = card.contents

        tts.call(card.contents) { [weak self] utterance in
            self?.synthesizer.speak(utterance)
        }
        
        prevCell = collectionView.cellForItem(at: indexPath) as? CardCell
    }
}

extension HomePreviewVC: UICollectionViewDelegateFlowLayout {
    
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

extension HomePreviewVC: UICollectionViewDataSource {
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
