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
        button.alpha = 0
        
        button.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 58, height: 58))
        button.setImage(UIImage(named: "btnMakecardDownload"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.tag = 1
        button.alpha = 0
        
        button.addTarget(self, action: #selector(subMenuButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let makeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 15))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text = "새로 만들기"
        label.textColor = UIColor.mainpink
        label.alpha = 0
        
        return label
    }()
    
    let loadLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 15))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text = "내려받기"
        label.textColor = UIColor.mainpink
        label.alpha = 0
        
        return label
    }()
    
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.1, radius: 6)
        setItemsPosition()
        addItems()
    }
    
    func setItemsPosition() {
        // blurView
        blurView.frame.origin.x = 0
        blurView.frame.origin.y = 0
        blurView.frame.size.width = self.view.bounds.width
        if UIScreen.main.bounds.height > 736 {
            blurView.frame.size.height = self.view.bounds.height - 83
        } else {
            blurView.frame.size.height = self.view.bounds.height - 49
        }
        blurView.alpha = 0
        
        // menuButton
        menuButton.frame.origin.x = self.view.bounds.width/2 - menuButton.frame.size.width/2
        if UIScreen.main.bounds.height > 736 {
            menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.size.height - 44
        } else {
            menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.size.height - 12
        }
        
        // makeButton
        makeButton.frame.origin.x = menuButton.frame.origin.x
        makeButton.frame.origin.y = menuButton.frame.origin.y - menuButton.frame.size.height
        
        // makeLabel
        makeLabel.frame.origin.x = makeButton.frame.origin.x + makeButton.frame.size.width + 10
        makeLabel.frame.origin.y = makeButton.frame.origin.y + makeButton.frame.size.height/2 - 7.5
        
        // loadButton
        loadButton.frame.origin.x = menuButton.frame.origin.x
        loadButton.frame.origin.y = makeButton.frame.origin.y - menuButton.frame.size.height - 6
        
        // loadLabel
        loadLabel.frame.origin.x = loadButton.frame.origin.x + loadButton.frame.size.width + 10
        loadLabel.frame.origin.y = loadButton.frame.origin.y + loadButton.frame.size.height/2 - 7.5
    }
    
    func addItems() {
        self.view.addSubview(blurView)
        self.view.addSubview(loadButton)
        self.view.addSubview(loadLabel)
        self.view.addSubview(makeButton)
        self.view.addSubview(makeLabel)
        self.view.addSubview(menuButton)
    }
  
    @objc func menuButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                sender.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.blurView.alpha = 0.8
                
                self.makeButton.alpha = 1
                self.makeLabel.alpha = 1
                
                self.makeButton.transform = CGAffineTransform(translationX: 0, y: -6)
                self.makeLabel.transform = CGAffineTransform(translationX: 0, y: -6)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseIn], animations: {
                self.loadButton.alpha = 1
                self.loadLabel.alpha = 1

                self.loadButton.transform = CGAffineTransform(translationX: 0, y: -6)
                self.loadLabel.transform = CGAffineTransform(translationX: 0, y: -6)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                sender.transform = CGAffineTransform.identity
                self.blurView.alpha = 0
                self.loadButton.alpha = 0
                self.loadLabel.alpha = 0
                
                self.loadButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.loadLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
                self.makeButton.alpha = 0
                self.makeLabel.alpha = 0
                
                self.makeButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.makeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
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
