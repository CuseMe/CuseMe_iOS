//
//  APIManager.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

protocol APIManager {}

extension APIManager {
    public static func setURL(_ path: String) -> String {
        return "http://15.165.108.23:3000" + path
    }
}
