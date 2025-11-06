//
//  MockProgressProvider.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import Foundation
import ProgressIndicatorKit

public struct MockProgressProvider: ProgressMessageProvider {
    public var messages: [String]
    public init(messages: [String] = ["Mocking...", "Testing..."]) {
        self.messages = messages
    }
}
