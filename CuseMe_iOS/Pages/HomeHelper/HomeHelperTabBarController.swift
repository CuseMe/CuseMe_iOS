//
//  HomeHelperTabBarController.swift
//  CuseMe_iOS
//
//  Created by wookeon on 2019/12/25.
//  Copyright © 2019 cuseme. All rights reserved.
//

import UIKit

class HomeHelperTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tabItems = tabBarController?.tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
    }
}
