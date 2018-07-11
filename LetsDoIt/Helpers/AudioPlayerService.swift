//
//  AudioPlayerService.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 7/11/18.
//  Copyright © 2018 HD. All rights reserved.
//

import AVFoundation


class AudioPlayerService {
    
    static let sharedInstance = AudioPlayerService()
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound(name: String, type: String = "mp3") {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: type)!)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch { }
    }
    
}
