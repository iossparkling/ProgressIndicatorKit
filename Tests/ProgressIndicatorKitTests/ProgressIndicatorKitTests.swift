//
//  ProgressIndicatorKitTests.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import XCTest
import SwiftUI
import UIKit
@testable import ProgressIndicatorKit

final class ProgressIndicatorKitTests: XCTestCase {

    // MARK: - Message providers

    func testMockProviderReturnsMessages() {
        let mock = MockProgressProvider(messages: ["One", "Two"])
        XCTAssertEqual(mock.messages.count, 2)
        XCTAssertEqual(mock.messages[0], "One")
    }

    func testDefaultProviderHasMessagesWithoutArguments() {
        let provider = DefaultProgressMessageProvider()
        XCTAssertFalse(provider.messages.isEmpty)
    }

    func testDefaultProviderKeepsCustomMessages() {
        let provider = DefaultProgressMessageProvider(messages: ["A"])
        XCTAssertEqual(provider.messages, ["A"])
    }

    // MARK: - MessageRotation

    func testRotationStartsOnFirstMessage() {
        let rotation = MessageRotation()
        XCTAssertEqual(rotation.current(in: ["One", "Two"]), "One")
    }

    func testRotationAdvancesAndWraps() {
        var rotation = MessageRotation()
        let messages = ["One", "Two", "Three"]

        rotation.advance(over: messages)
        XCTAssertEqual(rotation.current(in: messages), "Two")
        rotation.advance(over: messages)
        XCTAssertEqual(rotation.current(in: messages), "Three")
        rotation.advance(over: messages)
        XCTAssertEqual(rotation.current(in: messages), "One")
    }

    func testRotationWithNoMessagesDoesNotCrash() {
        var rotation = MessageRotation()
        XCTAssertNil(rotation.current(in: []))
        rotation.advance(over: [])
        XCTAssertNil(rotation.current(in: []))
        XCTAssertEqual(rotation.index, 0)
    }

    func testRotationSurvivesListShrinking() {
        var rotation = MessageRotation()
        let long = ["One", "Two", "Three"]
        rotation.advance(over: long)
        rotation.advance(over: long)   // index 2

        let short = ["Only"]
        XCTAssertEqual(rotation.current(in: short), "Only")
        rotation.advance(over: short)
        XCTAssertEqual(rotation.current(in: short), "Only")
    }

    func testRotationWithSingleMessageStaysPut() {
        var rotation = MessageRotation()
        rotation.advance(over: ["Only"])
        XCTAssertEqual(rotation.current(in: ["Only"]), "Only")
    }

    // MARK: - Color(hex:)

    func testHexWithHashParses() {
        let components = rgb(of: Color(hex: "#99AABB"))
        XCTAssertEqual(components.red, 0x99 / 255, accuracy: 0.01)
        XCTAssertEqual(components.green, 0xAA / 255, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0xBB / 255, accuracy: 0.01)
    }

    func testHexWithoutHashAndWithSpacesParses() {
        let components = rgb(of: Color(hex: " CCDDEE "))
        XCTAssertEqual(components.red, 0xCC / 255, accuracy: 0.01)
        XCTAssertEqual(components.green, 0xDD / 255, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0xEE / 255, accuracy: 0.01)
    }

    func testInvalidHexIsBlack() {
        let components = rgb(of: Color(hex: "not a color"))
        XCTAssertEqual(components.red, 0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0, accuracy: 0.01)
    }

    // MARK: - AudioPlaybackControl

    private let soundURL = URL(fileURLWithPath: "/tmp/sound.mp3")

    func testPlaysWhenVisibleAndEnabled() {
        let spy = SpyAudioPlayer()
        let control = AudioPlaybackControl(player: spy, url: soundURL)

        control.update(isVisible: true, shouldPlay: true)

        XCTAssertEqual(spy.playedURLs, [soundURL])
        XCTAssertEqual(spy.stopCount, 0)
    }

    func testStopsWhenViewDisappears() {
        let spy = SpyAudioPlayer()
        let control = AudioPlaybackControl(player: spy, url: soundURL)

        control.update(isVisible: false, shouldPlay: true)

        XCTAssertTrue(spy.playedURLs.isEmpty)
        XCTAssertEqual(spy.stopCount, 1)
    }

    func testStopsWhenAudioTurnedOffWhileVisible() {
        let spy = SpyAudioPlayer()
        let control = AudioPlaybackControl(player: spy, url: soundURL)

        control.update(isVisible: true, shouldPlay: false)

        XCTAssertTrue(spy.playedURLs.isEmpty)
        XCTAssertEqual(spy.stopCount, 1)
    }

    func testDoesNotPlayWithoutURL() {
        let spy = SpyAudioPlayer()
        let control = AudioPlaybackControl(player: spy, url: nil)

        control.update(isVisible: true, shouldPlay: true)

        XCTAssertTrue(spy.playedURLs.isEmpty)
    }

    func testMissingPlayerIsSafe() {
        let control = AudioPlaybackControl(player: nil, url: soundURL)
        control.update(isVisible: true, shouldPlay: true)
        control.update(isVisible: false, shouldPlay: true)
    }

    // MARK: - Bundled audio

    func testBundledAudioIsFound() {
        XCTAssertNotNil(ProgressIndicatorAudio.defaultURL)
    }

    // MARK: - Helpers

    private func rgb(of color: Color) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue)
    }
}
