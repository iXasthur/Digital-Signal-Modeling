//
//  ModulatedSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 22.09.2021.
//

import Foundation

struct ModulatedSignal: Signal {
    enum ModulationType {
        case amplitude
        case frequency
    }
    
    let name: String = "Modulated signal"
    
    let type: ModulationType = .amplitude
    
    let message: HarmonicSignal = HarmonicSignal.createSine(amplitude: 1, startPhase: 0, frequency: 1)
    let carrier: HarmonicSignal = HarmonicSignal.createSine(amplitude: 1, startPhase: 0, frequency: 10)
    
    func getValues(_ count: Int) -> [Double] {
        let carrierValues: [Double] = carrier.getValues(count)
        let messageValues: [Double] = message.getValues(count)
        var values: [Double] = []
        for n in 0..<count {
            let v = (1 + messageValues[n] / 1) * carrierValues[n]
            values.append(v)
        }
        return values
    }
}
