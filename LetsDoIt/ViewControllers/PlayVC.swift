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

class PlayVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    @IBOutlet weak var btnMode: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    private let playVM = PlayVM()
    private var timerPlay: Timer?
    private var tempWidth: CGFloat = 0.0
    private var countLoop = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.hideNavigationBar(true)
        
        let modeSelectionVC = DestinationView.modeSelectionVC()
        modeSelectionVC.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Move to the middle of the card list
        self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow() / 2, section: 0),
                                 at: .centeredHorizontally,
                                 animated: false)
        
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
        
        let sliderLayout = GravitySliderFlowLayout(with: CGSize(width: 200, height: 345))
        self.clCard.collectionViewLayout = sliderLayout
    }
    
    func configAutoscrollTimer() {
        self.countLoop += 1
        
        if self.countLoop == 1 {
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 500 {
            self.deconfigAutoscrollTimer()
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 900 {
            self.deconfigAutoscrollTimer()
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.004, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 1100 {
            self.deconfigAutoscrollTimer()
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 1200 {
            self.deconfigAutoscrollTimer()
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.011, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 1250 {
            self.deconfigAutoscrollTimer()
            self.timerPlay = Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(offsetCard), userInfo: nil, repeats: true)
        } else if self.countLoop == 1322 {
            self.deconfigAutoscrollTimer()
            self.flipCard(at: self.playVM.randomIndexCard())
          
            
            let timeDelay = 2.0 // second unit
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay, execute: {
                self.showSaveMomentPopup()
                self.btnMode.isHidden = false
                self.btnPlay.isHidden = false
            })
        }
    }
    
    func deconfigAutoscrollTimer() {
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
        
        self.configAutoscrollTimer()
    }
    
    @objc func showSaveMomentPopup() {
        AlertHelper.showPopup(on: self, title: nil, message: "Wana save this moment?".localized(), mainButton: "Yes".localized(), mainComplete: { (action:UIAlertAction) in
            self.navigationController?.pushViewController(DestinationView.recordVC(), animated: true)
        }, otherButton: "No".localized(), otherComplete: nil)
    }
    
    func flipCard(at index: Int) {
        let cardRandom = self.playVM.getCard(at: index)
        let cellCenter = self.clCard.cellForItem(at: IndexPath(item: 16394, section: 0)) as! CardCell
        
        UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            cellCenter.imgCard.image = cardRandom?.image
        }, completion: nil)
    }
    
    // MARK: - Action
    @IBAction func onClickGoToModeSelectionVC(_ sender: Any) {
        self.navigationController?.pushViewController(DestinationView.modeSelectionVC(), animated: true)
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        self.btnMode.isHidden = true
        self.btnPlay.isHidden = true
        // Move to the middle of the card list
        self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow() / 2, section: 0),
                                 at: .centeredHorizontally,
                                 animated: false)
        
        self.countLoop = 0
        self.configAutoscrollTimer()
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

extension PlayVC : ModeSelectionVCDelegate {
    func passMode(mode: String) {
        Log.debug(mode)
        self.playVM.changeMode(mode: mode)
    }
}
