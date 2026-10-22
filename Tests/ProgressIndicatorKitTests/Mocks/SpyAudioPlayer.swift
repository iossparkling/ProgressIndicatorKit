//
//  SpyAudioPlayer.swift
//  ProgressIndicatorKit
//

import Foundation
import ProgressIndicatorKit

/// Records calls instead of playing sound, so playback decisions can be tested.
final class SpyAudioPlayer: BackgroundAudioPlayable {
    private(set) var playedURLs: [URL] = []
    private(set) var stopCount = 0

    func play(from url: URL) {
        playedURLs.append(url)
    }

    func stop() {
        stopCount += 1
    }
}
