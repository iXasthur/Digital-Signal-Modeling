//
//  SingleVoiceSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct SingleVoiceSignalsView: View {
    
    @State private var signal: SingleVoiceSignal = SingleVoiceSignal.createSine(amplitude: 1, startPhase: 0, frequency: 1)
    
    var body: some View {
        ScrollView {
            VStack {
                SignalChart(signal: signal, title: "Single Voice")
                    .padding(.top, 10)
                
                SingleVoiceSignalCreator(signal: $signal)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
