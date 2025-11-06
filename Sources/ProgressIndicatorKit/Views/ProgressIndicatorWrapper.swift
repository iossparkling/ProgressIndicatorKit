//
//  ProgressIndicatorWrapper.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//


import SwiftUI
import AVFoundation

public struct ProgressIndicatorWrapper: View {
    private let messageProvider: ProgressMessageProvider
    private let audioPlayer: BackgroundAudioPlayable?
    private let audioURL: URL?
    private let shouldPlayAudio: Bool
 
    public init(
        messageProvider: ProgressMessageProvider,
        audioPlayer: BackgroundAudioPlayable?,
        audioURL: URL?,
        shouldPlayAudio: Bool
    ) {
        self.messageProvider = messageProvider
        self.audioPlayer = audioPlayer
        self.audioURL = audioURL
        self.shouldPlayAudio = shouldPlayAudio
    }
 
    public var body: some View {
        ProgressIndicatorView(messageProvider: messageProvider)
            .onAppear {
                if shouldPlayAudio, let url = audioURL {
                    audioPlayer?.play(from: url)
                }
            }
            .onDisappear {
                if shouldPlayAudio {
                    audioPlayer?.stop()
                }
            }
    }
}
