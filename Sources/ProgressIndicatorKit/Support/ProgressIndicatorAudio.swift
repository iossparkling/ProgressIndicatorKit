//
//  ProgressIndicatorAudio.swift
//  ProgressIndicatorKit
//

import Foundation

/// Access to the audio file that ships inside the package.
public enum ProgressIndicatorAudio {

    /// The looping sound bundled with ProgressIndicatorKit, or `nil` if it is missing.
    public static var defaultURL: URL? {
        Bundle.module.url(forResource: "background", withExtension: "mp3")
    }
}
