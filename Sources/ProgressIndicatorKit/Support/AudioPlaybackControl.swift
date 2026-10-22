//
//  AudioPlaybackControl.swift
//  ProgressIndicatorKit
//

import Foundation

/// Decides when the audio player should play or stop, so the view holds no such logic.
struct AudioPlaybackControl {

    let player: BackgroundAudioPlayable?
    let url: URL?

    /// Plays only while the view is visible and playback is wanted; stops in every other case.
    /// Stopping when nothing is playing is harmless.
    func update(isVisible: Bool, shouldPlay: Bool) {
        guard isVisible, shouldPlay, let url else {
            player?.stop()
            return
        }
        player?.play(from: url)
    }
}
