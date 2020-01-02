//
//  CardCell.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCornerRadius(cornerRadius: 10)
        view.setCornerRadius(cornerRadius: 10)
        cardImageView.setSpatialCornerRadius(rect: UIRectCorner([.topLeft, .topRight]), radius: 10)
        self.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.15, radius: 3)
        
        selectButton.setImage(UIImage(named: "btnEditSelectcardUnselected"), for: .normal)
        selectButton.setImage(UIImage(named: "btnEditSelectcardSelected"), for: .selected)
        
        visibleButton.setImage(UIImage(named: "btnCarddetailOff"), for: .normal)
        visibleButton.setImage(UIImage(named: "btnCarddetailOn"), for: .selected)
        
        selectButton.isHidden = true
        visibleButton.isHidden = true
    }
}
