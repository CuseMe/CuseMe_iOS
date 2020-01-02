//
//  ChangePhoneNumberVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/28.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class ChangePhoneNumberVC: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var underLine: UIView!
    
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGestureRecognizer()
        
        phoneNumberTextField.addTarget(self, action: #selector(test), for: UIControl.Event.editingChanged)
        underLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        
        changeButton.setCornerRadius(cornerRadius: nil)
        changeButton.setShadow(color: UIColor.mainpink, offSet: CGSize(width: 2, height: 3), opacity: 0.53, radius: 4)
        
        
        
    }
    
   
    
    @objc func test() {
        if(phoneNumberTextField.text?.count != 0) {
            underLine.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1)
        } else {
            underLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

}

extension ChangePhoneNumberVC: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: phoneNumberTextField) else { return false }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -70
                self.titleConstraint.constant = 40
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -27  //다시 돌아오기
                self.titleConstraint.constant = 70
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
