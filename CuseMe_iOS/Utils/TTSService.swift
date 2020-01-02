//
//  TTSService.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/31.
//  Copyright © 2019 cuseme. All rights reserved.
//

import AVFoundation

class TTSService {
        
    func call(_ contents: String, completion: @escaping (AVSpeechUtterance) -> Void) {

        let utterance = AVSpeechUtterance(string: contents)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5
        
        completion(utterance)
    }
}
