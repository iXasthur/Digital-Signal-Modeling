//
//  ColorExtensions.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

extension Color {
    #if os(macOS)
    static let backgroundColor = Color(NSColor.windowBackgroundColor)
    static let secondaryBackgroundColor = Color(NSColor.controlBackgroundColor)
    #else
    static let backgroundColor = Color(UIColor.systemBackground)
    static let secondaryBackgroundColor = Color(UIColor.secondarySystemBackground)
    #endif
}
