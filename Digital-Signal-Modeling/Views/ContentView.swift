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
                    "Single Voice",
                    "bolt.horizontal",
                    AnyView(
                        SingleVoiceSignalsView()
                    )
                ),
                (
                    "Multiple Voices",
                    "network",
                    AnyView(
                        MultipleVoicesSignalsView()
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
