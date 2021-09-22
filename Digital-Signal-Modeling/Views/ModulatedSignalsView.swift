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
        VStack {
            SignalChart(signal: signal)
                .padding(.top, 10)
            
            Spacer()
        }
    }
}
