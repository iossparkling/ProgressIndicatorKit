//
//  ProgressIndicatorWrapper.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import SwiftUI

/// Shows a `ProgressIndicatorView` and plays a looping sound while it is on screen.
public struct ProgressIndicatorWrapper: View {
    @State private var isVisible = false

    private let messageProvider: ProgressMessageProvider
    private let shouldPlayAudio: Bool
    private let playback: AudioPlaybackControl

    /// - Parameters:
    ///   - messageProvider: Supplies the messages shown next to the dots.
    ///   - audioPlayer: Plays the sound. Keep one instance alive in the caller and pass it in.
    ///   - audioURL: The sound to loop. Defaults to the file bundled with the package.
    ///   - shouldPlayAudio: Turn audio on or off. Changes take effect while the view is showing.
    public init(
        messageProvider: ProgressMessageProvider,
        audioPlayer: BackgroundAudioPlayable?,
        audioURL: URL? = ProgressIndicatorAudio.defaultURL,
        shouldPlayAudio: Bool
    ) {
        self.messageProvider = messageProvider
        self.shouldPlayAudio = shouldPlayAudio
        self.playback = AudioPlaybackControl(player: audioPlayer, url: audioURL)
    }

    public var body: some View {
        ProgressIndicatorView(messageProvider: messageProvider)
            .onAppear {
                isVisible = true
                playback.update(isVisible: true, shouldPlay: shouldPlayAudio)
            }
            .onDisappear {
                isVisible = false
                playback.update(isVisible: false, shouldPlay: shouldPlayAudio)
            }
            .onChange(of: shouldPlayAudio) { newValue in
                playback.update(isVisible: isVisible, shouldPlay: newValue)
            }
    }
}
