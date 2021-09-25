//
//  SignalChart.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct SignalChart: View {
    
    private let count = 512
    
    let signal: Signal
    let title: String?
    var compact: Bool = false
    
    var body: some View {
        ChartLineView(data: signal.getValues(count), title: title, height: compact ? 140 : 200)
    }
}
