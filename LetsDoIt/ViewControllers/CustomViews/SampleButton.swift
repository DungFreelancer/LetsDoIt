//
//  SampleButton.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 7/12/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit
import AVFoundation

class SampleButton: UIButton {
    
    var audioPlayer = AVAudioPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playSound(name: String, type: String = "mp3") {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: type)!)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch { }
    }
    
}
