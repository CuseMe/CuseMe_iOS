//
//  CardDetailVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit
import AVFoundation

class CardDetailVC: UIViewController {
    
    private var streamingPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var cardImageAreaView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var visibleButton: UIButton!
    @IBOutlet private weak var serialNumberLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var serialNumberView: UIView!
    
    private var cardService = CardService()
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 숨김 버튼 Did Tap
        visibleButton.isHidden = true
        
        setCornerRadius()
        setButtonImage()
        setShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let cardIdx = card?.cardIdx else { return }
        cardService.cardDetail(cardIdx: cardIdx) { [weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response else { return }
            
            print(response)
            
            if response.success {
                self.card = response.data!
                self.setData()
            } else {
                // 조회 실패 alert
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        // TODO: 네비게이션 컨트롤러 연결 후 작업
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonDidTap(_ sender: UIButton) {
        // TODO: 카드 편집으로 이동
        let dvc = UIStoryboard(name: "CardDetail", bundle: nil).instantiateViewController(withIdentifier: "CreateCardVC") as! CreateCardVC
        dvc.card = card
        dvc.modalPresentationStyle = .fullScreen
        present(dvc, animated: true)
    }
    
    @IBAction func deleteButtonDidTap(_ sender: UIButton) {
        guard let cardIdx = card?.cardIdx else { return }
        let alert = UIAlertController(title: "카드 삭제", message: "카드를 완전히 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            guard let self = self else { return }

            self.cardService.deleteCard(cardIdx: cardIdx) { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                print(response)
                
                if response.success {
                    self.dismiss(animated: true)
                } else {
                    // TODO: 삭제 실패 로직
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func visibleButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // TODO: 이전 뷰에 전달
    }
    
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        guard let recordURL = card?.recordURL else { return }
        
        let streamingURL = URL(string: recordURL)
        playerItem = AVPlayerItem(url: streamingURL!)
        
        streamingPlayer = AVPlayer(playerItem: playerItem)
        streamingPlayer?.rate = 1.0
        streamingPlayer?.play()
    }
}

extension CardDetailVC {
    private func setCornerRadius() {
        serialNumberView.setCornerRadius(cornerRadius: 3)
    }
    
    private func setButtonImage() {
        visibleButton.setImage(UIImage(named: "btnCarddetailOff"), for: .normal)
        visibleButton.setImage(UIImage(named: "btnCarddeatilOn"), for: .selected)
    }
    
    private func setShadow() {
        playButton.setShadow(color: UIColor.soundShadow, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
    }
    
    private func setData() {
        guard let card = card else { return }
        
        cardImageView.kf.setImage(with: URL(string: card.imageURL))
        titleLabel.text = card.title
        contentTextView.text = card.contents
        visibleButton.isSelected = card.visiblity
        serialNumberLabel.text = "일련번호 | \(card.serialNum)"
    }
}
