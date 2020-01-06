//
//  AuthService.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper

class AuthService: APIManager, Requestable {
    
    // UUID 인증
    func auth(completion: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/auth/start")
        
        let uuid = KeychainWrapper.standard.string(forKey: "uuid") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "uuid" : uuid
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
    
    // 관리자 모드 인증
    func admin(password: String, completion: @escaping (ResponseObject<Token>?, Error?) -> Void) {
        
        let url = Self.setURL("/auth/signin")
        
        let uuid = KeychainWrapper.standard.string(forKey: "uuid") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "uuid" : "\(uuid)",
            "password" : "\(password)"
        ]
        
        postable(url: url, type: ResponseObject<Token>.self, body: body, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
