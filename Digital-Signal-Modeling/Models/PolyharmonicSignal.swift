//
//  PolyharmonicSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import Foundation

struct PolyharmonicSignal: Signal {
    var name: String = "Polyharmonic signal"
    
    var signals: [HarmonicSignal] = []
    
    func getValues(_ count: Int) -> [Double] {
        if signals.isEmpty {
            return []
        }
        
        var signalValues: [[Double]] = .init()
        signals.forEach { signal in
            signalValues.append(signal.getValues(count))
        }
        
        var values: [Double] = []
        for n in 0..<count {
            var v: Double = 0
            signalValues.forEach { sv in
                v = v + sv[n]
            }
            values.append(v)
        }
        
        return values
    }
}
