//
//  DefaultProgressMessageProvider.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import Foundation

/// A simple provider that hands back a fixed list of messages.
public final class DefaultProgressMessageProvider: ProgressMessageProvider {

    /// Used when no messages are passed in.
    public static let defaultMessages = ["Loading...", "Please wait...", "Almost there..."]

    public let messages: [String]

    public init(messages: [String] = DefaultProgressMessageProvider.defaultMessages) {
        self.messages = messages
    }
}
