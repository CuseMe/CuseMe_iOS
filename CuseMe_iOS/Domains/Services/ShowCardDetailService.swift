//
//  ShowCardDetailService.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//
import Alamofire
import Foundation

class AuthService: APIManager, Requestable {
    
    // UUID 인증
    func auth(uuid: String, completion: @escaping (ResponseObject<Card>?, Error?) -> Void) {
        let url = Self.setURL("/cards/1")
        let header: HTTPHeaders = [
             "Content-Type" : "application/json",
            "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1MiwidXVpZCI6InRlc3QxIiwiaWF0IjoxNTc3OTgwNDk2LCJleHAiOjE1NzgwNjY4OTYsImlzcyI6ImdhbmdoZWUifQ.G9jAr2ca7UmbzdmN1xodHjZrlras8V1nVnwix4djidU"
        ]
        getable(url: url, type: ResponseObject<Card>.self, body: nil, header: header) {
        (response, error) in
            if response != nil {
                       completion(response, nil)
                   } else {
                       completion(nil, error)
                   }
        }
    }
}
