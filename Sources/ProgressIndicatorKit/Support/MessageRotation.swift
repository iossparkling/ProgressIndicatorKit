//
//  MessageRotation.swift
//  ProgressIndicatorKit
//

import Foundation

/// Tracks which progress message is showing. It holds only an index, so it keeps
/// working when the provider's list changes length, and an empty list is safe.
struct MessageRotation: Equatable {

    private(set) var index = 0

    /// The message to show, or `nil` when there are no messages.
    func current(in messages: [String]) -> String? {
        guard !messages.isEmpty else { return nil }
        return messages[min(index, messages.count - 1)]
    }

    /// Moves to the next message and wraps around at the end.
    mutating func advance(over messages: [String]) {
        guard !messages.isEmpty else {
            index = 0
            return
        }
        index = (min(index, messages.count - 1) + 1) % messages.count
    }
}
