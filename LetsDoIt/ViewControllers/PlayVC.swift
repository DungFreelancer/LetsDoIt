//
//  PlayVC.swift
//  LetsDoIt
//
//  Created by Dung Do on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import GravitySliderFlowLayout

class PlayVC: BaseVC {
    
    @IBOutlet weak var clCard: UICollectionView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    let playVM = PlayVM()
    private var timr = Timer()
    private var w: CGFloat = 0.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideNavigationBar(true)
        
        self.setUpCollectionView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private method
    func setUpCollectionView() {
        self.clCard.register(UINib(nibName: CardCell.nibName, bundle: nil), forCellWithReuseIdentifier: CardCell.cellID)
        self.clCard.dataSource = self
        self.clCard.delegate = self
        
        let sliderLayout = GravitySliderFlowLayout(with: CGSize(width: 200, height: 300))
        self.clCard.collectionViewLayout = sliderLayout
    }
    
    // MARK: - Action
    
    @IBAction func onClickGoToModeSelectionVC(_ sender: Any) {
        self.navigationController?.pushViewController(DestinationView.modeSelectionVC(), animated: true)
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        configAutoscrollTimer()
        self.btnPlay.isHidden = true
        self.btnStop.isHidden = false
    }
    
    @IBAction func onClickStop(_ sender: Any) {
        deconfigAutoscrollTimer()
        self.btnStop.isHidden = true
        self.btnPlay.isHidden = false
    }
    
    // way cham.
    func configAutoscrollTimer()
    {
        timr = Timer.scheduledTimer(timeInterval: -0.01, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
    }
    
    func deconfigAutoscrollTimer()
    {
        timr.invalidate()
    }
    
    func onTimer()
    {
        autoScrollView()
    }
    
    @objc func autoScrollView()
    {
        let initailPoint = CGPoint(x: w,y :0)
        
        if __CGPointEqualToPoint(initailPoint, clCard.contentOffset)
        {
            if w < clCard.contentSize.width
            {
                w += 0.5
            }
            else
            {
                w = -self.view.frame.size.width
            }
            
            let offsetPoint = CGPoint(x: w,y :0)
            
            clCard.contentOffset=offsetPoint
        }
        else
        {
            w = clCard.contentOffset.x
        }
    }
    
    /* cai' nay la way le.
    //    let kAutoScrollDuration: CGFloat = 1
    //
    //    func startTimer() {
    //        let timer = Timer.scheduledTimer(timeInterval: TimeInterval(kAutoScrollDuration), target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    //        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    //    }
    
    
    //    @objc func scrollToNextCell(){
    //
    //        //get cell size
    //        let cellSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    //
    //
    //        //get current content Offset of the Collection view
    //        let contentOffset = collectionView.contentOffset
    //
    //
    //        if collectionView.contentSize.width <= collectionView.contentOffset.x + cellSize.width
    //        {
    //            collectionView.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    //            collectionView.alpha = 2
    //
    //        } else {
    //            collectionView.scrollRectToVisible(CGRect(x:contentOffset.x + cellSize.width,y: contentOffset.y,width: cellSize.width,height: cellSize.height), animated: true);
    //            collectionView.alpha = 2
    //
    //        }
    //
    //    }
    
    
    */
    
}

extension PlayVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.playVM.cellRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.playVM.cellInstance(collectionView: collectionView, indexPath: indexPath)
    }
    
}
