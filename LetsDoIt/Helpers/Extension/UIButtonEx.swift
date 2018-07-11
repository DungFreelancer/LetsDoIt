//
//  UIButtonEx.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 7/11/18.
//  Copyright © 2018 HD. All rights reserved.
//
//
//import UIKit
//import AVFoundation
//
//extension UIButton {
//
//    var audioPlayer:AVAudioPlayer?
//    
//    func onClickWithSound(file:String,offType:String) {
//        let buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: offType)!)
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            UIApplication.shared.beginReceivingRemoteControlEvents()
//
//            audioPlayer = try AVAudioPlayer(contentsOf: buttonSound)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        }catch {
//            print(error)
//        }
//    }
//

//}
