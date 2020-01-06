//
//  EditCard.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/04.
//  Copyright © 2020 cuseme. All rights reserved.
//

struct EditCard: Codable {
    var cardIdx: Int
    let title: String
    let contents: String
    let imageURL: String
    let recordURL: String?
    let serialNum: String
    
    enum CodingKeys: String, CodingKey {
        case cardIdx
        case title
        case contents = "content"
        case imageURL = "image"
        case recordURL = "record"
        case serialNum
    }
}
