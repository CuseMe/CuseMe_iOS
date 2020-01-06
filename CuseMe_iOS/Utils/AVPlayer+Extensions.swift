//
//  AVPlayer+Extensions.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
