//
//  ModeSelectionVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/9/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import CircleMenu

protocol ModeSelectionVCDelegate: class {
    func passMode(mode: String)
}

class ModeSelectionVC: BaseVC {
    
    private let modeSelectionVM = ModeSelectionVM()
    private let playVM = PlayVM()
    
    var delegate: ModeSelectionVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnMenu = CircleMenu(
            frame: CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 20, width: 40, height: 40),
            normalIcon:"menu",
            selectedIcon:"icon_close",
            buttonsCount: 3,
            duration: 2,
            distance: 120)
        
        btnMenu.delegate = self
        btnMenu.layer.cornerRadius = btnMenu.frame.size.width / 2.0
        view.addSubview(btnMenu)
    }
}
extension ModeSelectionVC: CircleMenuDelegate {
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = modeSelectionVM.items[atIndex].color
        
        button.setImage(UIImage(named: modeSelectionVM.items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: modeSelectionVM.items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
        if atIndex == 0 {
            self.delegate?.passMode(mode: "Normal") 
            self.navigationController?.popViewController(animated: true)
        } else if atIndex == 1 {
            self.delegate?.passMode(mode: "Crazy")
            self.navigationController?.popViewController(animated: true)
        } else if atIndex == 2 {
            self.navigationController?.pushViewController(DestinationView.cardSelectionVC(), animated: true)
        }
    }
    
    //    // configure buttons
    //    optional func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int)
    //
    //    // call before animation
    //    optional func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int)
    //
    //    // call after animation
    //    optional func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int)
    //
    //    // call upon cancel of the menu
    //    optional func menuCollapsed(circleMenu: CircleMenu)
}

