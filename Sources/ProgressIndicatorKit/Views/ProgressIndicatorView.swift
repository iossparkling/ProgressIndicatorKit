//
//  ProgressIndicatorView.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import SwiftUI
import UIKit

public struct ProgressIndicatorView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isJumping = false
    @State private var colorIndex = 0
    @State private var rotation = MessageRotation()

    private let colors: [Color] = [Color(hex: "99AABB"), Color(hex: "CCDDEE")]
    private let animationDuration: Double = 0.3
    private let circleSize: CGFloat = 12
    private let messageInterval: Double = 3.0

    private let messageProvider: ProgressMessageProvider

    public init(messageProvider: ProgressMessageProvider) {
        self.messageProvider = messageProvider
    }

    public var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.0))
                    .frame(width: 60, height: 35)

                HStack(spacing: 2) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(colors[colorIndex])
                            .frame(width: circleSize, height: circleSize)
                            .offset(y: isJumping ? -10 : 0)
                            .animation(animation(for: index), value: isJumping)
                    }
                }
            }

            if let message = currentMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.updatesFrequently)
        // Starts when the view appears and is cancelled automatically when it disappears.
        .task { await runIndicator() }
    }

    // MARK: - State

    private var currentMessage: String? {
        rotation.current(in: messageProvider.messages)
    }

    private var accessibilityText: Text {
        if let currentMessage {
            return Text(verbatim: currentMessage)
        }
        return Text("Loading")
    }

    private var shouldReduceMotion: Bool {
        reduceMotion || ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    // MARK: - Animation loop

    @MainActor
    private func runIndicator() async {
        await bounce()

        while !Task.isCancelled {
            do {
                try await Task.sleep(nanoseconds: nanoseconds(messageInterval))
            } catch {
                return
            }

            rotation.advance(over: messageProvider.messages)
            announceCurrentMessage()
            await bounce()
        }
    }

    /// One hop of the dots, followed by the colour change. With Reduce Motion
    /// or Low Power Mode on, only the colour changes.
    @MainActor
    private func bounce() async {
        if shouldReduceMotion {
            colorIndex = (colorIndex + 1) % colors.count
            return
        }

        withAnimation {
            isJumping = true
        }

        do {
            try await Task.sleep(nanoseconds: nanoseconds(animationDuration / 2))
        } catch {
            isJumping = false
            return
        }
        isJumping = false

        do {
            try await Task.sleep(nanoseconds: nanoseconds(animationDuration / 2))
        } catch {
            return
        }
        colorIndex = (colorIndex + 1) % colors.count
    }

    /// Tells VoiceOver users when the message changes. Does nothing when VoiceOver is off.
    @MainActor
    private func announceCurrentMessage() {
        guard UIAccessibility.isVoiceOverRunning, let message = currentMessage else { return }
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    private func nanoseconds(_ seconds: Double) -> UInt64 {
        UInt64(seconds * 1_000_000_000)
    }

    private func animation(for index: Int) -> Animation {
        .easeInOut(duration: animationDuration)
        .repeatCount(1, autoreverses: true)
        .delay(Double(index) * 0.2)
    }
}
