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
import Macaw
import FanMenu

class PlayVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    @IBOutlet weak var btnMode: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var fanMenu: FanMenu!
    
    
    private let playVM = PlayVM()
    private var timerPlay: Timer?
    private var tempWidth: CGFloat = 0.0
    private var countLoop = 0
    private var isCardWillClose: Bool = true
    
    private let colors = [0x231FE4, 0x00BFB6, 0xFFC43D, 0xFF5F3D, 0xF34766]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fanMenu.button = mainButton(colorHex: 0x7C93FE)
        fanMenu.items = colors.enumerated().map { (index,item) in
            FanMenuButton(
                id: String(index), image: "", color: Color(val: item)
            )
        }
        fanMenu.menuRadius = 20.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi, 2 * Double.pi)
        fanMenu.radius = 15.0
        
        fanMenu.onItemWillClick = { button in
            if button.id != "main" {
                let newColor = self.colors[Int(button.id)!]
                let fanGroup = self.fanMenu.node as? Group
                let circleGroup = fanGroup?.contents[2] as? Group
                let shape = circleGroup?.contents[0] as? Shape
                shape?.fill = Color(val: newColor)
            }
        }
        fanMenu.transform = CGAffineTransform(rotationAngle: CGFloat(3 * Double.pi/2.0))
        
        self.setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.hideNavigationBar(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Move to the middle of the card list
        self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow()/2, section: 0),
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
            self.flipCard(at: 26)
          
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
        guard let cellCenter = self.clCard.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCell else {
            // Fix crash for small screen
            self.isCardWillClose = false
            return
        }
        
        if self.isCardWillClose {
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromRight, animations: {
                cellCenter.imgCard.image = UIImage(named: "Card_Back")
            }, completion: nil)
            self.isCardWillClose = false
        } else {
            let cardRandom = self.playVM.getCard(at: self.playVM.randomIndexCard())
            UIView.transition(with: cellCenter, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                cellCenter.imgCard.image = cardRandom?.image
            }, completion: nil)
            self.isCardWillClose = true
        }
    }
    
    func mainButton(colorHex: Int) -> FanMenuButton {
        return FanMenuButton(
            id: "main",
            image: "",
            color: Color(val: colorHex)
        )
    }
    
    // MARK: - Action
    @IBAction func onClickGoToModeSelectionVC(_ sender: Any) {
        self.isCardWillClose = true
        self.flipCard(at: 26)
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        self.btnMode.isHidden = true
        self.btnPlay.isHidden = true
        self.isCardWillClose = true
        self.flipCard(at: 26)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            // Move to the middle of the card list
            self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow()/2, section: 0),
                                     at: .centeredHorizontally,
                                     animated: false)
            
            self.countLoop = 0
            self.configAutoscrollTimer()
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


