//
//  Color+Hex.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import SwiftUI

extension Color {
    /// Creates a color from a 6-digit RGB hex string, with or without a leading `#`.
    /// An invalid string produces black, as before.
    public init(hex: String) {
        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let digits = trimmed.hasPrefix("#") ? String(trimmed.dropFirst()) : trimmed
        let rgb = Scanner(string: digits).scanUInt64(representation: .hexadecimal) ?? 0
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}
