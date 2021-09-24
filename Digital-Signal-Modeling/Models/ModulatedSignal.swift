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
    
    let type: ModulationType = .frequency
    
    let message: HarmonicSignal = HarmonicSignal.createSine(amplitude: 1, startPhase: 0, frequency: 3)
    let carrier: HarmonicSignal = HarmonicSignal.createSine(amplitude: 1, startPhase: 0, frequency: 18)
    
    private func getValuesFM(_ count: Int) -> [Double] {
        let messageValues: [Double] = message.getValues(count)
        
        var values: [Double] = []
        for n in 0..<count {
            let t = Double(n) / Double(count)
            
            var s = carrier
            s.frequency = s.frequency! + (s.frequency! / 8.0 * messageValues[n] / message.amplitude!)
            let phase = 2.0 * Double.pi * s.frequency! * t
            let y = s.getValue(phase: phase)
            print("\(n): msg:\(messageValues[n]) frequency:\(s.frequency!) phase:\(phase) y:\(y)")
            
            values.append(y)
        }
        return values
    }
    
    private func getValuesAM(_ count: Int) -> [Double] {
        let messageValues: [Double] = message.getValues(count)
        let carrierValues: [Double] = carrier.getValues(count)
        var values: [Double] = []
        for n in 0..<count {
            let v = (1 + messageValues[n] / message.amplitude!) * carrierValues[n]
            values.append(v)
        }
        return values
    }
    
    func getValues(_ count: Int) -> [Double] {
        switch type {
        case .amplitude:
            return getValuesAM(count)
        case .frequency:
            return getValuesFM(count)
        }
    }
}
