//
//  MultipleVoicesSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct MultipleVoicesSignalsView: View {
    
    @State private var signal: MultipleVoicesSignal = MultipleVoicesSignal()
    
    var body: some View {
        ScrollView {
            VStack {
                if signal.signals.isEmpty {
                    SignalChart(signal: signal, title: "Multiple Voices")
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
