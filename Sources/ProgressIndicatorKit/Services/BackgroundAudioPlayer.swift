//
//  BackgroundAudioPlayer.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//


import AVFoundation

public class BackgroundAudioPlayer: BackgroundAudioPlayable {
    private var player: AVAudioPlayer?
    
    public init() {}
    
    public func play(from url: URL) {
        // Do the heavy lifting (file loading) on background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback)
                try session.setActive(true)
                
                // Load audio data on background thread
                let audioData = try Data(contentsOf: url)
                
                // Create and use AVAudioPlayer on main thread only
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    do {
                        let audioPlayer = try AVAudioPlayer(data: audioData)
                        audioPlayer.prepareToPlay()
                        audioPlayer.numberOfLoops = -1
                        
                        self.player = audioPlayer
                        self.player?.play()
                        print("🔊 Audio playback started")
                    } catch {
                        print("❌ Audio player creation error: \(error.localizedDescription)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("❌ Audio loading error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.player?.stop()
            self?.player = nil
        }
    }
}
