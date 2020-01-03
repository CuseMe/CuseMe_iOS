//
//  Card.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

struct Card: Codable {
    
    let userIdx: Int?
    let cardIdx: Int
    let title: String
    let contents: String
    let imageURL: String
    let recordURL: String?
    let useCount: Int
    var visiblity: Bool
    let serialNum: String
    let sequence: Int
    var selected = false
    
    enum CodingKeys: String, CodingKey {
        case userIdx
        case cardIdx
        case title
        case contents = "content"
        case imageURL = "image"
        case recordURL = "record"
        case useCount = "count"
        case visiblity = "visible"
        case serialNum
        case sequence
    }
}
