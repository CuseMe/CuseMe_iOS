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
    
    
    let off = UIImage(named: "btnCarddetailOff")
    let on = UIImage(named: "btnCarddetailOn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offButton.setImage(on, for: .selected)
        playButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
    }
 //   @IBAction func hiddenButtonDidTap(_ sender: Any) {
        //offButton.isHidden = true
        
        //print("pl")
    //}
    
    
    

}
