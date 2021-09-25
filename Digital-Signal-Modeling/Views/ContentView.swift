//
//  ContentView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomTabView(
            tabBarPosition: .bottom,
            content: [
                (
                    "Harmonic",
                    "bolt.horizontal",
                    AnyView(
                        HarmonicSignalsView()
                    )
                ),
                (
                    "Polyharmonic",
                    "network",
                    AnyView(
                        PolyharmonicSignalsView()
                    )
                ),
                (
                    "Modulated",
                    "dot.radiowaves.left.and.right",
                    AnyView(
                        ModulatedSignalsView()
                    )
                )
            ]
        )
    }
}
