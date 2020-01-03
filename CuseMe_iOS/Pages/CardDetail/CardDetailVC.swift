//
//  CardDetailVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit

class CardDetailVC: UIViewController {

    @IBOutlet private weak var cardImageView: UIImageView!
    @IBOutlet private weak var visibleButton: UIButton!
    @IBOutlet private weak var serialNumberView: UIView!
    @IBOutlet private weak var serialNumberLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pushButton: UIButton!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet private weak var playButton: UIButton!
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reciveData()
    }
    
    private func setUI() {
        serialNumberView.setCornerRadius(cornerRadius: 3)
        playButton.setShadow(color: UIColor.soundShadow, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
        pushButton.setImage(UIImage(named: "btnCarddetailNoticeUnselected"), for: .normal)
        pushButton.setImage(UIImage(named: "btnCarddetailNoticeSelected"), for: .selected)
        visibleButton.setImage(UIImage(named: "btnCarddetailOff"), for: .normal)
        visibleButton.setImage(UIImage(named: "btnCarddeatilOn"), for: .selected)
        // TODO: 녹음한 데이터가 없을 때 이미지 디자이너 요청
        playButton.setImage(UIImage(named: "btnCarddetailPlay"), for: .normal)
        playButton.setImage(UIImage(named: "btnCarddetailPlay"), for: .selected)
    }
    
    private func reciveData() {
        guard let card = card else { return }
        cardImageView.kf.setImage(with: URL(string: card.imageURL))
        titleLabel.text = card.title
        contentsTextView.text = card.contents
        visibleButton.isSelected = card.visible
        serialNumberLabel.text = card.serialNum
        // TODO: 녹음 데이터
    }
    
    @IBAction func pushButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func backButtonDidTap(_ sender: Any) {
        // TODO: 네비게이션 컨트롤러 연결 후 작업
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func editButtonDidTap(_ sender: UIButton) {
        // TODO: 카드 편집으로 이동
        let dvc = UIStoryboard(name: "CardDetail", bundle: nil).instantiateViewController(withIdentifier: "CardEditVC") as! CardEditVC
        dvc.card = card
        dvc.addButtonString = "수정"
        dvc.modalPresentationStyle = .fullScreen
        present(dvc, animated: true)
    }
    @IBAction func deleteButtonDidTap(_ sender: UIButton) {
        // TODO: 카드 삭제 로직
        let alert = UIAlertController(title: "카드 삭제", message: "카드를 완전히 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    @IBAction func visibleButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
