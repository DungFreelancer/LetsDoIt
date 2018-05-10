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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func onClickBtnNormal(_ sender: Any) {
      
    }
    

    @IBAction func onClickBtnCrazy(_ sender: Any) {
        
    }
    
    
    @IBAction func onClickBtnCustom(_ sender: Any) {
        let cardSelectionVC = CardSelectionVC()
        present(cardSelectionVC, animated: true, completion: nil)
    }
    
}
