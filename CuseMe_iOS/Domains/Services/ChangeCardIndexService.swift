//
//  ChangeCardIndexService.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//
import Alamofire
import Foundation

class AuthService: APIManager, Requestable {
    func auth(uuid: String, completion: @escaping (ResponseDefault?, Error?) -> Void) {
        let url = Self.setURL("/cards/")
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4Ijo1MiwidXVpZCI6InRlc3QxIiwiaWF0IjoxNTc3OTgwNDk2LCJleHAiOjE1NzgwNjY4OTYsImlzcyI6ImdhbmdoZWUifQ.G9jAr2ca7UmbzdmN1xodHjZrlras8V1nVnwix4djidU"
        ]
        let body: Parameters = [
            "cardIdx" : 100,
            "visible" : 1,
            "sequence" : 105
        ]
        putable(url: url, type: ResponseDefault.self, body: body, header: header) {
        (response, error) in
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
