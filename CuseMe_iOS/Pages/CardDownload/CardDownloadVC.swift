//
//  CardDownloadVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/27.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class CardDownloadVC: UIViewController {

    // MARK: IBOulet
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    // MARK: Control Variable
    
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    // MARK: IBAction
    @IBAction func selfButtonDidTap(_ sender: Any) {
        // TODO: 화면 이동 -> 카드 생성
    }
    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func test(id: String, _ pw: String) {}
}

extension CardDownloadVC: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.inputTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: inputTextField) else { return false }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -120
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                self.centerYConstraint.constant = -82
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
