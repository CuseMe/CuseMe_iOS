//
//  UnlockVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/31.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class UnlockVC: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var underLine: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initGestureRecognizer()
        passwordTextField.addTarget(self, action: #selector(test), for: UIControl.Event.editingChanged)
        underLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        unlockButton.setCornerRadius(cornerRadius: nil)
        unlockButton.setShadow(color: UIColor.mainpink, offSet: CGSize(width: 2, height: 3), opacity: 0.53, radius: 4)
        passwordTextField.addTarget(self, action: "edited", for: UIControl.Event.editingChanged)
   
        
        alertLabel.isHidden = true
        
    }
    @objc func test() {
        if(passwordTextField.text?.count != 0) {
            underLine.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1)
        } else {
            underLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        }
    }
    
    let pass = "1234"
    
    @objc func edited() {
      // print("Edited \(passwordTextField.text)")
    }
    
    @IBAction func unlockButtonTouchDown(_ sender: Any) {
        if(passwordTextField.text != pass) {
            alertLabel.isHidden = false
        }
        else{
            alertLabel.isHidden = true}
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
}
extension UnlockVC: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.passwordTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: passwordTextField) else { return false }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        // keyboard up duration
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        //speed
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                // self.centerYConstraint.constant = -120 // Up
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                //   self.centerYConstraint.constant = -50 // Down
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



