//
//  PlayVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import MobileCoreServices
import GravitySliderFlowLayout
import AVFoundation

enum RecordType: String {
    case Snapshot
    case Video
}

class PlayVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    {
        didSet{
            clCard.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var btnPlay: UIButton!
    {
        didSet {
            btnPlay.layer.cornerRadius = 5
            btnPlay.layer.masksToBounds = true
        }
    }
    
    private let playVM = PlayVM()
    private var timerPlay: Timer?
    private var tempWidth: CGFloat = 0.0
    private var countLoop = 0
    private var isCardOpening: Bool = false
    
    private var isOpeningSubMenu: Bool = false
    
    //menuButton and subMenuButton
    @IBOutlet weak var menuBtnView: UIView!
    {
        didSet{
            menuBtnView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var menuButton : UIButton!
        {
        didSet{

            menuButton.setBackgroundImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        }
    }
  
    @IBOutlet weak var chickenModeButton: UIButton!
        {
        didSet{
            chickenModeButton.setBackgroundImage(#imageLiteral(resourceName: "chicken"), for: .normal)
            chickenModeButton.alpha = 0
        }
    }
    @IBOutlet weak var alienModeButton: UIButton!
        {
        didSet{
            alienModeButton.setBackgroundImage(#imageLiteral(resourceName: "alien"), for: .normal)
            alienModeButton.alpha = 0
        }
    }
    @IBOutlet weak var customModeButton: UIButton!
        {
        didSet{
            customModeButton.setBackgroundImage(#imageLiteral(resourceName: "gears"), for: .normal)
            customModeButton.alpha = 0
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        self.setupActionForButtons()
        AudioPlayerService.sharedInstance.playSound(soundFileName: "pianosound")

        HUDHelper.showLoading()
        self.playVM.changeMode(mode: self.playVM.currentMode) { [weak self] (isSuccess) in
            HUDHelper.hideLoading()
            self?.clCard.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Move to the middle of the card list
        if self.playVM.cellRow() > 0 {
            self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow()/2, section: 0),
                                     at: .centeredHorizontally,
                                     animated: false)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != menuBtnView {
            if isOpeningSubMenu {
                onClickMenuButton()
            }
        }
    }
    
    // MARK: - Private method
    func setUpCollectionView() {
        self.clCard.register(UINib(nibName: CardCell.nibName, bundle: nil), forCellWithReuseIdentifier: CardCell.cellID)
        self.clCard.dataSource = self
        self.clCard.delegate = self
        self.clCard.isScrollEnabled = false
        
        let sliderLayout = GravitySliderFlowLayout(with: CGSize(width: CARD_SIZE.width, height: CARD_SIZE.height))
        self.clCard.collectionViewLayout = sliderLayout
    }
    
    func configAutosScrollTimer() {
        if SCREEN_SIZE.height == 375 && SCREEN_SIZE.width == 812 {
            self.countLoop += 1
            
            if self.countLoop == 1 {
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 500 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 900 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.004, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1100 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1200 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.011, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1250 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1322 {
                self.deconfigAutoScrollTimer()
                self.isCardOpening = false
                self.flipCard(at: 26)
                
                let timeDelay = 2.0 // second unit
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay, execute: {
                    self.showSaveMomentPopup()
                    self.menuButton.isHidden = false
                    self.btnPlay?.isHidden = false
                })
            }
        } else {
            
            self.countLoop += 1
            
            if self.countLoop == 1 {
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 500 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 900 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.004, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1100 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1200 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.011, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1250 {
                self.deconfigAutoScrollTimer()
                self.timerPlay = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
            } else if self.countLoop == 1322 {
                self.deconfigAutoScrollTimer()
                self.isCardOpening = false
                self.flipCard(at: 26)
                
                let timeDelay = 2.0 // second unit
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay, execute: {
                    self.showSaveMomentPopup()
                    self.menuButton.isHidden = false
                    self.btnPlay?.isHidden = false
                })
            }
        }
    }
    
    func deconfigAutoScrollTimer() {
       
        self.timerPlay?.invalidate()
        self.timerPlay = nil
    }
    
    @objc func offsetCard() {
        let initailPoint = CGPoint(x: tempWidth,y :0)
        
        if __CGPointEqualToPoint(initailPoint, clCard.contentOffset) {
            if tempWidth < clCard.contentSize.width {
                tempWidth += 1
            } else {
                tempWidth = -self.view.frame.size.width
            }
            
            let offsetPoint = CGPoint(x: tempWidth,y :0)
            clCard.contentOffset = offsetPoint
        } else {
            tempWidth = clCard.contentOffset.x
        }
        
        self.configAutosScrollTimer()
    }
    
    @objc func showSaveMomentPopup() {
        AlertHelper.showActionSheet(on: self, title: "Save This Moment".localized(), message: nil, firstButton: "Snapshot".localized(), firstComplete: {_ in
            let vc = DestinationView.recordVC()
            vc.recordType = RecordType.Snapshot
            self.navigationController?.pushViewController(vc, animated: false)
        }, secondButton: "Short Video".localized(), secondComplete: { (action:UIAlertAction) in
            let vc = DestinationView.recordVC()
            vc.recordType = RecordType.Video
            self.navigationController?.pushViewController(vc, animated: false)
        })
    }
    
    func flipCard(at index: Int) {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "flipping")
        guard let cellCenter = self.clCard.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCell else {
            // Fix crash for small screen
            self.isCardOpening = false
            return
        }
        
        if self.isCardOpening {
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromRight, animations: {
                cellCenter.imgCard.image = UIImage(named: "cardback")
                cellCenter.lbTitle.isHidden = true
            }, completion: nil)
            self.isCardOpening = false
        } else {
            let cardRandom = self.playVM.getCard(at: self.playVM.randomIndexCard())
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                cellCenter.imgCard.image = cardRandom?.image
                cellCenter.lbTitle.isHidden = false
            }, completion: nil)
            self.isCardOpening = true
        }
    }
   
    // MARK: - Action
    fileprivate func setupActionForButtons(){
        self.menuButton.addTarget(self, action: #selector(onClickMenuButton), for: .touchUpInside)
        self.chickenModeButton.addTarget(self, action: #selector(onClickChickenModeButton), for: .touchUpInside)
        self.alienModeButton.addTarget(self, action: #selector(onClickAlienModeButton), for: .touchUpInside)
        self.customModeButton.addTarget(self, action: #selector(onClickCustomModeButton), for: .touchUpInside)
    }
    
    @objc func onClickMenuButton() {
        //Open menubutton
        AudioPlayerService.sharedInstance.playSound(soundFileName: "onclick")
        if !isOpeningSubMenu {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.menuButton.transform = self.menuButton.transform.rotated(by: CGFloat(Double.pi * (0.999)))
                self.chickenModeButton.alpha = 0
            }) { (true) in
                self.showChikenButton()
            }
            self.isOpeningSubMenu = true
            
            
        } else {
            //close menubutton
            UIView.animate(withDuration: 0.3, animations: {
                self.menuButton.transform = self.menuButton.transform.rotated(by: CGFloat(Double.pi/0.999 ))
                self.customModeButton.alpha = 0
            }) { (true) in
                self.showAlienButton()
            }
            self.isOpeningSubMenu = false
            
        }
    }
    
    fileprivate func showChikenButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.chickenModeButton.alpha = self.isOpeningSubMenu == true ? 1 : 0
            
        }) {(true) in
            if self.isOpeningSubMenu {
                self.showAlienButton()
            }
        }
    }
    
    fileprivate func showAlienButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alienModeButton.alpha = self.isOpeningSubMenu == true ? 1 : 0
            
        }){(true) in
            if self.isOpeningSubMenu {
                self.showCustomButton()
            } else {
                self.showChikenButton()
            }
        }
    }
    
    fileprivate func showCustomButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.customModeButton.alpha = self.isOpeningSubMenu == true ? 1 : 0
        })
    }
    
    @objc func onClickChickenModeButton() {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "chickensound")
        if self.isCardOpening {
                self.flipCard(at: 26)
        }
        self.playVM.changeMode(mode: .Chicken)
    }
    
    @objc func onClickAlienModeButton() {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "aliensound")
        if self.isCardOpening {
                self.flipCard(at: 26)
        }
        self.playVM.changeMode(mode: .Alien)
        
    }
    
    @objc func onClickCustomModeButton() {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "onclick")
        if self.isCardOpening {
                self.flipCard(at: 26)
                }
        let vc = DestinationView.cardSelectionVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        AudioPlayerService.sharedInstance.playSound(soundFileName: "onclick")
        self.menuButton?.isHidden = true
        if isOpeningSubMenu {
            onClickMenuButton()
        }
        self.btnPlay?.isHidden = true
        if self.isCardOpening {
            self.flipCard(at: 26)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            AudioPlayerService.sharedInstance.playSound(soundFileName: "flipsound")

            // Move to the middle of the card list
            self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow()/2, section: 0),
                                     at: .centeredHorizontally,
                                     animated: false)
            
            self.countLoop = 0
            self.configAutosScrollTimer()
        }
    }
}

extension PlayVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.playVM.cellRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.playVM.cellInstance(collectionView: collectionView, indexPath: indexPath)
    }
    
}
extension PlayVC: CardSelectionDelegate {
    
    func passCustomCards(_ arrCard: [Card]) {
        self.playVM.changeToCards(arrCard)
        self.playVM.currentMode = .Custom
    }
    
}
