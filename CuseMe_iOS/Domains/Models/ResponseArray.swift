//
//  ResponseArray.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

struct ResponseArray<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [T]?
}
