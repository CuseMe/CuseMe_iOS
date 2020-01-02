//
//  CardDetailVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/31.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardDetailVC: UIViewController {


    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var serialNum: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var offImageView: UIImageView!
    @IBOutlet weak var alertImageView: UIImageView!
    
    var off: Bool = false
    var alert: Bool = false
    
    @IBAction func offButtonDidTap(_ sender: Any) {
        if(off == false){
        let alert = UIAlertController(title: "보이는 카드 목록에\n바로 추가하시겠습니까?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "추가", style: .default) { (action) in
            if !self.off{
                    self.offImageView.image = UIImage(named: "btnCarddetailOn")
                self.off = !self.off
                }else{
                    self.offImageView.image = UIImage(named: "btnCarddetailOff")
                self.off = !self.off
                }
            }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
            }
        alert.addAction(cancel)
        alert.addAction(okAction)
            present(alert, animated: true, completion: nil)}
        else if (off == true){
            self.offImageView.image = UIImage(named: "btnCarddetailOff")
            self.off = !self.off
            }
        }
    
    @IBAction func alertButtonDidTap(_ sender: Any) {
        if(alert == false){
        let alert = UIAlertController(title: "이 카드를 사용하면\n아래의 번호로 알림이 갑니다.\n01012341234", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if !self.alert{
                    self.alertImageView.image = UIImage(named: "btnCarddetailNoticeSelected")
                self.alert = !self.alert
                }else{
                    self.alertImageView.image = UIImage(named: "btnCarddetailNoticeUnSelected")
                self.alert = !self.alert
                }
            }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
            }
        alert.addAction(cancel)
        alert.addAction(okAction)
            present(alert, animated: true, completion: nil)}
        else if (alert == true){
                   self.alertImageView.image = UIImage(named: "btnCarddetailNoticeUnselected")
                   self.alert = !self.alert
               }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "카드를 완전히\n삭제하시겠습니까?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .default) { (action) in
                /// 삭제 버튼
            }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
            }
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
    }

    
    

}
