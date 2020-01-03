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
    @IBOutlet weak var cardImageAreaView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var ttsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let picker = UIImagePickerController()
    let defaultImage = UIImage(named: "icMakecardPhoto")
    
    var addButtonString: String = ""
    var card: Card?
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardImageView.image == defaultImage {
            emptyLabel.isHidden = false
            cardImageView.contentMode = .center
        }
        
        picker.delegate = self
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        reciveData()
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    private func reciveData() {
        guard let card = card else { return }
        // TODO: 카드 데이터 받기
        // cardImageView.kf.setImage(with: URL(string: card.imageURL))
        titleTextField.text = card.title
        contentsTextView.text = card.contents
        if card.contents.count > 0 {
            contentsTextView.textColor = UIColor.textBrownBlack
        }
    }
    
    private func setUI() {
        //addButton.titleLabel?.text = addButtonString
        placeholderSetting()
        initGestureRecognizer()
        addButton.setCornerRadius(cornerRadius: nil)
        cardImageAreaView.setCornerRadius(cornerRadius: 5)
        cardImageView.setCornerRadius(cornerRadius: 5)
        cardImageAreaView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
        confirmButton.setCornerRadius(cornerRadius: nil)
        recordButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
        // TODO : ttsButton 에셋 요청
        ttsButton.setImage(UIImage(named: "btnCarddetailNoticeUnselected"), for: .normal)
        ttsButton.setImage(UIImage(named: "btnCarddetailNoticeSelected"), for: .selected)
        // TODO : playingButton 에셋 요청
        playButton.setImage(UIImage(named: "btnMakecardPlaySelected"), for: .normal)
        playButton.setImage(UIImage(named: "btnMakecardPlaySelected"), for: .selected)
    }
    
    private func showImagePicker() {
        
        let actionSheet = UIAlertController(title: "사진 첨부", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.showsCameraControls = true
                self.present(self.picker, animated: true)
            } else {
                print("not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "앨범", style: .default, handler: { (action) in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    // MARK: IBAction
    @IBAction func ttsButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func addButtonDidTap(_ sender: Any) {
        // TODO: 추가, 수정 버튼 눌렀을 때
    }
    @IBAction func playButtonDidTap(_ sender: Any) {
        // TODO: 재생 버튼 눌렀을 때
    }
    @IBAction func recordButtonDidTap(_ sender: Any) {
        // TODO: 녹음 버튼 눌렀을 때
    }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        // TODO: 확인 버튼 눌렀을 때
    }
    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CardEditVC: UIGestureRecognizerDelegate {
   
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
        cardImageView.addGestureRecognizer(imageViewTap)
    }
    
    @objc func imageViewDidTap(_ sender: UITapGestureRecognizer) {
        showImagePicker()
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

        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            if UIScreen.main.bounds.height < 667 {
                // TODO: 작은 디바이스 대응
            }
            else if UIScreen.main.bounds.height>667{
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            // TODO: 키보드가 입력을 가리는 문제 해결
            if UIScreen.main.bounds.height < 667 {
                // TODO: 작은 디바이스 대응
            }
            else if UIScreen.main.bounds.height>667{
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
            textView.textColor = UIColor.textBrownBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "카드 내용을 입력해주세요"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension CardEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImg = UIImage()
        
        if let possibleImg = info[.editedImage] as? UIImage {
            newImg = possibleImg
        }
        else if let possibleImg = info[.originalImage] as? UIImage {
            newImg = possibleImg
        }
        else {
            return
        }
        
        cardImageView.contentMode = .scaleToFill
        cardImageView.image = newImg
        
        dismiss(animated: true, completion: nil)
    }
}
