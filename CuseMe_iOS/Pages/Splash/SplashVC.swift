//
//  SplashVC.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2020/01/02.
//  Copyright © 2020 cuseme. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SplashVC: UIViewController {
    
    let authService = AuthService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let retrievedString = KeychainWrapper.standard.string(forKey: "uuid") {
            print("Retrieved : \(retrievedString)")
        } else {
            let uuid = UUID().uuidString
            let saveSuccessful = KeychainWrapper.standard.set(uuid, forKey: "uuid")
            print("Save was successful: \(saveSuccessful)")
        }
        
        guard let uuid = KeychainWrapper.standard.string(forKey: "uuid") else {
            return // TODO: 앱 종료
        }
        print(uuid)
        auth(uuid)
    }
    
    func auth(_ uuid: String) {
        authService.auth(uuid: uuid) { [weak self] response, Error in
            
            guard let self = self else { return }
            guard let response = response else { return }
            
            print(response)
            
            if response.status == 200 {
                let dvc = UIStoryboard(name: "HomeDisabled", bundle: nil).instantiateViewController(withIdentifier: "HomeDisabledNC") as! UINavigationController
                dvc.modalPresentationStyle = .fullScreen
                
                self.present(dvc, animated: true)
            } else {
                // TODO: 앱 종료
            }
        }
    }
}
