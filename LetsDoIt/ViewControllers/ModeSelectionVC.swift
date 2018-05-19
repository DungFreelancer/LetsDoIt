//
//  ModeSelectionVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/9/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

class ModeSelectionVC: BaseVC {
    
    @IBOutlet weak var btnNormal: UIButton!
    @IBOutlet weak var btnCrazy: UIButton!
    @IBOutlet weak var btnCustom: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNormal.titleLabel?.text = "Normal".localized()
        btnCrazy.titleLabel?.text = "Crazy".localized()
        btnCustom.titleLabel?.text = "Custom".localized()
    }
    
    // MARK: - Action
    @IBAction func onClickBtnNormal(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func onClickBtnCrazy(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBtnCustom(_ sender: Any) {
        self.navigationController?.pushViewController(DestinationView.cardSelectionVC(), animated: true)
    }
    
}
