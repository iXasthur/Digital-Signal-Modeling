//
//  HarmonicSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import Foundation

struct HarmonicSignal: Signal {
    var name: String = "Harmonic signal"
    
    var formula: (_ count: Int, _ n: Int) -> Double
    
    func getValues(_ count: Int) -> [Double] {
        var values: [Double] = []
        for n in 0..<count {
            values.append(formula(count, n))
        }
        return values
    }
    
    static func createDefault() -> HarmonicSignal {
        return HarmonicSignal(
            formula: { (_: Int, n: Int) -> Double in
                return Double(n)
            }
        )
    }
    
    static func createSine(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let name = "Sine (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                return amplitude * sin((2 * Double.pi * frequency * t) + startPhase)
            })
    }
    
    static func createImpulse(amplitude: Double, startPhase: Double, frequency: Double, duty: Double) -> HarmonicSignal {
        
        let name = "Impulse (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)), d: \(String(format: "%.2f", duty)))"
        
        return HarmonicSignal(
            name: name,
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                let phase = (startPhase + 2 * Double.pi * t * frequency).truncatingRemainder(dividingBy: 2 * Double.pi)
                return phase <= duty ? amplitude : -amplitude
            })
    }
    
    static func createTriangle(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        let name = "Triangle (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = asin(sin(2 * Double.pi / period * t + startPhase))
                return v0 * v1
            })
    }
    
    static func createSaw(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        let name = "Saw (a: \(String(format: "%.2f", amplitude)), p: \(String(format: "%.2f", startPhase)), f: \(String(format: "%.2f", frequency)))"
        
        return HarmonicSignal(
            name: name,
            formula: { (count: Int, n: Int) -> Double in
                let x = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = atan(tan(Double.pi * x / period + startPhase/2))
                return v0 * v1
            })
    }
    
    static func createNoise(amplitude: Double) -> HarmonicSignal {
        let name = "Noise (a: \(String(format: "%.2f", amplitude)))"
        
        return HarmonicSignal(
            name: name,
            formula: { (_: Int, _: Int) -> Double in
                return Double.random(in: -amplitude...amplitude)
            })
    }
}
