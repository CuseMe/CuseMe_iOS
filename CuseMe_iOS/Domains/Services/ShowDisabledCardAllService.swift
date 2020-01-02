//
//  ShowDisabledCardAllService.swift
//  CuseMe_iOS
//
//  Created by Yujin Shin on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//
import Alamofire
import Foundation

class AuthService: APIManager, Requestable {
    
    // UUID 인증
    func auth(uuid: String, completion: @escaping (ResponseArray<Card>?, Error?) -> Void) {
        let url = Self.setURL("/cards/visible")
        let header: HTTPHeaders = [
             "uuid": "5404066F-13CC-4BA2-8D68-4DA0B590C754"
           
        ]
        postable(url: url, type: ResponseArray<Card>.self, body: nil, header: header) {
        (response, error) in
            if response != nil {
                completion(response, nil)
                   } else {
                completion(nil, error)
                   }
        }
    }
}
