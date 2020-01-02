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
    @IBOutlet weak var inputViewCenterYConstraint: NSLayoutConstraint!
    
    let pass = "0000"  // check용 임시 비밀번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    private func setUI() {
        initGestureRecognizer()
        
        unlockButton.setCornerRadius(cornerRadius: nil)
            unlockButton.setShadow(color: UIColor.mainpink, offSet: CGSize(width: 2, height: 3), opacity: 0.53, radius: 3)
        
        passwordTextField.addTarget(self, action: #selector(checkPasswordLength), for: UIControl.Event.editingChanged)
    }
    
    @objc func checkPasswordLength() {
        if(passwordTextField.text?.count != 0) {
            underLine.backgroundColor = UIColor.mainpink
        } else {
            underLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 0.25)
        }
    }
    
    @IBAction func unlockButtonTouchDown(_ sender: Any) {
        if(passwordTextField.text != pass) {
            alertLabel.isHidden = false // 비밀번호 실패
        } else {
            // TODO: 잠금해제 API
            weak var pvc = self.presentingViewController
            self.dismiss(animated: true) {
                let dvc = UIStoryboard(name: "HomeHelper", bundle: nil).instantiateViewController(withIdentifier: "HomeHelperTC") as! HomeHelperTabBarController
                dvc.modalPresentationStyle = .fullScreen
                pvc?.present(dvc, animated: true)
            }
        }
    }

    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                
                // TODO: 작은 디바이스 대응
                self.inputViewCenterYConstraint.constant = -70
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                
                // TODO: 작은 디바이스 대응
                self.inputViewCenterYConstraint.constant = -70
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
