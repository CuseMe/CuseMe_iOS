//
//  UIView+Extensions.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

extension UIView {

    func setCornerRadius(cornerRadius : CGFloat?){
        
        // UIView 의 모서리가 둥근 정도를 설정
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
    }

    func setShadow(color: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
        
        // 그림자 색상 설정
        layer.shadowColor = color.cgColor
        // 그림자 크기 설정
        layer.shadowOffset = offSet
        // 그림자 투명도 설정
        layer.shadowOpacity = opacity
        // 그림자의 blur 설정
        layer.shadowRadius = radius
        
        layer.masksToBounds = false
    }

    func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        
        // UIView 의 테두리 색상 설정
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        } else {
            // borderColor 변수가 nil 일 경우의 default
            self.layer.borderColor = UIColor(red: 205/255, green: 209/255, blue: 208/255, alpha: 1.0).cgColor
        }
        
        // UIView 의 테두리 두께 설정
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        } else {
            // borderWidth 변수가 nil 일 경우의 default
            self.layer.borderWidth = 1.0
        }
    }
}
