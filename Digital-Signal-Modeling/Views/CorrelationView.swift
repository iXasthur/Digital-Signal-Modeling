//
//  CorrelationView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import SwiftUI

struct CorrelationView: View {
    
    let count = 4096
    
    @State private var signal0: SingleVoiceSignal? = .createSine(amplitude: 1, startPhase: 0, frequency: 1)
    @State private var signal1: SingleVoiceSignal? = .createSine(amplitude: 1, startPhase: 0, frequency: 39)
    
    var signalValuesForCorrelation: (vs0: [Double], vs1: [Double]) {
        var va0: [Double] = []
        var va1: [Double] = []
        
        if signal0 != nil && signal1 != nil {
            va0 = signal0!.getValues(count)
            va1 = signal1!.getValues(count)
        } else if signal0 != nil {
            va0 = signal0!.getValues(count)
            va1 = signal0!.getValues(count)
        } else if signal1 != nil {
            va0 = signal1!.getValues(count)
            va1 = signal1!.getValues(count)
        }
        
        return (va0, va1)
    }
    
    var body: some View {
        let vs = signalValuesForCorrelation
        let correlationDataP = CorrelationDataP(signal0: vs.vs0, signal1: vs.vs1)
        let correlationDataF = CorrelationDataF(signal0: vs.vs0, signal1: vs.vs1)
        
        return ScrollView {
            VStack {
                SignalChartExE(signal: $signal0, count: count, title: "First", compact: true)
                    .padding(.top, 10)
                SignalChartExE(signal: $signal1, count: count, title: "Second", compact: true)
                    .padding(.top, 10)
                ChartLineView(values: correlationDataP.getValues(), title: "Correlation Plain (t: \(correlationDataP.getTimeMs())ms)", compact: true)
                    .padding(.top, 10)
                ChartLineView(values: correlationDataF.getValues(), title: "Correlation Fast (t: \(correlationDataF.getTimeMs())ms)", compact: true)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
