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
                SignalChartEx(signal: signal.message, title: "Message", compact: true)
                    .padding(.top, 10)
                
                SingleVoiceSignalCreator(signal: $signal.message, compact: true)
                    .padding(.top, 10)
                
                SignalChartEx(signal: signal.carrier, title: "Carrier", compact: true)
                    .padding(.top, 20)
                
                SingleVoiceSignalCreator(signal: $signal.carrier, compact: true)
                    .padding(.top, 10)
                
                Picker("Modulation type", selection: $signal.type) {
                    ForEach(ModulatedSignal.ModulationType.allCases) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 10)
                
                SignalChartEx(signal: signal, title: "Modulated", compact: true)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
