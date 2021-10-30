//
//  ModulatedSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 22.09.2021.
//

import Foundation

struct ModulatedSignal: BaseSignal {
    enum ModulationType: String, CaseIterable, Identifiable {
        case amplitude
        case frequency
        
        var id: String { self.rawValue }
    }
    
    let name: String = "Modulated signal"
    
    var type: ModulationType = .amplitude
    
    var message: SingleVoiceSignal = SingleVoiceSignal.createSine(amplitude: 1, startPhase: 0, frequency: 4)
    var carrier: SingleVoiceSignal = SingleVoiceSignal.createSine(amplitude: 1, startPhase: 0, frequency: 15)
    
    private func getValuesFM(_ count: Int) -> [Double] {
        var values: [Double] = []
        
        let mf = message.frequency ?? 1
        let cf = carrier.frequency ?? 1

        var messagePhase: Double = message.startPhase ?? 0
        var carrierPhase: Double = carrier.startPhase ?? 0

        for _ in 0..<count {
            values.append(carrier.getValue(phase: carrierPhase))

            let messageValue = self.message.getValue(phase: messagePhase)
            
            messagePhase += 2 * Double.pi * mf / Double(count)

            carrierPhase += 2 * Double.pi * cf * (1 + messageValue) / Double(count)


            if carrierPhase >= 2 * Double.pi {
                carrierPhase -= 2 * Double.pi
            }
            if carrierPhase < 0.0 {
                carrierPhase += 2 * Double.pi
            }
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
