//
//  HarmonicSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import Foundation

struct HarmonicSignal: Signal {
    var name: String = "Harmonic signal"
    
    var type: SignalType
    
    var amplitude: Double?
    var startPhase: Double?
    var frequency: Double?
    var duty: Double?
    
    var formula: (_ s: HarmonicSignal, _ t: Double) -> Double
    
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
    
    static func createDefault() -> HarmonicSignal {
        return HarmonicSignal(
            type: .def,
            formula: { (_: HarmonicSignal, t: Double) -> Double in
                return t
            }
        )
    }
    
    static func createSine(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let name = "Sine (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            type: .sine,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: HarmonicSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                return amplitude * sin((2 * Double.pi * frequency * t) + startPhase)
            })
    }
    
    static func createImpulse(amplitude: Double, startPhase: Double, frequency: Double, duty: Double) -> HarmonicSignal {
        let name = "Impulse (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)), d: \(String(format: "%.2f", duty)))"
        
        let duty = 2 * Double.pi * duty
        
        return HarmonicSignal(
            name: name,
            type: .impulse,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            duty: duty,
            formula: { (signal: HarmonicSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                let duty: Double = signal.duty!
                
                let phase = (startPhase + 2 * Double.pi * t * frequency).truncatingRemainder(dividingBy: 2 * Double.pi)
                return phase <= duty ? amplitude : -amplitude
            })
    }
    
    static func createTriangle(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let name = "Triangle (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            type: .triangle,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: HarmonicSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                let v0 = 2 * amplitude / Double.pi
                let v1 = asin(sin(2 * Double.pi / (1 / frequency) * t + startPhase))
                return v0 * v1
            })
    }
    
    static func createSaw(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let name = "Saw (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            type: .saw,
            amplitude: amplitude,
            startPhase: startPhase,
            frequency: frequency,
            formula: { (signal: HarmonicSignal, t: Double) -> Double in
                let frequency: Double = signal.frequency!
                let amplitude: Double = signal.amplitude!
                let startPhase: Double = signal.startPhase!
                
                let v0 = 2 * amplitude / Double.pi
                let v1 = atan(tan(Double.pi * t / (1 / frequency) + startPhase/2))
                return v0 * v1
            })
    }
    
    static func createNoise(amplitude: Double) -> HarmonicSignal {
        let name = "Noise (a: \(String(format: "%.2f", amplitude)))"
        
        return HarmonicSignal(
            name: name,
            type: .noise,
            amplitude: amplitude,
            formula: { (signal: HarmonicSignal, t: Double) -> Double in
                let amplitude: Double = signal.amplitude!
                return Double.random(in: -amplitude...amplitude)
            })
    }
}
