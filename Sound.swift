//
//  Sound.swift
//  PlaySound
//
//  Created by Mac on 2020/9/29.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import AVFoundation


class Sound: NSObject {
    static var instance = Sound()
    
    private var soundArray: [String] = Array()
    private var currentSoundIndex = 0
    
    private var player: AVAudioPlayer
    
    private override init() {
        player = AVAudioPlayer()
    }
    
    func playSoundArray(fileNames: [String]) {
        soundArray = fileNames
        currentSoundIndex = 0
        playSound(fileNames.first!)
    }
        
    private func getFileUrl(name: String) -> URL? {
        let url = Bundle.main.url(forResource: name, withExtension: nil)
        return url
    }

    private func playSound(_ fileName: String) {
       let optionalUrl = getFileUrl(name: fileName)
        guard let url = optionalUrl else { return }
        if player.isPlaying { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
        } catch {
            print(error.localizedDescription)
        }
        player.prepareToPlay()
        player.play()
    }
     
}

extension Sound: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            currentSoundIndex += 1
            if currentSoundIndex >= soundArray.count { return }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.playSound(self.soundArray[self.currentSoundIndex])
            }
        }
    }
}
