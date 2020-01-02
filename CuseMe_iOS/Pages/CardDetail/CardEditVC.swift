//
//  CardEditVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit

class CardEditVC: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGestureRecognizer()
        addButton.setCornerRadius(cornerRadius: nil)
        imageView.setCornerRadius(cornerRadius: 5)
        imageView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
        confirmButton.setCornerRadius(cornerRadius: nil)
        recordButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
        placeholderSetting()
    
    }
  
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

}


extension CardEditVC: UIGestureRecognizerDelegate {
   
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.titleTextField.resignFirstResponder()
        self.contentsTextView.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: titleTextField) else { return false }
        
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
            else if UIScreen.main.bounds.height>667{
                //self.centerYConstraint.constant = -130
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
           //     self.centerYConstraint.constant = -50 // Down
            }
            else if UIScreen.main.bounds.height>667{
           // self.centerYConstraint.constant = -89
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
extension CardEditVC: UITextViewDelegate {
        func placeholderSetting() {
            contentsTextView.delegate = self
            contentsTextView.text = "카드 내용을 입력해주세요"
            contentsTextView.textColor = UIColor.lightGray
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "카드 내용을 입력해주세요"
                textView.textColor = UIColor.lightGray
            }
        }
}
