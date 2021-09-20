//
//  SignalChart.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct SignalChart: View {
    
    let count = 256
    
    let signal: Signal
    
    var body: some View {
        ChartLineView(data: signal.getValues(count), title: signal.name)
            .background(Color.blue)
    }
}
