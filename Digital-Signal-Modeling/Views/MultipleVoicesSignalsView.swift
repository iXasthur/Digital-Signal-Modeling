//
//  MultipleVoicesSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct MultipleVoicesSignalsView: View {
    
    @State private var signal: MultipleVoicesSignal = MultipleVoicesSignal()
    
    var sampleSignal: MultipleVoicesSignal {
        var sample = MultipleVoicesSignal()
        sample.signals = [
            SingleVoiceSignal.createSine(amplitude: 1, startPhase: 0, frequency: 1),
            SingleVoiceSignal.createSine(amplitude: 1, startPhase: 0, frequency: 16)
        ]
        return sample
    }
    
    var sampleSignalButton: HoldableButton {
        return HoldableButton(
            icon0: "book",
            icon1: "book.fill",
            onTap: {},
            onRelease: {
                signal = sampleSignal
            }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if signal.signals.isEmpty {
                    SignalChart(signal: signal, title: "Multiple Voices", buttons: [sampleSignalButton])
                        .padding(.top, 10)
                } else {
                    SignalChartEx(signal: signal, title: "Multiple Voices")
                        .padding(.top, 10)
                }
                
                MultipleVoicesSignalCreator(signal: $signal)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
