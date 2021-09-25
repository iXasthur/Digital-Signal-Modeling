//
//  PolyharmonicSignalsView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

struct PolyharmonicSignalsView: View {
    
    @State private var signal: PolyharmonicSignal = PolyharmonicSignal()
    
    var body: some View {
        ScrollView {
            VStack {
                SignalChart(signal: signal, title: "Polyharmonic")
                    .padding(.top, 10)
                
                PolyharmonicSignalCreator(signal: $signal)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
