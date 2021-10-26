//
//  SignalChart.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct SignalChart: View {
    let count: Int = 4096
    
    let signal: Signal
    let title: String?
    let compact: Bool
    var buttons: [HoldableButton]
    
    init(signal: Signal, title: String?, compact: Bool = false, buttons: [HoldableButton] = []) {
        self.signal = signal
        self.title = title
        self.compact = compact
        self.buttons = buttons
    }
    
    var body: some View {
        ChartLineView(
            data: signal.getValues(count),
            title: title,
            height: compact ? 140 : 200,
            actions: buttons
        )
    }
}


