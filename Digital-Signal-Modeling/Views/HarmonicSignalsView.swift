//
//  HarmonicSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct HarmonicSignalsView: View {
    
    @State private var signal: HarmonicSignal = HarmonicSignal.createSine(amplitude: 1, startPhase: 0, frequency: 1)
    
    var body: some View {
        ScrollView {
            VStack {
                SignalChart(signal: signal, title: "Harmonic")
                    .padding(.top, 10)
                
                HarmonicSignalCreator(signal: $signal)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
