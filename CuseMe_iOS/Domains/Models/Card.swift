//
//  Card.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/26.
//  Copyright © 2019 cuseme. All rights reserved.
//

import Foundation

struct Card: Decodable {
    let imageURL: String
    let title: String
    let contents: String
    let record: String?
    let visible: Bool
    let useCount: Int
    let serialNum: String
}
