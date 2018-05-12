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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Move to the middle of the card list
        self.clCard.scrollToItem(at: IndexPath(row: self.playVM.cellRow() / 2, section: 0),
                                 at: .centeredHorizontally,
                                 animated: false)
        
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
        
        let sliderLayout = GravitySliderFlowLayout(with: CGSize(width: 200, height: 300))
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
        } else if self.countLoop == 1320 {
            self.deconfigAutoscrollTimer()
            self.btnPlay.isHidden = false
            DispatchQueue.main.async {
                //time popup appear
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.popupActionSheet), userInfo: nil, repeats: false)
                
            }
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
    
    //popup ActionSheet to select record or snapshot
    @objc func popupActionSheet() {
        let picker = UIImagePickerController()
        picker.delegate = self
        AlertHelper.showActionSheet(on: self, title: "Save This Moment", message: nil, firstButton: "Snapshot", firstComplete: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.present(picker,animated: true,completion: nil)
            } else {
                Log.error("Camera is not available")
            }
        }, secondButton: "Short Video", secondComplete: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.videoMaximumDuration = 5
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = false
                picker.showsCameraControls = true
                self.present(picker,animated: true,completion: nil)
            } else {
                Log.error("Camera is not available")
            }
        }, thirdButton: nil, thirdComplete: nil)
    }
    
    
    // MARK: - Action
    @IBAction func onClickGoToModeSelectionVC(_ sender: Any) {
        self.navigationController?.pushViewController(DestinationView.modeSelectionVC(), animated: true)
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
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

extension PlayVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
