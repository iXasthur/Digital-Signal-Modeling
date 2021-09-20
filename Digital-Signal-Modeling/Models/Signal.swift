//
//  Signal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import Foundation

class Signal {
    var name = "Signal"
    
    var amplitude: Double = 1
    var startPhase: Double = 0
    var frequency: Double = 1
    
    func formula(_ count: Int, _ n: Int) -> Double {
        return amplitude * sin((2 * Double.pi * frequency * Double(n))/Double(count) + startPhase)
    }
    
    func getValues(_ count: Int) -> [Double] {
        var values: [Double] = []
        for n in 0...count {
            values.append(formula(count, n))
        }
        return values
    }
}
