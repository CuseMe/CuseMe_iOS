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
        return "http://13.125.41.98:3000" + path
    }
}
