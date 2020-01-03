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
    @IBOutlet weak var inputViewCenterYConstraint: NSLayoutConstraint!
    
    private var cardService = CardService()
    
    // MARK: Control Variable
    
    
    // MARK: ViewController Life Cycle
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
        downloadButton.setCornerRadius(cornerRadius: nil)
        downloadButton.setShadow(color: UIColor.mainpink, offSet: CGSize(width: 2, height: 3), opacity: 0.53, radius: 3)
    }
    
    // MARK: IBAction
    @IBAction func downloadButtonDidTap(_ sender: Any) {
        // TODO: 다운로드 이후 카드 상세
        guard let serialNumber = inputTextField.text else { return }
        
        cardService.download(serialNumber: serialNumber) { [weak self] response, error in
            
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response.success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "실패", message: response.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func selfButtonDidTap(_ sender: Any) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true) {
            let dvc = UIStoryboard(name: "CardDetail", bundle: nil).instantiateViewController(withIdentifier: "CardEditVC") as! CardEditVC
            dvc.modalPresentationStyle = .fullScreen
            pvc?.present(dvc, animated: true)
        }
    }
    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
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
                self.inputViewCenterYConstraint.constant = -27
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
