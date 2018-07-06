//
//  ViewController.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 9/30/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - private function
    func hideNavigationBar(_ isHidden: Bool) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bg"), for: UIBarMetrics.default )
    }
    
}

