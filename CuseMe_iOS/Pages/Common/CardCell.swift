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
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var visibleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCornerRadius(cornerRadius: 10)
        self.view.setCornerRadius(cornerRadius: 10)
        cardImageView.setSpatialCornerRadius(rect: UIRectCorner([.topLeft, .topRight]), radius: 10)
        self.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.15, radius: 3)
        selectImageView.isHidden = true
        visibleButton.isHidden = true
    }
}
