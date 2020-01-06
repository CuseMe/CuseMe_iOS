//
//  CreateCardVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/04.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit
import AVFoundation

class CreateCardVC: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cardImageAreaView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var ttsNoticeView: UIView!
    @IBOutlet weak var recordStackView: UIStackView!
    
    @IBOutlet weak var cardImageAreaViewTopAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var ttsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var streamingPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var streamingURL: URL?
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var audioSession: AVAudioSession?
    private var soundFileURL: URL?
    private var docsDir: String?
    private var done = false
    private var outputURL: URL?
    
    private let picker = UIImagePickerController()
    private let placeholder = "카드 내용을 입력해주세요"
    private var shouldSelectImage = false
    
    private var cardService = CardService()
    var card: Card?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDirectoryPath()
        setAudioSession()
        readyForRecord()
        setTextViewPlaceholder()
        receiveData()
        setButtonImage()
        setConerRadius()
        setShadow()
        initGestureRecognizer()
        
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    private func setDirectoryPath() {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = dirPaths[0] as String
        let soundFilePath = docsDir?.appending("/sound.caf")
        soundFileURL = URL(fileURLWithPath: soundFilePath!)
    }
    
    private func setAudioSession() {
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
        AVEncoderBitRateKey: 16,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey: 44100.0] as [String : Any]
        
        audioSession = AVAudioSession.sharedInstance()
        
        guard let audioSession = audioSession else { return }
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
    }
    
    // MARK: IBAction
    @IBAction func exitButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        // TODO: 생성 이후 카드 상세, 입력 후 다운로드 로직
        guard let newImage = cardImageView.image else { return }
        guard let title = titleTextField.text else { return }
        guard let content = contentTextView.text else { return }
        
        if content == placeholder || !shouldSelectImage {
            let alert = UIAlertController(title: "실패", message: "내용을 입력하세요.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true)
            return
        }
        
        if let cardIdx = card?.cardIdx, playerItem != nil {
            cardService.editCard(cardIdx: cardIdx, image: newImage, record: outputURL, title: title, content: content, visiblity: true) { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                print(response)
                
                if response.success {
                    // TODO: 카드 상세로 가야됨
                    
                    weak var pvc = self.presentingViewController as? CardDetailVC
                    pvc?.card?.cardIdx = (response.data?.cardIdx)!
                    self.dismiss(animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: response.message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true)
                }
            }
        } else {
            cardService.addCard(image: newImage, record: outputURL, title: title, content: content, visiblity: true) { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                
                print(response)
                
                if response.success {
                    // TODO: 카드 상세로 가야됨
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "실패", message: response.message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func ttsButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            ttsNoticeView.isHidden = false
            recordStackView.isHidden = true
            outputURL = nil
            readyForRecord()
        } else {
            ttsNoticeView.isHidden = true
            recordStackView.isHidden = false
        }
    }
    
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        if playerItem != nil {
            guard !(streamingPlayer?.isPlaying ?? false) else { return }
            streamingPlayer = AVPlayer(playerItem: playerItem)
            streamingPlayer?.rate = 1.0
            streamingPlayer?.play()
            playerItem = AVPlayerItem(url: streamingURL!)
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
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
            // TODO: 프로그레스바 스탑하고 감추기
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.mainpink
            audioPlayer?.stop()
        }
    }
    
    @IBAction func recordButtonDidTap(_ sender: UIButton) {
        done = false
        sender.isSelected = !sender.isSelected
        
        if playerItem != nil { playerItem = nil }
        
        if sender.isSelected {
            // TODO: 버튼 위에 시간 초 라벨이 생기고 매초 시간이 늘어야 함.
            playButton.isHidden = true
            confirmButton.isHidden = true
            audioRecorder?.record()
            //
        } else {
            // TODO: 버튼 위에 시간 초가 없어짐
            playButton.isHidden = false
            playButton.isEnabled = true
            confirmButton.isHidden = false
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.mainpink
            audioRecorder?.stop()
        }
    }
    
    @IBAction func confirmButtonDidTap(_ sender: UIButton) {
        done = true
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = UIColor.veryLightPinkTwo
        convertToM4A()
    }
}

// MARK: extension for TextView {
extension CreateCardVC: UITextViewDelegate {
    func setTextViewPlaceholder() {
        contentTextView.delegate = self
        contentTextView.text = placeholder
        contentTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.textBrownBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: extension for UIImagePicker
extension CreateCardVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImg = UIImage()
        
        if let possibleImg = info[.editedImage] as? UIImage {
            newImg = possibleImg
        } else if let possibleImg = info[.originalImage] as? UIImage {
            newImg = possibleImg
        } else { return }
        
        cardImageView.contentMode = .scaleToFill
        cardImageView.image = newImg
        shouldSelectImage = true
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: extension for UIGestureRecognizer
extension CreateCardVC: UIGestureRecognizerDelegate {
   
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
        self.contentTextView.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let _ = touch.view?.isDescendant(of: titleTextField) else { return false }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [weak self] in
            guard let self = self else { return }
            
            let value = (self.cardImageView.frame.height/2)
            self.cardImageAreaViewTopAnchor.constant = -value
            
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
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [weak self] in
            guard let self = self else { return }
            
            self.cardImageAreaViewTopAnchor.constant = 57
            
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

// MARK: extension for AVAudioRecoder
extension CreateCardVC: AVAudioRecorderDelegate {
    // 시간 제한으로 녹음 종료하면 호출
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record Success")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}

// MARK: extension for AVAudioPlayer
extension CreateCardVC: AVAudioPlayerDelegate {
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

// MARK: extension for CreateCardVC
extension CreateCardVC {
    func readyForRecord() {
        recordButton.isSelected = false
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = UIColor.veryLightPinkTwo
        playButton.isEnabled = false
        done = false
    }
    
    func receiveData() {
        guard let card = card else { return }
        shouldSelectImage = true
        cardImageView.kf.setImage(with: URL(string: card.imageURL))
        titleTextField.text = card.title
        contentTextView.text = card.contents
        if card.contents.count > 0 {
            contentTextView.textColor = UIColor.textBrownBlack
        }
        // TODO: TTS 뷰
        if let recordURL = card.recordURL {
            streamingURL = URL(string: recordURL)
            playerItem = AVPlayerItem(url: streamingURL!)
            downloadM4A()
            
            playButton.isEnabled = true
            playButton.isSelected = false
            done = true
        } else {
            ttsButton.isSelected = true
            recordStackView.isHidden = true
            ttsNoticeView.isHidden = false
        }
    }
    
    func setButtonImage() {
        playButton.setImage(UIImage(named: "btnMakecardPlayUnselected"), for: .disabled)
        playButton.setImage(UIImage(named: "btnMakecardPlaySelected"), for: .normal)
        playButton.setImage(UIImage(named: "btnMakecardPlayDeselected"), for: .selected)
        recordButton.setImage(UIImage(named: "recordButton"), for: .normal)
        recordButton.setImage(UIImage(named: "recordStopButton"), for: .selected)
        ttsButton.setImage(UIImage(named: "icMakecardMakettsUnselected"), for: .normal)
        ttsButton.setImage(UIImage(named: "icMakecardMakettsSelected"), for: .selected)
    }
    
    func setConerRadius() {
        addButton.setCornerRadius(cornerRadius: nil)
        cardImageAreaView.setCornerRadius(cornerRadius: 5)
        cardImageView.setCornerRadius(cornerRadius: 5)
        confirmButton.setCornerRadius(cornerRadius: nil)
        ttsNoticeView.setCornerRadius(cornerRadius: 3)
    }
    
    func setShadow() {
        cardImageAreaView.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.16, radius: 3)
        recordButton.setShadow(color: UIColor.black, offSet: CGSize(width: 0, height: 0), opacity: 0.2, radius: 3)
    }
    
    func showImagePicker() {
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
    
    func downloadM4A() {
        guard let streamingURL = streamingURL else { return }
        
        cardService.downloader(url: streamingURL) { [weak self] url in
            self?.outputURL = url
        }
    }
    
    func convertToM4A() {
        guard let soundFileURL = soundFileURL else { return }
        let asset = AVAsset.init(url: soundFileURL)
        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        
        let fileManager = FileManager.default
        let outputPath = docsDir?.appending("/record.m4a")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}

