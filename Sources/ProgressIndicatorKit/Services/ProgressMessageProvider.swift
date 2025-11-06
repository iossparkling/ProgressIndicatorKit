//
//  DefaultProgressMessageProvider.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import Foundation

public class DefaultProgressMessageProvider: ProgressMessageProvider {
    public let messages: [String]
    public init(messages: [String]) {
        self.messages = messages
    }
}
