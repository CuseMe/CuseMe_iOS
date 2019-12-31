//
//  ChangePasswordVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2019/12/27.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
 

    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var underLine1: UIView!
    @IBOutlet weak var underLine2: UIView!
    @IBOutlet weak var underLine3: UIView!
    
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
       self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGestureRecognizer()
      
         firstTextField.addTarget(self, action: #selector(test1), for: UIControl.Event.editingChanged)
         secondTextField.addTarget(self, action: #selector(test2), for: UIControl.Event.editingChanged)
         thirdTextField.addTarget(self, action: #selector(test3), for: UIControl.Event.editingChanged)
        
        changeButton.setCornerRadius(cornerRadius: nil)
        changeButton.setShadow(color: <#T##UIColor#>, offSet: <#T##CGSize#>, opacity: <#T##Float#>, radius: <#T##CGFloat#>)
        
    }
    
    @objc func test1() {
        
        if(firstTextField.text?.count != 0) {
            underLine1.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1)
        } else {
            underLine1.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        }
    }
    @objc func test2() {
        if(secondTextField.text?.count != 0) {
            underLine2.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1)
        } else {
            underLine2.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        }
    }
    
    @objc func test3() {
           if(thirdTextField.text?.count != 0) {
               underLine3.backgroundColor = UIColor(red: 251/255, green: 109/255, blue: 106/255, alpha: 1)
           } else {
               underLine3.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
           registerForKeyboardNotifications()
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           unregisterForKeyboardNotifications()
       }
}


extension ChangePasswordVC: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.firstTextField.resignFirstResponder()
        self.secondTextField.resignFirstResponder()
        self.thirdTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: firstTextField) else { return false }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        // keyboard up duration
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        //speed
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -120 // Up
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -50 // Down
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
