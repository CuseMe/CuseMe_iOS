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

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        
    }
    
    @IBAction func recordButtonDidTap(_ sender: UIButton) {
        
    }
    
    @IBAction func confirmButtonDidTap(_ sender: UIButton) {
        
    }
}

extension CreateCardVC: AVAudioRecorderDelegate {
    // 시간 제한으로 녹음 종료하면 호출
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record Success")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}

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
