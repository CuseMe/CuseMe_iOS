//
//  AuthSigninService.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//
import Alamofire
import Foundation

class AuthService: APIManager, Requestable {
    func auth(uuid: String, completion: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/auth/signin")
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
        ]

        let body: Parameters = [
            "uuid":"test1",
            "password":"5555"
        ]


        postable(url: url, type: ResponseDefault.self, body: body, header: header) {
        (response, error) in

        if response != nil {
                       completion(response, nil)
                   } else {
                       completion(nil, error)
                   }
        }
    }
}
