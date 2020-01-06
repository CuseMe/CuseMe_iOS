//
//  CardService.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/03.
//  Copyright © 2020 cuseme. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper
import AVFoundation

class CardService: APIManager, Requestable {
    
    // 발달 장애인 카드 조회
    func visibleCards(completion: @escaping (ResponseArray<Card>?, Error?) -> Void) {

        let url = Self.setURL("/cards/visible")
        
        let uuid = KeychainWrapper.standard.string(forKey: "uuid") ?? ""

        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        
        let body: Parameters = [
            "uuid": "\(uuid)"
        ]
        
        postable(url: url, type: ResponseArray<Card>.self, body: body, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 전체 카드 조회
    func allCards(completion: @escaping (ResponseArray<Card>?, Error?) -> Void) {
        
        let url = Self.setURL("/cards")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        getable(url: url, type: ResponseArray<Card>.self, body: nil, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 카드 사용 빈도 증가
    func increaseUseCount(cardIdx: Int, completion: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/\(cardIdx)/count")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        putalbe(url: url, type: ResponseDefault.self, body: nil, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 카드 전체 수정
    func updateCards(cards: [Card], completion: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/cards")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        let body: Parameters = [
            "arr": "\(cards)"
        ]
        
        putalbe(url: url, type: ResponseDefault.self, body: body, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func cardDetail(cardIdx: Int, completion: @escaping (ResponseObject<Card>?, Error?) -> Void) {
        let url = Self.setURL("/cards/\(cardIdx)")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
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
    
    func download(serialNumber: String, completion: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/\(serialNumber)")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        postable(url: url, type: ResponseDefault.self, body: nil, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 카드 생성
    func addCard(image: UIImage, record: URL?, title: String, content: String, visiblity: Bool, complection: @escaping (ResponseDefault?, Error?) -> Void) {
        
        let url = Self.setURL("/cards")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : "\(token)"
        ]
        
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            if record != nil {
                multipart.append(record!, withName: "record", fileName: "record.m4a", mimeType: "audio/m4a")
            }
            multipart.append(title.data(using: .utf8)!, withName: "title")
            multipart.append(content.data(using: .utf8)!, withName: "content")
            multipart.append("\(visiblity)".data(using: .utf8)!, withName: "visible")
        }, to: url, method: .post, headers: header) { result in
            switch result {
            case .success(let upload, _, _):
                print("upload: \(upload)")
                
                upload.responseJSON { res in
                    switch res.result {
                    case .success:
                        if let data = res.data {
                            do {
                                let result = try JSONDecoder().decode(ResponseDefault.self, from: data)
                                
                                complection(result, nil)
                            } catch (let error) {
                                print("catch: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        print("failure1: \(error.localizedDescription)")
                        complection(nil, error)
                    }
                }
            case .failure(let error):
                print("failure2: \(error.localizedDescription)")
                complection(nil, error)
            }
        }
    }
    
    func editCard(cardIdx: Int, image: UIImage, record: URL?, title: String, content: String, visiblity: Bool, complection: @escaping (ResponseObject<EditCard>?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/\(cardIdx)")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "token" : "\(token)"
        ]
        
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            if record != nil {
                multipart.append(record!, withName: "record", fileName: "record.m4a", mimeType: "audio/m4a")
            }
            multipart.append(title.data(using: .utf8)!, withName: "title")
            multipart.append(content.data(using: .utf8)!, withName: "content")
            multipart.append("\(visiblity)".data(using: .utf8)!, withName: "visible")
        }, to: url, method: .put, headers: header) { result in
            switch result {
            case .success(let upload, _, _):
                print("upload: \(upload)")
                
                upload.responseJSON { res in
                    switch res.result {
                    case .success:
                        if let data = res.data {
                            do {
                                let result = try JSONDecoder().decode(ResponseObject<EditCard>.self, from: data)
                                
                                complection(result, nil)
                            } catch (let error) {
                                print("catch: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        print("failure1: \(error.localizedDescription)")
                        complection(nil, error)
                    }
                }
            case .failure(let error):
                print("failure2: \(error.localizedDescription)")
                complection(nil, error)
            }
        }
    }
    
    func deleteCard(cardIdx: Int, completion: @escaping (ResponseDefault?, Error?) -> Void) {
        let url = Self.setURL("/cards/\(cardIdx)")
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        delete(url: url, type: ResponseDefault.self, body: nil, header: header) {
            response, error in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }   
        }
    }
    
    func downloader(url: URL, completion: @escaping (URL) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("sound.m4a")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).response { response in
            debugPrint(response)

            if response.error == nil, let recordPath = response.destinationURL?.path {
                let url = URL(fileURLWithPath: recordPath)
                completion(url)
            }
        }
    }
}
