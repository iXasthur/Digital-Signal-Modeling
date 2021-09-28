//
//  ModulatedSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 22.09.2021.
//

import Foundation

struct ModulatedSignal: Signal {
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
        
        
//        let messageValues: [Double] = message.getValues(count)
//
//        var values: [Double] = []
//        for n in 0..<count {
//            let t = Double(n) / Double(count)
//
//            var s = carrier
//            s.frequency = s.frequency! + (s.frequency! / 8.0 * messageValues[n] / message.amplitude!)
//            let phase = 2.0 * Double.pi * s.frequency! * t + s.startPhase!
//            let y = s.getValue(phase: phase)
//            print("\(n): msg:\(messageValues[n]) frequency:\(s.frequency!) phase:\(phase) y:\(y)")
//
//            values.append(y)
//        }
//        return values
        
//        let messageValues: [Double] = message.getValues(count)
//
//        var values: [Double] = []
//        for n in 0..<count {
//            let t = Double(n) / Double(count)
//
//            let simpson = { () -> Double in
//                let a0 = t / 8
//                let s0 = messageValues[0]
//                let s1 = 3 * messageValues[Int((Double(n)/3).rounded())]
//                let s2 = messageValues[Int((2*Double(n)/3).rounded())]
//                let s3 = messageValues[n]
//                return a0 * (s0 + s1 + s2 + s3)
//            }
//
//            let phase = 2.0 * Double.pi * carrier.frequency! * t + 2.0 * Double.pi * 5 * simpson()
//            let y = carrier.getValue(phase: phase)
//
//            values.append(y)
//        }
//        return values
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
