//
//  ModulatedSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 22.09.2021.
//

import SwiftUI

struct ModulatedSignalsView: View {
    
    @State private var signal: ModulatedSignal = ModulatedSignal()
    
    var body: some View {
        ScrollView {
            VStack {
                SignalChart(signal: signal.message, title: "Message")
                    .padding(.top, 10)
                
                HarmonicSignalCreator(signal: $signal.message)
                    .padding(.top, 10)
                
                SignalChart(signal: signal.carrier, title: "Carrier")
                    .padding(.top, 20)
                
                HarmonicSignalCreator(signal: $signal.carrier)
                    .padding(.top, 10)
                
                Picker("Modulation type", selection: $signal.type) {
                    ForEach(ModulatedSignal.ModulationType.allCases) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 10)
                
                SignalChart(signal: signal, title: "Modulated")
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
