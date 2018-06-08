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
import Floaty

class PlayVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    @IBOutlet weak var btnPlay: UIButton!
    
    private var btnMenu = Floaty()
    private let playVM = PlayVM()
    private var timerPlay: Timer?
    private var tempWidth: CGFloat = 0.0
    private var countLoop = 0
    private var isCardOpen: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBtnMenu()
        self.setUpCollectionView()
        
        HUDHelper.showLoading()
        self.playVM.changeMode(mode: self.playVM.currentMode) { [weak self] (isSuccess) in
            HUDHelper.hideLoading()
            self?.clCard.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.hideNavigationBar(true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.hideNavigationBar(false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    private func addBtnMenu() {
        //adjust btnMenu
        self.btnMenu.buttonColor = UIColor.clear
        self.btnMenu.buttonImage = UIImage(named: "galaxy")
        self.btnMenu.verticalDirection = .down
        
        //adjust location btnMenu
        self.btnMenu.paddingX = 8
        self.btnMenu.paddingY = SCREEN_SIZE.height - self.btnMenu.frame.height - 26
        
        //add item to btnMenu
        self.btnMenu.addItem(icon: UIImage(named: "chicken")) { (item) in
            if self.isCardOpen {
                self.flipCard(at: 26)
            }
            self.playVM.changeMode(mode: .Chicken)
        }
        self.btnMenu.addItem(icon: UIImage(named: "alien")) { (item) in
            if self.isCardOpen {
                self.flipCard(at: 26)
            }
            self.playVM.changeMode(mode: .Alien)
        }
        self.btnMenu.addItem(icon: UIImage(named: "gears")) { (item) in
            if self.isCardOpen {
                self.flipCard(at: 26)
            }
            let vc = DestinationView.cardSelectionVC()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.btnMenu.addItem(icon: UIImage(named: "info")) { (item) in
            let vc = DestinationView.InfoVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.view.addSubview(self.btnMenu)
    }
    
    func configAutosScrollTimer() {
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
            self.isCardOpen = false
            self.flipCard(at: 26)
          
            let timeDelay = 2.0 // second unit
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay, execute: {
                self.showSaveMomentPopup()
                self.btnMenu.isHidden = false
                self.btnPlay.isHidden = false
            })
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
        AlertHelper.showPopup(on: self, title: nil, message: "Wana save this moment?".localized(), mainButton: "Yes".localized(), mainComplete: { (action:UIAlertAction) in
            self.navigationController?.pushViewController(DestinationView.recordVC(), animated: true)
        }, otherButton: "No".localized(), otherComplete: nil)
    }
    
    func flipCard(at index: Int) {
        guard let cellCenter = self.clCard.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCell else {
            // Fix crash for small screen
            self.isCardOpen = false
            return
        }
        
        if self.isCardOpen {
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromRight, animations: {
                cellCenter.imgCard.image = UIImage(named: "Card_Back")
            }, completion: nil)
            self.isCardOpen = false
        } else {
            let cardRandom = self.playVM.getCard(at: self.playVM.randomIndexCard())
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                cellCenter.imgCard.image = cardRandom?.image
            }, completion: nil)
            self.isCardOpen = true
        }
    }
   
    // MARK: - Action
    @IBAction func onClickPlay(_ sender: Any) {
        self.btnMenu.isHidden = true
        self.btnPlay.isHidden = true
        
        if self.isCardOpen {
            self.flipCard(at: 26)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
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


