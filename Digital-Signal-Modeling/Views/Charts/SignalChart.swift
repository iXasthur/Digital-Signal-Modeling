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
    let hideLabels: Bool
    let buttons: [[HoldableButton]]
    
    init(signal: BaseSignal, title: String?, compact: Bool = false, hideLabels: Bool = false, buttons: [[HoldableButton]] = [], count: Int) {
        self.count = count
        self.signal = signal
        self.title = title
        self.compact = compact
        self.hideLabels = hideLabels
        self.buttons = buttons
    }
    
    var body: some View {
        ChartLineView(
            values: signal.getValues(count),
            title: title,
            compact: compact,
            hideLabels: hideLabels,
            buttons: buttons
        )
    }
}


