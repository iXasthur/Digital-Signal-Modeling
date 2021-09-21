//
//  HarmonicSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct HarmonicSignalsView: View {
    
//    @State private var amplitude: Double = 1
//    @State private var startPhase: Double = 0
//    @State private var frequency: Double = 1
    
    @State private var selectedSignalType = SignalType.impulse
    @State private var signal: HarmonicSignal = HarmonicSignal.createDefault()
    
    func updateSignal() {
        print("Updating harmonic signal")
        
        switch selectedSignalType {
        case .sine:
            signal = HarmonicSignal.createSin(amplitude: 1, startPhase: 0, frequency: 1)
        case .impulse:
            signal = HarmonicSignal.createImpulse(amplitude: 1, frequency: 1, duty: 1)
        case .triangle:
            signal = HarmonicSignal.createTriangle(amplitude: 1, frequency: 1)
        case .saw:
            signal = HarmonicSignal.createSaw(amplitude: 1, frequency: 1)
        case .noise:
            signal = HarmonicSignal.createDefault()
        }
    }
    
    var body: some View {
        VStack {
            Picker("Signal Type", selection: $selectedSignalType) {
                ForEach(SignalType.allCases) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedSignalType) { selected in
                updateSignal()
            }
            
            SignalChart(signal: signal)
                .padding(.top, 10)
            
            Spacer()
        }
        .onAppear {
            updateSignal()
        }
    }
}
