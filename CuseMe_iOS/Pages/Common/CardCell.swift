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
        
        view.setCornerRadius(cornerRadius: 10)
        // 그림자는 미정
        selectImageView.isHidden = true
        visibleButton.isHidden = true
    }
}
