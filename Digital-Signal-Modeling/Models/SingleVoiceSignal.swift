//
//  SingleVoiceSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import Foundation

enum SingleVoiceSignalType: String, CaseIterable, Identifiable {
    case sine
    case pulse
    case triangle
    case saw
    case noise
    case def

    var id: String { self.rawValue }
}

struct SingleVoiceSignal: BaseSignal {
    var name: String = "Single voice signal"
    
    var type: SingleVoiceSignalType
    
    var amplitude: Double?
    var startPhase: Double?
    var frequency: Double?
    var duty: Double?
    
    var formula: (_ s: SingleVoiceSignal, _ t: Double) -> Double
    
    func getValues(_ count: Int) -> [Double] {
        var values: [Double] = []
        for n in 0..<count {
            let t = Double(n) / Double(count)
            values.append(formula(self, t))
        }
        return values
    }
    
    func getValue(phase: Double) -> Double {
        var s = self
        s.startPhase = phase
        return formula(s, 0)
    }
    
    static func createDefault() -> SingleVoiceSignal {
        return SingleVoiceSignal(
            type: .def,
            formula: { (_: SingleVoiceSignal, t: Double) -> Double in
                return t
            }
        )
    }
    
    static func createSine(amplitude: Double, startPhase: Double, frequency: Double) -> SingleVoiceSignal {
        let name = "Sine (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return SingleVoiceSignal(
            name: name,
            type: .sine,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: SingleVoiceSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                return amplitude * sin((2 * Double.pi * frequency * t) + startPhase)
            })
    }
    
    static func createImpulse(amplitude: Double, startPhase: Double, frequency: Double, duty: Double) -> SingleVoiceSignal {
        let name = "Impulse (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)), d: \(String(format: "%.2f", duty)))"
        
        let duty = 2 * Double.pi * duty
        
        return SingleVoiceSignal(
            name: name,
            type: .pulse,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            duty: duty,
            formula: { (signal: SingleVoiceSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                let duty: Double = signal.duty!
                
                let phase = (startPhase + 2 * Double.pi * t * frequency).truncatingRemainder(dividingBy: 2 * Double.pi)
                return phase <= duty ? amplitude : -amplitude
            })
    }
    
    static func createTriangle(amplitude: Double, startPhase: Double, frequency: Double) -> SingleVoiceSignal {
        let name = "Triangle (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return SingleVoiceSignal(
            name: name,
            type: .triangle,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: SingleVoiceSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                let v0 = 2 * amplitude / Double.pi
                let v1 = asin(sin(2 * Double.pi / (1 / frequency) * t + startPhase))
                return v0 * v1
            })
    }
    
    static func createSaw(amplitude: Double, startPhase: Double, frequency: Double) -> SingleVoiceSignal {
        let name = "Saw (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return SingleVoiceSignal(
            name: name,
            type: .saw,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: SingleVoiceSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                let v0 = 2 * amplitude / Double.pi
                let v1 = atan(tan(Double.pi * t / (1 / frequency) + startPhase/2))
                return v0 * v1
            })
    }
    
    static func createNoise(amplitude: Double) -> SingleVoiceSignal {
        let name = "Noise (a: \(String(format: "%.2f", amplitude)))"
        
        return SingleVoiceSignal(
            name: name,
            type: .noise,
            amplitude: amplitude,
            formula: { (signal: SingleVoiceSignal, t: Double) -> Double in
                let amplitude: Double = signal.amplitude!
                return Double.random(in: -amplitude...amplitude)
            })
    }
    
    
}
