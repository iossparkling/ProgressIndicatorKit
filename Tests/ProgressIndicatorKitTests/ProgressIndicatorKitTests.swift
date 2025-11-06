//
//  ProgressIndicatorKitTests.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import XCTest
@testable import ProgressIndicatorKit

final class ProgressIndicatorKitTests: XCTestCase {
    func testMockProviderReturnsMessages() {
        let mock = MockProgressProvider(messages: ["One", "Two"])
        XCTAssertEqual(mock.messages.count, 2)
        XCTAssertEqual(mock.messages[0], "One")
    }
}
