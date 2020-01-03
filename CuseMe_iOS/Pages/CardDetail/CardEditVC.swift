//
//  CardEditVC.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit
import AVFoundation

// TODO: 버그 수정

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
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var soundFileURL: URL?
    private var docsDir: String?
    private var done = false
    private var outputURL: URL?
    
    private let cardService = CardService()
    
    let picker = UIImagePickerController()
    let defaultImage = UIImage(named: "icMakecardPhoto")
    
    var addButtonString: String = ""
    var card: Card?
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGestureRecognizer()
        recordButton.setImage(UIImage(named: "recordButton"), for: .normal)
        recordButton.setImage(UIImage(named: "recordStopButton"), for: .selected)
        /*
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPaths[0] as String
        let soundFilePath = docsDir?.appending("/sound.caf")
        soundFileURL = URL(fileURLWithPath: soundFilePath!)
        
        if cardImageView.image == defaultImage {
            emptyLabel.isHidden = false
            cardImageView.contentMode = .center
        }
        
        // set record Settings
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            print("audioSession error: \(error.localizedDescription)")
        }

        do {
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            guard let soundFileURL = soundFileURL else { return }
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("audioSession Error: \(error.localizedDescription)")
        }
        */
        picker.delegate = self
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if addButtonString == "수정" {
            reciveData()
        }
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    private func reciveData() {
        guard let card = card else { return }
        // TODO: 카드 데이터 받기
        cardImageView.kf.setImage(with: URL(string: card.imageURL))
        titleTextField.text = card.title
        contentsTextView.text = card.contents
        if card.contents.count > 0 {
            contentsTextView.textColor = UIColor.textBrownBlack
        }
    }
    
    func setUI() {
        /*
        placeholderSetting()
        
        
        addButton.setCornerRadius(cornerRadius: nil)
        cardImageAreaView.setCornerRadius(cornerRadius: 5)
        cardImageView.setCornerRadius(cornerRadius: 5)
        cardImageAreaView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
        
        confirmButton.setCornerRadius(cornerRadius: nil)
        confirmButton.tintColor = UIColor.clear
        recordButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
        
        

        ttsButton.setImage(UIImage(named: "icMakecardMakettsUnselected"), for: .normal)
        ttsButton.setImage(UIImage(named: "icMakecardMakettsSelected"), for: .selected)
        
        playButton.setImage(UIImage(named: "btnMakecardPlayUnselected"), for: .disabled)
        playButton.setImage(UIImage(named: "btnMakecardPlaySelected"), for: .normal)
        playButton.setImage(UIImage(named: "btnMakecardPlayDeselected"), for: .selected)
        */
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
        // TODO: 생성 이후 카드 상세, 입력 후 다운로드 로직
        guard let newImage = cardImageView.image else { return }
        guard let title = titleTextField.text else { return }
        guard let contents = contentsTextView.text else { return }
        
        cardService.addCard(image: newImage, record: outputURL, title: title, contents: contents, visiblity: true) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else { return }
            
            print(response)
            
            if response.success {
                // TODO: 카드 상세로 가야됨
                self.dismiss(animated: true, completion: nil)
            } else {
            }
        }
        
        // TODO: 추가, 수정 버튼 눌렀을 때
    }
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            // 중지 버튼으로 변해야할 때
            // 즉 재생해야할 때
            // TODO: 프로그레스바 호출
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.veryLightPinkTwo
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder!.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        } else {
            // 중지 버튼일 때, 다시 재생버튼으로 변해야할 때
            // TODO: 프로그레스바 스탑하고 감추기
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.mainpink
            audioPlayer?.stop()
        }
    }
    
    @IBAction func recordDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            // 녹음 시작, 그림자 있는 네모 버튼으로 바뀌었음.
            // TODO: 버튼 위에 시간 초 라벨이 생기고 매초 시간이 늘어야 함
            // 색깔도 변화해야함.
            playButton.isHidden = true
            confirmButton.isHidden = true
            audioRecorder?.record()
            //
        } else {
            // 녹음 중지
            // TODO: 버튼 위에 시간 초가 없어짐
            //
            playButton.isHidden = false
            playButton.isEnabled = true
            confirmButton.isHidden = false
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.mainpink
            audioRecorder?.stop()
        }
    }
    
    @IBAction func confirmButtonDidTap(_ sender: UIButton) {
        // TODO: '녹음이 완료되었습니다.' 색깔도 변화해야함.
        done = true
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = UIColor.veryLightPinkTwo
        convertToM4A()
    }
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func convertToM4A() {
        // convert m4a
        guard let soundFileURL = soundFileURL else { return }
        let asset = AVAsset.init(url: soundFileURL)
        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        
        let fileManager = FileManager.default
        let outputPath = docsDir?.appending("/sound.m4a")
        outputURL = URL(fileURLWithPath: outputPath!)
        
        do {
            try fileManager.removeItem(at: outputURL!)
        } catch {
            print("can't")
        }
        
        exportSession?.outputFileType = AVFileType.m4a
        exportSession?.outputURL = outputURL
        exportSession?.metadata = asset.metadata
        
        exportSession?.exportAsynchronously {
            if (exportSession?.status == .completed) {
                print("AV export succeeded.")
            }
            else if (exportSession?.status == .cancelled) {
                print("AV export cancelled.")
            }
            else {
                print ("Error is \(String(describing: exportSession?.error))")
            }
        }
        
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

extension CardEditVC: AVAudioRecorderDelegate {
    // 시간 제한으로 녹음 종료하면 호출
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record Success")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}

extension CardEditVC: AVAudioPlayerDelegate {
    // 재생 종료하면 호출
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // TODO: 프로그레스바 감추기
        playButton.isSelected = false
        if !done {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.mainpink
        }
        
    }
    
    // 디코더 에러 발생하면 호출
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Player Decode Error")
    }
}
