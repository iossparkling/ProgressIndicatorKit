//
//  protocol.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import Foundation

public protocol ProgressMessageProvider {
    var messages: [String] { get }
}

public protocol BackgroundAudioPlayable {
    func play(from url: URL)
    func stop()
}
