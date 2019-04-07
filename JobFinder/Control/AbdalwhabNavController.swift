//
//  AbdalwhabNavController.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import UIKit

class AbdalwhabNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor(named: "purpleColor")
    }

}
