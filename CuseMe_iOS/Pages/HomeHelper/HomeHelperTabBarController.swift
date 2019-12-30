//
//  HomeHelperTabBarController.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/30.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomeHelperTabBarController: UITabBarController {

    let menuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 58))
        button.setImage(UIImage(named: "btnTabbarPlus"), for: .normal)
        button.setShadow(color: UIColor.mainpink, offSet: CGSize(width: 0, height: 3), opacity: 0.5, radius: 3)
        button.adjustsImageWhenHighlighted = false

        button.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let makeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 58))
        button.setImage(UIImage(named: "btnMakecardNewcard"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.tag = 0
        
        button.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 58))
        button.setImage(UIImage(named: "btnMakecardDownload"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.tag = 1
        
        button.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let makeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 15))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text = "새로 만들기"
        label.textColor = UIColor.mainpink
        
        return label
    }()
    
    let loadLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 15))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text = "불러오기"
        label.textColor = UIColor.mainpink
        
        return label
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setBlurEffect()
        setBlackview()
        setButtonPosition()
        addButtons()
    }
    
    func setBlackview() {
        blackView.frame.origin.x = 0
        blackView.frame.origin.y = 0
        blackView.frame.size.width = self.view.bounds.width
        blackView.frame.size.height = self.view.bounds.height - 49
        blackView.alpha = 0
        
        self.view.addSubview(blackView)
    }
    
    func setButtonPosition() {
        // menuButton
        menuButton.frame.origin.x = self.view.bounds.width/2 - menuButton.frame.size.width/2
        menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.size.height - 12
        
        makeButton.frame.origin.x = menuButton.frame.origin.x
        makeButton.frame.origin.y = menuButton.frame.origin.y
        
        loadButton.frame.origin.x = menuButton.frame.origin.x
        loadButton.frame.origin.y = menuButton.frame.origin.y
    }
    
    func setBlurEffect() {
        blurEffectView.frame.origin.x = 0
        blurEffectView.frame.origin.y = 0
        blurEffectView.frame.size.width = self.view.bounds.width
        blurEffectView.frame.size.height = self.view.bounds.height - 49
        blurEffectView.alpha = 0
        
        self.view.addSubview(blurEffectView)
    }
    
    func addButtons() {
        self.view.addSubview(loadButton)
        self.view.addSubview(makeButton)
        self.view.addSubview(menuButton)
    }
  
    @objc func menuButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                sender.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.blackView.alpha = 0.8
                self.blurEffectView.alpha = 1
                
                let moveMakeButton = CGAffineTransform(translationX: 0, y: -64)
                let moveLoadButton = CGAffineTransform(translationX: 0, y: -128)
                
                let scaleMakeButton = CGAffineTransform(scaleX: 1, y: 1)
                let scaleLoadButton = CGAffineTransform(scaleX: 1, y: 1)
                
                let combineMakeButton = moveMakeButton.concatenating(scaleMakeButton)
                let combineLoadButton = moveLoadButton.concatenating(scaleLoadButton)
                
                self.makeButton.transform = combineMakeButton
                self.loadButton.transform = combineLoadButton

            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                sender.transform = CGAffineTransform.identity
                self.blackView.alpha = 0
                self.blurEffectView.alpha = 0
                
                let moveMakeButton = CGAffineTransform(translationX: 0, y: 0)
                let moveLoadButton = CGAffineTransform(translationX: 0, y: 0)
                
                let scaleMakeButton = CGAffineTransform(scaleX: 0.1, y: 0.1)
                let scaleLoadButton = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                let combineMakeButton = moveMakeButton.concatenating(scaleMakeButton)
                let combineLoadButton = moveLoadButton.concatenating(scaleLoadButton)
                
                self.makeButton.transform = combineMakeButton
                self.loadButton.transform = combineLoadButton
            }, completion: nil)
        }
    }
    
    @objc func subMenuButtonDidTap(_ sender: UIButton) {
        
        if sender.tag == 0 {
            let alert = UIAlertController(title: "새로 만들기", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true)
        } else if sender.tag == 1 {
            let alert = UIAlertController(title: "불러오기", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true)
        }
    }
} 

extension HomeHelperTabBarController {
    func callBlurView() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func removeBlurView() {
        blurEffectView.removeFromSuperview()
    }
}
