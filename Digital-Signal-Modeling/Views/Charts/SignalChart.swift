//
//  SignalChart.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct SignalChart: View {
    let count: Int
    
    let signal: BaseSignal
    let title: String?
    let compact: Bool
    var buttons: [HoldableButton]
    
    init(signal: BaseSignal, title: String?, compact: Bool = false, buttons: [HoldableButton] = [], count: Int) {
        self.count = count
        self.signal = signal
        self.title = title
        self.compact = compact
        self.buttons = buttons
    }
    
    var body: some View {
        ChartLineView(
            values: signal.getValues(count),
            title: title,
            compact: compact,
            buttons: buttons
        )
    }
}


